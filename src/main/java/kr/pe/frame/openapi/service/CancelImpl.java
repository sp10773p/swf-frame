package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("cancelService")
@SuppressWarnings({"rawtypes"})
public class CancelImpl extends OpenAPIService {
	@Resource(name = "amendService")
    private AmendImpl amendService;
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("MallId"       				, new CheckInfo().setVARCHAR("35" 	, true));  	//  M	VARCHAR(35)	몰ID
		docListChecker.put("SellerPartyId"       		, new CheckInfo().setVARCHAR("35" 	, false)); 	//  O	VARCHAR(35)	판매자ID(몰)
		docListChecker.put("SellerPartyRegistNo"       	, new CheckInfo().setVARCHAR("10" 	, true));  	//  M	VARCHAR(10)	판매자 사업자등록번호
		docListChecker.put("OrderNo"       				, new CheckInfo().setVARCHAR("50" 	, true));  	//  M	VARCHAR(50)	주문번호
		docListChecker.put("RequestType"       			, new CheckInfo().setVARCHAR("1" 	, true));  	//  M	VARCHAR(1)	요청구분구분
		docListChecker.put("ApplicationType"       		, new CheckInfo().setCODE(true));  				//  M	VARCHAR(1)	신청구분=고정
		docListChecker.put("AmendReasonCode"       		, new CheckInfo().setCODE(true));  				//  M	VARCHAR(2)	취하사유코드
		docListChecker.put("ReasonsAttributableCode"    , new CheckInfo().setCODE(true));  				//  M	VARCHAR(1)	귀책사유코드
		docListChecker.put("AmendReason"       			, new CheckInfo().setVARCHAR("200"  , true));  	//  M	VARCHAR(200)정정사유
		docListChecker.put("ExportDeclarationNo"       	, new CheckInfo().setVARCHAR("15" 	, true));  	//  M	VARCHAR(15)	수출신고번호
		docListChecker.put("AmendItemNo"       			, new CheckInfo().setVARCHAR("18"   , false)); 	//  O	INTEGER		정정항목수
		docListChecker.put("CustomsCode"       			, new CheckInfo().setCODE(false)); 				//  O	VARCHAR(3)	세관
		docListChecker.put("CustomsDeptCode"       		, new CheckInfo().setCODE(false)); 				//  O	VARCHAR(2)	과
		docListChecker.put("ApplicationDate"       		, new CheckInfo().setVARCHAR("8" 	, false)); 	//  O	VARCHAR(8)	신고일자
		docListChecker.put("ApplicationPartyCeoName"    , new CheckInfo().setVARCHAR("12" 	, false)); 	//  O	VARCHAR(12)	신고자대표자명
		docListChecker.put("ApplicationCompanyName"     , new CheckInfo().setVARCHAR("28" 	, false)); 	//  O	VARCHAR(28)	신고자상호
		docListChecker.put("ExportPartyName"       		, new CheckInfo().setVARCHAR("28" 	, false)); 	//  O	VARCHAR(28)	수출자성명
		docListChecker.put("ExportPartyCustomsId"       , new CheckInfo().setVARCHAR("15" 	, false)); 	//  O	VARCHAR(15)	수출자통관고유부호
		docListChecker.put("ExportPartyDeclarationId"   , new CheckInfo().setCODE(false, "openapi.codecheck.SellerUseApplicantID")); //  O	VARCHAR(5)	판매자신고인부호
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
			
		if(!"B".equals(in.get("ApplicationType"))){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "[ApplicationType]을 'B'로 요청하세요");
			return;
		}
		
		// 판매자사업자등록번호에서 '-', 양 끝 공백 제거
		String sSellerPartyRegistNo = (String) in.get("SellerPartyRegistNo");
		if (sSellerPartyRegistNo != null) {
			sSellerPartyRegistNo = sSellerPartyRegistNo.trim().replaceAll("-", "");
			in.put("SellerPartyRegistNo", sSellerPartyRegistNo);
		}
		
		
		try {
			amendService.doProcess(in, out);
			out.put("MallId", in.get("MallId"));
			out.put("SellerPartyId", in.get("SellerPartyId"));
			out.put("OrderNo", in.get("OrderNo"));
			
			
		} catch (Exception e) {
			out.put("MallId"			, in.get("MallId"));
			out.put("SellerPartyId"		, in.get("SellerPartyId"));
			out.put("OrderNo"			, in.get("OrderNo"));
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.INTERNAL_SERVER_ERROR.toString()); // HTTP status 코드를 넣어준다. 
			out.put(ERROR_DESCRIPTION	, e.getMessage());
			
		}
		
	}

	
}
