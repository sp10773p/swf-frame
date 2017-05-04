package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service()
@SuppressWarnings({"rawtypes"})
public class ExpInfoImpl extends OpenAPIService {
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("SellerPartyId"    			, new CheckInfo().setVARCHAR("35"	, false));	//	O	VARCHAR(35)
		docListChecker.put("OrderNo"    				, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50) 신청문서	: 주문번호 or 운송장번호를 기재
		docListChecker.put("DocumentTypeCode"    		, new CheckInfo().setVARCHAR("3"	, true));	//	M	VARCHAR(1)  신청문서구분 :	주문번호 A, 운송장번호 B
		
		return checkers;
	}
	
	/**
	 * 수출신고 정보조회
	 */
	@Override
	public void doProcess(Map in, Map out) {
			
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ORDER_ID", in.get("OrderNo"));
		List<Map<String, Object>> decList = dao.list("openapi.dec.selectDec830List", paramMap);
		if(decList.size() <= 0){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "조회된 수출신고 정보가 없습니다.");
			
			return;
		}
		
		//기본
		out.put("OrderNo", in.get("OrderNo"));
		out.put("RequestNo", "");
		
		
		//Main
		Map outMain = new HashMap();
		out.put("ExportInfo", outMain);
		Map<String, Object> mainMap = null;
		for (int i=0; i<decList.size();i++){
			mainMap = (Map<String, Object>) decList.get(i);
		
			outMain.put("ExportDeclarationNo"       , mainMap.get("RPT_NO")); //	M	VARCHAR2(15)	제출번호(PK)
			outMain.put("ApplicationCompanyName"    , mainMap.get("RPT_FIRM")); //	M	VARCHAR2(50)	신고자상호
			outMain.put("ApplicationId"         	, mainMap.get("RPT_MARK")); //	M	VARCHAR2(5)	신고자부호
			outMain.put("ApplicationPartyCeoName"   , mainMap.get("RPT_BOSS_NM")); //	M	VARCHAR2(12)	신고자대표자
			outMain.put("AgencyCompanyName"         , mainMap.get("COMM_FIRM")); //	M	VARCHAR2(28)	수출대행자 상호
			outMain.put("AgencyCustomsId"         	, mainMap.get("COMM_TGNO")); //	O	VARCHAR2(15)	수출대행자통관부호
			outMain.put("ExportPartyTypeCode"       , mainMap.get("EXP_DIVI")); //	M	VARCHAR2(1)	수출자구분
			outMain.put("ExportPartyCompanyName"    , mainMap.get("EXP_FIRM")); //	M	VARCHAR2(28)	수출화주 상호
			outMain.put("ExportPartyCeoName"        , mainMap.get("EXP_BOSS_NAME")); //	M	VARCHAR2(12)	수출화주 대표자성명
			outMain.put("ExportPartyAddress"        , mainMap.get("EXP_ADDR1")); //	M	VARCHAR2(150)	수출화주주소1
			outMain.put("ExportPartyRegistNo"       , mainMap.get("EXP_SDNO")); //	M	VARCHAR2(13)	수출화주사업자번호
			outMain.put("ExportPartyCustomsId"      , mainMap.get("EXP_TGNO")); //	O	VARCHAR2(15)	수출화주통관부호
			outMain.put("ExportPartyZipCode"        , mainMap.get("EXP_POST")); //	M	VARCHAR2(5)	수출화주 소재지우편번호
			outMain.put("MakerName"         		, mainMap.get("MAK_FIRM")); //	M	VARCHAR2(28)	제조자상호
			outMain.put("MakerCustomsId"         	, mainMap.get("MAK_TGNO")); //	O	VARCHAR2(15)	제조자통관부호
			outMain.put("MakerZipCode"         		, mainMap.get("MAK_POST")); //	M	VARCHAR2(5)	제조자지역코드
			outMain.put("ManufactureLocCode"        , mainMap.get("INLOCALCD")); //	O	VARCHAR2(3)	제조장소산업단지부호
			outMain.put("BuyerPartyEngName"         , mainMap.get("BUY_FIRM")); //	M	VARCHAR2(60)	해외거래처구매자상호
			outMain.put("BuyerPartyId"         		, mainMap.get("BUY_MARK")); //	O	VARCHAR2(13)	해외거래처구매자부호
			outMain.put("CustomsCode"         		, mainMap.get("RPT_CUS")); //	O	VARCHAR2(3)	신고세관
			outMain.put("CustomsDeptCode"         	, mainMap.get("RPT_SEC")); //	O	VARCHAR2(2)	신고세관과부호
			outMain.put("DeclarationDate"         	, mainMap.get("RPT_DAY")); //	O	VARCHAR2(8)	신고일자
			outMain.put("DeclarationType"         	, mainMap.get("RPT_DIVI")); //	M	VARCHAR2(1)	수출신고구분
			outMain.put("TransactionType"         	, mainMap.get("EXC_DIVI")); //	M	VARCHAR2(3)	수출거래구분
			outMain.put("ExportType"         		, mainMap.get("EXP_KI")); //	O	VARCHAR2(1)	수출종류
			outMain.put("PaymentTypeCode"         	, mainMap.get("CON_MET")); //	M	VARCHAR2(2)	결제방법
			outMain.put("DestinationCountryCode"    , mainMap.get("TA_ST_ISO")); //	M	VARCHAR2(2)	목적국국가코드
			outMain.put("LoadingLocPortCode"        , mainMap.get("FOD_CODE")); //	M	VARCHAR2(5)	적재항코드
			outMain.put("LoadingLocPortType"        , mainMap.get("ARR_MARK")); //	M	VARCHAR2(3)	적재항 구분코드
			outMain.put("TransportMeansCode"        , mainMap.get("TRA_MET")); //	O	VARCHAR2(2)	운송형태
			outMain.put("TransportCaseCode"         , mainMap.get("TRA_CTA")); //	O	VARCHAR2(3)	운송용기
			outMain.put("DepartureScheduledDate"    , mainMap.get("MAK_FIN_DAY")); //	O	VARCHAR2(8)	검사희망일
			outMain.put("GoodsLocZipCode"         	, mainMap.get("GDS_POST")); //	M	VARCHAR2(5)	물품소재지우편번호
			outMain.put("GoodsLocAddress"         	, mainMap.get("GDS_ADDR1")); //	M	VARCHAR2(70)	물품소재지주소1
			outMain.put("LcNo"         				, mainMap.get("LCNO")); //	O	VARCHAR2(20)	L/C번호
			outMain.put("GoodsUsedCode"         	, mainMap.get("USED_DIVI")); //	O	VARCHAR2(1)	물품상태구분코드
			outMain.put("StatementCode"         	, mainMap.get("UP5AC_DIVI")); //	O	VARCHAR2(1)	사전임시개청신청여부
			outMain.put("ReturnReasonCode"         	, mainMap.get("BAN_DIVI")); //	O	VARCHAR2(2)	반송사유부호
			outMain.put("RefundCode"         		, mainMap.get("REF_DIVI")); //	O	VARCHAR2(1)	환급신청자구분
			outMain.put("CustomsTaxRefundRequest"   , mainMap.get("RET_DIVI")); //	M	VARCHAR2(2)	간이환급신청구분
			outMain.put("ReturnScopeCode"         	, mainMap.get("MRN_DIVI")); //	O	VARCHAR2(1)	화물관리번호전송여부
			outMain.put("ContainerIndicator"        , mainMap.get("CONT_IN_GBN")); //	O	VARCHAR2(1)	컨테이너적입여부
			outMain.put("TotalPackageWeight"        , mainMap.get("TOT_WT")); //	M	NUMBER(16, 3)	총중량
			outMain.put("TotalPackageWeightUnitCode", mainMap.get("UT")); //	M	VARCHAR2(3)	총중량단위
			outMain.put("TotalPackageQuantity"      , mainMap.get("TOT_PACK_CNT")); //	M	NUMBER(6)	총포장수
			outMain.put("TotalPackageUnitCode"      , mainMap.get("TOT_PACK_UT")); //	M	VARCHAR2(3)	총포장수단위
			outMain.put("TotalDeclAmountKRW"        , mainMap.get("TOT_RPT_KRW")); //	M	NUMBER(15)	총신고금액원화
			outMain.put("TotalDeclAmountUSD"        , mainMap.get("TOT_RPT_USD")); //		NUMBER(12)	총신고금액미화
			outMain.put("FreightAmount"         	, mainMap.get("FRE_KRW")); //	O	NUMBER(12)	운임금액원화
			outMain.put("InsuranceAmount"         	, mainMap.get("INSU_KRW")); //	O	NUMBER(12)	보험금액원화
			outMain.put("DeliveryTermsCode"         , mainMap.get("AMT_COD")); //	M	VARCHAR2(3)	인도조건
			outMain.put("PaymentCurrencyCode"       , mainMap.get("CUR")); //	M	VARCHAR2(3)	결제통화
			outMain.put("PaymentAmount"         	, mainMap.get("AMT")); //	M	NUMBER(18, 2)	결제금액
			outMain.put("USDExchangeRate"         	, mainMap.get("EXC_RATE_USD")); //	O	NUMBER(9, 4)	미화환율
			outMain.put("PaymentExchangeRate"       , mainMap.get("EXC_RATE_CUR")); //	O	NUMBER(9, 4)	결제환율
			outMain.put("BondedTransportName"       , mainMap.get("BOSE_RPT_FIRM")); //	O	VARCHAR2(30)	보세운송인명
			outMain.put("BondedTransportStartDate"  , mainMap.get("BOSE_RPT_DAY1")); //	O	VARCHAR2(8)	보세운송기간시작
			outMain.put("BondedTransportEndDate"    , mainMap.get("BOSE_RPT_DAY2")); //	O	VARCHAR2(8)	보세운송기간종료
			outMain.put("LicenseDate"         		, mainMap.get("EXP_LIS_DAY")); //		VARCHAR2(8)	수리일자
			outMain.put("LoadingTermDate"         	, mainMap.get("JUK_DAY")); //		VARCHAR2(8)	적재의무기한
			outMain.put("FunctionCode"         		, mainMap.get("SEND_DIVI")); //	O	VARCHAR2(2)	송신구분
			outMain.put("ResponseTypeCode"         	, mainMap.get("RES_YN")); //	M	VARCHAR2(2)	응답형태
			outMain.put("TotalRan"         			, mainMap.get("TOT_RAN")); //	M	NUMBER(3)	총란수
			outMain.put("ApplicationNotice"         , mainMap.get("RPT_USG")); //	O	VARCHAR2(500)	신고인기재란
			outMain.put("CustomerNotice"         	, mainMap.get("CUS_NOTICE")); //		VARCHAR2(500)	세관기재란
			outMain.put("IdentificationID"         	, mainMap.get("GS_CHK")); //	O	VARCHAR2(2)	개성공단반입구분
			outMain.put("TradeIndicatorCode"        , mainMap.get("SN_DIVI")); //	O	VARCHAR2(1)	남북교역 과세,비과세구분
			outMain.put("AuthenticatorId"         	, mainMap.get("JU_MARK")); //		VARCHAR2(6)	심사담당자 직원부호
			outMain.put("AuthenticatorName"         , mainMap.get("JU_NAME")); //		VARCHAR2(12)	심사담당자 성명
			outMain.put("CarrierCompanyId"         	, mainMap.get("SHIP_CODE")); //	O	VARCHAR2(4)	선사부호
			outMain.put("CarrierCompanyName"        , mainMap.get("SHIP_CO")); //	O	VARCHAR2(25)	선사명
			outMain.put("CarrierName"         		, mainMap.get("SHIP_NAME")); //	O	VARCHAR2(35)	선박명편명
			outMain.put("FinalTransportPlaceCode"   , mainMap.get("CHK_PA_MARK")); //	O	VARCHAR2(8)	적재예정보세구역
			outMain.put("EstimatedDepartureDate"    , mainMap.get("PLAN_SHIP_DAY")); //	O	VARCHAR2(8)	출항예정일
			outMain.put("GoodsLocationCode"         , mainMap.get("WARE_MARK")); //	O	VARCHAR2(8)	반입장치장부호
			outMain.put("ImportBaseNo"         		, mainMap.get("IN_BASIS_NO")); //	O	VARCHAR2(15)	반입근거번호
			outMain.put("CargoControlNo"         	, mainMap.get("MRN_NO")); //	O	VARCHAR2(19)	화물관리번호
			
			//수출신고  란 정보 조회
			paramMap = new HashMap<String, Object>();
			paramMap.put("RPT_NO", mainMap.get("RPT_NO"));
			paramMap.put("RPT_SEQ", "00");
			List<Map<String, Object>> decRanList = dao.list("dec.selectDecRanList", paramMap);
			
			//Ran
			Map outRans = new HashMap();
			outMain.put("RanList", outRans);
			Map<String, Object> ranMap = null;
			for (int j=0; j<decRanList.size();j++){
				ranMap = (Map<String, Object>) decRanList.get(i);
				
				outRans.put("RanNo"      			, ranMap.get("RAN_NO"));        //		M	VARCHAR2(3)	란번호(PK)
				outRans.put("HSCode"      			, ranMap.get("HS"));            //		M	VARCHAR2(10)	세번부호
				outRans.put("HSGoodsDesc"      		, ranMap.get("STD_GNM"));       //		M	VARCHAR2(50)	표준품명
				outRans.put("GoodsDesc"      		, ranMap.get("EXC_GNM"));       //		M	VARCHAR2(50)	거래품명
				outRans.put("InvoiceNo"      		, ranMap.get("MG_CODE"));       //		O	VARCHAR2(17)	송품장부호
				outRans.put("BrandName"      		, ranMap.get("MODEL_GNM"));     //		O	VARCHAR2(30)	상표명
				outRans.put("DeclAmount1"      		, ranMap.get("RPT_KRW"));       //		M	NUMBER(18)	신고가격원화
				outRans.put("DeclAmount2"      		, ranMap.get("RPT_USD"));       //		O	NUMBER(12)	신고가격미화
				outRans.put("NetWeight"      		, ranMap.get("SUN_WT"));       	//		M	NUMBER(16, 3)	순중량
				outRans.put("NetWeightUnitCode"     , ranMap.get("SUN_UT"));        //		M	VARCHAR2(3)	순중량단위
				outRans.put("Quantity"      		, ranMap.get("WT"));           	//		O	NUMBER(10)	수량
				outRans.put("QuantityUnitCode"      , ranMap.get("UT"));            //		O	VARCHAR2(3)	수량단위
				outRans.put("ImportDeclarationNo"   , ranMap.get("IMP_RPT_SEND"));  //		O	VARCHAR2(15)	수입신고번호
				outRans.put("ImportDeclarationRanNo", ranMap.get("IMP_RAN_NO"));    //		O	VARCHAR2(3)	수입 란번호
				outRans.put("PackageQuantity"      	, ranMap.get("PACK_CNT"));      //		O	NUMBER(10)	포장갯수
				outRans.put("PackageUnitCode"      	, ranMap.get("PACK_UT"));       //		O	VARCHAR2(2)	포장단위
				outRans.put("OriginCountryCode"     , ranMap.get("ORI_ST_MARK1"));  //		M	VARCHAR2(2)	원산지국가부호
				outRans.put("OriginMarkCode1"      	, ranMap.get("ORI_ST_MARK2"));  //		O	VARCHAR2(1)	수출원산결정기준
				outRans.put("OriginMarkCode2"      	, ranMap.get("ORI_ST_MARK3"));  //		O	VARCHAR2(1)	수출원산표시여부
				outRans.put("OriginMarkCode3"      	, ranMap.get("ORI_FTA_YN"));    //		O	VARCHAR2(1)	원산지 자율발급 여부
				outRans.put("AttachYN"      		, ranMap.get("ATT_YN"));        //		M	VARCHAR2(1)	첨부여부  
				
				//수출신고  모델 정보 조회
				paramMap = new HashMap<String, Object>();
				paramMap.put("RPT_NO", mainMap.get("RPT_NO"));
				paramMap.put("RPT_SEQ", "00");
				paramMap.put("RAN_NO" , ranMap.get("RAN_NO"));
				List<Map<String, Object>> decModelList = dao.list("dec.selectDecModelList", paramMap);
				
				//Model
				Map outModels = new HashMap();
				outRans.put("ItemList", outModels);
				Map<String, Object> modelMap = null;
				for (int k=0; k<decModelList.size(); k++){
					modelMap = (Map<String, Object>) decModelList.get(k);
				
					outModels.put("ItemNo"         		, modelMap.get("SIL"));       //	M	VARCHAR2(2)	규격일련번호
					outModels.put("ItemCode"         	, modelMap.get("MG_CD"));	  //	O	VARCHAR2(50)	제품코드
					outModels.put("GoodsName"         	, modelMap.get("GNM"));       //	M	VARCHAR2(300)	모델규격
					outModels.put("Component"         	, modelMap.get("COMP"));      //	O	VARCHAR2(70)	성분
					outModels.put("ItemQuantity"        , modelMap.get("QTY"));       //	C	NUMBER(14, 4)	수량
					outModels.put("ItemQuantityUnitCode", modelMap.get("QTY_UT"));    //	C	VARCHAR2(3)	수량단위
					outModels.put("UnitPrice"         	, modelMap.get("PRICE"));     //	M	NUMBER(18, 6)	단가
					outModels.put("Amount"         		, modelMap.get("AMT"));       //	M	NUMBER(16, 4)	금액

				}
				
			}
		}
	}
	
	
}
