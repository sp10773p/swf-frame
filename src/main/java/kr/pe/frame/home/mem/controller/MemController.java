package kr.pe.frame.home.mem.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.pe.frame.adm.sys.service.UsrService;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.KeyGen;
import kr.pe.frame.cmm.util.WebUtil;
import kr.pe.frame.home.mem.service.MemService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MemController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "memService")
	private MemService memService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "usrService")
	private UsrService usrService;
	
	@Value("#{config['mem.join05.url']}")
	private String memJoin05Url;

	@RequestMapping(value = "/mem/idFnd")
	@ResponseBody
	public AjaxModel idFnd(HttpServletRequest request, AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		
		AjaxModel user = memService.selectUser(model);
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId((String)param.get("ACTION_MENU_ID"));
		accessLogModel.setScreenNm((String)param.get("ACTION_MENU_NM"));
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
	   return user;
	}
	
	@RequestMapping(value = "/mem/saveMemberJoin")
	@ResponseBody
	public AjaxModel saveMemberJoin(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		
		AjaxModel user = memService.saveMemberJoin(request, response);
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("join04");
		accessLogModel.setScreenNm("서비스 입력");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
		return user;
	}
	
	@RequestMapping(value = "/mem/saveEmailAuth")
	@ResponseBody
	public AjaxModel saveEmailAuth(HttpServletRequest request, AjaxModel model) throws Exception {
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		memService.saveEmailAuth(model);
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("join03");
		accessLogModel.setScreenNm("회원정보 입력");
		accessLogModel.setRmk("이메일 인증번호 발송");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
	   return model;
	}
	
	@RequestMapping(value = "/mem/selectEmailAuth")
	@ResponseBody
	public AjaxModel selectEmailAuth(HttpServletRequest request, AjaxModel model) throws Exception {
		String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
		memService.selectEmailAuth(model);
		AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("join03");
		accessLogModel.setScreenNm("회원정보 입력");
		accessLogModel.setRmk("이메일 인증번호 확인");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
	   return model;
	}
	
	/**
     * 사용자 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mem/selectUsr")
    @ResponseBody
    public AjaxModel selectUsr(HttpServletRequest request, AjaxModel model) throws Exception{
    	String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
    	AjaxModel user = usrService.selectUsr(model);
    	
    	AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("join05");
		accessLogModel.setScreenNm("가입정보 확인");
		accessLogModel.setRmk("사용자 정보 조회");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
		return user;
    }
    
	/**
     * UTH 사용자 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mem/selectUthUsr")
    @ResponseBody
    public AjaxModel selectUthUsr(HttpServletRequest request, AjaxModel model) throws Exception{
    	String ip      = WebUtil.getClientIp(request);
		String logDiv  = "W";	
    	AjaxModel user = memService.selectUthUsr(model);
    	
    	AccessLogModel accessLogModel = new AccessLogModel();
		
		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("join04");
		accessLogModel.setScreenNm("서비스 입력");
		accessLogModel.setRmk("UTH 사용자 조회");
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);
		return user;
    }

}
