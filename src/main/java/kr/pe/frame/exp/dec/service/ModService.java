package kr.pe.frame.exp.dec.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

import java.util.Map;

public interface ModService {
	
	void createExpModiDoc(Map<String, Object> inVar, Map<String, Object> outVar) throws Exception;
	
	/**
     * 수출정정 전송
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel saveExpDmrSend(AjaxModel model) throws Exception ;
}