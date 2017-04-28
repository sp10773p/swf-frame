package kr.pe.frame.basic.prof.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 사용자 화면: 기초정보 > 회원 관리 추상 클래스
 * @author 정안균
 * @since 2017-03-07
 * @version 1.0
 * @see ProfServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.07  정안균  최초 생성
 *
 * </pre>
 */
public interface ProfService {
	AjaxModel saveUserInfo(AjaxModel model) throws Exception;
	
	AjaxModel saveUserWithdraw(AjaxModel model) throws Exception;
	
	AjaxModel updateCmmFileAttchId(AjaxModel model) throws Exception;
	
	AjaxModel saveEmailAuth(AjaxModel model) throws Exception;
    
    AjaxModel selectEmailAuth(AjaxModel model) throws Exception;
    
    AjaxModel selectUsr(AjaxModel model) throws Exception;
}
