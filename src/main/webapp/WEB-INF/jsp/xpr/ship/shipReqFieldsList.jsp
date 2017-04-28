<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        headers = [ 
            {"HEAD_TEXT" : "특송사",						"WIDTH" : "250",	"FIELD_NAME" : "EXPRESS_NM",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "특송사 사업자번호",			"WIDTH" : "120",	"FIELD_NAME" : "EXPRESS_BIZ_NO",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "발송인명",					"WIDTH" : "150",	"FIELD_NAME" : "SENDER",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "발송인 우편번호",				"WIDTH" : "120",	"FIELD_NAME" : "SENDERZIPCODE",		"ALIGN" : "center"},
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
            {"HEAD_TEXT" : "발송인 이메일",				"WIDTH" : "200",	"FIELD_NAME" : "SENDEREMAIL",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "운송장번호",					"WIDTH" : "150",	"FIELD_NAME" : "REGINO",			"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "수출신고번호",				"WIDTH" : "130",	"FIELD_NAME" : "RPT_NO",			"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "판매 쇼핑몰",					"WIDTH" : "100",	"FIELD_NAME" : "STORE_NAME",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문일자",					"WIDTH" : "100",	"FIELD_NAME" : "ORDER_DATE",		"ALIGN" : "left",	"DATA_TYPE" : "DAT"},
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
            {"HEAD_TEXT" : "총무게",						"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_WEIGHT",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "무게 단위",					"WIDTH" : "100",	"FIELD_NAME" : "WEIGHT_UNIT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "총포장수",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_CNT",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "총포장 단위",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_UNIT",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "가로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_WIDTH",			"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "세로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_LENGTH",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "높이",						"WIDTH" : "100",	"FIELD_NAME" : "BOX_HEIGHT",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "크기 단위",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_DIMENSION_UNIT","ALIGN" : "left"},
            {"HEAD_TEXT" : "수량 단위",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY_UNIT","ALIGN" : "left"},
            {"HEAD_TEXT" : "통화 단위",					"WIDTH" : "100",	"FIELD_NAME" : "CURRENCY_UNIT",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY1",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 가격 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE1",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 분류 1",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT1",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "원산지 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE1",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU1",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION1",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY2",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 가격 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE2",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 분류 2",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT2",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "원산지 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE2",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU2",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION2",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY3",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 가격 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE3",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 분류 3",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT3",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "원산지 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE3",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU3",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION3",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY4",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 가격 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE4",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 분류 4",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT4",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "원산지 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "HSCODE 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE4",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "SKU 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU4",			"ALIGN" : "left"},
            {"HEAD_TEXT" : "소재 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION4",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE5",		"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 수량 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY5",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 가격 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE5",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "상품 분류 5",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY5",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "상품 무게 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT5",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
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
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort" : "REGNO",
            "fieldSelect" : true,
            "fieldSelectId" : "gridLayerFieldSelect",
            "controllers" : [
                {"btnName": "btnExcel", "type": "EXCEL", "qKey":"xpr.shipReqFieldsList"},
                {"btnName": "btnSearch", "type" : "S"}
            ]
        });
        
        $.comm.bindCustCombo('EXPRESS_BIZ_NO', "xpr.selectExpressUsers", true);
        $.comm.bindCombos.addComboInfo("SEARCH_COUNTRY_CD", "CUS0005", true, null, 3, true);	//수취인국가
        $.comm.bindCombos.draw();
        
        // 필드선택
        $("#gridLayerFieldSelect").hover(
            function(event) {
                $(this).css("background-color","#737373").css('cursor', 'hand');
            },
            function(event) {
                $(this).css("background-color","#15a4fa").css('cursor', 'default');
            }
        );
        
        gridWrapper.requestToServer();
    });
</script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
            <div class="search_frame on">
                <form id="searchForm" name="searchForm">
                    <ul class="search_sectionC">
                        <li>
                            <label for="F_REG_DTM" class="search_title">등록일자</label>
                            <label for="T_REG_DTM" class="search_title" style="display: none">등록일자</label>
                            <div class="search_date">
                                <fieldset>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" <attr:datefield to="T_REG_DTM" value="-1m"/> >
                                    <span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" <attr:datefield value="0"/>>
                                </fieldset>
                            </div>
                        </li>
                        <c:if test="${session.getUserDiv() ne 'E'}">
                        <li>
                            <label for="EXPRESS_BIZ_NO" class="search_title">특송사</label> 
                            <select name="EXPRESS_BIZ_NO" id="EXPRESS_BIZ_NO" class="search_input_select"></select>
                        </li>
                        </c:if>
                        <li>
                            <label for="SEARCH_COL" class="search_title">검색조건</label> 
                            <label for="SEARCH_TXT" class="search_title" style="display: none">검색조건 TEXT</label>
                            <select name="SEARCH_COL" id="SEARCH_COL" class="search_input_select">
                                <option value="order_no" selected>주문번호</option>
                                <option value="exprt_no">수출신고번호</option>
                                <option value="regi_no">운송장번호</option>
                            </select>
                            <input type="text" class="search_input" id="SEARCH_TXT" name="SEARCH_TXT" <attr:pk/> />
                        </li>
                        <li>
                            <label for="SEARCH_COUNTRY_CD" class="search_title">수취국가코드</label> 
                            <select name="SEARCH_COUNTRY_CD" id="SEARCH_COUNTRY_CD" class="search_input_select" style="width:300px;"></select>
                        </li>
                    </ul>
                    <!-- search_sectionC -->
                    <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
                </form>
            </div><!-- search_frame -->
            <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
                <div class="util_left64">
                    <p class="total">Total <span id="totCnt"></span><span id="gridLayerFieldSelect" style="background: #15a4fa;">필드선택</span><span style="background: #ffffff; color:#808080">* 필드선택을 통해 리스트에 보여지는 필드를 변경할 수 있습니다.</span></p>
                </div>
                <a href="##" class="btn white_84" id="btnExcel">엑셀다운로드</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 414px">
            </div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<!-- //inner-box -->
<%@ include file="/WEB-INF/include/include-body.jspf"%>
</body>
</html>
