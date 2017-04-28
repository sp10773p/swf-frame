package kr.pe.frame.adm.edi.controller;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.model.AjaxModel;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.adm.edi.service.EdiService;

/**
 * 송수신이력 처리 Controller
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@Controller
@RequestMapping("/edi")
public class EdiController {
    @Resource(name = "ediService")
    EdiService ediService;

    @RequestMapping("/selectSendRecvList")
    @ResponseBody
    public AjaxModel selectSendRecvList(AjaxModel model) throws Exception{
        return ediService.selectSendRecvList(model);
    }

    @RequestMapping("/selectSendRecv")
    @ResponseBody
    public AjaxModel selectSendRecv(AjaxModel model) throws Exception{
        return ediService.selectSendRecv(model);
    }

    @RequestMapping("/docReRecv")
    @ResponseBody
    public AjaxModel docReRecv(AjaxModel model) throws Exception{
        return ediService.docReRecv(model);
    }

    @RequestMapping("/selectSendRecvEvtList")
    @ResponseBody
    public AjaxModel selectSendRecvEvtList(AjaxModel model) throws Exception{
        return ediService.selectSendRecvEvtList(model);
    }
}
