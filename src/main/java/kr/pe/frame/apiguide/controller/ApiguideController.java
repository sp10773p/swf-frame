package kr.pe.frame.apiguide.controller;

import javax.annotation.Resource;

import kr.pe.frame.apiguide.service.ApiguideServiceImpl;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.apiguide.service.ApiguideService;

/**
 * 포털 > API관리 Controller
 * @author 정안균
 * @since 2017-03-30
 * @version 1.0
 * @see ApiguideServiceImpl ;
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.30  정안균  최초 생성
 *
 * </pre>
 */
@Controller
public class ApiguideController {
	 Logger logger = LoggerFactory.getLogger(this.getClass());

	 @Resource(name = "apiguideService")
	 ApiguideService apiguideService;
	 
	 @RequestMapping(value = "/apiguide/selectCmmApiKeyMng")
	 @ResponseBody
	 public AjaxModel selectCmmApiKeyMng(AjaxModel model) throws Exception {
	    return apiguideService.selectCmmApiKeyMng(model);
	 }
	 
	 @RequestMapping(value = "/apiguide/saveCmmApiKeyMng")
	 @ResponseBody
	 public AjaxModel saveCmmApiKeyMng(AjaxModel model) throws Exception {
	    return apiguideService.saveCmmApiKeyMng(model);
	 }
	 
	 @RequestMapping(value = "/apiguide/selectApiInfo")
	 @ResponseBody
	 public AjaxModel selectApiInfo(AjaxModel model) throws Exception {
	    return apiguideService.selectApiInfo(model);
	 }
}
