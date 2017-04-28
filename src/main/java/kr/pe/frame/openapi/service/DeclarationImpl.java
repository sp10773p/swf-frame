package kr.pe.frame.openapi.service;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.openapi.model.ResultTypeCode;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DateUtil;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.exp.dec.service.DecService;
import kr.pe.frame.openapi.model.CheckInfo;

@Service("declarationService")
@SuppressWarnings({"rawtypes"})
/**
 * 수출신고요청
 * @author jjkhj
 *
 */
public class DeclarationImpl extends OpenAPIService {
	@Resource(name = "decService")
    private DecService decService;
	 
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
		
		docListChecker.put("MallId"    					, new CheckInfo().setVARCHAR("35"	, true));	//	M	VARCHAR(35)			몰ID
		docListChecker.put("SellerPartyId"    			, new CheckInfo().setVARCHAR("35"	, false));	//	O	VARCHAR(35)			판매자ID(몰)
		docListChecker.put("OrderNo"    				, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50)			주문번호
		docListChecker.put("AutoDeclaration"    		, new CheckInfo().setCODE(true, "openapi.codecheck.Yn"));				//	M	VARCHAR(1)	자동전송여부 Y/N( 디폴트 Y)
		docListChecker.put("DeliveryStatus"    			, new CheckInfo().setVARCHAR("2"	, false));	//	O	VARCHAR(2)			배송상태
		docListChecker.put("DeliveryMeans"    			, new CheckInfo().setVARCHAR("3"	, false));	//	O	VARCHAR(3)			배송구분
		docListChecker.put("InvoiceNo"    				, new CheckInfo().setVARCHAR("100"	, false));	//	O	VARCHAR(100)		배송번호
		docListChecker.put("RequestType"    			, new CheckInfo().setVARCHAR("1"	, true));	//	M	VARCHAR(1)			요청구분 
		docListChecker.put("PaymentAmount"    			, new CheckInfo().setNUMERIC("15,2"	, true));	//	M	NUMERIC(15,2)		결제금액
		docListChecker.put("PaymentCurrencyCode"    	, new CheckInfo().setCODE(true, "openapi.codecheck.CurrencyCode"));		//	M	VARCHAR(3)	결제통화코드
		docListChecker.put("DestinationCountryCode"   	, new CheckInfo().setCODE(true, "openapi.codecheck.CountryCode"));		//	M	VARCHAR(3)	목적국 국가코드
		docListChecker.put("BuyerPartyEngName"    		, new CheckInfo().setVARCHAR("26"	, true));	//	M	VARCHAR(26)			구매자상호명
		docListChecker.put("TotalPackageQuantity"    	, new CheckInfo().setNUMERIC("6"	, true));	//	M	NUMERIC(6)			총포장갯수
		docListChecker.put("TotalPackageWeight"    		, new CheckInfo().setNUMERIC("16,3"	, true));	//	M	NUMERIC(11,1)		총중량
		docListChecker.put("SellerPartyCompanyName"    	, new CheckInfo().setVARCHAR("28"	, true));	//	M	VARCHAR(28)			판매자상호
		docListChecker.put("SellerPartyRegistNo"    	, new CheckInfo().setCODE(true, "openapi.codecheck.SellerUseBizNo"));	//	M	VARCHAR(10)	판매자사업자등록번호
		docListChecker.put("SellerPartyAddress"    		, new CheckInfo().setVARCHAR("70"	, false));	//	O	VARCHAR(70)			판매자주소
		docListChecker.put("SellerPartyCeoName"    		, new CheckInfo().setVARCHAR("12"	, false));	//	O	VARCHAR(12)			판매자대표자명
		docListChecker.put("SellerPartyZipCode"    		, new CheckInfo().setVARCHAR("5"	, false));	//	O	VARCHAR(5)			판매자우편번호5자리
		docListChecker.put("SellerPartyCustomsId"    	, new CheckInfo().setVARCHAR("15"	, false));	//	O	VARCHAR(15)			판매자통관고유부호
		docListChecker.put("SellerPartyDeclarationId"   , new CheckInfo().setCODE(false, "openapi.codecheck.SellerUseApplicantID"));	//	O	VARCHAR(5)	판매자신고인부호
		docListChecker.put("ExportAgentPartyCompanyName", new CheckInfo().setVARCHAR("28"	, false));	//	O	VARCHAR(28)			수출대행자 상호
		docListChecker.put("ExportAgentPartyCustomsId"  , new CheckInfo().setVARCHAR("15"	, false));	//	O	VARCHAR(15)			수출대행자 통관고유부호
		docListChecker.put("GoodsLocZipCode"    		, new CheckInfo().setVARCHAR("5"	, false));	//	O	VARCHAR(5)			물품소재지우편번호
		docListChecker.put("GoodsLocAddress"    		, new CheckInfo().setVARCHAR("70"	, false));	//	O	VARCHAR(70)			물품소재지주소
		docListChecker.put("LoadingLocPortCode"    		, new CheckInfo().setCODE(false, "openapi.codecheck.PortCode"));		//	O	VARCHAR(5)	적재항장소코드
		docListChecker.put("TransportMeansCode"    		, new CheckInfo().setCODE(false, "openapi.codecheck.TransportMeansCode"));	//	O	VARCHAR(3)	주운송수단코드
		docListChecker.put("CustomsCode"    			, new CheckInfo().setCODE(false));				//	O	VARCHAR(3)			세관코드
		docListChecker.put("CustomsDeptCode"    		, new CheckInfo().setCODE(false));				//	O	VARCHAR(3)			과코드
		docListChecker.put("ManufactureLocCode"    		, new CheckInfo().setCODE(false));				//	O	VARCHAR(3)			산업단지부호
		docListChecker.put("PaymentTypeCode"    		, new CheckInfo().setCODE(false));				//	O	VARCHAR(2)			결제방법코드
		docListChecker.put("ExportPartyTypeCode"    	, new CheckInfo().setCODE(false));				//	O	VARCHAR(1)			수출자구분
		docListChecker.put("CustomsTaxRefundRequest"    , new CheckInfo().setCODE(false));				//	O	VARCHAR(2)			간이환급신청여부
		docListChecker.put("InspectionCode"    			, new CheckInfo().setVARCHAR("1"	, false));	//	O	VARCHAR(1)			검사방법
		docListChecker.put("MakerCustomsId"    			, new CheckInfo().setVARCHAR("15"	, false));	//	O	VARCHAR(15)			제조자통관고유부호
		docListChecker.put("MakerName"    				, new CheckInfo().setVARCHAR("28"	, false));	//	O	VARCHAR(28)			제조자상호명
		docListChecker.put("MakerZipCode"    			, new CheckInfo().setVARCHAR("5"	, false));	//	O	VARCHAR(5)			제조자우편번호
		docListChecker.put("DeliveryTermsCode"    		, new CheckInfo().setCODE(false));				//	O	VARCHAR(3)			인도조건

		
		CheckInfo items = new CheckInfo().setLIST(true);
		Map itemsChecker = items.getSubCheckers();
		docListChecker.put("Items", items);
		
