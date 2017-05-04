package kr.pe.frame.openapi.service;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.service.AsyncService;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DateUtil;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.exp.dec.service.DecService;
import kr.pe.frame.exp.req.controller.ExpDecReqValidator;

@Service("declarationCreateService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class DeclarationCreateImpl extends OpenAPIService{
	@Resource(name = "decService")
    private DecService decService;
	 
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Autowired
    AsyncService asyncService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	private static Pattern PTRN_ENG_SPC_ETC = Pattern.compile("[a-zA-Z.,-[ ]]+"); // 영문, 공백, '.', ',', '-'
	private static Pattern PTRN_ENG_NUM_SPC_ETC = Pattern.compile("[a-zA-Z0-9\\p{Punct} \\t&&[^<>&]]+"); // 영문, 숫자, 공백(탭 포함), 특수문자('<', '>', '&' 제외)
	String status = "01";	// 신고생성요청 ('AAA1005')
	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("SellerPartyId"         		, new CheckInfo().setVARCHAR("35" 	, true));  	// 	M	VARCHAR(35)		판매자ID(몰)
		docListChecker.put("BrokerDeclarationId"        , new CheckInfo().setVARCHAR("5" 	, false)); 	// 	O	VARCHAR(5)		"수출의뢰관세사 신고인부호"
		docListChecker.put("OrderNo"         			, new CheckInfo().setVARCHAR("50" 	, true));  	// 	M	VARCHAR(50)		주문번호
		//docListChecker.put("AutoDeclaration"         	, new CheckInfo().setCODE(true, "openapi.codecheck.Yn"));  // 	M	VARCHAR(1)		자동전송여부 Y/N( 디폴트 Y)
		docListChecker.put("RequestType"         		, new CheckInfo().setVARCHAR("1" 	, true));  	// 	M	VARCHAR(1)		요청구분 
		docListChecker.put("PaymentAmount"         		, new CheckInfo().setNUMERIC("15,2" , true));  	// 	M	NUMERIC(15,2)	결제금액
		docListChecker.put("PaymentCurrencyCode"        , new CheckInfo().setCODE(true, "openapi.codecheck.CurrencyCode"));  		// 	M	VARCHAR(3)		결제통화코드
		docListChecker.put("DestinationCountryCode"     , new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode"));  		// 	M	VARCHAR(3)		목적국 국가코드
		docListChecker.put("BuyerPartyEngName"         	, new CheckInfo().setVARCHAR("26" 	, true));  	// 	M	VARCHAR(26)		구매자상호명
		docListChecker.put("TotalPackageQuantity"       , new CheckInfo().setVARCHAR("6" 	, true));  	// 	M	NUMERIC(6)		총포장갯수
		docListChecker.put("TotalPackageWeight"         , new CheckInfo().setNUMERIC("16,3" , true));  	// 	M	NUMERIC(16,3)	총중량
		docListChecker.put("SellerPartyCompanyName"     , new CheckInfo().setVARCHAR("28" 	, true));  	// 	M	VARCHAR(28)		판매자상호
		docListChecker.put("SellerPartyRegistNo"        , new CheckInfo().setCODE(true, "openapi.codecheck.SellerUseBizNo"));  		// 	M	VARCHAR(10)		판매자사업자등록번호
		docListChecker.put("SellerPartyAddress"         , new CheckInfo().setVARCHAR("70" 	, false)); 	// 	O	VARCHAR(70)		판매자주소
		docListChecker.put("SellerPartyCeoName"         , new CheckInfo().setVARCHAR("12" 	, false)); 	// 	O	VARCHAR(12)		판매자대표자명
		docListChecker.put("SellerPartyZipCode"         , new CheckInfo().setVARCHAR("5" 	, false)); 	// 	O	VARCHAR(5)		판매자우편번호5자리
		docListChecker.put("SellerPartyCustomsId"       , new CheckInfo().setVARCHAR("15" 	, false)); 	// 	O	VARCHAR(15)		판매자통관고유부호
		docListChecker.put("SellerPartyDeclarationId"   , new CheckInfo().setCODE(false, "openapi.codecheck.SellerUseApplicantID")); // 	O	VARCHAR(5)		판매자신고인부호
		docListChecker.put("GoodsLocZipCode"         	, new CheckInfo().setVARCHAR("5" 	, false)); 	// 	O	VARCHAR(5)		물품소재지우편번호
		docListChecker.put("GoodsLocAddress"         	, new CheckInfo().setVARCHAR("70" 	, false)); 	// 	O	VARCHAR(70)		물품소재지주소
		docListChecker.put("LoadingLocPortCode"         , new CheckInfo().setCODE(false, "openapi.codecheck.PortCode")); 			// 	O	VARCHAR(5)		적재항장소코드
		docListChecker.put("TransportMeansCode"         , new CheckInfo().setCODE(false, "openapi.codecheck.TransportMeansCode")); 	// 	O	VARCHAR(3)		주운송수단코드
		docListChecker.put("CustomsCode"         		, new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(3)		세관코드
		docListChecker.put("CustomsDeptCode"         	, new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(3)		과코드
		docListChecker.put("ManufactureLocCode"         , new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(3)		산업단지부호
		docListChecker.put("PaymentTypeCode"         	, new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(2)		결제방법코드
		docListChecker.put("ExportPartyTypeCode"        , new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(1)		수출자구분
		docListChecker.put("CustomsTaxRefundRequest"    , new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(2)		간이환급신청여부
		//docListChecker.put("InspectionCode"         	, new CheckInfo().setVARCHAR("1" 	, false)); // 	O	VARCHAR(1)		검사방법
		docListChecker.put("MakerCustomsId"         	, new CheckInfo().setVARCHAR("15" 	, false)); 	// 	O	VARCHAR(15)		제조자통관고유부호
		docListChecker.put("MakerName"         			, new CheckInfo().setVARCHAR("28" 	, false)); 	// 	O	VARCHAR(28)		제조자상호명
		docListChecker.put("MakerZipCode"         		, new CheckInfo().setVARCHAR("5" 	, false)); 	// 	O	VARCHAR(5)		제조자우편번호
		docListChecker.put("DeliveryTermsCode"         	, new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(3)		인도조건
		docListChecker.put("FreightAmount"         		, new CheckInfo().setVARCHAR("12" 	, false)); 	// 	O	NUMBER(12)		운임원화
		docListChecker.put("InsuranceAmount"         	, new CheckInfo().setVARCHAR("12" 	, false)); 	// 	O	NUMBER(12)		보험료원화
		//docListChecker.put("PriceAddYN"         		, new CheckInfo().setVARCHAR("1" 	, false)); // 	O	VARCHAR(1)		운임보험료 제품단가포함여부
		
		CheckInfo items = new CheckInfo().setLIST(true);
		Map itemsChecker = items.getSubCheckers();
		docListChecker.put("Items", items);
		
		itemsChecker.put("ItemNo"       				, new CheckInfo().setVARCHAR("50" 	, true));  // 	M	VARCHAR(50)		몰상품ID,몰에서 사용되는 품목 키
		itemsChecker.put("OriginLocCode"       			, new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode")); 		// 	O	VARCHAR(2)		판매물품원산지국가코드
		itemsChecker.put("NetWeight"       				, new CheckInfo().setNUMERIC("16,3" , false)); // 	O	NUMERIC(10,1)	포장용기제외순중량
		itemsChecker.put("Quantity"       				, new CheckInfo().setVARCHAR("10" 	, true)); // 	O	NUMERIC(10)		HS표준수량단위 수량
		itemsChecker.put("QuantityUnitCode"       		, new CheckInfo().setCODE(false, "openapi.codecheck.PackageUnitCode2")); 	// 	O	VARCHAR(3)		HS표준수량단위
		itemsChecker.put("BrandName"       				, new CheckInfo().setVARCHAR("30" 	, false)); // 	O	VARCHAR(30)		영문상표명
		itemsChecker.put("GoodsDesc"       				, new CheckInfo().setVARCHAR("50" 	, false)); // 	O	VARCHAR(50)		거래품명(영문)
		itemsChecker.put("HSCode"       				, new CheckInfo().setCODE(false, "openapi.codecheck.HsCode")); 				// 	O	VARCHAR(10)		HS부호
		itemsChecker.put("PackageQuantity"       		, new CheckInfo().setVARCHAR("8" 	, false)); // 	O	NUMERIC(8)		포장개수
		itemsChecker.put("PackageUnitCode"       		, new CheckInfo().setCODE(false)); 				// 	O	VARCHAR(2)		포장단위
		itemsChecker.put("DeclarationPrice"       		, new CheckInfo().setNUMERIC("17,2" , true));  // 	M	NUMERIC(17,2)	가격
		itemsChecker.put("UnitPrice"       				, new CheckInfo().setNUMERIC("17,2" , true)); // 	O	NUMERIC(17,2)	단가
		itemsChecker.put("DeclPriceCurrencyCode"       	, new CheckInfo().setCODE(false, "openapi.codecheck.CurrencyCode")); 		// 	O	VARCHAR(3)		통화
		itemsChecker.put("Component"       				, new CheckInfo().setVARCHAR("70" 	, false)); // 	O	VARCHAR(70)		성분

		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
		
		String reqNo ="";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		//주어진 정보의 기존전송여부를 확인
		paramMap = new HashMap<String, Object>();
		paramMap.put("SELLER_ID", (String)in.get("SellerPartyId"));
		paramMap.put("ORDER_ID", (String)in.get("OrderNo"));
		
		Map<String, Object> befReq = (Map<String, Object>) dao.select("openapi.dec.selectExpReqInfo", paramMap);
		String befStatus = "";
		boolean isExist = false;
		if (MapUtils.isEmpty(befReq)) {
			befStatus = "";
		}else{
			befStatus = (String) befReq.get("STATUS");
			reqNo = (String) befReq.get("REQ_NO");
			in.put("REQ_NO", reqNo);
			isExist = true;
		}
		//'AAA1005'
		if (!StringUtil.isEmpty(befStatus) && !"04".equals(befStatus)){
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
        List<Map<String, Object>>  items2 = (List<Map<String, Object>>) in.get("Items");
		Map<String, Object> inItem2 = new HashMap<String, Object>() ;
		double sumItem = 0;
		String errMsg = "";
		for (int i=0;i<items2.size();i++){
			inItem2 = (Map<String, Object>) items2.get(i);
			if(inItem2.get("UnitPrice") instanceof String){
				sumItem += Double.parseDouble((String) inItem2.get("UnitPrice")) * Integer.parseInt(getStringValue(inItem2.get("Quantity")));
	        }else if(inItem2.get("UnitPrice") instanceof Integer){
	        	sumItem += (int) inItem2.get("UnitPrice") * Integer.parseInt(getStringValue(inItem2.get("Quantity")));
	        }else if(inItem2.get("UnitPrice") instanceof Float){
	        	sumItem += Double.parseDouble(String.valueOf(inItem2.get("UnitPrice"))) * Integer.parseInt(getStringValue(inItem2.get("Quantity")));
	        }else if(inItem2.get("UnitPrice") instanceof Double){
	        	sumItem += ((Double) inItem2.get("UnitPrice")).doubleValue() * Integer.parseInt(getStringValue(inItem2.get("Quantity")));
	        }
			
	        //영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem2.get("BrandName")).matches()) {
				errMsg = "[BrandName]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
			}
			
			//영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem2.get("GoodsDesc")).matches()) {
				errMsg = "[GoodsDesc]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
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
		
        //의뢰관세사부호를 등록하면, 3Level작성 정보를 제공하지 않고, 해당 관세사로 의뢰건에 대한 메일을 제공한다.
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		reqNo = formatter.format(new Date())+"_"+in.get("OrderNo");
		if (!StringUtil.isEmpty((String) in.get("BrokerDeclarationId"))){
			
			//의뢰관세사부호로 관세사 메일주소 찾기
			paramMap = new HashMap<String, Object>();
			paramMap.put("APPLICANT_ID", (String) in.get("BrokerDeclarationId"));
			paramMap.put("USER_ID", (String)in.get("SellerPartyId"));
			String receiver = (String) dao.select("mod.selectApplicantMail", paramMap);
			if(StringUtil.isEmpty(receiver)){
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, "의뢰관세사부호가 정확하지 않습니다.");
				return;
			}
			
			Map<String, Object> mailParam = new HashMap<String, Object>();
			String title    = "goGlobal 요청관리번호[" + reqNo + "]의 수출신고 의뢰합니다.";
	        String vmName   = "dec_req_mail.html";
	        mailParam.put("REQ_NO", reqNo);
	        try {
				//commonService.sendSimpleEMail(receiver, title, vmName, mailParam);
	        	asyncService.asyncSendSimpleMail(DocUtil.decrypt(StringUtils.defaultIfEmpty(receiver, "")), title, vmName, mailParam);
				out.put("OrderNo"	, in.get("OrderNo"));
				out.put("RequestNo"	, reqNo);
			} catch (Exception e) {
				out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
				out.put(ERROR_DESCRIPTION	, e.getMessage());
				return;
			}
	        status = "05"; // 관세사의뢰 ('AAA1005')
		}
		
		try{
			//2Lev 데이터를 3Lev 로 변환
			Map<String, Object> mainMap = null;
			mainMap = makeMainReq(in);
			mainMap.put("REQ_NO"	,      reqNo);						//요청관리번호
			mainMap.put("REG_ID"	, 	   in.get("SellerPartyId"));	//등록자ID
			mainMap.put("MOD_ID"	, 	   in.get("SellerPartyId"));	//수정자ID
			dao.insert("openapi.dec.insertExpdecReq", mainMap);
			
			List<Map<String, Object>>  items = (List<Map<String, Object>>) in.get("Items");
			Map<String, Object> inItem = new HashMap<String, Object>() ;
			List<Map<String, Object>>  itemList = new ArrayList<Map<String, Object>>();
			for (int i=0;i<items.size();i++){
				inItem = (Map<String, Object>) items.get(i);
				/*String declarationPrice =  (String) inItem.get("DeclarationPrice");
				String unitPrice =  (String) inItem.get("UnitPrice");
				String quantity =  (String) inItem.get("Quantity");
				if (StringUtil.isEmpty(unitPrice)){
					if (!StringUtil.isEmpty(declarationPrice)){
						if (!StringUtil.isEmpty(quantity)){ 
							unitPrice = DocUtil.calcUnitPrice(declarationPrice, quantity);
						}
					}
				}*/
				inItem = makeItemReq(inItem);
				inItem.put("REQ_NO"		, reqNo);					//요청관리번호
				inItem.put("SN"			, (i+1)+"");				//번호
				inItem.put("REG_ID"		, in.get("SellerPartyId"));	//등록자ID
				inItem.put("MOD_ID"		, in.get("SellerPartyId"));	//수정자ID
				//itemList.add(inItem);
				dao.insert("openapi.dec.insertExpdecReqItem", inItem);
			}
			
			//수출신고서 생성
			try {
				AjaxModel model = new AjaxModel();
				in.put("REQ_NO", reqNo);
				model.setData(in);
				decService.saveGenerateExpDoc(model, "API");
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			paramMap = new HashMap<String, Object>();
			paramMap.put("REQ_NO", reqNo);
			String sRptNo = (String) dao.select("openapi.dec.selectRptNo", paramMap);
			
			Map<String, Object> expInfo = null;			   //공통
			List<Map<String, Object>> expRanList = null;   //란
			List<Map<String, Object>> expModelList = null; //모델규격
			
			//수출신고 Main정보 조회
			paramMap = new HashMap<String, Object>();
			paramMap.put("RPT_NO", sRptNo);
			expInfo = (Map<String, Object>) dao.select("dec.selectDecDetail", paramMap);
			if (MapUtils.isEmpty(expInfo)) {
				throw new BizException("수출신고서 정보가 없음");
			}
			
			//수출신고 란 정보 조회
			paramMap.put("RPT_SEQ", "00");
			expRanList = dao.list("dec.selectDecRanList", paramMap);
			if (expRanList == null || expRanList.size() < 1 ){
				throw new BizException("수출신고서 란정보가 없음");
			}
			
			//기본
			out.put("OrderNo", expInfo.get("ORDER_ID"));
			
			//Main
			Map outMain = new HashMap();
			out.put("ExportInfo", outMain);
			outMain.put("ExportDeclarationNo"	 		, expInfo.get("RPT_NO"));   		//	M	VARCHAR2(15)	제출번호(PK)
			outMain.put("ApplicationCompanyName"	 	, expInfo.get("RPT_FIRM"));   		//	M	VARCHAR2(50)	신고자상호
			outMain.put("ApplicationId"	 				, expInfo.get("RPT_MARK"));   		//	M	VARCHAR2(5)		신고자부호
			outMain.put("ApplicationPartyCeoName"  		, expInfo.get("RPT_BOSS_NM"));   	//	M	VARCHAR2(12)	신고자대표자
			
			//수출대행자 정보가 있으면, 대행자 정보입력하고, 없으면 기존대로 수출화주 정보를 대행자 정보에 입력함
			if(!"".equals((String) expInfo.get("COMM_TGNO")) && (String) expInfo.get("COMM_TGNO") != null ){
				outMain.put("AgencyCompanyName",          expInfo.get("COMM_FIRM"));    	//	수출대행자상호
				outMain.put("AgencyCustomsId",            expInfo.get("COMM_TGNO"));     	//	수출대행자통관부호
			}else{
				outMain.put("AgencyCompanyName",          expInfo.get("EXP_FIRM"));     	//	수출화주상호
				outMain.put("AgencyCustomsId",            expInfo.get("EXP_TGNO"));    		//	수출화주통관부호
			}
			
			outMain.put("ExportPartyTypeCode"  			, expInfo.get("EXP_DIVI"));   		//	M	VARCHAR2(1)	수출자구분
			outMain.put("ExportPartyCompanyName"  		, expInfo.get("EXP_FIRM"));   		//	M	VARCHAR2(28)수출화주 상호
			outMain.put("ExportPartyCeoName"  			, expInfo.get("EXP_BOSS_NAME"));   	//	M	VARCHAR2(12)수출화주 대표자성명
			outMain.put("ExportPartyAddress"  			, DocUtil.strCutArray((String) expInfo.get("EXP_ADDR1"), 35, 2,1));   //	M	VARCHAR2(150)	수출화주주소1
			outMain.put("ExportPartyRegistNo"  			, expInfo.get("EXP_SDNO"));   		//	M	VARCHAR2(13)수출화주사업자번호
			outMain.put("ExportPartyCustomsId"  		, expInfo.get("EXP_TGNO"));   		//	O	VARCHAR2(15)수출화주통관부호
			outMain.put("ExportPartyZipCode"  			, expInfo.get("EXP_POST"));   		//	M	VARCHAR2(5)	수출화주 소재지우편번호
			outMain.put("MakerName"  					, expInfo.get("MAK_FIRM"));   		//	M	VARCHAR2(28)제조자상호
			outMain.put("MakerCustomsId"  				, expInfo.get("MAK_TGNO"));   		//	O	VARCHAR2(15)제조자통관부호
			outMain.put("MakerZipCode"  				, expInfo.get("MAK_POST"));   		//	M	VARCHAR2(5)	제조자지역코드
			outMain.put("ManufactureLocCode"  			, expInfo.get("INLOCALCD"));   		//	O	VARCHAR2(3)	제조장소산업단지부호
			outMain.put("BuyerPartyEngName"  			, expInfo.get("BUY_FIRM"));   		//	M	VARCHAR2(60)해외거래처구매자상호
			outMain.put("BuyerPartyId"  				, expInfo.get("BUY_MARK"));   		//	O	VARCHAR2(13)해외거래처구매자부호
			outMain.put("CustomsCode"  					, expInfo.get("RPT_CUS"));  		//	O	VARCHAR2(3)	신고세관
			outMain.put("CustomsDeptCode"  				, expInfo.get("RPT_SEC"));   		//	O	VARCHAR2(2)	신고세관과부호
			outMain.put("DeclarationDate"  				, expInfo.get("RPT_DAY"));   		//	O	VARCHAR2(8)	신고일자
			outMain.put("DeclarationType"  				, expInfo.get("RPT_DIVI"));  		//	M	VARCHAR2(1)	수출신고구분
			outMain.put("TransactionType"  				, expInfo.get("EXC_DIVI"));   		//	M	VARCHAR2(3)	수출거래구분
			outMain.put("ExportType"  					, expInfo.get("EXP_KI"));   		//	O	VARCHAR2(1)	수출종류
			outMain.put("PaymentTypeCode"  				, expInfo.get("CON_MET"));  		//	M	VARCHAR2(2)	결제방법
			outMain.put("DestinationCountryCode"  		, expInfo.get("TA_ST_ISO"));		//	M	VARCHAR2(2)	목적국국가코드
			outMain.put("LoadingLocPortCode"  			, expInfo.get("FOD_CODE"));   		//	M	VARCHAR2(5)	적재항코드
			outMain.put("LoadingLocPortType"  			, expInfo.get("ARR_MARK"));   		//	M	VARCHAR2(3)	적재항 구분코드
			outMain.put("TransportMeansCode"  			, expInfo.get("TRA_MET"));   		//	O	VARCHAR2(2)	운송형태
			outMain.put("TransportCaseCode"  			, expInfo.get("TRA_CTA"));   		//	O	VARCHAR2(3)	운송용기
			outMain.put("InspectionCode"  				, expInfo.get("CHK_MET_GBN"));   	//		VARCHAR2(1)	검사방법코드
			outMain.put("DepartureScheduledDate"  		, expInfo.get("MAK_FIN_DAY"));   	//	O	VARCHAR2(8)	검사희망일
			outMain.put("GoodsLocZipCode"  				, expInfo.get("GDS_POST"));   		//	M	VARCHAR2(5)	물품소재지우편번호
			outMain.put("GoodsLocAddress"  				, expInfo.get("GDS_ADDR1"));   		//	M	VARCHAR2(70)물품소재지주소1
			outMain.put("LcNo"  						, expInfo.get("LCNO"));   			//	O	VARCHAR2(20)L/C번호
			outMain.put("GoodsUsedCode"  				, expInfo.get("USED_DIVI"));   		//	O	VARCHAR2(1)	물품상태구분코드
			outMain.put("StatementCode"  				, expInfo.get("UP5AC_DIVI"));   	//	O	VARCHAR2(1)	사전임시개청신청여부
			outMain.put("ReturnReasonCode"  			, expInfo.get("BAN_DIVI"));   		//	O	VARCHAR2(2)	반송사유부호
			outMain.put("RefundCode"  					, expInfo.get("REF_DIVI"));   		//	O	VARCHAR2(1)	환급신청자구분
			outMain.put("CustomsTaxRefundRequest"  		, expInfo.get("RET_DIVI"));			//	M	VARCHAR2(2)	간이환급신청구분
			outMain.put("ReturnScopeCode"  				, expInfo.get("MRN_DIVI"));   		//	O	VARCHAR2(1)	화물관리번호전송여부
			outMain.put("ContainerIndicator" 			, expInfo.get("CONT_IN_GBN"));   	//	O	VARCHAR2(1)	컨테이너적입여부
			outMain.put("TotalPackageWeight"  			, expInfo.get("TOT_WT"));   		//	M	NUMBER(16,3)총중량
			outMain.put("TotalPackageWeightUnitCode"  	, expInfo.get("UT"));				//	M	VARCHAR2(3)	총중량단위
			outMain.put("TotalPackageQuantity"  		, expInfo.get("TOT_PACK_CNT")); 	//	M	NUMBER(6)	총포장수
			outMain.put("TotalPackageUnitCode"  		, expInfo.get("TOT_PACK_UT"));   	//	M	VARCHAR2(3)	총포장수단위
			outMain.put("TotalDeclAmountKRW"  			, expInfo.get("TOT_RPT_KRW"));   	//	M	NUMBER(15)	총신고금액원화
			outMain.put("TotalDeclAmountUSD"  			, expInfo.get("TOT_RPT_USD"));   	//	O	NUMBER(12)	총신고금액미화
			outMain.put("FreightAmount"  				, expInfo.get("FRE_KRW"));  		//	O	NUMBER(12)	운임금액원화
			outMain.put("InsuranceAmount"  				, expInfo.get("INSU_KRW"));   		//	O	NUMBER(12)	보험금액원화
			outMain.put("DeliveryTermsCode"  			, expInfo.get("AMT_COD"));   		//	M	VARCHAR2(3)	인도조건
			outMain.put("PaymentCurrencyCode"  			, expInfo.get("CUR"));   			//	M	VARCHAR2(3)	결제통화
			outMain.put("PaymentAmount"  				, expInfo.get("AMT"));   			//	M	NUMBER(18,2)결제금액
			outMain.put("USDExchangeRate"  				, expInfo.get("EXC_RATE_USD"));   	//	O	NUMBER(9, 4)미화환율
			outMain.put("PaymentExchangeRate"  			, expInfo.get("EXC_RATE_CUR"));   	//	O	NUMBER(9, 4)결제환율
			
			outMain.put("BondedTransportName"  			, expInfo.get("BOSE_RPT_CODE"));   	//	O	VARCHAR2(30)보세운송인명
			outMain.put("BondedTransportStartDate"  	, expInfo.get("BOSE_RPT_DAY1"));   	//	O	VARCHAR2(8)	보세운송기간시작
			outMain.put("BondedTransportEndDate"  		, expInfo.get("BOSE_RPT_DAY2"));   	//	O	VARCHAR2(8)	보세운송기간종료
			outMain.put("FunctionCode"  				, expInfo.get("SEND_DIVI"));   		//	O	VARCHAR2(2)	송신구분
			outMain.put("ResponseTypeCode"  			, expInfo.get("RES_YN"));   		//	M	VARCHAR2(2)	응답형태
			outMain.put("TotalRan"  					, expInfo.get("TOT_RAN"));   		//	M	NUMBER(3)총란수
			outMain.put("ApplicationNotice"  			, expInfo.get("RPT_USG"));   		//	O	VARCHAR2(500)신고인기재란
			outMain.put("IdentificationID"  			, expInfo.get("GS_CHK"));   		//	O	VARCHAR2(2)	개성공단반입구분
			outMain.put("TradeIndicatorCode"  			, expInfo.get("SN_DIVI"));   		//	O	VARCHAR2(1)	남북교역 과세,비과세구분
			outMain.put("CarrierCompanyId"  			, expInfo.get("SHIP_CODE"));   		//	O	VARCHAR2(4)	선사부호
			outMain.put("CarrierCompanyName"  			, expInfo.get("SHIP_CO"));   		//	O	VARCHAR2(25)선사명
			outMain.put("CarrierName"  					, expInfo.get("SHIP_NAME"));   		//	O	VARCHAR2(35)선박명편명
			outMain.put("FinalTransportPlaceCode"  		, expInfo.get("CHK_PA_MARK"));   	//	O	VARCHAR2(8)	적재예정보세구역
			outMain.put("EstimatedDepartureDate"  		, expInfo.get("PLAN_SHIP_DAY"));   	//	O	VARCHAR2(8)	출항예정일
			outMain.put("GoodsLocationCode"  			, expInfo.get("WARE_MARK"));   		//	O	VARCHAR2(8)	반입장치장부호
			outMain.put("ImportBaseNo"  				, expInfo.get("IN_BASIS_NO"));   	//	O	VARCHAR2(15)반입근거번호
			outMain.put("CargoControlNo"  				, expInfo.get("MRN_NO"));   		//	O	VARCHAR2(19)화물관리번호
			
			//Ran
			Map outRans = new HashMap();
			outMain.put("RanList", outRans);
			Map<String, Object> ranMap = null;
			float amtTotal = 0;
			for (int i=0; i<expRanList.size();i++){
				ranMap = (Map<String, Object>) expRanList.get(i);
			
				outRans.put("RanNo"      			, ranMap.get("RAN_NO"));            	//		M	VARCHAR2(3)	  란번호(PK)
				outRans.put("HSCode"      			, ranMap.get("HS"));            		//		M	VARCHAR2(10) 세번부호
				outRans.put("HSGoodsDesc"      		, ranMap.get("STD_GNM"));            	//		M	VARCHAR2(50) 표준품명
				outRans.put("GoodsDesc"      		, ranMap.get("EXC_GNM"));            	//		M	VARCHAR2(50) 거래품명
				outRans.put("InvoiceNo"      		, ranMap.get("MG_CODE"));            	//		O	VARCHAR2(17) 송품장부호
				outRans.put("BrandName"      		, ranMap.get("MODEL_GNM"));            	//		O	VARCHAR2(30) 상표명
				outRans.put("DeclAmount1"      		, ranMap.get("RPT_KRW"));            	//		M	NUMBER(18)	  신고가격원화
				outRans.put("DeclAmount2"      		, ranMap.get("RPT_USD"));            	//		O	NUMBER(12) 	  신고가격미화
				outRans.put("NetWeight"      		, ranMap.get("SUN_WT"));            	//		M	NUMBER(16,3) 순중량
				outRans.put("NetWeightUnitCode"     , ranMap.get("SUN_UT"));           		//		M	VARCHAR2(3)	  순중량단위
				outRans.put("Quantity"      		, ranMap.get("WT"));            		//		O	NUMBER(10) 	  수량
				outRans.put("QuantityUnitCode"      , ranMap.get("UT"));           			//		O	VARCHAR2(3)	  수량단위
				outRans.put("ImportDeclarationNo"   , "");            						//		O	VARCHAR2(15) 수입신고번호
				outRans.put("ImportDeclarationRanNo", "");            						//		O	VARCHAR2(3)	  수입 란번호
				
				int sPackQty = ((BigDecimal) ranMap.get("PACK_CNT")).intValue();
				//sPackQty  = (sPackQty.indexOf(".") > -1) ? sPackQty.substring(0, sPackQty.indexOf(".")) : sPackQty;
				outRans.put("PackageQuantity"      	, sPackQty);            				//		O	NUMBER(10)	  포장갯수
				outRans.put("PackageUnitCode"      	, ranMap.get("PACK_UT"));          		//		O	VARCHAR2(2)	  포장단위
				outRans.put("OriginCountryCode"     , ranMap.get("ORI_ST_MARK1"));          //		M	VARCHAR2(2)	  원산지국가부호
				outRans.put("OriginMarkCode1"      	, "");            						//		O	VARCHAR2(1)	  수출원산결정기준
				outRans.put("OriginMarkCode2"      	, "");            						//		O	VARCHAR2(1)	  수출원산표시여부
				outRans.put("OriginMarkCode3"      	, "");            						//		O	VARCHAR2(1)	  원산지 자율발급 여부
				outRans.put("AttachYN"      		, ranMap.get("ATT_YN"));            	//		M	VARCHAR2(1)	  첨부여부
				
				//수출신고 모델규격 정보 조회
				paramMap.put("RAN_NO", ranMap.get("RAN_NO"));
				expModelList = dao.list("dec.selectDecModelList", paramMap);
				if (expModelList == null || expModelList.size() < 1 ){
					throw new BizException("수출신고서 모델규격정보가 없음");
				}
				
				//Model
				Map outModels = new HashMap();
				outRans.put("ItemList", outModels);
				Map<String, Object> modelMap = null;
				float amtRanTotal = 0;
				for (int j=0; j<expModelList.size(); j++){
					modelMap = (Map<String, Object>) expModelList.get(j);
					
					int iQty = ((BigDecimal) modelMap.get("QTY")).intValue();
					//int iQty  = (sQty.indexOf(".") > -1) ? Integer.parseInt(sQty.substring(0, sQty.indexOf("."))) : Integer.parseInt(sQty);
					
					outModels.put("ItemNo"         		, modelMap.get("SIL"));     	//	M	VARCHAR2(2)		규격일련번호
					outModels.put("ItemCode"         	, modelMap.get("MG_CD"));	    //	O	VARCHAR2(50)	제품코드
					outModels.put("GoodsName"         	, modelMap.get("GNM"));         //	M	VARCHAR2(300)	모델규격
					outModels.put("Component"         	, modelMap.get("COMP"));        //	O	VARCHAR2(70)	성분
					outModels.put("ItemQuantity"        , iQty);        				//	O	NUMBER(14,4)	수량
					outModels.put("ItemQuantityUnitCode", modelMap.get("QTY_UT"));    	//	O	VARCHAR2(3)		수량단위
					outModels.put("UnitPrice"         	, modelMap.get("PRICE"));     	//	M	NUMBER(18,6)	단가
					outModels.put("Amount"         		, modelMap.get("AMT"));       	//	M	NUMBER(16,4)	금액
				}
				
			}
			
			//dao.delete("openapi.dec.deleteExpdecReq", mainMap);
			//dao.delete("openapi.dec.deleteExpdecReqItem", mainMap);
			
			dao.delete("openapi.dec.deleteExpdec", paramMap);
			dao.delete("openapi.dec.deleteExpdecRan", paramMap);
			dao.delete("openapi.dec.deleteExpdecModel", paramMap);
			
		}catch(Exception e){
			//e.printStackTrace();
		}
		
	}
	
	private Map<String, Object> makeMainReq(Map<String, Object> in){

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		mainMap.put("STATUS",                     status           );     				   //상태
		mainMap.put("MALL_ID",                   in.get("SellerPartyId")            );     //몰ID
		mainMap.put("SELLER_ID",                 in.get("SellerPartyId")            );     //판매자ID
		mainMap.put("RPT_MARK",                  in.get("BrokerDeclarationId")      );     //수출의뢰관세사 신고인부호
		mainMap.put("ORDER_ID",                  in.get("OrderNo")                  );     //주문번호
		//mainMap.put("SEND_CHECK",                in.get("AutoDeclaration")          );     //자동전송여부
		mainMap.put("REQUEST_DIV",               in.get("RequestType")              );     //요청구분
		mainMap.put("PAYMENTAMOUNT",             in.get("PaymentAmount")            );     //결제금액
		mainMap.put("PAYMENTAMOUNT_CUR",         in.get("PaymentCurrencyCode")      );     //결제통화코드
		mainMap.put("DESTINATIONCOUNTRYCODE",    in.get("DestinationCountryCode")   );     //목적국국가코드
		mainMap.put("BUYERPARTYORGNAME",         in.get("BuyerPartyEngName")        );     //구매자상호명
		mainMap.put("SUMMARY_TOTALQUANTITY",     in.get("TotalPackageQuantity")     );     //총포장갯수
		mainMap.put("SUMMARY_TOTALWEIGHT",       in.get("TotalPackageWeight")       );     //중량합계
		mainMap.put("EOCPARTYORGNAME2",          in.get("SellerPartyCompanyName")   );     //판매자상호
		mainMap.put("EOCPARTYPARTYIDID1",        in.get("SellerPartyRegistNo")      );     //판매자사업자등록번호
		mainMap.put("EOCPARTYADDRLINE",          in.get("SellerPartyAddress")       );     //판매자주소
		mainMap.put("EOCPARTYORGCEONAME",        in.get("SellerPartyCeoName")       );     //판매자대표자명
		mainMap.put("EOCPARTYLOCID",             in.get("SellerPartyZipCode")       );     //판매자우편번호
		mainMap.put("EOCPARTYPARTYIDID2",        in.get("SellerPartyCustomsId")     );     //판매자통관고유부호
		mainMap.put("APPLICANTPARTYORGID",       in.get("SellerPartyDeclarationId") );     //판매자신고인부호
		mainMap.put("GOODSLOCATIONID1",          in.get("GoodsLocZipCode")          );     //물품소재지우편번호
		mainMap.put("GOODSLOCATIONNAME",         in.get("GoodsLocAddress")          );     //물품소재지	
		mainMap.put("LODINGLOCATIONID",          in.get("LoadingLocPortCode")       );     //적재항코드
		mainMap.put("TRANSPORTMEANSCODE",        in.get("TransportMeansCode")       );     //주운송수단
		mainMap.put("CUSTOMORGANIZATIONID",      in.get("CustomsCode")              );     //세관코드
		mainMap.put("CUSTOMDEPARTMENTID",        in.get("CustomsDeptCode")          );     //과코드
		mainMap.put("GOODSLOCATIONID2",          in.get("ManufactureLocCode")       );     //산업단지부호
		mainMap.put("PAYMENTTERMSTYPECODE",      in.get("PaymentTypeCode")          );     //결제방법코드
		mainMap.put("EXPORTERCLASSCODE",         in.get("ExportPartyTypeCode")      );     //수출자구분
		mainMap.put("SIMPLEDRAWAPPINDICATOR",    in.get("CustomsTaxRefundRequest")  );     //간이환급신청여부
		mainMap.put("INSPECTIONCODE",            in.get("InspectionCode")           );     //검사방법
		mainMap.put("MANUPARTYORGID",            in.get("MakerCustomsId")           );     //제조자통관고유부호
		mainMap.put("MANUPARTYORGNAME",          in.get("MakerName")                );     //제조자상호명
		mainMap.put("MANUPARTYLOCID",            in.get("MakerZipCode")             );     //제조자우편번호
		mainMap.put("DELIVERYTERMSCODE",         in.get("DeliveryTermsCode")        );     //인도조건
		mainMap.put("FRE_KRW",            		 in.get("FreightAmount")            );     //운임원화
		mainMap.put("INSU_KRW",           		 in.get("InsuranceAmount")          );     //보험료원화
		mainMap.put("REGIST_METHOD",           	 "API"          					);     //등록방법
		//mainMap.put("FOB_YN",               	 in.get("PriceAddYN")               );     //운임보험료 제품단가포함여부
		
		String loadingLocationId = (String) in.get("LoadingLocPortCode");
		if (!StringUtil.isEmpty(loadingLocationId)){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CLASS_ID"	, "CUS0046");	//항구공항
			paramMap.put("CODE"		, loadingLocationId);
			Map<String, Object> LocInfo = (Map<String, Object>)dao.select("comm.getCommcodeDetail", paramMap);
			mainMap.put("LODINGLOCATIONTYPECODE",   LocInfo.get("USER_REF3"));	//(3G:USER_REF1, 4G:USER_REF3) 적재항종류
		}

		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}
	
	private Map<String, Object> makeItemReq(Map<String, Object> inItem){
		
		// 입력필드 확인설정 MAP
		Map<String, Object> itemMap = new HashMap<String, Object>();

		itemMap.put("MALL_ITEM_NO",            	 inItem.get("ItemNo")                );     //몰상품코드
		itemMap.put("ORIGINLOCID",             	 inItem.get("OriginLocCode")         );     //원산지국가코드
		itemMap.put("NETWEIGHTMEASURE",        	 inItem.get("NetWeight")             );     //중량
		itemMap.put("LINEITEMQUANTITY",        	 inItem.get("Quantity")              );     //수량
		itemMap.put("LINEITEMQUANTITY_UC",     	 inItem.get("QuantityUnitCode")      );     //수량단위
		itemMap.put("BRANDNAME_EN",            	 inItem.get("BrandName")             );     //상표명
		itemMap.put("ITEMNAME_EN",             	 inItem.get("GoodsDesc")             );     //거래품명(영문)
		itemMap.put("ITEMNAME_HS",             	 inItem.get("GoodsDesc")             );     //거래품명(한글)
		itemMap.put("CLASSIDHSID",             	 inItem.get("HSCode")                );     //HS부호
		itemMap.put("PACKAGINGQUANTITY",       	 inItem.get("PackageQuantity")       );     //포장갯수
		itemMap.put("PACKAGINGQUANTITY_UC",    	 inItem.get("PackageUnitCode")       );     //포장단위
		itemMap.put("DECLARATIONAMOUNT",       	 inItem.get("DeclarationPrice")      );     //가격
		itemMap.put("BASEPRICEAMT",            	 inItem.get("UnitPrice")             );     //단가
		itemMap.put("DECLARATIONAMOUNT_CUR",   	 inItem.get("DeclPriceCurrencyCode") );     //통화코드
		itemMap.put("COMP",              	     inItem.get("Component")       	  );     //성분

		// 입력필드 확인설정 MAP 반환
		return itemMap;
	}
	
	private String getUSDExchange(){
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("APPLY_DATE", exchangeBaseDate);
		paramMap.put("NATION" ,     "USD");
		paramMap.put("IMPORT_EXPORT" , "E");
		String exchangeRateStr =  (String) dao.select("dec.selectExchangeRate", paramMap);
		return exchangeRateStr;
	}
}
