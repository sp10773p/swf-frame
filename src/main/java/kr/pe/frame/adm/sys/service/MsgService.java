package kr.pe.frame.adm.sys.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 시스템관리 > 알림메시지관리 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MsgServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.05  성동훈  최초 생성
 *
 * </pre>
 */
public interface MsgService {

	/**
	 * 알림 메시지 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveMessage(AjaxModel model) throws Exception;

}