		itemsChecker.put("ItemNo"    					, new CheckInfo().setVARCHAR("50"	, true));	//	M	VARCHAR(50)			몰상품ID,몰에서 사용되는 품목 키
		itemsChecker.put("OriginLocCode"    			, new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode"));		//	O	VARCHAR(2)				판매물품원산지국가코드
		itemsChecker.put("NetWeight"    				, new CheckInfo().setNUMERIC("16,3"	, false));	//	O	NUMERIC(10,1)		포장용기제외순중량
		itemsChecker.put("Quantity"    					, new CheckInfo().setNUMERIC("10"	, true));	//	O	NUMERIC(10)			HS표준수량단위 수량 => 물품수량
		itemsChecker.put("QuantityUnitCode"    			, new CheckInfo().setCODE(false, "openapi.codecheck.PackageUnitCode2"));//	O	VARCHAR(3)			HS표준수량단위 => 물품수량단위
		itemsChecker.put("BrandName"    				, new CheckInfo().setVARCHAR("30"	, false));	//	O	VARCHAR(30)			영문상표명
		itemsChecker.put("GoodsDesc"    				, new CheckInfo().setVARCHAR("50"	, false));	//	O	VARCHAR(50)			거래품명(영문)
		itemsChecker.put("HSCode"    					, new CheckInfo().setCODE(false, "openapi.codecheck.HsCode"));			//	O	VARCHAR(10)	HS부호
		itemsChecker.put("PackageQuantity"    			, new CheckInfo().setNUMERIC("8"	, false));	//	O	NUMERIC(8)			포장개수
		itemsChecker.put("PackageUnitCode"    			, new CheckInfo().setCODE(false));				//	O	VARCHAR(2)	포장단위
		itemsChecker.put("DeclarationPrice"    			, new CheckInfo().setNUMERIC("17,2"	, true));	//	M	NUMERIC(17,2)		가격
		itemsChecker.put("UnitPrice"    				, new CheckInfo().setNUMERIC("17,2"	, true));	//	O	NUMERIC(17,2)		단가
		itemsChecker.put("DeclPriceCurrencyCode"    	, new CheckInfo().setCODE(false, "openapi.codecheck.CurrencyCode"));	//	O	VARCHAR(3)	통화
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
			
		String reqNo = "";
		Map<String, Object> paramMap = new HashMap<String, Object>();
			
		//주어진 정보의 기존전송여부를 확인
		paramMap = new HashMap<String, Object>();
		paramMap.put("SELLER_ID", (String)in.get("MallId"));
		paramMap.put("ORDER_ID", (String)in.get("OrderNo"));
		
		Map<String, Object> befReq = (Map<String, Object>) dao.select("openapi.dec.selectExpReqInfo", paramMap);
		String befStatus = "";
		boolean isExist = false;
		if (MapUtils.isNotEmpty(befReq)) {
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
        List<Map<String, Object>>  items = (List<Map<String, Object>>) in.get("Items");
		Map<String, Object> inItem = new HashMap<String, Object>() ;
		double sumItem = 0;
		String errMsg = "";
		for (int i=0;i<items.size();i++){
			inItem = (Map<String, Object>) items.get(i);
			if(inItem.get("UnitPrice") instanceof String){
				sumItem += Double.parseDouble((String) inItem.get("UnitPrice")) * Integer.parseInt(getStringValue(inItem.get("Quantity")));
	        }else if(inItem.get("UnitPrice") instanceof Integer){
	        	sumItem += (int) inItem.get("UnitPrice") * Integer.parseInt(getStringValue(inItem.get("Quantity")));
	        }else if(inItem.get("UnitPrice") instanceof Float){
	        	sumItem += Double.parseDouble(String.valueOf(inItem.get("UnitPrice"))) * Integer.parseInt(getStringValue(inItem.get("Quantity")));
	        }else if(inItem.get("UnitPrice") instanceof Double){
	        	sumItem += ((Double) inItem.get("UnitPrice")).doubleValue() * Integer.parseInt(getStringValue(inItem.get("Quantity")));
	        }
			
			//영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem.get("BrandName")).matches()) {
				errMsg = "[BrandName]에는,  '영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.";
			}
			
			//영문,공백,'-' 문자사용여부 체크
			if (!PTRN_ENG_NUM_SPC_ETC.matcher((CharSequence) inItem.get("GoodsDesc")).matches()) {
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
	        
		/*
		 * 수신정보외에 기초값으로 셋팅할 정보를 조회하여 설정하여 준다.
		 * 사용자정보에서 사용자명=몰명, 도메인(몰도메인)명을 가져온다.
		 */
		Map<String, Object> mallInfo = new HashMap<String, Object>();
		paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", (String)in.get("MallId"));
		mallInfo = (Map<String, Object>) dao.select("usr.selectUser", paramMap);
		
		in.put("REGIST_METHOD"    , "API");
		in.put("SELL_MALL"        , mallInfo.get("USER_NM"));
		in.put("SELL_MALL_DOMAIN" , mallInfo.get("REG_MALL_ID"));	//MALL_DOMAIN 삭제로 REG_MALL_ID 대체

		//자동전송여부를 확인하여 API로 전송된 것을 판매자설정에 우선하여 처리한다.
		String sendCheck = (String)in.get("AutoDeclaration");
		if (StringUtil.isEmpty(sendCheck)){
			//판매자 설정정보에서 자동전송에 대한 정보를 가져와서 자동전송여부를 결정한다.
			Map<String, Object> sellerInfo = null;
			paramMap = new HashMap<String, Object>();
			paramMap.put("BIZ_NO", (String) in.get("SellerPartyRegistNo"));
			sellerInfo = (Map<String, Object>) dao.select("usr.selectUser", paramMap);
			sendCheck = (String) sellerInfo.get("AUTO_SEND_YN");
		}
		/*
		if ("Y".equals(sendCheck)){
			in.put("STATUS", "01");		//신고생성요청 ('AAA1005')
		}else{
			in.put("STATUS", "");
		}*/
		in.put("SEND_CHECK", sendCheck);	//자동전송여부
		in.put("STATUS", "01");		//신고생성요청 ('AAA1005')
		reqNo = saveExpReqInfo(in, isExist);

		/*
		 * OUT 항목세팅
		 */
		out.put("RequestNo", reqNo);
		try {
			//수출신고서 생성
			AjaxModel model = new AjaxModel();
			model.setData(in);
			decService.saveGenerateExpDoc(model, "API");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String saveExpReqInfo(Map in, boolean isExist) {
		String reqNo = "";
		Map<String, Object> mainMap = null;
		if (isExist){
			reqNo = (String) in.get("REQ_NO");
			mainMap = makeMain(in);
			mainMap.put("REQ_NO"	,	reqNo);				//요청관리번호
			mainMap.put("MOD_ID"	, 	in.get("MallId"));	//수정자ID
			
			dao.update("openapi.dec.updateExpdecReq", mainMap);
		}else{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			reqNo = formatter.format(new Date())+"_"+in.get("OrderNo");
			
			mainMap = makeMain(in);
			mainMap.put("REQ_NO",    reqNo);				//요청관리번호
			mainMap.put("REG_ID", 	 in.get("MallId"));		//등록자ID
			mainMap.put("MOD_ID", 	 in.get("MallId"));		//수정자ID
			
			dao.insert("openapi.dec.insertExpdecReq", mainMap);
		}
				
		/*
		 * TB_EXPDEC_REQ_ITEM : 삭제 후 저장
		 */
		dao.delete("openapi.dec.deleteExpdecReqItem", mainMap);
		List<Map<String, Object>>  items = (List<Map<String, Object>>) in.get("Items");
		Map<String, Object> inItem = new HashMap<String, Object>() ;
		for (int i=0;i<items.size();i++){
			inItem = (Map<String, Object>) items.get(i);
			
			/*
			 * 단가계산. 단가를 받아오지 않은 경우에는 결제금액을 기준으로 수량을 나누어서 단가를 계산하여 준다
			 * 웹화면에서 입력값수정시 사용하기 위함으로 끝자리를 맞출필요는 없음.
			 * 값을 만들어 넣는건 일단 보류
			 */
			/*String declarationPrice =  (String) inItem.get("DeclarationPrice");
			String unitPrice =  (String) inItem.get("UnitPrice");
			String quantity =  (String) inItem.get("Quantity");
			if (StringUtil.isEmpty(unitPrice)){
				if (!StringUtil.isEmpty(declarationPrice)){
					if (!StringUtil.isEmpty(quantity)){ 
						unitPrice = DocUtil.calcUnitPrice(declarationPrice, quantity);
						//inItem.put("unitPrice", unitPrice);
					}
				}
			}
			
			int iDeclarationPrice = 0;
			if (StringUtil.isEmpty(declarationPrice)){
				if (!StringUtil.isEmpty(unitPrice) && !StringUtil.isEmpty(quantity)){
					iDeclarationPrice = Integer.parseInt(unitPrice) * Integer.parseInt(quantity);
					declarationPrice = String.valueOf(iDeclarationPrice);
					inItem.put("DeclarationPrice", declarationPrice);
				}
			}*/
			
			
			inItem = makeItem(inItem);
			inItem.put("REQ_NO"	,      reqNo);		//요청관리번호
			inItem.put("SN"		,      (i+1)+"");	//번호
			inItem.put("REG_ID"	, 	   in.get("MallId"));//등록자ID
			inItem.put("MOD_ID"	, 	   in.get("MallId"));//등록자ID
			
			dao.insert("openapi.dec.insertExpdecReqItem", inItem);
		}
		return reqNo;
	}
	
	private Map<String, Object> makeMain(Map<String, Object> in){

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();

		mainMap.put("STATUS",                    in.get("STATUS")                   );     //상태
		mainMap.put("MALL_ID",                   in.get("MallId")                   );     //몰ID
		mainMap.put("SELLER_ID",                 in.get("MallId")            );     //판매자ID
		//mainMap.put("SELLER_ID",                 in.get("SellerPartyId")            );     //판매자ID
		mainMap.put("ORDER_ID",                  in.get("OrderNo")                  );     //주문번호
		mainMap.put("DELIVERY_CHECK",            in.get("DeliveryStatus")           );     //배송구분
		mainMap.put("DELIVERY_METHOD",           in.get("DeliveryMeans")            );     //배송방법
		mainMap.put("DELIVERY_NO",               in.get("InvoiceNo")                );     //배송번호
		mainMap.put("REQUEST_DIV",               in.get("RequestType")              );     //요청구분
		mainMap.put("PAYMENTAMOUNT",             in.get("PaymentAmount")            );     //결제금액
		mainMap.put("PAYMENTAMOUNT_CUR",         in.get("PaymentCurrencyCode")      );     //결제통화코드
		mainMap.put("DESTINATIONCOUNTRYCODE",    in.get("DestinationCountryCode")   );     //목적국국가코드
		mainMap.put("BUYERPARTYORGNAME",         in.get("BuyerPartyEngName")        );     //구매자상호명
		mainMap.put("SUMMARY_TOTALQUANTITY",     in.get("TotalPackageQuantity")     );     //총포장갯수
		mainMap.put("SUMMARY_TOTALWEIGHT",       in.get("TotalPackageWeight")       );     //중량합계
		mainMap.put("EOCPARTYORGNAME2",          in.get("SellerPartyCompanyName")   );     //판매자상호
		mainMap.put("EOCPARTYADDRLINE",          in.get("SellerPartyAddress")       );     //판매자주소
		mainMap.put("EOCPARTYORGCEONAME",        in.get("SellerPartyCeoName")       );     //판매자대표자명
		mainMap.put("EOCPARTYLOCID",             in.get("SellerPartyZipCode")       );     //판매자우편번호
		mainMap.put("EOCPARTYPARTYIDID1",        in.get("SellerPartyRegistNo")      );     //판매자사업자등록번호
		mainMap.put("EOCPARTYPARTYIDID2",        in.get("SellerPartyCustomsId")     );     //판매자통관고유부호
		mainMap.put("APPLICANTPARTYORGID",       in.get("SellerPartyDeclarationId") );     //판매자신고인부호
		mainMap.put("GOODSLOCATIONID1",          in.get("GoodsLocZipCode")          );     //물품소재지우편번호
		mainMap.put("GOODSLOCATIONNAME",         in.get("GoodsLocAddress")          );     //물품소재지	
		
		String loadingLocationId = (String) in.get("LoadingLocPortCode");
		if (!StringUtil.isEmpty(loadingLocationId)){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CLASS_ID"	, "CUS0046");	//항구공항
			paramMap.put("CODE"		, loadingLocationId);
			Map<String, Object> LocInfo = (Map<String, Object>)dao.select("comm.getCommcodeDetail", paramMap);
			mainMap.put("LODINGLOCATIONTYPECODE",   LocInfo.get("USER_REF3"));	//(3G:USER_REF1, 4G:USER_REF3) 적재항종류
		}
		
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
		mainMap.put("TOTALDECAMOUNT",            in.get("TotalDeclAmount")          );     //총신고가격금액
		mainMap.put("TOTALDECAMOUNT_CUR",        in.get("TotalDeclAmountCurrencyCode"));   //총신고가격통화코드
		mainMap.put("SEND_CHECK",                in.get("AutoDeclaration")          );     //자동전송여부
		mainMap.put("REGIST_METHOD",             in.get("REGIST_METHOD")            );     //등록방법
		mainMap.put("SELL_MALL",                 in.get("SELL_MALL")                );     //판매몰
		mainMap.put("SELL_MALL_DOMAIN",          in.get("SELL_MALL_DOMAIN")         );     //몰도메인
		mainMap.put("EXPORTAGENTORGNAME",        in.get("ExportAgentPartyCompanyName"));   //수출대행자상호명
		mainMap.put("EXPORTAGENTORGID",       	 in.get("ExportAgentPartyCustomsId"));     //통관고유부호
		

		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}
	
	private Map<String, Object> makeItem(Map<String, Object> inItem){
		
		// 입력필드 확인설정 MAP
		Map<String, Object> itemMap = new HashMap<String, Object>();

		itemMap.put("MALL_ITEM_NO",            	 inItem.get("ItemNo")                );     //몰상품코드
		itemMap.put("ORIGINLOCID",             	 inItem.get("OriginLocCode")         );     //원산지국가코드
		itemMap.put("NETWEIGHTMEASURE",        	 inItem.get("NetWeight")             );     //중량
		itemMap.put("LINEITEMQUANTITY",        	 inItem.get("Quantity")              );     //수량
		itemMap.put("LINEITEMQUANTITY_UC",     	 inItem.get("QuantityUnitCode")      );     //수량단위
		itemMap.put("BRANDNAME_EN",            	 inItem.get("BrandName")             );     //상표명
		itemMap.put("ITEMNAME_EN",             	 inItem.get("GoodsDesc")             );     //거래품명
		itemMap.put("CLASSIDHSID",             	 inItem.get("HSCode")                );     //HS부호
		itemMap.put("PACKAGINGQUANTITY",       	 inItem.get("PackageQuantity")       );     //포장갯수
		itemMap.put("PACKAGINGQUANTITY_UC",    	 inItem.get("PackageUnitCode")       );     //포장단위
		itemMap.put("DECLARATIONAMOUNT",       	 inItem.get("DeclarationPrice")      );     //가격
		itemMap.put("BASEPRICEAMT",            	 inItem.get("UnitPrice")             );     //단가
		itemMap.put("DECLARATIONAMOUNT_CUR",   	 inItem.get("DeclPriceCurrencyCode") );     //통화코드
		itemMap.put("ATTACHCODE",              	 inItem.get("DocRefUsageText")       );     //서류첨부여부

		// 입력필드 확인설정 MAP 반환
		return itemMap;
	}
}
