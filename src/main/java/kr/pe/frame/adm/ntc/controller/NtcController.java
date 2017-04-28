package kr.pe.frame.adm.ntc.controller;

import kr.pe.frame.adm.ntc.service.NtcService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 공지사항 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see NtcService
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
public class NtcController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "ntcService")
    NtcService ntcService;

    /**
     * 공지사항 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ntc/deleteCmmNotice")
    @ResponseBody
    public AjaxModel deleteCmmNotice(AjaxModel model) throws Exception {
        return ntcService.deleteCmmNotice(model);
    }

}
