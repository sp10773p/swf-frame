package kr.pe.frame.basic.info.service;


import kr.pe.frame.basic.info.controller.SelController;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 기본정보 > 상품정보조회 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see SelController , SelServiceImpl
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
public interface SelService {

    /**
     * 상품정보 저장
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel saveSellItem(AjaxModel model) throws Exception;

    /**
     * 신고서기본값 저장
     * @param model
     * @return
     */
    AjaxModel saveBaseval(AjaxModel model);

    /**
     * 신고인신고서기본값 저장
     * @param model
     * @return
     */
    AjaxModel saveDecBaseval(AjaxModel model);

    /**
     * HS코드 저장
     * @param model
     * @return
     */
    AjaxModel saveHsCode(AjaxModel model);


}