package kr.pe.frame.exp.dec.controller;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.exp.dec.service.ModService;

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
public class ModController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "modService")
    ModService modService;
    
    
    /**
     * 수출신고조회 전송
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mod/saveExpDmrSend")
    @ResponseBody
    public AjaxModel saveExpDmrSend(AjaxModel model) throws Exception {
        return modService.saveExpDmrSend(model);
    }


}
