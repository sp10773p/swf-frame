package kr.pe.frame.exp.req.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import org.apache.commons.lang.StringUtils;

import kr.pe.frame.cmm.util.StringUtil;

public class ExpDecReqValidator {
	@Resource(name = "commonDAO")
	private CommonDAO commonDAO;
	 
	private static Pattern PTRN_ENG = Pattern.compile("[a-zA-Z]+");
	private static Pattern PTRN_ENG_SPC = Pattern.compile("[a-zA-Z ]+");
	private static Pattern PTRN_ENG_NUM = Pattern.compile("[a-zA-Z0-9]+");
	private static Pattern PTRN_NUM = Pattern.compile("[0-9]+");
	private static Pattern PTRN_ENG_NUM_SPC_ETC = Pattern.compile("[a-zA-Z0-9\\p{Punct} \\t&&[^<>&]]+"); // 영문, 숫자, 공백(탭 포함), 특수문자('<', '>', '&' 제외)
	private static Pattern PTRN_ENG_SPC_ETC = Pattern.compile("[a-zA-Z.,-[ ]]+"); // 영문, 공백, '.', ',', '-'
	private static Pattern PTRN_ENG_SPC_HAN = Pattern.compile("[a-zA-Z[ ]가-힣]+"); // 영문, 공백, 한글
	private static Pattern PTRN_ENG_NUM_HAN_ETC = Pattern.compile("[a-zA-Z0-9가-힣*]+"); // 영문, 숫자, 한글, '*'

	private static String TYPE_ENG = "ENG";
	private static String TYPE_ENG_SPC = "ENG_SPC";
	private static String TYPE_ENG_NUM = "ENG_NUM";
	private static String TYPE_ENG_NUM_SPC_ETC = "ENG_NUM_SPC_ETC";
	private static String TYPE_ENG_SPC_ETC = "ENG_SPC_ETC";
	private static String TYPE_ENG_SPC_HAN = "ENG_SPC_HAN";
	private static String TYPE_ENG_NUM_HAN_ETC = "ENG_NUM_HAN_ETC";
	private static String TYPE_NUM = "NUM";
	private static String TYPE_DATE_TIME = "DATE_TIME";
	private static String TYPE_DATE = "DATE";
	private static String TYPE_TIME = "TIME";
	private static String TYPE_NONE = "";
	
	// 사업자등록번호
	public static boolean isValidRegistNo(String value, String title, boolean required) throws Exception {
		// 외국 사업자번호, 주민번호 들어올 수도 있음
		return valueCheck(value, title, TYPE_ENG_NUM, 13, false, required);
	}

