package kr.pe.frame.basic.info.controller;

import kr.pe.frame.basic.info.service.SelService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 기본정보 > 상품정보조회, 신고서기본값, 신고인신고서기본값, HS 조회 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see SelService
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
public class SelController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "selService")
    SelService selService;

    /**
     * 상품정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sel/saveSellItem")
    @ResponseBody
    public AjaxModel saveSellItem(AjaxModel model) throws Exception {
        return selService.saveSellItem(model);
    }

    /**
     * 신고서기본값 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sel/saveBaseval")
    @ResponseBody
    public AjaxModel saveBaseval(AjaxModel model) throws Exception {
        return selService.saveBaseval(model);
    }

    /**
     * 신고인신고서기본값 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sel/saveDecBaseval")
    @ResponseBody
    public AjaxModel saveDecBaseval(AjaxModel model) throws Exception {
        return selService.saveDecBaseval(model);
    }

    /**
     * HS코드 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sel/saveHsCode")
    @ResponseBody
    public AjaxModel saveHsCode(AjaxModel model) throws Exception {
        return selService.saveHsCode(model);
    }
}
