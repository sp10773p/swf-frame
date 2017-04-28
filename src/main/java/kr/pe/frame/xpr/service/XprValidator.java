package kr.pe.frame.xpr.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

import kr.pe.frame.cmm.core.base.BizException;

public class XprValidator {

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

    // 운송장번호
    public static boolean isValidRegiNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 13, false, required);
    }
    
    // 수출신고번호
    public static boolean isValidXprtNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 14, true, required);
    }
    
    // BL번호
    public static boolean isValidBlNo(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 20, false, required);
    }
    
    // 배송물구분
    public static boolean isValidStoreName(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("Other") && !value.equals("eBay") && !value.equals("Amazon") && !value.equals("Taobao")
                && !value.equals("Lazada") && !value.equals("QOO10") && !value.equals("Rakuten") && !value.equals("Etsy")) {
            throw new BizException(makeMsg(title, "에는", "'Other', 'eBay', 'Amazon', 'Taobao', 'Lazada', 'QOO10', 'Rakuten', 'Etsy' 값만 가능합니다."));
        }

        return true;
    }

    // 주문일자
    public static boolean isValidOrderDate(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DATE, 8, true, required);
    }
    
    // 상품구분
    public static boolean isValidProdDesc(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 20, false, required);
    }
    
    // 수취인 이름
    public static boolean isValidRecipientName(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 35, false, required);
    }
    
    // 수취인 전화
    public static boolean isValidRecipientPhone(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_NUM, 20, false, required);
    }
    
    // 수취인 이메일
    public static boolean isValidRecipientEmail(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 40, false, required);
    }
    
    // 수취인 주소
    public static boolean isValidRecipientAddress(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 98, false, required);
    }
    
    // 수취인 도시
    public static boolean isValidRecipientCity(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 35, false, required);
    }
    
    // 수취인 주
    public static boolean isValidRecipientState(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 35, false, required);
    }
    
    // 수취인 우편번호
    public static boolean isValidRecipientZipcd(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_ENG_NUM, 10, false, required);
    }
    
    // 배송 서비스
    public static boolean isValidDeliveryOption(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("Gift") && !value.equals("Documents") && !value.equals("Commercial Sample") && !value.equals("Returned Goods") && !value.equals("Merchandise")) {
            throw new BizException(makeMsg(title, "에는", "'Gift', 'Documents', 'Commercial Sample', 'Returned Goods', 'Merchandise' 값만 가능합니다."));
        }

        return true;
    }
    
    // 총무게
    public static boolean isValidTotalWeight(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 7, 0, required);
    }
    
    // 무게 단위
    public static boolean isValidWeightUnit(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("g") && !value.equals("Kg") && !value.equals("oz") && !value.equals("lb")) {
            throw new BizException(makeMsg(title, "에는", "'g', 'Kg', 'oz', 'lb' 값만 가능합니다."));
        }

        return true;
    }
    
    // 총포장수
    public static boolean isValidTotPackCnt(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 6, 0, required);
    }

    // 크기 단위
    public static boolean isValidBoxDimensionUnit(String value, String title, boolean required) throws Exception {
        if (value == null || value.equals("")) {
            if (required) {
                throw new BizException(makeMsg(title, "은(는)", "필수항목입니다."));
            }
        } else if (!value.equals("cm") && !value.equals("inch")) {
            throw new BizException(makeMsg(title, "에는", "'cm', 'inch' 값만 가능합니다."));
        }

        return true;
    }
    
    // 상품 1
    public static boolean isValidItemTitle(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 50, false, required);
    }
    
    // 상품 수량 1
    public static boolean isValidItemQuantity(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 7, 0, required);
    }
    
    // 상품 가격 1
    public static boolean isValidItemSalePrice(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 12, 0, required);
    }
    
    // 상품 분류 1
    public static boolean isValidItemCategory(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 20, false, required);
    }
    
    // 상품 무게 1
    public static boolean isValidItemWeight(String value, String title, boolean required) throws Exception {
        return numberValueCheck(value, title, 7, 0, required);
    }
    
    // SKU 1
    public static boolean isValidItemSku(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 50, false, required);
    }
    
    // 소재 1
    public static boolean isValidItemComposition(String value, String title, boolean required) throws Exception {
        return valueCheck(value, title, TYPE_DEFAULT, 100, false, required);
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
