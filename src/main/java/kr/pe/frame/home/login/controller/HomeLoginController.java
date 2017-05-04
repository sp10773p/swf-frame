package kr.pe.frame.home.login.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.adm.sys.service.UsrService;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.cmm.util.KeyGen;
import kr.pe.frame.cmm.util.WebUtil;
import kr.pe.frame.home.login.service.HomeLoginService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeLoginController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "homeLoginService")
	private HomeLoginService homeLoginService;
	
    @Resource(name = "usrService")
    private UsrService usrService;
    
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/homeLogin/idFnd")
	@ResponseBody
	public AjaxModel idFnd(HttpServletRequest request, AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		
		AjaxModel user = homeLoginService.selectUser(model);
		Map<String, Object>  data = user.getData();
		if(data != null && StringUtils.isNotEmpty((String)data.get("USER_ID"))) {
			data.put("EMAIL", "");
			model.setData(data);
		}
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId((String)param.get("ACTION_MENU_ID"));
		accessLogModel.setScreenNm((String)param.get("ACTION_MENU_NM"));
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
	   return model;
	}

	@RequestMapping(value = "/homeLogin/pwdFnd")
	@ResponseBody
	public AjaxModel pwdFnd(HttpServletRequest request, AjaxModel model) throws Exception {
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		AjaxModel user = homeLoginService.selectUser(model);
		Map<String, Object> data = user.getData();
		if(data != null && StringUtils.isNotEmpty((String)data.get("USER_ID"))) {
			data.put("EMAIL", DocUtil.decrypt(StringUtils.defaultIfEmpty((String) data.get("EMAIL"), "")));
			model.setData(data);
			usrService.saveInitPass(model);
			model.setMsg("SEND");
		}
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("pwdFnd");
		accessLogModel.setScreenNm("비밀번호 찾기");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
	   return model;
	}

}
