package kr.pe.frame.cmm.login.controller;

import kr.pe.frame.adm.sys.model.MenuModel;
import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.adm.sys.service.MenuService;
import kr.pe.frame.adm.sys.service.UsrService;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.base.Sha256;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DateUtil;
import kr.pe.frame.cmm.util.KeyGen;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.cmm.util.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.List;

/**
 * 로그인, 로그아웃 처리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.05  성동훈  최초 생성
 *
 * </pre>
 */
@Controller
public class LoginController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "usrService")
	private UsrService usrService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "menuService")
	private MenuService menuService;

	@Value("#{config['login.view']}")
	private String loginView;

	@Value("#{config['login.admin.view']}")
	private String loginAdminView;

	@Value("#{config['login.mobile.view']}")
	private String loginMobileView;

	@Value("#{config['use.password.encrypt']}")
	private boolean isPasswordEncrypt;

	@Value("#{config['main.url']}")
	private String mainUrl;

	@Value("#{config['main.admin.url']}")
	private String mainAdminUrl;

	@Value("#{config['main.mobile.url']}")
	private String mainMobileUrl;

	@Value("#{config['login.admin.url']}")
	private String loginAdminUrl;

	@Value("#{config['login.admin.ipcheck']}")
	private boolean isAdminIpCheck;

	/**
	 * 모바일 사이트 접속 화면 이동
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mobileLogin")
	public ModelAndView mobileLogin(HttpServletRequest request) throws Exception {
		ModelAndView mnv = new ModelAndView();
		mnv.setViewName("main/mobileLogin");

		HttpSession session = request.getSession();

		if(session.getAttribute(Constant.SESSION_KEY_MBL.getCode()) != null){
			request.setAttribute("sessionDiv", Constant.MBL_SESSION_DIV.getCode());
			mnv.setViewName(String.format("forward:%s", this.mainMobileUrl));
			return mnv;
		}

		saveAccessLog(request, Constant.MBL_SESSION_DIV.getCode(), "goGlobal 모바일사이트 접속");

		return mnv;
	}

	/**
	 * 어드민 사이트 접속 화면 이동
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminLogin")
	public ModelAndView adminLogin(HttpServletRequest request) throws Exception {
		ModelAndView mnv = new ModelAndView();
		mnv.setViewName("main/adminLogin");

		HttpSession session = request.getSession();

		if(session.getAttribute(Constant.SESSION_KEY_ADM.getCode()) != null){
			request.setAttribute("sessionDiv", Constant.ADM_SESSION_DIV.getCode());
			mnv.setViewName(String.format("forward:%s", this.mainAdminUrl));
			return mnv;
		}

		saveAccessLog(request, Constant.ADM_SESSION_DIV.getCode(), "goGlobal 어드민사이트 접속");

		return mnv;
	}

	/**
	 * 어드민 메인 화면으로 이동
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminMain")
	public ModelAndView adminMain(HttpServletRequest request) throws Exception {
		ModelAndView mnv = new ModelAndView();
		mnv.setViewName("main/adminMain");

		return mnv;
	}

	/**
	 * 모바일 메인 화면으로 이동
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mobileMain")
	public ModelAndView mobileMain(HttpServletRequest request) throws Exception {
		ModelAndView mnv = new ModelAndView();

		UsrSessionModel sessionModel = (UsrSessionModel) request.getSession().getAttribute(Constant.SESSION_KEY_MBL.getCode());
		if(sessionModel != null){
			List<MenuModel> menuModels = sessionModel.getMenuModelList();
			for(MenuModel menuModel : menuModels){
				String menuPath = menuModel.getMenuPath();
				String menuUrl  = menuModel.getMenuUrl();
				if(StringUtil.isEmpty(menuPath) || StringUtil.isEmpty(menuUrl)){
					continue;
				}

				mnv.addObject("loadMenuId"   , menuModel.getMenuId());
				mnv.addObject("loadMenuNm"   , menuModel.getMenuNm());
				mnv.addObject("loadMenuPath" , menuPath);
				mnv.addObject("loadMenuUrl"  , menuUrl);
				break;
			}
		}

		mnv.setViewName("main/mobileMain");

		return mnv;
	}

	/**
	 * 사용자 로그인 처리
	 * @param request
	 * @param response
	 * @param usrId
	 * @param usrPswd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/doLoginAction")
	public ModelAndView doLoginAction(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value = "usrId",required = false) String usrId,
									@RequestParam(value = "usrPswd",required = false) String usrPswd) throws Exception {

		if(usrId == null || usrPswd == null){
			ModelAndView mnv = new ModelAndView();
			mnv.setViewName("redirect:/");
			return mnv;
		}

		return loginAction(request, response, usrId, usrPswd, Constant.USR_SESSION_DIV.getCode());
	}

	/**
	 * 사용자 로그인 처리
	 * @param request
	 * @param response
	 * @param usrId
	 * @param usrPswd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/doAdminLoginAction")
	public ModelAndView doAdminLoginAction(HttpServletRequest request,
									HttpServletResponse response,
									@RequestParam(value = "usrId",required = false) String usrId,
									@RequestParam(value = "usrPswd",required = false) String usrPswd) throws Exception {
		if(usrId == null || usrPswd == null){
			return adminLogin(request);
		}

		return loginAction(request, response, usrId, usrPswd, Constant.ADM_SESSION_DIV.getCode());
	}

	/**
	 * 모바일 로그인 처리
	 * @param request
	 * @param response
	 * @param usrId
	 * @param usrPswd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/doMobileLoginAction")
	public ModelAndView doMobileLoginAction(HttpServletRequest request,
										 HttpServletResponse response,
										 @RequestParam(value = "usrId",required = false) String usrId,
										 @RequestParam(value = "usrPswd",required = false) String usrPswd) throws Exception {

		if(usrId == null || usrPswd == null){
			return mobileLogin(request);
		}

		return loginAction(request, response, usrId, usrPswd, Constant.MBL_SESSION_DIV.getCode());
	}

	/**
	 * 로그인 처리
	 * @param request
	 * @param usrId
	 * @param usrPswd
	 * @param sessionDiv
	 * @return
	 * @throws Exception
	 */
	public ModelAndView loginAction(HttpServletRequest request, HttpServletResponse response,
									String usrId, String usrPswd, String sessionDiv) throws Exception {

		UsrSessionModel usrSessionModel = usrService.selectUsrSessionInfo(usrId, sessionDiv);

		ModelAndView mnv = new ModelAndView();
		AccessLogModel accessLogModel = new AccessLogModel();

		String ip      = WebUtil.getClientIp(request);
		String msg = null;

		String redirect = "/";

		if(Constant.ADM_SESSION_DIV.getCode().equals(sessionDiv)){
			redirect = "/admin";

		}else if(Constant.MBL_SESSION_DIV.getCode().equals(sessionDiv)){
			redirect = "/mobile";

		}

		if (usrSessionModel == null) {
			msg = commonService.getMessage("I00000001");// 아이디 또는 비밀번호가 올바르지 않습니다.

		} else if (this.isPasswordEncrypt &&  !Sha256.compareEncrypt(usrSessionModel.getUserPw(), usrPswd) ||
				!this.isPasswordEncrypt &&  !usrPswd.equals(usrSessionModel.getUserPw())) {
			msg = commonService.getMessage("I00000001"); // 아이디 또는 비밀번호가 올바르지 않습니다.

		}else if(!"1".equals(usrSessionModel.getUserStatus()) || !"Y".equals(usrSessionModel.getUseChk())){ // 사용자 상태( 1 : 가입승인 ) || 사용여부
			msg = commonService.getMessage("W00000062"); // 사용할 수 없는 상태 입니다.

		}else if(usrSessionModel.getMenuModelList().size() == 0){
			msg = commonService.getMessage("W00000022"); // 사용할 수 있는 메뉴가 없습니다. \n권한이나 접속한 사이트를 확인 하세요.

		// IP접속허용체크
		}else if("M".equals(sessionDiv) && isAdminIpCheck && !checkIpMatching(usrId, ip)){
			msg = commonService.getMessage("W00000038"); // IP 접속권한이 없습니다.

		}

		if(msg == null) {
			usrSessionModel.setLoginError(0);
			if (usrSessionModel.getLoginLast() == null || DateUtil.parse(usrSessionModel.getLoginLast().replaceAll("-", "").substring(0, 8), "yyyyMMdd").before(DateUtil.parse("20000101", "yyyyMMdd"))) {
				usrSessionModel.setLoginStart(DateUtil.stamp().toString());
			}

			usrSessionModel.setLoginLast(DateUtil.stamp().toString());
			usrSessionModel.setModId(usrSessionModel.getUserId());

			// 사용자 로그인 정보 갱신
			usrService.updateUserLoginInfo(usrSessionModel);

			usrSessionModel.setUserIp(ip);
			HttpSession session = request.getSession(true);

			if (Constant.USR_SESSION_DIV.getCode().equals(sessionDiv)) {
				session.setAttribute(Constant.SESSION_KEY_USR.getCode(), usrSessionModel);

			} else if (Constant.ADM_SESSION_DIV.getCode().equals(sessionDiv)) {
				session.setAttribute(Constant.SESSION_KEY_ADM.getCode(), usrSessionModel);

			} else if (Constant.MBL_SESSION_DIV.getCode().equals(sessionDiv)) {
				session.setAttribute(Constant.SESSION_KEY_MBL.getCode(), usrSessionModel);

			}

			mnv.setViewName(String.format("redirect:%s", redirect));
			accessLogModel.setRmk("로그인 성공");

		}else{
			mnv.addObject("usrId"  , usrId);
			mnv.addObject("usrPswd", usrPswd);
			mnv.addObject("msg"    , msg);
			mnv.setViewName(String.format("forward:%s", redirect));

			accessLogModel.setRmk("로그인 실패[" + msg + "]");
		}


		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(sessionDiv);
		accessLogModel.setLoginIp(ip);
		accessLogModel.setScreenId("LOGIN");
		accessLogModel.setScreenNm("로그인");
		accessLogModel.setUserId(usrId);
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);

		return mnv;
	}

	/**
	 * check if IP address match pattern
	 *
	 * @param userId
	 * @param address
	 *            *.*.*.* , 192.168.1.0-255 , *
	 * @param address
	 *            - 192.168.1.1
	 *            address = 10.2.88.12  pattern = *.*.*.*   result: true
	 *                address = 10.2.88.12  pattern = *   result: true
	 *                address = 10.2.88.12  pattern = 10.2.88.12-13   result: true
	 *                address = 10.2.88.12  pattern = 10.2.88.13-125   result: false
	 * @return true if address match pattern
	 */
	private boolean checkIpMatching(String userId, String address) {
		try {
			boolean result = true;
			List<String> ipList = commonService.selectUserIpAccess(userId);
			if(ipList.size() == 0){
				return true;
			}

			for (String pattern : ipList) {
				if (pattern.equals("*.*.*.*") || pattern.equals("*"))
					return true;

				result = true;
				String[] mask = pattern.split("\\.");
				String[] ip_address = address.split("\\.");
				for (int i = 0; i < mask.length; i++) {
					if (mask[i].equals("*") || mask[i].equals(ip_address[i])) {
					}
					else if (mask[i].contains("-")) {
						byte min = Byte.parseByte(mask[i].split("-")[0]);
						byte max = Byte.parseByte(mask[i].split("-")[1]);
						byte ip = Byte.parseByte(ip_address[i]);
						if (ip < min || ip > max)
							result = false;
					} else
						result = false;
				}

				if (result) return true;
			}
			return result;
		}catch(ArrayIndexOutOfBoundsException e){
			return address.equals("0:0:0:0:0:0:0:1");
		}
	}

	/**
	 * 로그아웃 처리
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/logout")
	public ModelAndView logoutAction(HttpServletRequest request, HttpServletResponse response) throws Exception  {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		UsrSessionModel sessionModel = commonService.getUsrSessionModel(request);

		String sessionDiv = request.getParameter("sessionDiv");
		if(sessionModel != null){
			AccessLogModel accessLogModel = new AccessLogModel();

			if("A".equals(sessionModel.getUserDiv()) || "C".equals(sessionModel.getUserDiv())){
				accessLogModel.setLogDiv(Constant.ADM_SESSION_DIV.getCode());
			}else{
				if(Constant.USR_SESSION_DIV.getCode().equals(sessionDiv)){
					accessLogModel.setLogDiv(Constant.USR_SESSION_DIV.getCode());

				}else if(Constant.MBL_SESSION_DIV.getCode().equals(sessionDiv)){
					accessLogModel.setLogDiv(Constant.MBL_SESSION_DIV.getCode());

				}
			}

			accessLogModel.setSid(KeyGen.getRandomTimeKey());
			accessLogModel.setSessionId(session.getId());
			accessLogModel.setLoginIp(WebUtil.getClientIp(request));
			accessLogModel.setScreenId("LOGOUT");
			accessLogModel.setScreenNm("로그아웃");
			accessLogModel.setUserId(sessionModel.getUserId());
			accessLogModel.setUri(request.getRequestURI());

			commonService.saveAccessLog(accessLogModel);

			if("A".equals(sessionModel.getUserDiv()) || "C".equals(sessionModel.getUserDiv())){
				mav.setViewName(String.format("redirect:%s", "/admin"));
				session.setAttribute(Constant.SESSION_KEY_ADM.getCode(), null);

			}else{
				if(Constant.USR_SESSION_DIV.getCode().equals(sessionDiv)) {
					mav.setViewName(String.format("redirect:%s", "/"));
					session.setAttribute(Constant.SESSION_KEY_USR.getCode(), null);

				}else if(Constant.MBL_SESSION_DIV.getCode().equals(sessionDiv)){
					mav.setViewName(String.format("redirect:%s", "/mobile"));
					session.setAttribute(Constant.SESSION_KEY_MBL.getCode(), null);

				}
			}

		}else{
			mav.setViewName(String.format("redirect:%s", "/"));

		}

		return mav;
	}

	/**
	 * 사용자 사이트 메인 화면으로 이동
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/main")
	public ModelAndView main(HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("main/main");

		UsrSessionModel sessionModel = (UsrSessionModel) request.getSession().getAttribute(Constant.SESSION_KEY_USR.getCode());

		List<MenuModel> menuModels;

		String topMenuId = null;
		String topMenuNm = null;
		if(sessionModel != null){

			menuModels = sessionModel.getMenuModelList();

			mav.addObject("userId"        , sessionModel.getUserId());
			mav.addObject("loginLastTime" , sessionModel.getLoginLastStr());
			mav.addObject("session"       , sessionModel);
			mav.addObject("authCd"        , sessionModel.getAuthCd());
		}else{
			// 기본 화면
			menuModels = menuService.selectUsrMenuList("DEFAULT", "W");

			if(request.getSession(true).getAttribute(Constant.SESSION_MENU_LIST.getCode()) == null){
				request.getSession(true).setAttribute(Constant.SESSION_MENU_LIST.getCode(), menuModels);
			}

			mav.addObject("authCd", "DEFAULT");
		}

		String loadMenu = request.getParameter("loadMenu");
		if(StringUtil.isNotEmpty(loadMenu)){
			for(MenuModel menuModel : menuModels){
				String menuPath = menuModel.getMenuPath();
				String menuUrl  = menuModel.getMenuUrl();
				if(StringUtil.isEmpty(menuPath) || StringUtil.isEmpty(menuUrl)){
					continue;
				}

				if(loadMenu.equals(menuPath+"/"+menuUrl)){
					MenuModel rootMenuModel = menuService.findRootMenu(menuModels, menuModel.getPmenuId());
					if(rootMenuModel != null){
						topMenuId = rootMenuModel.getMenuId();
						topMenuNm = rootMenuModel.getMenuNm();
					}

					mav.addObject("loadMenuId" , menuModel.getMenuId());
					break;
				}
			}

			Enumeration<?> enumeration = request.getParameterNames();
			String key;
			String[] values;
			while (enumeration.hasMoreElements()) {
				key = (String) enumeration.nextElement();
				values = request.getParameterValues(key);
				if (values != null) {
					for(int i=0; i<values.length; i++){
						try {
							values[i] = URLDecoder.decode(values[i], StandardCharsets.UTF_8.toString());
						} catch (UnsupportedEncodingException e) {
						}
					}
					mav.addObject(key, (values.length > 1) ? values : values[0]);
				}
			}
		}

		if(topMenuId == null){
			topMenuId = menuModels.get(0).getMenuId();
			topMenuNm = menuModels.get(0).getMenuNm();
		}

		mav.addObject("menuList"      , menuModels);
		mav.addObject("sessionDiv"    , Constant.USR_SESSION_DIV.getCode());
		mav.addObject("topMenuId" , topMenuId);
		mav.addObject("topMenuNm" , topMenuNm);

		return mav;
	}

	private void saveAccessLog(HttpServletRequest request, String logDiv, String screenNm){
		AccessLogModel accessLogModel = new AccessLogModel();

		accessLogModel.setSid(KeyGen.getRandomTimeKey());
		accessLogModel.setSessionId(request.getSession().getId());
		accessLogModel.setLogDiv(logDiv);
		accessLogModel.setLoginIp(WebUtil.getClientIp(request));
		accessLogModel.setScreenId("ACCESS");
		accessLogModel.setScreenNm(screenNm);
		accessLogModel.setUri(request.getRequestURI());

		commonService.saveAccessLog(accessLogModel);

	}
}
