package kr.pe.frame.adm.ntc.service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 게시판 Service 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see NtcServiceImpl
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
public interface BoardService {

	/**
	 * 게시판 저장
	 * @param model
	 * @return
	 */
	AjaxModel save(AjaxModel model) throws BizException;

	/**
	 * 게시판 삭제
	 * @param model
	 * @return
	 */
	AjaxModel delete(AjaxModel model) throws BizException;
}