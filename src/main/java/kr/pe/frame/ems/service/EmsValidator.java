package kr.pe.frame.ems.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

import kr.pe.frame.cmm.core.base.BizException;

public class EmsValidator {

    private static Pattern PTRN_ENG = Pattern.compile("[a-zA-Z]+");
    private static Pattern PTRN_ENG_SPC = Pattern.compile("[a-zA-Z ]+");
    private static Pattern PTRN_ENG_NUM = Pattern.compile("[a-zA-Z0-9]+");
    private static Pattern PTRN_NUM = Pattern.compile("[0-9]+");
    private static Pattern PTRN_ENG_NUM_SPC_ETC = Pattern.compile("[a-zA-Z0-9\\p{Punct} \\t&&[^<>&]]+"); // 영문, 숫자, 공백(탭 포함), 특수문자('<', '>', '&' 제외)
    private static Pattern PTRN_ENG_SPC_ETC = Pattern.compile("[a-zA-Z.,-[ ]]+"); // 영문, 공백, '.', ',', '-'
    private static Pattern PTRN_ENG_SPC_HAN = Pattern.compile("[a-zA-Z[ ]가-힣]+"); // 영문, 공백, 한글
    private static Pattern PTRN_ENG_NUM_HAN_ETC = Pattern.compile("[a-zA-Z0-9가-힣*]+"); // 영문, 숫자, 한글, '*'
    private static Pattern PTRN_NUM_DÀSH = Pattern.compile("[0-9-]+"); // 숫자, '-'
    private static Pattern PTRN_DEFAULT = Pattern.compile(".*[[?][$][*][+][|]\\{\\}\\[\\]\\^!%\\\\].*");

    private static String TYPE_ENG = "ENG";
    private static String TYPE_ENG_SPC = "ENG_SPC";
    private static String TYPE_ENG_NUM = "ENG_NUM";
    private static String TYPE_NUM = "NUM";
    private static String TYPE_ENG_NUM_SPC_ETC = "ENG_NUM_SPC_ETC";
    private static String TYPE_ENG_SPC_ETC = "ENG_SPC_ETC";
    private static String TYPE_ENG_SPC_HAN = "ENG_SPC_HAN";
    private static String TYPE_ENG_NUM_HAN_ETC = "ENG_NUM_HAN_ETC";
    private static String TYPE_NUM_DÀSH = "NUM_DÀSH";
    private static String TYPE_DATE_TIME = "DATE_TIME";
    private static String TYPE_DATE = "DATE";
    private static String TYPE_TIME = "TIME";
    private static String TYPE_NONE = "";
    private static String TYPE_DEFAULT = "DEFAULT";

    // 배송물구분
    public static boolean isValidEmGubun(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("Sample") && !value.equals("Gift") && !value.equals("Merchandise") && !value.equals("Document")) {
            throw new BizException(makeMsg(title, "에는", "'Sample', 'Gift', 'Merchandise', 'Document' 값만 가능합니다."));
        }

