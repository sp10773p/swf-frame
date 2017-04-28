<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {

        fn_setCombo(); 	//공통콤보  조회
        
        headers = [ 
            {"HEAD_TEXT" : "특송사",			"FIELD_NAME" : "EXPRESS_NM",		"WIDTH" : "280",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "업로드 일시",		"FIELD_NAME" : "REG_DTM",			"WIDTH" : "160",	"ALIGN" : "center",	"LINK" : "fn_detail"}, 
            {"HEAD_TEXT" : "엑셀 건수",		"FIELD_NAME" : "TOT_CNT",			"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "정상 건수",		"FIELD_NAME" : "REG_CNT",			"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_reg_cnt_popup", "COLR" : "GREEN"}, 
            {"HEAD_TEXT" : "오류 건수",		"FIELD_NAME" : "ERR_CNT",			"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_err_cnt_popup", "COLR" : "RED"},
            {"HEAD_TEXT" : "업로드 내역",		"FIELD_NAME" : "상세보기",			"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_excel_popup"},
//             {"HEAD_TEXT" : "배송대기 건수",	"FIELD_NAME" : "SHIP_TOT_CNT",		"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "요청 건수",		"FIELD_NAME" : "SHIP_REG_CNT",		"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "접수 건수",		"FIELD_NAME" : "SHIP_REC_CNT",		"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"}
        ];
        
        gridWrapper = new GridWrapper({
            "actNm" : "배송요청 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "xpr.selectShipList",
            "requestUrl" : "/xpr/ship/selectShipList.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : false,
            "defaultSort" : "SN DESC",
            "postScript" : fn_postScript,
            "controllers" : [ 
                {"btnName" : "btnSearch", "type" : "S"} 
            ]
        });
        
        // 엑셀업로드
        $('#btnCheck').on("click", function(e) {
            $.comm.open("pickUploadPopup", '<c:out value="/jspView.do?jsp=xpr/ship/shipUploadPopup" />', 550, 300);
        });
        
        // 배송요청
        $('#btn_shipping').on("click", function(e) {
            fn_pickup();
        });
        
        $.comm.initPageParam();
        gridWrapper.requestToServer();
    });
    
    function fn_postScript() {
        $("input:checkbox[name=gridLayerChk]").each(function(index, obj){
            var data = gridWrapper.getRowData(index);
            if (data["REG_CNT"] == data["SHIP_REG_CNT"]) {
                $(this).attr("disabled", true);
            }
        });
    }
    
    function fn_setCombo() {
        $.comm.bindCustCombo('EXPRESS_BIZ_NO', "xpr.selectExpressUsers", true);
    }

    /***
     * 배송예약 상세 조회
     * @param index
     */
    function fn_detail(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("xpr/ship/shipDetail", data);
    }
    
    // 특송사 배송요청 업로드내역 상세 팝업 (정상)
    function fn_reg_cnt_popup (index) {
        var SUCCESS_YN = "Y";
        fn_excel_popup(index, SUCCESS_YN)
    }
    
    // 특송사 배송요청 업로드내역 상세 팝업 (오류)
    function fn_err_cnt_popup (index) {
        var SUCCESS_YN = "N";
        fn_excel_popup(index, SUCCESS_YN)
    }
    
    // 특송사 배송요청 업로드내역 상세 팝업
    function fn_excel_popup(index, SUCCESS_YN) {
        var data = gridWrapper.getRowData(index);
        var sn = data["SN"];
//         $.comm.open("shipExcelPopup", '<c:out value="/jspView.do?jsp=xpr/ship/shipExcelPopup" />'+"&SN="+sn, 1100, 600);
        $.comm.setModalArguments({"SN":data["SN"], "SUCCESS_YN":SUCCESS_YN});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:shipExcelPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=xpr/ship/shipExcelPopup" />', spec); // 모달 호츨
    }
    
    // 특송 배송요청
    function fn_pickup() {
        if (!gridWrapper.getSelectedSize() > 0) {
            alert($.comm.getMessage("W00000053")); //배송요청할 항목을 선택해 주세요.
            return;
        }
        
        if (!confirm($.comm.getMessage("C00000033"))) return; //배송요청하시겠습니까?

        var rows = gridWrapper.getSelectedRows();
        $.comm.send("xpr/ship/saveShipReq.do", rows, fn_callback, "배송요청");
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
                            <label for="EXPRESS_BIZ_NO" class="search_title">특송사</label> 
                            <select name="EXPRESS_BIZ_NO" id="EXPRESS_BIZ_NO" class="search_input_select"></select>
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
                <a href="##" class="btn white_84" id="btn_shipping">배송요청</a>
                <a href="<c:url value="/form/xpr_template.xls" />" class="btn white_147">표준 엑셀폼 다운로드</a>
                <a href="##" class="btn white_84" id="btnCheck">엑셀업로드</a>
                <a href="##" id="btnUpload" style="display:none"></a>
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
