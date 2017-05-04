package kr.pe.frame.adm.mig.service;

import kr.pe.frame.cmm.core.base.AbstractDAO;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.CommonUcpappDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.excel.*;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.cmm.util.WebUtil;
import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

/**
 * 이관관리 Service 구현클래스
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
@Service(value = "migService")
public class MigServiceImpl implements MigService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonUcpappDAO")
    private CommonUcpappDAO commonUcpappDAO;

    @Value("#{config['file.download.path']}")
    private String downloadPath;

    private RGBColor colors = null;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel selectTabModList(AjaxModel model) {
        Map param = model.getData();

        List<Map<String, String>> migTableList = selectTableMigMngList(null);

        if(migTableList == null || migTableList.size() == 0){
            model.setDataList(new ArrayList<Map<String, Object>>());
            model.setTotal(0);
            return model;
        }

        StringBuilder asisTableNames = new StringBuilder();
        StringBuilder tobeTableNames = new StringBuilder();
        // ASIS 테이블 목록 IN 조건절 생성
        for(Map<String, String> map : migTableList){
            asisTableNames.append("'").append(map.get("ASIS_TABLE")).append("',");
            tobeTableNames.append("'").append(map.get("TOBE_TABLE")).append("',");
        }

        // ASIS 테이블 컬럼정보 쿼리 문자열
        List<String> list = commonUcpappDAO.list("mig.selectAsisTableColumnInfoStrList", asisTableNames.substring(0, asisTableNames.length()-1));

        StringBuilder sb = new StringBuilder();
        for(String colStr : list){
            sb.append(colStr);
        }

        Map<String, Object> parmas = new HashMap<>();

        String migType = (String)param.get("P_MIG_TYPE");
        parmas.put("IS_COL_MOD"      , param.get("IS_COL_MOD"));
        parmas.put("SEARCH_TXT"      , param.get("SEARCH_TXT"));
        parmas.put("SEARCH_COL"      , param.get("SEARCH_COL"));
        parmas.put("P_MIG_TYPE"      , migType);
        parmas.put("ASIS_QUERY"      , (sb.length() > 0 ? sb.toString().substring(0, sb.length() - 10) : "SELECT '' ASIS_TABLE_NAME,'' ASIS_COLUMN_NAME,'' ASIS_DATA_TYPE,'' ASIS_DATA_LENGTH,'' ASIS_NULLABLE FROM DUAL"));
        parmas.put("TOBE_TABLE_NAMES", tobeTableNames.substring(0, tobeTableNames.length()-1));


        String strPageIndex = String.valueOf(param.get("PAGE_INDEX"));
        String strPageRow   = String.valueOf(param.get("PAGE_ROW"));
        int nPageIndex = 0;
        int nPageRow   = Integer.parseInt(Constant.DEFAULT_PAGE_ROW.getCode());

        if(!StringUtil.isEmpty(strPageIndex)){
            nPageIndex = Integer.parseInt(strPageIndex);
        }
        if(!StringUtil.isEmpty(strPageRow)){
            nPageRow = Integer.parseInt(strPageRow);
        }
        parmas.put("PAGE_INDEX", strPageIndex);
        parmas.put("PAGE_ROW"  , strPageRow);
        parmas.put("START", (nPageIndex * nPageRow) + 1);
        parmas.put("END"  , (nPageIndex * nPageRow) + nPageRow);
        parmas.put("ROWS" , nPageRow);

        // 결과조회
        List<Map<String, Object>> result;
        if("N".equals(migType)){ // 신규생성
            result = commonDAO.list("mig.selectNewTableColumnInfoList", parmas);
        }else{
            result = commonDAO.list("mig.selectTableColumnInfoList", parmas);
        }

        // 조회쿼리에 TOTAL COUNT 집계 컬럼 없이 카운트 쿼리 실행시 (COUNT(*) OVER() AS TOTAL_COUNT)
        if(result.size() > 0 && result.get(0).get("TOTAL_COUNT") != null) {
            model.setTotal(Integer.parseInt(String.valueOf(result.get(0).get("TOTAL_COUNT"))));
        }

        model.setDataList(result);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel selectTabColModList(AjaxModel model) {
        Map param = model.getData();

        String asisTableName = (String)param.get("ASIS_TABLE_NAME");
        String tobeTableName = (String)param.get("TOBE_TABLE_NAME");
        // ASIS 테이블 컬럼정보 쿼리 문자열
        List<String> list = commonUcpappDAO.list("mig.selectAsisTableColumnInfoStrList", "'" + asisTableName + "'");

        StringBuilder sb = new StringBuilder();
        for(String colStr : list){
            sb.append(colStr);
        }

        Map<String, String> queryParam = new HashMap<>();

        queryParam.put("ASIS_QUERY", sb.toString().substring(0, sb.length() - 10));
        queryParam.put("TOBE_TABLE_NAMES", "'" + tobeTableName + "'");

        queryParam.put("TOBE_TABLE_NAME", (String)param.get("TOBE_TABLE_NAME"));
        queryParam.put("ASIS_TABLE_NAME", (String)param.get("ASIS_TABLE_NAME"));

        // 결과조회
        List<Map<String, Object>> result = commonDAO.list("mig.selectTableColModInfoList", queryParam);

        // 조회쿼리에 TOTAL COUNT 집계 컬럼 없이 카운트 쿼리 실행시 (COUNT(*) OVER() AS TOTAL_COUNT)
        if(result.size() > 0 && result.get(0).get("TOTAL_COUNT") != null) {
            model.setTotal(Integer.parseInt(String.valueOf(result.get(0).get("TOTAL_COUNT"))));
        }

        model.setDataList(result);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel selectTabIndexList(AjaxModel model) {
        Map param = model.getData();

        Map<String, String> queryParam = new HashMap<>();
        queryParam.put("TABLE_NAME", (String)param.get("TOBE_TABLE_NAME"));

        AbstractDAO dao = commonDAO;
        if("ASIS".equals(param.get("TYPE"))){
            dao = commonUcpappDAO;
            queryParam.put("TABLE_NAME", (String)param.get("ASIS_TABLE_NAME"));
        }

        List<Map<String, Object>> result = dao.list("mig.selectTableIndexInfoList", queryParam);

        if(result.size() > 0 && result.get(0).get("TOTAL_COUNT") != null) {
            model.setTotal(Integer.parseInt(String.valueOf(result.get(0).get("TOTAL_COUNT"))));
        }

        model.setDataList(result);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveMigTableMng(AjaxModel model) {
        Map param = model.getData();

        String saveMode = (String)param.get("SAVE_MODE");

        int cnt = 0;

        String asisTableName = (String)param.get("ASIS_TABLE");
        if(StringUtil.isNotEmpty(asisTableName)){
            cnt = Integer.parseInt(String.valueOf(commonUcpappDAO.select("mig.selectTableCount", asisTableName)));

            if(cnt == 0){
                model.setMsg("존재하지 않는 AS-IS 테이블입니다.");
                return model;
            }
        }

        String tobeTableName = (String)param.get("TOBE_TABLE");
        cnt = Integer.parseInt(String.valueOf(commonDAO.select("mig.selectTableCount", tobeTableName)));

        if(cnt == 0){
            model.setMsg("존재하지 않는 TO-BE 테이블입니다.");
            return model;
        }

        if("I".equals(saveMode)){
            cnt = Integer.parseInt(String.valueOf(commonDAO.select("mig.selectMigTableMngCount", param)));
            if(cnt > 0){
                model.setMsg("이미 존재하는 데이터입니다.");
                return model;
            }

            commonDAO.insert("mig.insertMigTableMng", param);
        }else{
            commonDAO.update("mig.updateMigTableMng", param);
        }

        model.setCode("I00000003"); //저장 되었습니다.

        return model;
    }

    /**
     * 변경테이블 정보 조회
     * @param param
     * @return
     */
    private List selectTableMigMngList(Map<String, Object> param){
        return commonDAO.list("mig.selectMigTableList", param);
    }

    /**
     * {@inheritDoc}
     * @param request
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveDataMig(HttpServletRequest request) throws Exception {
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();

        Map<String, Object> retMap = new HashMap<>();

        while(iterator.hasNext()){
            String fileName = iterator.next();
            if(multipartHttpServletRequest.getFile(fileName).isEmpty()){
                continue;
            }

            List<MultipartFile> fileList = multipartHttpServletRequest.getFiles(fileName);
            for(MultipartFile multipartFile : fileList){
                InputStream in = multipartFile.getInputStream();
                ExcelReader excelReader = new ExcelReader();

                Sheet sheet = excelReader.getFirstSheet(in);
                List<List<String>> list = excelReader.parseExcelListSheet(sheet, 2, 1);

                int tobeTableNameIndex = 2;
                String tobeTableName = list.get(0).get(tobeTableNameIndex);
                commonDAO.delete("mig.deleteMigColMng", tobeTableName);

                retMap.put("TOBE_TABLE", tobeTableName);

                for (int k = 0 ; k < list.size(); k++){       // 자동 : 테이블 형태의 방식으로 출력
                    List<String> rowData = list.get(k);
                    // ASIS 테이블명/컬럼명이 없으면 pass
                    if(StringUtil.isEmpty(rowData.get(0)) || StringUtil.isEmpty(rowData.get(1))) {
                        continue;
                    }

                    Map<String, String> insertData = new HashMap<>();
                    for (int i = 0 ; i < rowData.size() ; i++){
                        String value = rowData.get(i);
                        value = (StringUtil.isEmpty(value) ? "" : value.trim());

                        String colId = null;

                        switch(i){
                            case 0 :
                                colId = "ASIS_TABLE";
                                break;
                            case 1 :
                                colId = "ASIS_COL";
                                break;
                            case 2 :
                                colId = "TOBE_TABLE";
                                break;
                            case 3 :
                                colId = "TOBE_COL";
                                break;
                            case 4 :
                                colId = "SUB";
                                break;
                            default :
                                break;
                        }

                        insertData.put(colId, value);
                    }

                    commonDAO.insert("mig.insertMigColMng", insertData);
                }
            }
        }

        AjaxModel model = new AjaxModel();
        model.setCode("I00000017"); // 파일업로드 되었습니다.
        model.setData(retMap);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel updateDataMig(AjaxModel model) {
        List<Map<String, Object>> dataList = model.getDataList();

        String tobeTableName = (String) dataList.get(0).get("TOBE_TABLE");
        commonDAO.delete("mig.deleteMigColMng", tobeTableName);

        for(Map<String, Object> data : dataList){
            commonDAO.insert("mig.insertMigColMng", data);
        }

        model.setCode("I00000003"); // 저장 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel selectScript(AjaxModel model) {
        Map<String, Object> param = model.getData();

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("RET_MAP", getQueryScript(param));
        model.setData(retMap);

        return model;
    }

    private String getQueryScript(Map<String, Object> param) {
        String dataMigType = (String)param.get("DATA_MIG_TYPE");
        String tobeTable   = (String)param.get("TOBE_TABLE");

        StringBuffer queryBuffer = new StringBuffer();
        //queryBuffer.append("SELECT 'INSERT 시작 : ").append(tobeTable).append("' FROM DUAL;\n");

        // 신규 이관
        if("N".equals(dataMigType)){
            param.put("STMT_CNT", (Integer.parseInt(String.valueOf(commonDAO.select("mig.selectTobeTableCount", param)))));
            String makeQueryStr = (String) commonDAO.select("mig.selectMakeQuery", param);
            List<String> list = commonDAO.list("mig.executeMakeQuery", makeQueryStr);

            for(String str : list){
                if(str == null || str.indexOf("null") > -1){

                    continue;
                }

                queryBuffer.append(str).append("\n");
            }

        // 1:1, N:1
        }else{
            String joinStr = (String)param.get("JOIN");
            String fromStr = (String)commonDAO.select("mig.selectAsisTable", param);
            List<Map<String, String>> sourceColList = commonDAO.list("mig.selectSourceColumn", param);

            if(sourceColList.size() == 0){
                return null;
            }
            StringBuffer asisColBuffer = new StringBuffer();
            StringBuffer tobeColBuffer = new StringBuffer();
            for(Map<String, String> colMap : sourceColList){
                String asisCol = colMap.get("ASIS_COL");
                String tobeCol = colMap.get("TOBE_COL");

                tobeColBuffer.append(tobeCol).append(",");
                asisColBuffer.append("          ").append(asisCol).append(",").append("\n");
            }
            tobeColBuffer = new StringBuffer(tobeColBuffer.substring(0, tobeColBuffer.length()-1));
            asisColBuffer = new StringBuffer(asisColBuffer.substring(0, asisColBuffer.length()-2));

            queryBuffer.append("INSERT INTO ").append(tobeTable).append("(").append(tobeColBuffer).append(")\n");
            queryBuffer.append("SELECT ").append("\n").append(asisColBuffer);
            queryBuffer.append("\n").append("  FROM ").append(fromStr).append("\n");
            if(StringUtil.isNotEmpty(joinStr)) {
                queryBuffer.append(" ").append(joinStr);
            }

            queryBuffer.append(";\n");
        }

        return queryBuffer.toString();
    }

    /**
     * {@inheritDoc}
     * @param request
     * @param response
     * @throws Exception
     */
    @Override
    public void printReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map param = WebUtil.getParameterToObject(request);

        HSSFWorkbook wb = new HSSFWorkbook();

        String fileName;
        if("ONE".equals((String)param.get("TYPE"))){
            String tobeTableName = (String)param.get("tobeTableName");

            fileName = tobeTableName;
            executeReport(wb, tobeTableName);

        }else{

            List<String> tobeTableNameList = commonDAO.list("mig.selectTobeTableNameList");
            for(int i=0; i<tobeTableNameList.size(); i++){
                String tableName = tobeTableNameList.get(i);
                executeReport(wb, tableName);

            }

            fileName = "MappingDefinition";
        }

        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");
        response.setHeader("Cache-Control", "max-age=0");

        wb.write(response.getOutputStream());
        wb.close();
    }

    /**
     * 매핑정의서 엑셀 생성
     * @param wb
     * @param tobeTableName
     * @throws Exception
     */
    private void executeReport(HSSFWorkbook wb, String tobeTableName) throws Exception{
        List<Map<String, String>> migTableList = commonDAO.list("mig.selectMappingTableList", tobeTableName);

        StringBuffer asisTableNames = new StringBuffer();

        // ASIS 테이블 목록 IN 조건절 생성
        for(Map<String, String> map : migTableList){
            asisTableNames.append("'").append(map.get("SOURCE_TABLE")).append("',");
        }

        asisTableNames = new StringBuffer(asisTableNames.substring(0, asisTableNames.length()-1));

        // ASIS 테이블 컬럼정보 쿼리 문자열
        List<String> list = commonUcpappDAO.list("mig.selectAsisTableColumnInfoStrList2", asisTableNames.toString());

        StringBuilder sb = new StringBuilder();
        for(String colStr : list){
            sb.append(colStr);
        }

        Map<String, String> parmas = new HashMap<>();

        parmas.put("ASIS_QUERY"      , sb.toString().substring(0, sb.length() - 10));
        parmas.put("TOBE_TABLE_NAME" , tobeTableName);

        // 결과조회
        List<Map<String, Object>> result = commonDAO.list("mig.selectTableColumnInfoList2", parmas);

        String asisTableComment = (String)commonUcpappDAO.select("mig.selectTableComment", asisTableNames.toString());
        String tobeTableComment = (String)commonDAO.select("mig.selectTableComment", "'"+tobeTableName+"'");

        // String joinStr = (String)((Map)migTableList.get(0)).get("JOIN"); // 데이터추출조건

        SheetFactory sheetFactory = new SheetFactory(wb, tobeTableName);
        createHeader(sheetFactory, asisTableComment, tobeTableComment);
        createRecord(sheetFactory, result);

        //sheetFactory.autoSizeColumn(1, 11);

    }

    /**
     * 매핑정의서 데이터 엑셀 생성
     * @param sheetFactory
     * @param result
     */
    private void createRecord(SheetFactory sheetFactory, List<Map<String, Object>> result) {
        String[] columnInfo = {"NO"    , "ASIS_TABLE", "ASIS_COL", "ASIS_DATA_TYPE", "ASIS_COMMENTS", "TOBE_TABLE", "TOBE_COL", "TOBE_DATA_TYPE", "TOBE_COMMENTS", "MODIFY_DESC", ""};
        String[] alignInfo  = {"center", "center"    , "center"  , "center"        , "left"         , "center"    , "center"  , "center"        , "left"         , "center"     , "center"};
        for(int i=0; i<result.size(); i++){
            Map<String, Object> data = result.get(i);

            String[] dataArr = new String[columnInfo.length];
            for(int k=0; k<columnInfo.length; k++){
                if(k == 0){
                    dataArr[k] = String.valueOf(i+1);
                    continue;
                }
                dataArr[k] = (data.containsKey(columnInfo[k]) ? (String)data.get(columnInfo[k]) : "");
            }

            sheetFactory.createData(dataArr, alignInfo, 5+i, 1);
        }
    }

    /**
     * 매핑정의서 엑셀 타이틀 생성
     * @param sheetFactory
     * @param asisTableComment
     * @param tobeTableComment
     */
    private void createHeader(SheetFactory sheetFactory, String asisTableComment, String tobeTableComment) {
        CellStyleFactory cellStyleFactory = new CellStyleFactory(sheetFactory.getWorkBook());

        CellStyle cellStyle = cellStyleFactory.getStaticCellStyle(STYLE.TITLE);
        Row row = sheetFactory.createRow(1);
        row.setHeight((short)700);

        sheetFactory.createMergeCell("[컬럼 매핑 정의서]", cellStyle, 1, 1, 1, 11);

        cellStyle = cellStyleFactory.getStaticCellStyle(STYLE.SUB_TITLE);
        sheetFactory.createMergeCell("소스테이블명", cellStyle, 2, 1, 2, 2);
        sheetFactory.createMergeCell("타겟테이블명", cellStyle, 2, 6, 2, 7);

        org.apache.poi.ss.usermodel.Font font = cellStyleFactory.getFont((short)11);
        cellStyle = cellStyleFactory.getCellStyle(font, CellStyle.ALIGN_LEFT);

        sheetFactory.createMergeCell(asisTableComment, cellStyle, 2, 3, 2, 5);
        sheetFactory.createMergeCell(tobeTableComment, cellStyle, 2, 8, 2, 11);

        cellStyle = cellStyleFactory.getStaticCellStyle(STYLE.HEADER_TITLE);
        sheetFactory.createMergeCell("No"        , cellStyle, 3, 1, 4, 1);
        sheetFactory.createMergeCell("Source"    , cellStyle, 3, 2, 3, 5);
        sheetFactory.createMergeCell("Target"    , cellStyle, 3, 6, 3, 9);
        sheetFactory.createMergeCell("변경사항"  , cellStyle, 3, 10, 4, 10);
        sheetFactory.createMergeCell("변환규칙"  , cellStyle, 3, 11, 4, 11);

        sheetFactory.createMergeCell("테이블명"  , cellStyle, 4, 2, 4, 2);
        sheetFactory.createMergeCell("컬럼명"    , cellStyle, 4, 3, 4, 3);
        sheetFactory.createMergeCell("데이터타입", cellStyle, 4, 4, 4, 4);
        sheetFactory.createMergeCell("주석"      , cellStyle, 4, 5, 4, 5);

        sheetFactory.createMergeCell("테이블명"  , cellStyle, 4, 6, 4, 6);
        sheetFactory.createMergeCell("컬럼명"    , cellStyle, 4, 7, 4, 7);
        sheetFactory.createMergeCell("데이터타입", cellStyle, 4, 8, 4, 8);
        sheetFactory.createMergeCell("주석"      , cellStyle, 4, 9, 4, 9);
    }


    /**
     * {@inheritDoc}
     * @param request
     * @param response
     */
    @Override
    public void scriptDownload(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuffer buffer = new StringBuffer();

        List<String> tableList = commonDAO.list("mig.executeMakeQuery", "SELECT TOBE_TABLE FROM X_MIG_TABLE_MNG GROUP BY TOBE_TABLE");
        buffer.append("/**************************************************\n");
        buffer.append(tableList.size()).append("건 테이블 생성\n");
        for(String str : tableList){
            buffer.append(" DROP TABLE ").append(str).append(";\n");
        }
        buffer.append("**************************************************/\n");

        // 테이블 스크립트
        logger.debug("테이블 스크립트 생성...");
        List<String> list = commonDAO.list("mig.selectTableDDL");
        for(String str : list){
            int removeSIdx = 0;
            try {
                removeSIdx = str.indexOf("USING INDEX");
                if(removeSIdx > 0){
                    buffer.append(str.substring(0, removeSIdx)).append(");\r\n");

                }else{
                    removeSIdx = str.indexOf("PCTFREE");
                    buffer.append(str.substring(0, removeSIdx)).append(";\r\n");
                }

            }catch(Exception e){
                logger.error("Table script Creating Error ===========>>>");
                logger.error("removeSIdx : {}", removeSIdx);
                logger.error("ddl : {}", str);
            }
        }


        // 인덱스 스크립트
        logger.debug("인덱스 스크립트 생성...");
        list = commonDAO.list("mig.selectIndexDDL");

        for(String str : list){
            int removeSIdx = 0;
            try {
                removeSIdx = str.indexOf("PCTFREE");
                buffer.append(str.substring(0, removeSIdx)).append(";\r\n");
            }catch(Exception e){
                logger.error("Index script Creating Error ===========>>>");
                logger.error("removeSIdx : {}", removeSIdx);
                logger.error("ddl : {}", str);
            }
        }

        // SEQUENCE 스크립트
        /*logger.debug("시퀀스 스크립트 생성...");
        list = commonDAO.list("mig.selectSequenceDDL");
        for(String str : list){
            int preStrLastIndex = str.indexOf("START WITH") + "START WITH".length();
            buffer.append(str.substring(0, preStrLastIndex)).append(" 0 NOCACHE  NOORDER  NOCYCLE \r\n");
        }*/

        // 테이블 코멘트 스크립트
        logger.debug("테이블 코멘트 스크립트 생성...");
        list = commonDAO.list("mig.selectTableCommentDDL");
        for(String str : list){
            buffer.append(str).append("\r\n");
        }

        // 테이블 컬럼 코멘트 스크립트
        logger.debug("테이블 컬럼 코멘트 스크립트 생성...");
        list = commonDAO.list("mig.selectColumnCommentDDL");
        for(String str : list){
            buffer.append(str).append("\r\n");
        }

        // 테이블 생성 검증 쿼리
        /*logger.debug("테이블 컬럼 코멘트 스크립트 생성...");
        list = commonDAO.list("mig.selectColumnCommentDDL");
        for(String str : list){
            buffer.append(str).append("\r\n");
        }*/

        // 인덱스 생성 검증 쿼리

        // 시퀀스 생성 검증 쿼리

        buffer.append("SELECT '").append(tableList.size()).append("' AS TRY_COUNT, COUNT(*) AS CREATE_COUNT FROM USER_TABLES WHERE TABLE_NAME IN (");
        for(String str : tableList){
            buffer.append("'").append(str).append("',");
        }

        buffer = new StringBuffer(buffer.substring(0, buffer.length()-1));
        buffer.append(");\n");

        String tempFile = downloadPath+File.separator+"migration.sql";
        logger.debug("Temp File Path : {}", tempFile);
        logger.debug("스크립트 임시파일 생성...");
        File file = new File(tempFile);
        FileUtils.writeStringToFile(file, buffer.toString());

        try(ServletOutputStream out = response.getOutputStream();
            BufferedInputStream in =  new BufferedInputStream(new FileInputStream(file))){

            byte[] bytes = new byte[1024];

            response.setContentType("utf-8");
            response.setContentType("application/octet-stream");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Content-Disposition", "attachment;filename=MIG_SCRIPT.sql;");
            long len = file.length();

            response.setContentLength((int)len);

            int n = 0;
            while ((n = in.read(bytes, 0, 1024)) != -1) {
                out.write(bytes, 0, n);
            }

        }finally {
            logger.debug("스크립트 임시파일 삭제...");
            file.delete();

        }
    }

    /**
     * {@inheritDoc}
     * @param request
     * @param response
     */
    @Override
    public void printScript(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Map<String, Object>> list = commonDAO.list("mig.selectMigTable");

        StringBuffer buffer = new StringBuffer();
        buffer.append("SET DEFINE OFF;\n");
        for(Map<String, Object> param : list){
            buffer.append("SELECT '").append(param.get("TOBE_TABLE")).append(" INSERT....' AS FROM DUAL;").append("\n");
            buffer.append(getQueryScript(param)).append("\n");
        }

        String tempFile = downloadPath+File.separator+"dataMigrationScript.sql";
        logger.debug("Temp File Path : {}", tempFile);
        logger.debug("데이터 스크립트 임시파일 생성...");
        File file = new File(tempFile);
        FileUtils.writeStringToFile(file, buffer.toString());

        try(ServletOutputStream out = response.getOutputStream();
            BufferedInputStream in =  new BufferedInputStream(new FileInputStream(file))){

            byte[] bytes = new byte[1024];

            response.setContentType("utf-8");
            response.setContentType("application/octet-stream");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Content-Disposition", "attachment;filename=MIG_DATA_SCRIPT.sql;");
            long len = file.length();

            response.setContentLength((int)len);

            int n = 0;
            while ((n = in.read(bytes, 0, 1024)) != -1) {
                out.write(bytes, 0, n);
            }

        }finally {
            logger.debug("데이터 스크립트 임시파일 삭제...");
            file.delete();

        }
    }
}
