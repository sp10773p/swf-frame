package kr.pe.frame.exp.imp.service;


import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 반품수입 처리 Service
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@SuppressWarnings("rawtypes")
public interface ImpService {
	/**
	 * 반품수입신고 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpReqList(AjaxModel model);

	/**
	 * 반품수입신고 상세 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpReq(AjaxModel model);

	/**
	 * 반품수입신고 삭제
	 * @param model
	 * @return
	 */
	AjaxModel deleteImpReqs(AjaxModel model) throws Exception;
	
	/**
	 * 반품수입의뢰 수출제품정보 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpReqItemList(AjaxModel model);

	/**
	 * 반품수입신고 수출제품정보 삭제
	 * @param model
	 * @return
	 */
	AjaxModel deleteImpReqItems(AjaxModel model) throws Exception;	
	
	/**
	 * 반품수입신고 수출제품정보 생성
	 * @param model
	 * @return
	 */
	AjaxModel createImpReqItems(AjaxModel model) throws Exception;	
	
	/**
	 * 반품수입의뢰 저장
	 * @param model
	 * @return
	 */
	AjaxModel saveImpReq(AjaxModel model) throws Exception;
	
	/**
	 * 반품수입의뢰 저장(Open API)
	 * @param model
	 * @return
	 */
	void saveImpReqApi(Map req) throws Exception;
	
	/**
	 * 반품수입의뢰 메일전송
	 * @param model
	 * @return
	 */
	AjaxModel sendImpReq(AjaxModel model) throws Exception;	
	
	/**
	 * 수출신고 의뢰파일다운로드
	 * @param model
	 * @return
	 */
	AjaxModel downloadImpReq(String reqNo) throws Exception;
	
	/**
	 * 반품수입의뢰 파일 업로드
	 * @param model
	 * @return
	 */
	AjaxModel saveImpReqFile(AjaxModel model) throws Exception;
	
	/**
	 * 수출신고 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectExpItemList(AjaxModel model);	
	
    // 수입신고결과 조회
	/**
	 * 수입신고결과 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpResList(AjaxModel model);

	/**
	 * 수입신고결과 상세 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpRes(AjaxModel model);	

	/**
	 * 수입신고결과 란 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpResRanList(AjaxModel model);			

	/**
	 * 수입신고결과 란 아이템 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpResRanItemList(AjaxModel model);			
	
	/**
	 * 수입신고결과 파일 업로드
	 * @param model
	 * @return
	 */
	AjaxModel uploadResFile(HttpServletRequest request) throws Exception;
	
	// KOTRA return
	/**
	 * KOTRA WMS 반품 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpKotraList(AjaxModel model);
	
	/**
	 * KOTRA WMS 반품 다운로드(양식)
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	void downloadImpKotra(List<String> regNos, ServletOutputStream out) throws Exception;	

	/**
	 * KOTRA WMS 반품 상세 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpKotra(AjaxModel model);

	/**
	 * KOTRA WMS 반품 삭제
	 * @param model
	 * @return
	 */
	AjaxModel deleteImpKotras(AjaxModel model) throws Exception;	
	
	
	/**
	 * KOTRA 간이수출신고정보 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectImpKotraItemList(AjaxModel model);

	/**
	 * KOTRA 간이수출신고정보 삭제
	 * @param model
	 * @return
	 */
	AjaxModel deleteImpKotraItems(AjaxModel model) throws Exception;	
	
	/**
	 * KOTRA 간이수출신고정보 생성
	 * @param model
	 * @return
	 */
	AjaxModel createImpKotraItems(AjaxModel model) throws Exception;	
	
	/**
	 * KOTRA WMS 저장
	 * @param model
	 * @return
	 */
	AjaxModel saveImpKotra(AjaxModel model) throws Exception;
}