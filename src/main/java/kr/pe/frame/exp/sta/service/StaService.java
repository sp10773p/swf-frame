package kr.pe.frame.exp.sta.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 수출실적 & 현황 조회 Service
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
public interface StaService {
	/**
	 * 수출실적명세요청 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectExpStaReqList(AjaxModel model);

	/**
	 * 수출실적명세요청 상세 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectExpStaReq(AjaxModel model);
	
	/**
	 * 수출실적명세요청 저장
	 * @param model
	 * @return
	 */
	AjaxModel saveExpStaReq(AjaxModel model) throws Exception;	
}