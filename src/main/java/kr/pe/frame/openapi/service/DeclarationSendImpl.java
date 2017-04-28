package kr.pe.frame.openapi.service;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DateUtil;
import kr.pe.frame.exp.dec.service.DecService;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.edi.service.EdiService;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.exp.req.controller.ExpDecReqValidator;

@Service
@SuppressWarnings({"rawtypes"})
public class DeclarationSendImpl extends OpenAPIService {
	@Resource(name = "decService")
    private DecService decService;
	
	@Resource(name = "ediService")
    private EdiService ediService;
	 
	Logger logger = LoggerFactory.getLogger(this.getClass());
	private static Pattern PTRN_ENG_SPC_ETC = Pattern.compile("[a-zA-Z.,-[ ]]+"); // 영문, 공백, '.', ',', '-'
	private static Pattern PTRN_ENG_NUM_SPC_ETC = Pattern.compile("[a-zA-Z0-9\\p{Punct} \\t&&[^<>&]]+"); // 영문, 숫자, 공백(탭 포함), 특수문자('<', '>', '&' 제외)
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("SellerPartyId"         		, new CheckInfo().setVARCHAR("35" 	, true)); 	//	M	VARCHAR(35)		판매자ID(몰)
		docListChecker.put("OrderNo"         			, new CheckInfo().setVARCHAR("50" 	, true)); 	//	M	VARCHAR(50)		주문번호
		docListChecker.put("AutoDeclaration"        	, new CheckInfo().setCODE(true, "openapi.codecheck.Yn")); 					//	M	VARCHAR(1)		자동전송여부 Y/N( 디폴트 Y)
		docListChecker.put("RequestType"         		, new CheckInfo().setVARCHAR("1" 	, true)); 	//	M	VARCHAR(1)		요청구분 
		docListChecker.put("ApplicationCompanyName" 	, new CheckInfo().setVARCHAR("50" 	, true)); 	//	M	VARCHAR2(50)	신고자상호
		docListChecker.put("ApplicationId"          	, new CheckInfo().setCODE(true, "openapi.codecheck.SellerUseApplicantID")); //	M	VARCHAR2(5)		신고자부호
		docListChecker.put("ApplicationPartyCeoName"    , new CheckInfo().setVARCHAR("12" 	, true)); 	//	M	VARCHAR2(12)	신고자대표자
		docListChecker.put("AgencyCompanyName"         	, new CheckInfo().setVARCHAR("28" 	, true)); 	//	M	VARCHAR2(28)	수출대행자 상호
		docListChecker.put("AgencyCustomsId"         	, new CheckInfo().setVARCHAR("15" 	, false)); 	//	O	VARCHAR2(15)	수출대행자통관부호
		docListChecker.put("ExportPartyTypeCode"        , new CheckInfo().setCODE(false)); 				//	M	VARCHAR2(1)		수출자구분
		docListChecker.put("ExportPartyCompanyName"     , new CheckInfo().setVARCHAR("28" 	, true)); 	//	M	VARCHAR2(28)	수출화주 상호
		docListChecker.put("ExportPartyCeoName"         , new CheckInfo().setVARCHAR("12" 	, true)); 	//	M	VARCHAR2(12)	수출화주 대표자성명
		docListChecker.put("ExportPartyAddress"         , new CheckInfo().setVARCHAR("150" 	, true)); 	//	M	VARCHAR2(150)	수출화주주소1
		docListChecker.put("ExportPartyRegistNo"        , new CheckInfo().setVARCHAR("13" 	, true)); 	//	M	VARCHAR2(13)	수출화주사업자번호
		docListChecker.put("ExportPartyCustomsId"       , new CheckInfo().setVARCHAR("15" 	, false)); 	//	O	VARCHAR2(15)	수출화주통관부호
		docListChecker.put("ExportPartyZipCode"         , new CheckInfo().setVARCHAR("5" 	, true)); 	//	M	VARCHAR2(5)		수출화주 소재지우편번호
		docListChecker.put("MakerName"         			, new CheckInfo().setVARCHAR("28" 	, true)); 	//	M	VARCHAR2(28)	제조자상호
		docListChecker.put("MakerCustomsId"         	, new CheckInfo().setVARCHAR("15" 	, false)); 	//	O	VARCHAR2(15)	제조자통관부호
		docListChecker.put("MakerZipCode"         		, new CheckInfo().setVARCHAR("5" 	, true)); 	//	M	VARCHAR2(5)		제조자지역코드
		docListChecker.put("ManufactureLocCode"         , new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(3)		제조장소산업단지부호
		docListChecker.put("BuyerPartyEngName"         	, new CheckInfo().setVARCHAR("60" 	, true)); 	//	M	VARCHAR2(60)	해외거래처구매자상호
		docListChecker.put("BuyerPartyId"         		, new CheckInfo().setVARCHAR("13" 	, false)); 	//	O	VARCHAR2(13)	해외거래처구매자부호
		docListChecker.put("CustomsCode"         		, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(3)		신고세관
		docListChecker.put("CustomsDeptCode"         	, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(2)		신고세관과부호
		docListChecker.put("DeclarationDate"         	, new CheckInfo().setVARCHAR("8" 	, true)); 	//	M	VARCHAR2(8)		신고일자
		docListChecker.put("DeclarationType"         	, new CheckInfo().setCODE(true, "openapi.codecheck.ExpDeclarationType")); 	//	M	VARCHAR2(1)		수출신고구분
		docListChecker.put("TransactionType"         	, new CheckInfo().setCODE(true, "openapi.codecheck.ExpTransactionType")); 	//	M	VARCHAR2(3)		수출거래구분
		docListChecker.put("ExportType"         		, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(1)		수출종류
		docListChecker.put("PaymentTypeCode"         	, new CheckInfo().setCODE(true)); 				//	M	VARCHAR2(2)		결제방법
		docListChecker.put("DestinationCountryCode"     , new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode")); 			//	M	VARCHAR2(2)		목적국국가코드
		docListChecker.put("LoadingLocPortCode"         , new CheckInfo().setCODE(true, "openapi.codecheck.PortCode")); 			//	M	VARCHAR2(5)		적재항코드
		docListChecker.put("LoadingLocPortType"         , new CheckInfo().setCODE(true, "openapi.codecheck.TransportMeansCode")); 	//	M	VARCHAR2(3)		적재항 구분코드
		docListChecker.put("TransportMeansCode"         , new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(2)		운송형태
		docListChecker.put("TransportCaseCode"         	, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(3)		운송용기
		docListChecker.put("DepartureScheduledDate"     , new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		검사희망일
		docListChecker.put("GoodsLocZipCode"         	, new CheckInfo().setVARCHAR("5" 	, true)); 	//	M	VARCHAR2(5)		물품소재지우편번호
		docListChecker.put("GoodsLocAddress"         	, new CheckInfo().setVARCHAR("70" 	, true)); 	//	M	VARCHAR2(70)	물품소재지주소1
		docListChecker.put("LcNo"         				, new CheckInfo().setVARCHAR("20" 	, false)); 	//	O	VARCHAR2(20)	L/C번호
		docListChecker.put("GoodsUsedCode"         		, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(1)		물품상태구분코드
		docListChecker.put("StatementCode"         		, new CheckInfo().setVARCHAR("1" 	, false)); 	//	O	VARCHAR2(1)		사전임시개청신청여부
		docListChecker.put("ReturnReasonCode"         	, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(2)		반송사유부호
		docListChecker.put("RefundCode"         		, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(1)		환급신청자구분
		docListChecker.put("CustomsTaxRefundRequest"    , new CheckInfo().setCODE(true)); 				//	M	VARCHAR2(2)		간이환급신청구분
		docListChecker.put("ReturnScopeCode"         	, new CheckInfo().setCODE(false, "openapi.codecheck.Yn")); 					//	O	VARCHAR2(1)		화물관리번호전송여부
		docListChecker.put("ContainerIndicator"         , new CheckInfo().setCODE(false, "openapi.codecheck.Yn")); 					//	O	VARCHAR2(1)		컨테이너적입여부
		docListChecker.put("TotalPackageWeight"         , new CheckInfo().setNUMERIC("16,3" , true)); 	//	M	NUMBER(16, 3)	총중량
		docListChecker.put("TotalPackageWeightUnitCode" , new CheckInfo().setCODE(true, "openapi.codecheck.QuantityUnitCode")); 	//	M	VARCHAR2(3)		총중량단위
		docListChecker.put("TotalPackageQuantity"       , new CheckInfo().setNUMERIC("6" 	, true)); 	//	M	NUMBER(6)		총포장수
		docListChecker.put("TotalPackageUnitCode"       , new CheckInfo().setCODE(true, "openapi.codecheck.PackageUnitCode2")); 	//	M	VARCHAR2(3)		총포장수단위
		docListChecker.put("TotalDeclAmountKRW"         , new CheckInfo().setNUMERIC("15" 	, true)); 	//	M	NUMBER(15)		총신고금액원화
		docListChecker.put("TotalDeclAmountUSD"         , new CheckInfo().setNUMERIC("12" 	, false)); 	//	O	NUMBER(12)		총신고금액미화
		docListChecker.put("FreightAmount"         		, new CheckInfo().setNUMERIC("12" 	, false)); 	//	O	NUMBER(12)		운임금액원화
		docListChecker.put("InsuranceAmount"         	, new CheckInfo().setNUMERIC("12" 	, false)); 	//	O	NUMBER(12)		보험금액원화
		docListChecker.put("DeliveryTermsCode"         	, new CheckInfo().setCODE(true)); 				//	M	VARCHAR2(3)		인도조건
		docListChecker.put("PaymentCurrencyCode"        , new CheckInfo().setCODE(true, "openapi.codecheck.CurrencyCode")); 		//	M	VARCHAR2(3)		결제통화
		docListChecker.put("PaymentAmount"         		, new CheckInfo().setNUMERIC("18,2" , true)); 	//	M	NUMBER(18, 2)	결제금액
		docListChecker.put("USDExchangeRate"         	, new CheckInfo().setNUMERIC("9,4" 	, false)); 	//	O	NUMBER(9, 4)	미화환율
		docListChecker.put("PaymentExchangeRate"        , new CheckInfo().setNUMERIC("9,4" 	, false)); 	//	O	NUMBER(9, 4)	결제환율
		docListChecker.put("BondedTransportName"        , new CheckInfo().setVARCHAR("30" 	, false)); 	//	O	VARCHAR2(30)	보세운송인명
		docListChecker.put("BondedTransportStartDate"   , new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		보세운송기간시작
		docListChecker.put("BondedTransportEndDate"     , new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		보세운송기간종료
		docListChecker.put("FunctionCode"         		, new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(2)		송신구분
		docListChecker.put("ResponseTypeCode"         	, new CheckInfo().setCODE(true)); 				//	M	VARCHAR2(2)		응답형태
		docListChecker.put("TotalRan"         			, new CheckInfo().setNUMERIC("3" 	, true)); 	//	M	NUMBER(3)		총란수
		docListChecker.put("ApplicationNotice"         	, new CheckInfo().setVARCHAR("500" 	, false)); 	//	O	VARCHAR2(500)	신고인기재란
		docListChecker.put("IdentificationID"         	, new CheckInfo().setVARCHAR("2" 	, false)); 	//	O	VARCHAR2(2)		개성공단반입구분
		docListChecker.put("TradeIndicatorCode"         , new CheckInfo().setCODE(false)); 				//	O	VARCHAR2(1)		남북교역 과세,비과세구분
		docListChecker.put("CarrierCompanyId"         	, new CheckInfo().setVARCHAR("4" 	, false)); 	//	O	VARCHAR2(4)		선사부호
		docListChecker.put("CarrierCompanyName"         , new CheckInfo().setVARCHAR("25" 	, false)); 	//	O	VARCHAR2(25)	선사명
		docListChecker.put("CarrierName"         		, new CheckInfo().setVARCHAR("35" 	, false)); 	//	O	VARCHAR2(35)	선박명편명
		docListChecker.put("FinalTransportPlaceCode"    , new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		적재예정보세구역
		docListChecker.put("EstimatedDepartureDate"     , new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		출항예정일
		docListChecker.put("GoodsLocationCode"         	, new CheckInfo().setVARCHAR("8" 	, false)); 	//	O	VARCHAR2(8)		반입장치장부호
		docListChecker.put("ImportBaseNo"         		, new CheckInfo().setVARCHAR("15" 	, false)); 	//	O	VARCHAR2(15)	반입근거번호
		docListChecker.put("CargoControlNo"         	, new CheckInfo().setVARCHAR("19" 	, false)); 	//	O	VARCHAR2(19)	화물관리번호

		CheckInfo ranList = new CheckInfo().setLIST(true);
		Map ranListChecker = ranList.getSubCheckers();
		docListChecker.put("RanList", ranList);
		
		ranListChecker.put("RanNo"         				, new CheckInfo().setVARCHAR("3" 	, true)); 	//		M	VARCHAR2(3)		란번호(PK)
		ranListChecker.put("HSCode"         			, new CheckInfo().setCODE(true, "openapi.codecheck.HsCode")); 				//		M	VARCHAR2(10)	세번부호
		ranListChecker.put("HSGoodsDesc"        		, new CheckInfo().setVARCHAR("50" 	, true)); 	//		M	VARCHAR2(50)	표준품명
		ranListChecker.put("GoodsDesc"         			, new CheckInfo().setVARCHAR("50" 	, true)); 	//		M	VARCHAR2(50)	거래품명
		ranListChecker.put("InvoiceNo"         			, new CheckInfo().setVARCHAR("17" 	, false)); 	//		O	VARCHAR2(17)	송품장부호
		ranListChecker.put("BrandName"         			, new CheckInfo().setVARCHAR("30" 	, false)); 	//		O	VARCHAR2(30)	상표명
		ranListChecker.put("DeclAmount1"        		, new CheckInfo().setNUMERIC("18" 	, true)); 	//		M	NUMBER(18)		신고가격원화
		ranListChecker.put("DeclAmount2"        		, new CheckInfo().setNUMERIC("12" 	, false)); 	//		O	NUMBER(12)		신고가격미화
		ranListChecker.put("NetWeight"         			, new CheckInfo().setNUMERIC("16,3" , true)); 	//		M	NUMBER(16, 3)	순중량
		ranListChecker.put("NetWeightUnitCode"  		, new CheckInfo().setCODE(true, "openapi.codecheck.QuantityUnitCode")); 	//		M	VARCHAR2(3)		순중량단위
		ranListChecker.put("Quantity"         			, new CheckInfo().setNUMERIC("10" 	, false)); 	//		O	NUMBER(10)		수량
		ranListChecker.put("QuantityUnitCode"       	, new CheckInfo().setCODE(false, "openapi.codecheck.PackageUnitCode2")); 	//		O	VARCHAR2(3)		수량단위
		ranListChecker.put("ImportDeclarationNo"    	, new CheckInfo().setVARCHAR("15" 	, false)); 	//		O	VARCHAR2(15)	수입신고번호
		ranListChecker.put("ImportDeclarationRanNo" 	, new CheckInfo().setVARCHAR("3" 	, false)); 	//		O	VARCHAR2(3)		수입 란번호
		ranListChecker.put("PackageQuantity"        	, new CheckInfo().setNUMERIC("10" 	, false)); 	//		O	NUMBER(10)		포장갯수
		ranListChecker.put("PackageUnitCode"        	, new CheckInfo().setCODE(false)); 				//		O	VARCHAR2(2)		포장단위
		ranListChecker.put("OriginCountryCode"      	, new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode")); 			//		M	VARCHAR2(2)		원산지국가부호
		ranListChecker.put("OriginMarkCode1"        	, new CheckInfo().setVARCHAR("1" 	, false)); //		O	VARCHAR2(1)		수출원산결정기준
		ranListChecker.put("OriginMarkCode2"        	, new CheckInfo().setVARCHAR("1" 	, false)); //		O	VARCHAR2(1)		수출원산표시여부
		ranListChecker.put("OriginMarkCode3"        	, new CheckInfo().setVARCHAR("1" 	, false)); //		O	VARCHAR2(1)		원산지 자율발급 여부
		ranListChecker.put("AttachYN"         			, new CheckInfo().setCODE(true, "openapi.codecheck.Yn")); 					//		M	VARCHAR2(1)		첨부여부
		
		CheckInfo items = new CheckInfo().setLIST(true);
		Map itemsChecker = items.getSubCheckers();
		ranListChecker.put("ItemList", items);
		
		itemsChecker.put("ItemNo"         				, new CheckInfo().setVARCHAR("2" 	, true)); 	//	M	VARCHAR2(2)		규격일련번호
		itemsChecker.put("ItemCode"         			, new CheckInfo().setVARCHAR("50" 	, false)); 	//	O	VARCHAR2(50)	제품코드
		itemsChecker.put("GoodsName"         			, new CheckInfo().setVARCHAR("300" 	, true)); 	//	M	VARCHAR2(300)	모델규격
		itemsChecker.put("Component"         			, new CheckInfo().setVARCHAR("70" 	, false)); 	//	O	VARCHAR2(70)	성분
		itemsChecker.put("ItemQuantity"         		, new CheckInfo().setNUMERIC("14,4" , true)); 	//	O	NUMBER(14, 4)	수량
		itemsChecker.put("ItemQuantityUnitCode"         , new CheckInfo().setCODE(false, "openapi.codecheck.PackageUnitCode2")); //	O	VARCHAR2(3)		수량단위
		itemsChecker.put("UnitPrice"         			, new CheckInfo().setNUMERIC("18,6" , true)); 	//	M	NUMBER(18, 6)	단가
		itemsChecker.put("Amount"         				, new CheckInfo().setNUMERIC("16,4" , true)); 	//	M	NUMBER(16, 4)	금액
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
			
		String reqNo = "";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		//주어진 정보의 기존전송여부를 확인
		paramMap = new HashMap<String, Object>();
		paramMap.put("SELLER_ID" , in.get("SellerPartyId"));
		paramMap.put("ORDER_ID"  , in.get("OrderNo"));
		
		Map<String, Object> befReq = (Map<String, Object>) dao.select("dec.selectDecDetail", paramMap);
		String befStatus = "";
		boolean isExist = false;
		if (MapUtils.isNotEmpty(befReq)) {
			befStatus = (String) befReq.get("RECE");
			isExist = true;
		}
		//수신상태가 '01'(오류)인 건은 다시 작성할수 있음
		if (!StringUtil.isEmpty(befStatus) && !"01".equals(befStatus)){
			
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "이미 신고(서 작성)된 주문건임");
			return;
		}
		
		//물품소재지 우편번호와 세관, 과 부호 적합성 여부 검토
		if(!"".equals(StringUtil.null2Str((String) in.get("GoodsLocZipCode")))){
			String pCus = StringUtil.null2Str((String) in.get("CustomsCode"));		//세관코드
			String pSec = StringUtil.null2Str((String) in.get("CustomsDeptCode"));	//과코드
			paramMap = new HashMap<String, Object>();
			paramMap.put("POST_NO", in.get("GoodsLocZipCode"));
			Map<String, Object> zipInfo  = (Map<String, Object>) dao.select("openapi.dec.selectPostCus", paramMap);
			if(MapUtils.isEmpty(zipInfo)){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "물품소재지 우편번호(GoodsLocZipCode) 가 정확하지 않습니다.");
				return;
			}
			if(!pCus.equals(zipInfo.get("CUS"))){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "물품소재지 우편번호에 따른 세관코드(CustomsCode)가 정확하지 않습니다. ["+zipInfo.get("CUS")+"] 으로 다시 요청하세요");
				return;
			}
			if(!pSec.equals(zipInfo.get("SEC"))){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "물품소재지 우편번호에 따른 과코드(CustomsDeptCode)가 정확하지 않습니다. ["+zipInfo.get("SEC")+"] 으로 다시 요청하세요");
				return;
			}
		}
		//구매자상호명 영문체크
		if (!PTRN_ENG_SPC_ETC.matcher((CharSequence) in.get("BuyerPartyEngName")).matches()) {
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "[BuyerPartyEngName]에는,  '영문, 공백, 특수문자('.', ',', '-')만 가능합니다.");
			return;
		}
		
		// 결제금액 200만원 이하 인지 체크
		Map<String, Object> map = new HashMap<String, Object>();
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		map.put("APPLY_DATE", exchangeBaseDate);
		map.put("NATION", in.get("PaymentCurrencyCode"));
		map.put("IMPORT_EXPORT", "E");
       
        String exRateStr = (String)dao.select("dec.selectExchangeRate", map);	//환율정보
        if (StringUtils.isEmpty(exRateStr)){
        	out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "환율정보가 없습니다.");
			return;
        }
        
        double exRate = Double.valueOf(exRateStr).doubleValue();
        double rsAmt = 0;
        double payAmt = 0;
        if(in.get("PaymentAmount") instanceof String){
        	payAmt = Double.parseDouble((String) in.get("PaymentAmount"));
        }else if(in.get("PaymentAmount") instanceof Integer){
        	payAmt = (int) in.get("PaymentAmount");
        }else if(in.get("PaymentAmount") instanceof Float){
        	payAmt = Double.parseDouble(String.valueOf(in.get("PaymentAmount")));
        }else if(in.get("PaymentAmount") instanceof Double){
        	payAmt = ((Double) in.get("PaymentAmount")).doubleValue();
        }
        rsAmt = exRate * payAmt;
        if (Math.round(rsAmt) > 2000000){
        	out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "신고금액(원화)은 200만원을 초과할 수 없습니다. [예상신고 원화금액: "+Math.round(rsAmt)+"]");
			return;
        }
        
        
        //동일한 주문 번호의 합계(주문수량 * 가격) 와 결제금액은 동일해야 한다.
        List<Map<String, Object>>  ranList = (List<Map<String, Object>>) in.get("RanList");
        Map<String, Object> inRan = new HashMap<String, Object>() ;
		String errMsg = "";
		String errMsgItem = "";
		double sumItem = 0;
		for (int i=0;i<ranList.size();i++){
			inRan = (Map<String, Object>) ranList.get(i);
			
	        //영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inRan.get("HSGoodsDesc")).matches()) {
				errMsg = "[HSGoodsDesc]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
			}
			//영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inRan.get("GoodsDesc")).matches()) {
				errMsg = "[GoodsDesc]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
			}
			
			//영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inRan.get("BrandName")).matches()) {
				errMsg = "[BrandName]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
			}
			
			List<Map<String, Object>>  itemList = (List<Map<String, Object>>) inRan.get("ItemList");
			Map<String, Object> inItem = new HashMap<String, Object>() ;
			for (int j=0;j<itemList.size();j++){
				inItem = (Map<String, Object>) itemList.get(i);
				if(inItem.get("UnitPrice") instanceof String){
					sumItem += Double.parseDouble((String) inItem.get("UnitPrice")) * Integer.parseInt(getStringValue(inItem.get("ItemQuantity")));
				}else if(inItem.get("UnitPrice") instanceof Integer){
					sumItem += (int) inItem.get("UnitPrice") * Integer.parseInt(getStringValue(inItem.get("ItemQuantity")));
				}else if(inItem.get("UnitPrice") instanceof Float){
					sumItem += Double.parseDouble(String.valueOf(inItem.get("UnitPrice"))) * Integer.parseInt(getStringValue(inItem.get("ItemQuantity")));
				}else if(inItem.get("UnitPrice") instanceof Double){
					sumItem += ((Double) inItem.get("UnitPrice")).doubleValue() * Integer.parseInt(getStringValue(inItem.get("ItemQuantity")));
				}
				
				//영문,공백,'-' 문자사용여부 체크
				if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem.get("GoodsName")).matches()) {
					errMsgItem = "[GoodsName]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
				}
				//영문,공백,'-' 문자사용여부 체크
				if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem.get("Component")).matches()) {
					errMsgItem = "[Component]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
				}
			}
		}
		String sPatten = "#####.##";
		DecimalFormat dFormat = new DecimalFormat(sPatten);
		String sumItemStr = dFormat.format(sumItem);
		String payAmtStr = dFormat.format(payAmt);
		if(!sumItemStr.equals(payAmtStr)){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "동일한 주문 번호의 합계(주문수량 * 단가)와 결제금액은 동일해야 합니다. [ 결제금액("+payAmtStr+") , 합계금액("+sumItemStr+") ]");
			return;
		}
		
		if(!errMsg.equals("")){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, errMsg);
			return;
		}
		
		if(!errMsgItem.equals("")){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, errMsgItem);
			return;
		}
		
		
		String  amtCod = in.get("DeliveryTermsCode") instanceof String ? (String) in.get("DeliveryTermsCode") : String.valueOf((int) in.get("DeliveryTermsCode"));	//인도조건
		String  freKrw = in.get("FreightAmount") instanceof String ? (String) in.get("FreightAmount") : String.valueOf((int) in.get("FreightAmount"));				//운임원화
		String  insuKrw = in.get("InsuranceAmount") instanceof String ? (String) in.get("InsuranceAmount") : String.valueOf((int) in.get("InsuranceAmount"));	 	//보험료원화
		try {
			ExpDecReqValidator.isValidAmtCodInsuFre(amtCod, freKrw, insuKrw, "인도조건별 금액체크");
		} catch (Exception e) {
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, e.getMessage());
			return;
		}
        
		//신고일자 확인(오늘일자가 아니면 오류)
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String sToday = formatter.format(new Date());
		sToday = sToday.substring(0, 8);
		if(!sToday.equals(in.get("DeclarationDate"))){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, "신고일자가 오늘날짜가 아닙니다. [DeclarationDate : "+in.get("DeclarationDate")+"]");
			return;
		}
        
		
		in.put("APPLICANTPARTYORGID"    , in.get("ApplicationId"));
		String rptNo = decService.makeRptNo(in, "830");
		
		in.put("REGIST_METHOD"    , "API");
		in.put("RPT_NO"    , rptNo);
		reqNo = saveExpInfo(in);
		
		//수출신고 전송
		paramMap.put("USER_ID" , in.get("SellerPartyId"));
		paramMap.put("TYPE"     , "ECC");
		Map<String, Object> IdenInfo = (Map<String, Object>) dao.select("dec.selectCmmIdentifier", paramMap);
		
		if (MapUtils.isEmpty(IdenInfo)) {
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, in.get("SellerPartyId")+"에 해당하는 식별자 정보가 없습니다.");
			return;
		}
				
		
		in.put("REQ_KEY", rptNo);
		in.put("SNDR_ID", IdenInfo.get("IDENTIFY_ID"));
		in.put("RECP_ID", "KCS4G001");
		in.put("DOC_TYPE", "GOVCBR830");
		
		AjaxModel model = new AjaxModel();
		List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();   
		paramList.add(in);
		model.setDataList(paramList);
		try {
			ediService.sendDoc(model);
		} catch (BizException e) {
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, e);
			return;
		}
		
		out.put("SellerPartyId", in.get("SellerPartyId"));
		out.put("OrderNo", in.get("OrderNo"));
		out.put("RequestNo", reqNo);
		
	}
	
	private String saveExpInfo(Map in) {
		String reqNo = "";
		Map<String, Object> mainMap = null;
	
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		reqNo = formatter.format(new Date())+"_"+in.get("OrderNo");
		
		mainMap = makeMain(in);
		mainMap.put("REQ_NO",    reqNo);					//요청관리번호
		mainMap.put("REG_ID", 	 in.get("SellerPartyId"));	//등록자ID
		mainMap.put("MOD_ID", 	 in.get("SellerPartyId"));	//수정자ID
		
		dao.insert("openapi.dec.insertCUSDEC830", mainMap);
				

		List<Map<String, Object>>  ranList = (List<Map<String, Object>>) in.get("RanList");
		Map<String, Object> inRan = new HashMap<String, Object>() ;
		for (int i=0;i<ranList.size();i++){
			inRan = (Map<String, Object>) ranList.get(i);
			
			inRan = makeRan(inRan);
			inRan.put("RPT_NO",        in.get("RPT_NO"));     		//제출번호
			inRan.put("RPT_SEQ",       "00");     					//제출차수
			inRan.put("REG_ID"	, 	   in.get("SellerPartyId"));	//등록자ID
			inRan.put("MOD_ID"	, 	   in.get("SellerPartyId"));	//등록자ID
			
			dao.insert("openapi.dec.insertCUSDEC830_RAN", inRan);
			
			List<Map<String, Object>>  itemList = (List<Map<String, Object>>) inRan.get("ItemList");
			Map<String, Object> inItem = new HashMap<String, Object>() ;
			for (int j=0;j<itemList.size();j++){
				inItem = (Map<String, Object>) itemList.get(j);
				
				inItem = makeItem(inItem);
				inItem.put("RPT_NO",        in.get("RPT_NO"));     		//제출번호
				inItem.put("RPT_SEQ",       "00");     					//제출차수
				inItem.put("RAN_NO",       inRan.get("RAN_NO"));     	//란번호
				inItem.put("REG_ID"	, 	   in.get("SellerPartyId"));	//등록자ID
				inItem.put("MOD_ID"	, 	   in.get("SellerPartyId"));	//등록자ID
				
				dao.insert("openapi.dec.insertCUSDEC830_MODEL", inItem);
				
			}
			
		}
		return reqNo;
	}
	
	private Map<String, Object> makeMain(Map<String, Object> in){

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();

		mainMap.put("RPT_NO",               in.get("RPT_NO"));     					//제출번호
		mainMap.put("RPT_SEQ",              "00");     								//제출차수
		mainMap.put("SEND",                 "01");     								//전송 (01:등록, 02:전송중, 03: 전송완료 [AAA1001] )
		mainMap.put("RECE",                 "");     								//수신
		mainMap.put("ORDER_ID",             in.get("OrderNo"));     				//주문번호
		mainMap.put("RPT_FIRM",             in.get("ApplicationCompanyName"));     	//신고자상호
		mainMap.put("RPT_MARK",             in.get("ApplicationId"));     			//신고자부호		
		mainMap.put("RPT_BOSS_NM",          in.get("ApplicationPartyCeoName"));    	//신고자대표자
		mainMap.put("COMM_FIRM",            in.get("AgencyCompanyName"));     		//수출대행자상호
		mainMap.put("COMM_TGNO",            in.get("AgencyCustomsId"));     		//수출대행자통관부호
		mainMap.put("EXP_DIVI",             in.get("ExportPartyTypeCode"));     	//수출자구분
		mainMap.put("EXP_FIRM",             in.get("ExportPartyCompanyName"));     	//수출화주상호
		mainMap.put("EXP_BOSS_NAME",        in.get("ExportPartyCeoName"));     		//수출화주대표자성명
		mainMap.put("EXP_ADDR1",            in.get("ExportPartyAddress"));     		//수출화주주소1
		mainMap.put("EXP_SDNO",             in.get("ExportPartyRegistNo"));     	//수출화주사업자번호
		mainMap.put("EXP_SDNO_DIVI",        "04");     								//수출화주사업자번호구분
		mainMap.put("EXP_TGNO",             in.get("ExportPartyCustomsId"));     	//수출화주통관부호
		mainMap.put("EXP_POST",             in.get("ExportPartyZipCode"));     		//수출화주소재지우편번호
		mainMap.put("MAK_FIRM",             in.get("MakerName"));     				//제조자상호
		mainMap.put("MAK_TGNO",             in.get("MakerCustomsId"));     			//제조자통관부호
		mainMap.put("MAK_POST",             in.get("MakerZipCode"));     			//제조자지역코드
		mainMap.put("INLOCALCD",            in.get("ManufactureLocCode"));     		//제조장소산업단지부호
		mainMap.put("BUY_FIRM",             in.get("BuyerPartyEngName"));     		//해외거래처구매자상호
		mainMap.put("BUY_MARK",             in.get("BuyerPartyId"));     			//해외거래처구매자부호
		mainMap.put("RPT_CUS",              in.get("CustomsCode"));     			//신고세관
		mainMap.put("RPT_SEC",              in.get("CustomsDeptCode"));     		//신고세관과부호
		mainMap.put("RPT_DAY",              in.get("DeclarationDate"));     		//신고일자
		mainMap.put("RPT_DIVI",             in.get("DeclarationType"));     		//수출신고구분
		mainMap.put("EXC_DIVI",             in.get("TransactionType"));     		//수출거래구분
		mainMap.put("EXP_KI",               in.get("ExportType"));     				//수출종류
		mainMap.put("CON_MET",              in.get("PaymentTypeCode"));     		//결제방법
		mainMap.put("TA_ST_ISO",            in.get("DestinationCountryCode"));     	//목적국국가코드
		mainMap.put("FOD_CODE",             in.get("LoadingLocPortCode"));     		//적재항코드
		mainMap.put("ARR_MARK",             in.get("LoadingLocPortType"));   		//적재항구분코드
		mainMap.put("TRA_MET",              in.get("TransportMeansCode"));     		//운송형태
		mainMap.put("TRA_CTA",              in.get("TransportCaseCode"));     		//운송용기
		mainMap.put("MAK_FIN_DAY",          in.get("DepartureScheduledDate"));     	//검사희망일
		mainMap.put("GDS_POST",             in.get("GoodsLocZipCode"));     		//물품소재지우편번호
		mainMap.put("GDS_ADDR1",            in.get("GoodsLocAddress"));     		//물품소재지주소1
		mainMap.put("LCNO",            		in.get("LcNo"));     					//L/C번호
		mainMap.put("USED_DIVI",            in.get("GoodsUsedCode"));     			//물품상태구분코드
		mainMap.put("UP5AC_DIVI",           in.get("StatementCode"));     			//사전임시개청신청여부
		mainMap.put("BAN_DIVI",            	in.get("ReturnReasonCode"));     		//반송사유부호
		mainMap.put("REF_DIVI",            	in.get("RefundCode"));     				//환급신청자구분
		mainMap.put("RET_DIVI",             in.get("CustomsTaxRefundRequest"));     //간이환급신청구분
		mainMap.put("MRN_DIVI",            	in.get("ReturnScopeCode"));     		//화물관리번호전송여부
		mainMap.put("CONT_IN_GBN",          in.get("ContainerIndicator"));     		//컨테이너적입여부
		mainMap.put("TOT_WT",               in.get("TotalPackageWeight"));     		//총중량
		mainMap.put("UT",                   in.get("TotalPackageWeightUnitCode"));  //총중량단위
		mainMap.put("TOT_PACK_CNT",         in.get("TotalPackageQuantity"));     	//총포장수
		mainMap.put("TOT_PACK_UT",          in.get("TotalPackageUnitCode"));   		//총포장수단위
		mainMap.put("TOT_RPT_KRW",          in.get("TotalDeclAmountKRW"));     		//총신고금액원화
		mainMap.put("TOT_RPT_USD",          in.get("TotalDeclAmountUSD"));     		//총신고금액미화
		mainMap.put("FRE_KRW",              in.get("FreightAmount"));     			//운임금액원화
		mainMap.put("INSU_KRW",             in.get("InsuranceAmount"));     		//보험금액원화
		mainMap.put("AMT_COD",              in.get("DeliveryTermsCode"));     		//인도조건
		mainMap.put("CUR",                  in.get("PaymentCurrencyCode"));     	//결제통화
		mainMap.put("AMT",                  in.get("PaymentAmount"));     			//결제금액
		mainMap.put("EXC_RATE_USD",         in.get("USDExchangeRate"));     		//미화환율
		mainMap.put("EXC_RATE_CUR",         in.get("PaymentExchangeRate"));     	//결제환율
		mainMap.put("BOSE_RPT_FIRM",        in.get("BondedTransportName")); 		//보세운송인명
		mainMap.put("BOSE_RPT_DAY1",        in.get("BondedTransportStartDate")); 	//보세운송기간시작
		mainMap.put("BOSE_RPT_DAY2",        in.get("BondedTransportEndDate")); 		//보세운송기간종료
		mainMap.put("SEND_DIVI",         	in.get("FunctionCode")); 				//송신구분
		mainMap.put("RES_YN",               in.get("ResponseTypeCode"));     		//응답형태
		mainMap.put("TOT_RAN",              in.get("TotalRan"));    				//총란수
		mainMap.put("RPT_USG",         		in.get("ApplicationNotice")); 			//신고인기재란
		mainMap.put("GS_CHK",         		in.get("IdentificationID")); 			//개성공단반입구분
		mainMap.put("SN_DIVI",         		in.get("TradeIndicatorCode")); 			//남북교역 과세,비과세구분
		mainMap.put("SHIP_CODE",         	in.get("CarrierCompanyId")); 			//선사부호
		mainMap.put("SHIP_CO",         		in.get("CarrierCompanyName")); 			//선사명
		mainMap.put("SHIP_NAME",         	in.get("CarrierName")); 				//선박명편명
		mainMap.put("CHK_PA_MARK",         	in.get("FinalTransportPlaceCode")); 	//적재예정보세구역
		mainMap.put("PLAN_SHIP_DAY",        in.get("EstimatedDepartureDate")); 		//출항예정일
		mainMap.put("WARE_MARK",         	in.get("GoodsLocationCode")); 			//반입장치장부호
		mainMap.put("IN_BASIS_NO",         	in.get("ImportBaseNo")); 				//반입근거번호
		mainMap.put("MRN_NO",         		in.get("CargoControlNo")); 				//화물관리번호

		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}
	
	private Map<String, Object> makeRan(Map<String, Object> inRan){
		
		// 입력필드 확인설정 MAP
		Map<String, Object> ranMap = new HashMap<String, Object>();

		ranMap.put("RAN_NO",             	inRan.get("RanNo"));     				//란번호
		ranMap.put("HS",             	  	inRan.get("HSCode"));     				//HS부호
		ranMap.put("STD_GNM",            	inRan.get("HSGoodsDesc"));     			//표준품명
		ranMap.put("EXC_GNM",             	inRan.get("GoodsDesc"));     			//거래품명
		ranMap.put("MG_CODE",        	 	inRan.get("InvoiceNo"));     			//송품장부호
		ranMap.put("MODEL_GNM",            	inRan.get("BrandName"));     			//상표명
		ranMap.put("RPT_KRW",            	inRan.get("DeclAmount1")); 				//신고가격원화
		ranMap.put("RPT_USD",            	inRan.get("DeclAmount2")); 				//신고가격미화
		ranMap.put("SUN_WT",            	inRan.get("NetWeight")); 				//순중량
		ranMap.put("SUN_UT",            	inRan.get("NetWeightUnitCode")); 		//순중량단위
		ranMap.put("WT",            	 	inRan.get("Quantity")); 				//수량
		ranMap.put("UT",            	 	inRan.get("QuantityUnitCode")); 		//수량단위
		ranMap.put("IMP_RPT_SEND",          inRan.get("ImportDeclarationNo")); 		//수입신고번호
		ranMap.put("IMP_RAN_NO",            inRan.get("ImportDeclarationRanNo")); 	//수입 란번호
		ranMap.put("PACK_CNT",            	inRan.get("PackageQuantity")); 			//포장갯수
		ranMap.put("PACK_UT",            	inRan.get("PackageUnitCode")); 			//포장단위
		ranMap.put("ORI_ST_MARK1",          inRan.get("OriginCountryCode")); 		//원산지국가부호
		ranMap.put("ORI_ST_MARK2",          inRan.get("OriginMarkCode1")); 			//수출원산결정기준
		ranMap.put("ORI_ST_MARK3",          inRan.get("OriginMarkCode2")); 			//수출원산표시여부
		ranMap.put("ORI_FTA_YN",            inRan.get("OriginMarkCode3")); 			//원산지 자율발급 여부
		ranMap.put("ATT_YN",            	inRan.get("AttachYN")); 				//첨부여부
		
		ranMap.put("ItemList",            	inRan.get("ItemList")); 				
		
		// 입력필드 확인설정 MAP 반환
		return ranMap;
	}
	
	private Map<String, Object> makeItem(Map<String, Object> inItem){
		
		// 입력필드 확인설정 MAP
		Map<String, Object> itemMap = new HashMap<String, Object>();

		itemMap.put("SIL",            	 inItem.get("ItemNo"));     			//규격일련번호
		itemMap.put("MG_CD",             inItem.get("ItemCode"));     			//제품코드
		itemMap.put("GNM",        	 	 inItem.get("GoodsName"));     			//모델규격
		itemMap.put("COMP",        	 	 inItem.get("Component"));     			//성분
		itemMap.put("QTY",     	 		 inItem.get("ItemQuantity"));     		//수량
		itemMap.put("QTY_UT",            inItem.get("ItemQuantityUnitCode"));   //수량단위
		itemMap.put("PRICE",             inItem.get("UnitPrice"));     			//단가
		itemMap.put("AMT",             	 inItem.get("Amount"));     			//금액
		

		// 입력필드 확인설정 MAP 반환
		return itemMap;
	}
}
