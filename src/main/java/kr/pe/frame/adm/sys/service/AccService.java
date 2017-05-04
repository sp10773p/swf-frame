package kr.pe.frame.adm.sys.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 접속 로그 정보(Access Log) Service 추상클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AccServiceImpl
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
public interface AccService {

	/**
	 * 접속 로그 정보 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveIpAccess(AjaxModel model) throws Exception;

}