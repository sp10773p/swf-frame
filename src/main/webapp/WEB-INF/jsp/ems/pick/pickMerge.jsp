<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2016-12-21
  Time: 오전 11:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridMaster, gridDetail, headers, headersDetail;
    var globalVar = {
        "SN" : "",
        "SEQ" : ""
    }
    $(function() {
        globalVar.SEQ = ""; // detail 참조 컬럼

        headers = [ 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDERNO",		"WIDTH" : "120",	"ALIGN" : "center",	"LINK" : "fn_detail", "POSIT" : "true"},
            {"HEAD_TEXT" : "수취인",			"FIELD_NAME" : "RECEIVENAME",	"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "품명",			"FIELD_NAME" : "CONTENTS",		"WIDTH" : "220",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "가격",			"FIELD_NAME" : "ITEM_VALUE",	"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "박스포장 중량",	"FIELD_NAME" : "TOTWEIGHT",		"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "목적지",			"FIELD_NAME" : "COUNTRYCD",		"WIDTH" : "45",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "우편물 구분",		"FIELD_NAME" : "PREMIUMCD_NM",	"WIDTH" : "80",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "수출이행등록",	"FIELD_NAME" : "XPRTNOYN",		"WIDTH" : "80",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "픽업요청",		"FIELD_NAME" : "PICKUP_YN",		"WIDTH" : "60",		"ALIGN" : "center"}
        ];

        headersDetail = [
            {"HEAD_TEXT" : "몰명",			"FIELD_NAME" : "MALL_ID",		"WIDTH" : "180",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDERNO",		"WIDTH" : "150",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "결제금액",		"FIELD_NAME" : "ITEM_VALUE",	"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "중량",			"FIELD_NAME" : "ITEM_WEIGHT",	"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "수량",			"FIELD_NAME" : "ITEM_NUMBER",	"WIDTH" : "80",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "목적지",			"FIELD_NAME" : "COUNTRYCD",		"WIDTH" : "50",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "XPRTNO",		"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량분할",		"FIELD_NAME" : "TOTDIVSENDYN",	"WIDTH" : "60",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "포장개수",		"FIELD_NAME" : "WRAPCNT",		"WIDTH" : "60",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"}
        ];
        
        gridMaster = new GridWrapper({
            "actNm" : "합배송 리스트 조회",
            "targetLayer" : "gridMasterLayer",
            "qKey" : "ems.selectPickMergeMasterList",
            "requestUrl" : "/ems/pick/selectPickMergeMasterList.do",
            "headers" : headers,
            "paramsGetter" : {"SN":"${SN}"},
            "countId" : "totCnt",
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "onlyOneCheck" : true,
            "checkPosit" : true,
            "scrollPaging" : false,
            "firstLoad" : false,
            "defaultSort"  : "SN, SEQ",
            "checkScript"  : fn_menuCheck,
            "postScript" : function() {
                fn_detail(0);
            }
        });
        
        gridDetail = new GridWrapper({
            "actNm" : "합배송 상세 리스트 조회",
            "targetLayer" : "gridDetailLayer",
            "qKey" : "ems.selectPickMergeDetailList",
            "requestUrl" : "/ems/pick/selectPickMergeDetailList.do",
            "headers" : headersDetail,
            "countId" : "totDetailCnt",
//             "gridNaviId" : "gridPagingDetailLayer",
            "check" : true,
            "scrollPaging" : false,
            "firstLoad" : false,
            "defaultSort"  : "IDX",
            "controllers" : [ 
                
            ]
        });

        // 합배송 추가 팝업
        $('#btn_add').on("click", function(e) {
            var rows = gridMaster.getSelectedRows();
            if (rows == "") {
                alert($.comm.getMessage("W00000013")); //합배송할 항목을 선택해 주세요
                return;
            }

            var row = rows[0];
            if (fnCheckPickReqComplete()) {
                alert($.comm.getMessage("W00000021")); //이미 EMS픽업요청이 완료된 건입니다.
                return;
            }

            $.comm.setModalArguments({"SN":globalVar.SN, "SEQ":globalVar.SEQ});
            var spec = "width:1100px;height:820px;scroll:auto;status:no;center:yes;resizable:yes;windowName:pickMergePopup";
            $.comm.dialog('<c:out value="/jspView.do?jsp=ems/pick/pickMergePopup" />', spec); // 모달 호츨
        });
        
        $('#btn_del').on("click", function(e) {
            var gridDetailSize = gridDetail.getSize();
            var gridDetailData = gridDetail.getData();
            var gridDetailSelectedSize = gridDetail.getSelectedSize();
            var gridDetailSelectedRows = gridDetail.getSelectedRows();
            
            if (!gridDetailSelectedSize > 0) {
                alert ($.comm.getMessage("W00000023")); //삭제할 항목을 선택해 주세요.
                return;
            }

            if (fnCheckPickReqComplete()) {
                alert($.comm.getMessage("W00000021")); //이미 EMS픽업요청이 완료된 건입니다.
                return;
            }

            if (!confirm($.comm.getMessage("C00000001"))) { //삭제하시겠습니까?
                return;
            }

            var paramArray = new Array();

            // 추가된 목록
            $.each (gridDetailData, function(index, value) {
                var param = new Object();
                var chk = value['CHK'];
                if (chk != '1'){
                    param.XPRTNO = value["XPRTNO"]; //수출신고번호
                    param.TOTDIVSENDYN = value["TOTDIVSENDYN"]; // 전량분할
                    param.WRAPCNT = value["WRAPCNT"]; //포장개수
                    paramArray.push(param);
                }
            });
            
            var param = {
                "SN":globalVar.SN,
                "SEQ":globalVar.SEQ,
                "PARAMS":JSON.stringify(paramArray),
                "CRUD":"D"
            };
            
            $.comm.send("/ems/pick/savePickMerge.do", param, fn_callback, "합배송리스트 저장");
        });
        
        $('#btnList').on("click", function (e) {
            $.comm.forward("ems/pick/pickList", {});
//             $.comm.pageBack();
        });
        
        gridMaster.requestToServer();
    });
    
    /***
     * 합배송 대상 조회
     * @param index
     */
    function fn_detail(index) {
        var size = gridMaster.getSize();
        if(size == 0){
            globalVar.SN = "";
            return;
        }
        
        var grigCheck = $("#gridMasterLayer_table").find("#gridMasterLayerChk"+index);
        if (grigCheck.is(":checked") == false) {
            $("#gridMasterLayer_table").find("input[name=gridMasterLayerChk]").prop("checked", false);
            grigCheck.prop("checked", true);
        }

        // global var Setting
        var data = gridMaster.getRowData(index);
        globalVar.SN = data["SN"];
        globalVar.SEQ = data["SEQ"];

        // Detail Header Setting
        gridDetail.setParams(data);
        gridDetail.drawGrid();
        gridDetail.requestToServer();
    }
    
    // 그리드 체크 클릭
    function fn_menuCheck(index) {
        fn_detail(index);
    }
    
    function getSn() {
        return globalVar.SN;
    }

    function getSeq() {
        return globalVar.SEQ;
    }
    
    // 합배송 대상 - 픽업요청 여부
    function fnCheckPickReqComplete() {
        var params = {"SN":globalVar.SN, "SEQ":globalVar.SEQ, "qKey":"selectReginoCnt"};
        var data = $.comm.sendSync("/common/select.do", params, "픽업요청 완료여부 조회").data;
        return data.CNT > 0 ? true : false;
    }
    
    // 중복체크
    function dupeCheck(no) {
        var check = false;
        var size = gridDetail.getSize();
        if (size == 0) return false; // row가 없으면 추가가능
        
        for (i = 0; i < size; i++) {
            var data = gridDetail.getRowData(i);
            var xprtNo = data["XPRTNO"] === undefined ? "" : data["XPRTNO"];
            if (xprtNo.toUpperCase() == no.toUpperCase()) {
                return check = true;
            }
        }
        
        return check;
    }
    
    // 목적국가 체크
    function existCountryCd(cd) {
        var check = false;

        if (gridDetail.getSize() == 0) { // row가 없으면 합배송 관리에 선택된 목적지와 비교
            var rows = gridMaster.getSelectedRows();
            var row  = rows[0];
            var countryCd = row["COUNTRYCD"] === undefined ? "" : row["COUNTRYCD"];
            if (countryCd.toUpperCase() == cd.toUpperCase()) {
                check = true;
            }
        }
        else { // row가 있으면 합배송 리스트에 추가된 목적지와 비교
            for (i = 0; i < gridDetail.getSize(); i++) {
                var data = gridDetail.getRowData(i);
                var countryCd = data["COUNTRYCD"] === undefined ? "" : data["COUNTRYCD"];
                if (countryCd.toUpperCase() == cd.toUpperCase()) {
                    return check = true;
                }
            }
        }

        return check;
    }
    
    var fn_callback = function (data) {
        if (data.code.indexOf('I') == 0) {
            fn_select();
        }
    }
    
    // 조회
    function fn_select() {
        gridDetail.requestToServer();
    }
    
</script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_84" id="btnList">목록</a>
                <a href="#" class="btn white_84" id="btn_add">추가</a>
            </div><!-- //util_frame -->
            <div id="gridMasterLayer" style="height: 400px">
            </div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
        
        <div class="title_frame">
            <p><a href="#" class="btnToggle_table">합배송 목록</a></p>
            <div class="list_typeA">
                <div class="util_frame">
                    <a href="#" class="btn white_84" id="btn_del">삭제</a>
                </div>
                <div id="gridDetailLayer" style="height: 200px">
                </div>
            </div>
        </div>
        
        
<!--         <div class="bottom_util"> -->
<!--             <div class="paging" id="gridPagingDetailLayer"> -->
<!--             </div> -->
<!--         </div> -->
    </div>
</div>
<!-- //inner-box -->
<%@ include file="/WEB-INF/include/include-body.jspf"%>
</body>
</html>
