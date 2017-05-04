package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;

@Service
@SuppressWarnings({"rawtypes", "unchecked"})
public class StatusImpl extends OpenAPIService {
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());
	JSONParser jsonParser = new JSONParser(); 

	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("MallId"       		, new CheckInfo().setVARCHAR("35" 	, true));  //  M	VARCHAR(35)	몰ID
		docListChecker.put("SellerPartyId"      , new CheckInfo().setVARCHAR("35" 	, false)); //  O	VARCHAR(35)	판매자ID(몰)
		docListChecker.put("OrderNo"       		, new CheckInfo().setVARCHAR("50" 	, true));  //  M	VARCHAR(50)	주문번호
		docListChecker.put("DocumentTypeCode"   , new CheckInfo().setVARCHAR("3" 	, true));  //  M	VARCHAR(3)	요청문서(수출신고서 830, 수출취하/정정신고서 5AS)
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
		// 처리결과 파라리미터 
		Map<String, Object> outMap = new HashMap<String, Object>();
		if("5AS".equalsIgnoreCase((String)in.get("DocumentTypeCode"))){
			outMap = amendResultAPIInfo(in, out);
		}else{
			outMap = procExpReqAPIInfo(in, out);
		}

		out.put("OrderNo"			, in.get("OrderNo"));
		out.put("DocumentTypeCode"	, in.get("DocumentTypeCode")); 
		out.put("ExpDeclNo"			, outMap.get("ExpDeclNo"));
		out.put("ExpLicenceNo"		, outMap.get("ExpLicenceNo"));
		out.put("Status"			, outMap.get("Status"));
		out.put("ConfirmDateTime"	, outMap.get("ConfirmDateTime"));
		out.put("TotalDeclAmount"	, outMap.get("TotalDeclAmount"));
		out.put("ExchangeRate"		, outMap.get("ExchangeRate"));
		out.put("CancelApproveNo"	, outMap.get("CancelApproveNo"));
		out.put("Remark"			, outMap.get("Remark"));			
		out.put("ErrorDescription"	, outMap.get("ErrorDescription"));		
		String fulfillJsonString = (String) outMap.get("Fulfillment");
		if (fulfillJsonString != null && fulfillJsonString.isEmpty() == false) {
			try {
				JSONArray jsonParsedArr = (JSONArray)JSONValue.parseWithException(fulfillJsonString);
				out.put("Fulfillment", jsonParsedArr);
			} catch (Exception e) {
				out.put("Fulfillment", fulfillJsonString);
			}
		}
		// JSON문자열을 넘겨주는데, JSON포맷이면 JSONObject로 변환하여 넘겨준다.	
		String errorDetailJsonString = (String) outMap.get("ErrorDetail");
		if (errorDetailJsonString != null && errorDetailJsonString.isEmpty() == false) {
			try {
				JSONObject json = (JSONObject) jsonParser.parse(errorDetailJsonString);
				out.put("ErrorDetail", json);
			} catch (Exception e) {
				out.put("ErrorDetail", errorDetailJsonString);
			}
		}
	}
	
	/**
	 * 수출신고 정정/취하 결과정보 처리
	 * @param input
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object>  amendResultAPIInfo(Map<String, Object> in, Map<String, Object>  out) {
		// 입력필드 확인설정 MAP
		Map<String, Object> outMap = new HashMap<String, Object>();
		
		String errorMsg = "";
		String errorJSON = "";
		String rece = "";	//작성된 수출신고서의 결과수신상태
		String submitNumberID = "";
		String referenceID = "";
		
		String remark = "";
		String confirmDateTime = "";
		String approveNo = "";

		Map<String, Object> paramMap = new HashMap<String, Object>();
		try {
			//정보조회
			paramMap = new HashMap<String, Object>();
			paramMap.put("MALL_ID", (String)in.get("MallId"));
			paramMap.put("ORDER_ID", (String)in.get("OrderNo"));
			
			List<Map<String, Object>> reqRecords = dao.list("mod.selectAmendResultInfo", paramMap);

			if (reqRecords == null || reqRecords.size()==0)	{
				throw new BizException("요청건이 없음");
			}else{
				Map<String, Object> resultMap = (Map<String, Object>) reqRecords.get(0);
				errorMsg  	   = (String) resultMap.get("ERROR_DESC");
				errorJSON 	   = (String) resultMap.get("ERROR_JSON");
				rece   		   = (String) resultMap.get("RECE");
				submitNumberID = (String) resultMap.get("RPT_NO");
				referenceID    = (String) resultMap.get("RPT_NO");

				if("05".equals(rece)){	// 승인('AAA1003')
					confirmDateTime = (String) resultMap.get("DPT_DAY");
					approveNo = (String) resultMap.get("DPT_NO");
				}else if ("01".equals(rece)){	// 오류('AAA1003')
					//오류통보를 찾아서 오류내역을 에러내용으로 리턴
					paramMap = new HashMap<String, Object>();
					paramMap.put("RPT_NO", referenceID);
					List<Map<String, Object>> errRecords = dao.list("mod.selectGovcbrr20", paramMap);
					String errTxt = "";
					if (errRecords != null && errRecords.size()>0){
						Map<String, Object> errInfo = new HashMap<String, Object>();
						for (int i=0;i<errRecords.size();i++){
							errInfo = (Map<String, Object>) errRecords.get(i);
							errTxt += errInfo.get("ERR_REASON") + ", ";
						}
					}
					errorMsg = errorMsg + " " +errTxt;
				}
			}

		} catch (BizException be){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			errorMsg = be.getMessage();
		}
	
		outMap.put("ExpDeclNo"		, submitNumberID);
		outMap.put("ExpLicenceNo"	, referenceID);
		outMap.put("Status"			, rece);
		outMap.put("ConfirmDateTime", confirmDateTime);
		outMap.put("CancelApproveNo", approveNo);
		outMap.put("Remark"			, remark);
		outMap.put("ErrorDetail"	, errorJSON);
		outMap.put("ErrorDescription" , errorMsg);
		
		return outMap;
	}
	
	/**
	 * 수출신고요청 결과정보 처리
	 * @param input
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object>  procExpReqAPIInfo(Map<String, Object> in, Map<String, Object> out) {
		// 입력필드 확인설정 MAP
		Map<String, Object> outMap = new HashMap<String, Object>();
		
		String errorMsg = "";
		String errorJSON = "";
		String rece = "";	//작성된 수출신고서의 결과수신상태
		String submitNumberID = "";
		String referenceID = "";
		String remark = "";
		
		String fulfillDate = "";
		String confirmDateTime = "";
		String exchRate = "";
		String totDeclAmt = "";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		try {
			//정보조회
			paramMap = new HashMap<String, Object>();
			paramMap.put("MALL_ID", (String) in.get("MallId"));
			paramMap.put("ORDER_ID", (String) in.get("OrderNo"));
			
			List<Map<String, Object>> reqRecords = dao.list("mod.selectExpReqResultInfo", paramMap);
			if (reqRecords == null || reqRecords.size()==0)	{
				throw new BizException("요청건이 없음");
			}else{
				Map<String, Object>  resultMap = (Map<String, Object> ) reqRecords.get(0);
				errorMsg  = (String) (resultMap.get("ERROR_DESC") != null ? resultMap.get("ERROR_DESC") : "");
				errorJSON = (String) resultMap.get("ERROR_JSON");
				rece   = (String) resultMap.get("RECE");
				submitNumberID = (String) resultMap.get("RPT_NO");
				referenceID    = (String) resultMap.get("RPT_NO");

				if("03".equals(rece) || "14".equals(rece)){	// 수리('AAA1002')
					confirmDateTime = (String) resultMap.get("EXP_LIS_DT");
					totDeclAmt = resultMap.get("TOT_RPT_KRW").toString();
					exchRate = resultMap.get("EXC_RATE_CUR").toString();
					fulfillDate = (String) resultMap.get("FULFILLMENT");
					//fulfillDate = "BL번호 : "+StringUtil.null2Str(resultMap.get("BLNO")) +", 출항일자 : "+ StringUtil.null2Str(resultMap.get("LEAVE_DAY"));
				}else if ("01".equals(rece)){	// 오류('AAA1002')
					//오류통보를 찾아서 오류내역을 에러내용으로 리턴
					paramMap = new HashMap<String, Object>();
					paramMap.put("RPT_NO", submitNumberID);
					List<Map<String, Object>> errRecords = dao.list("mod.selectGovcbrr20", paramMap);
					String errTxt = "";
					if (errRecords!=null && errRecords.size()>0){
						Map<String, Object> errInfo = new HashMap<String, Object>();
						for (int i=0;i<errRecords.size();i++){
							errInfo = (Map<String, Object>)errRecords.get(i);
							errTxt += errInfo.get("ERR_REASON") + ", ";
						}
					}
					errorMsg = errorMsg + " " +errTxt;
				}
				
				if("02".equals(rece)||"07".equals(rece)||"08".equals(rece)||"09".equals(rece)||"10".equals(rece)){	// 접수('AAA1002')
					remark = "GOVCBRR73" +  "//" + resultMap.get("DPT_DTM") +  "//" + resultMap.get("RESULT_CD") +  "//" + resultMap.get("RESULT_TXT");
				}
			}

		} catch (BizException be){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			errorMsg = be.getMessage();
		}
	
		outMap.put("ExpDeclNo"		, submitNumberID);
		outMap.put("ExpLicenceNo"	, referenceID);
		outMap.put("Status"			, rece);
		outMap.put("ConfirmDateTime", confirmDateTime);
		outMap.put("TotalDeclAmount", totDeclAmt);
		outMap.put("ExchangeRate"	, exchRate);
		outMap.put("Fulfillment"	, fulfillDate);
		outMap.put("Remark"			, remark);
		outMap.put("ErrorDetail"	, errorJSON);
		outMap.put("ErrorDescription" , errorMsg);
		
		return outMap;
	}
}
