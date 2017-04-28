package kr.pe.frame.ems.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.CommonValidatorService;
import kr.pe.frame.cmm.excel.ColumnInfo;
import kr.pe.frame.cmm.excel.ExcelReader;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.ems.api.EMSOpenApi;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.httpclient.ConnectTimeoutException;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.util.StringUtil;

/**
 * Created by kdh on 2017. 1. 10.
 */
@Service("emsService")
public class EmsServiceImpl implements EmsService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonValidator")
    private CommonValidatorService commonValidator;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    // ========================================================================================================= //
    // =================================================픽업요청================================================= //
    // ========================================================================================================= //

    /** 
     * EMS 픽업요청 리스트
     */
    @Override
    public AjaxModel selectPickList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * EMS 픽업요청 업로드내역 상세 리스트
     */
    @Override
    public AjaxModel selectPickExcelList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * EMS 픽업요청 처리내역 상세 리스트
     */
    @Override
    public AjaxModel selectPickReqList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * EMS 픽업요청 저장
     */
    @SuppressWarnings("unchecked")
    @Override
    public AjaxModel savePickReq(AjaxModel model) throws Exception {
        UsrSessionModel session = model.getUsrSessionModel();
        Map<String, Object> param = model.getData();
        param.put("USER_ID", session.getUserId());
        model.setData(param);

        List<Map<String, Object>> reqList = model.getDataList();

        int iTotCnt = 0;
        int iSucCnt = 0;
        int iErrCnt = 0;

        // 발송인 정보 조회 (셀러정보)
        Map<String, Object> sellerInfo = (Map<String, Object>) commonDAO.select("ems.selectSellerInfo", param);
        if (StringUtils.isEmpty(MapUtils.getString(sellerInfo, "SENDERADDR2"))) {
            model.setCode("W00000063"); // 영문주소가 입력되지 않았습니다.\n회원정보 화면에서 영문주소를 저장 후 다시 이용해 주시기 바랍니다.
            throw new BizException(model);
        }
        String email = DocUtil.decrypt(MapUtils.getString(sellerInfo, "EMAIL", ""));
        String hpno = DocUtil.decrypt(MapUtils.getString(sellerInfo, "HP_NO", ""));
        String telno = DocUtil.decrypt(MapUtils.getString(sellerInfo, "TEL_NO", ""));

        String[] tel = splitTelFormat(telno);
        String[] hp = splitPhoneFormat(hpno);


        // 픽업요청 선택된 항목
        for (Map<String, Object> req : reqList) {

            // 이전에 등록한 건 취소상태로 변경 (9:저장 -> 1:취소)
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("SN", req.get("SN"));
            paramMap.put("SEQ", req.get("SEQ"));
            paramMap.put("STATUS", "취소");
            paramMap.put("STATUSCD", "1");
            paramMap.put("USER_ID", session.getUserId());
            commonDAO.update("ems.updateEmsReceptReqStatus", paramMap);

            // 픽업요청(EMS_RECEPT_REQ) 테이블에 등록
            Map<String, Object> regParam = new HashMap<String, Object>();
            regParam.put("SN", req.get("SN"));
            regParam.put("SEQ", req.get("SEQ"));
            regParam.put("STATUS", "저장");
            regParam.put("STATUSCD", "9");
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
            commonDAO.insert("ems.insertEmsReceptReq", regParam);
        }
        
        // 픽업요청 테이블에 등록된 목록을 조회하여 픽업요청 EMS Open API 전송
        for (Map<String, Object> req : reqList) {
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("SN", req.get("SN"));
            paramMap.put("SEQ", req.get("SEQ"));
            paramMap.put("USER_ID", session.getUserId());

            // 픽업요청 테이블에 등록된 정보 조회 (STATUSCD = 9)
            List<Map<String, Object>> list = commonDAO.list("ems.selectEmsReceptReqList", paramMap);
            if (CollectionUtils.isNotEmpty(list)) {
                iTotCnt += list.size();
            }

            for (Map<String, Object> map : list) {
                String REGNO = MapUtils.getString(map, "REGNO");
                // 픽업요청 시작 -------------------------------------------------------------------------
                Map<String, String> params = new HashMap<String, String>();
                params.put("custno", MapUtils.getString(map, "CUSTNO", ""));
                params.put("apprno", MapUtils.getString(map, "APPRNO", ""));
                params.put("sender", MapUtils.getString(map, "SENDER", ""));
                params.put("senderzipcode", MapUtils.getString(map, "SENDERZIPCODE", ""));
                params.put("senderaddr1", MapUtils.getString(map, "SENDERADDR1", ""));
                params.put("senderaddr2", MapUtils.getString(map, "SENDERADDR2", ""));
                params.put("sendertelno1", MapUtils.getString(map, "SENDERTELNO1", ""));
                params.put("sendertelno2", MapUtils.getString(map, "SENDERTELNO2", ""));
                params.put("sendertelno3", MapUtils.getString(map, "SENDERTELNO3", ""));
                params.put("sendertelno4", MapUtils.getString(map, "SENDERTELNO4", ""));
                params.put("sendermobile1", MapUtils.getString(map, "SENDERMOBILE1", ""));
                params.put("sendermobile2", MapUtils.getString(map, "SENDERMOBILE2", ""));
                params.put("sendermobile3", MapUtils.getString(map, "SENDERMOBILE3", ""));
                params.put("sendermobile4", MapUtils.getString(map, "SENDERMOBILE4", ""));
                params.put("senderemail", MapUtils.getString(map, "SENDEREMAIL", ""));
                params.put("snd_message", MapUtils.getString(map, "SND_MESSAGE", ""));
                params.put("premiumcd", MapUtils.getString(map, "PREMIUMCD", ""));
                params.put("receivename", MapUtils.getString(map, "RECEIVENAME", ""));
                params.put("receivezipcode", MapUtils.getString(map, "RECEIVEZIPCODE", ""));
                params.put("receiveaddr1", MapUtils.getString(map, "RECEIVEADDR1", ""));
                params.put("receiveaddr2", MapUtils.getString(map, "RECEIVEADDR2", ""));
                params.put("receiveaddr3", MapUtils.getString(map, "RECEIVEADDR3", ""));
                params.put("receivetelno1", MapUtils.getString(map, "RECEIVETELNO1", ""));
                params.put("receivetelno2", MapUtils.getString(map, "RECEIVETELNO2", ""));
                params.put("receivetelno3", MapUtils.getString(map, "RECEIVETELNO3", ""));
                params.put("receivetelno4", MapUtils.getString(map, "RECEIVETELNO4", ""));
                params.put("receivetelno", MapUtils.getString(map, "RECEIVETELNO", ""));
                params.put("receivemail", MapUtils.getString(map, "RECEIVEMAIL", ""));
                params.put("countrycd", MapUtils.getString(map, "COUNTRYCD", ""));
                params.put("orderno", MapUtils.getString(map, "ORDERNO", ""));
                params.put("em_ee", MapUtils.getString(map, "EM_EE", ""));
                params.put("totweight", MapUtils.getString(map, "TOTWEIGHT", ""));
                params.put("boyn", MapUtils.getString(map, "BOYN", ""));
                params.put("boprc", MapUtils.getString(map, "BOPRC", ""));
                params.put("orderprsnzipcd", MapUtils.getString(map, "ORDERPRSNZIPCD", ""));
                params.put("orderprsnaddr1", MapUtils.getString(map, "ORDERPRSNADDR1", ""));
                params.put("orderprsnaddr2", MapUtils.getString(map, "ORDERPRSNADDR2", ""));
                params.put("orderprsnnm", MapUtils.getString(map, "ORDERPRSNNM", ""));
                params.put("orderprsntelnno", MapUtils.getString(map, "ORDERPRSNTELNNO", ""));
                params.put("orderprsntelfno", MapUtils.getString(map, "ORDERPRSNTELFNO", ""));
                params.put("orderprsntelmno", MapUtils.getString(map, "ORDERPRSNTELMNO", ""));
                params.put("orderprsntellno", MapUtils.getString(map, "ORDERPRSNTELLNO", ""));
                params.put("orderprsntelno", MapUtils.getString(map, "ORDERPRSNTELNO", ""));
                params.put("orderprsnhtelfno", MapUtils.getString(map, "ORDERPRSNHTELFNO", ""));
                params.put("orderprsnhtelmno", MapUtils.getString(map, "ORDERPRSNHTELMNO", ""));
                params.put("orderprsnhtellno", MapUtils.getString(map, "ORDERPRSNHTELLNO", ""));
                params.put("orderprsnhtelno", MapUtils.getString(map, "ORDERPRSNHTELNO", ""));
                params.put("orderprsnemailid", MapUtils.getString(map, "ORDERPRSNEMAILID", ""));
                params.put("contents", MapUtils.getString(map, "CONTENTS", ""));
                params.put("number", MapUtils.getString(map, "ITEM_NUMBER", ""));
                params.put("weight", MapUtils.getString(map, "ITEM_WEIGHT", ""));
                params.put("value", MapUtils.getString(map, "ITEM_VALUE", ""));
                params.put("hs_code", MapUtils.getString(map, "HS_CODE", ""));
                params.put("origin", MapUtils.getString(map, "ORIGIN", ""));
                params.put("EM_gubun", makeEmGubun(map));
                params.put("modelno", MapUtils.getString(map, "MODELNO", ""));
                params.put("ecommerceyn", MapUtils.getString(map, "ECOMMERCEYN", ""));
                params.put("bizregno", MapUtils.getString(map, "BIZREGNO", ""));
                params.put("exportsendprsnnm", MapUtils.getString(map, "EXPORTSENDPRSNNM", ""));
                params.put("exportsendprsnaddr", MapUtils.getString(map, "EXPORTSENDPRSNADDR", ""));
                params.put("xprtno1", MapUtils.getString(map, "XPRTNO1", ""));
                params.put("xprtno2", MapUtils.getString(map, "XPRTNO2", ""));
                params.put("xprtno3", MapUtils.getString(map, "XPRTNO3", ""));
                params.put("xprtno4", MapUtils.getString(map, "XPRTNO4", ""));
                params.put("recomporegipocd", MapUtils.getString(map, "RECOMPOREGIPOCD", ""));
                params.put("totdivsendyn1", MapUtils.getString(map, "TOTDIVSENDYN1", ""));
                params.put("totdivsendyn2", MapUtils.getString(map, "TOTDIVSENDYN2", ""));
                params.put("totdivsendyn3", MapUtils.getString(map, "TOTDIVSENDYN3", ""));
                params.put("totdivsendyn4", MapUtils.getString(map, "TOTDIVSENDYN4", ""));
                params.put("wrapcnt1", MapUtils.getString(map, "WRAPCNT1", ""));
                params.put("wrapcnt2", MapUtils.getString(map, "WRAPCNT2", ""));
                params.put("wrapcnt3", MapUtils.getString(map, "WRAPCNT3", ""));
                params.put("wrapcnt4", MapUtils.getString(map, "WRAPCNT4", ""));
                params.put("xprtnoyn", MapUtils.getString(map, "XPRTNOYN", ""));
                params.put("skustockmgmtno", MapUtils.getString(map, "SKUSTOCKMGMTNO", ""));
                params.put("paytypecd", MapUtils.getString(map, "PAYTYPECD", ""));
                params.put("currunit", MapUtils.getString(map, "CURRUNIT", ""));
                params.put("payapprno", MapUtils.getString(map, "PAYAPPRNO", ""));
                params.put("dutypayprsncd", MapUtils.getString(map, "DUTYPAYPRSNCD", ""));
                params.put("dutypayamt", MapUtils.getString(map, "DUTYPAYAMT", ""));
                params.put("dutypaycurr", MapUtils.getString(map, "DUTYPAYCURR", ""));
                params.put("boxlength", MapUtils.getString(map, "BOXLENGTH", ""));
                params.put("boxwidth", MapUtils.getString(map, "BOXWIDTH", ""));
                params.put("boxheight", MapUtils.getString(map, "BOXHEIGHT", ""));
                
                String xml = "";
                try {
                    xml = EMSOpenApi.getData("API003", params); // EMS 픽업요청
                }
                catch (ConnectTimeoutException e) {
                    model.setCode("E00000004"); // 호스트가 제한 시간 내에 연결을 수락하지 않았습니다.
                    throw new BizException(model);
                }
                // 픽업요청 끝 ---------------------------------------------------------------------------
                
                Document doc = Jsoup.parse(xml, "", Parser.xmlParser());
                Elements eError_code = doc.select("error_code");
                Elements eMessage = doc.select("message");
                
                if (!eError_code.isEmpty()) { // 오류
                    Map<String, Object> errorParam = new HashMap<String, Object>();
                    errorParam.put("REGNO", REGNO);
                    errorParam.put("STATUS", "오류");
                    errorParam.put("STATUSCD", "X");
                    errorParam.put("ERROR_CODE", eError_code.text());
                    errorParam.put("ERROR_MESSAGE", eMessage.text());
                    errorParam.put("USER_ID", session.getUserId());
                    
                    // 이전 오류건 삭제
                    commonDAO.delete("ems.deleteEmsReceptReqError", errorParam);

                    // 오류코드 / 오류내용 업데이트
                    commonDAO.update("ems.updateEmsReceptReqError", errorParam);
                    iErrCnt++;
                }
                else { // 성공시 수신정보 업데이트 & 종추적정보 테이블에 등록
                    Map<String, Object> sucessParam = new HashMap<String, Object>();
                    sucessParam.put("REGNO", REGNO);
                    sucessParam.put("STATUS", "등록");
                    sucessParam.put("STATUSCD", "0");
                    sucessParam.put("USER_ID", session.getUserId());
                    sucessParam.put("REQNO", doc.select("reqno").text());
                    sucessParam.put("RECEIVESEQ", doc.select("receiveseq").text());
                    sucessParam.put("REGINO", doc.select("regino").text());
                    sucessParam.put("PRERECEVPRC", doc.select("prerecevprc").text());
                    sucessParam.put("PRCPAYMETHCD", doc.select("prcpaymethcd").text());
                    sucessParam.put("TREATPOREGIPOCD", doc.select("treatporegipocd").text());
                    sucessParam.put("TREATPOREGIPOENGNM", doc.select("treatporegipoengnm").text());
                    
                    // 이전 오류건 삭제
                    commonDAO.delete("ems.deleteEmsReceptReqError", sucessParam);
                    
                    // 픽업요청 수신정보 업데이트
                    commonDAO.update("ems.updateEmsReceptReqResult", sucessParam);

                    Map<String, Object> traceParam = new HashMap<String, Object>();
                    traceParam.put("REGINO", doc.select("regino").text());
                    traceParam.put("EVENTNM", "등록");
                    traceParam.put("UPUCD", "0");
                    traceParam.put("USER_ID", session.getUserId());

                    // 종추적정보 등록
                    commonDAO.insert("ems.insertEmsTraceInfo", traceParam);

                    iSucCnt++;
                }
            }
        }

        String msg = "";
        if (iErrCnt > 0) {
            msg = String.format("총 %s건의 픽업요청 중 %s건의 요청에 오류가 발생하였습니다.\n픽업오류 건수를 클릭해 오류내용을 확인하여 주시기 바랍니다.", iTotCnt, iErrCnt);
        }
        else {
            msg = String.format("총 %s건의 픽업요청 중 %s건의 요청이 정상 처리되었습니다.", iTotCnt, iSucCnt);
        }
        model.setMsg(msg);
        
        return model;
    }

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
    
    private String makeEmGubun(Map<String, Object> map) {
        String EM_GUBUN = MapUtils.getString(map, "EM_GUBUN", "");
        String contents = removeLastSeparator(MapUtils.getString(map, "CONTENTS", ""), ";");
        String itemNumber = removeLastSeparator(MapUtils.getString(map, "ITEM_NUMBER", ""), ";");
        String itemWeight = removeLastSeparator(MapUtils.getString(map, "ITEM_WEIGHT", ""), ";");
        String itemValue = removeLastSeparator(MapUtils.getString(map, "ITEM_VALUE", ""), ";");
        String hsCode = removeLastSeparator(MapUtils.getString(map, "HS_CODE", ""), ";");
        String origin = removeLastSeparator(MapUtils.getString(map, "ORIGIN", ""), ";");
        
        ArrayList<Integer> counts = new ArrayList<Integer>();
        counts.add(StringUtils.countMatches(contents, ";"));
        counts.add(StringUtils.countMatches(itemNumber, ";"));
        counts.add(StringUtils.countMatches(itemWeight, ";"));
        counts.add(StringUtils.countMatches(itemValue, ";"));
        counts.add(StringUtils.countMatches(hsCode, ";"));
        counts.add(StringUtils.countMatches(origin, ";"));
        Integer max = Collections.max(counts);
        
        StringBuffer sb = new StringBuffer(EM_GUBUN);
        if (StringUtils.isNotEmpty(EM_GUBUN) && max.intValue() > 0) {
            for (int i = 0; i < max.intValue(); i++) {
                sb.append(";");
                sb.append(EM_GUBUN);
            }
        }
        return sb.toString();
    }

    private String removeLastSeparator(String str, String separator) {
        if (str.endsWith(separator)) {
            str = str.substring(0, str.length() - 1); // 마지막 separator 제거
        }
        return str;
    }

    // --------------------------------------------------------------------------------------------------------- //
    // ------------------------------------------------엑셀업로드------------------------------------------------ //
    // --------------------------------------------------------------------------------------------------------- //

    /**
     * EMS 픽업요청 엑셀업로드
     */
    @Override
    public AjaxModel uploadPickExcel(AjaxModel model) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        // SEQ_EMS_EMSREG_EXCEL.NEXTVAL 
        @SuppressWarnings("unchecked")
        Map<String, Object> seqMap = (Map<String, Object>) commonDAO.select("ems.getPickExcelMainSeq");

        // INSERT EMS_EMSREG_EXCEL
        Map<String, Object> param = model.getData();
        param.put("USER_ID", usrSession.getUserId());
        param.put("SN", seqMap.get("SN"));
        param.put("REG_TYPE", "A");
        commonDAO.insert("ems.insertPickExcelMain", param);

        List<ColumnInfo> excelInfoList = new ArrayList<ColumnInfo>();

        // EMS서비스 엑셀서식
        excelInfoList.add(setColumnInfo("EM_GUBUN", "상품구분", 12));
        excelInfoList.add(setColumnInfo("RECEIVENAME", "수취인명", 35));
        excelInfoList.add(setColumnInfo("RECEIVEMAIL", "수취인EMAIL", 40));
        excelInfoList.add(setColumnInfo("RECEIVETELNO1", "수취인전화 국가번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO2", "수취인전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO3", "수취인전화 국번", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO4", "수취인전화 전화번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO", "수취인전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("COUNTRYCD", "수취인국가코드", 2));
        excelInfoList.add(setColumnInfo("COUNTRYNM", "수취인국가명", 40)); 
        excelInfoList.add(setColumnInfo("RECEIVEZIPCODE", "수취인 우편번호", 20));
        excelInfoList.add(setColumnInfo("RECEIVEADDR3", "수취인 전체주소/ 상세주소 1", 300));
        excelInfoList.add(setColumnInfo("RECEIVEADDR4", "수취인 상세주소 2", 300)); 
        excelInfoList.add(setColumnInfo("RECEIVEADDR2", "수취인 시/군 주소", 200));
        excelInfoList.add(setColumnInfo("RECEIVEADDR1", "수취인 주/도 주소", 140));
        excelInfoList.add(setColumnInfo("RECEIVEBUILDNM", "수취인 건물명", 90)); 

        // EMS프리미엄일 경우 총 중량 또는 체적중량을 입력하시기 바랍니다.
        excelInfoList.add(setColumnInfo("TOTWEIGHT", "총중량", 7));

        // 세관신고서 (도착국 관세부여 자료로 활용되며, 부정확한 자료 입력시 통관지연 및 반송사유가 됨)
        excelInfoList.add(setColumnInfo("CONTENTS", "내용품명", 132));
        excelInfoList.add(setColumnInfo("ITEM_NUMBER", "개수", 32));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT", "순중량", 44));
        excelInfoList.add(setColumnInfo("ITEM_VALUE", "가격", 64));
        excelInfoList.add(setColumnInfo("HS_CODE", "HS_CODE", 44));
        excelInfoList.add(setColumnInfo("ORIGIN", "생산지", 12));
        excelInfoList.add(setColumnInfo("MODELNO", "모델명", 404));

        // 보험여부
        excelInfoList.add(setColumnInfo("BOYN", "보험가입여부", 1));
        excelInfoList.add(setColumnInfo("BOPRC", "보험가입금액", 15));

        // 우편물구분
        excelInfoList.add(setColumnInfo("PREMIUMCD", "우편물구분", 1));

        // 물품종류
        excelInfoList.add(setColumnInfo("EM_EE", "국제우편물종류코드", 2));

        // 고객주문번호
        excelInfoList.add(setColumnInfo("ORDERNO", "고객주문번호", 50));

        // 주문인 정보(참고용)
        excelInfoList.add(setColumnInfo("ORDERPRSNZIPCD", "주문인 우편번호", 6));
        excelInfoList.add(setColumnInfo("ORDERPRSNADDR2", "주문인 주소", 140));
        excelInfoList.add(setColumnInfo("ORDERPRSNNM", "주문인명", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELNNO", "주문인전화 국가번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELFNO", "주문인전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELMNO", "주문인전화 국번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELLNO", "주문인전화 전화번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELNO", "주문인전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELFNO", "주문인휴대전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELMNO", "주문인휴대전화 국번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELLNO", "주문인휴대전화 끝번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELNO", "주문인휴대전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNEMAILID", "주문인EMAIL", 40));

        // 수출우편물정보 관세청 제공
        excelInfoList.add(setColumnInfo("ECOMMERCEYN", "수출우편물정보관세청제공여부", 1));
        excelInfoList.add(setColumnInfo("BIZREGNO", "사업자번호", 10));
        excelInfoList.add(setColumnInfo("EXPORTSENDPRSNNM", "수출화주 이름 또는 상호", 35));
        excelInfoList.add(setColumnInfo("EXPORTSENDPRSNADDR", "수출화주 주소", 105));

        // 수출이행등록
        excelInfoList.add(setColumnInfo("XPRTNOYN", "수출이행등록여부", 1));
        excelInfoList.add(setColumnInfo("XPRTNO1", "수출신고번호1", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN1", "전량분할발송여부1", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT1", "선기적 포장개수1", 5));
        excelInfoList.add(setColumnInfo("XPRTNO2", "수출신고번호2", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN2", "전량분할발송여부2", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT2", "선기적 포장개수2", 5));
        excelInfoList.add(setColumnInfo("XPRTNO3", "수출신고번호3", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN3", "전량분할발송여부3", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT3", "선기적 포장개수3", 5));
        excelInfoList.add(setColumnInfo("XPRTNO4", "수출신고번호4", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN4", "전량분할발송여부4", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT4", "선기적 포장개수4", 5));

        // OnePack 추천우체국코드
        excelInfoList.add(setColumnInfo("RECOMPOREGIPOCD", "추천우체국기호", 5));

        Map<String, Object> extraData = new HashMap<String, Object>();
        extraData.put("SN", param.get("SN"));
        extraData.put("USER_ID", usrSession.getUserId());
        extraData.put("MALL_ID", usrSession.getUserId());
        extraData.put("REG_TYPE", param.get("REG_TYPE"));

        // INSERT EMS_EMSREG_EXCEL_DETAIL
        uploadExcelEmsreg(model, excelInfoList, extraData);

        // 공백 데이터 삭제
        commonDAO.delete("ems.deletePickExcelDetailEmpty", param);

        // 업로드 목록 조회
        List<Map<String, Object>> xlsList = commonDAO.list("ems.selectPickExcelDetailList", param);

        // MaxSize 체크 (MaxSize 초과건 -> INSERT EMS_EMSREG_EXCEL_ERRMSG) 
        checkMaxSize(excelInfoList, xlsList);

        // Validation 체크
        checkValidationEms(usrSession, xlsList);

        return model;
    }

    /**
     * EMS 픽업요청 엑셀업로드 (SeaExpress)
     */
    @Override
    public AjaxModel uploadPickSeaExcel(AjaxModel model) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        // SEQ_EMS_EMSREG_EXCEL.NEXTVAL 
        @SuppressWarnings("unchecked")
        Map<String, Object> seqMap = (Map<String, Object>) commonDAO.select("ems.getPickExcelMainSeq");

        // INSERT EMS_EMSREG_EXCEL
        Map<String, Object> param = model.getData();
        param.put("USER_ID", usrSession.getUserId());
        param.put("SN", seqMap.get("SN"));
        param.put("REG_TYPE", "B");
        commonDAO.insert("ems.insertPickExcelMain", param);

        List<ColumnInfo> excelInfoList = new ArrayList<ColumnInfo>();

        // 한중해상특송서비스 엑셀서식
        excelInfoList.add(setColumnInfo("EM_GUBUN", "상품구분", 12));
        excelInfoList.add(setColumnInfo("RECEIVENAME", "수취인명", 35));
        excelInfoList.add(setColumnInfo("RECEIVEMAIL", "수취인EMAIL", 40));
        excelInfoList.add(setColumnInfo("RECEIVETELNO1", "수취인전화 국가번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO2", "수취인전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO3", "수취인전화 국번", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO4", "수취인전화 전화번호", 4));
        excelInfoList.add(setColumnInfo("RECEIVETELNO", "수취인전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("RECEIVEZIPCODE", "수취인 우편번호", 20));
        excelInfoList.add(setColumnInfo("RECEIVEADDR3", "수취인 주소 1", 300));
        excelInfoList.add(setColumnInfo("RECEIVEADDR4", "수취인 주소 2", 300)); 
        excelInfoList.add(setColumnInfo("TOTWEIGHT", "총중량", 7));

        // 세관신고서 (도착국 관세부여 자료로 활용되며, 부정확한 자료 입력시 통관지연 및 반송사유가 됨)
        excelInfoList.add(setColumnInfo("CONTENTS", "내용품명", 765));
        excelInfoList.add(setColumnInfo("ITEM_NUMBER", "개수", 120));
        excelInfoList.add(setColumnInfo("ITEM_WEIGHT", "순중량", 165));
        excelInfoList.add(setColumnInfo("ITEM_VALUE", "가격", 240));
        excelInfoList.add(setColumnInfo("HS_CODE", "HS_CODE", 165));
        excelInfoList.add(setColumnInfo("ORIGIN", "생산지", 45));
        excelInfoList.add(setColumnInfo("MODELNO", "모델명", 1515));

        // 보험여부
        excelInfoList.add(setColumnInfo("BOYN", "보험가입여부", 1));
        excelInfoList.add(setColumnInfo("BOPRC", "보험가입금액", 15));

        // 고객주문번호
        excelInfoList.add(setColumnInfo("ORDERNO", "고객주문번호", 50));

        // 주문인 정보(참고용)
        excelInfoList.add(setColumnInfo("ORDERPRSNZIPCD", "주문인 우편번호", 6));
        excelInfoList.add(setColumnInfo("ORDERPRSNADDR2", "주문인 주소", 140));
        excelInfoList.add(setColumnInfo("ORDERPRSNNM", "주문인명", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELNNO", "주문인전화 국가번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELFNO", "주문인전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELMNO", "주문인전화 국번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELLNO", "주문인전화 전화번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNTELNO", "주문인전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELFNO", "주문인휴대전화 지역번호", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELMNO", "주문인휴대전화 국번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELLNO", "주문인휴대전화 끝번", 4));
        excelInfoList.add(setColumnInfo("ORDERPRSNHTELNO", "주문인휴대전화 전체번호", 40));
        excelInfoList.add(setColumnInfo("ORDERPRSNEMAILID", "주문인EMAIL", 40));

        // 수출우편물정보 관세청 제공(수출기업전용)
        excelInfoList.add(setColumnInfo("ECOMMERCEYN", "수출우편물정보관세청제공여부", 1));
        excelInfoList.add(setColumnInfo("BIZREGNO", "사업자번호", 10));
        excelInfoList.add(setColumnInfo("EXPORTSENDPRSNNM", "수출화주 이름 또는 상호", 35));
        excelInfoList.add(setColumnInfo("EXPORTSENDPRSNADDR", "수출화주 주소", 105));

        // 수출이행등록
        excelInfoList.add(setColumnInfo("XPRTNOYN", "수출이행등록여부", 1));
        excelInfoList.add(setColumnInfo("XPRTNO1", "수출신고번호1", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN1", "전량분할발송여부1", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT1", "선기적 포장개수1", 5));
        excelInfoList.add(setColumnInfo("XPRTNO2", "수출신고번호2", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN2", "전량분할발송여부2", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT2", "선기적 포장개수2", 5));
        excelInfoList.add(setColumnInfo("XPRTNO3", "수출신고번호3", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN3", "전량분할발송여부3", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT3", "선기적 포장개수3", 5));
        excelInfoList.add(setColumnInfo("XPRTNO4", "수출신고번호4", 14));
        excelInfoList.add(setColumnInfo("TOTDIVSENDYN4", "전량분할발송여부4", 1));
        excelInfoList.add(setColumnInfo("WRAPCNT4", "선기적 포장개수4", 5));

        // 세부통관정보 입력
        excelInfoList.add(setColumnInfo("SKUSTOCKMGMTNO", "SKU재고관리번호", 50));
        excelInfoList.add(setColumnInfo("PAYTYPECD", "결제수단", 2));
        excelInfoList.add(setColumnInfo("CURRUNIT", "결제통화", 3));
        excelInfoList.add(setColumnInfo("PAYAPPRNO", "결제승인번호", 50));
        excelInfoList.add(setColumnInfo("DUTYPAYPRSNCD", "관세납부자", 1));
        excelInfoList.add(setColumnInfo("DUTYPAYAMT", "납부관세액", 11));
        excelInfoList.add(setColumnInfo("DUTYPAYCURR", "관세납부통화", 3));
        excelInfoList.add(setColumnInfo("BOXLENGTH", "포장상자 길이", 7));
        excelInfoList.add(setColumnInfo("BOXWIDTH", "포장상자 너비", 7));
        excelInfoList.add(setColumnInfo("BOXHEIGHT", "포장상자 높이", 7));

        Map<String, Object> extraData = new HashMap<String, Object>();
        extraData.put("SN", param.get("SN"));
        extraData.put("USER_ID", usrSession.getUserId());
        extraData.put("MALL_ID", usrSession.getUserId());
        extraData.put("REG_TYPE", param.get("REG_TYPE"));

        // INSERT EMS_EMSREG_EXCEL_DETAIL
        uploadExcelEmsregSea(model, excelInfoList, extraData);

        // 공백 데이터 삭제
        commonDAO.delete("ems.deletePickExcelDetailEmpty", param);

        // 업로드 목록 조회
        List<Map<String, Object>> xlsList = commonDAO.list("ems.selectPickExcelDetailList", param);

        // MaxSize 체크 (MaxSize 초과건 -> INSERT EMS_EMSREG_EXCEL_ERRMSG) 
        checkMaxSize(excelInfoList, xlsList);

        // Validation 체크
        checkValidationSea(usrSession, xlsList);

        return model;
    }

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

                        commonDAO.insert("ems.insertPickExcelErrmsgSelect", errMsgMap);
                    }
                }
            }
        }
    }

    @SuppressWarnings("unchecked")
    private void uploadExcelEmsreg(AjaxModel model, List<ColumnInfo> excelInfoList, Map<String, Object> extraData) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        Map<String, Object> fileMap = model.getDataList().get(0);
        Map<Integer,Map<Integer, Object>> rows = excelReader.parseExcelOnlyFirstSheet(
            new File(StringUtil.null2Str(fileMap.get("FILE_STRE_COURS")) + StringUtil.null2Str(fileMap.get("STRE_FILE_NM")) + StringUtil.null2Str(fileMap.get("FILE_SN")))
        );
        
        List<Map<String, Object>> valueList = new ArrayList<Map<String, Object>>();

        for (Integer row : rows.keySet()) {
            if (row < 4) continue;
            
            boolean bErr = false;
            String sStatusDesc = "";
            
            Map<String, Object> expDecInfo = new HashMap<String, Object>();
            
            // 주문번호에 해당되는 수출신고번호, 전량분할발송여부, 포장개수 가져옴
            String orderNo = StringUtil.null2Str(rows.get(row).get(28));
            String premiumcd = StringUtil.null2Str(rows.get(row).get(26));
            if (!orderNo.isEmpty()) {
                String wrapCnt1 = StringUtil.null2Str(rows.get(row).get(49));//ExcelUtil.getValue(row.getCell(49), true).trim();
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("ORDERNO", orderNo);
                paramMap.put("WRAPCNT1", wrapCnt1);
                paramMap.put("BIZ_NO", usrSession.getBizNo());
                expDecInfo = (Map<String, Object>) commonDAO.select("ems.selectExpDecInfo", paramMap);
            }
            
            Map<String, Object> excelData = new HashMap<String, Object>();
            for (Integer cell : rows.get(row).keySet()) {
                String cellData = StringUtil.null2Str(rows.get(row).get(cell));
                
                ColumnInfo columnInfoDTO = excelInfoList.get(cell);
                String headerId = columnInfoDTO.getHeaderId();
                int maxColumnSize = columnInfoDTO.getMaxColumnSize();
                
                excelData.put(headerId, cellData);
                
                if ("RECEIVEADDR3".equals(headerId)) { // 수취인 전체주소/ 상세주소 1
                    String COUNTRYCD = StringUtil.null2Str(rows.get(row).get(8));//ExcelUtil.getValue(row.getCell(8), true).trim();
                    String RECEIVEADDR4 = StringUtil.null2Str(rows.get(row).get(12));//ExcelUtil.getValue(row.getCell(12), true).trim();
                    String RECEIVEBUILDNM = StringUtil.null2Str(rows.get(row).get(15));//ExcelUtil.getValue(row.getCell(15), true).trim();

                    if ("US".equals(COUNTRYCD)) { // 미국행일경우 건물명+상세주소1
                        if (StringUtils.isNotEmpty(RECEIVEBUILDNM)) {
                            cellData = RECEIVEBUILDNM + " " + cellData;
                        }
                    } else { // 미국행이 아닐경우 상세주소1+상세주소2
                        if (StringUtils.isNotEmpty(RECEIVEADDR4)) {
                            cellData = cellData + " " + RECEIVEADDR4;
                        }
                    }
                }
                
                // 수출신고번호1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
                if ("XPRTNO1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
                    if (!"P".equals(premiumcd)) { // EMS 프리미엄 수출이행등록 불가
                        cellData = StringUtil.null2Str(expDecInfo.get("XPRTNO1"));
                    }
                }
                
                // 전량분할발송여부1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
//                if ("TOTDIVSENDYN1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
//                    if (!"P".equals(premiumcd)) { // EMS 프리미엄 수출이행등록 불가
//                        cellData = StringUtil.null2Str(expDecInfo.get("TOTDIVSENDYN1"));
//                    }
//                }

                // 선기적 포장개수1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
//                if ("WRAPCNT1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
//                    if (!"P".equals(premiumcd)) { // EMS 프리미엄 수출이행등록 불가
//                        cellData = StringUtil.null2Str(expDecInfo.get("WRAPCNT1"));
//                    }
//                }
                
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
                commonDAO.insert("ems.insertPickExcelDetail", param);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    @SuppressWarnings("unchecked")
    private void uploadExcelEmsregSea(AjaxModel model, List<ColumnInfo> excelInfoList, Map<String, Object> extraData) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        
        Map<String, Object> fileMap = model.getDataList().get(0);
        Map<Integer,Map<Integer, Object>> rows = excelReader.parseExcelOnlyFirstSheet(
            new File(StringUtil.null2Str(fileMap.get("FILE_STRE_COURS")) + StringUtil.null2Str(fileMap.get("STRE_FILE_NM")) + StringUtil.null2Str(fileMap.get("FILE_SN")))
        );
        
        List<Map<String, Object>> valueList = new ArrayList<Map<String, Object>>();

        for (Integer row : rows.keySet()) {
            if (row < 4) continue;
            
            boolean bErr = false;
            String sStatusDesc = "";
            
            Map<String, Object> expDecInfo = new HashMap<String, Object>();
            
            // 주문번호에 해당되는 수출신고번호, 전량분할발송여부, 포장개수 가져옴
            String orderNo = StringUtil.null2Str(rows.get(row).get(21));//ExcelUtil.getValue(row.getCell(21), true).trim();
            if (!orderNo.isEmpty()) {
                String wrapCnt1 = StringUtil.null2Str(rows.get(row).get(42));//ExcelUtil.getValue(row.getCell(42), true).trim();
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("ORDERNO", orderNo);
                paramMap.put("WRAPCNT1", wrapCnt1);
                paramMap.put("BIZ_NO", usrSession.getBizNo());
                expDecInfo = (Map<String, Object>) commonDAO.select("ems.selectExpDecInfo", paramMap);
            }
            
            Map<String, Object> excelData = new HashMap<String, Object>();
            for (Integer cell : rows.get(row).keySet()) {
                String cellData = StringUtil.null2Str(rows.get(row).get(cell));
                
                ColumnInfo columnInfoDTO = excelInfoList.get(cell);
                String headerId = columnInfoDTO.getHeaderId();
                int maxColumnSize = columnInfoDTO.getMaxColumnSize();
                
                excelData.put(headerId, cellData);
                
                if ("RECEIVEADDR3".equals(headerId)) { // 주소 1
                    String RECEIVEADDR4 = StringUtil.null2Str(rows.get(row).get(10));//ExcelUtil.getValue(row.getCell(10), true).trim();
                    if (StringUtils.isNotEmpty(RECEIVEADDR4)) {
                        cellData = cellData + " " + RECEIVEADDR4;
                    }
                }
                if ("PAYTYPECD".equals(headerId)) { // 결제수단
                    cellData = StringUtil.toShortenStringMB(cellData, maxColumnSize);
                }
                if ("DUTYPAYPRSNCD".equals(headerId)) { // 관세납부자
                    cellData = StringUtil.toShortenStringMB(cellData, maxColumnSize);
                }

                // 수출신고번호1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
                if ("XPRTNO1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
                    cellData = StringUtil.null2Str(expDecInfo.get("XPRTNO1"));
                }

                // 전량분할발송여부1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
//                if ("TOTDIVSENDYN1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
//                    cellData = StringUtil.null2Str(expDecInfo.get("TOTDIVSENDYN1"));
//                }

                // 선기적 포장개수1 값이 없고 수출신고수리내역에 정보가 있으면 수출신고수리내역정보를 입력
//                if ("WRAPCNT1".equals(headerId) && StringUtil.isEmpty(cellData) && MapUtils.isNotEmpty(expDecInfo)) {
//                    cellData = StringUtil.null2Str(expDecInfo.get("WRAPCNT1"));
//                }
                
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
                commonDAO.insert("ems.insertPickExcelDetail", param);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    // 오류 체크
    private void checkValidationEms(UsrSessionModel usrSession, List<Map<String, Object>> xlsList) throws Exception {
        List<Map<String, Object>> rowErrorList = null;
        for (Map<String, Object> xls : xlsList) {
            boolean bErr = false;
            rowErrorList = new ArrayList<Map<String, Object>>();

            String EM_GUBUN = StringUtil.null2Str(xls.get("EM_GUBUN"));
            String RECEIVENAME = StringUtil.null2Str(xls.get("RECEIVENAME"));
            String RECEIVEMAIL = StringUtil.null2Str(xls.get("RECEIVEMAIL"));
            String RECEIVETELNO1 = StringUtil.null2Str(xls.get("RECEIVETELNO1"));
            String RECEIVETELNO2 = StringUtil.null2Str(xls.get("RECEIVETELNO2"));
            String RECEIVETELNO3 = StringUtil.null2Str(xls.get("RECEIVETELNO3"));
            String RECEIVETELNO4 = StringUtil.null2Str(xls.get("RECEIVETELNO4"));
            String RECEIVETELNO = StringUtil.null2Str(xls.get("RECEIVETELNO"));
            String COUNTRYCD = StringUtil.null2Str(xls.get("COUNTRYCD"));
            String RECEIVEZIPCODE = StringUtil.null2Str(xls.get("RECEIVEZIPCODE"));
            String RECEIVEADDR3 = StringUtil.null2Str(xls.get("RECEIVEADDR3"));
            String RECEIVEADDR2 = StringUtil.null2Str(xls.get("RECEIVEADDR2"));
            String RECEIVEADDR1 = StringUtil.null2Str(xls.get("RECEIVEADDR1"));
            String TOTWEIGHT = StringUtil.null2Str(xls.get("TOTWEIGHT"));
            String CONTENTS = StringUtil.null2Str(xls.get("CONTENTS"));
            String ITEM_NUMBER = StringUtil.null2Str(xls.get("ITEM_NUMBER"));
            String ITEM_WEIGHT = StringUtil.null2Str(xls.get("ITEM_WEIGHT"));
            String ITEM_VALUE = StringUtil.null2Str(xls.get("ITEM_VALUE"));
            String HS_CODE = StringUtil.null2Str(xls.get("HS_CODE"));
            String ORIGIN = StringUtil.null2Str(xls.get("ORIGIN"));
            String MODELNO = StringUtil.null2Str(xls.get("MODELNO"));
            String BOYN = StringUtil.nvl(xls.get("BOYN"), "N");
            String BOPRC = StringUtil.null2Str(xls.get("BOPRC"));
            String PREMIUMCD = StringUtil.null2Str(xls.get("PREMIUMCD"));
            String EM_EE = StringUtil.null2Str(xls.get("EM_EE"));
            String ORDERNO = StringUtil.null2Str(xls.get("ORDERNO"));
            String ORDERPRSNZIPCD = StringUtil.null2Str(xls.get("ORDERPRSNZIPCD"));
            String ORDERPRSNTELNNO = StringUtil.null2Str(xls.get("ORDERPRSNTELNNO"));
            String ORDERPRSNTELFNO = StringUtil.null2Str(xls.get("ORDERPRSNTELFNO"));
            String ORDERPRSNTELMNO = StringUtil.null2Str(xls.get("ORDERPRSNTELMNO"));
            String ORDERPRSNTELLNO = StringUtil.null2Str(xls.get("ORDERPRSNTELLNO"));
            String ORDERPRSNTELNO = StringUtil.null2Str(xls.get("ORDERPRSNTELNO"));
            String ORDERPRSNHTELFNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELFNO"));
            String ORDERPRSNHTELMNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELMNO"));
            String ORDERPRSNHTELLNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELLNO"));
            String ORDERPRSNHTELNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELNO"));
            String ECOMMERCEYN = StringUtil.null2Str(xls.get("ECOMMERCEYN"));
            String BIZREGNO = StringUtil.null2Str(xls.get("BIZREGNO"));
            String EXPORTSENDPRSNNM = StringUtil.null2Str(xls.get("EXPORTSENDPRSNNM"));
            String EXPORTSENDPRSNADDR = StringUtil.null2Str(xls.get("EXPORTSENDPRSNADDR"));
            String XPRTNO1 = StringUtil.null2Str(xls.get("XPRTNO1"));
            String XPRTNO2 = StringUtil.null2Str(xls.get("XPRTNO2"));
            String XPRTNO3 = StringUtil.null2Str(xls.get("XPRTNO3"));
            String XPRTNO4 = StringUtil.null2Str(xls.get("XPRTNO4"));
            String XPRTNOYN = StringUtil.null2Str(xls.get("XPRTNOYN"));
            String TOTDIVSENDYN1 = StringUtil.null2Str(xls.get("TOTDIVSENDYN1"));
            String TOTDIVSENDYN2 = StringUtil.null2Str(xls.get("TOTDIVSENDYN2"));
            String TOTDIVSENDYN3 = StringUtil.null2Str(xls.get("TOTDIVSENDYN3"));
            String TOTDIVSENDYN4 = StringUtil.null2Str(xls.get("TOTDIVSENDYN4"));
            String WRAPCNT1 = StringUtil.null2Str(xls.get("WRAPCNT1"));
            String WRAPCNT2 = StringUtil.null2Str(xls.get("WRAPCNT2"));
            String WRAPCNT3 = StringUtil.null2Str(xls.get("WRAPCNT3"));
            String WRAPCNT4 = StringUtil.null2Str(xls.get("WRAPCNT4"));

            // 필수값 체크
            try {
                EmsValidator.isValidEmGubun(EM_GUBUN, "상품구분", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EM_GUBUN", EM_GUBUN, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveName(RECEIVENAME, "수취인명", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVENAME", RECEIVENAME, e.getMessage());
            }
            try {
                EmsValidator.isValidReceivEmail(RECEIVEMAIL, "수취인EMAIL", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEMAIL", RECEIVEMAIL, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO1, "수취인전화 국가번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO1", RECEIVETELNO1, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO2, "수취인전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO2", RECEIVETELNO2, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO3, "수취인전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO3", RECEIVETELNO3, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO4, "수취인전화 전화번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO4", RECEIVETELNO4, e.getMessage());
            }
            try {
                boolean isEmpty = StringUtils.isEmpty(RECEIVETELNO1) || StringUtils.isEmpty(RECEIVETELNO2) || StringUtils.isEmpty(RECEIVETELNO3)
                        || StringUtils.isEmpty(RECEIVETELNO4);
                EmsValidator.isValidReceiveTelno(RECEIVETELNO, "수취인전화 전체번호", isEmpty ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO", RECEIVETELNO, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(COUNTRYCD, "수취인국가코드", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "COUNTRYCD", COUNTRYCD, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveZipcode(RECEIVEZIPCODE, "수취인 우편번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEZIPCODE", RECEIVEZIPCODE, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveAddr3(RECEIVEADDR3, "수취인 전체주소/ 상세주소 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEADDR3", RECEIVEADDR3, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveAddr2(RECEIVEADDR2, "수취인 시/군 주소", "US".equals(COUNTRYCD) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEADDR2", RECEIVEADDR2, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveAddr1(RECEIVEADDR1, "수취인 주/도 주소", "US".equals(COUNTRYCD) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEADDR1", RECEIVEADDR1, e.getMessage());
            }
            try {
                EmsValidator.isValidTotWeight(TOTWEIGHT, "총중량", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTWEIGHT", TOTWEIGHT, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(CONTENTS);
                for (String value : values) {
                    EmsValidator.isValidContents(value, "내용품명", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "CONTENTS", CONTENTS, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_NUMBER);
                for (String value : values) {
                    EmsValidator.isValidItemNumber(value, "개수", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_NUMBER", ITEM_NUMBER, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_WEIGHT);
                for (String value : values) {
                    EmsValidator.isValidItemWeight(value, "순중량", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT", ITEM_WEIGHT, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_VALUE);
                for (String value : values) {
                    EmsValidator.isValidItemValue(value, "가격", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_VALUE", ITEM_VALUE, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(HS_CODE);
                for (String value : values) {
                    commonValidator.isValidHsCode(value, "HS_CODE", "US".equals(COUNTRYCD) ? true : false);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "HS_CODE", HS_CODE, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ORIGIN);
                for (String value : values) {
                    commonValidator.isValidCountryCode(value, "생산지", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORIGIN", ORIGIN, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(MODELNO);
                for (String value : values) {
                    EmsValidator.isValidModelNo(value, "모델명", false);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORIGIN", ORIGIN, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(BOYN, "보험가입여부", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOYN", BOYN, e.getMessage());
            }
            try {
                EmsValidator.isValidBoPrc(BOPRC, "보험가입금액", "Y".equals(BOYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOPRC", BOPRC, e.getMessage());
            }
            try {
                EmsValidator.isValidPremiumCd(PREMIUMCD, "우편물구분코드", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "PREMIUMCD", PREMIUMCD, e.getMessage());
            }
            try {
                EmsValidator.isValidEmEe(EM_EE, "우편물종류코드", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EM_EE", EM_EE, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderNo(ORDERNO, "고객주문번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERNO", ORDERNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNZIPCD, "주문인 우편번호", 6, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNZIPCD", ORDERPRSNZIPCD, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELNNO, "주문인전화 국가번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELNNO", ORDERPRSNTELNNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELFNO, "주문인전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELFNO", ORDERPRSNTELFNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELMNO, "주문인전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELMNO", ORDERPRSNTELMNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELLNO, "주문인전화 전화번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELLNO", ORDERPRSNTELLNO, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderTelno(ORDERPRSNTELNO, "주문인전화 전체번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELNO", ORDERPRSNTELNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELFNO, "주문인휴대전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELFNO", ORDERPRSNHTELFNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELMNO, "주문인휴대전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELMNO", ORDERPRSNHTELMNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELLNO, "주문인휴대전화 끝번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELLNO", ORDERPRSNHTELLNO, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderHTelno(ORDERPRSNHTELNO, "주문인휴대전화 전체번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELNO", ORDERPRSNHTELNO, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(ECOMMERCEYN, "수출우편물정보관세청제공여부", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ECOMMERCEYN", ECOMMERCEYN, e.getMessage());
            }
            try {
                EmsValidator.isValidBizRegNo(BIZREGNO, "사업자번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BIZREGNO", BIZREGNO, e.getMessage());
            }
            try {
                EmsValidator.isValidExportSendPrsnNm(EXPORTSENDPRSNNM, "수출화주 이름 또는 상호", "Y".equals(ECOMMERCEYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EXPORTSENDPRSNNM", EXPORTSENDPRSNNM, e.getMessage());
            }
            try {
                EmsValidator.isValidExportSendPrsnAddr(EXPORTSENDPRSNADDR, "수출화주 주소", "Y".equals(ECOMMERCEYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EXPORTSENDPRSNADDR", EXPORTSENDPRSNADDR, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(XPRTNOYN, "수출이행등록여부", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNOYN", XPRTNOYN, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN1, "전량분할발송여부1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN1", TOTDIVSENDYN1, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN2, "전량분할발송여부2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN2", TOTDIVSENDYN2, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN3, "전량분할발송여부3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN3", TOTDIVSENDYN3, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN4, "전량분할발송여부4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN4", TOTDIVSENDYN4, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT1, "선기적 포장개수1", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT1", WRAPCNT1, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT2, "선기적 포장개수2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT2", WRAPCNT2, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT3, "선기적 포장개수3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT3", WRAPCNT3, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT4, "선기적 포장개수4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT4", WRAPCNT4, e.getMessage());
            }

            // 주문번호 검증 
            try {
                Map<String, Object> searchParam = new HashMap<String, Object>();
                searchParam.put("ORDERNO", ORDERNO);
                searchParam.put("REG_ID", usrSession.getUserId());
                searchParam.put("BIZ_NO", usrSession.getBizNo());
                int iCnt = (int) commonDAO.select("ems.selectExistOrderId", searchParam);
                if (iCnt == 0) {
                    throw new BizException("해당 주문번호로 수출신고요청한 건이 존재하지 않습니다. 주문번호[" + ORDERNO + "]");
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERNO", ORDERNO, e.getMessage());
            }

            // 수출신고번호1 검증
            try {
                if (!"".equals(XPRTNO1)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO1);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호1[" + XPRTNO1 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO1);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO1, "수출신고번호1", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호1[" + XPRTNO1 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO1", XPRTNO1, e.getMessage());
            }

            // 수출신고번호2 검증
            try {
                if (!"".equals(XPRTNO2)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO2);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호2[" + XPRTNO2 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO2);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO2, "수출신고번호2", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호2[" + XPRTNO2 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO2", XPRTNO2, e.getMessage());
            }

            // 수출신고번호3 검증
            try {
                if (!"".equals(XPRTNO3)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO3);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호3[" + XPRTNO3 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO3);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO3, "수출신고번호3", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호3[" + XPRTNO3 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO3", XPRTNO3, e.getMessage());
            }

            // 수출신고번호4 검증
            try {
                if (!"".equals(XPRTNO4)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO4);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호4[" + XPRTNO4 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO4);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO4, "수출신고번호4", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호4[" + XPRTNO4 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO4", XPRTNO4, e.getMessage());
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
                commonDAO.update("ems.updatePickExcelDetailStatusDesc", chkDaoParam);
                commonDAO.update("ems.updatePickExcelDetail", chkDaoParam);
                
                // 엑셀 에러메시지가 존재할 경우 기존 내용 삭제 후 등록
                if (rowErrorList.size() > 0) {
                    commonDAO.delete("ems.deletePickExcelErrmsg", chkDaoParam);
                }

                Map<String, Object> errMsgMap = null;
                for (Map<String, Object> errorInfo : rowErrorList) {
                    errMsgMap = new HashMap<String, Object>(errorInfo);
                    errMsgMap.put("SN", chkDaoParam.get("SN"));
                    errMsgMap.put("SEQ", chkDaoParam.get("SEQ"));

                    try {
                        commonDAO.insert("ems.insertPickExcelErrmsg", errMsgMap);
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
                commonDAO.update("ems.updatePickExcelDetailStatusDesc", chkDaoParam);
                commonDAO.delete("ems.deletePickExcelErrmsg", chkDaoParam);
            }
        }
    }

    // 오류 체크
    private void checkValidationSea(UsrSessionModel usrSession, List<Map<String, Object>> xlsList) throws Exception {
        List<Map<String, Object>> rowErrorList = null;
        for (Map<String, Object> xls : xlsList) {
            boolean bErr = false;
            rowErrorList = new ArrayList<Map<String, Object>>();

            String EM_GUBUN = StringUtil.null2Str(xls.get("EM_GUBUN"));
            String RECEIVENAME = StringUtil.null2Str(xls.get("RECEIVENAME"));
            String RECEIVEMAIL = StringUtil.null2Str(xls.get("RECEIVEMAIL"));
            String RECEIVETELNO1 = StringUtil.null2Str(xls.get("RECEIVETELNO1"));
            String RECEIVETELNO2 = StringUtil.null2Str(xls.get("RECEIVETELNO2"));
            String RECEIVETELNO3 = StringUtil.null2Str(xls.get("RECEIVETELNO3"));
            String RECEIVETELNO4 = StringUtil.null2Str(xls.get("RECEIVETELNO4"));
            String RECEIVETELNO = StringUtil.null2Str(xls.get("RECEIVETELNO"));
            String COUNTRYCD = StringUtil.null2Str(xls.get("COUNTRYCD"));
            String RECEIVEZIPCODE = StringUtil.null2Str(xls.get("RECEIVEZIPCODE"));
            String RECEIVEADDR3 = StringUtil.null2Str(xls.get("RECEIVEADDR3"));
            String TOTWEIGHT = StringUtil.null2Str(xls.get("TOTWEIGHT"));
            String CONTENTS = StringUtil.null2Str(xls.get("CONTENTS"));
            String ITEM_NUMBER = StringUtil.null2Str(xls.get("ITEM_NUMBER"));
            String ITEM_WEIGHT = StringUtil.null2Str(xls.get("ITEM_WEIGHT"));
            String ITEM_VALUE = StringUtil.null2Str(xls.get("ITEM_VALUE"));
            String HS_CODE = StringUtil.null2Str(xls.get("HS_CODE"));
            String ORIGIN = StringUtil.null2Str(xls.get("ORIGIN"));
            String MODELNO = StringUtil.null2Str(xls.get("MODELNO"));
            String BOYN = StringUtil.nvl(xls.get("BOYN"), "N");
            String BOPRC = StringUtil.null2Str(xls.get("BOPRC"));
            String ORDERNO = StringUtil.null2Str(xls.get("ORDERNO"));
            String ORDERPRSNZIPCD = StringUtil.null2Str(xls.get("ORDERPRSNZIPCD"));
            String ORDERPRSNTELNNO = StringUtil.null2Str(xls.get("ORDERPRSNTELNNO"));
            String ORDERPRSNTELFNO = StringUtil.null2Str(xls.get("ORDERPRSNTELFNO"));
            String ORDERPRSNTELMNO = StringUtil.null2Str(xls.get("ORDERPRSNTELMNO"));
            String ORDERPRSNTELLNO = StringUtil.null2Str(xls.get("ORDERPRSNTELLNO"));
            String ORDERPRSNTELNO = StringUtil.null2Str(xls.get("ORDERPRSNTELNO"));
            String ORDERPRSNHTELFNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELFNO"));
            String ORDERPRSNHTELMNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELMNO"));
            String ORDERPRSNHTELLNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELLNO"));
            String ORDERPRSNHTELNO = StringUtil.null2Str(xls.get("ORDERPRSNHTELNO"));
            String ECOMMERCEYN = StringUtil.null2Str(xls.get("ECOMMERCEYN"));
            String BIZREGNO = StringUtil.null2Str(xls.get("BIZREGNO"));
            String EXPORTSENDPRSNNM = StringUtil.null2Str(xls.get("EXPORTSENDPRSNNM"));
            String EXPORTSENDPRSNADDR = StringUtil.null2Str(xls.get("EXPORTSENDPRSNADDR"));
            String XPRTNO1 = StringUtil.null2Str(xls.get("XPRTNO1"));
            String XPRTNO2 = StringUtil.null2Str(xls.get("XPRTNO2"));
            String XPRTNO3 = StringUtil.null2Str(xls.get("XPRTNO3"));
            String XPRTNO4 = StringUtil.null2Str(xls.get("XPRTNO4"));
            String XPRTNOYN = StringUtil.null2Str(xls.get("XPRTNOYN"));
            String TOTDIVSENDYN1 = StringUtil.null2Str(xls.get("TOTDIVSENDYN1"));
            String TOTDIVSENDYN2 = StringUtil.null2Str(xls.get("TOTDIVSENDYN2"));
            String TOTDIVSENDYN3 = StringUtil.null2Str(xls.get("TOTDIVSENDYN3"));
            String TOTDIVSENDYN4 = StringUtil.null2Str(xls.get("TOTDIVSENDYN4"));
            String WRAPCNT1 = StringUtil.null2Str(xls.get("WRAPCNT1"));
            String WRAPCNT2 = StringUtil.null2Str(xls.get("WRAPCNT2"));
            String WRAPCNT3 = StringUtil.null2Str(xls.get("WRAPCNT3"));
            String WRAPCNT4 = StringUtil.null2Str(xls.get("WRAPCNT4"));

            // 해상특송 통관정보
            String SKUSTOCKMGMTNO = StringUtil.null2Str(xls.get("SKUSTOCKMGMTNO"));
            String PAYTYPECD = StringUtil.null2Str(xls.get("PAYTYPECD"));
            String CURRUNIT = StringUtil.null2Str(xls.get("CURRUNIT"));
            String PAYAPPRNO = StringUtil.null2Str(xls.get("PAYAPPRNO"));
            String DUTYPAYPRSNCD = StringUtil.null2Str(xls.get("DUTYPAYPRSNCD"));
            String DUTYPAYAMT = StringUtil.null2Str(xls.get("DUTYPAYAMT"));
            String DUTYPAYCURR = StringUtil.null2Str(xls.get("DUTYPAYCURR"));
            String BOXLENGTH = StringUtil.null2Str(xls.get("BOXLENGTH"));
            String BOXWIDTH = StringUtil.null2Str(xls.get("BOXWIDTH"));
            String BOXHEIGHT = StringUtil.null2Str(xls.get("BOXHEIGHT"));

            // 필수값 체크
            try {
                EmsValidator.isValidEmGubun(EM_GUBUN, "상품구분", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EM_GUBUN", EM_GUBUN, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveName(RECEIVENAME, "수취인명", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVENAME", RECEIVENAME, e.getMessage());
            }
            try {
                EmsValidator.isValidReceivEmail(RECEIVEMAIL, "수취인EMAIL", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEMAIL", RECEIVEMAIL, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO1, "수취인전화 국가번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO1", RECEIVETELNO1, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO2, "수취인전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO2", RECEIVETELNO2, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO3, "수취인전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO3", RECEIVETELNO3, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(RECEIVETELNO4, "수취인전화 전화번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO4", RECEIVETELNO4, e.getMessage());
            }
            try {
                boolean isEmpty = StringUtils.isEmpty(RECEIVETELNO1) || StringUtils.isEmpty(RECEIVETELNO2) || StringUtils.isEmpty(RECEIVETELNO3)
                        || StringUtils.isEmpty(RECEIVETELNO4);
                EmsValidator.isValidReceiveTelno(RECEIVETELNO, "수취인전화 전체번호", isEmpty ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVETELNO", RECEIVETELNO, e.getMessage());
            }
            try {
                commonValidator.isValidCountryCode(COUNTRYCD, "수취인국가코드", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "COUNTRYCD", COUNTRYCD, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveZipcode(RECEIVEZIPCODE, "수취인 우편번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEZIPCODE", RECEIVEZIPCODE, e.getMessage());
            }
            try {
                EmsValidator.isValidReceiveAddr3(RECEIVEADDR3, "수취인 전체주소/ 상세주소 1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "RECEIVEADDR3", RECEIVEADDR3, e.getMessage());
            }
            try {
                EmsValidator.isValidTotWeight(TOTWEIGHT, "총중량", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTWEIGHT", TOTWEIGHT, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(CONTENTS);
                for (String value : values) {
                    EmsValidator.isValidContents(value, "내용품명", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "CONTENTS", CONTENTS, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_NUMBER);
                for (String value : values) {
                    EmsValidator.isValidItemNumber(value, "개수", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_NUMBER", ITEM_NUMBER, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_WEIGHT);
                for (String value : values) {
                    EmsValidator.isValidItemWeight(value, "순중량", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_WEIGHT", ITEM_WEIGHT, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ITEM_VALUE);
                for (String value : values) {
                    EmsValidator.isValidItemValue(value, "가격", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ITEM_VALUE", ITEM_VALUE, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(HS_CODE);
                for (String value : values) {
                    commonValidator.isValidHsCode(value, "HS_CODE", false);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "HS_CODE", HS_CODE, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(ORIGIN);
                for (String value : values) {
                    commonValidator.isValidCountryCode(value, "생산지", true);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORIGIN", ORIGIN, e.getMessage());
            }
            try {
                String[] values = splitSemicolon(MODELNO);
                for (String value : values) {
                    EmsValidator.isValidModelNo(value, "모델명", false);
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORIGIN", ORIGIN, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(BOYN, "보험가입여부", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOYN", BOYN, e.getMessage());
            }
            try {
                EmsValidator.isValidBoPrc(BOPRC, "보험가입금액", "Y".equals(BOYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOPRC", BOPRC, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderNo(ORDERNO, "고객주문번호", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERNO", ORDERNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNZIPCD, "주문인 우편번호", 6, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNZIPCD", ORDERPRSNZIPCD, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELNNO, "주문인전화 국가번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELNNO", ORDERPRSNTELNNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELFNO, "주문인전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELFNO", ORDERPRSNTELFNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELMNO, "주문인전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELMNO", ORDERPRSNTELMNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNTELLNO, "주문인전화 전화번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELLNO", ORDERPRSNTELLNO, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderTelno(ORDERPRSNTELNO, "주문인전화 전체번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNTELNO", ORDERPRSNTELNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELFNO, "주문인휴대전화 지역번호", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELFNO", ORDERPRSNHTELFNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELMNO, "주문인휴대전화 국번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELMNO", ORDERPRSNHTELMNO, e.getMessage());
            }
            try {
                EmsValidator.isValidMaxLengthNumber(ORDERPRSNHTELLNO, "주문인휴대전화 끝번", 4, false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELLNO", ORDERPRSNHTELLNO, e.getMessage());
            }
            try {
                EmsValidator.isValidOrderHTelno(ORDERPRSNHTELNO, "주문인휴대전화 전체번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERPRSNHTELNO", ORDERPRSNHTELNO, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(ECOMMERCEYN, "수출우편물정보관세청제공여부", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ECOMMERCEYN", ECOMMERCEYN, e.getMessage());
            }
            try {
                EmsValidator.isValidBizRegNo(BIZREGNO, "사업자번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BIZREGNO", BIZREGNO, e.getMessage());
            }
            try {
                EmsValidator.isValidExportSendPrsnNm(EXPORTSENDPRSNNM, "수출화주 이름 또는 상호", "Y".equals(ECOMMERCEYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EXPORTSENDPRSNNM", EXPORTSENDPRSNNM, e.getMessage());
            }
            try {
                EmsValidator.isValidExportSendPrsnAddr(EXPORTSENDPRSNADDR, "수출화주 주소", "Y".equals(ECOMMERCEYN) ? true : false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "EXPORTSENDPRSNADDR", EXPORTSENDPRSNADDR, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(XPRTNOYN, "수출이행등록여부", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNOYN", XPRTNOYN, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN1, "전량분할발송여부1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN1", TOTDIVSENDYN1, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN2, "전량분할발송여부2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN2", TOTDIVSENDYN2, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN3, "전량분할발송여부3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN3", TOTDIVSENDYN3, e.getMessage());
            }
            try {
                EmsValidator.isValidYn(TOTDIVSENDYN4, "전량분할발송여부4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "TOTDIVSENDYN4", TOTDIVSENDYN4, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT1, "선기적 포장개수1", true);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT1", WRAPCNT1, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT2, "선기적 포장개수2", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT2", WRAPCNT2, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT3, "선기적 포장개수3", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT3", WRAPCNT3, e.getMessage());
            }
            try {
                EmsValidator.isValidWrapCnt(WRAPCNT4, "선기적 포장개수4", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "WRAPCNT4", WRAPCNT4, e.getMessage());
            }
            try {
                EmsValidator.isValidSkuStockMgmtNo(SKUSTOCKMGMTNO, "SKU재고관리번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "SKUSTOCKMGMTNO", SKUSTOCKMGMTNO, e.getMessage());
            }
            try {
                EmsValidator.isValidPayTypeCd(PAYTYPECD, "결제수단", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "PAYTYPECD", PAYTYPECD, e.getMessage());
            }
            try {
                EmsValidator.isValidCurrUnit(CURRUNIT, "결제통화", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "CURRUNIT", CURRUNIT, e.getMessage());
            }
            try {
                EmsValidator.isValidPayApprNo(PAYAPPRNO, "결제승인번호", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "PAYAPPRNO", PAYAPPRNO, e.getMessage());
            }
            try {
                EmsValidator.isValidDutyPayPrsnCd(DUTYPAYPRSNCD, "관세납부자", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "DUTYPAYPRSNCD", DUTYPAYPRSNCD, e.getMessage());
            }
            try {
                EmsValidator.isValidDutyPayAmt(DUTYPAYAMT, "납부관세액", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "DUTYPAYAMT", DUTYPAYAMT, e.getMessage());
            }
            try {
                EmsValidator.isValidDutyPayCurr(DUTYPAYCURR, "관세납부통화", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "DUTYPAYCURR", DUTYPAYCURR, e.getMessage());
            }
            try {
                EmsValidator.isValidBoxSize(BOXLENGTH, "포장상자 길이", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOXLENGTH", BOXLENGTH, e.getMessage());
            }
            try {
                EmsValidator.isValidBoxSize(BOXWIDTH, "포장상자 너비", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOXWIDTH", BOXWIDTH, e.getMessage());
            }
            try {
                EmsValidator.isValidBoxSize(BOXHEIGHT, "포장상자 높이", false);
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "BOXHEIGHT", BOXHEIGHT, e.getMessage());
            }

            // 주문번호 검증 
            try {
                Map<String, Object> searchParam = new HashMap<String, Object>();
                searchParam.put("ORDERNO", ORDERNO);
                searchParam.put("REG_ID", usrSession.getUserId());
                searchParam.put("BIZ_NO", usrSession.getBizNo());
                int iCnt = (int) commonDAO.select("ems.selectExistOrderId", searchParam);
                if (iCnt == 0) {
                    throw new BizException("주문번호가 존재하지 않습니다. 주문번호[" + ORDERNO + "]");
                }
                else {
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isNotEmpty(COUNTRYCD)) {
                        if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                            throw new BizException("수취인 국가와 목적지가 다른 주문번호입니다. 주문번호[" + ORDERNO + "], 목적지[" + countryCode + "]");
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "ORDERNO", ORDERNO, e.getMessage());
            }

            // 수출신고번호1 검증
            try {
                if (!"".equals(XPRTNO1)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO1);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호1[" + XPRTNO1 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO1);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO1, "수출신고번호1", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호1[" + XPRTNO1 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO1", XPRTNO1, e.getMessage());
            }

            // 수출신고번호2 검증
            try {
                if (!"".equals(XPRTNO2)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO2);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호2[" + XPRTNO2 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO2);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO2, "수출신고번호2", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호2[" + XPRTNO2 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO2", XPRTNO2, e.getMessage());
            }

            // 수출신고번호3 검증
            try {
                if (!"".equals(XPRTNO3)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO3);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호3[" + XPRTNO3 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO3);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO3, "수출신고번호3", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호3[" + XPRTNO3 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO3", XPRTNO3, e.getMessage());
            }

            // 수출신고번호4 검증
            try {
                if (!"".equals(XPRTNO4)) {
//                    Map<String, Object> searchParam = new HashMap<String, Object>();
//                    searchParam.put("XPRTNO", XPRTNO4);
//                    searchParam.put("REG_ID", usrSession.getUserId());
//                    searchParam.put("BIZ_NO", usrSession.getBizNo());
//                    int iCnt = (int) commonDAO.select("ems.selectExistRptNo", searchParam);
//                    if (iCnt == 0) {
//                        throw new BizException("수출신고번호가 존재하지 않습니다. 수출신고번호4[" + XPRTNO4 + "]");
//                    }
                    
                    Map<String, Object> searchParam = new HashMap<String, Object>();
                    searchParam.put("XPRTNO", XPRTNO4);
                    searchParam.put("REG_ID", usrSession.getUserId());
                    searchParam.put("BIZ_NO", usrSession.getBizNo());
                    String countryCode = (String) commonDAO.select("ems.selectDestinationCountryCode", searchParam);
                    if (StringUtils.isEmpty(countryCode)) { // 수출신고번호가 없으면 자릿수만 체크
                        EmsValidator.isValidXprtNo(XPRTNO4, "수출신고번호4", false);
                    }
                    else { // 수출신고번호가 있으면 목적지 체크
                        if (StringUtils.isNotEmpty(COUNTRYCD)) {
                            if (!StringUtils.equals(COUNTRYCD, countryCode)) {
                                throw new BizException("수취인 국가와 목적지가 다른 수출신고번호입니다. 수출신고번호4[" + XPRTNO4 + "], 목적지[" + countryCode + "]");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                addErrorInfo(rowErrorList, "XPRTNO4", XPRTNO4, e.getMessage());
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
                commonDAO.update("ems.updatePickExcelDetailStatusDesc", chkDaoParam);
                commonDAO.update("ems.updatePickExcelDetail", chkDaoParam);
                
                // 엑셀 에러메시지가 존재할 경우 기존 내용 삭제 후 등록
                if (rowErrorList.size() > 0) {
                    commonDAO.delete("ems.deletePickExcelErrmsg", chkDaoParam);
                }

                Map<String, Object> errMsgMap = null;
                for (Map<String, Object> errorInfo : rowErrorList) {
                    errMsgMap = new HashMap<String, Object>(errorInfo);
                    errMsgMap.put("SN", chkDaoParam.get("SN"));
                    errMsgMap.put("SEQ", chkDaoParam.get("SEQ"));

                    try {
                        commonDAO.insert("ems.insertPickExcelErrmsg", errMsgMap);
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
                commonDAO.update("ems.updatePickExcelDetailStatusDesc", chkDaoParam);
                commonDAO.delete("ems.deletePickExcelErrmsg", chkDaoParam);
            }
        }
    }

    private String[] splitSemicolon(String str) {
        if (str.endsWith(";")) {
            str = str.substring(0, str.length() - 1); // 마지막 ";" 제거
        }
        return str.split(";");
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
    // =============================================픽업요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 목록
     */
    @Override
    public AjaxModel selectPickDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    // ========================================================================================================= //
    // =============================================픽업요청 상세정보============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 정보
     */
    @Override
    public AjaxModel selectPickDetailInfo(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        model = commonService.select(model);
        return model;
    }
    
    /**
     * EMS 픽업요청 상세정보 저장
     */
    @Override
    public AjaxModel savePickDetailInfo(AjaxModel model) throws Exception {
        UsrSessionModel session = model.getUsrSessionModel();
        
        Map<String, Object> param = model.getData();
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        list.add(param);
        
        if ("es".equals(param.get("EM_EE"))) {
            checkValidationSea(session, list); // 한중해상특송
        }
        else {
            checkValidationEms(session, list); // EMS/K-Packet
        }
        
        commonDAO.update("ems.updatePickDetailInfo", param);
        
        model.setCode("I00000003"); //저장되었습니다.
        
        return model;
    }
    

    // ========================================================================================================= //
    // ==================================================합배송================================================== //
    // ========================================================================================================= //

    /**
     * 합배송관리 리스트
     */
    @Override
    public AjaxModel selectPickMergeMasterList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * 합배송관리 Sub 리스트
     */
    @Override
    public AjaxModel selectPickMergeDetailList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        // sub list
        String qKey = (String) param.get(Constant.QUERY_KEY.getCode());
        List<Map<String, Object>> subList = commonDAO.list(qKey, param);
//        List<Map<String, Object>> subList = commonService.selectList(model).getDataList();
        model.setDataList(subList);
        return model;
    }

    /**
     * 합배송추가 - 수출신고수리내역 리스트
     */
    @Override
    public AjaxModel selectPickMergeList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        param.put("BIZ_NO", model.getUsrSessionModel().getBizNo());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * 합배송추가 - 저장
     */
    @Override
    public AjaxModel savePickMerge(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        JSONParser parser = new JSONParser();
        JSONArray jsonArray = (JSONArray) parser.parse(MapUtils.getString(param, "PARAMS"));
        JSONObject row1 = jsonArray.size() > 0 ? (JSONObject) jsonArray.get(0) : new JSONObject();
        JSONObject row2 = jsonArray.size() > 1 ? (JSONObject) jsonArray.get(1) : new JSONObject();
        JSONObject row3 = jsonArray.size() > 2 ? (JSONObject) jsonArray.get(2) : new JSONObject();
        JSONObject row4 = jsonArray.size() > 3 ? (JSONObject) jsonArray.get(3) : new JSONObject();

        param.put("XPRTNO1", row1.get("XPRTNO"));
        param.put("TOTDIVSENDYN1", row1.get("TOTDIVSENDYN"));
        param.put("WRAPCNT1", row1.get("WRAPCNT"));

        param.put("XPRTNO2", row2.get("XPRTNO"));
        param.put("TOTDIVSENDYN2", row2.get("TOTDIVSENDYN"));
        param.put("WRAPCNT2", row2.get("WRAPCNT"));

        param.put("XPRTNO3", row3.get("XPRTNO"));
        param.put("TOTDIVSENDYN3", row3.get("TOTDIVSENDYN"));
        param.put("WRAPCNT3", row3.get("WRAPCNT"));

        param.put("XPRTNO4", row4.get("XPRTNO"));
        param.put("TOTDIVSENDYN4", row4.get("TOTDIVSENDYN"));
        param.put("WRAPCNT4", row4.get("WRAPCNT"));

        int updateCnt = commonDAO.update("ems.updateEmsRegExcelDetail", param);
        if (updateCnt > 0) {
            if ("I".equals(MapUtils.getString(param, "CRUD"))) {
                model.setCode("I00000011"); //추가되었습니다.
            } else if ("D".equals(MapUtils.getString(param, "CRUD"))) {
                model.setCode("I00000004"); //삭제 되었습니다.
            } else {
                model.setCode("I00000003"); //저장 되었습니다.
            }

        }
        return model;
    }

    // ========================================================================================================= //
    // ==================================================기표지================================================== //
    // ========================================================================================================= //

    /**
     * EMS 기표지 출력대상 리스트
     */
    @Override
    public AjaxModel selectCovList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    /**
     * EMS 기표지 출력대상 Data 리스트
     */
    @Override
    public AjaxModel selectCovDataList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);
        
        List<Map<String, Object>> dataList = commonDAO.list("ems.selectCovDataList", param);
        model.setDataList(dataList);
        return model;
    }

    // ========================================================================================================= //
    // =================================================배송현황================================================= //
    // ========================================================================================================= //

    /**
     * EMS 배송현황 리스트
     */
    @Override
    public AjaxModel selectStatList(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        model = commonService.selectGridPagingList(model);
        return model;
    }

    /**
     * EMS 배송현황 상세 정보
     */
    @Override
    public AjaxModel selectStatTraceDetail(AjaxModel model) throws GeneralSecurityException, UnsupportedEncodingException {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);

        // 배송이력
        model = commonService.selectGridPagingList(model);
        return model;
    }
    
    /**
     * EMS 배송현황 실시간 조회
     */
    @SuppressWarnings("unchecked")
    @Override
    public AjaxModel saveRealTimeEmsTraceInfo(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);
        
        String userId = model.getUsrSessionModel().getUserId();
        String paramRegino = MapUtils.getString(param, "REGINO", "");
        if (StringUtils.isEmpty(paramRegino) || paramRegino.length() != 13) {
            model.setCode("00000023"); //처리내역이 없습니다.
            return model;
        }
        
        // 접수 정보 조회
        Map<String, Object> receptInfo = (Map<String, Object>) commonDAO.select("ems.selectReceptInfo", param);
        if (MapUtils.isNotEmpty(receptInfo)) {
            Map<String, String> receptParams = new HashMap<String, String>();
            String custno = MapUtils.getString(receptInfo, "CUSTNO", "");
            String orderno = MapUtils.getString(receptInfo, "ORDERNO", "");
            String statuscd = MapUtils.getString(receptInfo, "STATUSCD", "");
            
            // I:배달완료, 1:취소, 17:오류
            if (statuscd != null && (statuscd.trim().equals("I") || statuscd.trim().equals("1") || statuscd.trim().equals("17"))) {
                model.setCode("I00000025"); //더 이상 수신할 종추적 Data가 없습니다.
                return model;
            }
            
            // EMS 접수 확인
            receptParams.put("custno", custno);
            receptParams.put("orderno", orderno);
            String xml = "";
            try {
                xml = EMSOpenApi.getData("API001", receptParams); // EMS 접수확인 Open API 정보
            }
            catch (ConnectTimeoutException e) {
                model.setCode("E00000004"); // 호스트가 제한 시간 내에 연결을 수락하지 않았습니다.
                throw new BizException(model);
            }
            Document doc = Jsoup.parse(xml, "", Parser.xmlParser());
            Elements eError_code = doc.select("error_code");
            Elements eMessage = doc.select("message");
            if (!eError_code.isEmpty()) { // 오류
                String msg = String.format("[%s] %s", eError_code.text(), eMessage.text());
                model.setMsg(msg);
                return model;
            }
            
            // EMS 종추적정보 확인
            Map<String, String> params = new HashMap<String, String>();
            params.put("query", paramRegino);
            xml = EMSOpenApi.getData("API002", params); // EMS 종추적 Open API 정보
            doc = Jsoup.parse(xml, "", Parser.xmlParser());
            eError_code = doc.select("error_code");
            eMessage = doc.select("message");
            if (!eError_code.isEmpty()) { // 오류
                if ("ERR-001".equals(eError_code.text())) {
                    model.setCode("I00000026"); //수신한 Data가 없습니다.
                    return model;
                }
                else {
                    String msg = String.format("[%s] %s", eError_code.text(), eMessage.text());
                    model.setMsg(msg);
                    return model;
                }
            }
            
            // 종추적 정보 업데이트, 등록
            Map<String, String> apiInfo = new HashMap<String, String>();
            apiInfo.put("REGINO", paramRegino);
            apiInfo.put("SENDERNM", doc.select("sendernm").text());
            apiInfo.put("RECEIVERNM", doc.select("receivename").text());
            apiInfo.put("MAILTYPENM", doc.select("mailtypenm").text());
            apiInfo.put("MAILKINDNM", doc.select("mailkindnm").text());
            apiInfo.put("DELIVERYDATE", doc.select("deliverydate").text());
            apiInfo.put("DELIVERYYN", doc.select("deliveryyn").text());
            apiInfo.put("SIGNERNM", doc.select("signernm").text());
            apiInfo.put("RELATIONNM", doc.select("relationnm").text());
            apiInfo.put("CONNECTEDREGINO", doc.select("connectedregino").text());
            apiInfo.put("POSTMANNM", doc.select("postmannm").text());
            apiInfo.put("INBOUNDOUTBOUNDNM", doc.select("inboundoutboundnm").text());
            apiInfo.put("RECVPOSTZIPCD", doc.select("recvpostzipcd").text());
            apiInfo.put("RECVPOSTTELNO", doc.select("recvposttelno").text());
            apiInfo.put("DESTCOUNTRYCD", doc.select("destcountrycd").text());
            apiInfo.put("DESTCOUNTRYNM", doc.select("destcountrynm").text());
            apiInfo.put("GCDATE", doc.select("gcdate").text());
            apiInfo.put("POSTIMPCCD", doc.select("postimpccd").text());
            apiInfo.put("RECEIVERZIPCD", doc.select("receiverzipcd").text());
            apiInfo.put("CUSTOMSFAILEDNM", doc.select("customsfailednm").text());
            apiInfo.put("SENDCNT", doc.select("sendcnt").text());
            apiInfo.put("SENDFLIGHTNO", doc.select("sendflightno").text());
            apiInfo.put("AIRDATE", doc.select("airdate").text());
            apiInfo.put("DELIPOSTTELNO", doc.select("deliposttelno").text());
            apiInfo.put("USER_ID", userId);
            
            Map<String, Object> traceInfo = (Map<String, Object>) commonDAO.select("ems.selectTraceInfo", param);
            String regino = MapUtils.getString(traceInfo, "REGINO", "");
            if (StringUtils.isNotEmpty(regino)) {
                commonDAO.update("ems.updateTraceInfo", apiInfo);
            } 
            else {
                commonDAO.insert("ems.insertTraceInfo", apiInfo);
            }
            
            // 해당 등기번호의 종추적 History 정보 삭제 후 등록
            Elements itemList = doc.select("itemlist");
            int itemNo = 0;
            String latelyTracedate = "";
            String latelyUpucd = "";
            String latelyEventnm = "";
            
            commonDAO.delete("ems.deleteTraceInfoHistory", param);
            for (Element item : itemList) {
                itemNo++;
                Map<String, Object> itemMap =  new HashMap<String, Object>();
                itemMap.put("REGINO", regino);
                itemMap.put("ITEMNO", itemNo);
                itemMap.put("SORTINGDATE", item.select("sortingdate").text());
                itemMap.put("EVENTHMS", item.select("eventhms").text());
                itemMap.put("EVENTREGIPONM", item.select("eventregiponm").text());
                itemMap.put("DELIVRSLTNM", item.select("delivrsltnm").text());
                itemMap.put("NONDELIVREASNNM", item.select("nondelivreasnnm").text());
                itemMap.put("EVENTNM", item.select("eventnm").text());
                itemMap.put("EVENTYMD", item.select("eventymd").text());
                itemMap.put("UPUCD", item.select("upucd").text());
                itemMap.put("USER_ID", userId);
                commonDAO.insert("ems.insertTraceInfoHistory", itemMap);
                if (itemNo == itemList.size()) {
                    latelyTracedate = doc.select("sortingdate").text();
                    latelyUpucd = doc.select("upucd").text();
                    latelyEventnm = doc.select("eventnm").text();
                }
            }
            
            // 최종상태 업데이트
            Map<String, Object> latelyTraceInfoMap =  new HashMap<String, Object>();
            latelyTraceInfoMap.put("REGINO", regino);
            latelyTraceInfoMap.put("TRACEDATE", latelyTracedate);
            latelyTraceInfoMap.put("UPUCD", latelyUpucd);
            latelyTraceInfoMap.put("EVENTNM", latelyEventnm);
            latelyTraceInfoMap.put("USER_ID", userId);
            commonDAO.update("ems.updateLatelyTraceInfo", latelyTraceInfoMap);
            model.setCode("I00000027"); //종추적 Data를 최신상태로 업데이트 하였습니다.
            return model;
            
        }

        model.setCode("00000023"); //처리내역이 없습니다.
        return model;
    }
}
