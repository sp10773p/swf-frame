package kr.pe.frame.adm.edi.service;


import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 송수신이력 처리 Service
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
public interface EdiService {
	/**
	 * 송수신이력 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectSendRecvList(AjaxModel model);

	/**
	 * 송수신이력 상세 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectSendRecv(AjaxModel model) throws Exception;

	/**
	 * 재처리
	 * @param model
	 * @return
	 */
	AjaxModel docReRecv(AjaxModel model) throws Exception;

	/**
	 * 전송이벤트 목록 조회
	 * @param model
	 * @return
	 */
	AjaxModel selectSendRecvEvtList(AjaxModel model);

	/**
	 * 전송요청
	 * @param reqs
	 * @return
	 */
	AjaxModel sendDoc(AjaxModel reqs) throws BizException;
}