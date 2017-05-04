package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.service.AdmService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 시스템관리 > 어드민관리 Controller
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
public class AdmController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "admService")
    private AdmService admService;

    /**
     * 어드민사용자 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/saveAdmUser")
    @ResponseBody
    public AjaxModel saveAdmUser(AjaxModel model) throws Exception {
        return admService.saveAdmUser(model);
    }

    /**
     * 어드민사용자 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/deleteAdminUser")
    @ResponseBody
    public AjaxModel deleteAdminUser(AjaxModel model) throws Exception {
        return admService.deleteAdminUser(model);
    }

}
