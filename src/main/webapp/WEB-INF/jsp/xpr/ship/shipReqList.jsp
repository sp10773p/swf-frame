<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<s:eval expression="@config.getProperty('summary.from.date.period')" var="datePeriod"/>
<script>
    var gridWrapper, headers, headersExcel;
    $(function() {
        $.comm.bindCombo("XPR_SHIP_STATUS", "XPR_SHIP_STATUS", true, null, null, null, 1);

        // 로그인 화면의 배송요청접수확인에서 링크
        if(!$.comm.isNull(parent.mfn_getVariable("DEC_STATUS"))){
            var status = parent.mfn_getVariable("DEC_STATUS");
            if(status == "EXPRESS_REC_COUNT"){ // 배송요청접수확인
                $('#XPR_SHIP_STATUS').val("B");
            }

            $('#F_REG_DTM').val(new Date().dateAdd2("d", parseInt("${datePeriod}")*-1).format('YYYY-MM-DD'));
            $('#T_REG_DTM').val(new Date().format('YYYY-MM-DD'));

            parent.mfn_getVariable("DEC_STATUS", null);
        }

        headers = [ 
            {"HEAD_TEXT" : "상태",			"FIELD_NAME" : "STATUS",			"WIDTH" : "100",	"ALIGN" : "center",	"HTML_FNC" : "fn_status"},
//             {"HEAD_TEXT" : "배송요청 목록",	"FIELD_NAME" : "상세보기",			"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_fields_popup"},
            {"HEAD_TEXT" : "상세정보",		"FIELD_NAME" : "보기",				"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_detail"},
            {"HEAD_TEXT" : "운송장번호",		"FIELD_NAME" : "REGINO",			"WIDTH" : "150",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "RPT_NO",			"WIDTH" : "150",	"ALIGN" : "center",	"LINK" : "fn_popLink"}, 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "STORE_ORDER_NO",	"WIDTH" : "150",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "수취인명",		"FIELD_NAME" : "RECIPIENT_NAME",	"WIDTH" : "100",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "연락처",			"FIELD_NAME" : "RECIPIENT_PHONE",	"WIDTH" : "150",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "이메일",			"FIELD_NAME" : "RECIPIENT_EMAIL",	"WIDTH" : "150",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "국가",			"FIELD_NAME" : "RECIPIENT_COUNTRY",	"WIDTH" : "50",		"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "주",				"FIELD_NAME" : "RECIPIENT_STATE",	"WIDTH" : "150",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "도시",			"FIELD_NAME" : "RECIPIENT_CITY",	"WIDTH" : "150",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "우편번호",		"FIELD_NAME" : "RECIPIENT_ZIPCD",	"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "주소",			"FIELD_NAME" : "RECIPIENT_ADDRESS1","WIDTH" : "300",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "주소 (상세)",		"FIELD_NAME" : "RECIPIENT_ADDRESS2","WIDTH" : "200",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "분류",			"FIELD_NAME" : "ITEM_CATEGORY1",	"WIDTH" : "150",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "품명",			"FIELD_NAME" : "ITEM_TITLE1",		"WIDTH" : "200",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "수량",			"FIELD_NAME" : "ITEM_QUANTITY1",	"WIDTH" : "100",	"ALIGN" : "right"}, 
            {"HEAD_TEXT" : "중량",			"FIELD_NAME" : "ITEM_WEIGHT1",		"WIDTH" : "100",	"ALIGN" : "right"},
            {"HEAD_TEXT" : "총중량",			"FIELD_NAME" : "TOTAL_WEIGHT",		"WIDTH" : "100",	"ALIGN" : "right"}, 
            {"HEAD_TEXT" : "금액",			"FIELD_NAME" : "ITEM_SALE_PRICE1",	"WIDTH" : "100",	"ALIGN" : "right"}, 
            {"HEAD_TEXT" : "통화",			"FIELD_NAME" : "CURRENCY_UNIT",		"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "등록일시",		"FIELD_NAME" : "REG_DTM",			"WIDTH" : "140",	"ALIGN" : "center"} 
        ];
        
        gridWrapper = new GridWrapper({
            "actNm" : "배송요청 리스트 조회 (특송사)",
            "targetLayer" : "gridLayer",
            "qKey" : "xpr.selectShipReqList",
            "requestUrl" : "/xpr/ship/selectShipReqList.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : false,
//             "postScript" : fn_postScript,
            "controllers" : [ 
                {"btnName" : "btnSearch", "type" : "S", "preScript":fn_search_preScript},
                {"btnName" : "btn_excel", "type": "EXCEL", "qKey": "xpr.selectShipReportListAll", "preScript":fn_excel_preScript}
            ]
        });
        
//         headersExcel = [ 
//             {"HEAD_TEXT" : "운송장번호",		"FIELD_NAME" : "REGINO",			"WIDTH" : "100",	"ALIGN" : "center"}, 
//             {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "RPT_NO",			"WIDTH" : "100",	"ALIGN" : "center"}, 
//             {"HEAD_TEXT" : "수량",			"FIELD_NAME" : "ITEM_QUANTITY",		"WIDTH" : "100",	"ALIGN" : "right"}, 
//             {"HEAD_TEXT" : "중량",			"FIELD_NAME" : "ITEM_WEIGHT",		"WIDTH" : "100",	"ALIGN" : "right"}, 
//             {"HEAD_TEXT" : "분할선적여부",	"FIELD_NAME" : "SPLIT_YN",			"WIDTH" : "100",	"ALIGN" : "center"}, 
//             {"HEAD_TEXT" : "동시포장여부",	"FIELD_NAME" : "MERGE_YN",			"WIDTH" : "100",	"ALIGN" : "center"} 
//         ];

        headersExcel = [ 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDER_NO",							"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "운송장번호",		"FIELD_NAME" : "REGINO",							"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "EXP_DECL_NO",						"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "수리일자",		"FIELD_NAME" : "CONFIRM_DATE_TIME",					"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "총중량",			"FIELD_NAME" : "TOTAL_PACKAGE_WEIGHT",				"WIDTH" : "100",	"ALIGN" : "right"},
            {"HEAD_TEXT" : "총중량단위",		"FIELD_NAME" : "TOTAL_PACKAGE_WEIGHT_UNIT_CODE",	"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "총포장수",		"FIELD_NAME" : "TOTAL_PACKAGE_QUANTITY",			"WIDTH" : "100",	"ALIGN" : "right"},
            {"HEAD_TEXT" : "총포장수단위",	"FIELD_NAME" : "TOTAL_PACKAGE_UNIT_CODE",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수량",			"FIELD_NAME" : "QUANTITY",							"WIDTH" : "100",	"ALIGN" : "right"}, 
            {"HEAD_TEXT" : "수량단위",		"FIELD_NAME" : "QUANTITY_UNIT_CODE",				"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "동시포장여부",	"FIELD_NAME" : "SUM_PACKING",						"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "분할포장여부",	"FIELD_NAME" : "DIVISION_PACKING",					"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "검사대상여부",	"FIELD_NAME" : "INSPECTION_TARGET",					"WIDTH" : "100",	"ALIGN" : "center"} 
        ];

        // 접수확인
        $('#btn_confirm').on("click", function(e) {
            fn_receipt();
        });
        
        $.comm.initPageParam();
        gridWrapper.requestToServer();
    });
    
    // 조회 후
    function fn_postScript() {
        $("input:checkbox[name=gridLayerChk]").each(function(index, obj){
            var data = gridWrapper.getRowData(index);
            if (data["STATUSCD"] == "B") {
                $(this).attr("disabled", true);
            }
        });
    }
    
    // 조회 버튼 클릭 전
    function fn_search_preScript() {
        gridWrapper.setHeaders(headers);
        gridWrapper.setQKey("xpr.selectShipReqList");
        return true;
    }
    
    // 엑셀 버튼 클릭 전
    function fn_excel_preScript() {
        var rows = gridWrapper.getSelectedRows();
        
        if (rows == 0 && gridWrapper.getSize() == 0) {
            alert($.comm.getMessage("I00000040")); //검색된 자료가 없습니다.
            return;
        }
        
        var regnos = [];
        $.each (rows, function(index, value) {
            regnos[index] = value["REGNO"]
        });
        
        if (regnos.length > 0) {
            gridWrapper.addParam("REGNOS", regnos);
        }
        gridWrapper.setHeaders(headersExcel);
        gridWrapper.setQKey("xpr.selectShipReportListAll");
        return true;
    }
    
    // 처리상태
    function fn_status(index, val) {
        var data = gridWrapper.getRowData(index);
        if (data["STATUSCD"] == "B") {
            return "<span style='color:blue'>"+val+"</span>";
        }
        else {
            return val;
        }
    }
    
    // 접수확인
    function fn_receipt() {
        if (!gridWrapper.getSelectedSize() > 0) {
            alert($.comm.getMessage("W00000046", "접수할 항목")); // 접수할 항목을 선택하세요.
            return;
        }
        
        var receiptCnt = 0;
        var rows = gridWrapper.getSelectedRows();
        $.each (rows, function(index, value) {
            if (value["STATUSCD"] == "B") receiptCnt++; // 접수확인
        });
        
        if (receiptCnt == gridWrapper.getSelectedSize()) {
            alert($.comm.getMessage("I00000039")); //이미 접수확인된 건입니다.
            return;
        }
        
        var messageCode = receiptCnt > 0 ? "C00000038" : "C00000002";
        if (!confirm($.comm.getMessage(messageCode))) return; //저장 하시겠습니까?

        $.comm.send("xpr/ship/saveShipReqStatus.do", rows, fn_callback, "배송요청");
    }
    
     // 배송요청 상세 조회
    function fn_detail(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("xpr/ship/shipReqDetailInfo", data);
    }
     
     // 수출신고 상세 조회
    function fn_popLink(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"RPT_NO":data["RPT_NO"]});
//         $.comm.setModalArguments({"RPT_NO":"1308616601160X"});
        var spec = "width:800px;height:700px;scroll:auto;status:no;center:yes;resizable:yes;";
        // 모달 호츨
        $.comm.dialog("<c:out value='/jspView.do?jsp=exp/dec/decResInfoPopup' />", spec,
            function () { // 리턴받을 callback 함수
                var ret = $.comm.getModalReturnVal();
                if (ret) {
                
                }
            }
        );
    }
    
    function fn_fields_popup(index) {
        var data = gridWrapper.getRowData(index);
//         $.comm.open("shipExcelPopup", '<c:out value="/jspView.do?jsp=xpr/ship/shipExcelPopup" />'+"&SN="+sn, 1100, 600);
        $.comm.setModalArguments({"SN":data["SN"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:shipReqFieldsListPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipReqFieldsListPopup" />', spec); // 모달 호츨
    }
    
    function fn_callback() {
        gridWrapper.requestToServer();
    }
    
</script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
            <div class="search_frame on">
                <form id="reportForm" name="reportForm">
                    
                </form>
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
                        <li>
                            <label for="XPR_SHIP_STATUS" class="search_title">접수상태</label> 
                            <select name="XPR_SHIP_STATUS" id="XPR_SHIP_STATUS" class="search_input_select"></select>
                        </li>
                        <li>
                            <label for="SEARCH_COL" class="search_title">검색조건</label> 
                            <label for="SEARCH_TXT" class="search_title" style="display: none">검색조건 TEXT</label>
                            <select name="SEARCH_COL" id="SEARCH_COL" class="search_input_select">
                                <option value="regi_no" selected>운송장번호</option>
                                <option value="exprt_no">수출신고번호</option>
                                <option value="order_no">주문번호</option>
                            </select>
                            <input type="text" class="search_input" id="SEARCH_TXT" name="SEARCH_TXT" <attr:pk/> />
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
                <a href="##" class="btn white_84" id="btn_confirm">접수확인</a>
                <a href="##" class="btn white_173" id="btn_excel">이행신고용 엑셀 다운로드</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 414px"></div>
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
