<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        headers = [ 
            {"HEAD_TEXT" : "수취인명",		"FIELD_NAME" : "RECEIVENAME",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "연락처",			"FIELD_NAME" : "RECEIVETELNO",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "이메일",			"FIELD_NAME" : "RECEIVEMAIL",	"WIDTH" : "",		"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "XPRTNO1",		"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDERNO",		"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "운송장번호",		"FIELD_NAME" : "REGINO",		"WIDTH" : "120",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "상세정보",		"FIELD_NAME" : "보기",			"WIDTH" : "100",	"ALIGN" : "center",		"BTN_FNC" : "fn_detail_edit"}, 
            {"HEAD_TEXT" : "등록상태",		"FIELD_NAME" : "STATUS",		"WIDTH" : "60",		"ALIGN" : "center",		"HTML_FNC" : "fn_reg_status"}, 
            {"HEAD_TEXT" : "픽업상태",		"FIELD_NAME" : "PICK_STATUS",	"WIDTH" : "100",	"ALIGN" : "center",		"HTML_FNC" : "fn_pick_status"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "픽업요청 상세 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectPickDetailList",
            "requestUrl" : "/ems/pick/selectPickDetail.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
//             "paramsGetter" : {"SN":$('#SN').val()},
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : false,
            "defaultSort" : "SN, SEQ",
            "postScript" : fn_postScript,
            "controllers" : [ 
                
            ]
        });

        // 목록
        $('#btnList').on("click", function (e) {
//             $.comm.forward("ems/pick/pickList", {});
            $.comm.pageBack();
        });
        
        // 픽업요청
        $('#btn_pickup').on("click", function(e) {
            fn_pickup();
        });
        
        gridWrapper.requestToServer();
    });
    
    function fn_postScript() {
        $("input:checkbox[name=gridLayerChk]").each(function(index, obj){
            var data = gridWrapper.getRowData(index);
            if (!$.comm.isNull(data["REGINO"]) || data["STATUS"] == "E") {
                $(this).attr("disabled", true);
            }
        });
    }

    /* 상세정보 수정 화면 */
    function fn_detail_edit(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.forward("ems/pick/pickDetailInfo", data);
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
    
    // 픽업요청 (단건)
    function fn_pickupSingle(index) {
        if (!confirm($.comm.getMessage("C00000019"))) return; //픽업요청하시겠습니까?

        var rows = [];
        var data = gridWrapper.getRowData(index);
        rows.push(data);
        $.comm.send("ems/pick/savePickReq.do", rows, fn_callback, "픽업요청");
    }
    
    // 등록상태
    function fn_reg_status(index, val) {
        var data = gridWrapper.getRowData(index);
        if (data["STATUS"] == "E") {
            return "<a href='#this' onclick='gfn_gridLink(\"fn_showErrorList\", \"" + (index) + "\")'><span style='color:red'>오류</span></a>";
        }
        else {
            return "<span style='color:green'>정상</span>";
        }
    }
    
    // 픽업상태
    function fn_pick_status(index, val) {
        var data = gridWrapper.getRowData(index);
        if ($.comm.isNull(data["REGINO"])) {
            if ($.comm.isNull(data["STATUS"])) {
                if (data["PICK_STATUS"] == "X") {
                    return "<a href='#this' onclick='gfn_gridLink(\"fn_showPickErrorList\", \"" + (index) + "\")'><span style='color:red'>오류</span></a>";
                }
                else {
                    return "<a href='#this' class='btn_inquiryC' onclick='gfn_gridLink(\"fn_pickupSingle\", \"" + (index) + "\")'>픽업요청</a>";
                }
            }
            else {
                return "";
            }
        }
        else {
            return "<span style='color:blue'>픽업요청</span>";
        }
    }
    
    // 오류내용 팝업 (upload)
    function fn_showErrorList(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"SN":data["SN"], "SEQ":data["SEQ"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickExcelErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickExcelErrPopup" />', spec); // 모달 호츨
    }
    
    // 오류내용 팝업 (EMS)
    function fn_showPickErrorList(index) {
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"REGNO":data["REGNO"]});
        var spec = "width:1100px;height:650px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickReqErrPopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickReqErrPopup" />', spec); // 모달 호츨
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
                            <label for="SEARCH_PICK_STATUS" class="search_title">픽업상태</label> 
                            <select name="SEARCH_PICK_STATUS" id="SEARCH_PICK_STATUS" class="search_input_select">
                                <option value="">전체</option>
                                <option value="REQUEST">픽업요청</option>
                                <option value="NOT_REQUESTED">픽업미요청</option>
                                <option value="ERROR">오류</option>
                            </select>
                        </li>
                    </ul>
                </div>
            </div>
        </form>

        <div class="list_typeA">
            <div class="util_frame">
                <a href="##" class="btn white_84" id="btnList">목록</a>
                <a href="##" class="btn white_84" id="btn_pickup">픽업요청</a>
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
