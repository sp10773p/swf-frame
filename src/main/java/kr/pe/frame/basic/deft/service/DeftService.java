package kr.pe.frame.basic.deft.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 사용자 화면: 기본정보 > 신고서 기본값 추상 클래스
 * @author 정안균
 * @since 2017-03-02
 * @version 1.0
 * @see DeftServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.02  정안균  최초 생성
 *
 * </pre>
 */
public interface DeftService {
	/**
	 * 신고서 기본값 조회
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel selectBaseVal(AjaxModel model) throws Exception;
	
	/**
	 * 신고서 기본값 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveBaseVal(AjaxModel model) throws Exception;
}
