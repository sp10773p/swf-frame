package kr.pe.frame.openapi.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;

/**
 * 반품수입정보 OPEN API Service
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@Service
@SuppressWarnings({"rawtypes", "unchecked"})
public class ImpInfoImpl extends OpenAPIService {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "commonDAO")
    private CommonDAO dao;

	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("SellerPartyId", new CheckInfo().setVARCHAR("35", true));
		docListChecker.put("OrderNo", new CheckInfo().setVARCHAR("50", true));
		docListChecker.put("DocumentTypeCode", new CheckInfo().setVARCHAR("3", true));
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
		String[] mstMapping = new String[]{
				"ImportDeclarationNo#RPT_NO", "DeclarationDate#RPT_DAY", "CustomsCode#CUS", "CustomsDeptCode#SEC", "BLNo#BLNO", "BLSplitCode#BL_YN", "CargoControlNo#MRN_MSN_HSN", "ArrivalDate#ARR_DAY", "WarehouseArrivalDate#INC_DAY", 
				"CollectTypeCode#LEV_FORM", "ApplicationCompanyName#RPT_FIRM", "ApplicationPartyCeoName#RPT_NAME", "ImportPartyCompanyName#IMP_FIRM", "ImportPartyCustomsId#IMP_TGNO", "ImportPartyTypeCode#IMP_DIVI", "PayerCompanyName#NAB_FIRM", "PayerCeoName#NAB_NAME", "PayerPostNo#NAB_PA_MARK", "PayerAddress#NAB_ADDR1", 
				"PayerCustomsId#NAB_TGNO", "PayerRegistNo#NAB_SDNO", "BuyerPartyEngName#SUP_FIRM", "BuyerPartyCountryCode#SUP_ST", "BuyerPartyId#SUP_MARK", "GovernmentProcedureCode#TG_PLN_MARK", "DeclarationType#RPT_DIVI_MARK", "TransactionType#EXC_DIVI_MARK", "ImportType#IMP_KI_MARK", "CertificateOfOriginCode#ORI_ST_PRF_YN", 
				"ValueDeclarationCode#AMT_RPT_YN", "TotalPackageWeight#TOT_WT", "TotalPackageQuantity#TOT_PACK_CNT", "TotalPackageUnitCode#TOT_PACK_UT", "ArrivalPortCode#ARR_MARK", "TransportMeansCode#TRA_MET", "TransportCaseCode#TRA_CTA", "DepartureCountryCode#FOD_MARK", "CarrierName#SHIP", "CarrierCountryCode#ST_CODE", 
				"MasterBLNo#MAS_BLNO", "CarrierCompanyId#TRA_CHF_MARK", "InspectionLocationCode#CHK_PA_MARK", "InspectionLocationNo#CHK_PA", "TotalRan#TOT_RAN_CNT", "DeliveryTermsCode#CON_COD", "PaymentCurrencyCode#CON_CUR", "PaymentExchangeRate#CON_RATE", "PaymentAmount#CON_TOT_AMT", "PaymentTypeCode#CON_KI", 
				"TotalDeclAmountKRW#TOT_TAX_USD", "TotalDeclAmountUSD#TOT_TAX_KRW", "FreightAmount#FRE_KRW", "InsuranceAmount#INSU_KRW", "OtherChargeAmount#AD_CST_KRW", "DeductionAmount#SUB_CST_KRW", "TotalCustomsTax#TOT_GS", "TotalConsumptionTax#TOT_TS", "TotalLiquorTax#TOT_HOF", "TotalTransportationTax#TOT_GT", 
				"TotalEducationTax#TOT_KY", "TotalRuralSpecialTax#TOT_NT", "TotalValueAddedTax#TOT_VAT", "TotalDelayTax#TOT_DLY_TAX", "TotalNotDeclarationTax#TOT_ADD_TAX", "TotalTax#TOT_TAX_SUM", "PaymentNoticeNo#NAB_NO", "PaymentNoticeIssueDate#NAB_DELI_DAY", "TotalVATBaseAmount#VAT_TAX_CT", "TotalVATExemptionBaseAmount#VAT_FREE_CT", 
				"ExpressCompanyId#SP_DELI", "CustomerNotice#CUS_NOTICE", "AuthenticatorId#JU_NAME", "AuthenticatorName#JU_MARK", "CustomsReceiveDate#RC_DAY", "CustomsLicenseDate#LIS_DAY"
		};
		
		String[] ranMapping = new String[]{
				"RanNo#RAN_NO", "HSCode#HS", "HSGoodsDesc#STD_GNAME", "GoodsDesc#EXC_GNAME", "BrandCode#STD_CODE", "BrandName#MODEL_GNAME", "AttachYN#ATT_YN", "DeclAmountKRW#TAX_KRW", "DeclAmountUSD#TAX_USD", "NetWeight#SUN_WT", 
				"NetWeightUnitCode#SUN_UT", "Quantity#QTY", "QuantityUnitCode#QTY_UT", "RefundQuantity#REF_WT", "RefundQuantityUnitCode#REF_UT", "ResponsibleAgencyId1#AFT_CHK_CHF1", "ResponsibleAgencyId2#AFT_CHK_CHF2", "ResponsibleAgencyId3#AFT_CHK_CHF3", "OriginCountryCode#ORI_ST_MARK1", "OriginMarkCode1#ORI_ST_MARK2", 
				"OriginMarkCode2#ORI_ST_MARK3", "OriginMarkCode3#ORI_ST_MARK4", "COIssueDate#ORI_ST_DAY", "COIssueID#ORI_ST_NO", "COIssueAgencyName#ORI_ST_CHF", "SpecialTaxCountBasic#SP_TAX_BASIS", "CustomsTaxCode#GS_DIVI", "CustomsTaxRate#GS_RATE", "CustomsTaxBasicAmount#UPI_TAX", "CustomsTaxDeductRate#GS_RMV_RATE", 
				"CustomsTax#GS", "CustomsTaxDeductAmount#GS_RMV", "CustomsTaxDeductCode#GS_RMV_MARK", "CustomsTaxDeductTypeCode#GS_RMV_DIVI", "InternalTaxTypeCode#NG_DIVI", "InternalTaxKindCode#NG_KI_DIVI", "InternalTaxCode#NG_MARK", "InternalTaxRate#NG_RATE", "InternalTax#NG_RMV_AMT", "InternalTaxDeductAmount#NG", 
				"ConsumptionTaxExemptionCode#TS_FREE_MARK", "ConsumptionTaxBasicPrice#TS_CET_SUB", "ConsumptionTax#TS", "TransportationTax#GT", "LiquorTax#HOF", "EducationTaxTypeCode#KY_DIVI", "EducationTaxKindCode#KY_KI_DIVI", "EducationTaxDeductAmount#KY_RMV_AMT", "EducationTaxRate#KY_RATE", "EducationTax#KY", 
				"RuralSpecialTaxTypeCode#NT_DIVI", "RuralSpecialTaxKindCode#NT_KI_DIVI", "RuralSpecialTax#NT", "RuralSpecialTaxRate#NT_RATE", "ValueAddedTaxRate#VAT_RATE", "ValueAddedTaxTypeCode#VAT_DIVI", "ValueAddedTaxKindCode#VAT_KI_DIVI", "ValueAddedTax#VAT", "ValueAddedTaxDeductCode#VAT_RMV_MARK", "ValueAddedTaxDeductAmount#VAT_RMV", 
				"ValueAddedTaxDeductRate#VAT_RMV_RATE", "CustomsTaxBasicCode#GS_CET", "VATBaseAmount#VAT_TAX_CT", "VATExemptionBaseAmount#VAT_FREE_CT", "ExpressInspectionCode#SP_DELI", "InspectionChangeTypeCode#CHK_MET_CH", "TotalItemCount#TOT_SIZE_CNT", "TotalExportItemCount#TOT_EXP_CNT", "NotRequirementItemCount#TOT_C4_CNT", "AdditionalDocumentId#YONGDO_NO", 
				"COIssueLocCode#ORI_ST_STNCD", "COIssueLocName#ORI_ST_STN", "COIssuerName#ORI_ST_NAME", "CORuleCode#ORI_ST_MARK5", "COCriteriaCode#ORI_ST_MARK6", "COTotalQuantityQuantity#ORI_ST_TOTQTY", "COUsageQuantityQuantity#ORI_ST_QTY", "COTotalGrossMassMeasure#ORI_ST_TOTWT", "COUsageGrossMassMeasure#ORI_ST_WT", "COSplitIndicatorCode#ORI_ST_PARTYN", 
				"StandardGoodsDescCode#ITEMCDSEND", "CONonDescriptionReasonCode#ORI_ST_EXEMPT_CD", "COIssueCountryCode#ORI_ST_ISO", "UsedMaterialCode#MG_DIVI", "ItemRanNo#MG_RANNO", "LiquorTaxExemptionCode#HOF_FREE_MARK", "InsoectionRequireCode#CS_REQ_MARK"
		};
		
		String[] itemMapping = new String[]{
				"ItemNo#SIL", "ItemCode#RG_CODE", "GoodsName#IMP_GNAME1", "Component#COMPOENT1", "ItemQuantity#QTY", "ItemQuantityUnitCode#UT", "UnitPrice#UPI", "Amount#AMT", "RefundId#REF_NO", "RepeatImportId#D26_RPT_NO"
		};
		
		Map param = new HashMap();
		param.put("SELLER_ID", in.get("SellerPartyId"));
		param.put("ORDER_ID", in.get("OrderNo"));
		
		List<Map> mst = dao.list("imp.selectImpRes_Api", param);
		
		if(mst == null || mst.size() == 0) {
			out.put(RESULT_TYPE_CODE, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION, "주문번호(OrderNo)[" + in.get("OrderNo") + "]의 반품수입신고 정보가 존재하지 않습니다.");
			
			return;
		}
		
		for(String item : mstMapping) {
			String[] mItem = item.split("#");
			
			out.put(mItem[0], mst.get(0).get(mItem[1]));
		}
		
		List<Map> ranOut = new ArrayList();
		out.put("RanList", ranOut);
		
		param.put("RPT_NO", mst.get(0).get("RPT_NO"));
		List<Map> ran = dao.list("imp.selectImpResRan", param);
		
		for(Map ranItem : ran) {
			Map ranItemOut = new HashMap();
			ranOut.add(ranItemOut);
			
			for(String item : ranMapping) {
				String[] mItem = item.split("#");
				
				ranItemOut.put(mItem[0], ranItem.get(mItem[1]));
			}
			
			List<Map> itemOut = new ArrayList();
			ranItemOut.put("ItemList", itemOut);
			
			param.put("RAN_NO", ranItem.get("RAN_NO"));
			List<Map> item = dao.list("imp.selectImpResRanItem", param);
			
			for(Map itemItem : item) {
				Map itemItemOut = new HashMap();
				itemOut.add(itemItemOut);
				
				for(String itemI : itemMapping) {
					String[] mItem = itemI.split("#");
					
					itemItemOut.put(mItem[0], itemItem.get(mItem[1]));
				}
			}
		}
	}
}
