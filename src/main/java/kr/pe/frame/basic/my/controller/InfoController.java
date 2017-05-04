package kr.pe.frame.basic.my.controller;

import kr.pe.frame.basic.my.service.InfoService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 기본정보 > 내정보관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see InfoService
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
public class InfoController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "infoService")
    InfoService infoService;

    /**
     * 내정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/info/saveUser")
    @ResponseBody
    public AjaxModel saveUser(AjaxModel model) throws Exception {
        return infoService.saveUser(model);
    }

    /**
     * 탈퇴 요청
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/info/saveWithOutReq")
    @ResponseBody
    public AjaxModel saveWithOutReq(AjaxModel model) throws Exception {
        return infoService.saveWithOutReq(model);
    }

    /**
     * 비밀번호 변경
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/info/saveModPw")
    @ResponseBody
    public AjaxModel saveModPw(AjaxModel model) throws Exception {
        return infoService.saveModPw(model);
    }
}
