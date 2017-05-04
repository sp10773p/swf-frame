package kr.pe.frame.exp.req.controller;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.exp.req.service.ReqService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by jjkhj on 2017-01-09.
 */
@Controller
public class ReqController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "reqService")
    ReqService reqService;

    /**
     * 수출신고요청 목록조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/req/selectDecReqList")
    @ResponseBody
    public AjaxModel selectDecReqList(AjaxModel model) throws Exception{
        return reqService.selectDecReqList(model);
    }
    
}
