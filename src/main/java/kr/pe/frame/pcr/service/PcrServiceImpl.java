package kr.pe.frame.pcr.service;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.CommonTradeDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.lang.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Parser;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import kr.pe.frame.adm.edi.service.EdiService;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.FileCommonService;
import kr.pe.frame.cmm.util.StringUtil;

/**
 * Created by jak on 2017-01-19.
 */
@Service(value = "pcrService")
public class PcrServiceImpl implements PcrService {
	Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonService")
    private CommonService commonService;
    
    @Resource(name = "fileCommonService")
    private FileCommonService fileCommonService;
    
    @Resource(name = "ediService")
    private EdiService ediService;
    
    @Resource(name = "commonTradeDAO")
    private CommonTradeDAO commonTradeDAO;

	@Override
	public AjaxModel selectPcrLic(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();

        // 필수 쿼리 아이디 체크
        if(StringUtils.isEmpty((String)param.get(Constant.QUERY_KEY.getCode()))){
            model.setStatus(-1);
            model.setMsg(commonService.getMessage("E00000001")); // 조회 쿼리 ID가 존재하지 않습니다.

            return model;
        }

        // 조회쿼리
        String qKey = (String)param.get(Constant.QUERY_KEY.getCode());
        Map<String, Object> map = (Map<String, Object>)commonDAO.selectWithCol(qKey, param);

        String email =  DocUtil.decrypt(StringUtils.defaultIfEmpty((String) map.get("SUP_EMAIL"), ""));
        if(!StringUtils.isEmpty(email)) {
        	map.put("SUP_EMAIL" , email);
        }

        model.setData(map);

        return model;
	}
	
