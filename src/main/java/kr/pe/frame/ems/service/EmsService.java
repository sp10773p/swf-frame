package kr.pe.frame.ems.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;

import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * Created by kdh on 2017. 1. 10.
 */
public interface EmsService {

    // ========================================================================================================= //
    // =================================================픽업요청================================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * EMS 픽업요청 업로드내역 상세 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickExcelList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * EMS 픽업요청 처리내역 상세 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickReqList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * EMS 픽업요청 저장
     * @param model
     * @return
     * @throws Exception 
     */
    AjaxModel savePickReq(AjaxModel model) throws Exception;
    
    // ========================================================================================================= //
    // =============================================픽업요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 목록
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    // ========================================================================================================= //
    // =============================================픽업요청 상세정보============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 정보
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * EMS 픽업요청 상세정보 저장
     * @param model
     * @return
     * @throws Exception 
     */
    AjaxModel savePickDetailInfo(AjaxModel model) throws Exception;
    
    // --------------------------------------------------------------------------------------------------------- //
    // ------------------------------------------------엑셀업로드------------------------------------------------ //
    // --------------------------------------------------------------------------------------------------------- //
    
    /**
     * EMS 픽업요청 엑셀업로드
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */

    AjaxModel uploadPickExcel(AjaxModel model) throws Exception;
    
    /**
     * EMS 픽업요청 엑셀업로드 (SeaExpress)
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    
    AjaxModel uploadPickSeaExcel(AjaxModel model) throws Exception;
    

    // ========================================================================================================= //
    // ==================================================합배송================================================== //
    // ========================================================================================================= //

    /**
     * 합배송관리 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickMergeMasterList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * 합배송관리 Sub 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickMergeDetailList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * 합배송추가 - 수출신고수리내역 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectPickMergeList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * 합배송추가 - 저장
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel savePickMerge(AjaxModel model) throws Exception;

    // ========================================================================================================= //
    // ==================================================기표지================================================== //
    // ========================================================================================================= //

    /**
     * EMS 기표지 출력대상 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectCovList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;
    
    /**
     * EMS 기표지 출력대상 Data 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectCovDataList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    // ========================================================================================================= //
    // =================================================배송현황================================================= //
    // ========================================================================================================= //

    /**
     * EMS 배송현황 리스트
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectStatList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * EMS 배송현황 상세 정보
     * @param model
     * @return
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    AjaxModel selectStatTraceDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException;

    /**
     * EMS 배송현황 실시간 조회
     * @param model
     * @return
     * @throws Exception 
     */
    AjaxModel saveRealTimeEmsTraceInfo(AjaxModel model) throws Exception;
}
