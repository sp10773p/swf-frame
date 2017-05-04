package kr.pe.frame.openapi.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.KeyGen;
import kr.pe.frame.cmm.util.WebUtil;
import kr.pe.frame.openapi.model.ErrorDescription;
import kr.pe.frame.openapi.model.ResultTypeCode;
import kr.pe.frame.openapi.service.OpenAPIService;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.WebApplicationContext;

import javax.annotation.Resource;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * OPEN API 수신 Controller
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@Controller
@SuppressWarnings({"rawtypes", "unchecked"})
public class OpenApiController implements ApplicationListener<ContextRefreshedEvent> {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "commonService")
    CommonService cService;
    
    @Autowired
    WebApplicationContext webApplicationContext;
    
	@RequestMapping(value = "/api/**")
    public void api(HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setCharacterEncoding(StandardCharsets.UTF_8.toString());
		try{ 
			AccessLogModel accessLogModel = new AccessLogModel();
			
			accessLogModel.setSid(KeyGen.getRandomTimeKey());
			accessLogModel.setSessionId(req.getSession().getId());
			accessLogModel.setLogDiv(Constant.OPEN_API_DIV.getCode());
			accessLogModel.setLoginIp(WebUtil.getClientIp(req));
			accessLogModel.setRmk("접속");
			accessLogModel.setApiKey(req.getHeader(OpenAPIService.API_HEADER_KEY));
			accessLogModel.setUri(req.getRequestURI());
	
			cService.saveAccessLog(accessLogModel);
		} catch(Exception e) {
			logger.error("{} ", e);
		}
		
		String apiId = "";
		String apiKey = "";
		String useId = "";
		Map imParam = null;
        try(ServletInputStream in = req.getInputStream(); ServletOutputStream out = res.getOutputStream();){    	
        	ObjectMapper mapper = new ObjectMapper();
        	
        	Map rtn = new HashMap();
			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.INIT.toString());
			rtn.put(OpenAPIService.ERROR_DESCRIPTION, ErrorDescription.INIT_MESSAGE.toString());
        	try { 
        		apiKey = req.getHeader(OpenAPIService.API_HEADER_KEY);
        		if(StringUtils.isEmpty(apiKey)) {
        			rtn = new HashMap();
        			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNAUTHORIZED.toString());
        			rtn.put(OpenAPIService.ERROR_DESCRIPTION, ErrorDescription.UNAUTHORIZED_REQUEST.toString());
        			
        			return;
        		}
        		
        		AjaxModel aParam = new AjaxModel();
        		Map param = new HashMap();
        		aParam.setData(param);
        		param.put(Constant.QUERY_KEY.getCode(), "openapi.selectApiInfo");
        		param.put("API_URL", req.getRequestURI());
        		
        		AjaxModel rst = cService.select(aParam);
        		if(rst.getData() == null) {
        			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNAUTHORIZED.toString());
        			rtn.put(OpenAPIService.ERROR_DESCRIPTION, ErrorDescription.UNAUTHORIZED_REQUEST.toString());
        			
        			return;
        		}
        		
        		try{ 
        			String inStr = IOUtils.toString(in, StandardCharsets.UTF_8.toString());
        			imParam = mapper.readValue(inStr, HashMap.class);
        			
        			if(imParam == null) {
            			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
            			rtn.put(OpenAPIService.ERROR_DESCRIPTION, ErrorDescription.INVALID_REQUEST_DATA.toString());
            			
            			return;
        			}
        		} catch(Exception e) {
        			logger.error("{} ", e);
        			
        			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
        			rtn.put(OpenAPIService.ERROR_DESCRIPTION, ErrorDescription.INVALID_REQUEST_DATA.toString());
        			
        			return;
        		}
        		
        		OpenAPIService apiService = (OpenAPIService) webApplicationContext.getBean(Class.forName((String)rst.getData().get("CLASS_ID")));
        		
        		apiId = (String)rst.getData().get("API_ID");
        		try { 
        			useId = apiService.isValidClient(apiKey, apiId, imParam);
        		} catch(BizException e) {
        			logger.error("{} ", e);
        			
        			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNAUTHORIZED.toString());
        			rtn.put(OpenAPIService.ERROR_DESCRIPTION, e.getMessage());
        			
        			return;
        		}
        		
        		try { 
        			apiService.checkValidation(apiId, imParam);
        			
        			rtn = apiService.docRecv(apiId, useId, (List<Map>) imParam.get("DocList"));
        		} catch(BizException e) {
        			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
        			rtn.put(OpenAPIService.ERROR_DESCRIPTION, e.getMessage());
        			
        			return;
        		 } finally {
         			param.clear();
         			param.put("API_ID", (String)rst.getData().get("API_ID"));
         			param.put("API_KEY", apiKey);
         			param.put("INC_CNT", "-1");
         			
         			apiService.updateCCUCnt(param);
        		 }
	        } catch(Exception e) {
	        	logger.error("Exception : {} ", e);
	        	
    			rtn.put(OpenAPIService.RESULT_TYPE_CODE, ResultTypeCode.INTERNAL_SERVER_ERROR.toString());
    			rtn.put(OpenAPIService.ERROR_DESCRIPTION, e.getMessage());
	        } finally {
	    		try{ 
	    			AccessLogModel accessLogModel = new AccessLogModel();
	    			
	    			accessLogModel.setSid(KeyGen.getRandomTimeKey());
	    			accessLogModel.setSessionId(req.getSession().getId());
	    			accessLogModel.setLogDiv(Constant.OPEN_API_DIV.getCode());
	    			accessLogModel.setUserId(useId);
	    			accessLogModel.setLoginIp(WebUtil.getClientIp(req));
	    			accessLogModel.setApiId(apiId);
	    			accessLogModel.setApiKey(apiKey);
	    			accessLogModel.setUri(req.getRequestURI());
	    			accessLogModel.setParam(mapper.writeValueAsString(imParam));
	    			
	    			if(rtn.get(OpenAPIService.RESULT_TYPE_CODE) != null) {
	    				accessLogModel.setRmk(mapper.writeValueAsString(rtn));
	    			} else {
	    				accessLogModel.setRmk("TOTAL_COUNT=" + rtn.get(OpenAPIService.TOTAL_COUNT) + ", ERROR_COUNT=" + rtn.get(OpenAPIService.ERROR_COUNT));
	    			}
	    	
	    			cService.saveAccessLog(accessLogModel);
	    		} catch(Exception e) {
	    			logger.error("{} ", e);
	    		}
	    		
				IOUtils.write(mapper.writeValueAsString(rtn), out, "UTF-8");
				
	        	res.setCharacterEncoding("UTF-8");
	        	res.setContentType("application/json; charset=utf-8");
	    		res.getOutputStream().flush();
	    	}        	
		} 
    }
    
	@Override
	public void onApplicationEvent(ContextRefreshedEvent arg0) {
		AjaxModel aParam = new AjaxModel();
		Map param = new HashMap();
		aParam.setData(param);
		param.put(Constant.QUERY_KEY.getCode(), "openapi.resetCCUCnt");

		cService.update(aParam);
	}	
}
