package kr.pe.frame.cmm.core.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.util.DateUtil;

@Service(value = "commonValidator")
public class CommonValidatorServiceImpl implements CommonValidatorService {
    
    @Resource(name = "commonDAO")
    CommonDAO commonDAO;
    
    // 통화코드 유효여부 (환율정보)
    @Override
    public boolean isValidCurrencyCode(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInCurrencyDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // 통화코드 유효여부 (공통코드)
    @Override
    public boolean isValidCurrencyCd(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInCurrencyCdDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // 국가코드 유효여부
    @Override
    public boolean isValidCountryCode(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInCountryCdDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // HS_CD 유효여부
    @Override
    public boolean isValidHsCode(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInHsCdDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // 규격수량 코드 유효여부
    @Override
    public boolean isValidQuantityUnitCode(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInQuantityUnitCdDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // 포장단위코드 유효여부
    @Override
    public boolean isValidPackageUnitCode(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInPackageUnitCdDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    
    // 통화코드 체크 (환율정보)
    private boolean existsInCurrencyDb(String currencyCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("NATION", currencyCode);
       
        String NATION = (String)commonDAO.select("commonValidator.selectExchangeRate", map);

        if (NATION != null) {
            return true;
        } else {
            return false;
        }
    }
    
    // 통화코드 체크 (공통코드)
    private boolean existsInCurrencyCdDb(String currencyCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CLASS_ID", "CUS0042"); // 통화코드
        map.put("CODE", currencyCode);
       
        String CODE = (String)commonDAO.select("commonValidator.selectCommonCode", map);

        if (CODE != null) {
            return true;
        } else {
            return false;
        }
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
    
    // HS_CD 체크
    private boolean existsInHsCdDb(String hsCd) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("HS_CD", hsCd);
        
        String HS_CD = (String)commonDAO.select("commonValidator.selectTbHsCd", map);

        if (HS_CD != null) {
            return true;
        } else {
            return false;
        }
    }
    
    // 규격수량 단위코드 체크
    private boolean existsInQuantityUnitCdDb(String weightUnitCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CLASS_ID", "CUS0006"); // 규격수량 단위
        map.put("CODE", weightUnitCode);
       
        String CODE = (String)commonDAO.select("commonValidator.selectCommonCode", map);

        if (CODE != null) {
            return true;
        } else {
            return false;
        }
    }
    
    // 포장단위코드 체크
    private boolean existsInPackageUnitCdDb(String packageUnitCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CLASS_ID", "CUS0043"); // 중량/수량 단위
        map.put("CODE", packageUnitCode);
        
        String CODE = (String)commonDAO.select("commonValidator.selectCommonCode", map);
        
        if (CODE != null) {
            return true;
        } else {
            return false;
        }
    }
    
    // 오류 메세지
    private String makeMsg(String title, String postposition, String msg) {
        if (title == null || title.equals("")) {
            return msg;
        }

        return title + postposition + " " + msg;
    }
    
    // 결제금액 200만원 이하 인지 체크
    private boolean isOverCheckAmt(String amt , String countryCode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String rptDay = DateUtil.getToday();
		String exchangeBaseDate = DateUtil.firstDate(rptDay);
		map.put("APPLY_DATE", exchangeBaseDate);
		map.put("NATION", countryCode);
		map.put("IMPORT_EXPORT", "E");
       
        String exRateStr = (String)commonDAO.select("dec.selectExchangeRate", map);	//환율정보
        if (StringUtils.isEmpty(exRateStr)) throw new BizException("환율정보가 없습니다."); 
        
        double exRate = Double.valueOf(exRateStr).doubleValue();
        double rsAmt = exRate * Integer.parseInt(amt);
        if (Math.round(rsAmt) > 2000000) throw new BizException("신고금액(원화)은 200만원을 초과할 수 없습니다. [예상신고 원화금액: "+Math.round(rsAmt)+"]");
        
        return true;
    }

	
	// 결제금액
    @Override
	public boolean isValidPaymentAmount(String value, String value2, String title, boolean required) throws Exception {
		if (required == false && (value == null || value.equals(""))) {
			return true;
		} else if (isOverCheckAmt(value, value2)) { // 200만원이 넘는지 체크
			return true;
		} else {
			throw new BizException (makeMsg(title, "이(가)", "유효하지 않습니다."));
		}
	}
    
    //  인도조건 (공통코드)
    @Override
    public boolean isValidAmtCod(String value, String title, boolean required) throws Exception {
        if (required == false && (value == null || value.equals(""))) {
            return true;
        } else if (existsInAmtCodDb(value)) { // DB에 존재하면
            return true;
        } else {
            throw new BizException(makeMsg(title, "이(가)", "유효하지 않습니다."));
        }
    }
    
    // 인도조건 체크 (공통코드)
    private boolean existsInAmtCodDb(String currencyCode) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CLASS_ID", "CUS0038"); // 통화코드
        map.put("CODE", currencyCode);
       
        String CODE = (String)commonDAO.select("commonValidator.selectCommonCode", map);

        if (CODE != null) {
            return true;
        } else {
            return false;
        }
    }
}
