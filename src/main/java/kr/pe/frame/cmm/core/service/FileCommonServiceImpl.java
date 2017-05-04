package kr.pe.frame.cmm.core.service;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.util.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 파일처리 공통 서비스 추상 클래스 구현
 * @author 성동훈
 * @since 2017-01-03
 * @version 1.0
 * @see FileCommonService
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
@Service(value = "fileCommonService")
public class FileCommonServiceImpl implements FileCommonService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonService")
    CommonService commonService;

    @Resource(name = "commonDAO")
    CommonDAO commonDAO;

    @Autowired
    WebApplicationContext webApplicationContext;

    @Value("#{config['file.upload.path']}")
    private String UPLOAD_FILE_HOMEPATH;

    @Value("#{config['file.download.path']}")
    private String DOWNLOAD_FILE_HOMEPATH;

    private String FOLDER_DIV_CHAR = "/";


    /**
     * {@inheritDoc}
     */
    @Override
    public AjaxModel deleteFiles(AjaxModel model) {
        List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }

        String attachFileId = null;
        for(Map<String, Object> fileInfo : dataList){
            if(fileInfo.get("FILE_STRE_COURS") == null || fileInfo.get("STRE_FILE_NM") == null || fileInfo.get("ORIGNL_FILE_NM") == null){
                fileInfo = (Map)commonDAO.select("file.selectFileInfo", model.getData());

                if(fileInfo == null) continue;
            }

            String savePath     = (String) fileInfo.get("FILE_STRE_COURS");
            String streFileNm   = (String) fileInfo.get("STRE_FILE_NM");

            if(attachFileId == null){
                attachFileId = (String)fileInfo.get("ATCH_FILE_ID");
            }

            File file = new File(savePath + streFileNm);
            if(file.exists()){
                file.delete();
            }else{
                logger.error("파일이 존재 하지 않음 : " + file.getPath());
            }

            commonDAO.delete("file.deleteFileInfo", fileInfo);
        }

        // 디테일이 0건이면 마스터 삭제
        commonDAO.delete("file.deleteFileMst", attachFileId);

        model.getData().put("ATCH_FILE_ID", commonDAO.select("file.selectFileDtlMaxAtchfileid", attachFileId));
        model.getData().put(Constant.POST_TYPE.getCode(), Constant.POST_DELETE.getCode());

        model = executePostService(model); // POST_SERVICE 실행
        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String atchFileId = request.getParameter("ATCH_FILE_ID");
        String fileSn 	  = request.getParameter("FILE_SN");

        Map<String, String> param = new HashMap<>();
        param.put("ATCH_FILE_ID", atchFileId);
        param.put("FILE_SN"     , fileSn);

        Map<String, Object> fileInfo = (Map) commonDAO.select("file.selectFileInfo", param);

        String savePath     = (String) fileInfo.get("FILE_STRE_COURS");
        String streFileNm   = (String) fileInfo.get("STRE_FILE_NM");
        String orignlFileNm = (String) fileInfo.get("ORIGNL_FILE_NM");

        File file = new File(savePath + streFileNm);

        if(file.exists()){
            try(ServletOutputStream out = response.getOutputStream();
                BufferedInputStream in =  new BufferedInputStream(new FileInputStream(file))){

                byte[] buffer = new byte[1024];

                response.setContentType("utf-8");
                response.setContentType("application/octet-stream");
                response.setHeader("Accept-Ranges", "bytes");
                response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(orignlFileNm,StandardCharsets.UTF_8.toString())+";");
                long len = file.length();

                response.setContentLength((int)len);

                int n = 0;
                while ((n = in.read(buffer, 0, 1024)) != -1) {
                    out.write(buffer, 0, n);
                }// while
            }
        }else{
            try(OutputStream out = response.getOutputStream()){
                String errorText = "<script>alert('" + commonService.getMessage("W00000008") +"');</script>"; // 파일이 존재하지 않습니다.
                out.write(errorText.getBytes("utf-8"));
                out.flush();
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public AjaxModel uploadFiles(HttpServletRequest request) throws IOException {
        String fileUploadScreenDiv = request.getParameter("FILE_UPLOAD_SCREEN_DIV");
        String attachFileId        = request.getParameter("ATCH_FILE_ID");
        String filePath  = null;

        String storedFileLocation = getUploadFilePath(fileUploadScreenDiv);

        File serverFile = new File(storedFileLocation);
        if (!serverFile.exists() || serverFile.isFile()) {
            serverFile.mkdirs();
        }

        if(StringUtil.isEmpty(attachFileId)){
            Map<String, String> fileMst = new HashMap<>();
            commonDAO.insert("file.insertCmmFileMst", fileMst);
            attachFileId = fileMst.get("ATCH_FILE_ID");
        }

        List<Map<String, Object>> resultList = new ArrayList<>();

        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();


        String originalFileName      = null;
        String originalFileExtension = null;
        String storedFileName        = null;

        long fileSize = 0;

        while (iterator.hasNext()) {
            String fileName = iterator.next();
            if(multipartHttpServletRequest.getFile(fileName).isEmpty()){
                continue;
            }

            List<MultipartFile> fileList = multipartHttpServletRequest.getFiles(fileName);
            for(MultipartFile multipartFile : fileList){
                originalFileName      = multipartFile.getOriginalFilename();
                originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
                storedFileName        = getTimeStamp();

                fileSize = multipartFile.getSize();

                Map<String, Object> fileDtl = new HashMap<>();
                fileDtl.put("ATCH_FILE_ID"   , attachFileId);
                fileDtl.put("FILE_STRE_COURS", storedFileLocation);
                fileDtl.put("STRE_FILE_NM"   , storedFileName);
                fileDtl.put("ORIGNL_FILE_NM" , originalFileName);
                fileDtl.put("FILE_EXTSN"     , originalFileExtension);
                fileDtl.put("FILE_MG"        , Long.toString(fileSize));
                fileDtl.put("FILE_USE_GB"    , "05");

                commonDAO.insert("file.insertCmmFileDtl", fileDtl);

                storedFileName = storedFileName + (String)fileDtl.get("FILE_SN");
                filePath = storedFileLocation + File.separator + storedFileName;

                File file = new File(filePath);
                multipartFile.transferTo(file);

                resultList.add(fileDtl);
            }
        }
        
        Map<String, Object> data = new HashMap<String, Object>();
        data.putAll(WebUtil.getParameterToObject(request));
        data.put("ATCH_FILE_ID", attachFileId);
        data.put(Constant.POST_TYPE.getCode(), Constant.POST_INSERT.getCode());

        UsrSessionModel sessionModel = commonService.getUsrSessionModel(request);

        AjaxModel model = new AjaxModel();
        model.setUsrSessionModel(sessionModel);
        model.setData(data);
        model.setDataList(resultList);

        model = executePostService(request, model); // POST_SERVICE 실행
        model.setCode("I00000017"); // 파일업로드 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean deleteAttachFileId(List<String> attchFileIdList) {
        StringBuffer sb = new StringBuffer();
        for(String attchFileId : attchFileIdList){
            sb.append("'").append(attchFileId).append("',");
        }

        sb = new StringBuffer(sb.substring(0, sb.length()-1));

        List<String> fileNames = commonDAO.list("file.selectFileNameList", sb.toString());

        for(String fileName : fileNames){
            File file = new File(fileName);
            if(file.exists()){
                file.delete();
            }else{
                logger.error("파일이 존재 하지 않음 : " + file.getPath());
            }
        }

        commonDAO.delete("file.deleteDtlFiles", sb.toString());
        commonDAO.delete("file.deleteMstFiles", sb.toString());

        return true;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean deleteAttachFileId(String attchFileId) {
        return deleteAttachFileId(Arrays.asList(attchFileId));
    }

    @Override
    public String getUploadFilePath(String fileUploadScreenDiv) {
        String storedFileLocation = UPLOAD_FILE_HOMEPATH + FOLDER_DIV_CHAR +  getUpFolderName() + FOLDER_DIV_CHAR;	// 저장 경로

        if(fileUploadScreenDiv == null || "".equals(fileUploadScreenDiv)){
            storedFileLocation = storedFileLocation + "DEF" + FOLDER_DIV_CHAR ;
        }else{
            storedFileLocation = storedFileLocation + fileUploadScreenDiv + FOLDER_DIV_CHAR ;
        }

        return storedFileLocation;
    }

    @Override
    public String getDownloadFilePath(String fileUploadScreenDiv) {
        String storedFileLocation = DOWNLOAD_FILE_HOMEPATH + FOLDER_DIV_CHAR;	// 저장 경로

        if(fileUploadScreenDiv == null || "".equals(fileUploadScreenDiv)){
            storedFileLocation = storedFileLocation + "DEF" + FOLDER_DIV_CHAR ;
        }else{
            storedFileLocation = storedFileLocation + fileUploadScreenDiv + FOLDER_DIV_CHAR ;
        }

        return storedFileLocation;
    }

    /**
     * upload 디렉토리명을 반환
     * @return
     */
    private String getUpFolderName(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM", Locale.KOREA);
        java.util.Date dt = new java.util.Date();
        String mTime = sdf.format(dt);
        return mTime;
    }

    /**
     * upload 파일명 생성을 위한 문자열 반환
     * @return
     */
    private String getTimeStamp() {

        String rtnStr = null;

        // 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
        String pattern = "yyyyMMddhhmmssSSS";

        try {
            SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
            Timestamp ts = new Timestamp(System.currentTimeMillis());

            rtnStr = sdfCurrent.format(ts.getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rtnStr;
    }

    /**
     * 파일 업로드, 다운로드 후 Service 처리 실행
     * @param request
     * @param model
     * @return
     */
    private AjaxModel executePostService(HttpServletRequest request, AjaxModel model) {
        String postService = request.getParameter("POST_SERVICE");
        model.getData().put("POST_SERVICE", postService);

        return executePostService(model);
    }

    /**
     * 파일 업로드, 다운로드 후 Service 처리 실행
     * @param request
     * @param model
     * @return
     */
    private AjaxModel executePostService(AjaxModel model) {
        String postService = (model.getData().containsKey("POST_SERVICE") ? (String)model.getData().get("POST_SERVICE"): null);
        if(StringUtil.isNotEmpty(postService) && postService.indexOf(".") > 0){
            String[] serviceArr = postService.split("\\.");

            String beanName   = serviceArr[0];
            String methodName = serviceArr[1];

            if(webApplicationContext.containsBean(beanName)){
                Object serviceObject = webApplicationContext.getBean(beanName);

                Method method = ReflectionUtils.findMethod(serviceObject.getClass(), methodName, AjaxModel.class);
                if(method == null){
                    logger.error("POST_SERVICE로 등록한 서비스가 존재 하지 않습니다.");
                }else{
                    logger.debug("Execute Post Service : {}.{}",  beanName, methodName);
                    model = (AjaxModel) ReflectionUtils.invokeMethod(method, serviceObject, model);
                }

            }else{
                logger.error("POST_SERVICE로 등록한 서비스가 존재 하지 않습니다.");
            }
        }

        return model;
    }
}
