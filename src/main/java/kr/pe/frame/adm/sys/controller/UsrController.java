package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.adm.sys.service.UsrService;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.RandomString;
import kr.pe.frame.cmm.util.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import kr.pe.frame.cmm.core.base.Sha256;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 시스템관리 > 사용자관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see UsrService
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
public class UsrController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "usrService")
    UsrService usrService;

    @Resource(name = "commonService")
    CommonService commonService;

    @Value("#{config['main.url']}")
    private String mainUrl;

    private final LinkedHashMap<Long, String> webAccessKey = new LinkedHashMap<>();

    /**
     * 사용자 리스트 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/selectUsrList")
    @ResponseBody
    public AjaxModel selectUsrList(AjaxModel model) throws Exception{
        return usrService.selectUsrList(model);
    }

    /**
     * 사용자 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/selectUsr")
    @ResponseBody
    public AjaxModel selectUsr(AjaxModel model) throws Exception{
        return usrService.selectUsr(model);
    }

    /**
     * 사용자 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/saveUser")
    @ResponseBody
    public AjaxModel saveUser(AjaxModel model) throws Exception {
        return usrService.saveUser(model);
    }

    /**
     * 비밀번호 초기화
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/initPass")
    @ResponseBody
    public AjaxModel saveInitPass(AjaxModel model) throws Exception {
        return usrService.saveInitPass(model);
    }

    /**
     * 사용자 승인처리
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/saveUserApprove")
    @ResponseBody
    public AjaxModel saveUserApprove(AjaxModel model) throws Exception {
        return usrService.saveUserApprove(model);
    }

    /**
     * API 키 생성
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/makeApiKey")
    @ResponseBody
    public AjaxModel makeApiKey(AjaxModel model) throws Exception {
        return usrService.saveMakeApiKey(model);
    }

    /**
     * 탈퇴승인 처리
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/userDrop")
    @ResponseBody
    public AjaxModel userDrop(AjaxModel model) throws Exception {
        return usrService.saveUserDrop(model);
    }


    /**
     * 사용자 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/deleteUser")
    @ResponseBody
    public AjaxModel deleteUser(AjaxModel model) throws Exception {
        return usrService.deleteUser(model);
    }

    /**
     * 사용자 WEB 접속 인증키 생성
     * @param request
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/usr/createWebAccessKey")
    @ResponseBody
    public AjaxModel createWebAccessKey(HttpServletRequest request, @RequestParam("userId") String userId) throws Exception {
        AjaxModel model = new AjaxModel();

        StringBuilder sb = new StringBuilder();
        HttpSession session = request.getSession(false);
        sb.append(userId).append(session.getId()).append(RandomString.random(10));

        String key = Sha256.encrypt(sb.toString());

        addWebAccessKey(key);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("accessKey", key);
        model.setData(retMap);

        return model;
    }

    /**
     * 사용자Web 접속
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/usr/userWebSite")
    public ModelAndView userWebSite(HttpServletRequest request, HttpServletResponse response,
                                        @RequestParam(value = "userId", required = false) String userId,
                                        @RequestParam(value = "key", required = false) String key) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:/");

        HttpSession session = request.getSession(true);

        // Session Validation
        if(isValidWebAccessKey(key)){
            UsrSessionModel usrSessionModel = usrService.selectUsrSessionInfo(userId, Constant.USR_SESSION_DIV.getCode());

            String ip = WebUtil.getClientIp(request);
            usrSessionModel.setUserIp(ip);

            session.setAttribute(Constant.SESSION_KEY_USR.getCode(), usrSessionModel);

            response.addHeader("sessiondiv", Constant.USR_SESSION_DIV.getCode());
            response.addHeader("global_login_user_id", userId);

        }else{
            session.setAttribute(Constant.SESSION_KEY_USR.getCode(), null);

            response.addHeader("sessiondiv", null);
            response.addHeader("global_login_user_id", null);
        }

        return mav;
    }

    /**
     * 사용자 WEB 접속 인증키관리 추가
     * @param key
     */
    private synchronized void addWebAccessKey(String key){
        synchronized (webAccessKey){
            webAccessKey.put(System.currentTimeMillis(), key);
        }
    }

    /**
     * 사용자 WEB 접속 인증키 검증
     * @param accessKey
     * @return
     * @throws Exception
     */
    private synchronized boolean isValidWebAccessKey(String accessKey) throws Exception {
        boolean bool = false;
        synchronized (webAccessKey){
            List<Long> removeKey = new ArrayList<>();
            for ( Map.Entry entry : webAccessKey.entrySet() ) {
                long addTime = (long) entry.getKey();
                if((System.currentTimeMillis() - addTime) > (1000 * 5)){
                    removeKey.add(addTime);

                }else{
                    if(accessKey.equals(entry.getValue())){
                        removeKey.add(addTime);
                        bool = true;
                    }
                }
            }

            for(Long key : removeKey){
                webAccessKey.remove(key);
            }
        }

        return bool;
    }
}
