<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        headers = [ 
            {"HEAD_TEXT" : "특송사 사업자번호",			"WIDTH" : "150",	"FIELD_NAME" : "EXPRESS_BIZ_NO",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인명",					"WIDTH" : "150",	"FIELD_NAME" : "SENDER",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "SENDERZIPCODE",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소1(상세)",			"WIDTH" : "250",	"FIELD_NAME" : "SENDERADDR1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 주소2(기본)",			"WIDTH" : "250",	"FIELD_NAME" : "SENDERADDR2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호1",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERTELNO1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호2",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERTELNO2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호3",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERTELNO3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 전화번호4",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERTELNO4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신1",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERMOBILE1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신2",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERMOBILE2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신3",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERMOBILE3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이동통신4",				"WIDTH" : "100",	"FIELD_NAME" : "SENDERMOBILE4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "SENDEREMAIL",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "운송장번호",					"WIDTH" : "150",	"FIELD_NAME" : "REGINO",			"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "수출신고번호",				"WIDTH" : "150",	"FIELD_NAME" : "RPT_NO",			"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "판매 쇼핑몰",					"WIDTH" : "100",	"FIELD_NAME" : "STORE_NAME",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문일자",					"WIDTH" : "100",	"FIELD_NAME" : "ORDER_DATE",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문번호",					"WIDTH" : "200",	"FIELD_NAME" : "STORE_ORDER_NO",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "200",	"FIELD_NAME" : "PROD_DESC",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 이름",					"WIDTH" : "100",	"FIELD_NAME" : "RECIPIENT_NAME",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 전화",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_PHONE",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_EMAIL",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 주소1",				"WIDTH" : "350",	"FIELD_NAME" : "RECIPIENT_ADDRESS1","ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 주소2",				"WIDTH" : "200",	"FIELD_NAME" : "RECIPIENT_ADDRESS2","ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 도시",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_CITY",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 주",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_STATE",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_ZIPCD",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인 국가",					"WIDTH" : "100",	"FIELD_NAME" : "RECIPIENT_COUNTRY",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "배송 서비스",					"WIDTH" : "100",	"FIELD_NAME" : "DELIVERY_OPTION",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "총무게",						"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_WEIGHT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "무게 단위",					"WIDTH" : "100",	"FIELD_NAME" : "WEIGHT_UNIT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "총포장수",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_CNT",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "총포장 단위",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_UNIT",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "가로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_WIDTH",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "세로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_LENGTH",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "높이",						"WIDTH" : "100",	"FIELD_NAME" : "BOX_HEIGHT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "크기 단위",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_DIMENSION_UNIT","ALIGN" : "left"},
            {"HEAD_TEXT" : "수량 단위",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY_UNIT","ALIGN" : "left"},
            {"HEAD_TEXT" : "통화 단위",					"WIDTH" : "100",	"FIELD_NAME" : "CURRENCY_UNIT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 가격 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 분류 1",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "원산지 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 가격 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 분류 2",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "원산지 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 가격 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 분류 3",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "원산지 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 가격 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 분류 4",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "원산지 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE5",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY5",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 가격 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE5",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 분류 5",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY5",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT5",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "원산지 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN5",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE5",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU5",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION5",	"ALIGN" : "left"}
        ];
        
        gridWrapper = new GridWrapper({
            "actNm" : "배송요청목록 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "xpr.shipReqFieldsList",
            "requestUrl" : "/xpr/ship/selectShipReqFieldsList.do",
            "headers" : headers,
            "paramsGetter" : {"SN":arguments.SN},
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort" : "REGNO",
            "fieldSelect" : true,
            "controllers" : [
                {"btnName": "btnExcel", "type": "EXCEL", "qKey":"xpr.shipReqFieldsList"}
            ]
        });
        
        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridWrapper.requestToServer();
    });
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
                <a href="##" class="btn white_84" id="btnExcel">엑셀다운로드</a>
            </div><!-- //util_frame -->
            
            <div id="gridLayer" style="height: 400px"></div>
            <div class="bottom_util">
                <div class="paging" id="gridPagingLayer">
                </div>
            </div>
        </div><!-- //title_frame -->
    </div><!-- //layerContainer -->

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
