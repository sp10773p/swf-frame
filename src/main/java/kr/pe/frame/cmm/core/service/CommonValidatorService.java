package kr.pe.frame.cmm.core.service;

public interface CommonValidatorService {

    /**
     * HS코드를 조회하여 유효여부 리턴
     * @param map
     * @return
     */
    boolean isValidHsCode(String value, String title, boolean required) throws Exception;
    
    /**
     * 국가코드를 조회하여 유효여부 리턴
     * @param map
     * @return
     */
    boolean isValidCountryCode(String value, String title, boolean required) throws Exception;

    /**
     * 통화코드를 조회하여 유효여부 리턴 (환율정보기반)
     * @param map
     * @return
     */
    boolean isValidCurrencyCode(String value, String title, boolean required) throws Exception;
    
    /**
     * 통화코드를 조회하여 유효여부 리턴 (공통코드기반)
     * @param map
     * @return
     */
    boolean isValidCurrencyCd(String value, String title, boolean required) throws Exception;
    
    /**
     * 규격수량단위를 조회하여 유효여부 리턴 (공통코드기반)
     * @param map
     * @return
     */
    boolean isValidQuantityUnitCode(String value, String title, boolean required) throws Exception;
    
    /**
     * 포장단위를 조회하여 유효여부 리턴 (공통코드기반)
     * @param map
     * @return
     */
    boolean isValidPackageUnitCode(String value, String title, boolean required) throws Exception;
    
    
    /**
     * 결제금액 체크
     * @param pAYMENTAMOUNT
     * @param pAYMENTAMOUNT_CUR
     * @param string
     * @param b
     * @return
     * @throws Exception
     */
    boolean isValidPaymentAmount(String pAYMENTAMOUNT, String pAYMENTAMOUNT_CUR, String string, boolean b)  throws Exception;
    
    /**
     * 인도조건 조회하여 유효여부 리턴
     * @param map
     * @return
     */
    boolean isValidAmtCod(String value, String title, boolean required) throws Exception;
}
