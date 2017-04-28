package kr.pe.frame.basic.prod.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.CommonValidatorService;
import kr.pe.frame.cmm.excel.ExcelReader;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.util.StringUtil;

/**
 * 사용자 화면: 기초정보 > 상품관리 구현 클래스
 * @author 정안균
 * @since 2017-03-08
 * @version 1.0
 * @see ProdService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.08  정안균  최초 생성
 *
 * </pre>
 */
@Service(value = "prodService")
@SuppressWarnings("unchecked")
public class ProdServiceImpl implements ProdService {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "commonDAO")
    private CommonDAO commonDAO;
	
	@Resource(name = "commonService")
    private CommonService commonService;
	
	@Resource(name = "commonValidator")
    private CommonValidatorService commonValidator;
	
	@Resource(name = "excelReader")
    private ExcelReader excelReader;

	@Override
	public AjaxModel saveItemInfo(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("MOD_ID", model.getUsrSessionModel().getUserId());
		commonDAO.update("prod.updateItem", param);
        model.setCode("I00000003"); //저장되었습니다.
		return model;
	}
		
    private void uploadExcelItemInfo(AjaxModel model, Map<String, Object> data) throws Exception {
        Map<String, Object> fileMap = model.getDataList().get(0);
        String userId = (String)data.get("USER_ID");
        String mallId = (String)data.get("MALL_ID");
        String bizNo = (String)data.get("BIZ_NO");
        String sn = (String)data.get("SN");
		Map<Integer,Map<Integer, Object>> rows = excelReader.parseExcelOnlyFirstSheet(
        		new File(StringUtil.null2Str(fileMap.get("FILE_STRE_COURS")) + StringUtil.null2Str(fileMap.get("STRE_FILE_NM")) + StringUtil.null2Str(fileMap.get("FILE_SN")))
        );
        
		String[] colNames = new String[]{
				"MALL_ITEM_NO", "ITEM_NM", "HS_CD", "BRAND_NM", "ORG_NAT_CD", "WEIGHT", "WEIGHT_UT", "QUANTY_UT", "MAKER_NM", "MAKER_TGNO", 
				"MAKER_POST_NO", "GNM", "INGREDIENTS", "CATEGORY1", "CATEGORY2", "CATEGORY3", "SPEC_DETAIL", "ITEM_VIEW_URL"
		};
		
        for(Integer row : rows.keySet()) {
        	if(row == 0) continue;
        	
        	Map<String, Object> excelData = new HashMap<String, Object>(); 
        	for(Integer cell : rows.get(row).keySet()) {
        		excelData.put(colNames[cell], rows.get(row).get(cell).toString());
        	}
        	excelData.put("USER_ID", userId);
        	excelData.put("MALL_ID", mallId);
        	excelData.put("BIZ_NO", bizNo);
        	excelData.put("SN", sn);
        	commonDAO.insert("prod.insertItemExcelDetail", excelData);
        }
    }
	
	@Override
	public AjaxModel uploadItemInfoExcel(AjaxModel model) throws Exception {
        UsrSessionModel usrSession = model.getUsrSessionModel();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        
        // INSERT : CMM_ITEM_EXCEL 
        Map<String, Object> param = model.getData();
        param.put("USER_ID"		, usrSession.getUserId());
        param.put("MALL_ID" 	, usrSession.getUserId());
        param.put("BIZ_NO" 	    , usrSession.getBizNo());
        param.put("TIMESTAMP"	, formatter.format(new Date()));
        commonDAO.insert("prod.insertItemExcel", param);
        
		// 상품정보
		// INSERT : CMM_ITEM_EXCEL_DETAIL 
		uploadExcelItemInfo(model, param);
		
		// CMM_ITEM_EXCEL_DETAIL 테이블 공백데이터 삭제
        commonDAO.delete("prod.deleteItemExcelDetailEmpty", null);
        
        int cnt = Integer.parseInt(String.valueOf(commonDAO.select("prod.selectItemInfoCnt", param)));
        if(cnt > 0) {
        	model.setMsg(commonService.getMessage("W00000060", "상품번호"));
        	return model;
        }
        cnt = Integer.parseInt(String.valueOf(commonDAO.select("prod.selectItemExcelDetailCnt", param)));
        if(cnt > 0) {
        	model.setMsg(commonService.getMessage("W00000061", "상품번호"));
        	return model;
        }
        // 업로드 목록 조회
        List<Map<String, Object>> xlsList = commonDAO.list("prod.selectItemExcelDetailList", param);

        // Validation 체크
        String errMsg = checkValidation(usrSession, xlsList);
        if(StringUtils.isEmpty(errMsg)) {
        	commonDAO.insert("prod.insertItemInfo", param);
        } else {
        	model.setMsg(errMsg);
        	return model;
        }
		return model;
	}
	
	// 오류 체크
    private String checkValidation(UsrSessionModel usrSession, List<Map<String, Object>> xlsList) throws Exception {
    	StringBuffer msg =  new StringBuffer();
        for (Map<String, Object> xls : xlsList) {
			String mallItemNo = StringUtil.null2Str(xls.get("MALL_ITEM_NO"));
			String itemNm = StringUtil.null2Str(xls.get("ITEM_NM"));
			String hsCd = StringUtil.null2Str(xls.get("HS_CD"));
			String brandNm = StringUtil.null2Str(xls.get("BRAND_NM"));
			String orgNatCd = StringUtil.null2Str(xls.get("ORG_NAT_CD"));
			String weight = StringUtil.null2Str(xls.get("WEIGHT"));
			String weightUt = StringUtil.null2Str(xls.get("WEIGHT_UT"));
			String quantyUt = StringUtil.null2Str(xls.get("QUANTY_UT"));
			String makerNm = StringUtil.null2Str(xls.get("MAKER_NM"));		
			String makerTgno = StringUtil.null2Str(xls.get("MAKER_TGNO"));	
			String makerPostNo = StringUtil.null2Str(xls.get("MAKER_POST_NO"));	
			String gnm = StringUtil.null2Str(xls.get("GNM"));
			String ingredients = StringUtil.null2Str(xls.get("INGREDIENTS"));
			String category1 = StringUtil.null2Str(xls.get("CATEGORY1"));
			String category2 = StringUtil.null2Str(xls.get("CATEGORY2"));
			String category3 = StringUtil.null2Str(xls.get("CATEGORY3"));
			String specDetail = StringUtil.null2Str(xls.get("SPEC_DETAIL"));
			String itemViewUrl = StringUtil.null2Str(xls.get("ITEM_VIEW_URL"));

			msg.append(ProdValidator.isValidComm(mallItemNo, "상품ID[" + mallItemNo + "] 상품ID", 35, true));
			msg.append(ProdValidator.isValidEngNumSpc(itemNm, "상품ID[" + mallItemNo + "] 상품명 (영문)", 50, true));
			msg.append(ProdValidator.isValidNum(hsCd, "상품ID[" + mallItemNo + "] HS코드", 10, 0, true));
			msg.append(ProdValidator.isValidEngNumSpc(brandNm, "상품ID[" + mallItemNo + "] 상표명 (영문)", 30, true));
			msg.append(ProdValidator.isValidUpperEng(orgNatCd, "상품ID[" + mallItemNo + "] 원산지 국가코드", 3, true));
			msg.append(ProdValidator.isValidNum(weight, "상품ID[" + mallItemNo + "] 중량", 16, 3, true));
			msg.append(ProdValidator.isValidEngNum(weightUt, "상품ID[" + mallItemNo + "] 중량단위", 3, true));
			msg.append(ProdValidator.isValidEngNum(quantyUt, "상품ID[" + mallItemNo + "] 수량단위", 3, true));
			msg.append(ProdValidator.isValidComm(makerNm, "상품ID[" + mallItemNo + "] 제조자상호명", 28, false));
			msg.append(ProdValidator.isValidComm(makerTgno, "상품ID[" + mallItemNo + "] 제조자통관고유부호", 15, false));
			msg.append(ProdValidator.isValidNum(makerPostNo, "상품ID[" + mallItemNo + "] 제조자우편번호", 5, 0, true));
			msg.append(ProdValidator.isValidComm(gnm, "상품ID[" + mallItemNo + "] 규격", 500, false));
			msg.append(ProdValidator.isValidComm(ingredients, "상품ID[" + mallItemNo + "] 성분", 70, false));
			msg.append(ProdValidator.isValidComm(category1, "상품ID[" + mallItemNo + "] 카테고리1", 100, false));
			msg.append(ProdValidator.isValidComm(category2, "상품ID[" + mallItemNo + "] 카테고리2", 100, false));
			msg.append(ProdValidator.isValidComm(category3, "상품ID[" + mallItemNo + "] 카테고리3", 100, false));
			msg.append(ProdValidator.isValidComm(specDetail, "상품ID[" + mallItemNo + "] 기타스펙", 500, false));
			msg.append(ProdValidator.isValidComm(itemViewUrl, "상품ID[" + mallItemNo + "] 상품Url", 500, false));

        }
        return msg.toString();
    }
}
