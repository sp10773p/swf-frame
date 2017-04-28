package kr.pe.frame.exp.dec.service;

import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DateUtil;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.cmm.util.StringUtil;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.pe.frame.adm.edi.service.EdiService;
import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.CommonZipDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.base.CustomsOpenApi;

/**
 * Created by jjkhj on 2017-01-09.
 */
@Service("decService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class DecServiceImpl implements DecService {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;
    
    @Resource(name = "commonZipDAO")
    private CommonZipDAO commonZipDAO;

    @Resource(name = "commonService")
    private CommonService commonService;
    
    @Resource(name = "ediService")
    private EdiService ediService;

	/**
	 * 수출신고전송
	 */
	@Override
	public AjaxModel saveExpDecSend(AjaxModel model) throws Exception {
		List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }
        
        model = ediService.sendDoc(model);
        
        for(Map<String, Object> param : dataList){
        	param.put("SEND", "02");
            commonDAO.update("dec.updateDecSend", param);
        }

        //model.setCode("I00000014"); //전송되었습니다.

        return model;
	}
	


	/**
	 * 수출신고 요청
	 */
	@Override
	public AjaxModel saveExpDecReq(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		
		param.put("SN"        , (String)param.get("SN"));
		param.put("BIZ_NO"    , model.getUsrSessionModel().getBizNo());
		param.put("SELLER_ID" , model.getUsrSessionModel().getUserId());
		param.put("USER_ID"   , model.getUsrSessionModel().getUserId());
		param.put("STATUS"    , "01");	//신고생성요청 ('AAA1005')
		
		commonDAO.insert("dec.insertExpdecReq", param);
		commonDAO.insert("dec.insertExpdecReqItem", param);
		
		//SN UPDATE
		List<Map<String, Object>> listEx = commonDAO.list("dec.selectExpdecReqNoExcel", param);
		for(Map<String, Object> recordEx  : listEx){
			 param.put("REQ_NO"    , (String) recordEx.get("REQ_NO"));
			 List<Map<String, Object>> list = commonDAO.list("dec.selectExpdecReqNo", param);
				String pReqNo = (String) recordEx.get("REQ_NO");
				int pSn = 1;
				for(Map<String, Object> record  : list){
					 pSn = (pReqNo.equals((String) record.get("REQ_NO"))) ? pSn : 1 ;
					 param.put("REQ_NO" , (String) record.get("REQ_NO"));
					 param.put("SN"     ,  record.get("SN"));
					 param.put("P_SN"   ,  pSn);
					 commonDAO.update("dec.updateExpdecReqItemSeq", param);
					 pSn++;
				}
		}
		model.setCode("I00000003"); //저장되었습니다.
		
		//수출신고서 생성
		saveGenerateExpDoc(model, "");
		
		return model;
	}
	
	/**
	 * 수출신고서 생성
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public void saveGenerateExpDoc(AjaxModel model, String gbn) throws Exception {
		Map<String, Object> param = model.getData();
		
		if("API".equals(gbn)){
			param.put("BIZ_NO"    , param.get("SellerPartyRegistNo"));
		}else{
			param.put("BIZ_NO"    , model.getUsrSessionModel().getBizNo());
		}
		param.put("STATUS"    , "02");	//신고생성준비 ('AAA1005')
		//신고요청인 건들을 신고준비로 업데이트
		commonDAO.update("dec.updateExpdecReqStatus", param);
		
		//신고준비중인 수출신고요청 건들을 조회
		List<Map<String, Object>> list = commonDAO.list("dec.selectExpDecReqList", param);
		for(Map<String, Object> record  : list){
			//수출신고생성요청
            param.put("REQ_NO"    , (String) record.get("REQ_NO"));
            model.setData(param);
            
            generateExpDocRun(param, model);
	    }
				
	}
	
	
	/**
	 * 수출신고 생성처리
	 * @param model
	 * @throws Exception
	 */
	public void generateExpDocRun(Map<String, Object> inVar, AjaxModel model) throws Exception {
		
		Map<String, Object> docExpMain = null;  		//신고서 공통
		List<Map<String, Object>> docExpRans = null;  	//신고서 란
		List<Map<String, Object>> docExpModels = null;  //신고서 모델규격
		JSONObject errJSON = new JSONObject();
		String errMsg = "";
		String status = "";
		
		int ranCnt = 0;
		BaseValueMap baseValMap = null;					  //신고서항목및 기본값
		Map<String, Object> expReqInfo = null;			  //요청 공통
		List<Map<String, Object>> expReqRanList = null;   //요청 란
		List<Map<String, Object>> expReqModelList = null; //요청 모델규격
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> expItemBaseVal = null;
		
		String reqNo = inVar.get("REQ_NO").toString();
		
		try {
			
			//수출신고요청 Main정보 조회
			paramMap = new HashMap<String, Object>();
			paramMap.put("REQ_NO", reqNo);
			expReqInfo = (Map<String, Object>) commonDAO.select("dec.selectExpReqInfo", paramMap);
			if (MapUtils.isEmpty(expReqInfo)) {
				throw new BizException("생성할 수출신고서 요청 정보가 없음");
			}
			
			//수출신고요청 란 정보 조회
			expReqRanList = commonDAO.list("dec.selectExpReqRanList", paramMap);
			if (expReqRanList == null || expReqRanList.size() < 1 ){
				throw new BizException("생성할 수출신고서 요청 란정보가 없음");
			}
			
			
			//수출신고요청 모델규격 정보 조회
			expReqModelList = commonDAO.list("dec.selectExpReqModelList", paramMap);
			if (expReqModelList == null || expReqModelList.size() < 1 ){
				throw new BizException("생성할 수출신고서 요청 모델규격정보가 없음");
			}
			
			//환율. 신고가 원화계산
			String rptDay = DateUtil.getToday();
			String exchangeRateStr = "";
			BigDecimal sumNetWeight = new BigDecimal("0.000");
			BigDecimal totalDecAmt = new BigDecimal("0");
			CalcCheckMap calcCheckMap = new CalcCheckMap(); 
			calcCheckMap = calculateAmt(expReqInfo, ranCnt, rptDay, expReqRanList);
			if (!StringUtil.isEmpty(calcCheckMap.errMsg)){
				throw new Exception(calcCheckMap.errMsg);
			}
			exchangeRateStr = calcCheckMap.exchangeRateStr;
			sumNetWeight = calcCheckMap.sumNetWeight;
			totalDecAmt = calcCheckMap.totalDecAmt;
			
			//baseVal 조회 : 공통
			String registMethod = StringUtil.null2Str((String)expReqInfo.get("REGIST_METHOD"));
			paramMap = new HashMap<String, Object>();
			paramMap.put("DOC_ID"   , "수출신고");
			paramMap.put("BIZ_NO"   , expReqInfo.get("EOCPARTYPARTYIDID1"));
			paramMap.put("TABLE_NM" , "EXP_CUSDEC830");
			expItemBaseVal = commonDAO.list("dec.selectExpDecBaseVal", paramMap);
			baseValMap = new BaseValueMap(expItemBaseVal);
			
			//baseVal + reqMaster =  Main Map 생성
			DocumentCheckMap documentCheckMap = null;
			documentCheckMap = makeMain(expReqInfo, baseValMap, registMethod);
			if (!StringUtil.isEmpty(documentCheckMap.errMsg)){
				errMsg += documentCheckMap.errMsg;
				errJSON = documentCheckMap.jsonOBJ;
			}
			docExpMain = documentCheckMap.map;
					
			//baseVal 조회 : Ran + Model
			paramMap = new HashMap<String, Object>();
			paramMap.put("DOC_ID"   , "수출신고");
			paramMap.put("BIZ_NO"   , expReqInfo.get("EOCPARTYPARTYIDID1"));
			paramMap.put("TABLE_NM" , "EXP_CUSDEC830_RAN");
			expItemBaseVal = commonDAO.list("dec.selectExpDecBaseVal", paramMap);
			baseValMap = new BaseValueMap(expItemBaseVal);
			
			//baseVal + reqRan = Ran Map 생성
			documentCheckMap = null;
			
			String insuKrw = decimalToStr(expReqInfo, "INSU_KRW");
			String freKrw = decimalToStr(expReqInfo, "FRE_KRW");
			
			documentCheckMap = makeRans(expReqRanList, baseValMap, exchangeRateStr, registMethod, errJSON);
			if (!StringUtil.isEmpty(documentCheckMap.errMsg)){
				errMsg += documentCheckMap.errMsg;
				errJSON = documentCheckMap.jsonOBJ;
			}
			docExpRans = documentCheckMap.dataSetMap;
			
			
			//baseVal + reqModel = Model Map 생성
			documentCheckMap = null;
			documentCheckMap = makeModels(expReqModelList, baseValMap, exchangeRateStr, registMethod, errJSON);
			if (!StringUtil.isEmpty(documentCheckMap.errMsg)){
				errMsg += documentCheckMap.errMsg;
				errJSON = documentCheckMap.jsonOBJ;
			}
			docExpModels = documentCheckMap.dataSetMap;
			
			//체크완료한 수출신고서 정보에서 체크한 에러가 있다면 오류처리
			if (!StringUtil.isEmpty(errMsg)){
				throw new BizException("수출신고 생성오류.");
			}
			
			//최종 유효성 검사
			documentCheckMap = null;
			documentCheckMap = validationTotal(docExpMain, sumNetWeight, expReqInfo, errMsg);
			docExpMain.putAll(documentCheckMap.map);
			if (!StringUtil.isEmpty(documentCheckMap.errMsg)){
				throw new Exception(documentCheckMap.errMsg);
			}
			
			//제출번호 생성
			documentCheckMap = null;
			documentCheckMap = getRptNo(expReqInfo, reqNo, errMsg);
			if (!StringUtil.isEmpty(documentCheckMap.errMsg)){
				throw new Exception(documentCheckMap.errMsg);
			}
			
			//작성한값을 셋팅
			docExpMain.put("RPT_NO", documentCheckMap.map.get("RPT_NO"));
			docExpMain.put("RPT_SEQ", "00");
			docExpMain.put("DECLARATIONDATE", rptDay);
			docExpMain.put("EXCHANGERATE", exchangeRateStr);
			docExpMain.put("TOTALDECAMOUNT", totalDecAmt.toString());
			docExpMain.put("SUMMARY_TOTALLINENUMBER", docExpRans.size()+"");	//총란수
			docExpMain.put("REQ_NO", reqNo);
			docExpMain.put("ORDER_ID", expReqInfo.get("ORDER_ID"));
			docExpMain.put("INSU_KRW", insuKrw);
			docExpMain.put("FRE_KRW" , freKrw);
			docExpMain.put("REG_ID"  , expReqInfo.get("REG_ID"));
			docExpMain.put("MALL_ID"  , expReqInfo.get("MALL_ID"));
			docExpMain.put("REGIST_METHOD", expReqInfo.get("REGIST_METHOD"));
			
			//수출신고서 생성
			saveInfo(docExpMain, docExpRans, docExpModels, (Boolean)documentCheckMap.map.get("IS_EXIST"), model);	//수출신고서 테이블에 저장.시스템오류외의 오류처리없음.
			status = "03";	//수출신고생성 ('AAA1005')
			
			//자동전송여부가 'Y' 이면 자동으로 수출신고서를 전송한다.
			if("Y".equals(expReqInfo.get("SEND_CHECK"))){
				Map<String, Object> in = new HashMap<String, Object>();
				List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>(); 
				
				in.put("USER_ID"  , expReqInfo.get("MALL_ID"));
				in.put("TYPE"     , "ECC");
				Map<String, Object> IdenInfo = (Map<String, Object>) commonDAO.select("dec.selectCmmIdentifier", in);
				
				if (MapUtils.isEmpty(IdenInfo)) {
					
					throw new Exception(expReqInfo.get("MALL_ID")+"에 해당하는 식별자 정보가 없습니다.");
				}
				
				in.put("REQ_KEY", documentCheckMap.map.get("RPT_NO"));
				in.put("SNDR_ID", IdenInfo.get("IDENTIFY_ID"));
				in.put("RECP_ID", "KCS4G001");
				in.put("DOC_TYPE", "GOVCBR830");
				in.put("RPT_NO", docExpMain.get("RPT_NO"));
				in.put("RPT_SEQ", docExpMain.get("RPT_SEQ"));
				in.put("USER_ID", docExpMain.get("REG_ID"));
				paramList.add(in);
				model.setDataList(paramList);
				try {
					saveExpDecSend(model);
				} catch (BizException e) {
					in = new HashMap<String, Object>();
					in.put("USER_ID", expReqInfo.get("REG_ID"));
					in.put("SEND", "90");
					commonDAO.update("dec.updateDecSend", in);
					throw new Exception(e);
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
			errMsg += e.getMessage();
			status = "04";	//수출생성오류 ('AAA1005')
		}
		//요청정보에 status 업데이트
		paramMap = new HashMap<String, Object>();
		paramMap.put("REQ_NO", reqNo);
		paramMap.put("STATUS", status);
		paramMap.put("ERROR_DESC", errMsg);
		paramMap.put("ERROR_JSON", errJSON.toJSONString());
		commonDAO.update("dec.updateExpReqStatus", paramMap);
		
	}

	//환율. 신고가 원화계산
	public CalcCheckMap calculateAmt(Map<String, Object> expReqInfo, int ranCnt, String rptDay, List<Map<String, Object>> expReqRanList) {
		
		String exchangeRateStr = "";
		BigDecimal sumNetWeight = new BigDecimal("0.000");	//항목별 중량 합계
		BigDecimal totalDecAmt = new BigDecimal("0");
		String errMsg = "";
		try{
			String exchangeBaseDate = DateUtil.firstDate(rptDay);
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("APPLY_DATE", exchangeBaseDate);
			paramMap.put("NATION", expReqInfo.get("PAYMENTAMOUNT_CUR"));
			paramMap.put("IMPORT_EXPORT", "E");
			if ("KRW".equals(expReqInfo.get("PAYMENTAMOUNT_CUR"))){
				exchangeRateStr = "1.00";
			}else{
				exchangeRateStr = (String)commonDAO.select("dec.selectExchangeRate", paramMap);
				if (StringUtils.isEmpty(exchangeRateStr)){
					throw new BizException("환율정보가 없음");
				}
				exchangeRateStr =  exchangeRateStr.replaceAll(",", "");
			}
	
			/*
			 * 숫자를 체크해야할 사항. 항목설정
			 * 1. 포장수량 0이면 기본값을 셋팅해주어야함. 총포장수량이 개별 포장수량의 최대값보다 작다면 개별최대포장수량을 사용.
			 * 	  -.개별수량이 없는 경우 (0포함) : 1로 설정
			 * 2. 중량. 중량이 0이면 기본값 1을 사용.
			 * 	  -.개별건의 중량은 중량이 없는 경우(0 포함) : 중량 = 1/물품수  
			 * 3. 란별 신고금액을 합하여 총 신고금액으로 사용하고, 결제금액은 입력받은 그대로 사용, 따라서 2개의 값이 서로 상이할 수 있음
			 */
			ranCnt = expReqRanList.size();
			int checkTotPackCnt = 1;
			BigDecimal itemAmt = null;
			String decItemAmt = null;
			int checkPackCnt = 1;
			Map<String, Object> itemMap = new HashMap<String, Object>();
			for (int i=0; i<ranCnt; i++){
				itemMap = expReqRanList.get(i);
	
				try {
					checkPackCnt = ((BigDecimal) itemMap.get("PACKAGINGQUANTITY")).intValue();
					//checkPackCnt = (int) itemMap.get("PACKAGINGQUANTITY");
				} catch (NumberFormatException nfe){
					checkPackCnt = 1;
				}
				if (checkPackCnt > checkTotPackCnt) checkTotPackCnt = checkPackCnt;
				
				sumNetWeight = sumNetWeight.add(new BigDecimal( String.valueOf(((BigDecimal)itemMap.get("NETWEIGHTMEASURE")).doubleValue())) );
	
				try {
					decItemAmt = DocUtil.calcExchWonFloor(exchangeRateStr, String.valueOf(((BigDecimal) itemMap.get("DECLARATIONAMOUNT")).doubleValue())); //신고가 계산
					itemAmt = new BigDecimal(decItemAmt);
					totalDecAmt = totalDecAmt.add(itemAmt);
				} catch (NumberFormatException e){
					e.printStackTrace();
				}
			}
			//신고가격은 200만원을 넘길수 없음
			if(totalDecAmt.intValue() > 2000000){
				throw new BizException("신고금액(원화)은 200만원을 초과할 수 없습니다. [예상신고 원화금액: "+totalDecAmt);
			}
		}catch (Exception e){
			e.printStackTrace();
			errMsg = e.getMessage();
		}
		
		return new CalcCheckMap(exchangeRateStr, sumNetWeight, totalDecAmt, errMsg);
	}



	/**
	 *  요청값과 기본값을 합하여 수출신고서 항목을 만듬
	 *  inputType은 API로 받은것과 엑셀(해외몰 API) 건인 경우로 나누어서 기본값적용을 나눔.
	 *  몰API로 수신받은 경우에 몰기본값을 적용, 그외에는 신고인 기본값설정을 적용
	 */
	public DocumentCheckMap makeMain(Map<String, Object> orgReq, BaseValueMap baseValueMap, String inputType){
		
		String[] itemNmArr = baseValueMap.getItemNmArr();
		Map<String, Object> mainMap = new HashMap<String, Object>();
		JSONObject jsonOBJ = new JSONObject();
		String errMsg = "";
		String orgValue = "";
		String itemValue = "";
		DocumentCheckMap checkMap = null;
		
		if (itemNmArr.length > 0){
			Map<String, Object> baseValConf = null;
			for ( int i=0;i<itemNmArr.length;i++){
				if("API".equals(inputType)){
					try{
						orgValue = (orgReq.get(itemNmArr[i])).toString();
					}catch(NullPointerException e){
						orgValue = "";
					}
				}else{
//					orgValue = isBigDecimal(itemNmArr[i], "A") ? decimalToStr(orgReq, itemNmArr[i]) : (String) orgReq.get(itemNmArr[i]);
					orgValue = (orgReq.get(itemNmArr[i]) instanceof String) ? (String) orgReq.get(itemNmArr[i]) : decimalToStr(orgReq, itemNmArr[i]);
				}
				baseValConf = baseValueMap.getBaseValMap(itemNmArr[i]);
				
				if ("F".equals(baseValConf.get("BASE_VAL_DIV"))){
					itemValue = (String) baseValConf.get("BASE_VAL");
				}else{
					itemValue = DocUtil.chooseItemValue(orgValue, (String) baseValConf.get("BASE_VAL_SELLER"));
				}
				
				// Validation 체크
				checkMap = checkValidationMain(itemNmArr[i], mainMap, orgValue, itemValue, baseValConf, errMsg, jsonOBJ);
				mainMap.putAll(checkMap.map);
				if (!StringUtil.isEmpty(checkMap.errMsg)){
					errMsg = checkMap.errMsg;
					jsonOBJ.putAll(checkMap.jsonOBJ);;
				}
			}
		}
		return new DocumentCheckMap(null, mainMap, errMsg, jsonOBJ);
	}

	public DocumentCheckMap makeRans(List orgReqList, BaseValueMap baseValueMap, String exchangeRateStr, String inputType, JSONObject jsonOBJ){
		List<Map<String, Object>> rans = new ArrayList<Map<String, Object>>();
		Map<String, Object> ranMap = new HashMap<String, Object>();
		int itemsCnt = orgReqList.size();
		
		String errMsg = "";
		
		String[] itemNmArr = baseValueMap.getItemNmArr();
		
		String ranNo = "";
		String orgValue = "";
		String itemValue = "";
		String hsWtUnit = "";
		String hsPkgUnit = "";
		Map<String, Object> orgMap = null;
		
		@SuppressWarnings("unused")
		int checkSize = 0;
		@SuppressWarnings("unused")
		String checkCode = "";
		
		DocumentCheckMap checkMap = null;
		
		for (int ran=0;ran<orgReqList.size();ran++){
			ranMap = new HashMap<String, Object>(); 
			orgMap = (Map<String, Object>) orgReqList.get(ran);
			ranMap.putAll(orgMap);
			ranNo = DocUtil.lpadbyte(""+(ran+1), 3, "0");
			ranMap.put("RAN_NO", ranNo);
			
			hsWtUnit  = (String) orgMap.get("HS_WT_UNIT");	 //HS코드에 등록된 중량단위
			hsPkgUnit = (String) orgMap.get("HS_PKG_UNIT"); //HS코드에 등록된 수량단위
			ranMap.put("HS_WT_UNIT", hsWtUnit);
			ranMap.put("HS_PKG_UNIT", hsPkgUnit);
			
			if (itemNmArr.length > 0){

				Map<String, Object> baseValConf = null;
				for ( int i=0;i<itemNmArr.length;i++){
//					orgValue = isBigDecimal(itemNmArr[i], "B") ? decimalToStr(orgMap, itemNmArr[i]) : (String) orgMap.get(itemNmArr[i]);
					orgValue = (orgMap.get(itemNmArr[i]) instanceof String) ? (String) orgMap.get(itemNmArr[i]) : decimalToStr(orgMap, itemNmArr[i]);
					
					baseValConf = baseValueMap.getBaseValMap(itemNmArr[i]);
					try { checkSize = (int) baseValConf.get("CHECK_SIZE");	} catch (Exception e){	checkSize = 0;	}
					checkCode = (String) baseValConf.get("CHECK_CODE");
					if ("I".equals(baseValConf.get("BASE_VAL_DIV"))){
						continue;
					} else if ("F".equals(baseValConf.get("BASE_VAL_DIV"))){
						itemValue = (String) baseValConf.get("BASE_VAL");
						ranMap.put(itemNmArr[i], DocUtil.checkItemValue(itemNmArr[i], itemValue));
					} else {
						
						itemValue = orgValue;
						
						// Validation 체크
						checkMap = checkValidationRan(itemNmArr[i], ranMap, ran, orgValue, itemValue, hsPkgUnit, hsWtUnit, itemsCnt, baseValConf, errMsg, jsonOBJ);
						if (MapUtils.isNotEmpty(checkMap.map)) {
							ranMap.putAll(checkMap.map);
						}
						if (!StringUtil.isEmpty(checkMap.errMsg)){
							errMsg = checkMap.errMsg;
							jsonOBJ.putAll(checkMap.jsonOBJ);;
						}
					}
					//ranMap.put(itemNmArr[i], DocUtil.checkItemValue(itemNmArr[i], itemValue));
				}  //end for 항목설정맵 itemNmArr
				
				//신고가 계산
				String decAmtWONStr = "";
				String declarationAmount = decimalToStr(orgMap, "DECLARATIONAMOUNT");
				
				decAmtWONStr = DocUtil.calcExchWonFloor(exchangeRateStr, declarationAmount);
				ranMap.put("DECLARATIONAMOUNT", decAmtWONStr);
				
				rans.add(ranMap);
			} // end if itemNmArr.length>0
			
		}  // end for 
		
		return new DocumentCheckMap(rans, null, errMsg, jsonOBJ);
	}
	
	public DocumentCheckMap makeModels(List orgReqList, BaseValueMap baseValueMap, String exchangeRateStr, String inputType, JSONObject jsonOBJ){
		List<Map<String, Object>> models = new ArrayList<Map<String, Object>>();
		Map<String, Object> modelMap = new HashMap<String, Object>();
		int itemsCnt = orgReqList.size();
		
		String errMsg = "";
		
		String[] itemNmArr = baseValueMap.getItemNmArr();
		
		String orgValue = "";
		String itemValue = "";
		String hsWtUnit = "";
		String hsPkgUnit = "";
		Map<String, Object> orgMap = null;
		
		@SuppressWarnings("unused")
		int checkSize = 0;
		@SuppressWarnings("unused")
		String checkCode = "";
		
		DocumentCheckMap checkMap = null;
		
		for (int iModel=0;iModel<orgReqList.size();iModel++){
			modelMap = new HashMap<String, Object>(); 
			orgMap = (Map<String, Object>) orgReqList.get(iModel);
			modelMap.putAll(orgMap);
			
			hsWtUnit  = (String) orgMap.get("HS_WT_UNIT");	 //HS코드에 등록된 중량단위
			hsPkgUnit = (String) orgMap.get("HS_PKG_UNIT"); //HS코드에 등록된 수량단위
			modelMap.put("HS_WT_UNIT", hsWtUnit);
			modelMap.put("HS_PKG_UNIT", hsPkgUnit);
			
			if (itemNmArr.length > 0){

				Map<String, Object> baseValConf = null;
				for ( int i=0;i<itemNmArr.length;i++){
					orgValue = (orgMap.get(itemNmArr[i]) instanceof String) ? (String) orgMap.get(itemNmArr[i]) : decimalToStr(orgMap, itemNmArr[i]);
					
					baseValConf = baseValueMap.getBaseValMap(itemNmArr[i]);
					try { checkSize = (int) baseValConf.get("CHECK_SIZE");	} catch (Exception e){	checkSize = 0;	}
					checkCode = (String) baseValConf.get("CHECK_CODE");
					if ("I".equals(baseValConf.get("BASE_VAL_DIV"))){
						continue;
					} else if ("F".equals(baseValConf.get("BASE_VAL_DIV"))){
						itemValue = (String) baseValConf.get("BASE_VAL");
						modelMap.put(itemNmArr[i], DocUtil.checkItemValue(itemNmArr[i], itemValue));
					} else {
						
						itemValue = orgValue;
						
						// Validation 체크
						checkMap = checkValidationModel(itemNmArr[i], modelMap, iModel, orgValue, itemValue, hsPkgUnit, hsWtUnit, itemsCnt, baseValConf, errMsg, jsonOBJ);
						if (MapUtils.isNotEmpty(checkMap.map)) {
							modelMap.putAll(checkMap.map);
						}
						modelMap.putAll(checkMap.map);
						if (!StringUtil.isEmpty(checkMap.errMsg)){
							errMsg = checkMap.errMsg;
							jsonOBJ.putAll(checkMap.jsonOBJ);;
						}
						
					}
					//modelMap.put(itemNmArr[i], DocUtil.checkItemValue(itemNmArr[i], itemValue));
				}  //end for 항목설정맵 itemNmArr
				
				models.add(modelMap);
			} 
			
		}  // end for 
		
		return new DocumentCheckMap(models, null, errMsg, jsonOBJ);
	}
	
	/**
	 * 영문확인
	 * @param itemNm
	 * @return
	 */
	private boolean isEngItem(String itemNm){
		String[] acceptedItemArr = {"BuyerPartyOrgName", "ItemName_HS", "BrandName_EN"};
		for ( String acceptedItem:acceptedItemArr ){
			if (itemNm.toUpperCase().equals(acceptedItem.toUpperCase())){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 제출번호 생성
	 * @param expReqInfo
	 * @param doc_id
	 * @return
	 */
	public String makeRptNo(Map<String, Object> expReqInfo , String docId){
		String rptNo = "";
		String appId = (String) expReqInfo.get("APPLICANTPARTYORGID");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("APPLICANT_ID" , appId);	//신고인부호
		param.put("DOC_ID"       , docId);
		
		rptNo = newRptNo(param);
		
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String rptYear =  (formatter.format(new Date())).substring(2, 4);
		if("830".equals(docId)){
			/**
			 * 제출번호 체크섬을 계산하여 수출신고번호 제출번호에 붙임.
			 * 1.생성한 제출번호13를 각자리별로 checkDigit[자기순서]를 곱하여 10으로 나눈 나머지를 계산함. 
			 * 2.계산된 13개의 숫자를 더하여 10으로 나눈나머지를 구함. 
			 * 3.나머지가 0이면 '0' 아니면 10-(나머지) 하여 계산된 값을 체크디지트로 사용
			 */
			rptNo = appId + rptYear + DocUtil.lpadbyte(rptNo, 6, "0");
			
			int checkDigits[] = {7,3,1,7,3,1,7,3,1,7,3,1,7};
			int v_chk = 0;
			int v_sum = 0;
			for(int i=0; i<checkDigits.length; i++){
				v_chk = (Integer.parseInt(rptNo.substring(i, i+1)) * checkDigits[i]) % 10;
				v_sum = v_sum + v_chk;
			}
			v_chk = v_sum % 10;
			if(v_chk > 0){
				v_chk = 10 - v_chk;
			}
			
			rptNo = rptNo + v_chk;
			
		}else{
			rptNo = appId + rptYear + DocUtil.lpadbyte(rptNo, 5, "0") + "U";
		}
		
		//if ( "X".equals(this.DOC_SEND_TYPE) ) {
			//EDI일때는 마지막 자리는 체크디지트, XML일때는 끝자리에 X를 처리
			if (rptNo !=null && rptNo.length()>=14){
				rptNo = rptNo.substring(0, 13)+"X";
			}
		//}
		
		return rptNo;
	}



	private synchronized String newRptNo(Map<String, Object> param) {
		String rptNo;
		int docCnt = Integer.parseInt(String.valueOf(commonDAO.select("dec.selectDocIdCount", param)));
		
		if(docCnt <= 0){
			rptNo = "1";
			param.put("RPT_NO"      , rptNo);
			param.put("REG_ID"      , "AUTOREG");
			param.put("MOD_ID"      , "AUTOREG");
			commonDAO.insert("dec.insertSubmitNoMng", param);
		}else{
			rptNo = (String) commonDAO.select("dec.selectRptNoNew", param);
			param.put("RPT_NO"      , rptNo);
			commonDAO.update("dec.updateSubmitNoMng", param);
		}
		return rptNo;
	}
	
	private void saveInfo(Map<String, Object> expMain, List<Map<String, Object>> expRans, List<Map<String, Object>> expModels, boolean isExists, AjaxModel model) throws Exception
	{
		String rptNo = (String) expMain.get("RPT_NO");
		String rptSeq = (String) expMain.get("RPT_SEQ");
		String regGbn = StringUtil.null2Str((String) expMain.get("REGIST_METHOD"));
		String reqNo = (String) expMain.get("REQ_NO");
		String userId = "EXCEL".equals(regGbn) ? (String) expMain.get("REG_ID") : (String) expMain.get("MALL_ID");

		Map<String, Object> mainMap = makeCUSDEC830(expMain);
		mainMap.put("USER_ID"		, userId);
		if (isExists){
			commonDAO.update("dec.updateCUSDEC830", mainMap);
			
			//폼목정보삭제
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RPT_NO", rptNo);
			commonDAO.delete("dec.deleteExpDecOldRanInfo", param);
			commonDAO.delete("dec.deleteExpDecOldModelInfo", param);
		}else{
			commonDAO.insert("dec.insertCUSDEC830", mainMap);
		}
		
		Map<String, Object> ranMap = null;
		// 란정보저장
		for (int i=0; i<expRans.size();i++){
			ranMap = (Map<String, Object>)expRans.get(i);

			Map<String, Object> ranParam = makeCUSDEC830_RAN(ranMap);
			String orderId = (String) (i==0 ? mainMap.get("ORDER_ID") : "");
			ranParam.put("RPT_NO"  ,  rptNo);            //	제출번호
			ranParam.put("RPT_SEQ" ,  rptSeq );			 // 제출차수
			ranParam.put("MG_CODE" ,  orderId);			 // 송품장부호
			ranParam.put("USER_ID" ,  userId);
			commonDAO.insert("dec.insertCUSDEC830_RAN", ranParam);
			
			// 모델 정보저장
			Map<String, Object> modelMap = null;
			int idx = 1;
			for (int j=0; j<expModels.size();j++){
				modelMap = (Map<String, Object>)expModels.get(j);
				Map<String, Object> modelParam = makeCUSDEC830_MODEL(modelMap);
				if(ranParam.get("HS").equals(modelParam.get("HS"))){
					modelParam.put("RPT_NO"  ,	rptNo);              		 //	제출번호
					modelParam.put("RPT_SEQ" ,  rptSeq );					 // 제출차수
					modelParam.put("RAN_NO"  ,  ranParam.get("RAN_NO") );	 // 란번호
					String silNo = DocUtil.lpadbyte(""+(idx), 2, "0");
					modelParam.put("SIL", silNo);
					modelParam.put("USER_ID" ,  userId);
					
					commonDAO.insert("dec.insertCUSDEC830_MODEL", modelParam);
					
					idx++;
				}
			}
			//결제금액 :CON_AMT UPDATE
			commonDAO.update("dec.upateCUSDEC830_RAN_AMT", ranParam);
		}
		
		//신고가 UPDATE
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("NATION", (String) expMain.get("PAYMENTAMOUNT_CUR"));
		param.put("RPT_NO", rptNo);
		param.put("RPT_SEQ", rptSeq);
		param.put("REQ_NO", reqNo);
		updateExpDecAmt(param);
	}
	
	private void updateExpDecAmt(Map<String, Object> param) {
		
		Map<String, Object> newParam = new HashMap<String, Object>();
		newParam.putAll(param);
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		newParam.put("APPLY_DATE"    , exchangeBaseDate);
		newParam.put("NATION"        ,  newParam.get("NATION"));
		newParam.put("IMPORT_EXPORT" , "E");
		newParam.put("RPT_NO"        , newParam.get("RPT_NO"));
		newParam.put("REQ_NO"        , newParam.get("REQ_NO"));
		
		Map<String, Object> diffInfo = (Map<String, Object>) commonDAO.select("dec.selectDiffInfo", newParam);
		newParam.put("FRE_DIFF", diffInfo.get("FRE_DIFF"));
		newParam.put("INSU_DIFF", diffInfo.get("INSU_DIFF"));
		List<Map<String, Object>> ranAmtList = commonDAO.list("dec.selectCUSDEC830_RAN_AMT", newParam);
		int totAmt = 0;
		for(Map map : ranAmtList){
			double rptKrw = 0;
			double firAmt = getDoubleValue(map, "FIR_AMT");	//((BigDecimal) map.get("FIR_AMT")).doubleValue();
			double freCalc = getDoubleValue(map, "FRE_CALC");	//((BigDecimal) map.get("FRE_CALC")).doubleValue();
			double insuCalc = getDoubleValue(map, "INSU_CALC");	//((BigDecimal) map.get("INSU_CALC")).doubleValue();
			String currValUsd = (String) map.get("CURR_VAL_USD");
			
			rptKrw = firAmt - freCalc - insuCalc;
			totAmt += rptKrw;
			newParam.put("RAN_NO", map.get("RAN_NO"));
			newParam.put("RPT_KRW", rptKrw);
			newParam.put("CURR_VAL_USD", currValUsd);
			commonDAO.update("dec.updateExpDecAmtItem", newParam);
		}
		newParam.put("TOT_AMT", totAmt);
		commonDAO.update("dec.updateExpDecAmt", newParam);
		
	}



	private Map<String, Object> makeCUSDEC830(Map<String, Object> outMap) throws Exception {

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();

		mainMap.put("RPT_NO",               (String) outMap.get("RPT_NO"));     				//제출번호
		mainMap.put("RPT_SEQ",              (String) outMap.get("RPT_SEQ"));     				//제출차수
		mainMap.put("SEND",                 "01");     											//전송 (01:등록, 02:전송중, 03: 전송완료 [AAA1001] )
		mainMap.put("RECE",                 "");     											//수신
		mainMap.put("ORDER_ID",             (String) outMap.get("ORDER_ID"));     				//주문번호
		mainMap.put("RPT_FIRM",             (String) outMap.get("EOCPARTYORGNAME2"));     		//신고자상호
		mainMap.put("RPT_MARK",             (String) outMap.get("APPLICANTPARTYORGID"));     	//신고자부호		
		mainMap.put("RPT_BOSS_NM",          (String) outMap.get("EOCPARTYORGCEONAME"));     	//신고자대표자
		//수출대행자 정보가 있으면, 대행자 정보입력하고, 없으면 기존대로 수출화주 정보를 대행자 정보에 입력함
		if(!"".equals((String) outMap.get("EXPORTAGENTORGID")) && (String) outMap.get("EXPORTAGENTORGID") != null ){
			mainMap.put("COMM_FIRM",            (String) outMap.get("EXPORTAGENTORGNAME"));    	//수출대행자상호
			mainMap.put("COMM_TGNO",            (String) outMap.get("EXPORTAGENTORGID"));     	//수출대행자통관부호
		}else{
			mainMap.put("COMM_FIRM",            (String) outMap.get("EOCPARTYORGNAME2"));     	//수출대행자상호
			mainMap.put("COMM_TGNO",            (String) outMap.get("EOCPARTYPARTYIDID2"));     //수출대행자통관부호
		}
		mainMap.put("EXP_DIVI",             (String) outMap.get("EXPORTERCLASSCODE"));     		//수출자구분
		mainMap.put("EXP_FIRM",             (String) outMap.get("EOCPARTYORGNAME2"));     		//수출화주상호
		mainMap.put("EXP_BOSS_NAME",        (String) outMap.get("EOCPARTYORGCEONAME"));     	//수출화주대표자성명
		mainMap.put("EXP_ADDR1",            DocUtil.strCutArray((String) outMap.get("EOCPARTYADDRLINE"), 35, 2,1));     //수출화주주소1
		mainMap.put("EXP_ADDR2",            DocUtil.strCutArray((String) outMap.get("EOCPARTYADDRLINE"), 35, 2,2));     //수출화주주소2
		mainMap.put("EXP_SDNO",             (String) outMap.get("EOCPARTYPARTYIDID1"));     	//수출화주사업자번호
		mainMap.put("EXP_SDNO_DIVI",        (String) outMap.get("EOCPARTYPARTYIDTYPECODE1"));   //수출화주사업자번호구분
		mainMap.put("EXP_TGNO",             (String) outMap.get("EOCPARTYPARTYIDID2"));     	//수출화주통관부호
		mainMap.put("EXP_POST",             (String) outMap.get("EOCPARTYLOCID"));     			//수출화주소재지우편번호
		mainMap.put("MAK_FIRM",             (String) outMap.get("MANUPARTYORGNAME"));     		//제조자상호
		mainMap.put("MAK_TGNO",             (String) outMap.get("MANUPARTYORGID"));     		//제조자통관부호
		mainMap.put("MAK_POST",             (String) outMap.get("MANUPARTYLOCID"));     		//제조자지역코드
		mainMap.put("INLOCALCD",            (String) outMap.get("GOODSLOCATIONID2"));     		//제조장소산업단지부호
		mainMap.put("BUY_FIRM",             (String) outMap.get("BUYERPARTYORGNAME"));     		//해외거래처구매자상호
		mainMap.put("RPT_CUS",              (String) outMap.get("CUSTOMORGANIZATIONID"));     	//신고세관
		mainMap.put("RPT_SEC",              (String) outMap.get("CUSTOMDEPARTMENTID"));     	//신고세관과부호
		mainMap.put("RPT_DAY",              (String) outMap.get("DECLARATIONDATE"));     		//신고일자
		mainMap.put("RPT_DIVI",             (String) outMap.get("DECLARATIONCLASSCODE"));     	//수출신고구분
		mainMap.put("RPT_DIVINM",           (String) outMap.get("DECLARATIONCLASSCODE_CDNM"));  //수출신고구분명
		mainMap.put("EXC_DIVI",             (String) outMap.get("TRANSACTIONTYPECODE"));     	//수출거래구분
		mainMap.put("EXC_DIVINM",           (String) outMap.get("TRANSACTIONTYPECODE_CDNM"));   //수출거래구분명
		mainMap.put("EXP_KI",               (String) outMap.get("EXPORTTYPECODE"));     		//수출종류
		mainMap.put("EXP_KINM",             (String) outMap.get("EXPORTTYPECODE_CDNM"));     	//수출종류명
		mainMap.put("CON_MET",              (String) outMap.get("PAYMENTTERMSTYPECODE"));     	//결제방법
		mainMap.put("CON_METNM",            (String) outMap.get("PAYMENTTERMSTYPECODE_CDNM"));  //결제방법명
		mainMap.put("TA_ST_ISO",            (String) outMap.get("DESTINATIONCOUNTRYCODE"));     //목적국국가코드
		mainMap.put("TA_ST_ISONM",          (String) outMap.get("DESTINATIONCOUNTRYCODE_CDNM"));//목적국명
		mainMap.put("FOD_CODE",             (String) outMap.get("LODINGLOCATIONID"));     		//적재항코드
		mainMap.put("FOD_CODENM",           (String) outMap.get("LODINGLOCATIONID_CDNM"));     	//적재항명
		mainMap.put("ARR_MARK",             (String) outMap.get("LODINGLOCATIONTYPECODE4G"));   //적재항구분코드
		mainMap.put("TRA_MET",              (String) outMap.get("TRANSPORTMEANSCODE"));     	//운송형태
		mainMap.put("TRA_METNM",            (String) outMap.get("TRANSPORTMEANSCODE_CDNM"));    //운송형태명
		mainMap.put("CHK_MET_GBN",          (String) outMap.get("INSPECTIONCODE"));     		//검사방법코드
		mainMap.put("GDS_POST",             (String) outMap.get("GOODSLOCATIONID1"));     		//물품소재지우편번호
		mainMap.put("GDS_ADDR1",            (String) outMap.get("GOODSLOCATIONNAME"));     		//물품소재지주소1
		mainMap.put("RET_DIVI",             (String) outMap.get("SIMPLEDRAWAPPINDICATOR"));     //간이환급신청구분
		mainMap.put("TOT_WT",               (String) outMap.get("SUMMARY_TOTALWEIGHT"));     	//총중량
		mainMap.put("UT",                   (String) outMap.get("SUMMARY_TOTALWEIGHT_UC"));     //총중량단위
		mainMap.put("TOT_PACK_CNT",         (String) outMap.get("SUMMARY_TOTALQUANTITY"));     	//총포장수
		mainMap.put("TOT_PACK_UT",          (String) outMap.get("SUMMARY_TOTALQUANTITY_UC"));   //총포장수단위
		mainMap.put("TOT_RPT_KRW",          (String) outMap.get("TOTALDECAMOUNT"));     		//총신고금액원화
		mainMap.put("CUR",                  (String) outMap.get("PAYMENTAMOUNT_CUR"));     		//결제통화
		mainMap.put("AMT",                  (String) outMap.get("PAYMENTAMOUNT"));     			//결제금액
		mainMap.put("EXC_RATE_CUR",         (String) outMap.get("EXCHANGERATE"));     			//결제환율
		mainMap.put("RES_YN",               (String) outMap.get("DOCRESTYPECODE"));     		//응답형태
		mainMap.put("TOT_RAN",              (String) outMap.get("SUMMARY_TOTALLINENUMBER"));    //총란수
		mainMap.put("REQ_NO",               (String) outMap.get("REQ_NO"));     				//요청관리번호
		mainMap.put("MAK_LOC_SEQ",          (String) outMap.get("MANUPARTYLOCSEQ"));     		//제조자사업장일련번호
		mainMap.put("AMT_COD",              (String) outMap.get("DELIVERYTERMSCODE"));     		//인도조건
		mainMap.put("FRE_KRW",              (String) outMap.get("FRE_KRW"));     				//운임금액원화
		mainMap.put("FRE_UT",                "KRW");     										//운임금액통화
		mainMap.put("FRE_AMT",          	(String) outMap.get("FRE_KRW"));     				//운임금액
		mainMap.put("INSU_KRW",             (String) outMap.get("INSU_KRW"));     				//보험금액원화
		mainMap.put("INSU_UT",               "KRW");     										//보험금액통화
		mainMap.put("INSU_AMT",          	(String) outMap.get("INSU_KRW"));     				//보험금액
		
		
		//mainMap.put("RPT_YEAR",             ((String) outMap.get("DECLARATIONDATE")).substring(2,4));     //신고년도
		
		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}
	
	private Map<String, Object> makeCUSDEC830_RAN(Map<String, Object> outMap) throws Exception {

		// 입력필드 확인설정 MAP
		Map<String, Object> ranMap = new HashMap<String, Object>();
				
		ranMap.put("RAN_NO",                (String) outMap.get("RAN_NO"));     			//란번호
		ranMap.put("HS",                    (String) outMap.get("CLASSIDHSID"));     		//세번부호
		ranMap.put("STD_GNM",               (String) outMap.get("ITEMNAME_HS"));     		//표준품명
		ranMap.put("EXC_GNM",               (String) outMap.get("ITEMNAME_EN"));     		//거래품명
		ranMap.put("MODEL_GNM",             (String) outMap.get("BRANDNAME_EN"));     		//상표명
		ranMap.put("RPT_KRW",               (String) outMap.get("DECLARATIONAMOUNT"));    	//신고가격원화
		ranMap.put("RPT_USD",                "");
		ranMap.put("CUR_UT",                (String) outMap.get("DECLARATIONAMOUNT_CUR"));
		ranMap.put("AMT_COD",               (String) outMap.get("DELIVERYTERMSCODE"));    	//인도조건
		ranMap.put("CON_AMT",               "");		//결제금액   
		ranMap.put("SUN_WT",                (String) outMap.get("NETWEIGHTMEASURE")); 		//순중량
		ranMap.put("SUN_UT",                (String) outMap.get("NETWEIGHTMEASURE_UC"));  	//순중량단위
		ranMap.put("WT",                    (String) outMap.get("LINEITEMQUANTITY"));     	//수량(SUM)
		ranMap.put("UT",                    (String) outMap.get("LINEITEMQUANTITY_UC"));  	//수량단위
		ranMap.put("IMP_RPT_SEND",           ""); 
		ranMap.put("IMP_RAN_NO",             "");
		ranMap.put("PACK_CNT",              (String) outMap.get("PACKAGINGQUANTITY"));    	//포장갯수(SUM)
		ranMap.put("PACK_UT",               (String) outMap.get("PACKAGINGQUANTITY_UC")); 	//포장단위
		ranMap.put("ORI_ST_MARK1",          (String) outMap.get("ORIGINLOCID"));     		//원산지국가부호
		ranMap.put("ORI_ST_NM",              ""); 
		ranMap.put("ORI_ST_MARK2",           ""); 
		ranMap.put("ORI_ST_MARK3",           ""); 
		ranMap.put("ORI_FTA_YN",             ""); 
		ranMap.put("ATT_YN",                (String) outMap.get("DOCREFUSAGETEXT"));      	//첨부서류여부
		ranMap.put("MODIRAN",                "");

		// 입력필드 확인설정 MAP 반환
		return ranMap;
	}
	
	private Map<String, Object> makeCUSDEC830_MODEL(Map<String, Object> outMap) throws Exception {
		String sQty = (String)outMap.get("LINEITEMQUANTITY");
		int iQty  = (sQty.indexOf(".") > -1) ? Integer.parseInt(sQty.substring(0, sQty.indexOf("."))) : Integer.parseInt(sQty);
		double sBaseAmt = ((BigDecimal) outMap.get("BASEPRICEAMT")).doubleValue();
		
		// 입력필드 확인설정 MAP
		Map<String, Object> modelMap = new HashMap<String, Object>();
		modelMap.put("HS",                  (String) outMap.get("CLASSIDHSID"));     		//세번부호
		modelMap.put("SIL",                 "");     										//규격일련번호
		modelMap.put("MG_CD",                "");     										//제품코드
		modelMap.put("GNM",                 (String) outMap.get("ITEMNAME_EN"));     		//모델규격 
		modelMap.put("COMP",                (String) outMap.get("INGREDIENTS"));     		//성분 
		modelMap.put("QTY",                  iQty);   										//수량 
		modelMap.put("QTY_UT",              (String) outMap.get("LINEITEMQUANTITY_UC"));	//수량단위
		modelMap.put("PRICE",                sBaseAmt);     								//단가 
		modelMap.put("AMT",                  iQty * sBaseAmt);     							//금액(수량*단가)
		modelMap.put("SUN_WT",              (String) outMap.get("NETWEIGHTMEASURE"));     	//순중량
		modelMap.put("SUN_UT",              (String) outMap.get("NETWEIGHTMEASURE_UC"));    //순중량단위
		modelMap.put("MODIRAN",             "");     										//정정구분
	

		// 입력필드 확인설정 MAP 반환
		return modelMap;
	}

	/**
	 * 수출신고 정정
	 */
	@Override
	public AjaxModel saveExpDecMod(AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		param.put("USER_ID" , model.getUsrSessionModel().getUserId());
		param.put("RPT_DAY" , StringUtil.null2Str(param.get("RPT_DAY")).replaceAll("-", ""));
		param.put("LIS_DAY" , StringUtil.null2Str(param.get("EXP_LIS_DAY")).replaceAll("-", ""));
		
		//수출신고서 테이블들(EXP_CUSDEC830~)의 대상 수출신고번호(RPT_NO)의 차수(RPT_SEQ)를 증가 시켜 해당 레코드들을 복사한다.
		String rpt_seq = (String) commonDAO.select("dec.selectExpDecRptSeq", param);
		param.put("RPT_SEQ" , rpt_seq);
		commonDAO.insert("dec.insertExpDec830Copy", param);
		commonDAO.insert("dec.insertExpDec830RanCopy", param);
		commonDAO.insert("dec.insertExpDec830RanItemCopy", param);
		
		//수출정정신청 공통(EXP_CUSDMR5AS) 레코드를 신규 생성한다. 
		String modi_seq = (String) commonDAO.select("dec.selectExpDmrModiSeq", param);
		param.put("MODI_SEQ" , modi_seq);
		param.put("SEND" , "01");
		param.put("RECD" , "");
		commonDAO.insert("dec.insertExpDmr5as", param);
		
		//수출신고서 전송상태UPDATE
		param.put("SEND", "05");	//정정진행중 ('AAA1001')
		commonDAO.update("dec.updateDecSend", param);
		
		model.setCode("I00000035"); //저장 되었습니다. 수출정정신고 메뉴에서 정정 내역을 작성하고 관세청으로 전송하시기 바랍니다.
		model.setData(param);
		
		return model;
	}
	
	/**
	 * 수출신고 취하
	 */
	@Override
	public AjaxModel saveExpDecCancel(AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		param.put("USER_ID" , model.getUsrSessionModel().getUserId());
		param.put("RPT_DAY" , StringUtil.null2Str(param.get("RPT_DAY")).replaceAll("-", ""));
		param.put("LIS_DAY" , StringUtil.null2Str(param.get("EXP_LIS_DAY")).replaceAll("-", ""));
		
		//수출정정신청 공통(EXP_CUSDMR5AS) 레코드를 신규 생성한다. 
		String modi_seq = (String) commonDAO.select("dec.selectExpDmrModiSeq", param);
		param.put("MODI_SEQ" , modi_seq);
		param.put("SEND" , "01");
		param.put("RECD" , "");
		commonDAO.insert("dec.insertExpDmr5as", param);
		
		//수출신고서 전송상태UPDATE
		param.put("SEND", "06");	//취하진행중 ('AAA1001')
		commonDAO.update("dec.updateDecSend", param);
		
		
		try{
			sendExpModDoc(param);	
			model.setCode("I00000022"); //신청 되었습니다. 수출정정신고조회 메뉴에서 정정 내역을 확인하세요
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return model;
	}
	
	//수출취하/기간연장  전송
	private void sendExpModDoc(Map<String, Object> in) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("USER_ID" , in.get("USER_ID"));
		param.put("TYPE"    , "ECC");
		Map<String, Object> IdenInfo = (Map<String, Object>) commonDAO.select("dec.selectCmmIdentifier", param);
		
		if (MapUtils.isEmpty(IdenInfo)) {
			throw new Exception(param.get("USER_ID")+"에 해당하는 식별자 정보가 없습니다.");
		}
				
		
		param.put("REQ_KEY", in.get("RPT_NO")+"_"+in.get("MODI_SEQ"));
		param.put("SNDR_ID", IdenInfo.get("IDENTIFY_ID"));
		param.put("RECP_ID", "KCS4G001");
		param.put("DOC_TYPE", "GOVCBR5AS");
		
		AjaxModel model = new AjaxModel();
		List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();   
		paramList.add(param);
		model.setDataList(paramList);
		try {
			//전송
			ediService.sendDoc(model);
			//상태업데이트
			commonDAO.insert("mod.updateExpDmrSend", in);
		} catch (BizException e) {
			throw new Exception(e);
		}
	}
	
	/**
	 * 수출신고 기간연장
	 */
	@Override
	public AjaxModel saveExpDecTerm(AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		String jukDayChg = (String) param.get("JUK_DAY_CHG");
		param.put("USER_ID" , model.getUsrSessionModel().getUserId());
		param.put("RPT_DAY" , StringUtil.null2Str(param.get("RPT_DAY")).replaceAll("-", ""));
		param.put("LIS_DAY" , StringUtil.null2Str(param.get("EXP_LIS_DAY")).replaceAll("-", ""));
		param.put("JUK_DAY_CHG" , jukDayChg.replaceAll("-", ""));
		
		//1.수출신고서 테이블들(EXP_CUSDEC830~)의 대상 수출신고번호(RPT_NO)의 차수(RPT_SEQ)를 증가 시켜 해당 레코드들을 복사한다.
		String rpt_seq = (String) commonDAO.select("dec.selectExpDecRptSeq", param);
		param.put("RPT_SEQ" , rpt_seq);
		commonDAO.insert("dec.insertExpDec830Copy", param);
		commonDAO.insert("dec.insertExpDec830RanCopy", param);
		commonDAO.insert("dec.insertExpDec830RanItemCopy", param);
		
		
		//2.수출정정신청 공통(EXP_CUSDMR5AS) 레코드를 신규 생성한다. 
		String modi_seq = (String) commonDAO.select("dec.selectExpDmrModiSeq", param);
		param.put("MODI_SEQ" , modi_seq);
		param.put("SEND" , "01");
		param.put("RECD" , "");
		commonDAO.insert("dec.insertExpDmr5as", param);
		
		//3.‘00’차수 수출신고서의 적재의무기한(JUK_DAY)을  신규 적재의무기한으로 변경한다
		commonDAO.update("dec.updateExpDec830Term", param);
		
		//4.수출정정신청 ITEM(EXP_CUSDMR5AS_ITEM) 레코드를 신규 생성한다.
		param.put("RAN_NO"    , "000");
		param.put("SIZE_NO"   , "00");
		param.put("ITEM_NO"   , "A608");
		param.put("RAN_DIVI"  , "");
		param.put("MODIFRONT" , StringUtil.null2Str(param.get("JUK_DAY")).replaceAll("-", ""));
		param.put("MODIAFTER" , jukDayChg.replaceAll("-", ""));
		commonDAO.insert("dec.insertExpDmr5asItem", param);
		
		//수출신고서 전송상태UPDATE
		param.put("SEND", "05");	//정정진행중 ('AAA1001')
		commonDAO.update("dec.updateDecSend", param);
		
		try{
			sendExpModDoc(param);			
			model.setCode("I00000022"); //신청 되었습니다. 수출정정신고조회 메뉴에서 정정 내역을 확인하세요
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return model;
	}
	
	/**
	 * 수출신고 수정
	 */
	@Override
	public AjaxModel saveExpDecAll(AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		param.put("USER_ID" 	, model.getUsrSessionModel().getUserId());
		param.put("APPLY_DATE"  , exchangeBaseDate);
		param.put("NATION"  	, param.get("CUR"));
		param.put("IMPORT_EXPORT"  , "E");
		param.put("BOSE_RPT_DAY1"  , StringUtil.null2Str(param.get("BOSE_RPT_DAY1")).replaceAll("-", ""));
		param.put("BOSE_RPT_DAY2"  , StringUtil.null2Str(param.get("BOSE_RPT_DAY2")).replaceAll("-", ""));
		String gbn = (String) param.get("GBN");
		if("A".equals(gbn)){
			commonDAO.update("dec.updateExpDec", param);
		}else if("B".equals(gbn)){
			commonDAO.update("dec.updateExpDecRan", param);
		}else{
			commonDAO.update("dec.updateExpDecItem", param);
			//란의 결제금액을 UPDATE 하기위해 호출
			commonDAO.update("dec.updateExpDecRan", param);
		}
		
		//신고가 UPDATE
		updateExpDecAmt(param);
		
		model.setCode("I00000003"); //저장되었습니다.
		
		
		return model;
	}
	
	/**
	 * 수출정정취하신고 수정
	 */
	@Override
	public AjaxModel saveModExpDecAll (AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		param.put("USER_ID" , model.getUsrSessionModel().getUserId());
		param.put("MODI_DAY" , StringUtil.null2Str(param.get("MODI_DAY")).replaceAll("-", ""));
		commonDAO.update("dec.updateCusDmr5As", param);
		
		model.setCode("I00000003"); //저장되었습니다.
		
		
		return model;
	}
	
	/**
	 * 수출정정취하신고 정정내역생성
	 */
	@Override
	public AjaxModel saveModExpDecDtl (AjaxModel model) throws Exception {
		
		Map<String, Object> param = model.getData();
		String gbn = (String) param.get("GBN");
		int itemSize = ((Double) param.get("ITEM_SIZE")).intValue();
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		param.put("USER_ID" , model.getUsrSessionModel().getUserId());
		param.put("APPLY_DATE"  , exchangeBaseDate);
		param.put("NATION"  	, param.get("CUR"));
		param.put("IMPORT_EXPORT"  , "E");
		
		//공통
		if("A".equals(gbn)){
			
			//수출신고서 수정
			param.put("AMT" , StringUtil.null2Str(param.get("AMT")).replaceAll(",", ""));
			param.put("RPT_SEQ" , "00");
			commonDAO.update("dec.updateExpDec", param);
			
			//신고가 UPDATE
			if(itemSize>0) updateExpDecAmt(param);
			
			//새로 수정된 수출신고목록 조회(00 차수)
			List<Map<String, Object>> afterList = commonDAO.list("dec.selectDecDetail", param);
			
			//최종차수 수출신고목록 조회
			String rptSeq = (String) commonDAO.select("dec.selectExpDecRptSeq", param);
			int iRptSeq = Integer.parseInt(rptSeq) - 1;
			rptSeq = DocUtil.lpadbyte(""+(iRptSeq), 2, "0");
			param.put("S_RPT_SEQ" , rptSeq);
			List<Map<String, Object>> beforeList = commonDAO.list("dec.selectDecDetail", param);
			
			//컬럼명 정보 조회
			param.put(Constant.RESULTSET_METADATA_KEY.getCode(), "RETURN_KEY"); // 'RETURN_KEY'의 문자열을 KEY로 컬럼명 리스트 생성
			commonDAO.listWithMetadata("dec.selectDecDetail", param);
			List colNmlist = (List) param.get("RETURN_KEY"); 
			
			//수정된 항목 가져오기
			List<Map<String, Object>> modList = compareModExp(beforeList, afterList, colNmlist);
			Map<String, Object> modMap = new HashMap<String, Object>();
			
			//관세청 제공 수출정정항목 조회
			List<Map<String, Object>> itemList = commonDAO.list("dec.selectExpModItemA");
			Map<String, Object> itemMap = new HashMap<String, Object>();
			
			param.put("DEL_GBN"   , gbn);
			commonDAO.delete("dec.deleteExpDmr5asItem", param);
			for (int j=0; j<itemList.size(); j++){
				itemMap = itemList.get(j);
				String sFieldNm = StringUtil.null2Str((String) itemMap.get("FIELD_NM"));
				for (int k=0;k<modList.size();k++){
					modMap =  modList.get(k);
					if(sFieldNm.equals(modMap.get("FIELD_NM"))){						
						Map<String, Object> paramMap = new HashMap<String, Object>();
						
						paramMap.put("RPT_NO"     , param.get("RPT_NO"));			//신청번호
						paramMap.put("MODI_SEQ"   , param.get("MODI_SEQ"));						//순번
						paramMap.put("RAN_NO"     , "000");							//란번호
						paramMap.put("SIZE_NO"    , "00" );							//규격번호
						paramMap.put("CNTR_SEQNO" , "");
						paramMap.put("LAW_SEQNO"  , "");
						paramMap.put("CAR_SEQNO"  , "");
						paramMap.put("ITEM_NO"    , itemMap.get("MOD_ITEM_NO"));
						paramMap.put("ITEM_NM"    , itemMap.get("MOD_ITEM_DESC"));	//항목명
						paramMap.put("RAN_DIVI"   , "");							//정정구분
						paramMap.put("MODIFRONT"  , modMap.get("MODIFRONT"));		//정정전내역
						paramMap.put("MODIAFTER"  , modMap.get("MODIAFTER"));		//정정후내역
						paramMap.put("USER_ID"    , param.get("USER_ID"));
						
						//수정된 항목 저장
						commonDAO.insert("dec.insertExpDmr5asItem", paramMap);
					}
				}
			}
			
			
		//란	
		}else if("B".equals(gbn)){
			
			//수출신고서 란 수정
			param.put("RPT_SEQ" , "00");
			commonDAO.update("dec.updateExpDecRan", param);
			
			//신고가 UPDATE
			if(itemSize>0) updateExpDecAmt(param);
			
			//새로 수정된 수출신고 란 목록 조회(00 차수)
			List<Map<String, Object>> afterList = commonDAO.list("dec.selectDecRanDetail", param);
			
			//최종차수 수출신고 란 목록 조회
			String rptSeq = (String) commonDAO.select("dec.selectExpDecRptSeq", param);
			int iRptSeq = Integer.parseInt(rptSeq) - 1;
			rptSeq = DocUtil.lpadbyte(""+(iRptSeq), 2, "0");
			param.put("RPT_SEQ" , rptSeq);
			List<Map<String, Object>> beforeList = commonDAO.list("dec.selectDecRanDetail", param);
			
			//컬럼명 정보 조회
			param.put(Constant.RESULTSET_METADATA_KEY.getCode(), "RETURN_KEY"); // 'RETURN_KEY'의 문자열을 KEY로 컬럼명 리스트 생성
			commonDAO.listWithMetadata("dec.selectDecRanDetail", param);
			List colNmlist = (List) param.get("RETURN_KEY"); 
			
			//수정된 항목 가져오기
			List<Map<String, Object>> modList = compareModExp(beforeList, afterList, colNmlist);
			Map<String, Object> modMap = new HashMap<String, Object>();
			
			//관세청 제공 수출정정항목 조회
			List<Map<String, Object>> itemList = commonDAO.list("dec.selectExpModItemB");
			Map<String, Object> itemMap = new HashMap<String, Object>();
			
			param.put("DEL_GBN"   , gbn);
			commonDAO.delete("dec.deleteExpDmr5asItem", param);
			for (int j=0; j<itemList.size(); j++){
				itemMap = itemList.get(j);
				String sFieldNm = StringUtil.null2Str((String) itemMap.get("FIELD_NM"));
				for (int k=0;k<modList.size();k++){
					modMap =  modList.get(k);
					if(sFieldNm.equals(modMap.get("FIELD_NM"))){						
						Map<String, Object> paramMap = new HashMap<String, Object>();
						
						paramMap.put("RPT_NO"     , param.get("RPT_NO"));			//신청번호
						paramMap.put("MODI_SEQ"   , param.get("MODI_SEQ"));			//순번
						paramMap.put("RAN_NO"     , param.get("RAN_NO"));			//란번호
						paramMap.put("SIZE_NO"    , "00" );							//규격번호
						paramMap.put("CNTR_SEQNO" , "");
						paramMap.put("LAW_SEQNO"  , "");
						paramMap.put("CAR_SEQNO"  , "");
						paramMap.put("ITEM_NO"    , itemMap.get("MOD_ITEM_NO"));
						paramMap.put("ITEM_NM"    , itemMap.get("MOD_ITEM_DESC"));	//항목명
						paramMap.put("RAN_DIVI"   , "03");							//정정구분
						paramMap.put("MODIFRONT"  , modMap.get("MODIFRONT"));		//정정전내역
						paramMap.put("MODIAFTER"  , modMap.get("MODIAFTER"));		//정정후내역
						paramMap.put("USER_ID"    , param.get("USER_ID"));
						
						//수정된 항목 저장
						commonDAO.insert("dec.insertExpDmr5asItem", paramMap);
					}
				}
			}
			
		//모델&규격
		}else{
			//수출신고서 모델&규격 수정
			param.put("RPT_SEQ" , "00");
			commonDAO.update("dec.updateExpDecItem", param);
			
			//신고가 UPDATE
			if(itemSize>0) updateExpDecAmt(param);
			
			//새로 수정된 수출신고 란 목록 조회(00 차수)
			List<Map<String, Object>> afterList = commonDAO.list("dec.selectDecModelDetail", param);
			
			//최종차수 수출신고 란 목록 조회
			String rptSeq = (String) commonDAO.select("dec.selectExpDecRptSeq", param);
			int iRptSeq = Integer.parseInt(rptSeq) - 1;
			rptSeq = DocUtil.lpadbyte(""+(iRptSeq), 2, "0");
			param.put("RPT_SEQ" , rptSeq);
			List<Map<String, Object>> beforeList = commonDAO.list("dec.selectDecModelDetail", param);
			
			//컬럼명 정보 조회
			param.put(Constant.RESULTSET_METADATA_KEY.getCode(), "RETURN_KEY"); // 'RETURN_KEY'의 문자열을 KEY로 컬럼명 리스트 생성
			commonDAO.listWithMetadata("dec.selectDecModelDetail", param);
			List colNmlist = (List) param.get("RETURN_KEY"); 
			
			//수정된 항목 가져오기
			List<Map<String, Object>> modList = compareModExp(beforeList, afterList, colNmlist);
			Map<String, Object> modMap = new HashMap<String, Object>();
			
			//관세청 제공 수출정정항목 조회
			List<Map<String, Object>> itemList = commonDAO.list("dec.selectExpModItemC");
			Map<String, Object> itemMap = new HashMap<String, Object>();
			
			param.put("DEL_GBN"   , gbn);
			commonDAO.delete("dec.deleteExpDmr5asItem", param);
			for (int j=0; j<itemList.size(); j++){
				itemMap = itemList.get(j);
				String sFieldNm = StringUtil.null2Str((String) itemMap.get("FIELD_NM"));
				for (int k=0;k<modList.size();k++){
					modMap =  modList.get(k);
					if(sFieldNm.equals(modMap.get("FIELD_NM"))){						
						Map<String, Object> paramMap = new HashMap<String, Object>();
						
						paramMap.put("RPT_NO"     , param.get("RPT_NO"));			//신청번호
						paramMap.put("MODI_SEQ"   , param.get("MODI_SEQ"));			//순번
						paramMap.put("RAN_NO"     , param.get("RAN_NO"));			//란번호
						paramMap.put("SIZE_NO"    , param.get("SIL"));				//규격번호
						paramMap.put("CNTR_SEQNO" , "");
						paramMap.put("LAW_SEQNO"  , "");
						paramMap.put("CAR_SEQNO"  , "");
						paramMap.put("ITEM_NO"    , itemMap.get("MOD_ITEM_NO"));
						paramMap.put("ITEM_NM"    , itemMap.get("MOD_ITEM_DESC"));	//항목명
						paramMap.put("RAN_DIVI"   , "03");							//정정구분
						paramMap.put("MODIFRONT"  , modMap.get("MODIFRONT"));		//정정전내역
						paramMap.put("MODIAFTER"  , modMap.get("MODIAFTER"));		//정정후내역
						paramMap.put("USER_ID"    , param.get("USER_ID"));
						
						//수정된 항목 저장
						commonDAO.insert("dec.insertExpDmr5asItem", paramMap);
					}
				}
			}
		}
		
		model.setCode("I00000003"); //저장되었습니다.
		
		return model;
	}

	/**
	 * 수출정정내역 비교
	 */
	private List<Map<String, Object>> compareModExp( List<Map<String, Object>> beforeList, List<Map<String, Object>> afterList, List colNmlist) {
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> itemMap = new HashMap<String, Object>();
		for(int i=0; i<beforeList.size(); i++){
			itemMap = beforeList.get(i);
			Map<String, Object> itemMap2 = new HashMap<String, Object>();
			for(int j=0; j<afterList.size(); j++){
				itemMap2 = afterList.get(j);
				for(int k=0; k<colNmlist.size();k++){
					String colVal1, colVal2 = "";
					colVal1 = StringUtil.null2Str(itemMap.get(colNmlist.get(k)));
					colVal2 = StringUtil.null2Str(itemMap2.get(colNmlist.get(k)));
					if(!colVal1.equals(colVal2)){
						resultMap = new HashMap<String, Object>();
						resultMap.put("FIELD_NM", colNmlist.get(k));
						resultMap.put("MODIFRONT", colVal1);	//정정전내역
						resultMap.put("MODIAFTER", colVal2);	//정정후내역
						resultList.add(resultMap);
					}
				}
			}
		}
		return resultList;
	}
	
	
	
	/**
	 * 공통사항 Validation
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @param baseValConf 
	 * @param itemValue 
	 * @param orgValue 
	 * @param mainMap 
	 * @param itemNmArr 
	 * @param itemValue 
	 * @param baseValConf 
	 * @param orgValue 
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @return 
	 */
	private DocumentCheckMap checkValidationMain(String itemNmArr, Map<String, Object> mainMap, String orgValue, String itemValue, Map<String, Object> baseValConf, String errMsg, JSONObject jsonOBJ) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int checkSize = 0;
		String checkCode = "";
		String checkCodeNm = "";
		if("0.0".equals(itemValue)) itemValue = "0";
		
		//수출신고항목별 예외체크사항
		if ("LodingLocationTypeCode".toUpperCase().equals(itemNmArr.toUpperCase())){
			
			String loadingLocation = StringUtil.null2Str(mainMap.get("LODINGLOCATIONID"));	//기본값으로 설정되었을수도 있으므로 결과맵에서 찾는다.
			paramMap.put("CLASS_ID", "CUS0046");	//항구공항
			paramMap.put("CODE", loadingLocation);
			Map<String, Object> LocInfo = (Map<String, Object>)commonDAO.select("comm.getCommcodeDetail", paramMap);
			if(MapUtils.isNotEmpty(LocInfo)){				
				mainMap.put("LODINGLOCATIONTYPECODE",   LocInfo.get("USER_REF1"));	//3G
				mainMap.put("LODINGLOCATIONTYPECODE4G", LocInfo.get("USER_REF3"));	//4G
			}				
			
		}
		
		//제조자 우편번호는 없을시 화주우편번호를 사용
		if ("ManuPartyLocID".toUpperCase().equals(itemNmArr.toUpperCase())){
			if (StringUtil.isEmpty(itemValue)){
				itemValue = (String) mainMap.get("EOCPARTYLOCID");
			}
		}
		
		//총포장수량이 0이면 1을 셋팅. 값이 없으면 기본값으로 1로 처리됨.(앞서계산한 아이템 최대 포장갯수보다 작으면 오류처리)
		if ("Summary_TotalQuantity".toUpperCase().equals(itemNmArr.toUpperCase())){
			itemValue = StringUtil.null2Str(mainMap.get("SUMMARY_TOTALQUANTITY"));
			if ("0".equals(itemValue)){
				itemValue = "1";
			}
		}
		
		try {
			//항목체크
			if (StringUtil.isEmpty(itemValue) && "N".equals(baseValConf.get("BASE_VAL_DIV"))){
				String baseVal = (String) baseValConf.get("BASE_VAL");
				if (StringUtil.isEmpty(baseVal)) {
					// 환급신청인 기본값을 추가하여, 기존 사용자 기본값이 없을 수 있으므로, 부득이 예외코드 삽입
					// 차후 사용자 전체에 기본값이 없을(0)을 설정하여 변경할 필요가 있는지 검토 필요
					if(!"DrawBackRole".toUpperCase().equals(itemNmArr.toUpperCase())){
						throw new BizException("빈값오류");
					}
				}else{
					//항목설정에서 설정한 기본값이 있을때는 빈값대신 기본값을 사용한다.
					//단 총중량은 설정된 기본값을 기준으로 란수만큼 나누어서 란값으로 반영해준다.
					itemValue = baseVal;
				}
			}
			
			//신고할 문자열 사이즈체크
			try { checkSize = (int) baseValConf.get("CHECK_SIZE");	} catch (Exception e){	checkSize = 0;	}
			if ( checkSize>0 && DocUtil.length2Byte(itemValue)>checkSize ) {
				throw new BizException("입력사이즈오류");
			}
			
			//공통코드값 체크
			// 환급신청인은 코드가 없을 수 있어서 부득이 예외코드 삽입, 차후 사용자 전체에 기본값이 없음(0)을 설정하여 변경할 필요가 있는지 검토 필요
			checkCode = (String) baseValConf.get("CHECK_CODE");
			if ( !StringUtil.isEmpty(checkCode) && !"DrawBackRole".toUpperCase().equals(itemNmArr.toUpperCase())) {
				paramMap = new HashMap<String, Object>();
				paramMap.put("CLASS_ID", checkCode);
				paramMap.put("CODE", itemValue);
				try { 
					Map<String, Object> cdInfo = (Map<String, Object>) commonDAO.select("comm.getCommcodeDetail", paramMap);
					checkCodeNm = (String) cdInfo.get("CODE_NM");
				} catch(Exception e) { 
					checkCodeNm = ""; 
					};
				if (StringUtil.isEmpty(checkCodeNm)){
					throw new BizException("잘못된 코드값");
				}
				mainMap.put(itemNmArr+"_CDNM", checkCodeNm);
			}
			
			//영문입력확인. 
			if ( isEngItem(itemNmArr) ){
				if ( !DocUtil.isEnglishOnlySymbols(itemValue) ){
					throw new BizException("영문만 허용.");
				}
			}
		} catch (Exception die){
			String dieExceptionDesc = die.getMessage();
			errMsg += baseValConf.get("ITEM_DESC")+" "+dieExceptionDesc+", ";
			jsonOBJ.put(baseValConf.get("API_ITEM_NM"), orgValue);
		}
		
		mainMap.put(itemNmArr, DocUtil.checkItemValue(itemNmArr, itemValue));
		
		return new DocumentCheckMap(null, mainMap, errMsg, jsonOBJ);
	}
	
	/**
	 * 공통사항 Validation
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @param baseValConf 
	 * @param itemsCnt 
	 * @param hsWtUnit 
	 * @param hsPkgUnit 
	 * @param itemValue 
	 * @param orgValue 
	 * @param ran 
	 * @param ranMap 
	 * @param itemNmArr 
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @param baseValConf 
	 * @param itemsCnt 
	 * @param hsWtUnit 
	 * @param hsPkgUnit 
	 * @param itemValue 
	 * @param itemNmArr 
	 * @param itemNmArr 
	 * @param hsWtUnit 
	 * @param itemValue 
	 * @param itemValue 
	 * @param itemsCnt 
	 * @param hsWtUnit2 
	 * @param baseValConf 
	 * @param baseValConf 
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @param orgValue 
	 * @param jsonOBJ 
	 * @param errMsg 
	 * @return 
	 */
	//checkMap = checkValidationRan(itemNmArr[i], itemValue, hsPkgUnit, hsWtUnit, itemsCnt, baseValConf, errMsg, jsonOBJ);
	private DocumentCheckMap checkValidationRan(String itemNmArr, Map<String, Object> ranMap, int ran, String orgValue, String itemValue, String hsPkgUnit, String hsWtUnit, int itemsCnt, Map<String, Object> baseValConf, String errMsg, JSONObject jsonOBJ) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int checkSize = 0;
		String checkCode = "";
		String checkCodeNm = "";
		if("0.0".equals(itemValue)) itemValue = "0";
		//HS중량단위가 없을때는 값을 보내지 않는다.  HS표준코드에 설정된 단위를 사용
		if ("NETWEIGHTMEASURE".equals(itemNmArr) || "NETWEIGHTMEASURE_UC".equals(itemNmArr)){
			if (StringUtil.isEmpty(hsWtUnit)){
				ranMap.put(itemNmArr, "");
				return new DocumentCheckMap(null, ranMap, errMsg, jsonOBJ);
			}else{
				if ("NETWEIGHTMEASURE_UC".equals(itemNmArr))  itemValue = hsWtUnit;
			}
		}
		//HS수량단위가 없을때는 값을 보내지 않는다.  HS표준코드에 설정된 단위를 사용
		if ("LINEITEMQUANTITY".equals(itemNmArr) || "LINEITEMQUANTITY_UC".equals(itemNmArr)){
			if (StringUtil.isEmpty(hsPkgUnit)){
				ranMap.put(itemNmArr, "");
				return new DocumentCheckMap(null, ranMap, errMsg, jsonOBJ);
			}else{
				if ("LINEITEMQUANTITY_UC".equals(itemNmArr))  itemValue = hsPkgUnit;
			}
		}
		//개별 중량이 없을때는 전체 아이템수로 1을 나눈값을 중량으로 처리한다.
		if ("NetWeightMeasure".toUpperCase().equals(itemNmArr.toUpperCase())){
			if ("0".equals(itemValue)){
				itemValue = DocUtil.calcBasicWeight(itemsCnt);
			}
		}
		//포장수량이 0일때는 기본값 1을 셋팅
		if ("PackagingQuantity".toUpperCase().equals(itemNmArr.toUpperCase())){
			if ("0".equals(itemValue)){
				itemValue = "1";
			}
		}

		try {
			//항목체크
			if (StringUtil.isEmpty(itemValue) && "N".equals(baseValConf.get("BASE_VAL_DIV"))){
				String baseVal = (String) baseValConf.get("BASE_VAL");
				if (StringUtil.isEmpty(baseVal)) {
					throw new BizException("빈값오류");
				}else{
					//항목설정에서 설정한 기본값이 있을때는 빈값대신 기본값을 사용한다.
					//단 총중량은 설정된 기본값을 기준으로 란수만큼 나누어서 란값으로 반영해준다.
					itemValue = baseVal;
				}
			}
			
			//신고할 문자열 사이즈 체크
			if ( checkSize>0 && DocUtil.length2Byte(itemValue)>checkSize ) {
				itemValue = DocUtil.getByteLenStr(itemValue, checkSize);
			}
			
			//공통코드값 체크
			checkCode = (String) baseValConf.get("CHECK_CODE");
			if ( !StringUtil.isEmpty(checkCode) ) {
				paramMap = new HashMap<String, Object>();
				paramMap.put("CLASS_ID", checkCode);
				paramMap.put("CODE", itemValue);
				try {
					Map<String, Object> cdInfo = (Map<String, Object>)commonDAO.select("comm.getCommcodeDetail", paramMap);
					checkCodeNm = (String) cdInfo.get("CODE_NM"); 
				} catch(Exception e){ 
					checkCodeNm = ""; 
					};
				if (StringUtil.isEmpty(checkCodeNm)){
					throw new BizException("잘못된 코드값");
				}
				ranMap.put(itemNmArr+"_CDNM", checkCodeNm);
			}
			
			//영문입력확인. 
			if ( isEngItem(itemNmArr) ){
				if ( !DocUtil.isEnglishOnlySymbols(itemValue) ){
					throw new BizException("영문만 허용.");
				}
			} else if ("ITEMNAME_EN".equalsIgnoreCase(itemNmArr)){
				if (!DocUtil.isEngNumSpcCharOnly(itemValue)) {
					throw new BizException("영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 허용");
				}
			}
		} catch (Exception die){
			String dieExceptionDesc = die.getMessage();
			errMsg += (String) baseValConf.get("ITEM_DESC")+(ran+1)+" "+dieExceptionDesc+", ";
			jsonOBJ.put(baseValConf.get("API_ITEM_NM"), orgValue);
		}
		
		ranMap.put(itemNmArr, DocUtil.checkItemValue(itemNmArr, itemValue));
		
		return new DocumentCheckMap(null, ranMap, errMsg, jsonOBJ);
	}
	
	private DocumentCheckMap checkValidationModel(String itemNmArr, Map<String, Object> modelMap, int iModel, String orgValue, String itemValue, String hsPkgUnit, String hsWtUnit, int itemsCnt, Map<String, Object> baseValConf, String errMsg, JSONObject jsonOBJ){
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int checkSize = 0;
		String checkCode = "";
		String checkCodeNm = "";
		if("0.0".equals(itemValue)) itemValue = "0";
		//HS수량단위가 없을때  HS표준코드에 설정된 단위를 사용
		if ("LINEITEMQUANTITY_UC".equals(itemNmArr)){
			if (StringUtil.isEmpty(itemValue)){
				itemValue = hsPkgUnit;
			}
		}
		
		//HS중량단위가 없을때는 값을 보내지 않는다.  HS표준코드에 설정된 단위를 사용
		if ("NETWEIGHTMEASURE".equals(itemNmArr) || "NETWEIGHTMEASURE_UC".equals(itemNmArr)){
			if (StringUtil.isEmpty(hsWtUnit)){
				modelMap.put(itemNmArr, "");
				return new DocumentCheckMap(null, modelMap, errMsg, jsonOBJ);
			}else{
				if ("NETWEIGHTMEASURE_UC".equals(itemNmArr))  itemValue = hsWtUnit;
			}
		}
		//개별 중량이 없을때는 전체 아이템수로 1을 나눈값을 중량으로 처리한다.
		if ("NetWeightMeasure".toUpperCase().equals(itemNmArr.toUpperCase())){
			if ("0".equals(itemValue)){
				itemValue = DocUtil.calcBasicWeight(itemsCnt);
			}
		}
		//포장수량이 0일때는 기본값 1을 셋팅
		if ("PackagingQuantity".toUpperCase().equals(itemNmArr.toUpperCase())){
			if ("0".equals(itemValue)){
				itemValue = "1";
			}
		}

		try {
			//항목체크
			if (StringUtil.isEmpty(itemValue) && "N".equals(baseValConf.get("BASE_VAL_DIV"))){
				String baseVal = (String) baseValConf.get("BASE_VAL");
				if (StringUtil.isEmpty(baseVal)) {
					throw new BizException("빈값오류");
				}else{
					//항목설정에서 설정한 기본값이 있을때는 빈값대신 기본값을 사용한다.
					//단 총중량은 설정된 기본값을 기준으로 란수만큼 나누어서 란값으로 반영해준다.
					itemValue = baseVal;
				}
			}
			
			//신고할 문자열 사이즈 체크
			if ( checkSize>0 && DocUtil.length2Byte(itemValue)>checkSize ) {
				itemValue = DocUtil.getByteLenStr(itemValue, checkSize);
			}
			
			//공통코드값 체크
			checkCode = (String) baseValConf.get("CHECK_CODE");
			if ( !StringUtil.isEmpty(checkCode) ) {
				paramMap = new HashMap<String, Object>();
				paramMap.put("CLASS_ID", checkCode);
				paramMap.put("CODE", itemValue);
				try {
					Map<String, Object> cdInfo = (Map<String, Object>)commonDAO.select("comm.getCommcodeDetail", paramMap);
					checkCodeNm = (String) cdInfo.get("CODE_NM"); 
				} catch(Exception e){ 
					checkCodeNm = ""; 
					};
				if (StringUtil.isEmpty(checkCodeNm)){
					throw new BizException("잘못된 코드값");
				}
				modelMap.put(itemNmArr+"_CDNM", checkCodeNm);
			}
			
			//영문입력확인. 
			if ( isEngItem(itemNmArr) ){
				if ( !DocUtil.isEnglishOnlySymbols(itemValue) ){
					throw new BizException("영문만 허용.");
				}
			} else if ("ITEMNAME_EN".equalsIgnoreCase(itemNmArr)){
				if (!DocUtil.isEngNumSpcCharOnly(itemValue)) {
					throw new BizException("영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 허용");
				}
			}
		} catch (Exception die){
			String dieExceptionDesc = die.getMessage();
			errMsg += (String) baseValConf.get("ITEM_DESC")+(iModel+1)+" "+dieExceptionDesc+", ";
			jsonOBJ.put(baseValConf.get("API_ITEM_NM"), orgValue);
		}
		
		modelMap.put(itemNmArr, DocUtil.checkItemValue(itemNmArr, itemValue));
		
		return new DocumentCheckMap(null, modelMap, errMsg, jsonOBJ);
	}
	
	public DocumentCheckMap validationTotal(Map<String, Object> docExpMain, BigDecimal sumNetWeight, Map<String, Object> expReqInfo, String errMsg){
		//총포장수량, 총무게 체크
		//int checkTotPackCntDec = 1;
		//float checkTotWeightDec = 1f;
		BigDecimal decTotalWeight = null;	//총중량
		
		try {
			decTotalWeight = new BigDecimal((String) docExpMain.get("SUMMARY_TOTALWEIGHT"));
		}catch(Exception e){}
		if ( decTotalWeight == null ){
			docExpMain.put("SUMMARY_TOTALWEIGHT", sumNetWeight.toString());
		}else{
			if (decTotalWeight.compareTo(sumNetWeight) == -1){
				errMsg += "총중량이 항목별 중량합계보다 작음.";
			}
		}
		
		//제조자 미상이 아닌경우 환급신청인 처리
		//제조자 정보에 따른 수출자 구분 및 환급신청인 처리, 제조자 정보가 있으면 환급신청의도가 있으므로 오류처리 - 김정민과장 확인
		if(!"미상".equals(docExpMain.get("MANUPARTYORGNAME")) && !"제조미상9999000".equals(docExpMain.get("MANUPARTYORGID"))){
			String drawBackRole = (String) docExpMain.get("DRAWBACKROLE");
			if(!"1".equals(drawBackRole) && !"2".equals(drawBackRole)){
				errMsg += "제조자 정보가 확인되었으나 환급신청인 설정이 없습니다.";
			}

			if(!StringUtil.isEmpty((String) expReqInfo.get("MANUPARTYLOCSEQ"))){
				docExpMain.put("MANUPARTYLOCSEQ", (String) expReqInfo.get("MANUPARTYLOCSEQ"));
			}
			if(docExpMain.get("EOCPARTYPARTYIDID2").equals(docExpMain.get("MANUPARTYORGID"))){
				docExpMain.put("EXPORTERCLASSCODE", "A");
			}
		}
		
		//수출대행자등록번호체크로직추가
		if (!StringUtil.isEmpty((String) expReqInfo.get("EXPORTAGENTORGID")) && !DocUtil.checkExportDeclIdPattern((String) expReqInfo.get("EXPORTAGENTORGID"))){
			errMsg += "통관고유부호는 한글2~4자리와 *, 그리고 숫자와 영문만 사용가능합니다.";
		}
		
		if(!StringUtil.isEmpty((String) expReqInfo.get("EXPORTAGENTORGID"))){
			docExpMain.put("EXPORTAGENTORGID", expReqInfo.get("EXPORTAGENTORGID"));
		}
		
		if(!StringUtil.isEmpty((String) expReqInfo.get("EXPORTAGENTORGNAME"))){
			docExpMain.put("EXPORTAGENTORGNAME", expReqInfo.get("EXPORTAGENTORGNAME"));
		}
		
		return new DocumentCheckMap(null, docExpMain, errMsg, null);
	}
	
	/*
	 * 제출번호생성
	 * 1. 요청번호로 기존에 생성된 수출신고번호를 조회하여 상태를 확인한다.
	 * 2. 수출신고가 존재한다면 해당 수출신고의 상태가 오류통보인 경우에는 같은번호로 cusdec830에 수정저장하고 아니면 오류발생
	 */
	public DocumentCheckMap getRptNo(Map<String, Object> expReqInfo, String reqNo, String errMsg) {
		String oldRptNo = "";
		String oldRece = "";
		boolean isExist = false;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("REQ_NO", reqNo);
		 List<Map<String, Object>> records = commonDAO.list("dec.selectExpDecOldInfo", paramMap);
		if (records==null || records.size()<=0){
			//nothing
		}else{
			Map<String, Object> oldDecInfo = records.get(0);
			oldRptNo =  (String) oldDecInfo.get("RPT_NO");
			oldRece  =  (String) oldDecInfo.get("RECE");
			isExist  = true;
		}
		
		String rptNo = "";
		if (isExist){
			if (!"01".equals(oldRece)){	// 오류 ('AAA1002')
				errMsg = "수출신고 생성오류. 이미작성된 수출신고서가 존재합니다.";
			}else{
				rptNo = oldRptNo;
			}
		}else{
			String applicantId = (String) expReqInfo.get("APPLICANTPARTYORGID");
			if (!DocUtil.checkApplicantId(applicantId)){
				errMsg = "신고인부호="+applicantId+"오류";
			}
			
			//RPT NO 채번
			rptNo = makeRptNo(expReqInfo, "830");
		}
		paramMap.put("RPT_NO", rptNo);
		paramMap.put("IS_EXIST", isExist);
		
		return new DocumentCheckMap(null, paramMap, errMsg, null);
	}
		
	public String decimalToStr(Map map, String col){
		String val = "";
		try{
			val	= String.valueOf(((BigDecimal)map.get(col)).doubleValue());
		}catch(NullPointerException ne){
			val = "";
		}catch(Exception e){
			val = "";
		}
		return val;
	}
	
	private double getDoubleValue(Map map, String col) {
		double val = 0;
		try{
			val = ((BigDecimal) map.get(col)).doubleValue();
		}catch(Exception e){
			val = 0;
		}
		return val;
	}

    @Override
    public AjaxModel downloadExpReq(String reqNo) throws Exception {
    	Map mst = null;
    	
    	Map param = new HashMap();
    	param.put("REQ_NO", reqNo);
    	
    	AjaxModel model = new AjaxModel();
    	model.setData(param);
		
		param.clear();
    	param.put("REQ_NO", reqNo);
		param.put("qKey", "dec.selectExpReqFF");
		
    	model.setData(param);
    	
		commonService.select(model);
		mst = new HashMap(model.getData());
		
		List<Map<String, Object>> rans = new ArrayList();
		mst.put("RANS", rans);
    	
    	model.getData().put("qKey", "dec.selectExpReqRanFF");
    	rans = commonService.selectList(model).getDataList();
    	
		List<Map<String, Object>> ranItems = new ArrayList();
		mst.put("RAN_ITEMS", ranItems);
		
    	for(Map item : rans) {
    		param.clear();
    		param.putAll(item);
    		param.put("qKey", "dec.selectExpReqRanItemFF");
    		model.setData(param);
    		
    		ranItems.addAll(commonService.selectList(model).getDataList());
    	}
    	
    	StringBuffer stBuffer = new StringBuffer();
    	
    	String ruleStr = CUSDEC830Rule.getRuleStr(CUSDEC830Rule.EHDR, CUSDEC830Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[EHDR]")); 
			throw new BizException(model);
		}
		
		String[] rule = ruleStr.split("\\^", -1);
		for(int i = 0; i < rule.length -1; i++) {
			String[] vA = rule[i].split("#", -1);

			if(StringUtils.isEmpty(vA[0])) {
				stBuffer.append(vA[1]).append("^");
			} else {
				if(mst.get(vA[0]) != null) {
					stBuffer.append(mst.get(vA[0]).toString()).append("^");
				} else {
					stBuffer.append(vA[1]).append("^");
				}
			}
		}
		
		stBuffer.append(System.getProperty("line.separator"));
    	
    	ruleStr = CUSDEC830Rule.getRuleStr(CUSDEC830Rule.EDTL, CUSDEC830Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[EDTL]")); 
			throw new BizException(model);
		}
		
		rule = ruleStr.split("\\^", -1);
		
    	for(Map item : rans) {
			for(int i = 0; i < rule.length -1; i++) {
				String[] vA = rule[i].split("#", -1);
	
				if(StringUtils.isEmpty(vA[0])) {
					stBuffer.append(vA[1]).append("^");
				} else {
					if(item.get(vA[0]) != null) {
						stBuffer.append(item.get(vA[0]).toString()).append("^");
					} else {
						stBuffer.append(vA[1]).append("^");
					}
				}
			}
			
			stBuffer.append(System.getProperty("line.separator"));
    	}
    	
    	ruleStr = CUSDEC830Rule.getRuleStr(CUSDEC830Rule.EMDL, CUSDEC830Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[EMDL]")); 
			throw new BizException(model);
		}
		
		rule = ruleStr.split("\\^", -1);
		
    	for(Map item : ranItems) {
			for(int i = 0; i < rule.length -1; i++) {
				String[] vA = rule[i].split("#", -1);
	
				if(StringUtils.isEmpty(vA[0])) {
					stBuffer.append(vA[1]).append("^");
				} else {
					if(item.get(vA[0]) != null) {
						stBuffer.append(item.get(vA[0]).toString()).append("^");
					} else {
						stBuffer.append(vA[1]).append("^");
					}
				}
			}
			
			stBuffer.append(System.getProperty("line.separator"));
    	}
    	
		model.setMsg(stBuffer.toString());
		model.setData(mst);
		
        return model;
    }	

	@Override
	public AjaxModel uploadResFile(HttpServletRequest request) throws Exception {
		UsrSessionModel sessionModel = (UsrSessionModel) request.getSession(true).getAttribute(Constant.SESSION_KEY_USR.getCode());
		String applicationId = sessionModel.getApplicantId();
		
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();

        Map<String, Object> retMap = new HashMap<>();

        AjaxModel model = new AjaxModel();
        while(iterator.hasNext()){
            String fileName = iterator.next();
            if(multipartHttpServletRequest.getFile(fileName).isEmpty()){
                continue;
            }

            List<MultipartFile> fileList = multipartHttpServletRequest.getFiles(fileName);
            for(MultipartFile multipartFile : fileList){
                InputStream in = multipartFile.getInputStream();
                
                if(in != null) {
                	List<String> txts = null;
                	try{ 
                		txts = IOUtils.readLines(in, "MS949");
                	} finally {
                		IOUtils.closeQuietly(in);
                	}                		
                	
                	List<String[]> dataAll = new ArrayList<String[]>(); 
            		for(int i = 0; i < txts.size(); i++) {
            			String[] item = txts.get(i).split("\\^", -1);
            			String ruleStr = CUSDEC830Rule.getRuleStr(item[0], CUSDEC830Rule.UP);
            			
            			if(ruleStr == null) {
            				logger.debug(commonService.getMessage("W00000047", "존재하지 않는 내역코드[" + item[0] + "]"));
            				continue;
            			}
            			
            			dataAll.add(item);
            		}

            		boolean isExistEHDR = false;
            		boolean isExistEDTL = false;
            		boolean isExistEMDL = false;
            		
            		String prtNo = "";
            		for(String[] data :  dataAll) {
            			String ruleStr = CUSDEC830Rule.getRuleStr(data[0], CUSDEC830Rule.UP);
            			
            			String[] rule = ruleStr.split("\\^", -1);
            			if(rule.length != data.length) {	// 스펙 체크
            				model.setMsg(commonService.getMessage("W00000047", "룰파일[" + rule.length + "]과 데이터[" + data.length + "] 길이 불일치[" + data[0] + "]")); 
	    					throw new BizException(model);
            			}
            			
            			if(data[0].equals("EHDR")) isExistEHDR = true;
            			if(data[0].equals("EDTL")) isExistEDTL = true;
            			if(data[0].equals("EMDL")) isExistEMDL = true;
            			
            			if(prtNo.equals("")) {
            				prtNo = data[2];
            			}
            			
            			if(!prtNo.startsWith(applicationId) || !prtNo.equals(data[2])) {	// 신고번호 불일치
            				model.setMsg(commonService.getMessage("W00000047", "파일내 신고번호 불일치"));
	    					throw new BizException(model);
            			}
            		}
            		
            		if(!isExistEHDR || !isExistEDTL || !isExistEMDL) {	// 최소 1건의 항목이 존재 해야 함
            			model.setMsg(commonService.getMessage("W00000047", "필수 세그먼크 미존재"));
    					throw new BizException(model);
            		}

            		Map mst = new HashMap<String,Object>();
            		List<Map<String,String>> ran = new ArrayList();
            		mst.put("RAN", ran);
            		List<Map<String,String>> ranItem = new ArrayList();
            		mst.put("RAN_ITEM", ranItem);
            		for(String[] data :  dataAll) {
            			String[] rule = CUSDEC830Rule.getRuleStr(data[0], CUSDEC830Rule.UP).split("\\^", -1);
            			
            			if(data[0].equals("EHDR")) {	// 중복시 최종 데이터로 처리됨
                			for(int i = 1; i < rule.length; i++) {
                				String[] vA = rule[i].split("#", -1);

                				if(!StringUtils.isEmpty(vA[0])) {
                					mst.put(vA[0], data[i]);
                				}
                			}
            			} else {
            				Map item = new HashMap<String,String>();
            				if(data[0].equals("EDTL")) {
            					ran.add(item);
            				} else if(data[0].equals("EMDL")) {
            					ranItem.add(item);
            				}
                			for(int i = 1; i < rule.length; i++) {
                				String[] vA = rule[i].split("#", -1);

                				if(!StringUtils.isEmpty(vA[0])) {
                					item.put(vA[0], data[i]);
                				}
                			}
            			}
            		}
            		
            		if(StringUtils.isEmpty((String) mst.get("EXP_LIS_DAY"))) {
            			model.setMsg(commonService.getMessage("00000064", "수리일자"));
    					throw new BizException(model);
            		}
        		
            		commonDAO.delete("dec.deleteCUSDEC830_RAN_ITEMFF", mst);
            		commonDAO.delete("dec.deleteCUSDEC830_RANFF", mst);
            		commonDAO.delete("dec.deleteCUSDEC830FF", mst);
        			
            		commonDAO.insert("dec.insertCUSDEC830FF", mst);
        			for(Map item : ran) {
        				commonDAO.insert("dec.insertCUSDEC830_RANFF", item);
        			}
        			for(Map item : ranItem) {
        				commonDAO.insert("dec.insertCUSDEC830_RAN_ITEMFF", item);
        			}
                } 
            }
        }

        model.setCode("I00000017"); // 파일업로드 되었습니다.
        model.setData(retMap);

        return model;
	}
	
	/**
	  * 수출이행내역 조회
	  */
	public AjaxModel selectRunHis(AjaxModel model) throws Exception{
		Map<String, Object> modelParam = model.getData();
		Map<String, String> params = new HashMap<String, String>();
		params.put("expDclrNo", (String)modelParam.get("RPT_NO"));
		String xml = null;
		
		xml = CustomsOpenApi.getData("API002", params); // 수출신고번호별 수출이행 내역
		Document doc = Jsoup.parse(xml, "", Parser.xmlParser());
		Elements masters = doc.select("expDclrNoPrExpFfmnBrkdQryRsltVo");
		Elements detailList = doc.select("expDclrNoPrExpFfmnBrkdDtlQryRsltVo");

		Element master = null;
		if (masters.size() > 0) {
			master = masters.get(0);
		} else {
			return model;
		}

		modelParam.put("shpmPckUt"	, master.select("shpmPckUt").text());
		modelParam.put("mnurConm"	, master.select("mnurConm").text());
		modelParam.put("shpmCmplYn"	, master.select("shpmCmplYn").text());
		modelParam.put("acptDt"		, master.select("acptDt").text());
		modelParam.put("shpmWght"	, master.select("shpmWght").text());
		modelParam.put("exppnConm"	, master.select("exppnConm").text());
		modelParam.put("loadDtyTmlm", master.select("loadDtyTmlm").text());
		modelParam.put("expDclrNo"	, master.select("expDclrNo").text());
		modelParam.put("csclWght"	, master.select("csclWght").text());
		modelParam.put("shpmPckGcnt", master.select("shpmPckGcnt").text());
		modelParam.put("csclPckUt"	, master.select("csclPckUt").text());
		modelParam.put("csclPckGcnt", master.select("csclPckGcnt").text());
		model.setData(modelParam);
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> detail = null;
		for (Element element : detailList) {
			detail = new HashMap<String, Object>();
			detail.put("shpmPckUt"	, element.select("shpmPckUt").text());
			detail.put("tkofDt"		, element.select("tkofDt").text());
			detail.put("shpmPckGcnt", element.select("shpmPckGcnt").text());
			detail.put("blNo"		, element.select("blNo").text());
				
			list.add(detail);
		}
		model.setDataList(list);
		model.setTotal(list.size());
		
		return model;
	}
}