package kr.pe.frame.xpr.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * Created by kdh on 2017. 1. 10.
 */
public interface XprService {

    // ========================================================================================================= //
    // =================================================배송요청================================================= //
    // ========================================================================================================= //
    
    /**
     * 주거래특송사 코드 조회
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel getMainExpressCode(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 업로드내역 상세 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipExcelList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * 특송 배송요청 엑셀업로드
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */

    AjaxModel uploadShipExcel(AjaxModel model) throws Exception;
    
    /**
     * 특송 배송요청 저장 (상태)
     * @param model
     * @return
     * @throws Exception 
     */
    AjaxModel saveShipReq(AjaxModel model) throws Exception;
    

    // ========================================================================================================= //
    // =============================================배송요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 상세 목록
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    // ========================================================================================================= //
    // =============================================배송요청 상세정보============================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 상세 정보
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 상세정보 저장
     * @param model
     * @return
     * @throws Exception 
     */
    AjaxModel saveShipDetailInfo(AjaxModel model) throws Exception;
    
    // ========================================================================================================= //
    // =================================================특송사용================================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 조회
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipReqList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 상세 조회
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipReqDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 접수확인 (상태)
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel saveShipReqStatus(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 특송 배송요청 내역 (셀러/특송사)
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectShipReqFieldsList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
}
