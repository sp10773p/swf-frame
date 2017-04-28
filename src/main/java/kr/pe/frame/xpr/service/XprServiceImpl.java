package kr.pe.frame.xpr.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.CommonValidatorService;
import kr.pe.frame.cmm.excel.ColumnInfo;
import kr.pe.frame.cmm.excel.ExcelReader;
import kr.pe.frame.cmm.util.StringUtil;

//import java.io.FileInputStream;
//import org.apache.commons.io.IOUtils;

/**
 * Created by kdh on 2017. 1. 10.
 */
@Service("xprService")
public class XprServiceImpl implements XprService {

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;
    
    @Resource(name = "commonValidator")
    private CommonValidatorService commonValidator;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;
    
    // ========================================================================================================= //
    // =================================================배송요청================================================= //
    // ========================================================================================================= //
    
    /**
     * 주거래특송사 코드 조회
     */
    @Override
    public AjaxModel getMainExpressCode(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        String baseVal = (String) commonDAO.select("xpr.getMainExpressCode", param);
        param.put("baseVal", baseVal);
        model.setData(param);
        return model;
    }
    
    /**
     * 특송 배송요청 리스트
     */
    @Override
    public AjaxModel selectShipList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);
        
        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    /**
     * 특송 배송요청 업로드내역 상세 리스트
     */
    @Override
    public AjaxModel selectShipExcelList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        UsrSessionModel session = model.getUsrSessionModel();
        
        Map<String, Object> param = model.getData();
        param.put("USER_ID", session.getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    // --------------------------------------------------------------------------------------------------------- //
    // ------------------------------------------------엑셀업로드------------------------------------------------ //
    // --------------------------------------------------------------------------------------------------------- //
    
    /**
     * 특송 배송요청 엑셀업로드
     */
    @Override
    public AjaxModel uploadShipExcel(AjaxModel model) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        // 주거래특송사코드 조회
        Map<String, Object> param = model.getData();
        param.put("USER_ID", usrSession.getUserId());
        String baseVal = (String) commonDAO.select("xpr.getMainExpressCode", param);
        String tempBaseVal = MapUtils.getString(param, "TEMP_EXPRESS_BIZ_NO");
        if (StringUtil.isEmpty(baseVal) && StringUtil.isEmpty(tempBaseVal)) {
            model.setCode("W00000056"); // 주거래특송사가 지정되지 않았니다.\n신고인신고서기본값 설정에서 주거래특송사를 지정해 주세요.
            throw new BizException(model);
        }

        // SEQ_XPR_XPRREG_EXCEL.NEXTVAL 
        @SuppressWarnings("unchecked")
        Map<String, Object> seqMap = (Map<String, Object>) commonDAO.select("xpr.getShipExcelMainSeq");
        
        // INSERT XPR_XPRREG_EXCEL
        param.put("EXPRESS_BIZ_NO", StringUtil.isEmpty(tempBaseVal) ? baseVal : tempBaseVal);
        param.put("SN", seqMap.get("SN"));
        commonDAO.insert("xpr.insertShipExcelMain", param);

        List<ColumnInfo> excelInfoList = new ArrayList<ColumnInfo>();

        // 추가정보
        excelInfoList.add(setColumnInfo("REGINO", "운송장번호", 13));
        excelInfoList.add(setColumnInfo("RPT_NO", "수출신고번호", 14));
//        excelInfoList.add(setColumnInfo("BLNO", "B/L No.", 20));
        
        // 주문정보
        excelInfoList.add(setColumnInfo("STORE_NAME", "판매 쇼핑몰", 10));
        excelInfoList.add(setColumnInfo("ORDER_DATE", "주문일자", 8));
        excelInfoList.add(setColumnInfo("STORE_ORDER_NO", "주문번호", 50));
        excelInfoList.add(setColumnInfo("PROD_DESC", "상품구분", 20));
        
        // 수취인정보
        excelInfoList.add(setColumnInfo("RECIPIENT_NAME", "수취인 이름", 35));
        excelInfoList.add(setColumnInfo("RECIPIENT_PHONE", "수취인 전화", 20));
        excelInfoList.add(setColumnInfo("RECIPIENT_EMAIL", "수취인 이메일", 40));
        excelInfoList.add(setColumnInfo("RECIPIENT_ADDRESS1", "수취인 주소1", 98));
        excelInfoList.add(setColumnInfo("RECIPIENT_ADDRESS2", "수취인 주소2", 98));
        excelInfoList.add(setColumnInfo("RECIPIENT_CITY", "수취인 도시", 35));
        excelInfoList.add(setColumnInfo("RECIPIENT_STATE", "수취인 주", 35));
        excelInfoList.add(setColumnInfo("RECIPIENT_ZIPCD", "수취인 우편번호", 10));
        excelInfoList.add(setColumnInfo("RECIPIENT_COUNTRY", "수취인 국가", 2));
        
        // 배송정보
        excelInfoList.add(setColumnInfo("DELIVERY_OPTION", "배송 서비스", 20));
        excelInfoList.add(setColumnInfo("TOTAL_WEIGHT", "총무게", 7));
        excelInfoList.add(setColumnInfo("WEIGHT_UNIT", "무게 단위", 3));
        excelInfoList.add(setColumnInfo("TOTAL_PACK_CNT", "총포장수", 6));        // 추가
        excelInfoList.add(setColumnInfo("TOTAL_PACK_UNIT", "총포장 단위", 3));      // 추가
        excelInfoList.add(setColumnInfo("BOX_WIDTH", "가로 길이", 7));
        excelInfoList.add(setColumnInfo("BOX_LENGTH", "세로 길이", 7));
        excelInfoList.add(setColumnInfo("BOX_HEIGHT", "높이", 7));
        excelInfoList.add(setColumnInfo("BOX_DIMENSION_UNIT", "크기 단위", 4));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY_UNIT", "수량 단위", 3));  // 추가
        excelInfoList.add(setColumnInfo("CURRENCY_UNIT", "통화 단위", 3));
        
        // 상품정보1
        excelInfoList.add(setColumnInfo("ITEM_TITLE1", "상품 1", 50));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY1", "상품 수량 1", 7));
        excelInfoList.add(setColumnInfo("ITEM_SALE_PRICE1", "상품 가격 1", 12));
        excelInfoList.add(setColumnInfo("ITEM_CATEGORY1", "상품 분류 1", 20));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT1", "상품 무게 1", 7));
        excelInfoList.add(setColumnInfo("ITEM_ORIGIN1", "원산지 1", 2));
        excelInfoList.add(setColumnInfo("ITEM_HSCODE1", "HSCODE 1", 10));
        excelInfoList.add(setColumnInfo("ITEM_SKU1", "SKU 1", 50));
        excelInfoList.add(setColumnInfo("ITEM_COMPOSITION1", "소재 1", 100));
        
        // 상품정보2
        excelInfoList.add(setColumnInfo("ITEM_TITLE2", "상품 2", 50));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY2", "상품 수량 2", 7));
        excelInfoList.add(setColumnInfo("ITEM_SALE_PRICE2", "상품 가격 2", 12));
        excelInfoList.add(setColumnInfo("ITEM_CATEGORY2", "상품 분류 2", 20));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT2", "상품 무게 2", 7));
        excelInfoList.add(setColumnInfo("ITEM_ORIGIN2", "원산지 2", 2));
        excelInfoList.add(setColumnInfo("ITEM_HSCODE2", "HSCODE 2", 10));
        excelInfoList.add(setColumnInfo("ITEM_SKU2", "SKU 2", 50));
        excelInfoList.add(setColumnInfo("ITEM_COMPOSITION2", "소재 2", 100));
        
        // 상품정보3
        excelInfoList.add(setColumnInfo("ITEM_TITLE3", "상품 3", 50));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY3", "상품 수량 3", 7));
        excelInfoList.add(setColumnInfo("ITEM_SALE_PRICE3", "상품 가격 3", 12));
        excelInfoList.add(setColumnInfo("ITEM_CATEGORY3", "상품 분류 3", 20));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT3", "상품 무게 3", 7));
        excelInfoList.add(setColumnInfo("ITEM_ORIGIN3", "원산지 3", 2));
        excelInfoList.add(setColumnInfo("ITEM_HSCODE3", "HSCODE 3", 10));
        excelInfoList.add(setColumnInfo("ITEM_SKU3", "SKU 3", 50));
        excelInfoList.add(setColumnInfo("ITEM_COMPOSITION3", "소재 3", 100));
        
        // 상품정보4
        excelInfoList.add(setColumnInfo("ITEM_TITLE4", "상품 4", 50));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY4", "상품 수량 4", 7));
        excelInfoList.add(setColumnInfo("ITEM_SALE_PRICE4", "상품 가격 4", 12));
        excelInfoList.add(setColumnInfo("ITEM_CATEGORY4", "상품 분류 4", 20));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT4", "상품 무게 4", 7));
        excelInfoList.add(setColumnInfo("ITEM_ORIGIN4", "원산지 4", 2));
        excelInfoList.add(setColumnInfo("ITEM_HSCODE4", "HSCODE 4", 10));
        excelInfoList.add(setColumnInfo("ITEM_SKU4", "SKU 4", 50));
        excelInfoList.add(setColumnInfo("ITEM_COMPOSITION4", "소재 4", 100));
        
        // 상품정보5
        excelInfoList.add(setColumnInfo("ITEM_TITLE5", "상품 5", 50));
        excelInfoList.add(setColumnInfo("ITEM_QUANTITY5", "상품 수량 5", 7));
        excelInfoList.add(setColumnInfo("ITEM_SALE_PRICE5", "상품 가격 5", 12));
        excelInfoList.add(setColumnInfo("ITEM_CATEGORY5", "상품 분류 5", 20));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT5", "상품 무게 5", 7));
        excelInfoList.add(setColumnInfo("ITEM_ORIGIN5", "원산지 5", 2));
        excelInfoList.add(setColumnInfo("ITEM_HSCODE5", "HSCODE 5", 10));
        excelInfoList.add(setColumnInfo("ITEM_SKU5", "SKU 5", 50));
        excelInfoList.add(setColumnInfo("ITEM_COMPOSITION5", "소재 5", 100));

        Map<String, Object> extraData = new HashMap<String, Object>();
        extraData.put("SN", param.get("SN"));
        extraData.put("USER_ID", usrSession.getUserId());
        extraData.put("EXPRESS_BIZ_NO", param.get("EXPRESS_BIZ_NO"));

        // INSERT XPR_XPRREG_EXCEL_DETAIL
        uploadExcelXprreg(model, excelInfoList, extraData);

        // 공백 데이터 삭제
        commonDAO.delete("xpr.deleteShipExcelDetailEmpty", param);

        // 업로드 목록 조회
        List<Map<String, Object>> xlsList = commonDAO.list("xpr.selectShipExcelDetailList", param);

        // MaxSize 체크 (MaxSize 초과건 -> INSERT XPR_XPRREG_EXCEL_ERRMSG) 
        checkMaxSize(excelInfoList, xlsList);

        // Validation 체크
        checkValidation(usrSession, xlsList);

        return model;
    }

    @SuppressWarnings("unchecked")
    private void uploadExcelXprreg(AjaxModel model, List<ColumnInfo> excelInfoList, Map<String, Object> extraData) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        Map<String, Object> fileMap = model.getDataList().get(0);
        Map<Integer,Map<Integer, Object>> rows = excelReader.parseExcelOnlyFirstSheet(
            new File(StringUtil.null2Str(fileMap.get("FILE_STRE_COURS")) + StringUtil.null2Str(fileMap.get("STRE_FILE_NM")) + StringUtil.null2Str(fileMap.get("FILE_SN")))
        );
        
        List<Map<String, Object>> valueList = new ArrayList<Map<String, Object>>();

        for (Integer row : rows.keySet()) {
            if (row < 2) continue;
            
            boolean bErr = false;
            String sStatusDesc = "";
            
            Map<String, Object> expDecInfo = new HashMap<String, Object>();
            
            String storeOrderNo = StringUtil.null2Str(rows.get(row).get(4));//ExcelUtil.getValue(row.getCell(4), true).trim(); // 주문번호
            String rptNo = StringUtil.null2Str(rows.get(row).get(1));//ExcelUtil.getValue(row.getCell(1), true).trim(); // 수출신고번호
            if (storeOrderNo.isEmpty() && !rptNo.isEmpty()) {
                // 수출신고번호에 해당되는 주문번호 가져옴
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("RPT_NO", rptNo);
                paramMap.put("USER_ID", usrSession.getUserId());
                paramMap.put("BIZ_NO", usrSession.getBizNo());
                expDecInfo = (Map<String, Object>) commonDAO.select("xpr.selectOrderNo", paramMap);
            }
            else if (!storeOrderNo.isEmpty() && rptNo.isEmpty()) {
                // 주문번호에 해당되는 수출신고번호 가져옴
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("STORE_ORDER_NO", storeOrderNo);
                paramMap.put("USER_ID", usrSession.getUserId());
                paramMap.put("BIZ_NO", usrSession.getBizNo());
                expDecInfo = (Map<String, Object>) commonDAO.select("xpr.selectRptNo", paramMap);
            }
            
            Map<String, Object> excelData = new HashMap<String, Object>();
            for (Integer cell : rows.get(row).keySet()) {
                String cellData = StringUtil.null2Str(rows.get(row).get(cell));
                
                ColumnInfo columnInfoDTO = excelInfoList.get(cell);
                String headerId = columnInfoDTO.getHeaderId();
                int maxColumnSize = columnInfoDTO.getMaxColumnSize();
                
                excelData.put(headerId, cellData);
                
                if ("RPT_NO".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
                    // 수출신고번호 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
                    cellData = StringUtil.null2Str(expDecInfo.get("RPT_NO"));
                }
                else if ("STORE_ORDER_NO".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
                    // 주문번호 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
                    cellData = StringUtil.null2Str(expDecInfo.get("ORDER_ID"));
                }

                // 컬럼별 최대 크기 값으로 데이터를 자른다. 최대 크기 값이 0이면 자르지 않는다.
                if (maxColumnSize > 0) {
                    if (cellData.length() > 0) {
                        if (cellData.getBytes().length > maxColumnSize) { // 오류정보 세팅하고 데이터 자른다.
                            bErr = true;
                            sStatusDesc += headerId + "/";

                            cellData = StringUtil.toShortenStringMB(cellData, maxColumnSize);
                        }
                    }
                }

                excelData.put(headerId, cellData);
            }
            
            excelData.putAll(extraData);
            
            if (bErr) {
                removeLastSeparator(sStatusDesc, "/");

                excelData.put("STATUS", "E");
                excelData.put("STATUS_DESC", sStatusDesc);
            }
            
            valueList.add(excelData);
        }

        for (Map<String, Object> param : valueList) {
            try {
                commonDAO.insert("xpr.insertShipExcelDetail", param);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    // MaxSize 체크 (MaxSize 초과건 -> INSERT XPR_XPRREG_EXCEL_ERRMSG)
    private void checkMaxSize(List<ColumnInfo> excelInfoList, List<Map<String, Object>> xlsList) {
        for (Map<String, Object> xls : xlsList) {
            Map<String, Object> row = xls;
            String status = (String) row.get("STATUS");

            if ("E".equals(status)) {
                String statusDesc = (String) row.get("STATUS_DESC");
                String[] statusDescArray = null;
                if (statusDesc != null) {
                    statusDescArray = statusDesc.split("/");
                    Map<String, Object> errMsgMap = null;

                    for (String errorColumnName : statusDescArray) {
                        errMsgMap = new HashMap<String, Object>();
                        errMsgMap.put("SN", row.get("SN"));
                        errMsgMap.put("SEQ", row.get("SEQ"));
                        errMsgMap.put("ERROR_COLUMN_NAME", errorColumnName);
                        String headerDesc = getHeaderName(excelInfoList, errorColumnName);
                        int maxSize = getMaxColumnSize(excelInfoList, errorColumnName);
                        errMsgMap.put("ERROR_MESSAGE", headerDesc + "의 길이가 너무 깁니다. 최대바이트(" + maxSize + ")");

                        commonDAO.insert("xpr.insertShipExcelErrmsgSelect", errMsgMap);
                    }
                }
            }
        }
    }
    
    // 오류 체크
    private void checkValidation(UsrSessionModel usrSession, List<Map<String, Object>> xlsList) throws Exception {
        List<Map<String, Object>> rowErrorList = null;
        for (Map<String, Object> xls : xlsList) {
            boolean bErr = false;
            rowErrorList = new ArrayList<Map<String, Object>>();

            // 추가정보
            String REGINO = StringUtil.null2Str(xls.get("REGINO"));
            String RPT_NO = StringUtil.null2Str(xls.get("RPT_NO"));
//            String BLNO = StringUtil.null2Str(xls.get("BLNO"));
            
            // 주문정보
            String STORE_NAME = StringUtil.null2Str(xls.get("STORE_NAME"));
            String ORDER_DATE = StringUtil.null2Str(xls.get("ORDER_DATE"));
            String STORE_ORDER_NO = StringUtil.null2Str(xls.get("STORE_ORDER_NO"));
            String PROD_DESC = StringUtil.null2Str(xls.get("PROD_DESC"));
            
            // 수취인정보
            String RECIPIENT_NAME = StringUtil.null2Str(xls.get("RECIPIENT_NAME"));
            String RECIPIENT_PHONE = StringUtil.null2Str(xls.get("RECIPIENT_PHONE"));
            String RECIPIENT_EMAIL = StringUtil.null2Str(xls.get("RECIPIENT_EMAIL"));
            String RECIPIENT_ADDRESS1 = StringUtil.null2Str(xls.get("RECIPIENT_ADDRESS1"));
            String RECIPIENT_ADDRESS2 = StringUtil.null2Str(xls.get("RECIPIENT_ADDRESS2"));
            String RECIPIENT_CITY = StringUtil.null2Str(xls.get("RECIPIENT_CITY"));
            String RECIPIENT_STATE = StringUtil.null2Str(xls.get("RECIPIENT_STATE"));
            String RECIPIENT_ZIPCD = StringUtil.null2Str(xls.get("RECIPIENT_ZIPCD"));
            String RECIPIENT_COUNTRY = StringUtil.null2Str(xls.get("RECIPIENT_COUNTRY"));
            
            // 배송정보
            String DELIVERY_OPTION = StringUtil.null2Str(xls.get("DELIVERY_OPTION"));
            String TOTAL_WEIGHT = StringUtil.null2Str(xls.get("TOTAL_WEIGHT"));
            String WEIGHT_UNIT = StringUtil.null2Str(xls.get("WEIGHT_UNIT"));
            String TOTAL_PACK_CNT = StringUtil.null2Str(xls.get("TOTAL_PACK_CNT"));             // 추가
            String TOTAL_PACK_UNIT = StringUtil.null2Str(xls.get("TOTAL_PACK_UNIT"));           // 추가
            String BOX_WIDTH = StringUtil.null2Str(xls.get("BOX_WIDTH"));
            String BOX_LENGTH = StringUtil.null2Str(xls.get("BOX_LENGTH"));
            String BOX_HEIGHT = StringUtil.null2Str(xls.get("BOX_HEIGHT"));
            String BOX_DIMENSION_UNIT = StringUtil.null2Str(xls.get("BOX_DIMENSION_UNIT"));
            String ITEM_QUANTITY_UNIT = StringUtil.null2Str(xls.get("ITEM_QUANTITY_UNIT")); // 추가
            String CURRENCY_UNIT = StringUtil.null2Str(xls.get("CURRENCY_UNIT"));
            
            // 상품 1
            String ITEM_TITLE1 = StringUtil.null2Str(xls.get("ITEM_TITLE1"));
            String ITEM_QUANTITY1 = StringUtil.null2Str(xls.get("ITEM_QUANTITY1"));
            String ITEM_SALE_PRICE1 = StringUtil.null2Str(xls.get("ITEM_SALE_PRICE1"));
            String ITEM_CATEGORY1 = StringUtil.null2Str(xls.get("ITEM_CATEGORY1"));
            String ITEM_WEIGHT1 = StringUtil.null2Str(xls.get("ITEM_WEIGHT1"));
            String ITEM_ORIGIN1 = StringUtil.null2Str(xls.get("ITEM_ORIGIN1"));
            String ITEM_HSCODE1 = StringUtil.null2Str(xls.get("ITEM_HSCODE1"));
            String ITEM_SKU1 = StringUtil.null2Str(xls.get("ITEM_SKU1"));
            String ITEM_COMPOSITION1 = StringUtil.null2Str(xls.get("ITEM_COMPOSITION1"));
            
            // 상품 2
            boolean isEmptyItem2 = false;
            String ITEM_TITLE2 = StringUtil.null2Str(xls.get("ITEM_TITLE2"));
            String ITEM_QUANTITY2 = StringUtil.null2Str(xls.get("ITEM_QUANTITY2"));
            String ITEM_SALE_PRICE2 = StringUtil.null2Str(xls.get("ITEM_SALE_PRICE2"));
            String ITEM_CATEGORY2 = StringUtil.null2Str(xls.get("ITEM_CATEGORY2"));
            String ITEM_WEIGHT2 = StringUtil.null2Str(xls.get("ITEM_WEIGHT2"));
            String ITEM_ORIGIN2 = StringUtil.null2Str(xls.get("ITEM_ORIGIN2"));
            String ITEM_HSCODE2 = StringUtil.null2Str(xls.get("ITEM_HSCODE2"));
            String ITEM_SKU2 = StringUtil.null2Str(xls.get("ITEM_SKU2"));
            String ITEM_COMPOSITION2 = StringUtil.null2Str(xls.get("ITEM_COMPOSITION2"));
            if (StringUtils.isEmpty(ITEM_TITLE2) && StringUtils.isEmpty(ITEM_QUANTITY2) && StringUtils.isEmpty(ITEM_SALE_PRICE2) && 
                StringUtils.isEmpty(ITEM_CATEGORY2) && StringUtils.isEmpty(ITEM_WEIGHT2) && StringUtils.isEmpty(ITEM_ORIGIN2) &&
                StringUtils.isEmpty(ITEM_HSCODE2) && StringUtils.isEmpty(ITEM_SKU2) && StringUtils.isEmpty(ITEM_COMPOSITION2)) {
                isEmptyItem2 = true;
            }
            
            // 상품 3
            boolean isEmptyItem3 = false;
            String ITEM_TITLE3 = StringUtil.null2Str(xls.get("ITEM_TITLE3"));
            String ITEM_QUANTITY3 = StringUtil.null2Str(xls.get("ITEM_QUANTITY3"));
            String ITEM_SALE_PRICE3 = StringUtil.null2Str(xls.get("ITEM_SALE_PRICE3"));
            String ITEM_CATEGORY3 = StringUtil.null2Str(xls.get("ITEM_CATEGORY3"));
            String ITEM_WEIGHT3 = StringUtil.null2Str(xls.get("ITEM_WEIGHT3"));
            String ITEM_ORIGIN3 = StringUtil.null2Str(xls.get("ITEM_ORIGIN3"));
            String ITEM_HSCODE3 = StringUtil.null2Str(xls.get("ITEM_HSCODE3"));
            String ITEM_SKU3 = StringUtil.null2Str(xls.get("ITEM_SKU3"));
            String ITEM_COMPOSITION3 = StringUtil.null2Str(xls.get("ITEM_COMPOSITION3"));
            if (StringUtils.isEmpty(ITEM_TITLE3) && StringUtils.isEmpty(ITEM_QUANTITY3) && StringUtils.isEmpty(ITEM_SALE_PRICE3) && 
                StringUtils.isEmpty(ITEM_CATEGORY3) && StringUtils.isEmpty(ITEM_WEIGHT3) && StringUtils.isEmpty(ITEM_ORIGIN3) &&
                StringUtils.isEmpty(ITEM_HSCODE3) && StringUtils.isEmpty(ITEM_SKU3) && StringUtils.isEmpty(ITEM_COMPOSITION3)) {
                isEmptyItem3 = true;
            }
            
            // 상품 4
            boolean isEmptyItem4 = false;
            String ITEM_TITLE4 = StringUtil.null2Str(xls.get("ITEM_TITLE4"));
            String ITEM_QUANTITY4 = StringUtil.null2Str(xls.get("ITEM_QUANTITY4"));
            String ITEM_SALE_PRICE4 = StringUtil.null2Str(xls.get("ITEM_SALE_PRICE4"));
            String ITEM_CATEGORY4 = StringUtil.null2Str(xls.get("ITEM_CATEGORY4"));
            String ITEM_WEIGHT4 = StringUtil.null2Str(xls.get("ITEM_WEIGHT4"));
            String ITEM_ORIGIN4 = StringUtil.null2Str(xls.get("ITEM_ORIGIN4"));
            String ITEM_HSCODE4 = StringUtil.null2Str(xls.get("ITEM_HSCODE4"));
            String ITEM_SKU4 = StringUtil.null2Str(xls.get("ITEM_SKU4"));
            String ITEM_COMPOSITION4 = StringUtil.null2Str(xls.get("ITEM_COMPOSITION4"));
            if (StringUtils.isEmpty(ITEM_TITLE4) && StringUtils.isEmpty(ITEM_QUANTITY4) && StringUtils.isEmpty(ITEM_SALE_PRICE4) && 
                StringUtils.isEmpty(ITEM_CATEGORY4) && StringUtils.isEmpty(ITEM_WEIGHT4) && StringUtils.isEmpty(ITEM_ORIGIN4) &&
                StringUtils.isEmpty(ITEM_HSCODE4) && StringUtils.isEmpty(ITEM_SKU4) && StringUtils.isEmpty(ITEM_COMPOSITION4)) {
                isEmptyItem4 = true;
            }
            
            // 상품 5
            boolean isEmptyItem5 = false;
            String ITEM_TITLE5 = StringUtil.null2Str(xls.get("ITEM_TITLE5"));
            String ITEM_QUANTITY5 = StringUtil.null2Str(xls.get("ITEM_QUANTITY5"));
            String ITEM_SALE_PRICE5 = StringUtil.null2Str(xls.get("ITEM_SALE_PRICE5"));
            String ITEM_CATEGORY5 = StringUtil.null2Str(xls.get("ITEM_CATEGORY5"));
            String ITEM_WEIGHT5 = StringUtil.null2Str(xls.get("ITEM_WEIGHT5"));
            String ITEM_ORIGIN5 = StringUtil.null2Str(xls.get("ITEM_ORIGIN5"));
            String ITEM_HSCODE5 = StringUtil.null2Str(xls.get("ITEM_HSCODE5"));
            String ITEM_SKU5 = StringUtil.null2Str(xls.get("ITEM_SKU5"));
            String ITEM_COMPOSITION5 = StringUtil.null2Str(xls.get("ITEM_COMPOSITION5"));
            if (StringUtils.isEmpty(ITEM_TITLE5) && StringUtils.isEmpty(ITEM_QUANTITY5) && StringUtils.isEmpty(ITEM_SALE_PRICE5) && 
                StringUtils.isEmpty(ITEM_CATEGORY5) && StringUtils.isEmpty(ITEM_WEIGHT5) && StringUtils.isEmpty(ITEM_ORIGIN5) &&
                StringUtils.isEmpty(ITEM_HSCODE5) && StringUtils.isEmpty(ITEM_SKU5) && StringUtils.isEmpty(ITEM_COMPOSITION5)) {
                isEmptyItem5 = true;
            }

            // 필수값 체크
            try {
                XprValidator.isValidRegiNo(REGINO, "운송장번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "REGINO", REGINO, e.getMessage());
            }
//            try {
//                XprValidator.isValidBlNo(BLNO, "B/L No.", false);
//            } catch (Exception e) {
//                addErrorInfo(rowErrorList, "REGINO", REGINO, e.getMessage());
//            }
            try {
                XprValidator.isValidStoreName(STORE_NAME, "판매 쇼핑몰", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "STORE_NAME", STORE_NAME, e.getMessage());
            }
            try {
                XprValidator.isValidOrderDate(ORDER_DATE, "주문일자", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDER_DATE", ORDER_DATE, e.getMessage());
            }
            try {
                XprValidator.isValidProdDesc(PROD_DESC, "상품구분", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "PROD_DESC", PROD_DESC, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientName(RECIPIENT_NAME, "수취인 이름", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_NAME", RECIPIENT_NAME, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientPhone(RECIPIENT_PHONE, "수취인 전화", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_PHONE", RECIPIENT_PHONE, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientEmail(RECIPIENT_EMAIL, "수취인 이메일", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_EMAIL", RECIPIENT_EMAIL, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientAddress(RECIPIENT_ADDRESS1, "수취인 주소1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_ADDRESS1", RECIPIENT_ADDRESS1, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientAddress(RECIPIENT_ADDRESS2, "수취인 주소2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_ADDRESS2", RECIPIENT_ADDRESS2, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientCity(RECIPIENT_CITY, "수취인 도시", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_CITY", RECIPIENT_CITY, e.getMessage());
            }
            try {
                // 미국, 중국, 일본, 호주의 경우 필수
                String[] countrys = new String[] {"US", "CN", "JP", "AU"};
                boolean contains = Arrays.asList(countrys).contains(RECIPIENT_COUNTRY);
                XprValidator.isValidRecipientState(RECIPIENT_STATE, "수취인 주", contains);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_STATE", RECIPIENT_STATE, e.getMessage());
            }
            try {
                XprValidator.isValidRecipientZipcd(RECIPIENT_ZIPCD, "수취인 우편번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_ZIPCD", RECIPIENT_ZIPCD, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(RECIPIENT_COUNTRY, "수취인 국가", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECIPIENT_COUNTRY", RECIPIENT_COUNTRY, e.getMessage());
            }
            try {
                XprValidator.isValidDeliveryOption(DELIVERY_OPTION, "배송 서비스", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "DELIVERY_OPTION", DELIVERY_OPTION, e.getMessage());
            }
            try {
                XprValidator.isValidTotalWeight(TOTAL_WEIGHT, "총무게", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTAL_WEIGHT", TOTAL_WEIGHT, e.getMessage());
            }
            try {
                commonValidator.isValidQuantityUnitCode(WEIGHT_UNIT, "무게 단위", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WEIGHT_UNIT", WEIGHT_UNIT, e.getMessage());
            }
            try {
                XprValidator.isValidTotPackCnt(TOTAL_PACK_CNT, "총포장수", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTAL_PACK_CNT", TOTAL_PACK_CNT, e.getMessage());
            }
            try {
                commonValidator.isValidPackageUnitCode(TOTAL_PACK_UNIT, "포장 단위", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTAL_PACK_UNIT", TOTAL_PACK_UNIT, e.getMessage());
            }
            try {
                XprValidator.isValidBoxSize(BOX_WIDTH, "가로", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOX_WIDTH", BOX_WIDTH, e.getMessage());
            }
            try {
                XprValidator.isValidBoxSize(BOX_LENGTH, "세로", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOX_LENGTH", BOX_LENGTH, e.getMessage());
            }
            try {
                XprValidator.isValidBoxSize(BOX_HEIGHT, "높이", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOX_HEIGHT", BOX_HEIGHT, e.getMessage());
            }
            try {
                XprValidator.isValidBoxDimensionUnit(BOX_DIMENSION_UNIT, "크기 단위", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOX_DIMENSION_UNIT", BOX_DIMENSION_UNIT, e.getMessage());
            }
            try {
                commonValidator.isValidQuantityUnitCode(ITEM_QUANTITY_UNIT, "수량 단위", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY_UNIT", ITEM_QUANTITY_UNIT, e.getMessage());
            }
            try {
                commonValidator.isValidCurrencyCd(CURRENCY_UNIT, "통화 단위", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "CURRENCY_UNIT", CURRENCY_UNIT, e.getMessage());
            }
            
            // 상품 1
            try {
                XprValidator.isValidItemTitle(ITEM_TITLE1, "상품 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_TITLE1", ITEM_TITLE1, e.getMessage());
            }
            try {
                XprValidator.isValidItemQuantity(ITEM_QUANTITY1, "상품 수량 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY1", ITEM_QUANTITY1, e.getMessage());
            }
            try {
                XprValidator.isValidItemSalePrice(ITEM_SALE_PRICE1, "상품 가격 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SALE_PRICE1", ITEM_SALE_PRICE1, e.getMessage());
            }
            try {
                XprValidator.isValidItemCategory(ITEM_CATEGORY1, "상품 분류 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_CATEGORY1", ITEM_CATEGORY1, e.getMessage());
            }
            try {
                XprValidator.isValidItemWeight(ITEM_WEIGHT1, "상품 무게 1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT1", ITEM_WEIGHT1, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(ITEM_ORIGIN1, "원산지 1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_ORIGIN1", ITEM_ORIGIN1, e.getMessage());
            }
            try {
                commonValidator.isValidHsCode(ITEM_HSCODE1, "HSCODE 1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_HSCODE1", ITEM_HSCODE1, e.getMessage());
            }
            try {
                XprValidator.isValidItemSku(ITEM_SKU1, "SKU 1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SKU1", ITEM_SKU1, e.getMessage());
            }
            try {
                XprValidator.isValidItemComposition(ITEM_COMPOSITION1, "소재 1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_COMPOSITION1", ITEM_COMPOSITION1, e.getMessage());
            }
            
            // 상품 2
            try {
                XprValidator.isValidItemTitle(ITEM_TITLE2, "상품 2", isEmptyItem2 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_TITLE2", ITEM_TITLE2, e.getMessage());
            }
            try {
                XprValidator.isValidItemQuantity(ITEM_QUANTITY2, "상품 수량 2", isEmptyItem2 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY2", ITEM_QUANTITY2, e.getMessage());
            }
            try {
                XprValidator.isValidItemSalePrice(ITEM_SALE_PRICE2, "상품 가격 2", isEmptyItem2 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SALE_PRICE2", ITEM_SALE_PRICE2, e.getMessage());
            }
            try {
                XprValidator.isValidItemCategory(ITEM_CATEGORY2, "상품 분류 2", isEmptyItem2 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_CATEGORY2", ITEM_CATEGORY2, e.getMessage());
            }
            try {
                XprValidator.isValidItemWeight(ITEM_WEIGHT2, "상품 무게 2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT2", ITEM_WEIGHT2, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(ITEM_ORIGIN2, "원산지 2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_ORIGIN2", ITEM_ORIGIN2, e.getMessage());
            }
            try {
                commonValidator.isValidHsCode(ITEM_HSCODE2, "HSCODE 2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_HSCODE2", ITEM_HSCODE2, e.getMessage());
            }
            try {
                XprValidator.isValidItemSku(ITEM_SKU2, "SKU 2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SKU2", ITEM_SKU2, e.getMessage());
            }
            try {
                XprValidator.isValidItemComposition(ITEM_COMPOSITION2, "소재 2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_COMPOSITION2", ITEM_COMPOSITION2, e.getMessage());
            }
            
            // 상품 3
            try {
                XprValidator.isValidItemTitle(ITEM_TITLE3, "상품 3", isEmptyItem3 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_TITLE3", ITEM_TITLE3, e.getMessage());
            }
            try {
                XprValidator.isValidItemQuantity(ITEM_QUANTITY3, "상품 수량 3", isEmptyItem3 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY3", ITEM_QUANTITY3, e.getMessage());
            }
            try {
                XprValidator.isValidItemSalePrice(ITEM_SALE_PRICE3, "상품 가격 3", isEmptyItem3 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SALE_PRICE3", ITEM_SALE_PRICE3, e.getMessage());
            }
            try {
                XprValidator.isValidItemCategory(ITEM_CATEGORY3, "상품 분류 3", isEmptyItem3 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_CATEGORY3", ITEM_CATEGORY3, e.getMessage());
            }
            try {
                XprValidator.isValidItemWeight(ITEM_WEIGHT3, "상품 무게 3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT3", ITEM_WEIGHT3, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(ITEM_ORIGIN3, "원산지 3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_ORIGIN3", ITEM_ORIGIN3, e.getMessage());
            }
            try {
                commonValidator.isValidHsCode(ITEM_HSCODE3, "HSCODE 3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_HSCODE3", ITEM_HSCODE3, e.getMessage());
            }
            try {
                XprValidator.isValidItemSku(ITEM_SKU3, "SKU 3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SKU3", ITEM_SKU3, e.getMessage());
            }
            try {
                XprValidator.isValidItemComposition(ITEM_COMPOSITION3, "소재 3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_COMPOSITION3", ITEM_COMPOSITION3, e.getMessage());
            }
            
            // 상품 4
            try {
                XprValidator.isValidItemTitle(ITEM_TITLE4, "상품 4", isEmptyItem4 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_TITLE4", ITEM_TITLE4, e.getMessage());
            }
            try {
                XprValidator.isValidItemQuantity(ITEM_QUANTITY4, "상품 수량 4", isEmptyItem4 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY4", ITEM_QUANTITY4, e.getMessage());
            }
            try {
                XprValidator.isValidItemSalePrice(ITEM_SALE_PRICE4, "상품 가격 4", isEmptyItem4 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SALE_PRICE4", ITEM_SALE_PRICE4, e.getMessage());
            }
            try {
                XprValidator.isValidItemCategory(ITEM_CATEGORY4, "상품 분류 4", isEmptyItem4 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_CATEGORY4", ITEM_CATEGORY4, e.getMessage());
            }
            try {
                XprValidator.isValidItemWeight(ITEM_WEIGHT4, "상품 무게 4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT4", ITEM_WEIGHT4, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(ITEM_ORIGIN4, "원산지 4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_ORIGIN4", ITEM_ORIGIN4, e.getMessage());
            }
            try {
                commonValidator.isValidHsCode(ITEM_HSCODE4, "HSCODE 4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_HSCODE4", ITEM_HSCODE4, e.getMessage());
            }
            try {
                XprValidator.isValidItemSku(ITEM_SKU4, "SKU 4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SKU4", ITEM_SKU4, e.getMessage());
            }
            try {
                XprValidator.isValidItemComposition(ITEM_COMPOSITION4, "소재 4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_COMPOSITION4", ITEM_COMPOSITION4, e.getMessage());
            }
            
            // 상품 5
            try {
                XprValidator.isValidItemTitle(ITEM_TITLE5, "상품 5", isEmptyItem5 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_TITLE5", ITEM_TITLE5, e.getMessage());
            }
            try {
                XprValidator.isValidItemQuantity(ITEM_QUANTITY5, "상품 수량 5", isEmptyItem5 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_QUANTITY5", ITEM_QUANTITY5, e.getMessage());
            }
            try {
                XprValidator.isValidItemSalePrice(ITEM_SALE_PRICE5, "상품 가격 5", isEmptyItem5 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SALE_PRICE5", ITEM_SALE_PRICE5, e.getMessage());
            }
            try {
                XprValidator.isValidItemCategory(ITEM_CATEGORY5, "상품 분류 5", isEmptyItem5 ? false : true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_CATEGORY5", ITEM_CATEGORY5, e.getMessage());
            }
            try {
                XprValidator.isValidItemWeight(ITEM_WEIGHT5, "상품 무게 5", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT5", ITEM_WEIGHT5, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(ITEM_ORIGIN5, "원산지 5", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_ORIGIN5", ITEM_ORIGIN5, e.getMessage());
            }
            try {
                commonValidator.isValidHsCode(ITEM_HSCODE5, "HSCODE 5", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_HSCODE5", ITEM_HSCODE5, e.getMessage());
            }
            try {
                XprValidator.isValidItemSku(ITEM_SKU5, "SKU 5", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_SKU5", ITEM_SKU5, e.getMessage());
            }
            try {
                XprValidator.isValidItemComposition(ITEM_COMPOSITION5, "소재 5", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_COMPOSITION5", ITEM_COMPOSITION5, e.getMessage());
            }
            
            // 수출신고번호 검증 
            try {
                Map<String, Object> searchParam = new HashMap<String, Object>();
                searchParam.put("RPT_NO", RPT_NO);
                searchParam.put("USER_ID", usrSession.getUserId());
                searchParam.put("BIZ_NO", usrSession.getBizNo());
                int iCnt = (int) commonDAO.select("xpr.selectExistRptNo", searchParam);
                if (iCnt == 0) {
                    throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호[" + RPT_NO + "]");
                }
                else {
                    String countryCode = (String) commonDAO.select("xpr.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isNotEmpty(RECIPIENT_COUNTRY)) {
                        if (!StringUtils.equals(RECIPIENT_COUNTRY, countryCode)) {
                            throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호[" + RPT_NO + "], 목적지[" + countryCode + "]");
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RPT_NO", STORE_ORDER_NO, e.getMessage());
            }
            
            // 주문번호 검증 
            try {
                Map<String, Object> searchParam = new HashMap<String, Object>();
                searchParam.put("STORE_ORDER_NO", STORE_ORDER_NO);
                searchParam.put("USER_ID", usrSession.getUserId());
                searchParam.put("BIZ_NO", usrSession.getBizNo());
                int iCnt = (int) commonDAO.select("xpr.selectExistOrderId", searchParam);
                if (iCnt == 0) {
                    throw new BizException("주문번호가 존재하지 않습니다. 주문번호[" + STORE_ORDER_NO + "]");
                }
                else {
                    String countryCode = (String) commonDAO.select("xpr.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isNotEmpty(RECIPIENT_COUNTRY)) {
                        if (!StringUtils.equals(RECIPIENT_COUNTRY, countryCode)) {
                            throw new BizException("수취인 국가와 목적지가 다른 주문번호입니다. 주문번호[" + STORE_ORDER_NO + "], 목적지[" + countryCode + "]");
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "STORE_ORDER_NO", STORE_ORDER_NO, e.getMessage());
            }
            
            if (rowErrorList.size() > 0) {
                bErr = true;
            }

            if (bErr) {
                Map<String, Object> chkDaoParam = new HashMap<String, Object>();
                chkDaoParam.put("SN", xls.get("SN"));
                chkDaoParam.put("SEQ", xls.get("SEQ"));
                chkDaoParam.put("STATUS", "E");
                String sStatusDesc = "";
                for (Map<String, Object> errorInfo : rowErrorList) {
                    sStatusDesc += errorInfo.get("ERROR_COLUMN_NAME");
                    sStatusDesc += "/";
                }
                chkDaoParam.put("STATUS_DESC", sStatusDesc);

                // Validation 오류컬럼 업데이트
                commonDAO.update("xpr.updateShipExcelDetailStatusDesc", chkDaoParam);
                commonDAO.update("xpr.updateShipExcelDetail", chkDaoParam);

                // 엑셀 에러메시지가 존재할 경우 기존 내용 삭제 후 등록
                if (rowErrorList.size() > 0) {
                    commonDAO.delete("xpr.deleteShipExcelErrmsg", chkDaoParam);
                }
                
                Map<String, Object> errMsgMap = null;
                for (Map<String, Object> errorInfo : rowErrorList) {
                    errMsgMap = new HashMap<String, Object>(errorInfo);
                    errMsgMap.put("SN", chkDaoParam.get("SN"));
                    errMsgMap.put("SEQ", chkDaoParam.get("SEQ"));

                    try {
                        commonDAO.insert("xpr.insertShipExcelErrmsg", errMsgMap);
                    } catch (Exception e) {
                        if (e instanceof DuplicateKeyException == false) {
                            throw e;
                        }
                    }
                }
            }
            else {
                Map<String, Object> chkDaoParam = new HashMap<String, Object>();
                chkDaoParam.put("SN", xls.get("SN"));
                chkDaoParam.put("SEQ", xls.get("SEQ"));
                chkDaoParam.put("STATUS", "");
                commonDAO.update("xpr.updateShipExcelDetailStatusDesc", chkDaoParam);
                commonDAO.delete("xpr.deleteShipExcelErrmsg", chkDaoParam);
            }
        }
    }
    
    private String removeLastSeparator(String str, String separator) {
        if (str.endsWith(separator)) {
            str = str.substring(0, str.length() - 1); // 마지막 separator 제거
        }
        return str;
    }
    
    private ColumnInfo setColumnInfo(String headerId, String headerName, int maxColumnSize) {
        ColumnInfo columnInfo = new ColumnInfo();
        columnInfo.setHeaderId(headerId);
        columnInfo.setHeaderName(headerName);
        columnInfo.setMaxColumnSize(maxColumnSize);
        return columnInfo;
    }

    private String getHeaderName(List<ColumnInfo> list, String id) {
        for (ColumnInfo dto : list) {
            if (id.equals(dto.getHeaderId())) {
                return dto.getHeaderName();
            }
        }
        return StringUtils.EMPTY;
    }

    private int getMaxColumnSize(List<ColumnInfo> list, String id) {
        for (ColumnInfo dto : list) {
            if (id.equals(dto.getHeaderId())) {
                return dto.getMaxColumnSize();
            }
        }
        return 0;
    }
    
    private void addErrorInfo(List<Map<String, Object>> errorList, String errorColumnName, String errorColumnData, String errorMessage) {
        Map<String, Object> errorInfo = new HashMap<String, Object>();
        errorInfo.put("ERROR_COLUMN_NAME", errorColumnName);
        errorInfo.put("ERROR_COLUMN_DATA", errorColumnData);
        errorInfo.put("ERROR_MESSAGE", errorMessage);

        errorList.add(errorInfo);
    }

    // ========================================================================================================= //
    // =============================================배송요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 상세 목록
     */
    @Override
    public AjaxModel selectShipDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    /**
     * 특송 배송요청 저장 (상태)
     */
    @SuppressWarnings("unchecked")
    @Override
    public AjaxModel saveShipReq(AjaxModel model) throws Exception {
        UsrSessionModel session = model.getUsrSessionModel();
        Map<String, Object> param = model.getData();
        param.put("USER_ID", session.getUserId());
        model.setData(param);
        
        // 발송인 정보 조회 (셀러정보)
        Map<String, Object> sellerInfo = (Map<String, Object>) commonDAO.select("ems.selectSellerInfo", param);
        String email = DocUtil.decrypt(MapUtils.getString(sellerInfo, "EMAIL", ""));
        String hpno = DocUtil.decrypt(MapUtils.getString(sellerInfo, "HP_NO", ""));
        String telno = DocUtil.decrypt(MapUtils.getString(sellerInfo, "TEL_NO", ""));
        
        String[] tel = splitTelFormat(telno);
        String[] hp = splitPhoneFormat(hpno);
        
        // 배송요청 선택된 항목
        List<Map<String, Object>> reqList = model.getDataList();
        for (Map<String, Object> req : reqList) {
            
            // 배송요청(XPR_RECEPT_REQ) 테이블에 등록
            Map<String, Object> regParam = new HashMap<String, Object>();
            regParam.put("SN", req.get("SN"));
            regParam.put("SEQ", req.get("SEQ"));
            regParam.put("STATUSCD", "A"); //배송요청
            regParam.put("USER_ID", session.getUserId());
            
            // 발송자정보
            regParam.put("BIZ_NO", session.getBizNo());
            regParam.put("SENDER", MapUtils.getString(sellerInfo, "SENDER"));               // 발송인명
            regParam.put("SENDERZIPCODE", MapUtils.getString(sellerInfo, "SENDERZIPCODE")); // 발송인 우편번호
            regParam.put("SENDERADDR1", MapUtils.getString(sellerInfo, "SENDERADDR1"));     // 발송인 주소1(상세)
            regParam.put("SENDERADDR2", MapUtils.getString(sellerInfo, "SENDERADDR2"));     // 발송인 주소2(기본)
            regParam.put("SENDERTELNO1", ObjectUtils.toString("82"));                       // 발송인 전화번호1
            regParam.put("SENDERTELNO2", ArrayUtils.toString(tel[0], ""));                  // 발송인 전화번호2
            regParam.put("SENDERTELNO3", ArrayUtils.toString(tel[1], ""));                  // 발송인 전화번호3
            regParam.put("SENDERTELNO4", ArrayUtils.toString(tel[2], ""));                  // 발송인 전화번호4
            regParam.put("SENDERMOBILE1", ObjectUtils.toString("82"));                      // 발송인 이동통신1
            regParam.put("SENDERMOBILE2", ArrayUtils.toString(hp[0], ""));                  // 발송인 전화번호1
            regParam.put("SENDERMOBILE3", ArrayUtils.toString(hp[1], ""));                  // 발송인 전화번호1
            regParam.put("SENDERMOBILE4", ArrayUtils.toString(hp[2], ""));                  // 발송인 전화번호1
            regParam.put("SENDEREMAIL", ObjectUtils.toString(email));                       // 발송인 이메일
            commonDAO.insert("xpr.insertXprReceptReq", regParam);
        }
        
        model.setCode("I00000003"); //저장되었습니다.
        
        return model;
    }
    
    // ========================================================================================================= //
    // =============================================배송요청 상세정보============================================= //
    // ========================================================================================================= //

    /**
     * 특송 배송요청 상세 정보
     */
    @Override
    public AjaxModel selectShipDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        model = commonService.select(model);
        return model;
    }
    
    /**
     * 특송 배송요청 상세정보 저장
     */
    @Override
    public AjaxModel saveShipDetailInfo(AjaxModel model) throws Exception {
        UsrSessionModel session = model.getUsrSessionModel();
        
        Map<String, Object> param = model.getData();
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        list.add(param);
        checkValidation(session, list);
        
        commonDAO.update("xpr.updateShipDetailInfo", param);
        
        model.setCode("I00000003"); //저장되었습니다.
        
        return model;
    }
    
    // ========================================================================================================= //
    // =================================================특송사용================================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 조회
     */
    @Override
    public AjaxModel selectShipReqList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        UsrSessionModel session = model.getUsrSessionModel();
        
        Map<String, Object> param = model.getData();
        param.put("USER_ID", session.getUserId());
        param.put("BIZ_NO", session.getBizNo());
        model.setData(param);
        
        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    /**
     * 특송 배송요청 상세 조회
     */
    @Override
    public AjaxModel selectShipReqDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        UsrSessionModel session = model.getUsrSessionModel();
        
        Map<String, Object> param = model.getData();
        param.put("USER_ID", session.getUserId());
        param.put("BIZ_NO", session.getBizNo());
        model.setData(param);
        
        model = commonService.select(model);
        return model;
    }
    
    /**
     * 특송 배송요청 접수확인 (상태)
     */
    @Override
    public AjaxModel saveShipReqStatus(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        UsrSessionModel session = model.getUsrSessionModel();
        
        // 접수확인 선택된 항목
        List<Map<String, Object>> reqList = model.getDataList();
        for (Map<String, Object> req : reqList) {
            if ("B".equals(req.get("STATUSCD"))) continue; // 이미 접수확인건은 제외
            
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("SN", req.get("SN"));
            param.put("SEQ", req.get("SEQ"));
            param.put("STATUSCD", "B"); //배송접수
            param.put("USER_ID", session.getUserId());
            param.put("BIZ_NO", session.getBizNo());
            commonDAO.update("xpr.updateShipReqStatus", param);
        }
        
        model.setCode("I00000003"); //저장되었습니다.
        
        return model;
    }
    
    /**
     * 특송 배송요청 내역 (셀러/특송사)
     */
    @Override
    public AjaxModel selectShipReqFieldsList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        UsrSessionModel session = model.getUsrSessionModel();
        Map<String, Object> param = model.getData();
        param.put("USER_DIV", session.getUserDiv());
        param.put("USER_ID", session.getUserId());
        param.put("BIZ_NO", session.getBizNo());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    // ========================================================================================================= //
    
    private String[] splitTelFormat(String value) {
        if (value == null || "".equals(value)) return new String[3];
        
        String regEx = "(\\d{2,3})(\\d{4})(\\d{4})";
        if (!Pattern.matches(regEx, value)) return new String[3];

        String replaceStr = value.replaceAll(regEx, "$1-$2-$3");
        String[] split = replaceStr.split("-");
        if (ArrayUtils.isEmpty(split)) {
            split = new String[3];
        }
        return split;
    }

    private String[] splitPhoneFormat(String value) {
        if (value == null || "".equals(value)) return new String[3];
        
        String regEx = "(\\d{3})(\\d{3,4})(\\d{4})";
        if (!Pattern.matches(regEx, value)) return new String[3];

        String replaceStr = value.replaceAll(regEx, "$1-$2-$3");
        String[] split = replaceStr.split("-");
        if (ArrayUtils.isEmpty(split)) {
            split = new String[3];
        }
        return split;
    }
}
