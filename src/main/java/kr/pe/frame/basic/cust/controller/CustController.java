package kr.pe.frame.basic.cust.controller;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.basic.cust.service.CustService;

/**
 * 사용자 화면: 기초정보 > 거래처관리 Controller
 * @author 정안균
 * @since 2017-03-06
 * @version 1.0
 * @see DeftService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.06  정안균  최초 생성
 *
 * </pre>
 */
@Controller
public class CustController {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "custService")
	CustService custService;
	
	@RequestMapping(value = "/cust/saveCust")
	@ResponseBody
	public AjaxModel saveCust(AjaxModel model) throws Exception {
		return custService.saveCust(model);
	}
	
	@RequestMapping(value = "/cust/deleteCustList")
	@ResponseBody
	public AjaxModel deleteCustList(AjaxModel model) throws Exception {
		return custService.deleteCustList(model);
	}
}
