package kr.pe.frame.pcr.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

public interface PcrService {
	AjaxModel selectPcrLic(AjaxModel model) throws Exception;
	
	public AjaxModel uploadTaxInvoice(AjaxModel model) throws Exception;
	
	AjaxModel savePcrLic(AjaxModel model) throws Exception;
	
	AjaxModel savePcrItemList(AjaxModel model) throws Exception;
	
	AjaxModel saveAllPcrLicCopyInfo(AjaxModel model) throws Exception;
	
	AjaxModel deletePcrLicList(AjaxModel model) throws Exception;
	
	AjaxModel savePcrDocAndItemList(AjaxModel model) throws Exception;
	
	AjaxModel deletePcrDocAndItemList(AjaxModel model) throws Exception;
	
	AjaxModel savePcrTaxInvoice(AjaxModel model) throws Exception;
	
	AjaxModel savePcrSend(AjaxModel model) throws Exception;

}
