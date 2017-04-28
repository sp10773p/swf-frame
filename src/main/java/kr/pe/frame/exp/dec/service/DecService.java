package kr.pe.frame.exp.dec.service;


import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.cmm.core.model.AjaxModel;
import org.json.simple.JSONObject;

@SuppressWarnings("rawtypes")
public interface DecService {
	/**
     * 수출신고 전송
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveExpDecSend(AjaxModel model) throws Exception ;
	
	/**
     * 수출신고요청
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveExpDecReq(AjaxModel model) throws Exception;
    
    /**
     * 수출신고 정정
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveExpDecMod(AjaxModel model) throws Exception;
     
	/**
	 * 수출신고 취하
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveExpDecCancel(AjaxModel model) throws Exception;
  
	 /**
	  * 수출신고 기간연장
	  * @param model
	  * @return
	  * @throws Exception
	  */
	AjaxModel saveExpDecTerm(AjaxModel model) throws Exception;
   
	/**
	  * 수출신고 수정
	  * @param model
	  * @return
	  * @throws Exception
	  */
	AjaxModel saveExpDecAll(AjaxModel model) throws Exception ;
	
	/**
	  * 수출정정취하신고 수정
	  * @param model
	  * @return
	  * @throws Exception
	  */
	AjaxModel saveModExpDecAll(AjaxModel model) throws Exception ;
	
	/**
	  * 수출정정취하신고 정정내역생성
	  * @param model
	  * @return
	  * @throws Exception
	  */
	AjaxModel saveModExpDecDtl(AjaxModel model) throws Exception ;

	/**
	 * 수출신고서 생성
	 * @param model
	 * @throws Exception
	 */
	void saveGenerateExpDoc(AjaxModel model, String gbn) throws Exception ;
	
	/**
	 * RPT NO 채번
	 * @param model
	 * @throws Exception
	 */
	String makeRptNo(Map<String, Object> expReqInfo, String docId);
	
	
	/**
	 * 신고서 Main 생성
	 * @param 
	 * @throws Exception
	 */
	DocumentCheckMap makeMain(Map<String, Object> orgReq, BaseValueMap baseValueMap, String inputType);
	
	/**
	 * 신고서 란 생성
	 * @param 
	 * @throws Exception
	 */
	DocumentCheckMap makeRans(List orgReqList, BaseValueMap baseValueMap, String exchangeRateStr, String inputType, JSONObject jsonOBJ);
	
	/**
	 * 신고서 모델 생성
	 * @param 
	 * @throws Exception
	 */	
	DocumentCheckMap makeModels(List orgReqList, BaseValueMap baseValueMap, String exchangeRateStr, String inputType, JSONObject jsonOBJ);
			
	/**
	 * 환율 및 신고가 계산
	 * @param 
	 * @throws Exception
	 */
	CalcCheckMap calculateAmt(Map<String, Object> expReqInfo, int ranCnt, String rptDay, List<Map<String, Object>> expReqRanList);
	
	/**
	 * 유효성 검사
	 * @param 
	 * @throws Exception
	 */
	DocumentCheckMap validationTotal(Map<String, Object> docExpMain, BigDecimal sumNetWeight, Map<String, Object> expReqInfo, String errMsg);
	
	/**
	 * 제출번호 생성
	 * @param 
	 * @throws Exception
	 */
	DocumentCheckMap getRptNo(Map<String, Object> expReqInfo, String reqNo, String errMsg);
	
	/**
	 * 수출신고 의뢰파일다운로드
	 * @param model
	 * @return
	 */
	AjaxModel downloadExpReq(String reqNo) throws Exception;
	
	/**
	 * 수출수리정보 파일 업로드
	 * @param model
	 * @return
	 */
	AjaxModel uploadResFile(HttpServletRequest request) throws Exception;
	
	/**
	  * 수출이행내역 조회
	  * @param model
	  * @return
	  * @throws Exception
	  */
	AjaxModel selectRunHis(AjaxModel model) throws Exception ;
}