	@Override
	public AjaxModel uploadTaxInvoice(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		Map<String, Object> fileMap = model.getDataList().get(0);
        String filePath = StringUtil.null2Str(fileMap.get("FILE_STRE_COURS")) + StringUtil.null2Str(fileMap.get("STRE_FILE_NM")) + StringUtil.null2Str(fileMap.get("FILE_SN"));
        String attachFileId = StringUtil.null2Str(fileMap.get("ATCH_FILE_ID"));

        Document doc = null;
        try(InputStream in = new FileInputStream(filePath)){
        	doc = Jsoup.parse(in, "UTF-8", "", Parser.xmlParser());
        }
		
        List taxInvoiceList = new ArrayList();
        Elements resultList = doc.select("TaxInvoice");
        String tempAddr = null;
		int len = 0;
        if(resultList.size() > 0) {
        	for(Element result : resultList) {
        		Map<String, Object> taxInvoice = new HashMap<>();
        		taxInvoice.put("DOC_ID", (String)param.get("DOC_ID"));          //전자문서번호
        		taxInvoice.put("TAX_INVOICE_ID", result.select("IssueID").text());    //세금계산서 번호
        		taxInvoice.put("ISSUE_DT" , result.select("TaxInvoiceDocument").select("IssueDateTime").text());   //작성일자
        		
        		//거래처 등록시 필요한 항목 정보
        		Element invoicer = result.select("TaxInvoiceTradeSettlement").select("InvoicerParty").get(0);
        		
        		taxInvoice.put("ORG_ID", invoicer.select("ID").text());                   //사업자등록번호	
        		taxInvoice.put("ORG_NM", invoicer.select("NameText").text());             //상호
        		taxInvoice.put("ORG_CEO_NM", invoicer.select("SpecifiedPerson").text());  //대표자명
        		taxInvoice.put("BIZ_TYPE", invoicer.select("TypeCode").text());  		  //업태
        		taxInvoice.put("BIZ_ITEM", invoicer.select("ClassificationCode").text());  //종목
        		taxInvoice.put("TEL_NO", invoicer.select("DefinedContact").select("TelephoneCommunication").text());    //전화번호
        		taxInvoice.put("MANAGER_NM", invoicer.select("DefinedContact").select("PersonNameText").text());        //담당자명
        		taxInvoice.put("MANAGE_DEPT", invoicer.select("DefinedContact").select("DepartmentNameText").text());   //담당부서
        		taxInvoice.put("MANAGER_EMAIL", invoicer.select("DefinedContact").select("URICommunication").text());   //담당자이메일
        		taxInvoice.put("ALLY_BIZ_PLACE_ID", invoicer.select("SpecifiedOrganization").select("TaxRegistrationID").text());  //종사업장번호
        		
        		len = 0;
        		tempAddr = null;
        		tempAddr = invoicer.select("SpecifiedAddress").select("LineOneText").text();
        		String tmp = PcrValidator.lengthLimit(tempAddr, 35, null);
        		taxInvoice.put("ADDR1", tmp);
				len += tmp.length();

				tmp = PcrValidator.lengthLimit(tempAddr.substring(len), 35, null);											
				taxInvoice.put("ADDR2", tmp);											
				len += tmp.length();

				tmp = PcrValidator.lengthLimit(tempAddr.substring(len), 35, null);											
				taxInvoice.put("ADDR3", tmp);										
        		
        		taxInvoice.put("REG_ID" , model.getUsrSessionModel().getUserId());
        		taxInvoice.put("MOD_ID" , model.getUsrSessionModel().getUserId());
        		Elements itemList = result.select("TaxInvoiceTradeLineItem");
        		if(itemList.size() > 0) {
        			for(Element item : itemList) {
        				taxInvoice.put("ITEM_NM", item.select("NameText").text());         	   		//품명
        				taxInvoice.put("CHARGE_DT", item.select("PurchaseExpiryDateTime").text());  //공급일자
        				taxInvoice.put("ITEM_DEF", item.select("InformationText").text()); 	   		//규격
        				taxInvoice.put("CHARGE_AMT", item.select("InvoiceAmount").text()); 	   		//공급가액
        				taxInvoice.put("TAX_AMT", item.select("CalculatedAmount").text());   	    //세액
        				taxInvoice.put("ITEM_QTY", item.select("ChargeableUnitQuantity").text());   //수량
        				taxInvoiceList.add(taxInvoice);	
        			}
        		}
        	}
        }        
		
		//유효성 체크
		StringBuffer msg =  new StringBuffer();
        for(int i=0; i < taxInvoiceList.size(); i++) {
        	Map<String, Object> map = (Map<String, Object>)taxInvoiceList.get(i);
        	if(i == 0) {
        		msg.append(PcrValidator.isValidDocId((String)map.get("DOC_ID"), "전자문서번호", true));
        	}
        	msg.append(PcrValidator.isValidComm((String)map.get("TAX_INVOICE_ID"), "세금계산서 번호", 35, true));
    		msg.append(PcrValidator.isValidDt((String)map.get("ISSUE_DT"), "작성일자", true));
    		msg.append(PcrValidator.isValidComm((String)map.get("ORG_ID"), "사업자등록번호", 10, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("ORG_NM"), "상호", 35, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("ORG_CEO_NM"), "대표자명", 35, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("BIZ_TYPE"), "업태", 105, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("BIZ_ITEM"), "종목", 105, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("TEL_NO"), "전화번호", 25, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("MANAGER_NM"), "담당자명", 35, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("MANAGE_DEPT"), "담당부서", 35, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("MANAGER_EMAIL"), "담당자 이메일", 50, true));
    		msg.append(PcrValidator.isValidComm((String)map.get("ALLY_BIZ_PLACE_ID"), "종사업장번호", 4, true));
        	String itemNm = (String)map.get("ITEM_NM");
        	msg.append(PcrValidator.isValidComm(itemNm, "품명", 35, true));
        	msg.append(PcrValidator.isValidComm((String)map.get("ITEM_DEF"), "규격", 70, true));
        	msg.append(PcrValidator.isValidDt((String)map.get("CHARGE_DT"), "공급일자", true));
        	msg.append(PcrValidator.isValidChargeAmt((String)map.get("CHARGE_AMT"), "공급가액", true));
        	msg.append(PcrValidator.isValidTaxAmt((String)map.get("TAX_AMT"), "세액", true));
        	msg.append(PcrValidator.isValidItemQty((String)map.get("ITEM_QTY"), "수량", true));
        }
        //저장
        if(StringUtils.isEmpty(msg.toString())) {
        	if(taxInvoiceList.size() > 0) {
	        	for(int i=0; i < taxInvoiceList.size(); i++) {
	            	Map<String, Object> map = (Map<String, Object>)taxInvoiceList.get(i);
	            	map.put("ATCH_FILE_ID", attachFileId);
	            	
	            	commonDAO.insert("pcr.insertTaxInvoice", map);
	            	commonDAO.insert("cust.insertCmmCust", map); //거래처 등록
	            }
        	} else {
        		msg.append("업로드 정보가 없습니다.");
        	}

        }

		model.setMsg(msg.toString());
		return model;
	}

