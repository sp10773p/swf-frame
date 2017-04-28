package kr.pe.frame.cmm.login.interceptor;

import kr.pe.frame.adm.sys.model.MenuModel;
import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.adm.sys.service.MenuService;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AccessLogModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.KeyGen;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.cmm.util.WebUtil;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Spring Dispatcher 처리전 공통 Interceptor 처리
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
public class CommonInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(CommonInterceptor.class);

    private List<String> nonTarget;
    private List<String> nonTargetMenu;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "menuService")
    private MenuService menuService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String jsp = request.getParameter("jsp");

        if (logger.isDebugEnabled()) {
            logger.debug("======================================          START         ======================================");
            logger.debug("Request URI \t:  {}{}", request.getRequestURI(), (jsp != null ? "?jsp=" + jsp : ""));

            request.setAttribute("startTime", System.currentTimeMillis());
        }

        // Login Session Check
        try {
            HttpSession session = request.getSession();

            UsrSessionModel sessionModel = commonService.getUsrSessionModel(request);

            String actionMenuId = request.getParameter(Constant.ACTION_MENU_ID.getCode());
            String actionMenuNm = request.getParameter(Constant.ACTION_MENU_NM.getCode());
            String actionMenuDiv = request.getParameter(Constant.ACTION_MENU_DIV.getCode());

            if(actionMenuId == null) actionMenuId = request.getHeader(Constant.ACTION_MENU_ID.getCode());
            if(actionMenuNm != null) actionMenuNm = URLDecoder.decode(actionMenuNm, StandardCharsets.UTF_8.toString());

            if (!isLoginExcludeURL(request) && !isExcludeMenu(actionMenuId) && !validUserSession(request, sessionModel)) {
                if (logger.isDebugEnabled()) {
                    logger.debug("세션이 만료된 요청 [Request URL : " + request.getRequestURL().toString() + "]");
                }

                String contentType = request.getContentType();
                if(contentType != null && contentType.contains("application/json")){
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("code", "E00000002"); // 세션이 만료되었습니다.
                    OutputStream outputStream = response.getOutputStream();
                    outputStream.write(jsonObject.toJSONString().getBytes());
                    outputStream.flush();

                }

                return false;
            }

            if (sessionModel != null) {
                if("A".equals(sessionModel.getUserDiv()) || "C".equals(sessionModel.getUserDiv())){
                    if(request.getRequestURI().equals("/main.do")){
                        session.setAttribute(Constant.SESSION_KEY_USR.getCode(), null);
                        response.sendRedirect("/");
                    }
                }else{
                    if(request.getRequestURI().equals("/adminMain.do")){
                        session.setAttribute(Constant.SESSION_KEY_ADM.getCode(), null);
                        response.sendRedirect("/admin");
                    }
                }

                if(actionMenuId == null && StringUtil.isNotEmpty(jsp)){
                    List<MenuModel> menuList = sessionModel.getMenuModelList();
                    MenuModel menuModel = menuService.findJspMenu(menuList, jsp);
                    actionMenuId = menuModel.getMenuId();
                    actionMenuNm = menuModel.getMenuNm();
                    actionMenuDiv = menuModel.getMenuDiv();

                    request.setAttribute(Constant.ACTION_MENU_ID.getCode(), actionMenuId);
                    request.setAttribute(Constant.ACTION_MENU_NM.getCode(), actionMenuNm);
                    request.setAttribute(Constant.ACTION_MENU_DIV.getCode(), actionMenuDiv);
                }

                if((actionMenuId == null ? jsp : actionMenuId) != null && request.getHeader("AJAX") == null){
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.putAll(WebUtil.getParameterToObject(request));

                    AccessLogModel accessLogModel = new AccessLogModel();

                    accessLogModel.setSid(KeyGen.getRandomTimeKey());
                    accessLogModel.setSessionId(session.getId());
                    accessLogModel.setLogDiv(actionMenuDiv);
                    accessLogModel.setLoginIp(WebUtil.getClientIp(request));
                    accessLogModel.setUserId(sessionModel.getUserId());
                    accessLogModel.setScreenId((actionMenuId == null ? jsp : actionMenuId));
                    accessLogModel.setScreenNm(actionMenuNm);
                    accessLogModel.setUri(request.getRequestURI());
                    accessLogModel.setParam(jsonObject.toJSONString());

                    if(jsp != null){
                        accessLogModel.setRmk(jsp);
                    }
                    String actionNm = request.getParameter("ACTION_NM");
                    if(actionNm != null){
                        accessLogModel.setRmk(URLDecoder.decode(actionNm, StandardCharsets.UTF_8.toString()));
                    }
                    commonService.saveAccessLog(accessLogModel);
                }
            }

        } catch (Exception e) {
            logger.error("{}", e);
        }

        return true;
    }

    private boolean validUserSession(HttpServletRequest request, UsrSessionModel sessionModel) {
        if(sessionModel == null) return false;

        String userId = request.getHeader("global_login_user_id");
        if(userId != null && !userId.equals(sessionModel.getUserId())){
            return false;
        }

        return true;
    }

    /**
     * 세션 체크 대상 여부 반환
     * @param request
     * @return
     */
    private boolean isLoginExcludeURL(HttpServletRequest request) {
        boolean isNonTarget;
        for (String tar : nonTarget) {
            if(tar.startsWith("*")  && tar.endsWith("*")){
                isNonTarget = request.getRequestURI().indexOf(tar.replaceAll("\\*", "")) > 0;

            }else if(tar.startsWith("*")  && !tar.endsWith("*")){
                isNonTarget = request.getRequestURI().endsWith(tar.replaceAll("\\*", ""));

            }else if(!tar.startsWith("*")  && tar.endsWith("*")){
                isNonTarget = request.getRequestURI().startsWith(tar.replaceAll("\\*", ""));

            } else { // equals
                isNonTarget = request.getRequestURI().equals(tar.replaceAll("\\*", ""));
            }

            if (isNonTarget) {
                if (logger.isDebugEnabled()) {
                    logger.debug("세션체크 제외 : {}", tar);
                }
                return true;
            }
        }
        return false;
    }

    /**
     * 세션 체크 메뉴 대상 여부 반환
     * @param menuId
     * @return
     */
    private boolean isExcludeMenu(String menuId) {
        menuId = (StringUtil.isEmpty(menuId) ? "" : menuId);
        boolean isNonTarget = false;
        for (String tar : nonTargetMenu) {
            if (menuId.equals(tar)) {
                if (logger.isDebugEnabled()) {
                    logger.debug("세션체크 제외 메뉴 : {}", tar);
                }

                isNonTarget = true;
                break;
            }
        }
        return isNonTarget;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug(request.getRequestURL() + " execute time : " + (System.currentTimeMillis() - ((Long) request.getAttribute("startTime"))) + " ms");
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("======================================           END          ======================================\n");
        }
    }


    public void setNonTarget(List<String> nonTarget) {
        this.nonTarget = nonTarget;
    }

    public void setNonTargetMenu(List<String> nonTargetMenu) {
        this.nonTargetMenu = nonTargetMenu;
    }
}