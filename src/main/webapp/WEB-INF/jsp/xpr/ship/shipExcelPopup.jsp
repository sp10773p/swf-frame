<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers;
    var globalVar = {
        "SN" : "",
        "SUCCESS_YN" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        globalVar.SN = arguments.SN;
        globalVar.SUCCESS_YN = arguments.SUCCESS_YN;
        headers = [ 
            {"HEAD_TEXT" : "오류",						"WIDTH" : "100",	"FIELD_NAME" : "오류",				"ALIGN" : "center",	"HTML_FNC": "fn_error"},
            {"HEAD_TEXT" : "운송장번호",					"WIDTH" : "150",	"FIELD_NAME" : "REGINO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"}, 
            {"HEAD_TEXT" : "수출신고번호",				"WIDTH" : "150",	"FIELD_NAME" : "RPT_NO",			"ALIGN" : "left",	"HTML_FNC": "fn_html"}, 
            {"HEAD_TEXT" : "판매 쇼핑몰",					"WIDTH" : "100",	"FIELD_NAME" : "STORE_NAME",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문일자",					"WIDTH" : "100",	"FIELD_NAME" : "ORDER_DATE",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "주문번호",					"WIDTH" : "200",	"FIELD_NAME" : "STORE_ORDER_NO",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품구분",					"WIDTH" : "200",	"FIELD_NAME" : "PROD_DESC",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 이름",					"WIDTH" : "100",	"FIELD_NAME" : "RECIPIENT_NAME",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 전화",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_PHONE",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 이메일",				"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_EMAIL",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 주소1",				"WIDTH" : "350",	"FIELD_NAME" : "RECIPIENT_ADDRESS1","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 주소2",				"WIDTH" : "200",	"FIELD_NAME" : "RECIPIENT_ADDRESS2","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 도시",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_CITY",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 주",					"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_STATE",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 우편번호",				"WIDTH" : "150",	"FIELD_NAME" : "RECIPIENT_ZIPCD",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수취인 국가",					"WIDTH" : "100",	"FIELD_NAME" : "RECIPIENT_COUNTRY",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "배송 서비스",					"WIDTH" : "100",	"FIELD_NAME" : "DELIVERY_OPTION",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "총무게",						"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_WEIGHT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "무게 단위",					"WIDTH" : "100",	"FIELD_NAME" : "WEIGHT_UNIT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "총포장수",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_CNT",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "총포장 단위",					"WIDTH" : "100",	"FIELD_NAME" : "TOTAL_PACK_UNIT",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "가로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_WIDTH",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "세로 길이",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_LENGTH",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "높이",						"WIDTH" : "100",	"FIELD_NAME" : "BOX_HEIGHT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "크기 단위",					"WIDTH" : "100",	"FIELD_NAME" : "BOX_DIMENSION_UNIT","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "수량 단위",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY_UNIT","ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "통화 단위",					"WIDTH" : "100",	"FIELD_NAME" : "CURRENCY_UNIT",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 수량 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY1",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 가격 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE1",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 분류 1",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY1",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 무게 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "원산지 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HSCODE 1",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE1",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU1",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "소재 1",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION1",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 수량 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 가격 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 분류 2",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 무게 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "원산지 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HSCODE 2",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE2",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU2",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "소재 2",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION2",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 수량 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY3",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 가격 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE3",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 분류 3",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY3",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 무게 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "원산지 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HSCODE 3",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE3",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU3",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "소재 3",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION3",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 수량 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY4",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 가격 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE4",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 분류 4",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY4",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 무게 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "원산지 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HSCODE 4",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE4",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU4",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "소재 4",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION4",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_TITLE5",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 수량 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_QUANTITY5",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 가격 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_SALE_PRICE5",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 분류 5",					"WIDTH" : "200",	"FIELD_NAME" : "ITEM_CATEGORY5",	"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "상품 무게 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_WEIGHT5",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "원산지 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_ORIGIN5",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "HSCODE 5",					"WIDTH" : "100",	"FIELD_NAME" : "ITEM_HSCODE5",		"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "SKU 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_SKU5",			"ALIGN" : "left",	"HTML_FNC": "fn_html"},
            {"HEAD_TEXT" : "소재 5",						"WIDTH" : "200",	"FIELD_NAME" : "ITEM_COMPOSITION5",	"ALIGN" : "left",	"HTML_FNC": "fn_html"}
        ];
        
        gridWrapper = new GridWrapper({
            "actNm" : "배송요청 업로드 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "xpr.selectShipExcelList",
            "requestUrl" : "/xpr/ship/selectShipExcelList.do",
            "headers" : headers,
            "paramsGetter" : {"SN":globalVar.SN, "SUCCESS_YN":globalVar.SUCCESS_YN},
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort" : "SN, SEQ",
            "controllers" : [

            ]
        });
        
        // 배송요청
        $('#btn_shipping').on("click", function(e) {
            fn_shipping();
        });

        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridWrapper.requestToServer();
    });
    
    // 특송사 배송요청
    function fn_shipping() {
        if (checkRemainCnt() == 0) {
            alert($.comm.getMessage("I00000021")); //요청할 내용이 없습니다.
            return;
        }
        
        if (!confirm($.comm.getMessage("C00000033"))) return; //배송요청하시겠습니까?

        var params = new Array();
        var param = {"SN":globalVar.SN};
        params.push(param);
        $.comm.send("xpr/ship/saveShipReq.do", params, fn_callback, "배송요청");
    }
    
    // 배송요청 대상건 조회
    function checkRemainCnt() {
        var params = {"SN":globalVar.SN, "qKey":"xpr.selectXprShipReqExcelChk"};
        var info = $.comm.sendSync("/common/select.do", params, "배송요청 대상건 조회").data;
        return info.CNT;
    }
    
    // 배송요청 callback
    var fn_callback = function (data) {
        opener.gridWrapper.requestToServer();
        self.close();
    }
    
    // 오류내용 팝업
    function fn_showErrorList(index) {
        var size = gridWrapper.getSize();
        if(size == 0){
            gridError.drawGrid();
            return;
        }
        
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"SN":data["SN"], "SEQ":data["SEQ"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickExcelErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipExcelErrPopup" />', spec); // 모달 호츨
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
                <a href="##" class="btn white_84" id="btn_shipping">배송요청</a>
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
