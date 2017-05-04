package kr.pe.frame.apiguide.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 포털 > API관리 Service
 * @author 정안균
 * @since 2017-03-30
 * @version 1.0
 * @see ApiguideServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.30  정안균  최초 생성
 *
 * </pre>
 */
public interface ApiguideService {
	
	AjaxModel selectCmmApiKeyMng(AjaxModel model) throws Exception;
	
	AjaxModel saveCmmApiKeyMng(AjaxModel model) throws Exception;
	
	AjaxModel selectApiInfo(AjaxModel model) throws Exception;
}
