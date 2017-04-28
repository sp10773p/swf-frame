package kr.pe.frame.basic.my.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 기본정보 > 내정보관리 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see InfoServiceImpl
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
public interface InfoService {

    /**
     * 내정보 저장
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel saveUser(AjaxModel model) throws Exception;

    /**
     * 탈퇴 요청
     * @param model
     * @return
     */
    AjaxModel saveWithOutReq(AjaxModel model);

    /**
     * 비밀번호 변경
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveModPw(AjaxModel model) throws Exception;
}