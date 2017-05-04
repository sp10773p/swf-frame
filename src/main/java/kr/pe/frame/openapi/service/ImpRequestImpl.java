package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.service.AsyncService;
import kr.pe.frame.exp.imp.service.ImpService;
import kr.pe.frame.openapi.model.CheckInfo;

/**
 * 반품수입요청 OPEN API Service
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
public class ImpRequestImpl extends OpenAPIService {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "impService")
    ImpService impService;
    
    @Autowired
    AsyncService asyncService;

	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map dLC = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		dLC.put("SellerPartyId", new CheckInfo().setVARCHAR("35", true));
		dLC.put("OrderNo", new CheckInfo().setVARCHAR("50", true));
		dLC.put("RequestType", new CheckInfo().setVARCHAR("1", true));
		dLC.put("ApplicationId", new CheckInfo().setCODE(true, "openapi.codecheck.CustomsUseApplicantID"));
		dLC.put("CustomsCode", new CheckInfo().setCODE(false));
		dLC.put("CustomsDeptCode", new CheckInfo().setCODE(false));
		dLC.put("MasterBLNo", new CheckInfo().setVARCHAR("20", false));
		dLC.put("BLNo", new CheckInfo().setVARCHAR("20", true));
		dLC.put("MRNNo", new CheckInfo().setVARCHAR("19", false));
		dLC.put("ImportPartyCompanyName", new CheckInfo().setVARCHAR("28", true));
		dLC.put("ImportPartyCustomsId", new CheckInfo().setVARCHAR("15", false));
		dLC.put("ImportPartyTypeCode", new CheckInfo().setCODE(true));
		dLC.put("PayerCompanyName", new CheckInfo().setVARCHAR("28", true));
		dLC.put("PayerCeoName", new CheckInfo().setVARCHAR("12", true));
		dLC.put("PayerPostNo", new CheckInfo().setVARCHAR("5", false));
		dLC.put("PayerAddress", new CheckInfo().setVARCHAR("150", true));
		dLC.put("PayerCustomsId", new CheckInfo().setVARCHAR("15", false));
		dLC.put("PayerRegistNo", new CheckInfo().setVARCHAR("13", true));
		dLC.put("PayerTelNumber", new CheckInfo().setVARCHAR("40", true));
		dLC.put("PayerEmail", new CheckInfo().setVARCHAR("100", false));
		dLC.put("BuyerPartyEngName", new CheckInfo().setVARCHAR("60", false));
		dLC.put("BuyerPartyCountryCode", new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode"));
		dLC.put("BuyerPartyId", new CheckInfo().setVARCHAR("13", false));
		dLC.put("PaymentTypeCode", new CheckInfo().setCODE(false));
		dLC.put("DeclarationType", new CheckInfo().setCODE(false));
		dLC.put("TransactionType", new CheckInfo().setCODE(false));
		dLC.put("ImportType", new CheckInfo().setCODE(false));
		dLC.put("CertificateOfOriginCode", new CheckInfo().setCODE(false));
		dLC.put("ValueDeclarationCode", new CheckInfo().setCODE(false, new String[]{"Y", "N"}));
		dLC.put("TotalPackageWeight", new CheckInfo().setNUMERIC("16,3", true));
		dLC.put("TotalPackageQuantity", new CheckInfo().setNUMERIC("8", false));
		dLC.put("TotalPackageUnitCode", new CheckInfo().setCODE(false, "openapi.codecheck.PackageUnitCode"));
		dLC.put("ArrivalPortCode", new CheckInfo().setCODE(false, "openapi.codecheck.PortCode"));
		dLC.put("TransportMeansCode", new CheckInfo().setCODE(false));
		dLC.put("TransportCaseCode", new CheckInfo().setCODE(false));
		dLC.put("DepartureCountryCode", new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode"));
		dLC.put("CarrierName", new CheckInfo().setVARCHAR("20", false));
		dLC.put("CarrierCountryCode", new CheckInfo().setCODE(false, "openapi.codecheck.CountryCode"));
		dLC.put("DeliveryTermsCode", new CheckInfo().setCODE(false));
		dLC.put("PaymentCurrencyCode", new CheckInfo().setCODE(true, "openapi.codecheck.CurrencyCode"));
		dLC.put("PaymentAmount", new CheckInfo().setNUMERIC("15,2", true));
		dLC.put("PaymentTypeCode", new CheckInfo().setVARCHAR("2", true));
		dLC.put("FreightAmount", new CheckInfo().setNUMERIC("18", false));
		dLC.put("InsuranceAmount", new CheckInfo().setNUMERIC("18", false));
		dLC.put("OtherChargeAmount", new CheckInfo().setNUMERIC("18", false));
		dLC.put("DeductionAmount", new CheckInfo().setNUMERIC("18", false));
		dLC.put("AuthenticatorNotice", new CheckInfo().setVARCHAR("1000", false));
		
		CheckInfo itemList = new CheckInfo().setLIST(false);
		Map iLC = itemList.getSubCheckers();
		dLC.put("ItemList", itemList);
		
		iLC.put("ItemNo", new CheckInfo().setVARCHAR("2", false));
		iLC.put("ExportDeclarationNo", new CheckInfo().setVARCHAR("15", true));
		iLC.put("ExportDeclarationRanNo", new CheckInfo().setVARCHAR("3", true));
		iLC.put("ExportDeclarationItemNo", new CheckInfo().setVARCHAR("2", true));
		iLC.put("Quantity", new CheckInfo().setNUMERIC("14,1", true));
		iLC.put("CustomsTaxDeductCode", new CheckInfo().setCODE(true, new String[]{"Y", "N"}));
		iLC.put("ValueAddedTaxTypeCode", new CheckInfo().setCODE(true, new String[]{"Y", "N"}));
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) throws Exception {
		String[] mstMapping = new String[]{
				"SellerPartyId#SELLER_ID", "OrderNo#ORDER_ID", "ApplicationId#RPT_MARK", "CustomsCode#CUS", "CustomsDeptCode#SEC", "MasterBLNo#MAS_BLNO", "BLNo#BLNO", "MRNNo#MRN_NO", "ImportPartyCompanyName#IMP_FIRM", "ImportPartyCustomsId#IMP_TGNO", 
				"ImportPartyTypeCode#IMP_DIVI", "PayerCompanyName#NAB_FIRM", "PayerCeoName#NAB_NAME", "PayerPostNo#NAB_PA_MARK", "PayerAddress#NAB_ADDR", "PayerCustomsId#NAB_TGNO", "PayerRegistNo#NAB_SDNO", "PayerTelNumber#NAB_TELNO", "PayerEmail#NAB_EMAIL", "BuyerPartyEngName#SUP_FIRM", 
				"BuyerPartyCountryCode#SUP_ST", "BuyerPartyId#SUP_MARK", "PaymentTypeCode#LEV_FORM", "DeclarationType#RPT_DIVI_MARK", "TransactionType#EXC_DIVI_MARK", "ImportType#IMP_KI_MARK", "ValueDeclarationCode#ORI_ST_PRF_YN", "CertificateOfOriginCode#AMT_RPT_YN", "TotalPackageWeight#TOT_WT", "TotalPackageQuantity#TOT_PACK_CNT", 
				"TotalPackageUnitCode#TOT_PACK_UT", "ArrivalPortCode#ARR_MARK", "TransportMeansCode#TRA_MET", "TransportCaseCode#TRA_CTA", "DepartureCountryCode#FOD_ST_ISO", "CarrierName#SHIP_NM", "CarrierCountryCode#SHIP_ST_ISO", "DeliveryTermsCode#CON_COD", "PaymentCurrencyCode#CON_CUR", "PaymentAmount#CON_AMT", 
				"PaymentTypeCode#CON_KI", "FreightAmount#FRE_AMT", "InsuranceAmount#INSU_AMT", "OtherChargeAmount#ADD_AMT", "DeductionAmount#SUB_AMT", "AuthenticatorNotice#REQ_TXT"
		};
		
		String[] itemMapping = new String[]{
				"ExportDeclarationNo#EXP_RPT_NO", "ExportDeclarationRanNo#EXP_RAN_NO", "ExportDeclarationItemNo#EXP_SIL",  
				"Quantity#USE_QTY", "CustomsTaxDeductCode#GS_YN", "ValueAddedTaxTypeCode#VAT_YN"
		};
		
		try{ 
			for(String itemM : mstMapping) {
				String[] mItemM = itemM.split("#");
				
				in.put(mItemM[1], in.get(mItemM[0]));
				in.remove(mItemM[0]);
			}
			
			List<Map> itemIn = (List<Map>) in.get("ItemList");
			for(Map item : itemIn) {
				for(String itemM : itemMapping) {
					String[] mItemM = itemM.split("#");
					
					item.put(mItemM[1], item.get(mItemM[0]));
					item.remove(mItemM[0]);
				}
			}
			
			impService.saveImpReqApi(in);

	        String title    = "goGlobal 의뢰관리번호[" + in.get("REQ_NO") + "]의 반품수입신고 의뢰합니다.";
	        String vmName   = "req_impreq_mail.html";
	        
	        Map cus = (Map) dao.select("imp.selectCustoms", in.get("RPT_MARK"));			
	        
	        Map mailParam = new HashMap();
	        mailParam.put("REQ_NO", in.get("REQ_NO"));
	        mailParam.put("BLNO", in.get("BLNO"));
	        mailParam.put("IMP_FIRM", in.get("IMP_FIRM"));
	        mailParam.put("NAB_TELNO", in.get("NAB_TELNO"));
	        
			asyncService.asyncSendSimpleMail(DocUtil.decrypt(StringUtils.defaultIfEmpty((String) cus.get("EMAIL"), "")), title, vmName, mailParam);
		} catch(BizException e) {
			out.put(RESULT_TYPE_CODE, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION, e.getMessage());
		}
	}
}
