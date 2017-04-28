package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.service.MsgService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 시스템관리 > 알림메시지관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MsgService
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
public class MsgController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "msgService")
    MsgService msgService;

    /**
     * 알림 메시지 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msg/saveMessage")
    @ResponseBody
    public AjaxModel saveMessage(AjaxModel model) throws Exception{
        return msgService.saveMessage(model);
    }
}
