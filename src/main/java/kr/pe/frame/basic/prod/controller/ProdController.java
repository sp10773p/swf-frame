package kr.pe.frame.basic.prod.controller;

import javax.annotation.Resource;

import kr.pe.frame.basic.prod.service.ProdService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 사용자 화면: 기초정보 > 상품관리 Controller
 * @author 정안균
 * @since 2017-03-08
 * @version 1.0
 * @see ProdService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.08  정안균  최초 생성
 *
 * </pre>
 */
@Controller
public class ProdController {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "prodService")
	ProdService prodService;
	
	@RequestMapping(value = "/prod/saveItemInfo")
	@ResponseBody
	public AjaxModel saveUserInfo(AjaxModel model) throws Exception {
	    return prodService.saveItemInfo(model);
	}
	
}
