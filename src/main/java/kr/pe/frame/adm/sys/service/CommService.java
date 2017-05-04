package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 시스템관리 > 공통코드관리 Service 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see CommServiceImpl
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
public interface CommService {
    /**
     * 마스터 코드 저장
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveMasterCode(AjaxModel model) throws Exception;

    /**
     * 마스터 코드 삭제
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel deleteMasterCode(AjaxModel model) throws Exception;

    /**
     * 디테일 코드 저장
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel saveDetailCode(AjaxModel model) throws Exception;

    /**
     * 디테일 코드 삭제
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel deleteDetailCode(AjaxModel model) throws Exception;
}
