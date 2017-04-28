<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers, gridExcel;
    $(function() {
        headers = [ 
            {"HEAD_TEXT" : "수취인명",		"FIELD_NAME" : "RECIPIENT_NAME",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "연락처",			"FIELD_NAME" : "RECIPIENT_PHONE",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "이메일",			"FIELD_NAME" : "RECIPIENT_EMAIL",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "RPT_NO",			"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "STORE_ORDER_NO",	"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "B/L No.",		"FIELD_NAME" : "REGINO",			"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "상세정보",		"FIELD_NAME" : "보기",				"WIDTH" : "100",	"ALIGN" : "center",		"BTN_FNC" : "fn_detail_edit"}, 
            {"HEAD_TEXT" : "등록상태",		"FIELD_NAME" : "STATUS",			"WIDTH" : "60",		"ALIGN" : "center",		"HTML_FNC" : "fn_reg_status"}, 
            {"HEAD_TEXT" : "배송상태",		"FIELD_NAME" : "SHIP_STATUS_NM",	"WIDTH" : "100",	"ALIGN" : "center",		"HTML_FNC" : "fn_ship_status"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "배송요청 상세 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "xpr.selectShipDetailList",
            "requestUrl" : "/xpr/ship/selectShipDetail.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
//             "paramsGetter" : {"SN":globalVar.SN},
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : false,
            "defaultSort"  : "SN, SEQ",
            "controllers" : [ 
                
            ]
        });
        
        // 목록
        $('#btnList').on("click", function (e) {
//             $.comm.forward("xpr/ship/shipList", {});
            $.comm.pageBack();
        });
        
        // 바코드출력
        $('#btn_barcode').on("click", function (e) {
            fn_printPopup();
        });
        
        // 배송요청 목록 팝업
        $('#btn_uploadList').on("click", function(e) {
//             $.comm.open("shipReqFieldsListPopup", '<c:out value="/jspView.do?jsp=xpr/ship/shipReqFieldsListPopup" />' + '&SN='+globalVar.SN, 1100, 650);
            
            $.comm.setModalArguments({"SN":$("#SN").val()});
            var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:shipReqFieldsListPopup";
            $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipReqFieldsListPopup" />', spec); // 모달 호츨
        });
        
        gridWrapper.requestToServer();
    });

    /* 상세정보 수정 화면 */
    function fn_detail_edit(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("xpr/ship/shipDetailInfo", data);
    }
    
    // 배송요청
    function fn_doShipping(index) {
        if (!confirm($.comm.getMessage("C00000033"))) return; //배송요청하시겠습니까?

        var rows = [];
        var data = gridWrapper.getRowData(index);
        rows.push(data);
        $.comm.send("xpr/ship/saveShipReq.do", rows, fn_callback, "배송요청");
    }
    
    function fn_reg_status(index, val) {
        var data = gridWrapper.getRowData(index);
        if (data["STATUS"] == "E") {
            return "<a href='#this' onclick='gfn_gridLink(\"fn_showErrorList\", \"" + (index) + "\")'><span style='color:red'>오류</span></a>";
        }
        else {
            return "<span style='color:green'>정상</span>";
        }
    }
    
    function fn_ship_status(index, val) {
        var data = gridWrapper.getRowData(index);
        if (data["SHIP_STATUS"] == "A") {
            return val;
        }
        else if (data["SHIP_STATUS"] == "B") {
            return "<span style='color:blue'>"+val+"</span>";
        }
        else {
            if (data["STATUS"] != "E") {
                return "<a href='#this' class='btn_inquiryC' onclick='gfn_gridLink(\"fn_doShipping\", \"" + (index) + "\")'>배송요청</a>";
            }
            else {
                return val;
            }
        }
    }
    
    // 오류내용 팝업
    function fn_showErrorList(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"SN":data["SN"], "SEQ":data["SEQ"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:shipExcelErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipExcelErrPopup" />', spec); // 모달 호츨
    }
    
    function fn_printPopup(){
        if (!gridWrapper.getSelectedSize() > 0) {
            alert($.comm.getMessage("I00000029")); //인쇄할 항목을 선택해 주세요.
            return;
        }
        
//         $.comm.open("shipPrintPopup", '<c:out value="/jspView.do?jsp=xpr/ship/shipPrintPopup" />', 400, 380);
        $.comm.setModalArguments({"SN":$("#SN").val()});
        var spec = "width:400px;height:380px;scroll:auto;status:no;center:yes;resizable:yes;windowName:shipPrintPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipPrintPopup" />', spec); // 모달 호츨
    }
    
    function fn_print(params, cnt) {
        fnReportPrint('BARCODE', params, '바코드 출력');
    }
    
    function fn_callback() {
        gridWrapper.requestToServer();
    }
    
</script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">

        <form id="searchForm">
            <input type="hidden" id="SN" name="SN" value="${SN}" />
            
            <div class="search_toggle_frame">
                <div class="search_frame on">
                    <ul class="search_sectionC">
                        <li>
                            <label for="SEARCH_REG_STATUS" class="search_title">등록상태</label> 
                            <select name="SEARCH_REG_STATUS" id="SEARCH_REG_STATUS" class="search_input_select">
                                <option value="">전체</option>
                                <option value="NORMAL">정상</option>
                                <option value="ERROR">오류</option>
                            </select>
                        </li>
                        <li>
                            <label for="SEARCH_SHIP_STATUS" class="search_title">배송상태</label> 
                            <select name="SEARCH_SHIP_STATUS" id="SEARCH_SHIP_STATUS" class="search_input_select">
                                <option value="">전체</option>
                                <option value="REQUEST">배송요청</option>
                                <option value="NOT_REQUESTED">배송미요청</option>
                            </select>
                        </li>
                    </ul>
                </div>
            </div>
        </form>

        <div class="list_typeA">
            <div class="util_frame">
                <a href="##" class="btn white_84" id="btnList">목록</a>
                <a href="##" class="btn white_84" id="btn_barcode">바코드 출력</a>
<!--                 <a href="##" class="btn white_84" id="btn_uploadList">배송요청 목록</a> -->
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 400px">
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
