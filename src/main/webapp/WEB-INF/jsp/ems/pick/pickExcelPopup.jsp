<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers, headersSea;
    var globalVar = {
        "SN" : "",
        "REG_TYPE" : "",
        "SUCCESS_YN" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        globalVar.SN = arguments.SN;
        globalVar.REG_TYPE = arguments.REG_TYPE;
        globalVar.SUCCESS_YN = arguments.SUCCESS_YN;
        headers = [ 
            {"HEAD_TEXT" : "오류",						"WIDTH" : "100",	"FIELD_NAME" : "오류",				"ALIGN" : "center",	"HTML_FNC": "fn_error"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "100",	"FIELD_NAME" : "EM_GUBUN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"}, 
            {"HEAD_TEXT" : "수취인명",					"WIDTH" : "100",	"FIELD_NAME" : "RECEIVENAME",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEMAIL",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인국가코드",				"WIDTH" : "100",	"FIELD_NAME" : "COUNTRYCD",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인우편번호",				"WIDTH" : "100",	"FIELD_NAME" : "RECEIVEZIPCODE",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 전체주소 / 상세주소 1",	"WIDTH" : "350",	"FIELD_NAME" : "RECEIVEADDR3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 시/군 주소",			"WIDTH" : "200",	"FIELD_NAME" : "RECEIVEADDR2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 주/도 주소",			"WIDTH" : "200",	"FIELD_NAME" : "RECEIVEADDR1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "총중량",						"WIDTH" : "100",	"FIELD_NAME" : "TOTWEIGHT",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "내용품명",					"WIDTH" : "200",	"FIELD_NAME" : "CONTENTS",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "개수",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_NUMBER",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "순중량",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "가격",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_VALUE",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HS_CODE",					"WIDTH" : "100",	"FIELD_NAME" : "HS_CODE",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "생산지",						"WIDTH" : "100",	"FIELD_NAME" : "ORIGIN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "모델명",						"WIDTH" : "100",	"FIELD_NAME" : "MODELNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "보험가입여부",				"WIDTH" : "100",	"FIELD_NAME" : "BOYN",				"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "보험가입금액",				"WIDTH" : "100",	"FIELD_NAME" : "BOPRC",				"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "우편물구분",					"WIDTH" : "100",	"FIELD_NAME" : "PREMIUMCD",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "물품종류",					"WIDTH" : "100",	"FIELD_NAME" : "EM_EE_NM",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "고객주문번호",				"WIDTH" : "200",	"FIELD_NAME" : "ORDERNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인우편번호",				"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNZIPCD",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인주소",					"WIDTH" : "350",	"FIELD_NAME" : "ORDERPRSNADDR2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인명",					"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNNM",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELFNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELMNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELLNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 지역번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELFNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 국번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELMNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 끝번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELLNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 전체번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNEMAILID",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출우편물정보관세청제공여부",	"WIDTH" : "200",	"FIELD_NAME" : "ECOMMERCEYN",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "사업자번호",					"WIDTH" : "150",	"FIELD_NAME" : "BIZREGNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출화주이름 또는 상호",		"WIDTH" : "200",	"FIELD_NAME" : "EXPORTSENDPRSNNM",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출화주 주소",				"WIDTH" : "350",	"FIELD_NAME" : "EXPORTSENDPRSNADDR","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출이행등록여부",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNOYN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호1",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO1",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부1",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수1",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT1",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호2",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO2",         	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부2",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수2",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT2",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호3",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO3",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부3",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수3",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT3",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호4",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO4",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부4",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수4",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT4",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "추천우체국코드",				"WIDTH" : "100",	"FIELD_NAME" : "RECOMPOREGIPOCD",	"ALIGN" : "left",	"HTML_FNC": "fn_html"}
        ];
        
        headersSea = [ 
            {"HEAD_TEXT" : "오류",						"WIDTH" : "100",	"FIELD_NAME" : "오류",				"ALIGN" : "center",	"HTML_FNC": "fn_error"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "100",	"FIELD_NAME" : "EM_GUBUN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"}, 
            {"HEAD_TEXT" : "수취인명",					"WIDTH" : "100",	"FIELD_NAME" : "RECEIVENAME",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEMAIL",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인국가코드",				"WIDTH" : "100",	"FIELD_NAME" : "COUNTRYCD",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인우편번호",				"WIDTH" : "100",	"FIELD_NAME" : "RECEIVEZIPCODE",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 전체주소 / 상세주소 1",	"WIDTH" : "350",	"FIELD_NAME" : "RECEIVEADDR3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 시/군 주소",			"WIDTH" : "200",	"FIELD_NAME" : "RECEIVEADDR2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 주/도 주소",			"WIDTH" : "200",	"FIELD_NAME" : "RECEIVEADDR1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "총중량",						"WIDTH" : "100",	"FIELD_NAME" : "TOTWEIGHT",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "내용품명",					"WIDTH" : "200",	"FIELD_NAME" : "CONTENTS",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "개수",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_NUMBER",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "순중량",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "가격",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_VALUE",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HS_CODE",					"WIDTH" : "100",	"FIELD_NAME" : "HS_CODE",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "생산지",						"WIDTH" : "100",	"FIELD_NAME" : "ORIGIN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "모델명",						"WIDTH" : "100",	"FIELD_NAME" : "MODELNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "보험가입여부",				"WIDTH" : "100",	"FIELD_NAME" : "BOYN",				"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "보험가입금액",				"WIDTH" : "100",	"FIELD_NAME" : "BOPRC",				"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "우편물구분",					"WIDTH" : "100",	"FIELD_NAME" : "PREMIUMCD",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "물품종류",					"WIDTH" : "100",	"FIELD_NAME" : "EM_EE_NM",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "고객주문번호",				"WIDTH" : "200",	"FIELD_NAME" : "ORDERNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인우편번호",				"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNZIPCD",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인주소",					"WIDTH" : "350",	"FIELD_NAME" : "ORDERPRSNADDR2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인명",					"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNNM",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELFNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELMNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELLNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 지역번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELFNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 국번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELMNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 끝번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELLNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인휴대전화 전체번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNEMAILID",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출우편물정보관세청제공여부",	"WIDTH" : "200",	"FIELD_NAME" : "ECOMMERCEYN",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "사업자번호",					"WIDTH" : "150",	"FIELD_NAME" : "BIZREGNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출화주이름 또는 상호",		"WIDTH" : "200",	"FIELD_NAME" : "EXPORTSENDPRSNNM",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출화주 주소",				"WIDTH" : "350",	"FIELD_NAME" : "EXPORTSENDPRSNADDR","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출이행등록여부",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNOYN",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호1",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO1",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부1",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수1",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT1",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호2",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO2",         	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부2",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수2",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT2",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호3",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO3",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부3",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수3",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT3",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수출신고번호4",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO4",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "전량분할발송여부4",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "선기적 포장개수4",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT4",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU재고관리번호",				"WIDTH" : "200",	"FIELD_NAME" : "SKUSTOCKMGMTNO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "결제수단",					"WIDTH" : "100",	"FIELD_NAME" : "PAYTYPECD",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "결제통화",					"WIDTH" : "100",	"FIELD_NAME" : "CURRUNIT",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "결제승인번호",				"WIDTH" : "200",	"FIELD_NAME" : "PAYAPPRNO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "관세납부자",					"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYPRSNCD",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "납부관세액",					"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYAMT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "관세납부통화",				"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYCURR",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "포장상자 길이",				"WIDTH" : "100",	"FIELD_NAME" : "BOXLENGTH",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "포장상자 너비",				"WIDTH" : "100",	"FIELD_NAME" : "BOXWIDTH",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "포장상자 높이",				"WIDTH" : "100",	"FIELD_NAME" : "BOXHEIGHT",			"ALIGN" : "left",	"HTML_FNC": "fn_html"}
        ];
        gridWrapper = new GridWrapper({
            "actNm" : "픽업요청 업로드 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectPickExcelList",
            "requestUrl" : "/ems/pick/selectPickExcelList.do",
            "headers" : globalVar.REG_TYPE == 'A' ? headers : headersSea,
            "paramsGetter" : {"SN":globalVar.SN, "REG_TYPE":globalVar.REG_TYPE, "SUCCESS_YN":globalVar.SUCCESS_YN},
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort" : "SN, SEQ",
            "controllers" : [

            ]
        });
        
        // 픽업요청
        $('#btn_pickup').on("click", function(e) {
            fn_pickup();
        });

        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridWrapper.requestToServer();
    });
    
    // EMS 픽업요청
    function fn_pickup() {
        if (checkRemainCnt(globalVar.SN) == 0) {
            alert($.comm.getMessage("I00000021")); //요청할 내용이 없습니다.
            return;
        }
        
        if (!confirm($.comm.getMessage("C00000019"))) return; //픽업요청하시겠습니까?

        var params = new Array();
        var param = {"SN":globalVar.SN};
        params.push(param);
        $.comm.send("ems/pick/savePickReq.do", params, fn_callback, "픽업요청");
    }
    
    // 픽업요청 대상건 조회
    function checkRemainCnt(sn) {
        var params = {"SN":sn, "qKey":"ems.selectEmsPicupReqExcelChk"};
        var info = $.comm.sendSync("/common/select.do", params, "픽업요청 대상건 조회").data;
        return info.CNT;
    }
    
    // 픽업요청 callback
    var fn_callback = function (data) {
        opener.gridWrapper.requestToServer();
        self.close();
    }
    
    // 상세정보 화면
    function fn_showErrorList(index) {
        var size = gridWrapper.getSize();
        if(size == 0){
            gridError.drawGrid();
            return;
        }
        
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"SN":data["SN"], "SEQ":data["SEQ"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickExcelErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickExcelErrPopup" />', spec); // 모달 호츨
    }

    function fn_error(index, val) {
        var data = gridWrapper.getRowData(index);
        var str = "";
        if (data["STATUS"] == "E") {
            str = "<a href='#this' class='btn_inquiryC' onclick='gfn_gridLink(\"fn_showErrorList\", \"" + (index) + "\")'>오류</a>";
        }
        return str;
    }
    
    function checkError(index, val, col) {
        var str = "";
        var data = gridWrapper.getRowData(index);
        var statusDesc = getSafeString(data["STATUS_DESC"]);
        var errCols = statusDesc.split("/");
        var isMatch = false;
        
        list: {
            for (i in errCols) {
                if (errCols[i].match(col)) {
                    isMatch = true;
                    break list;
                }
            } 
        }
        
        if (isMatch) {
            str = val + "<br/><div style='color:red'>오류</div>";
        }
        else {
            str = val;
        }
        return str;
    }
    
    function fn_html(index, val, field) {
        return checkError(index, val, field);
    }
    
    function getSafeString(val) {
        return (val === undefined) ? "" : val;
    }
</script>
</head>
<body>
    <div class="layerContainer">
        <div class="layerTitle">
            <h1>${ACTION_MENU_NM}</h1>
        </div><!-- layerTitle -->
        
        <div class="layer_btn_frame">
        </div><!-- layer_btn_frame -->
        
        <div class="title_frame">
            <div class="util_frame">
                <a href="##" class="btn white_84" id="btn_close">닫기</a> 
                <a href="##" class="btn white_84" id="btn_pickup">픽업요청</a>
            </div><!-- //util_frame -->
            
            <div id="gridLayer" style="height: 414px"></div>
            <div class="bottom_util">
                <div class="paging" id="gridPagingLayer">
                </div>
            </div>
        </div><!-- //title_frame -->
    </div><!-- //layerContainer -->

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
