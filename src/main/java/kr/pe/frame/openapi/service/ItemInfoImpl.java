package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service()
@SuppressWarnings({"rawtypes"})
public class ItemInfoImpl extends OpenAPIService {
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
		
		docListChecker.put("MallId"         		, new CheckInfo().setVARCHAR("35" , true)); 	// 	M	VARCHAR(50)	몰ID	몰관리자가 회원가입 시 생성한 회원 User ID
		docListChecker.put("SellerPartyId"         	, new CheckInfo().setVARCHAR("35" , false)); 	//	O	VARCHAR(35)	판매자ID(몰)	몰에서 구분되는 판매자키
		docListChecker.put("SellerPartyRegistNo"    , new CheckInfo().setCODE(true, "openapi.codecheck.SellerUseBizNo"));	//	M	VARCHAR(10) 사업자등록번호	
		docListChecker.put("RequestType"         	, new CheckInfo().setVARCHAR("1" , true)); 		//	M	VARCHAR(1)	요청구분	N:U (신규/수정))
		docListChecker.put("ItemNo"         		, new CheckInfo().setVARCHAR("35" , true)); 	//	M	VARCHAR(35)	상품번호	
		docListChecker.put("GoodsDesc"         		, new CheckInfo().setVARCHAR("50" , true)); 	//	M	VARCHAR(50)	품명(영문품명)	
		docListChecker.put("HsCode"         		, new CheckInfo().setCODE(false, "openapi.codecheck.HsCode")); 			//	O	VARCHAR(10)	세번부호
		docListChecker.put("BrandName"         		, new CheckInfo().setVARCHAR("30" , true)); 	//	M	VARCHAR(30)	상표명	영문대문자(공백없이)
		docListChecker.put("OriginLocCode"         	, new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode")); 		//	M	VARCHAR(3)	원산지국가코드	원산지 국가의 IOS국가코드 2자리 없는 경우 “KR”
		docListChecker.put("Weight"         		, new CheckInfo().setNUMERIC("10,1" , true)); 	//	M	NUMERIC(10,1)	중량	
		docListChecker.put("WeightUnitCode"         , new CheckInfo().setVARCHAR("3" , true)); 		//	M	VARCHAR(3)	중량단위	
		docListChecker.put("QuantityUnitCode"       , new CheckInfo().setVARCHAR("3" , true)); 		//	M	VARCHAR(3)	수량단위	
		docListChecker.put("MakerName"         		, new CheckInfo().setVARCHAR("28" , false)); 	//	O	VARCHAR(28)	제조자상호	
		docListChecker.put("MakerCustomsId"         , new CheckInfo().setVARCHAR("15" , false)); 	//	O	VARCHAR(15)	제조자통관고유부호	
		docListChecker.put("MakerZipCode"         	, new CheckInfo().setVARCHAR("5" , false)); 	//	O	VARCHAR(5)	제조자우편번호	
		docListChecker.put("Specification"         	, new CheckInfo().setVARCHAR("500" , false)); 	//	O	VARCHAR(500)	규격	수출신고서 규격에 들어갈 규격기술
		docListChecker.put("Ingredients"         	, new CheckInfo().setVARCHAR("70" , false)); 	//	O	VARCHAR(70)	성분	수출신고서 성분에 들어갈 성분기술
		docListChecker.put("Category1"         		, new CheckInfo().setVARCHAR("100" , false)); 	//	O	VARCHAR(100)	카테고리1	몰에서 관리하는 상품의 카테고리명 상위. HS코드를 위한 참조항목
		docListChecker.put("Category2"         		, new CheckInfo().setVARCHAR("100" , false)); 	//	O	VARCHAR(100)	카테고리2	몰에서 관리하는 상품의 카테고리명 차상위
		docListChecker.put("Category3"         		, new CheckInfo().setVARCHAR("100" , false)); 	//	O	VARCHAR(100)	카테고리3	몰에서 관리하는 상품의 카테고리명 세번째
		docListChecker.put("SpecificationRemark"    , new CheckInfo().setVARCHAR("500" , false)); 	//	O	VARCHAR(500)	기타스펙	HS코드를 위한 참조항목
		docListChecker.put("ItemViewUrl"         	, new CheckInfo().setVARCHAR("500" , false)); 	//	O	VARCHAR2(500)	웹주소	상품 상세스펙을 조회할 수 있는 웹주소를 기재

		
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
			

		// 판매자사업자등록번호에서 '-', 양 끝 공백 제거
		String sSellerPartyRegistNo = (String) in.get("SellerPartyRegistNo");
		if (sSellerPartyRegistNo != null) {
			sSellerPartyRegistNo = sSellerPartyRegistNo.trim().replaceAll("-", "");
			in.put("SellerPartyRegistNo", sSellerPartyRegistNo);
		}

		try {
			
			//주어진 정보의 기존전송여부를 확인
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("MALL_ID"      , in.get("MallId")); 
			paramMap.put("BIZ_NO"       , in.get("SellerPartyRegistNo"));  
			paramMap.put("MALL_ITEM_NO" , in.get("ItemNo")); 
			
			List<Map<String, Object>> itemRecords = dao.list("openapi.dec.selectItemInfo", paramMap);

			boolean isExist = false;
			if (itemRecords != null && itemRecords.size() > 0)	{ 
				isExist = true; //update
			}
			
			String requestType = (String) in.get("RequestType");
			// N, U가 아닌 경우
			if(!"N".equalsIgnoreCase(requestType) && !"U".equalsIgnoreCase(requestType)){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "요청구분은 신규:N/수정:U 로 보내야 합니다. 요청구분="+requestType);
				return;
			}
			// N 인데, 동일 ID가 존재
			if ("N".equalsIgnoreCase(requestType) && isExist){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "상품정보등록 :해당 셀러의 상품은 이미 등록되어 있습니다. 정보를 수정하려면 요청구분을 'U' 로 요청하십시오");
				return;
			// U 인데, 동일 ID가 부재
			} else if ("U".equalsIgnoreCase(requestType) && !isExist){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "상품정보수정 :해당 셀러의 상품이 등록되어 있지 않습니다. 정보를 등록하려면 요청구분을 'N' 로 요청하십시오");
				return;
			}
			
			Map<String, Object> mainMap = null;
			if (isExist){
				mainMap = makeMain(in);
				mainMap.put("MOD_ID"	, 	in.get("MallId"));	//수정자ID
				dao.update("openapi.dec.updateItemInfo", mainMap);
			}else{
				
				mainMap = makeMain(in);
				mainMap.put("REG_ID"	, 	in.get("MallId"));	//등록자ID
				mainMap.put("MOD_ID"	, 	in.get("MallId"));	//수정자ID
				dao.insert("openapi.dec.insertItemInfo", mainMap);
			}
		
			out.put("MallId", in.get("MallId"));
			out.put("SellerPartyId", in.get("SellerPartyId"));
			out.put("ItemNo", in.get("ItemNo"));
		
			
		} catch (Exception e) {	
		
			out.put("MallId", in.get("MallId"));
			out.put("SellerPartyId", in.get("SellerPartyId"));
			out.put("ItemNo", in.get("ItemNo"));
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.INTERNAL_SERVER_ERROR.toString()); // HTTP status 코드를 넣어준다. 
			out.put(ERROR_DESCRIPTION	, e.getMessage());
			
		}
		
	}
	
	private Map<String, Object> makeMain(Map<String, Object> in){

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		mainMap.put("MALL_ID",               (String) in.get("MallId")              );   //몰ID
		mainMap.put("MALL_ITEM_NO",          (String) in.get("ItemNo")              );   //몰상품번호
		mainMap.put("BIZ_NO",                (String) in.get("SellerPartyRegistNo") );   //사업자등록번호
		mainMap.put("MALL_SELLER_ID",        (String) in.get("SellerPartyId")       );   //판매자몰ID
		mainMap.put("ITEM_NM",               (String) in.get("GoodsDesc")           );   //품명
		mainMap.put("HS_CD",                 (String) in.get("HsCode")              );   //세번부호
		mainMap.put("BRAND_NM",              (String) in.get("BrandName")           );   //상표명
		mainMap.put("ORG_NAT_CD",            (String) in.get("OriginLocCode")       );   //원산지국가코드
		mainMap.put("WEIGHT",                (String) in.get("Weight")              );   //중량
		mainMap.put("WEIGHT_UT",             (String) in.get("WeightUnitCode")      );   //중량단위
		mainMap.put("QUANTY_UT",             (String) in.get("QuantityUnitCode")    );   //수량단위
		mainMap.put("MAKER_NM",              (String) in.get("MakerName")           );   //제조자
		mainMap.put("MAKER_TGNO",            (String) in.get("MakerCustomsId")      );   //제조자통관고유부호
		mainMap.put("MAKER_POST_NO",         (String) in.get("MakerZipCode")        );   //제조자우편번호
		mainMap.put("GNM",                   (String) in.get("Specification")       );   //규격
		mainMap.put("INGREDIENTS",           (String) in.get("Ingredients")         );   //성분
		mainMap.put("EXPORT_DEC",             ""           );   						 //수출신고여부
		mainMap.put("CATEGORY1",             (String) in.get("Category1")           );   //카테고리1
		mainMap.put("CATEGORY2",             (String) in.get("Category2")           );   //카테고리2
		mainMap.put("CATEGORY3",             (String) in.get("Category3")           );   //카테고리3
		mainMap.put("SPEC_DETAIL",           (String) in.get("SpecificationRemark") );   //상세스펙
		mainMap.put("ITEM_VIEW_URL",         (String) in.get("ItemViewUrl") 		);   //상품 URL
		mainMap.put("REGIST_METHOD",         "API" 		);   							 //등록방법

		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}

}
