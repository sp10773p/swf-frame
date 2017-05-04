package kr.pe.frame.adm.sys.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 시스템관리 > 권한관리 Service 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AuthServiceImpl
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
public interface AuthService {

	/**
	 * 권한정보 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveAuth(AjaxModel model) throws Exception;

	/**
	 * 메뉴별 버튼권한 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	AjaxModel saveBtnAuth(AjaxModel model) throws Exception;

	/**
	 * 권한 삭제
	 * @param model
	 * @return
	 */
	AjaxModel deleteAuth(AjaxModel model);
}