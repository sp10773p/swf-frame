package kr.pe.frame.basic.deft.controller;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.basic.deft.service.DeftService;

/**
 * 사용자 화면: 기본정보 > 신고서 기본값 Controller
 * @author 정안균
 * @since 2017-03-02
 * @version 1.0
 * @see DeftService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.02  정안균  최초 생성
 *
 * </pre>
 */
@Controller
public class DeftController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "deftService")
    DeftService deftService;
    
    /**
     * 신고서 기본값 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deft/selectBaseVal")
	@ResponseBody
	public AjaxModel selectBaseVal(AjaxModel model) throws Exception {
	   return deftService.selectBaseVal(model);
	}
    
    /**
     * 신고서 기본값 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deft/saveBaseVal")
    @ResponseBody
    public AjaxModel saveBaseVal(AjaxModel model) throws Exception {
        return deftService.saveBaseVal(model);
    }
}
