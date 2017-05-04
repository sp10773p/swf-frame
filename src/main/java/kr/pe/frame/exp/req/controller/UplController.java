package kr.pe.frame.exp.req.controller;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.exp.req.service.UplService;

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
public class UplController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "uplService")
    UplService uplService;
    
    /**
     * 수출신고업로드 목록 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/upl/selectDecExcelList")
    @ResponseBody
    public AjaxModel selectDecExcelList(AjaxModel model) throws Exception{
        return uplService.selectDecExcelList(model);
    }
    
}
