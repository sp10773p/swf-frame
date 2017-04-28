package kr.pe.frame.basic.cust.service;

import kr.pe.frame.basic.deft.service.DeftServiceImpl;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 사용자 화면: 기초정보 > 거래처 관리 추상 클래스
 * @author 정안균
 * @since 2017-03-06
 * @version 1.0
 * @see DeftServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.06  정안균  최초 생성
 *
 * </pre>
 */
public interface CustService {
	AjaxModel saveCust(AjaxModel model) throws Exception;
	
	AjaxModel deleteCustList(AjaxModel model) throws Exception;

}
