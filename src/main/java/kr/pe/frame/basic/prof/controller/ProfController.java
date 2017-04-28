package kr.pe.frame.basic.prof.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.basic.prof.service.ProfService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.home.mem.service.MemService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 사용자 화면: 기초정보 > 회원관리 Controller
 * @author 정안균
 * @since 2017-03-07
 * @version 1.0
 * @see ProfService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.07  정안균  최초 생성
 *
 * </pre>
 */
@Controller
public class ProfController {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "profService")
	ProfService profService;
	
	@Resource(name = "memService")
    MemService memService;
	
	@RequestMapping(value = "/prof/saveUserInfo")
	@ResponseBody
	public AjaxModel saveUserInfo(AjaxModel model) throws Exception {
	    return profService.saveUserInfo(model);
	}
	
	@RequestMapping(value = "/prof/saveUserWithdraw")
	@ResponseBody
	public AjaxModel saveUserWithdraw(AjaxModel model) throws Exception {
	    return profService.saveUserWithdraw(model);
	}
	
	@RequestMapping(value = "/prof/saveEmailAuth")
	@ResponseBody
	public AjaxModel saveEmailAuth(HttpServletRequest request, AjaxModel model) throws Exception {
		profService.saveEmailAuth(model);
	    return model;
	}
	
	@RequestMapping(value = "/prof/selectEmailAuth")
	@ResponseBody
	public AjaxModel selectEmailAuth(HttpServletRequest request, AjaxModel model) throws Exception {
		profService.selectEmailAuth(model);
	   return model;
	}
	
	/**
     * 사용자 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/prof/selectUsr")
    @ResponseBody
    public AjaxModel selectUsr(AjaxModel model) throws Exception{
        return profService.selectUsr(model);
    }
    
    /**
     * UTH 사용자 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/prof/selectUthUsr")
	@ResponseBody
	public AjaxModel selectUthUsr(HttpServletRequest request, AjaxModel model) throws Exception {
    	memService.selectUthUsr(model);
	   return model;
	}
}
