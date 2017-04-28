package kr.pe.frame.exp.req.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

public interface ReqService {

	/**
     * 수출신고요청 목록조회
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel selectDecReqList(AjaxModel model) throws Exception;
	

}