<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        headers = [
//             {"HEAD_TEXT" : "등록구분",		"FIELD_NAME" : "REG_TYPE_NM",	"WIDTH" : "150",	"ALIGN" : "center"}, /* 한중해상특송 사용시 주석해제 */
            {"HEAD_TEXT" : "업로드 일시",		"FIELD_NAME" : "REG_DTM",		"WIDTH" : "160",	"ALIGN" : "center",	"LINK" : "fn_detail"},
            {"HEAD_TEXT" : "엑셀 건수",		"FIELD_NAME" : "TOT_CNT",		"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "정상 건수",		"FIELD_NAME" : "REG_CNT",		"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_reg_cnt_popup",		"COLR" : "GREEN"},
            {"HEAD_TEXT" : "오류 건수",		"FIELD_NAME" : "ERR_CNT",		"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_err_cnt_popup",		"COLR" : "RED"},
            {"HEAD_TEXT" : "업로드 내역",		"FIELD_NAME" : "상세보기",		"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_excel_popup"},
            {"HEAD_TEXT" : "합배송 관리",		"FIELD_NAME" : "관리",			"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_merge"},
            {"HEAD_TEXT" : "픽업요청 건수",	"FIELD_NAME" : "PIC_TOT_CNT",	"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "정상 건수",		"FIELD_NAME" : "PIC_REG_CNT",	"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_pic_reg_cnt_popup",	"COLR" : "GREEN"},
            {"HEAD_TEXT" : "오류 건수",		"FIELD_NAME" : "PIC_ERR_CNT",	"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM",	"LINK" : "fn_pic_err_cnt_popup",	"COLR" : "RED"},
            {"HEAD_TEXT" : "픽업요청 내역",	"FIELD_NAME" : "상세보기",		"WIDTH" : "100",	"ALIGN" : "center",	"BTN_FNC" : "fn_req_popup"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "픽업요청 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectPickList",
            "requestUrl" : "/ems/pick/selectPickList.do",
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
        
        $.comm.bindCombo("EMS_REG_TYPE", "EMS_REG_TYPE", true, null, null, null, 1);
        
        singleFileUtil = new FileUtil({
            "id" : "file",
            "addBtnId" : "btnUpload",
            "extNames" : [ "xls", "xlsx" ],
            "successCallback" : fn_callback,
            "postService" : "emsService.uploadPickExcel"
        });
        
        // 엑셀업로드 파일선택 팝업
        $('#btn_upload').on("click", function(e) {
            $.comm.open("pickUploadPopup", '<c:out value="/jspView.do?jsp=ems/pick/pickUploadPopup" />', 350, 280);
        });
        
        // 픽업요청
        $('#btn_pickup').on("click", function(e) {
            fn_pickup();
        });
        
        $.comm.initPageParam();
        gridWrapper.requestToServer();
    });
    
    function fn_postScript() {
        $("input:checkbox[name=gridLayerChk]").each(function(index, obj){
            var data = gridWrapper.getRowData(index);
            if (data["REG_CNT"] == data["PIC_REG_CNT"]) {
                $(this).attr("disabled", true);
            }
        });
    }
    
    /***
     * 픽업요청 상세 조회
     * @param index
     */
    function fn_detail(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("ems/pick/pickDetail", data);
    }

    // 합배송관리 상세정보 화면
    function fn_merge(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("ems/pick/pickMerge", data);
    }
    
    // EMS 픽업요청 업로드내역 상세 팝업 (정상)
    function fn_reg_cnt_popup (index) {
        var SUCCESS_YN = "Y";
        fn_excel_popup(index, SUCCESS_YN)
    }
    
    // EMS 픽업요청 업로드내역 상세 팝업 (오류)
    function fn_err_cnt_popup (index) {
        var SUCCESS_YN = "N";
        fn_excel_popup(index, SUCCESS_YN)
    }
    
    // EMS 픽업요청 업로드내역 상세 팝업
    function fn_excel_popup(index, SUCCESS_YN) {
        var data = gridWrapper.getRowData(index);
        var sn = data["SN"];
        var regType = data["REG_TYPE"];
//      $.comm.open("pickExcelPopup", '<c:out value="/jspView.do?jsp=ems/pick/pickExcelPopup" />'+"&SN="+sn+"&REG_TYPE="+regType, 1100, 746);
        $.comm.setModalArguments({"SN":data["SN"], "REG_TYPE":data["REG_TYPE"], "SUCCESS_YN":SUCCESS_YN});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickExcelPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickExcelPopup" />', spec); // 모달 호츨
    }
    
    // EMS 픽업요청 처리내역 상세 팝업 (정상)
    function fn_pic_reg_cnt_popup (index) {
        var SUCCESS_YN = "Y";
        fn_req_popup(index, SUCCESS_YN)
    }
    
    // EMS 픽업요청 처리내역 상세 팝업 (오류)
    function fn_pic_err_cnt_popup (index) {
        var SUCCESS_YN = "N";
        fn_req_popup(index, SUCCESS_YN)
    }

    // EMS 픽업요청 처리내역 상세 팝업
    function fn_req_popup(index, SUCCESS_YN) {
        var data = gridWrapper.getRowData(index);
        var sn = data["SN"];
        var regType = data["REG_TYPE"];
//      $.comm.open("pickReqPopup", '<c:out value="/jspView.do?jsp=ems/pick/pickReqPopup" />'+"&SN="+sn+"&REG_TYPE="+regType, 1100, 746);
        $.comm.setModalArguments({"SN":data["SN"], "REG_TYPE":data["REG_TYPE"], "SUCCESS_YN":SUCCESS_YN});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickReqPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickReqPopup" />', spec); // 모달 호츨
    }
    
    // EMS 픽업요청
    function fn_pickup() {
        if (!gridWrapper.getSelectedSize() > 0) {
            alert($.comm.getMessage("W00000040")); //픽업요청할 항목을 선택해 주세요.
            return;
        }
        
        if (!confirm($.comm.getMessage("C00000019"))) return; //픽업요청하시겠습니까?

        var rows = gridWrapper.getSelectedRows();
        $.comm.send("ems/pick/savePickReq.do", rows, fn_callback, "픽업요청");
    }
    
    var fn_callback = function (data) {
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
                        <!-- 한중해상특송 사용시 주석해제 -->
<!--                         <li> -->
<!--                             <label for="EMS_REG_TYPE" class="search_title">등록구분</label>  -->
<!--                             <select name="EMS_REG_TYPE" id="EMS_REG_TYPE" class="search_input_select"></select> -->
<!--                         </li> -->
                        <!-- 한중해상특송 사용시 주석해제 -->
                    </ul>
                    <!-- search_sectionC -->
                    <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
                </form>
            </div><!-- search_frame -->
            <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
                <a href="##" class="btn white_84" id="btn_pickup">픽업요청</a>
                <!-- 한중해상특송 사용시 주석해제 -->
<!--                 <a href="##" class="btn white_84" id="btn_upload">엑셀업로드</a> -->
                <!-- 한중해상특송 사용시 주석해제 -->
                <a href="<c:url value="/form/ems_template.xls" />" class="btn white_147">표준 엑셀폼 다운로드</a>
                <a href="##" class="btn white_84" id="btnUpload">엑셀업로드</a>
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
