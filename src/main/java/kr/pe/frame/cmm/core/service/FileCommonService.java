package kr.pe.frame.cmm.core.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 파일처리 공통 서비스 추상 클래스
 * @author 성동훈
 * @since 2017-01-03
 * @version 1.0
 * @see FileCommonServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.03  성동훈  최초 생성
 *
 * </pre>
 */
public interface FileCommonService {

    /**
     * 파일 삭제 처리
     * @param model
     * @return
     */
    AjaxModel deleteFiles(AjaxModel model);

    /**
     * 파일 다운로드
     * @param request
     * @param response
     * @throws Exception
     */
    void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception;

    /**
     * 파일 업로드
     * @param request
     * @return
     * @throws IOException
     */
    AjaxModel uploadFiles(HttpServletRequest request) throws IOException;

    /**
     * N건 ATCH_FILE_ID로 파일 삭제처리
     * @param attchFileIdList
     * @return
     */
    boolean deleteAttachFileId(List<String> attchFileIdList);

    /**
     * ATCH_FILE_ID로 파일 삭제처리
     * @param attchFileId
     * @return
     */
    boolean deleteAttachFileId(String attchFileId);

    /**
     * 파일 업로드 경로 반환
     * @return
     */
    String getUploadFilePath(String fileUploadScreenDiv);

    /**
     * 파일 다운로드 경로 반환
     * @return
     */
    String getDownloadFilePath(String fileUploadScreenDiv);
}
