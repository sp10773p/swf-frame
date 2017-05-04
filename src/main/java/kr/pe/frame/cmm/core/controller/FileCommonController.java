package kr.pe.frame.cmm.core.controller;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.FileCommonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;

/**
 * 파일 처리 공통 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see
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
@Controller
public class FileCommonController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "fileCommonService")
    FileCommonService fileCommonService;


    @Resource(name = "commonService")
    CommonService commonService;

    /**
     * 파일 업로드 처리
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/uploadFiles")
    @ResponseBody
    public AjaxModel uploadFiles (HttpServletRequest request) throws Exception {
        return fileCommonService.uploadFiles(request);
    }

    /**
     * 파일 삭제 처리
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/deleteFiles")
    @ResponseBody
    public AjaxModel deleteFiles (AjaxModel model) throws Exception {
        return fileCommonService.deleteFiles(model);
    }

    /**
     * 파일 다운로드 처리
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/common/fileDownload")
    public void doDownload (HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            fileCommonService.downloadFile(request, response);

        }catch(Exception ex){
            logger.error("{}", ex);

            String errorMsg = commonService.getMessage("E00000003");
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(("<script>alert('" + errorMsg + "');</script>").getBytes());
            outputStream.flush();
        }
    }
}