	@Override
	public AjaxModel savePcrLic(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        String reqType = StringUtils.isNotEmpty((String)param.get("REQ_TYPE")) ? (String)param.get("REQ_TYPE") : "";
        // 필드 암호화 처리
        if(StringUtils.isNotEmpty((String)param.get("SUP_EMAIL_ID")) && StringUtils.isNotEmpty((String)param.get("SUP_EMAIL_DOMAIN"))){
        	String email = (String)param.get("SUP_EMAIL_ID") + "@" + (String)param.get("SUP_EMAIL_DOMAIN");
            param.put("SUP_EMAIL", DocUtil.encrypt(email));
        }
        
        Map<String, Object> result = (Map<String, Object>)commonDAO.select("pcr.selectPcrLicStat", param);
        param.put("MOD_ID", model.getUsrSessionModel().getUserId());
        param.put("REG_ID", model.getUsrSessionModel().getUserId());
        // 저장
        boolean newSave = false;
        if(result != null) {
        	String docStat = (String)result.get("DOC_STAT");
        	if(StringUtils.isEmpty(docStat) || (!docStat.equals("A1") && !docStat.equals("A2"))) newSave = true;
        } else {
        	newSave = true;
        }
        // 신규
        if(newSave){
        	Map<String, String> docId = commonService.createDocId("APPPCR");
			param.put("DOC_ID", docId.get("DOCNM") + docId.get("RGSTTM") + StringUtils.leftPad(docId.get("SQN"), 8, "0"));
        	if(reqType.equals("C")) { //취소신청일 경우에는 이전 전자문서번호의 정보들을 copy
        		param.put("CANCEL_SAVE", "Y");
        		commonDAO.insert("pcr.copyPcrLic", param);
        		commonDAO.insert("pcr.copyPcrDoc", param);
        		commonDAO.insert("pcr.copyPcrItem", param);
        		commonDAO.insert("pcr.copyTaxInvoice", param);
        	} else {
        		commonDAO.insert("pcr.insertPcrLic", param);
        	}
        // 수정
        }else{
            commonDAO.update("pcr.updatePcrLic", param);
        } 
        
        model.setData(param);
        return model;
	}
	
