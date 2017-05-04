package kr.pe.frame.pcr.controller;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.pcr.service.PcrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by jak on 2017-01-18.
 */
@Controller
public class PcrController {
	 Logger logger = LoggerFactory.getLogger(this.getClass());

	 @Resource(name = "pcrService")
     PcrService pcrService;
	 
	 @RequestMapping(value = "/pcr/selectPcrLic")
	 @ResponseBody
	 public AjaxModel saveUser(AjaxModel model) throws Exception {
	    return pcrService.selectPcrLic(model);
	 }
	 
	 @RequestMapping(value = "/pcr/selectPcrLicDetailInfo")
	 @ResponseBody
	 public AjaxModel selectPcrLicDetailInfo(AjaxModel model) throws Exception {
	    return pcrService.selectPcrLic(model);
	 }
	 
	 @RequestMapping(value = "/pcr/savePcrLic")
	 @ResponseBody
	 public AjaxModel savePcrLic(AjaxModel model) throws Exception {
	    return pcrService.savePcrLic(model);
	 }
	 
	 @RequestMapping(value = "/pcr/savePcrItemList")
	 @ResponseBody
	 public AjaxModel saveApiKeyDtl(AjaxModel model) throws Exception {
		 return pcrService.savePcrItemList(model);
	 }
	 
	 @RequestMapping(value = "/pcr/saveAllPcrLicCopyInfo")
	 @ResponseBody
	 public AjaxModel saveAllPcrLicCopyInfo(AjaxModel model) throws Exception {
		 return pcrService.saveAllPcrLicCopyInfo(model);
	 }
	 
	 @RequestMapping(value = "/pcr/deletePcrLicList")
	 @ResponseBody
	 public AjaxModel deletePcrLicList(AjaxModel model) throws Exception {
		 return pcrService.deletePcrLicList(model);
	 }
	 
	 @RequestMapping(value = "/pcr/savePcrDocAndItemList")
	 @ResponseBody
	 public AjaxModel savePcrDocAndItemList(AjaxModel model) throws Exception {
		 return pcrService.savePcrDocAndItemList(model);
	 }
	 
	 @RequestMapping(value = "/pcr/deltePcrDocAndItemList")
	 @ResponseBody
	 public AjaxModel deltePcrDocAndItemList(AjaxModel model) throws Exception {
		 return pcrService.deletePcrDocAndItemList(model);
	 }
	 
	 @RequestMapping(value = "/pcr/savePcrTaxInvoice")
	 @ResponseBody
	 public AjaxModel savePcrTaxInvoice(AjaxModel model) throws Exception {
	    return pcrService.savePcrTaxInvoice(model);
	 }
	 
	 @RequestMapping(value = "/pcr/savePcrSend")
	 @ResponseBody
	 public AjaxModel savePcrSend(AjaxModel model) throws Exception {
	    return pcrService.savePcrSend(model);
	 }

}