	// 상호
	public static boolean isValidCompanyName(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 28, false, required);
	}

	// 대표자명
	public static boolean isValidCeoName(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_ENG_SPC_HAN, 12, false, required);
	}

	// 신고인부호
	public static boolean isValidDeclarationId(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 5, true, required);
	}

	// 통관고유부호
	public static boolean isValidCustomsId(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_ENG_NUM_HAN_ETC, 15, true, required);
	}

	// 우편번호
	public static boolean isValidZipCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 5, true, required);
	}

	// 주소
	public static boolean isValidAddress(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 300, false, required);
	}

	// 주문번호
	public static boolean isValidOrderNo(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 50, false, required);
	}

	// 상품ID
	public static boolean isValidItemNo(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 35, false, required);
	}

	// 상품명
	public static boolean isValidGoodsDesc(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_ENG_NUM_SPC_ETC, 50, false, required);
	}

	// 결제금액
	public static boolean isValidPaymentAmount(String value, String value2, String title, boolean required) throws Exception {
		return numberValueCheck(value, title, 14, 2, required);
	}

	public static boolean isMakeLocationCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 3, true, required);
	}

	public static boolean isMakeLocationSequence(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 4, true, required);
	}

	// 구매자상호명
	public static boolean isValidBuyerPartyEngName(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_ENG_SPC_ETC, 60, false, required);
	}

	// 중량
	public static boolean isValidWeight(String value, String title, boolean required) throws Exception {
		return numberValueCheck(value, title, 13, 3, required);
	}

	// 단가
	public static boolean isValidPrice(String value, String title, boolean required) throws Exception {
		return numberValueCheck(value, title, 14, 2, required);
	}

	// 도메인명
	public static boolean isValidSellMallDomain(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 50, false, required);
	}

	// 몰, 셀러 등 ID
	public static boolean isValidUserId(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 35, false, required);
	}

	// 요청구분
	public static boolean isValidRequestType(String value, String title, boolean required) throws Exception {
		if (value == null || value.equals("")) {
			if (required) {
				throw new Exception(makeMsg(title, "은(는)", "필수항목입니다."));
			}
		} else if (!value.equals("N") && !value.equals("U")) {
			throw new Exception(makeMsg(title, "에는", "'N', 'U' 값만 가능합니다."));
		}

		return true;
	}

	// 신청구분(A:정정 B:취하 C:적재기간 연장)
	public static boolean isValidApplicationTypeB(String value, String title, boolean required) throws Exception {
		if (value == null || value.equals("")) {
			if (required) {
				throw new Exception(makeMsg(title, "은(는)", "필수항목입니다."));
			}
		} else if (!value.equals("B")) {
			throw new Exception(makeMsg(title, "에는", "'B' 값만 가능합니다."));
		}

		return true;
	}

	// 정정사유코드
	public static boolean isValidAmendReasonCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 2, false, required);
	}

	// 귀책사유코드
	public static boolean isValidReasonsAttributableCode(String value, String title, boolean required) throws Exception {
		if (value == null || value.equals("")) {
			if (required) {
				throw new Exception(makeMsg(title, "은(는)", "필수항목입니다."));
			}
		} else if (!value.equals("A") && !value.equals("B") && !value.equals("C") && !value.equals("D") && !value.equals("E") && !value.equals("F") && !value.equals("G") && !value.equals("H") && !value.equals("Z")) {
			throw new Exception(makeMsg(title, "에는", "'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'Z' 값만 가능합니다."));
		}

		return true;
	}

	// 정정사유
	public static boolean isValidAmendReason(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 200, false, required);
	}

	// 수출신고번호
	public static boolean isValidExportDeclarationNo(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_ENG_NUM, 15, false, required);
	}

	// 정정항목수
	public static boolean isValidAmendItemNo(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 10, false, required);
	}

	// 세관코드
	public static boolean isValidCustomsCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 3, true, required);
	}

	// 과코드
	public static boolean isValidCustomsDeptCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 2, true, required);
	}

	// 일자
	public static boolean isValidDate(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_DATE, 8, true, required);
	}

	// 이름
	public static boolean isValidName(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 28, false, required);
	}

	// 상표명
	public static boolean isValidBrandName(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 30, false, required);
	}

	// 원산지국가코드
	public static boolean isValidOriginLocCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 2, false, required);
	}

	// 중량단위
	public static boolean isValidWeightUnitCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 3, false, required);
	}

	// 수량단위
	public static boolean isValidQuantityUnitCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 3, false, required);
	}

	// 규격
	public static boolean isValidSpecification(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 500, false, required);
	}

	// 성분
	public static boolean isValidIngredients(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 70, false, required);
	}

	// 카테고리
	public static boolean isValidCategory(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 100, false, required);
	}

	// 스펙확인 웹주소
	public static boolean isValidItemViewUrl(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 500, false, required);
	}

	public static boolean isValidAutoDeclaration(String value, String title, boolean required) throws Exception {
		if (value == null || value.equals("")) {
			if (required) {
				throw new Exception(makeMsg(title, "은(는)", "필수항목입니다."));
			}
		} else if (!value.equals("Y") && !value.equals("N")) {
			throw new Exception(makeMsg(title, "에는", "'Y', 'N' 값만 가능합니다."));
		}

		return true;
	}

	// 수량
	public static boolean isValidQuantity(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 10, false, required);
	}

	// 포장단위
	public static boolean isValidPackageUnitCode(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 2, false, required);
	}
	
	// 인도조건
	public static boolean isValidAmtCod(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 3, false, true);
	}
	// 운임금액
	public static boolean isValidFreKrw(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 12, false, false);
	}
	// 보험금액
	public static boolean isValidInsuKrw(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NUM, 12, false, false);
	}
	// 상품성분명
	public static boolean isValidComp(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 70, false, false);
	}
	
	// 주문수량단위
	public static boolean isValidUt(String value, String title, boolean required) throws Exception {
		return valueCheck(value, title, TYPE_NONE, 3, false, false);
	}
	
	public static void checkMaker(String makerNm, String makerRegId, String makerOrgId, String makePostCd, String makerLocCd, String makerLocSeq) throws Exception {
		String errorColumnNamesStr = "";
		String errorColumnDataStr = "";
		String errorMessagesStr = "";

		if(makerNm != null && makerNm.length() > 0){
			if(makerRegId == null || makerRegId.length() <= 0){
				errorColumnNamesStr += "MAKER_REG_ID{/}";
				errorColumnDataStr += "제조자사업자번호{/}";
				errorMessagesStr += "제조자사업자번호는 필수 입니다.{/}";
			}
			if(makerOrgId == null || makerOrgId.length() <= 0){
				errorColumnNamesStr += "MAKER_ORG_ID{/}";
				errorColumnDataStr += "제조자통관고유부호{/}";
				errorMessagesStr += "제조자통관고유부호는 필수 입니다.{/}";
			}
			if(makePostCd == null || makePostCd.length() <= 0){
				errorColumnNamesStr += "MAKER_POST_CD{/}";
				errorColumnDataStr += "제조장소(우편번호){/}";
				errorMessagesStr += "제조장소(우편번호)는 필수 입니다.{/}";
			}
		}else if(makerRegId != null && makerRegId.length() > 0){
			if(makerNm == null || makerNm.length() <= 0){
				errorColumnNamesStr += "MAKER_NM{/}";
				errorColumnDataStr += "제조자{/}";
				errorMessagesStr += "제조자는 필수 입니다.{/}";
			}
			if(makerOrgId == null || makerOrgId.length() <= 0){
				errorColumnNamesStr += "MAKER_ORG_ID{/}";
				errorColumnDataStr += "제조자통관고유부호{/}";
				errorMessagesStr += "제조자통관고유부호는 필수 입니다.{/}";
			}
			if(makePostCd == null || makePostCd.length() <= 0){
				errorColumnNamesStr += "MAKER_POST_CD{/}";
				errorColumnDataStr += "제조장소(우편번호){/}";
				errorMessagesStr += "제조장소(우편번호)는 필수 입니다.{/}";
			}
		}else if(makerOrgId != null && makerOrgId.length() > 0){
			if(makerNm == null || makerNm.length() <= 0){
				errorColumnNamesStr += "MAKER_NM{/}";
				errorColumnDataStr += "제조자{/}";
				errorMessagesStr += "제조자는 필수 입니다.{/}";
			}
			if(makerRegId == null || makerRegId.length() <= 0){
				errorColumnNamesStr += "MAKER_REG_ID{/}";
				errorColumnDataStr += "제조자사업자번호{/}";
				errorMessagesStr += "제조자사업자번호는 필수 입니다.{/}";
			}
			if(makePostCd == null || makePostCd.length() <= 0){
				errorColumnNamesStr += "MAKER_POST_CD{/}";
				errorColumnDataStr += "제조장소(우편번호){/}";
				errorMessagesStr += "제조장소(우편번호)는 필수 입니다.{/}";
			}
		}else if(makePostCd != null && makePostCd.length() > 0){
			if(makerNm == null || makerNm.length() <= 0){
				errorColumnNamesStr += "MAKER_NM{/}";
				errorColumnDataStr += "제조자{/}";
				errorMessagesStr += "제조자는 필수 입니다.{/}";
			}
			if(makerRegId == null || makerRegId.length() <= 0){
				errorColumnNamesStr += "MAKER_REG_ID{/}";
				errorColumnDataStr += "제조자사업자번호{/}";
				errorMessagesStr += "제조자사업자번호는 필수 입니다.{/}";
			}
			if(makerOrgId == null || makerOrgId.length() <= 0){
				errorColumnNamesStr += "MAKER_ORG_ID{/}";
				errorColumnDataStr += "제조자통관고유부호{/}";
				errorMessagesStr += "제조자통관고유부호는 필수 입니다.{/}";
			}
		}else if(makerLocCd != null && makerLocCd.length() > 0){
			if(makerNm == null || makerNm.length() <= 0){
				errorColumnNamesStr += "MAKER_NM{/}";
				errorColumnDataStr += "제조자{/}";
				errorMessagesStr += "제조자는 필수 입니다.{/}";
			}
			if(makerRegId == null || makerRegId.length() <= 0){
				errorColumnNamesStr += "MAKER_REG_ID{/}";
				errorColumnDataStr += "제조자사업자번호{/}";
				errorMessagesStr += "제조자사업자번호는 필수 입니다.{/}";
			}
			if(makerOrgId == null || makerOrgId.length() <= 0){
				errorColumnNamesStr += "MAKER_ORG_ID{/}";
				errorColumnDataStr += "제조자통관고유부호{/}";
				errorMessagesStr += "제조자통관고유부호는 필수 입니다.{/}";
			}
			if(makePostCd == null || makePostCd.length() <= 0){
				errorColumnNamesStr += "MAKER_POST_CD{/}";
				errorColumnDataStr += "제조장소(우편번호){/}";
				errorMessagesStr += "제조장소(우편번호)는 필수 입니다.{/}";
			}
		}else if(makerLocSeq != null && makerLocSeq.length() > 0){
			if(makerNm == null || makerNm.length() <= 0){
				errorColumnNamesStr += "MAKER_NM{/}";
				errorColumnDataStr += "제조자{/}";
				errorMessagesStr += "제조자는 필수 입니다.{/}";
			}
			if(makerRegId == null || makerRegId.length() <= 0){
				errorColumnNamesStr += "MAKER_REG_ID{/}";
				errorColumnDataStr += "제조자사업자번호{/}";
				errorMessagesStr += "제조자사업자번호는 필수 입니다.{/}";
			}
			if(makerOrgId == null || makerOrgId.length() <= 0){
				errorColumnNamesStr += "MAKER_ORG_ID{/}";
				errorColumnDataStr += "제조자통관고유부호{/}";
				errorMessagesStr += "제조자통관고유부호는 필수 입니다.{/}";
			}
			if(makePostCd == null || makePostCd.length() <= 0){
				errorColumnNamesStr += "MAKER_POST_CD{/}";
				errorColumnDataStr += "제조장소(우편번호){/}";
				errorMessagesStr += "제조장소(우편번호)는 필수 입니다.{/}";
			}
		}

		if (errorColumnNamesStr.equals("")) {
			return;
		} else {
			throw new Exception(errorColumnNamesStr + "{|}" + errorColumnDataStr + "{|}" + errorMessagesStr);
		}
	}

	// 동일 주문번호인 경우 결제금액, 구매자상호명, 목적국 국가코드 체크
	@SuppressWarnings("rawtypes")
	public static boolean checkDataByOrderNo(List<Map<String, Object>> list, int compareIndex) throws Exception {
		Map compareDataMap = (Map) list.get(compareIndex);
		String ORDER_ID = StringUtil.null2Str((String) compareDataMap.get("ORDER_ID"));
		String PAYMENTAMOUNT = StringUtil.null2Str((String) compareDataMap.get("PAYMENTAMOUNT"));
		String BUYERPARTYORGNAME = StringUtil.null2Str((String) compareDataMap.get("BUYERPARTYORGNAME"));
		String DESTINATIONCOUNTRYCODE = StringUtil.null2Str((String) compareDataMap.get("DESTINATIONCOUNTRYCODE"));

		String makerNm = StringUtil.null2Str((String) compareDataMap.get("MAKER_NM"));
		String makerRegId = StringUtil.null2Str((String) compareDataMap.get("MAKER_REG_ID"));
		String makerLocSeq = StringUtil.null2Str((String) compareDataMap.get("MAKER_LOC_SEQ"));
		String makerOrgId = StringUtil.null2Str((String) compareDataMap.get("MAKER_ORG_ID"));
		String makerPostCd = StringUtil.null2Str((String) compareDataMap.get("MAKER_POST_CD"));
		String makerLocCd = StringUtil.null2Str((String) compareDataMap.get("MAKER_LOC_CD"));
		
		String PAYMENTAMOUNT_CUR = StringUtil.null2Str((String) compareDataMap.get("PAYMENTAMOUNT_CUR"));
		String SELL_MALL_DOMAIN = StringUtil.null2Str((String) compareDataMap.get("SELL_MALL_DOMAIN"));
		String AMT_COD = StringUtil.null2Str((String) compareDataMap.get("AMT_COD"));
		double INSU_KRW = getDoubleValue(compareDataMap, "INSU_KRW");
		double FRE_KRW = getDoubleValue(compareDataMap, "FRE_KRW");
		
		String errorColumnNamesStr = "";
		String errorColumnDataStr = "";
		String errorMessagesStr = "";
		
		for (int idx = 0; idx < list.size(); idx++) {
			if (compareIndex == idx) {
				continue;
			}
			Map map = (Map) list.get(idx);
			String PAYMENTAMOUNT2 = StringUtil.null2Str((String) map.get("PAYMENTAMOUNT"));
			String BUYERPARTYORGNAME2 = StringUtil.null2Str((String) map.get("BUYERPARTYORGNAME"));
			String DESTINATIONCOUNTRYCODE2 = StringUtil.null2Str((String) map.get("DESTINATIONCOUNTRYCODE"));
			String ORDER_ID2 = StringUtil.null2Str((String) map.get("ORDER_ID"));

			String maNm = StringUtil.null2Str((String) map.get("MAKER_NM"));
			String maRegId = StringUtil.null2Str((String) map.get("MAKER_REG_ID"));
			String maLocSeq = StringUtil.null2Str((String) map.get("MAKER_LOC_SEQ"));
			String maOrgId = StringUtil.null2Str((String) map.get("MAKER_ORG_ID"));
			String maPostCd = StringUtil.null2Str((String) map.get("MAKER_POST_CD"));
			String maLocCd = StringUtil.null2Str((String) map.get("MAKER_LOC_CD"));
			
			String PAYMENTAMOUNT_CUR2 = StringUtil.null2Str((String) map.get("PAYMENTAMOUNT_CUR"));
			String SELL_MALL_DOMAIN2 = StringUtil.null2Str((String) map.get("SELL_MALL_DOMAIN"));
			String AMT_COD2 = StringUtil.null2Str((String) map.get("AMT_COD"));
			double INSU_KRW2 = getDoubleValue(map, "INSU_KRW");
			double FRE_KRW2 =  getDoubleValue(map, "FRE_KRW");

			if (ORDER_ID.equals(ORDER_ID2)) {
				if (!PAYMENTAMOUNT.equals(PAYMENTAMOUNT2)) {
					errorColumnNamesStr += "PAYMENTAMOUNT{/}";
					errorColumnDataStr += PAYMENTAMOUNT + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 결제금액이 다른 건이 있습니다.{/}";
				}
				if (!BUYERPARTYORGNAME.equals(BUYERPARTYORGNAME2)) {
					errorColumnNamesStr += "BUYERPARTYORGNAME{/}";
					errorColumnDataStr += BUYERPARTYORGNAME + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 구매자상호명이 다른 건이 있습니다.{/}";
				}
				if (!DESTINATIONCOUNTRYCODE.equals(DESTINATIONCOUNTRYCODE2)) {
					errorColumnNamesStr += "DESTINATIONCOUNTRYCODE{/}";
					errorColumnDataStr += DESTINATIONCOUNTRYCODE + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 목적국 국가코드가 다른 건이 있습니다.{/}";
				}

				if (makerNm != null && !"".equals(makerNm) && !makerNm.equals(maNm)) {
					errorColumnNamesStr += "MAKER_NM{/}";
					errorColumnDataStr += makerNm + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자가 다른 건이 있습니다.{/}";
				}else if((makerNm == null || "".equals(makerNm)) && (maNm != null && !"".equals(maNm))){
					errorColumnNamesStr += "MAKER_NM{/}";
					errorColumnDataStr += "제조자{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자가 다른 건이 있습니다.{/}";
				}

				if (makerRegId != null && !"".equals(makerRegId) && !makerRegId.equals(maRegId)) {
					errorColumnNamesStr += "MAKER_REG_ID{/}";
					errorColumnDataStr += makerRegId + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자사업자번호가 다른 건이 있습니다.{/}";
				}else if((makerRegId == null || "".equals(makerRegId)) && (maRegId != null && !"".equals(maRegId))){
					errorColumnNamesStr += "MAKER_REG_ID{/}";
					errorColumnDataStr += "제조자사업자번호{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자사업자번호가 다른 건이 있습니다.{/}";
				}

				if (makerLocSeq != null && !"".equals(makerLocSeq) && !makerLocSeq.equals(maLocSeq)) {
					errorColumnNamesStr += "MAKER_LOC_SEQ{/}";
					errorColumnDataStr += makerLocSeq + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자사업장일련번호가 다른 건이 있습니다.{/}";
				}else if((makerLocSeq == null || "".equals(makerLocSeq)) && (maLocSeq != null && !"".equals(maLocSeq))){
					errorColumnNamesStr += "MAKER_LOC_SEQ{/}";
					errorColumnDataStr += "제조자사업장일련번호{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자사업장일련번호가 다른 건이 있습니다.{/}";
				}

				if (makerOrgId != null && !"".equals(makerOrgId) && !makerOrgId.equals(maOrgId)) {
					errorColumnNamesStr += "MAKER_ORG_ID{/}";
					errorColumnDataStr += makerOrgId + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자통관고유부호가 다른 건이 있습니다.{/}";
				}else if((makerOrgId == null || "".equals(makerOrgId)) && (maOrgId != null && !"".equals(maOrgId))){
					errorColumnNamesStr += "MAKER_ORG_ID{/}";
					errorColumnDataStr += "제조자통관고유부호{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조자통관고유부호가 다른 건이 있습니다.{/}";
				}

				if (makerPostCd != null && !"".equals(makerPostCd) && !makerPostCd.equals(maPostCd)) {
					errorColumnNamesStr += "MAKER_POST_CD{/}";
					errorColumnDataStr += makerPostCd + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조장소(우편번호)가 다른 건이 있습니다.{/}";
				}else if((makerPostCd == null || "".equals(makerPostCd)) && (maPostCd != null && !"".equals(maPostCd))){
					errorColumnNamesStr += "MAKER_POST_CD{/}";
					errorColumnDataStr += "제조장소(우편번호){/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 제조장소(우편번호)가 다른 건이 있습니다.{/}";
				}

				if (makerLocCd != null && !"".equals(makerLocCd) && !makerLocCd.equals(maLocCd)) {
					errorColumnNamesStr += "MAKER_LOC_CD{/}";
					errorColumnDataStr += makerLocCd + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 산업단지부호가 다른 건이 있습니다.{/}";
				}else if((makerLocCd == null || "".equals(makerLocCd)) && (maLocCd != null && !"".equals(maLocCd))){
					errorColumnNamesStr += "MAKER_LOC_CD{/}";
					errorColumnDataStr += "산업단지부호{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 산업단지부호가 다른 건이 있습니다.{/}";
				}
				
				if (!PAYMENTAMOUNT_CUR.equals(PAYMENTAMOUNT_CUR2)) {
					errorColumnNamesStr += "PAYMENTAMOUNT_CUR{/}";
					errorColumnDataStr += PAYMENTAMOUNT_CUR + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 결제통화코드가 다른 건이 있습니다.{/}";
				}
				
				if (!SELL_MALL_DOMAIN.equals(SELL_MALL_DOMAIN2)) {
					errorColumnNamesStr += "SELL_MALL_DOMAIN{/}";
					errorColumnDataStr += SELL_MALL_DOMAIN + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 도메인명이 다른 건이 있습니다.{/}";
				}
				
				if (!AMT_COD.equals(AMT_COD2)) {
					errorColumnNamesStr += "AMT_COD{/}";
					errorColumnDataStr += AMT_COD + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 인도조건이 다른 건이 있습니다.{/}";
				}
				
				if (INSU_KRW != INSU_KRW2) {
					errorColumnNamesStr += "INSU_KRW{/}";
					errorColumnDataStr += INSU_KRW + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 보험료원화가 다른 건이 있습니다.{/}";
				}
				
				if (FRE_KRW != FRE_KRW2) {
					errorColumnNamesStr += "FRE_KRW{/}";
					errorColumnDataStr += FRE_KRW + "{/}";
					errorMessagesStr += "동일 주문번호(" + ORDER_ID + ") 건 중에 운임원화가 다른 건이 있습니다.{/}";
				}
			}
		}

		if (errorColumnNamesStr.equals("")) {
			return true;
		} else {
			throw new Exception(errorColumnNamesStr + "{|}" + errorColumnDataStr + "{|}" + errorMessagesStr);
		}
	}

	private static double getDoubleValue(Map map, String col) {
		double val = 0;
		try{
			val = ((BigDecimal) map.get(col)).doubleValue();
		}catch(Exception e){
			val = 0;
		}
		return val;
	}

	/**
	 * 입력값을 필수여부, 길이, 검증타입에 따라 체크한다.
	 *
	 * @param value 입력값
	 * @param name 입력값 이름
	 * @param type 검증타입
	 * @param size 최대바이트
	 * @param sameSizeOnly 입력값의 바이트수와 최대바이트수가 일치해야만 하는지 여부
	 * @param required 필수 여부
	 * @return
	 * @throws Exception
	 */
	private static boolean valueCheck(String value, String name, String type, int size, boolean sameSizeOnly, boolean required) throws Exception {
		String errMsg = null;

		if (value == null || value.length() == 0) {
			if (required) {
				errMsg = makeMsg(name, "은(는)", "필수항목입니다.");
			}
		} else if (sameSizeOnly && value.getBytes("MS949").length != size) {
			errMsg = makeMsg(name, "의", "길이가 맞지 않습니다. " + size + " 자리만 가능합니다.");
		} else if (!sameSizeOnly && value.getBytes("MS949").length > size) {
			errMsg = makeMsg(name,  "의", "길이가 너무 깁니다. 최대바이트(" + size + ")");
		} else if (TYPE_ENG.equals(type) && !PTRN_ENG.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "영문만 입력 가능합니다.");
		} else if (TYPE_ENG_SPC.equals(type) && !PTRN_ENG_SPC.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "영문, 공백만 입력 가능합니다.");
		} else if (TYPE_ENG_NUM.equals(type) && !PTRN_ENG_NUM.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "영문, 숫자만 입력 가능합니다.");
		} else if (TYPE_NUM.equals(type) && !PTRN_NUM.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "숫자만 입력 가능합니다.");
		} else if (TYPE_DATE_TIME.equals(type) && !isDateTime(value, "yyyyMMddHHmmss")) {
			errMsg = makeMsg(name, "의", "형식(yyyyMMddHHmmss : 14자리)이 맞지 않습니다.");
		} else if (TYPE_DATE.equals(type) && !isDateTime(value, "yyyyMMdd")) {
			errMsg = makeMsg(name, "의", "형식(yyyyMMdd : 8자리)이 맞지 않습니다.");
		} else if (TYPE_TIME.equals(type) && !isDateTime(value, "HHmmss")) {
			errMsg = makeMsg(name, "의", "형식((HHmmss : 6자리)이 맞지 않습니다.");
		} else if (TYPE_ENG_NUM_SPC_ETC.equals(type) && !PTRN_ENG_NUM_SPC_ETC.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "영문, 숫자, 공백, 특수문자('<', '>', '&' 제외)만 가능합니다.");
		} else if (TYPE_ENG_SPC_ETC.equals(type) && !PTRN_ENG_SPC_ETC.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "영문, 공백, 특수문자('.', ',', '-')만 가능합니다.");
		} else if (TYPE_ENG_SPC_HAN.equals(type) && !PTRN_ENG_SPC_HAN.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "한글, 영문, 공백만 가능합니다.");
		} else if (TYPE_ENG_NUM_HAN_ETC.equals(type) && !PTRN_ENG_NUM_HAN_ETC.matcher(value).matches()) {
			errMsg = makeMsg(name, "에는", "한글, 영문, 숫자, '*'만 가능합니다.");
		}

		if (errMsg != null) {
			throw new Exception(errMsg);
		}

		return true;
	}

	/**
	 * 숫자 입력값을 필수여부, 정수부/소수부 길이에 따라 체크한다.
	 *
	 * @param value 입력값
	 * @param name 입력값 이름
	 * @param type 검증타입
	 * @param size 최대바이트
	 * @param sameSizeOnly 입력값의 바이트수와 최대바이트수가 일치해야만 하는지 여부
	 * @param required 필수 여부
	 * @return
	 * @throws Exception
	 */
	private static boolean numberValueCheck(String value, String name, int numberSize, int decimalSize, boolean require) throws Exception {
		String errMsg = null;

		if (value == null || value.length() == 0) {
			if (require) {
				errMsg = makeMsg(name, "은(는)", "필수항목입니다.");
			}
		} else if (numberSize < 0 || decimalSize < 0) {
			errMsg = makeMsg(name, "의", "숫자 자리수 설정이 잘못 되었습니다.");
		} else if (value.length() > (numberSize + decimalSize + (decimalSize > 0 ? 1 : 0))) {
			errMsg = makeMsg(name, "의", "길이가 너무 깁니다. 소수점 제외 최대 " + (numberSize + decimalSize) + "자리로 입력해 주세요.");
		} else {
			Pattern numberPoint = Pattern.compile("[0-9]{1," + numberSize + "}" + (decimalSize > 0 ? "(\\.[0-9]{1," + decimalSize + "})?" : ""));
			if (!numberPoint.matcher(value).matches()) {
				errMsg = makeMsg(name, "의", "값이 올바르지 않습니다. 정수 부분은 최대 " + numberSize + "자리, 소수 부분은 최대 " + decimalSize + "자리로 입력해 주세요.");
			}
		}

		if (errMsg != null) {
			throw new Exception(errMsg);
		}

		return true;
	}

	private static boolean isDateTime(String value, String formatStr) {
		boolean rslt = false;
		try {
			SimpleDateFormat format = new SimpleDateFormat(formatStr);
			Date date = format.parse(value);
			SimpleDateFormat format1 = new SimpleDateFormat(formatStr);
			rslt = format1.format(date).equals(value);
		} catch (Exception e) {
			;
		}
		return rslt;
	}

	private static String makeMsg(String title, String postposition, String msg) {
		if (title == null || title.equals("")) {
			return msg;
		}

		return title + postposition + " " + msg;
	}
	
	// 목적국 국가코드
	public boolean isValidDestinationCountryCode(String value, String title, boolean required) throws Exception {
		if (valueCheck(value, title, TYPE_ENG, 2, true, required)) {
			if (required == false && (value == null || value.equals(""))) {
				return true;
			} else if (existsInCountryCdDb(value)) { // DB에 존재하면
				return true;
			} else {
				throw new Exception (makeMsg(title, "이(가)", "유효하지 않습니다."));
			}
		}

		return false;
	}
	
	// 국가코드 체크
    private boolean existsInCountryCdDb(String countryCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CLASS_ID", "CUS0005"); // 국가코드
        map.put("CODE", countryCode);
       
        String CODE = (String)commonDAO.select("commonValidator.selectCommonCode", map);

        if (CODE != null) {
            return true;
        } else {
            return false;
        }
    }

    public static boolean isValidAmtCodInsuFre(String amtCod, String freKrw, String insuKrw, String title)  throws Exception {
    	if (StringUtils.isEmpty(amtCod)) {
    		amtCod = "FOB";
		}
    	
    	if(amtCod.equals("CIF")||amtCod.equals("CIP")||amtCod.equals("DAF")||amtCod.equals("DDP")||amtCod.equals("DDU")||amtCod.equals("DEQ")||amtCod.equals("DES")||amtCod.equals("DAT")||amtCod.equals("DAP")){
			if(StringUtils.isEmpty(insuKrw)|| Integer.parseInt(insuKrw) <= 0 || StringUtils.isEmpty(freKrw) || Integer.parseInt(freKrw) <= 0){
				throw new BizException("인도조건이 "+ amtCod+"인 경우에 운임, 보험료 둘다 0보다 커야 합니다.");
			}
		}else if(amtCod.equals("CIN")){
			if(StringUtils.isEmpty(insuKrw)||Integer.parseInt(insuKrw) <= 0 || (!StringUtils.isEmpty(freKrw) && Integer.parseInt(freKrw) > 0 )){
				throw new BizException("인도조건이 "+ amtCod+"이면 보험료는 0보다 커야하고, 운임은 0이어야 합니다.");
			}
		}else if(amtCod.equals("CFR")||amtCod.equals("CPT")){
			if((!StringUtils.isEmpty(insuKrw) && Integer.parseInt(insuKrw) > 0) || StringUtils.isEmpty(freKrw) || Integer.parseInt(freKrw) <= 0){
				throw new BizException("인도조건이 "+ amtCod+"이면 보험료는 0이어야 하고, 운임은 0보다 커야 합니다.");
			}
		}else if(amtCod.equals("FOB")||amtCod.equals("EXW")||amtCod.equals("FAS")||amtCod.equals("FCA")){
			if((!StringUtils.isEmpty(insuKrw) && Integer.parseInt(insuKrw) > 0) || (!StringUtils.isEmpty(freKrw) && Integer.parseInt(freKrw) > 0)){
				throw new BizException("인도조건이 "+ amtCod+"인 경우에는 운임,보험료 둘다 0이어야 합니다.");
			}
		}
    	
    	return true;
	}
    
    public static boolean checkDataByOrderNoAmt(List<Map<String, Object>> list, int compareIndex) throws Exception {
		Map compareDataMap = (Map) list.get(compareIndex);
		String ORDER_ID = (String) compareDataMap.get("ORDER_ID");
		String PAYMENTAMOUNT = (String) compareDataMap.get("PAYMENTAMOUNT");
		int SUM_ATM = 0;
		
		for (int idx = 0; idx < list.size(); idx++) {
			Map map = (Map) list.get(idx);
			String ORDER_ID2 = (String) map.get("ORDER_ID");
			String LINEITEMQUANTITY2 = (String) map.get("LINEITEMQUANTITY");
			String DECLARATIONAMOUNT2 = (String) map.get("DECLARATIONAMOUNT");
			int ITEM_AMT2 = Integer.parseInt(LINEITEMQUANTITY2) * Integer.parseInt(DECLARATIONAMOUNT2);
			if (ORDER_ID.equals(ORDER_ID2)) {
				SUM_ATM += ITEM_AMT2;
			}
		}
		if (SUM_ATM != Integer.parseInt(PAYMENTAMOUNT)) {
			throw new BizException("동일한 주문 번호의 합계(주문수량 * 가격)와 결제금액은 동일해야 합니다. [ 결제금액("+PAYMENTAMOUNT+") , 합계금액("+SUM_ATM+") ]");
		}
		return true;
	}
	
}
