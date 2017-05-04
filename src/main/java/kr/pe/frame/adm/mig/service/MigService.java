package kr.pe.frame.adm.mig.service;


import kr.pe.frame.cmm.core.model.AjaxModel;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 이관관리 Service 추상클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MigServiceImpl
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
public interface MigService {

    /**
     * 테이블변경 조회
     * @param model
     * @return
     */
    AjaxModel selectTabModList(AjaxModel model);

    /**
     * 변경컬럼 정보 조회
     * @param model
     * @return
     */
    AjaxModel selectTabColModList(AjaxModel model);

    /**
     * AS-IS/TO-BE INDEX 조회
     * @param model
     * @return
     */
    AjaxModel selectTabIndexList(AjaxModel model);

    /**
     * 변경테이블이관 저장
     * @param model
     * @return
     */
    AjaxModel saveMigTableMng(AjaxModel model);

    /**
     * 엑셀 업로드 처리
     * @param request
     * @return
     * @throws Exception
     */
    AjaxModel saveDataMig(HttpServletRequest request) throws Exception;

    /**
     * 인터페이스매핑 저장
     * @param model
     * @return
     */
    AjaxModel updateDataMig(AjaxModel model);

    /**
     * SCRIPT 조회
     * @param model
     * @return
     */
    AjaxModel selectScript(AjaxModel model);

    /**
     * 매핑정의서 엑셀 다운로드
     * @param request
     * @param response
     * @throws Exception
     */
    void printReport(HttpServletRequest request, HttpServletResponse response) throws Exception;

    /**
     * 이관스크립트 다운로드
     * @param request
     * @param response
     */
    void scriptDownload(HttpServletRequest request, HttpServletResponse response) throws IOException;

    /**
     * 이관 DATA Script 다운로드
     * @param request
     * @param response
     */
    void printScript(HttpServletRequest request, HttpServletResponse response) throws IOException;
}