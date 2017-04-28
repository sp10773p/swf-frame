package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.CustomsOpenApi;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;

@Service()
@SuppressWarnings({"rawtypes"})
public class ExpFulfillmentStatusImpl extends OpenAPIService {
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("MallId"    					, new CheckInfo().setVARCHAR("35"	, true));	//	M	VARCHAR(35)
		docListChecker.put("SellerPartyId"    			, new CheckInfo().setVARCHAR("35"	, false));	//	O	VARCHAR(35)
		docListChecker.put("InquiryNo"    				, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50)
		docListChecker.put("InquiryTypeCode"    		, new CheckInfo().setVARCHAR("3"	, true));	//	M	VARCHAR(1)
		
		return checkers;
	}
	
	/**
	 * 수출이행내역 요청
	 */
	@Override
	public void doProcess(Map in, Map out) {
			
		int ord=0;
		if(ord > 0){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
			out.put(ERROR_DESCRIPTION	, "2개 이상의 조회번호(InquiryNo)로 요청할 수 없습니다.");
		}
		
		JSONArray resDataArray = new JSONArray();
		try {
			Map<String, String> params = new HashMap<String, String>();
			
			if(((String)in.get("InquiryTypeCode")).equals("BL")) {
				params.put("blNo", (String)in.get("InquiryNo"));
				
				String xml = null;
				try {
					xml = CustomsOpenApi.getData("API002", params); // 수출신고번호별 수출이행 내역
				} catch (Exception e) {
					out.put(RESULT_TYPE_CODE	, ResultTypeCode.NO_ERROR.toString());
					out.put(ERROR_DESCRIPTION	, "B/L 번호 [" + in.get("InquiryNo") + "] 관세청 연결 오류");
					out.put("MallId"			, in.get("MallId"));
					out.put("SellerPartyId"		, in.get("SellerPartyId"));
					out.put("OrgSeq"			, ord); 						// 원본에서 해당 건이 차지하는 순번
					out.put("BlNo"				, in.get("InquiryNo"));
					out.put("InquiryTypeCode"	, in.get("InquiryTypeCode"));
					out.put("status"			, "CNER"); 						// CNER : 관세청 연결 오류
					
					return;
					
				}
				Document doc = Jsoup.parse(xml, "", Parser.xmlParser());
				Elements masters = doc.select("expDclrNoPrExpFfmnBrkdBlNoQryRsltVo");
				
				Element master = null;
				if (masters.size() <= 0) {
					out.put(RESULT_TYPE_CODE	, ResultTypeCode.NO_ERROR.toString());
					out.put(ERROR_DESCRIPTION	, "B/L 번호 [" + in.get("InquiryNo") + "] 이행내역 부재");
					out.put("MallId"			, in.get("MallId"));
					out.put("SellerPartyId"		, in.get("SellerPartyId"));
					out.put("BlNo"				, in.get("InquiryNo"));
					out.put("OrgSeq"			, ord); // 원본에서 해당 건이 차지하는 순번
					out.put("InquiryTypeCode"	, in.get("InquiryTypeCode"));
					out.put("status"			, "NORS"); // NORS : 결과없음
					
					return;
				}
				
				master = masters.get(0);				
				
				/*
				out.put("MallId", in.get("MallId"));
				out.put("SellerPartyId", in.get("SellerPartyId"));
				out.put("OrgSeq", ord); // 원본에서 해당 건이 차지하는 순번
				*/
				
				out.put("BlNo"				, in.get("InquiryNo"));
				out.put("InquiryTypeCode"	, in.get("InquiryTypeCode"));
				out.put("status"			,  "FFRS");	// FFRS : 이행결과
				
				// 관세청 데이타
				out.put("ShipmentIndicator"							,  master.select("shpmcmplYn").text());
				out.put("ExportDeclarationNo"						,  master.select("expDclrNo").text());
				out.put("ConfirmDate"								,  master.select("acptDt").text());
				out.put("ExporterCompanyName"						,  master.select("exppnConm").text());
				out.put("CustomsClearancePackageQuantityUnitCode"	,  master.select("csclPckUt").text());
				out.put("CustomsClearancePackageQuantity"			,  master.select("csclPckGcnt").text());
				out.put("CustomsClearanceWeight"					,  master.select("csclWght").text());
				out.put("DepartureDate"								,  master.select("tkofDt").text());				
				out.put("PortOfLoadingName"							,  master.select("shpmAirptPortNm").text());
				out.put("ShipmentPackageQuantity"					,  master.select("shpmPckGcnt").text());
				out.put("ShipmentWeight"							,  master.select("shpmWght").text());
				out.put("DivideWithdraw"							,  master.select("dvdeWdrw").text());		
				
			} else if (((String)in.get("InquiryTypeCode")).equals("EPN")) {
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
				out.put(ERROR_DESCRIPTION	, "수출신고번호를 통한 수출이행내역 조회는 향후에 개발될 예정입니다.");
				
			} else {
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
				out.put(ERROR_DESCRIPTION	, "알수 없는 조회유형코드(InquiryTypeCode)입니다.");
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.put("MallId"			, in.get("MallId"));
			out.put("SellerPartyId"		, in.get("SellerPartyId"));
			out.put("BlNo"				, in.get("InquiryNo"));
			out.put("OrgSeq"			, ord); // 원본에서 해당 건이 차지하는 순번
			out.put("InquiryTypeCode"	, in.get("InquiryTypeCode"));
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.INTERNAL_SERVER_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, e.getMessage());
		
		}
		
		ord++;
	}
	
	
}