        return true;
    }

    // 수취인명
    public static boolean isValidReceiveName(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 35, false, required);
    }

    // 수취인 이메일
    public static boolean isValidReceivEmail(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 40, false, required);
    }

    // 수취인전체 전화번호
    public static boolean isValidReceiveTelno(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM_DÀSH, 40, false, required);
    }

    // 수취인 우편번호
    public static boolean isValidReceiveZipcode(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 20, false, required);
    }

    // 수취인 주소3(상세1)
    public static boolean isValidReceiveAddr3(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 300, false, required);
    }

    // 수취인 주소2(시/군)
    public static boolean isValidReceiveAddr2(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 200, false, required);
    }

    // 수취인 주소1(주/도)
    public static boolean isValidReceiveAddr1(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 140, false, required);
    }

    // 총중량
    public static boolean isValidTotWeight(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 7, 0, required);
    }

    // 내용품명 (세미콜론구분자로 최대 4건 등록가능)
    public static boolean isValidContents(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NONE, 32, false, required);
    }

    // 개수 (세미콜론구분자로 최대 4건 등록가능)
    public static boolean isValidItemNumber(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 7, 0, required);
    }

    // 순중량 (세미콜론구분자로 최대 4건 등록가능)
    public static boolean isValidItemWeight(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 10, 0, required);
    }

    // 가격 (세미콜론구분자로 최대 4건 등록가능)
    public static boolean isValidItemValue(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 15, 0, required);
    }

    // 모델명 (세미콜론구분자로 최대 4건 등록가능)
    public static boolean isValidModelNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 100, false, required);
    }

    // 보험가입금액
    public static boolean isValidBoPrc(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 15, 0, required);
    }

    // 우편물구분코드
    public static boolean isValidPremiumCd(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("E") && !value.equals("P") && !value.equals("K")) {
            throw new BizException(makeMsg(title, "에는", "'E', 'P', 'K' 값만 가능합니다."));
        }

        return true;
    }

    // 우편물종류코드
    public static boolean isValidEmEe(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("ee") && !value.equals("em") && !value.equals("re") && !value.equals("rl") && !value.equals("el") && !value.equals("es")) {
            throw new BizException(makeMsg(title, "에는", "'ee', 'em', 're', 'rl', 'el', 'es' 값만 가능합니다."));
        }

        return true;
    }

    // 주문번호
    public static boolean isValidOrderNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 50, false, required);
    }

    // 주문인전화 전체번호
    public static boolean isValidOrderTelno(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM_DÀSH, 40, false, required);
    }

    // 주문인휴대전화 전체번호
    public static boolean isValidOrderHTelno(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM_DÀSH, 40, false, required);
    }

    // 사업자번호
    public static boolean isValidBizRegNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM, 10, false, required);
    }
    
    // 수출화주 이름 또는 상호
    public static boolean isValidExportSendPrsnNm(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 35, false, required);
    }
    
    // 수출화주 주소
    public static boolean isValidExportSendPrsnAddr(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 105, false, required);
    }

    // 전량분할발송여부
    public static boolean isValidYn(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("Y") && !value.equals("N")) {
            throw new BizException(makeMsg(title, "에는", "'Y', 'N' 값만 가능합니다."));
        }

        return true;
    }

    // 선기적 포장개수
    public static boolean isValidWrapCnt(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM, 5, false, required);
    }
    
    // 수출신고번호
    public static boolean isValidXprtNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 14, true, required);
    }

    // SKU재고관리번호
    public static boolean isValidSkuStockMgmtNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 50, false, required);
    }

    // 결제수단
    public static boolean isValidPayTypeCd(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("01") && !value.equals("02") && !value.equals("03") && !value.equals("04") && !value.equals("05") && !value.equals("06")
                && !value.equals("07") && !value.equals("08") && !value.equals("09") && !value.equals("10") && !value.equals("11") && !value.equals("12")) {
            throw new BizException(makeMsg(title, "에는", "'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12' 값만 가능합니다."));
        }

        return true;
    }
    
    // 결제통화
    public static boolean isValidCurrUnit(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("KRW") && !value.equals("RMB") && !value.equals("USD")) {
            throw new BizException(makeMsg(title, "에는", "'KRW', 'RMB', 'USD' 값만 가능합니다."));
        }
        
        return true;
    }
    
    // 결제승인번호
    public static boolean isValidPayApprNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 50, false, required);
    }

    // 관세납부자
    public static boolean isValidDutyPayPrsnCd(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("1") && !value.equals("2") && !value.equals("3")) {
            throw new BizException(makeMsg(title, "에는", "'1', '2', '3' 값만 가능합니다."));
        }
        
        return true;
    }
    
    // 납부관세액
    public static boolean isValidDutyPayAmt(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 8, 2, required);
    }
    
    // 관세납부통화
    public static boolean isValidDutyPayCurr(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("KRW") && !value.equals("RMB") && !value.equals("USD") && !value.equals("EUR")) {
            throw new BizException(makeMsg(title, "에는", "'KRW', 'RMB', 'USD', 'EUR' 값만 가능합니다."));
        }
        
        return true;
    }
    
    // 포장상자 사이즈
    public static boolean isValidBoxSize(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 4, 2, required);
    }
    
    // 최대 길이 체크 (문자)
    public static boolean isValidMaxLengthString(String value, String title, int size, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NONE, size, false, required);
    }

    // 최대 길이 체크 (정수)
    public static boolean isValidMaxLengthNumber(String value, String title, int size, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM, size, false, required);
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
        } else if (sameSizeOnly && value.getBytes().length != size) {
            errMsg = makeMsg(name, "의", "길이가 맞지 않습니다. " + size + " 자리만 가능합니다.");
        } else if (!sameSizeOnly && value.getBytes().length > size) {
            errMsg = makeMsg(name, "의", "길이가 너무 깁니다. 최대바이트(" + size + ")");
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
        } else if (TYPE_NUM_DÀSH.equals(type) && !PTRN_NUM_DÀSH.matcher(value).matches()) {
            errMsg = makeMsg(name, "에는", "숫자, '-'만 가능합니다.");
        } else if (TYPE_DEFAULT.equals(type) && PTRN_DEFAULT.matcher(value).matches()) {
            errMsg = makeMsg(name, "에는", "특수문자(\"?!$%^*+{}[]|\\)를 사용할 수 없습니다.");
        }

        if (errMsg != null) {
            throw new BizException(errMsg);
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
            throw new BizException(errMsg);
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
}
