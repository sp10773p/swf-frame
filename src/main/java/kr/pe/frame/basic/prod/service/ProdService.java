package kr.pe.frame.basic.prod.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 사용자 화면: 기초정보 > 상품관리 추상 클래스
 * @author 정안균
 * @since 2017-03-08
 * @version 1.0
 * @see ProdServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.08  정안균  최초 생성
 *
 * </pre>
 */
public interface ProdService {
	AjaxModel saveItemInfo(AjaxModel model) throws Exception;

	AjaxModel uploadItemInfoExcel(AjaxModel model) throws Exception;

}
