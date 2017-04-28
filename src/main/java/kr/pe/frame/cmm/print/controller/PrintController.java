package kr.pe.frame.cmm.print.controller;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.util.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.KeyGen;

@Controller
public class PrintController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Value("#{config['ubi.viewer.url']}")
	private String ubiViewerUrl;

	@RequestMapping(value = "/printMngt", method = RequestMethod.POST)
	public ModelAndView printMngt(HttpServletRequest request, @RequestParam("reportFile") String reportFile, @RequestParam("args") String args, 
				@RequestParam("screenId") String screenId, @RequestParam("screenNm") String screenNm, @RequestParam("actionNm") String actionNm) throws Exception {
		ModelAndView mnv = new ModelAndView();
		AccessLogModel accessLogModel = new AccessLogModel();
		
		HttpSession session = request.getSession();
        UsrSessionModel sessionModel = (UsrSessionModel) session.getAttribute(Constant.SESSION_KEY_USR.getCode());
		String ip = WebUtil.getClientIp(request);
		String logDiv = "W";
		
		if(screenId != null) screenId = URLDecoder.decode(screenId, StandardCharsets.UTF_8.toString());
		if(screenNm != null) screenNm = URLDecoder.decode(screenNm, StandardCharsets.UTF_8.toString());
		if(actionNm != null) actionNm = URLDecoder.decode(actionNm, StandardCharsets.UTF_8.toString());
		
		
		mnv.addObject("reportFile", reportFile);
		mnv.addObject("args", args);
		mnv.addObject("reportCnt", StringUtil.defaultIfEmpty(request.getParameter("reportCnt"), ""));

		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId(screenId);
		accessLogModel.setScreenNm(screenNm);
		accessLogModel.setRmk(actionNm);
		accessLogModel.setUserId(sessionModel.getUserId());
		accessLogModel.setUri(request.getRequestURI());
		commonService.saveAccessLog(accessLogModel);
		mnv.setViewName("forward:" + this.ubiViewerUrl);
		
		return mnv;
	}
	

}