	@Override
	public AjaxModel savePcrItemList(AjaxModel model) throws Exception {
		List<Map<String, Object>> list = model.getDataList();
		String userId = model.getUsrSessionModel().getUserId();
        for(Map<String, Object> param : list){
        	param.put("MOD_ID", userId);
            commonDAO.update("pcr.updatePcrLicItem", param);
        }

        if(list.size() > 0) {
        	 Map<String, Object> param = list.get(0);
        	 Map<String, Object> result = (Map<String, Object>)commonDAO.select("pcr.selectPcrLicTotItem", param);
        	 if(result != null) {
        		 String totQty = String.valueOf(result.get("TOT_QTY"));
        		 String totAmt = String.valueOf(result.get("TOT_AMT"));
        		 if(totQty.length() > 18) {
        			 throw new BizException(commonService.getMessage("W00000080", "총수량")); 
                 }
                  
                 if(totAmt.length() > 18) {
                	 throw new BizException(commonService.getMessage("W00000079", "총금액")); 
                 }
        	 }
        	 
        	 param.put("MOD_ID", userId);
        	 commonDAO.update("pcr.updatePcrLicTotItem", param);
        	 model.setData(result);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
	}	

	@Override
	public AjaxModel saveAllPcrLicCopyInfo(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        param.put("MOD_ID", model.getUsrSessionModel().getUserId());
        param.put("REG_ID", model.getUsrSessionModel().getUserId());
        
        Map<String, String> docId = commonService.createDocId("APPPCR");
		param.put("DOC_ID", docId.get("DOCNM") + docId.get("RGSTTM") + StringUtils.leftPad(docId.get("SQN"), 8, "0"));
		
        commonDAO.insert("pcr.copyPcrLic", param);
		commonDAO.insert("pcr.copyPcrDoc", param);
		commonDAO.insert("pcr.copyPcrItem", param);
		commonDAO.insert("pcr.copyTaxInvoice", param);
		
        model.setData(param);
        return model;
	}

	@Override
	public AjaxModel deletePcrLicList(AjaxModel model) throws Exception {
        List<Map<String, Object>> dataList = model.getDataList();
        for(Map<String, Object> param : dataList){
            commonDAO.delete("pcr.deletePcrTaxInvoiceList", param);
            commonDAO.delete("pcr.deletePcrItemList", param);
            commonDAO.delete("pcr.deletePcrDocList", param);
            commonDAO.delete("pcr.deletePcrLic", param);

        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
	}

	@Override
	public AjaxModel savePcrDocAndItemList(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
        List<Map<String, Object>> list = (List)param.get("ITEM");
        
        for(Map<String, Object> pcrDoc : list){
        	pcrDoc.put("DOC_ID", (String)param.get("DOC_ID"));
        	pcrDoc.put("REG_ID", model.getUsrSessionModel().getUserId());
        	pcrDoc.put("MOD_ID", model.getUsrSessionModel().getUserId());
        	int docCnt = Integer.parseInt(String.valueOf(commonDAO.select("pcr.selectPcrDocCnt", param)));
        	if(docCnt > 999) {
        		 //수출신고필증은 최대 999 개까지 등록하실 수 있습니다.
        		throw new BizException(commonService.getMessage("W00000070"));
        	}
        	
        	int itemCnt = Integer.parseInt(String.valueOf(commonDAO.select("pcr.selectPcrItemCnt", param)));
        	if(itemCnt > 999) {
        		//구매물품은 최대 999 개까지 등록하실 수 있습니다.
        		throw new BizException(commonService.getMessage("W00000069"));
        	}
            commonDAO.insert("pcr.insertPcrDoc", pcrDoc);
            commonDAO.insert("pcr.insertPcrItem", pcrDoc);
        }
        param.put("MOD_ID",  model.getUsrSessionModel().getUserId());
        commonDAO.update("pcr.updatePcrLicTotItem", param);
        model.setCode("I00000003"); //저장되었습니다.

        return model;
	}

	@Override
	public AjaxModel deletePcrDocAndItemList(AjaxModel model) throws Exception {
		List<Map<String, Object>> dataList = model.getDataList();
		String userId = model.getUsrSessionModel().getUserId();
        for(Map<String, Object> param : dataList){
            commonDAO.delete("pcr.deletePcrDoc", param);
            commonDAO.delete("pcr.deletePcrItem", param);
        }
        
        if(dataList.size() > 0) {
       	 Map<String, Object> param = dataList.get(0);
       	 param.put("MOD_ID", userId);
       	 commonDAO.update("pcr.updatePcrLicTotItem", param);
        }
        model.setCode("I00000004"); //삭제되었습니다.
        return model;
	}

	@Override
	public AjaxModel savePcrTaxInvoice(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("REG_ID", model.getUsrSessionModel().getUserId());
		param.put("MOD_ID", model.getUsrSessionModel().getUserId());

		Map<String, Object> result = (Map<String, Object>)commonDAO.select("pcr.selectPcrTaxInvoice", param);
	    if(result != null) {
	    	commonDAO.update("pcr.updatePcrTaxInvoice", param);
	    } else {
	    	int cnt = Integer.parseInt(String.valueOf(commonDAO.select("pcr.selectPcrTaxInvoiceCnt", param)));
        	if(cnt > 999) {
        		 //세금계산서는 최대 999 개까지 등록하실 수 있습니다.
        		throw new BizException(commonService.getMessage("W00000071"));
        	}
	    	commonDAO.insert("pcr.insertTaxInvoice", param);
	    }
        model.setCode("I00000003"); //저장되었습니다.
        model.setData(param);
        return model;
	}

	@Override
	public AjaxModel savePcrSend(AjaxModel model) throws Exception {
		List<Map<String, Object>> dataList = model.getDataList();
		model = ediService.sendDoc(model);
		for(Map<String, Object> param : dataList){
			param.put("MOD_ID", model.getUsrSessionModel().getUserId());
			param.put("DOC_STAT", "C1");
	        commonDAO.update("pcr.updatePcrLicStat", param);
	    }
		return model;
	}
}
