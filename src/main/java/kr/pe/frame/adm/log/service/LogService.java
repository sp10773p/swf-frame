package kr.pe.frame.adm.log.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 관리자 > 로그관리 Service
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see LogServiceImpl
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
public interface LogService {

	/**
	 * 로그 상세 내용 조회
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel selectParam(AjaxModel model) throws Exception;

	/**
	 * 로그제외 추가
	 * @param model
	 * @return
	 */
    AjaxModel saveLogPass(AjaxModel model);

	/**
	 * 로그필터관리 저장
	 * @param model
	 * @return
	 */
    AjaxModel saveLogFilter(AjaxModel model);
}