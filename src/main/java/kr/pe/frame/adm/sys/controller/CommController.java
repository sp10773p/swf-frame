package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.service.CommService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 시스템관리 > 공통코드관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see CommService
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
public class CommController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commService")
    private CommService commService;

    /**
     * 마스터 코드 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/comm/saveMasterCode")
    @ResponseBody
    public AjaxModel saveMasterCode(AjaxModel model) throws Exception {
        return commService.saveMasterCode(model);
    }

    /**
     * 마스터 코드 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/comm/deleteMasterCode")
    @ResponseBody
    public AjaxModel deleteMasterCode(AjaxModel model) throws Exception {
        return commService.deleteMasterCode(model);
    }

    /**
     * 디테일 코드 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/comm/saveDetailCode")
    @ResponseBody
    public AjaxModel saveDetailCode(AjaxModel model) throws Exception {
        return commService.saveDetailCode(model);
    }

    /**
     * 디테일 코드 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/comm/deleteDetailCode")
    @ResponseBody
    public AjaxModel deleteDetailCode(AjaxModel model) throws Exception {
        return commService.deleteDetailCode(model);
    }
}
