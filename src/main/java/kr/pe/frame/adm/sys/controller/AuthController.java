package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.service.AdmService;
import kr.pe.frame.adm.sys.service.AuthService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 시스템관리 > 권한관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AdmService
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
public class AuthController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "authService")
    private AuthService authService;

    /**
     * 권한정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/auth/saveAuth")
    @ResponseBody
    public AjaxModel saveAuth(AjaxModel model) throws Exception {
        return authService.saveAuth(model);
    }

    /**
     * 메뉴별 버튼권한 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/auth/saveBtnAuth")
    @ResponseBody
    public AjaxModel saveBtnAuth(AjaxModel model) throws Exception {
        return authService.saveBtnAuth(model);
    }

    /**
     * 권한 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/auth/deleteAuth")
    @ResponseBody
    public AjaxModel deleteAuth(AjaxModel model) throws Exception {
        return authService.deleteAuth(model);
    }


}
