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
            {"HEAD_TEXT" : "오류",						"WIDTH" : "100",	"FIELD_NAME" : "오류",					"ALIGN" : "left",	"HTML_FNC" : "fn_error"},
            {"HEAD_TEXT" : "발송인명",					"WIDTH" : "100",	"FIELD_NAME" : "SENDER",				"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "발송인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERZIPCODE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소2(기본)",			"WIDTH" : "350",	"FIELD_NAME" : "SENDERADDR2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소1(상세)",			"WIDTH" : "200",	"FIELD_NAME" : "SENDERADDR1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호1",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호2",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호3",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호4",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신1",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신2",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신3",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신4",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "SENDEREMAIL",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "배송 메시지",					"WIDTH" : "200",	"FIELD_NAME" : "SND_MESSAGE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "100",	"FIELD_NAME" : "EM_GUBUN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인명",					"WIDTH" : "100",	"FIELD_NAME" : "RECEIVENAME",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEMAIL",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호1",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호2",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호3",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호4",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인전체 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인국가코드",				"WIDTH" : "100",	"FIELD_NAME" : "COUNTRYCD",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEZIPCODE",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전체주소 / 상세주소 1",	"WIDTH" : "350",	"FIELD_NAME" : "RECEIVEADDR3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 시/군 주소",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEADDR2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 주/도 주소",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEADDR1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "총중량",						"WIDTH" : "100",	"FIELD_NAME" : "TOTWEIGHT",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "내용품명",					"WIDTH" : "200",	"FIELD_NAME" : "CONTENTS",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "개수",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_NUMBER",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "순중량",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "가격",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_VALUE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "HS_CODE",					"WIDTH" : "100",	"FIELD_NAME" : "HS_CODE",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "생산지",						"WIDTH" : "100",	"FIELD_NAME" : "ORIGIN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "모델명",						"WIDTH" : "100",	"FIELD_NAME" : "MODELNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "보험가입여부",				"WIDTH" : "100",	"FIELD_NAME" : "BOYN",					"ALIGN" : "left"},
            {"HEAD_TEXT" : "보험가입금액",				"WIDTH" : "100",	"FIELD_NAME" : "BOPRC",					"ALIGN" : "left"},
            {"HEAD_TEXT" : "우편물구분",					"WIDTH" : "100",	"FIELD_NAME" : "PREMIUMCD",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "물품종류",					"WIDTH" : "150",	"FIELD_NAME" : "EM_EE_NM",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "고객주문번호",				"WIDTH" : "200",	"FIELD_NAME" : "ORDERNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNZIPCD",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문자주소1",					"WIDTH" : "350",	"FIELD_NAME" : "ORDERPRSNADDR1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문자주소2",					"WIDTH" : "200",	"FIELD_NAME" : "ORDERPRSNADDR2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인명",					"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNNM",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELFNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELMNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELLNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 지역번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELFNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 국번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELMNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 끝번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELLNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 전체번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNEMAILID",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출우편물관세청제공여부",		"WIDTH" : "200",	"FIELD_NAME" : "ECOMMERCEYN",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "사업자번호",					"WIDTH" : "150",	"FIELD_NAME" : "BIZREGNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출화주이름 또는 상호",		"WIDTH" : "200",	"FIELD_NAME" : "EXPORTSENDPRSNNM",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출화주 주소",				"WIDTH" : "350",	"FIELD_NAME" : "EXPORTSENDPRSNADDR",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출이행등록여부",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNOYN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호1",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO1",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부1",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수1",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT1",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호2",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO2",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부2",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수2",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT2",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호3",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO3",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부3",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수3",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT3",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호4",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO4",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부4",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수4",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT4",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "추천우체국기호",				"WIDTH" : "100",	"FIELD_NAME" : "RECOMPOREGIPOCD",		"ALIGN" : "left"}
        ];
        
        headersSea = [ 
            {"HEAD_TEXT" : "오류",						"WIDTH" : "100",	"FIELD_NAME" : "오류",					"ALIGN" : "left",	"HTML_FNC" : "fn_error"},
            {"HEAD_TEXT" : "발송인명",					"WIDTH" : "100",	"FIELD_NAME" : "SENDER",				"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "발송인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERZIPCODE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소2(기본)",			"WIDTH" : "350",	"FIELD_NAME" : "SENDERADDR2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소1(상세)",			"WIDTH" : "200",	"FIELD_NAME" : "SENDERADDR1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호1",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호2",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호3",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호4",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERTELNO4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신1",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신2",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신3",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신4",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERMOBILE4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "SENDEREMAIL",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "배송 메시지",					"WIDTH" : "200",	"FIELD_NAME" : "SND_MESSAGE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "100",	"FIELD_NAME" : "EM_GUBUN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인명",					"WIDTH" : "100",	"FIELD_NAME" : "RECEIVENAME",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEMAIL",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호1",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호2",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호3",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화번호4",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인전체 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVETELNO",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인국가코드",				"WIDTH" : "100",	"FIELD_NAME" : "COUNTRYCD",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEZIPCODE",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전체주소 / 상세주소 1",	"WIDTH" : "350",	"FIELD_NAME" : "RECEIVEADDR3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 시/군 주소",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEADDR2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 주/도 주소",			"WIDTH" : "150",	"FIELD_NAME" : "RECEIVEADDR1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "총중량",						"WIDTH" : "100",	"FIELD_NAME" : "TOTWEIGHT",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "내용품명",					"WIDTH" : "200",	"FIELD_NAME" : "CONTENTS",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "개수",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_NUMBER",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "순중량",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "가격",						"WIDTH" : "100",	"FIELD_NAME" : "ITEM_VALUE",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "HS_CODE",					"WIDTH" : "100",	"FIELD_NAME" : "HS_CODE",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "생산지",						"WIDTH" : "100",	"FIELD_NAME" : "ORIGIN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "모델명",						"WIDTH" : "100",	"FIELD_NAME" : "MODELNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "보험가입여부",				"WIDTH" : "100",	"FIELD_NAME" : "BOYN",					"ALIGN" : "left"},
            {"HEAD_TEXT" : "보험가입금액",				"WIDTH" : "100",	"FIELD_NAME" : "BOPRC",					"ALIGN" : "left"},
            {"HEAD_TEXT" : "우편물구분",					"WIDTH" : "100",	"FIELD_NAME" : "PREMIUMCD",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "물품종류",					"WIDTH" : "150",	"FIELD_NAME" : "EM_EE_NM",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "고객주문번호",				"WIDTH" : "200",	"FIELD_NAME" : "ORDERNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNZIPCD",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문자주소1",					"WIDTH" : "350",	"FIELD_NAME" : "ORDERPRSNADDR1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문자주소2",					"WIDTH" : "200",	"FIELD_NAME" : "ORDERPRSNADDR2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인명",					"WIDTH" : "100",	"FIELD_NAME" : "ORDERPRSNNM",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 국가번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 지역번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELFNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 국번",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELMNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 전화번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELLNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인전화 전체번호",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNTELNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 지역번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELFNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 국번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELMNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 끝번",			"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELLNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인휴대전화 전체번호",		"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNHTELNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인EMAIL",				"WIDTH" : "150",	"FIELD_NAME" : "ORDERPRSNEMAILID",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출우편물관세청제공여부",		"WIDTH" : "200",	"FIELD_NAME" : "ECOMMERCEYN",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "사업자번호",					"WIDTH" : "150",	"FIELD_NAME" : "BIZREGNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출화주이름 또는 상호",		"WIDTH" : "200",	"FIELD_NAME" : "EXPORTSENDPRSNNM",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출화주 주소",				"WIDTH" : "350",	"FIELD_NAME" : "EXPORTSENDPRSNADDR",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출이행등록여부",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNOYN",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호1",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO1",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부1",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수1",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT1",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호2",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO2",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부2",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수2",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT2",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호3",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO3",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부3",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수3",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT3",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출신고번호4",				"WIDTH" : "150",	"FIELD_NAME" : "XPRTNO4",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "전량분할발송여부4",			"WIDTH" : "150",	"FIELD_NAME" : "TOTDIVSENDYN4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "선기적 포장개수4",				"WIDTH" : "150",	"FIELD_NAME" : "WRAPCNT4",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "추천우체국기호",				"WIDTH" : "100",	"FIELD_NAME" : "RECOMPOREGIPOCD",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU재고관리번호",				"WIDTH" : "200",	"FIELD_NAME" : "SKUSTOCKMGMTNO",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "결제수단",					"WIDTH" : "100",	"FIELD_NAME" : "PAYTYPECD",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "결제통화",					"WIDTH" : "100",	"FIELD_NAME" : "CURRUNIT",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "결제승인번호",				"WIDTH" : "200",	"FIELD_NAME" : "PAYAPPRNO",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "관세납부자",					"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYPRSNCD",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "납부관세액",					"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYAMT",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "관세납부통화",				"WIDTH" : "100",	"FIELD_NAME" : "DUTYPAYCURR",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "포장상자 길이",				"WIDTH" : "100",	"FIELD_NAME" : "BOXLENGTH",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "포장상자 너비",				"WIDTH" : "100",	"FIELD_NAME" : "BOXWIDTH",				"ALIGN" : "left"},
            {"HEAD_TEXT" : "포장상자 높이",				"WIDTH" : "100",	"FIELD_NAME" : "BOXHEIGHT",				"ALIGN" : "left"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "픽업요청 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectPickReqList",
            "requestUrl" : "/ems/pick/selectPickReqList.do",
            "headers" : globalVar.REG_TYPE == 'A' ? headers : headersSea,
            "paramsGetter" : {"SN":globalVar.SN, "REG_TYPE":globalVar.REG_TYPE, "SUCCESS_YN":globalVar.SUCCESS_YN},
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort"  : "REGNO",
            "controllers" : [

            ]
        });
        
        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridWrapper.requestToServer();
    });

    // 상세정보 화면
    function fn_showErrorList(index) {
        var size = gridWrapper.getSize();
        if(size == 0){
            gridError.drawGrid();
            return;
        }
        
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"REGNO":data["REGNO"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickReqErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickReqErrPopup" />', spec); // 모달 호츨
    }

    function fn_error(index, val) {
        var data = gridWrapper.getRowData(index);
        var errCode = data["ERROR_CODE"];
        var str = "";
        if (errCode !== undefined && errCode.length > 0) {
            str = "<a href='#this' class='btn_inquiryC' onclick='gfn_gridLink(\"fn_showErrorList\", \"" + (index) + "\")'>오류</a>";
        }
        return str;
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
