package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service()
@SuppressWarnings({"rawtypes"})
public class OrderListImpl extends OpenAPIService {
	@Resource(name = "commonDAO")
	private CommonDAO commonDAO;
	
	@Resource(name = "declarationService")
    private DeclarationImpl declaration;
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("MallId"    					, new CheckInfo().setVARCHAR("35"	, true));	//	M	VARCHAR(35) 몰ID
		docListChecker.put("SellerPartyId"    			, new CheckInfo().setVARCHAR("35"	, false));	//	O	VARCHAR(35) 판매자ID(몰)
		docListChecker.put("OrderNo"    				, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50) 주문번호
		docListChecker.put("AutoDeclaration"    		, new CheckInfo().setCODE(true, "openapi.codecheck.Yn"));	//	M	VARCHAR(1) 자동전송여부 Y/N( 디폴트 Y)
		docListChecker.put("RequestType"    			, new CheckInfo().setVARCHAR("1"	, true));	//	M	VARCHAR(1) 요청구분
		docListChecker.put("PaymentAmount"    			, new CheckInfo().setNUMERIC("15,2"	, true));	//	M	NUMERIC(15,2) 결제금액
		docListChecker.put("PaymentCurrencyCode"    	, new CheckInfo().setCODE(true, "openapi.codecheck.CurrencyCode"));	//	M	VARCHAR(3) 결제통화코드
		docListChecker.put("DestinationCountryCode"   	, new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode"));	//	M	VARCHAR(3) 목적국 국가코드
		docListChecker.put("BuyerPartyEngName"    		, new CheckInfo().setVARCHAR("26"	, true));	//	M	VARCHAR(26) 구매자상호명
		docListChecker.put("SellerPartyRegistNo"    	, new CheckInfo().setCODE(true, "openapi.codecheck.SellerUseBizNo"));	//	M	VARCHAR(10) 판매자사업자등록번호
		docListChecker.put("TotalPackageQuantity"    	, new CheckInfo().setNUMERIC("6"	, true));	//	M	NUMERIC(6) 총포장갯수
		docListChecker.put("TotalPackageWeight"    		, new CheckInfo().setNUMERIC("11,1"	, true));	//	M	NUMERIC(11,1) 총중량
		
		CheckInfo items = new CheckInfo().setLIST(true);
		Map itemsChecker = items.getSubCheckers();
		docListChecker.put("Items", items);
		
		itemsChecker.put("ItemNo"    					, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50) 몰상품ID,몰에서 사용되는 품목 키
		itemsChecker.put("OriginLocCode"    			, new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode"));		//	O	VARCHAR(2) 판매물품원산지국가코드
		itemsChecker.put("NetWeight"    				, new CheckInfo().setNUMERIC("10,1"	, false));	//	O	NUMERIC(10,1) 포장용기제외순중량
		itemsChecker.put("Quantity"    					, new CheckInfo().setNUMERIC("10"	, true));	//	O	NUMERIC(10) HS표준수량단위 수량 => 물품수량
		itemsChecker.put("QuantityUnitCode"    			, new CheckInfo().setCODE(false));				//	O	VARCHAR(3) HS표준수량단위 => 물품수량단위
		itemsChecker.put("BrandName"    				, new CheckInfo().setVARCHAR("30"	, false));	//	O	VARCHAR(30) 영문상표명
		itemsChecker.put("GoodsDesc"    				, new CheckInfo().setVARCHAR("50"	, false));	//	O	VARCHAR(50) 거래품명(영문)
		itemsChecker.put("HSCode"    					, new CheckInfo().setCODE(false, "openapi.codecheck.HsCode"));			//	O	VARCHAR(10) HS부호
		itemsChecker.put("PackageQuantity"    			, new CheckInfo().setNUMERIC("8"	, false));	//	O	NUMERIC(8) 포장개수
		itemsChecker.put("PackageUnitCode"    			, new CheckInfo().setCODE(false));				//	O	VARCHAR(2)	포장단위
		itemsChecker.put("DeclarationPrice"    			, new CheckInfo().setNUMERIC("17,2"	, true));	//	M	NUMERIC(17,2) 가격
		itemsChecker.put("UnitPrice"    				, new CheckInfo().setNUMERIC("17,2"	, true));	//	O	NUMERIC(17,2) 단가
		itemsChecker.put("DeclPriceCurrencyCode"    	, new CheckInfo().setCODE(false, "openapi.codecheck.CurrencyCode"));	//	O	VARCHAR(3) 통화
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
			
		int ord = 0;
		// 판매자사업자등록번호에서 '-', 양 끝 공백 제거
		String sSellerPartyRegistNo = (String) in.get("SellerPartyRegistNo");
		if (sSellerPartyRegistNo != null) {
			sSellerPartyRegistNo = sSellerPartyRegistNo.trim().replaceAll("-", "");
			in.put("SellerPartyRegistNo", sSellerPartyRegistNo);
		}
		
		try {
			//수출신고요청 호출
			declaration.doProcess(in, out);
			out.put("MallId"			, in.get("MallId"));
			out.put("SellerPartyId"		, in.get("SellerPartyId"));
			out.put("OrderNo"			, in.get("OrderNo"));
			out.put("OrgSeq"			, ord); // 원본에서 해당 건이 차지하는 순번
		
		} catch (Exception e) {
			
			out.put("MallId"			, in.get("MallId"));
			out.put("SellerPartyId"		, in.get("SellerPartyId"));
			out.put("OrderNo"			, in.get("OrderNo"));
			out.put("OrgSeq"			, ord); // 원본에서 해당 건이 차지하는 순번
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.INTERNAL_SERVER_ERROR.toString()); // HTTP status 코드를 넣어준다.
			out.put(ERROR_DESCRIPTION	, e.getMessage());
			
		}
		
		ord++;
	}

}
