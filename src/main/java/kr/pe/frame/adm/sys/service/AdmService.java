package kr.pe.frame.adm.sys.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 시스템관리 > 어드민관리 Service 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AdmServiceImpl
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
public interface AdmService {

	/**
	 * 어드민사용자 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveAdmUser(AjaxModel model) throws Exception;

	/**
	 * 어드민사용자 삭제
	 * @param model
	 * @return
	 */
    AjaxModel deleteAdminUser(AjaxModel model);
}