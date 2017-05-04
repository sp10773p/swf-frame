package kr.pe.frame.exp.req.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

public interface UplService {

	/**
     * 수출신고업로드 목록조회
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel selectDecExcelList(AjaxModel model) throws Exception;
	

   /**
    * 수출신고 엑셀업로드
    * @param model
    * @return
    * @throws Exception
    */

   AjaxModel uploadDecExcel(AjaxModel model) throws Exception;




}