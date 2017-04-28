package kr.pe.frame.exp.sta.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.exp.sta.service.StaService;

/**
 * 수출실적 & 현황 조회 Controller
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
@RequestMapping("/sta")
public class StaController {
    @Resource(name = "staService")
    StaService service;
    
    @Resource(name = "commonService")
    CommonService commonService;

    @RequestMapping("/selectExpStaReqList")
    @ResponseBody
    public AjaxModel selectExpStaReqList(AjaxModel model) throws Exception{
        return service.selectExpStaReqList(model);
    }

    @RequestMapping("/selectExpStaReq")
    @ResponseBody
    public AjaxModel selectExpStaReq(AjaxModel model) throws Exception{
        return service.selectExpStaReq(model);
    }

    @RequestMapping("/saveExpStaReq")
    @ResponseBody
    public AjaxModel saveExpStaReq(AjaxModel model) throws Exception{
        return service.saveExpStaReq(model);
    }
}
