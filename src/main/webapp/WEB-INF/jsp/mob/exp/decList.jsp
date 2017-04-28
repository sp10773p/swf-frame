<%--
    Class Name : decList.jsp
    Description : 모바일 수출신고 조회
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성

    author : 성동훈
    since : 2017.03.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-mobile-header.jspf" %>
    <link rel="stylesheet" href="<c:url value='/css/mobile/list.css'/>"/>

    <script>
        var globalVar = {};
        var gridWrapper;
        $(function() {
            var currDate = new Date();
            globalVar["fromRptDate"] = currDate.dateAdd2("d", -7).format("YYYYMMDD");
            globalVar["toRptDate"]   = currDate.format("YYYYMMDD");

            var params = {
                "SEARCH_DTM": "RPT_DAY",
                "F_REG_DTM" : globalVar["fromRptDate"],
                "T_REG_DTM" : globalVar["toRptDate"]
            };

            var headers = [
                {"HEAD_TEXT": "수출신고번호" 	, "FIELD_NAME": "RPT_NO"	, "LINK":"fn_detail"},
                {"HEAD_TEXT": "주문번호"     	, "FIELD_NAME": "ORDER_ID"},
                {"HEAD_TEXT": "전송상태"     	, "FIELD_NAME": "SEND_NM"},
                {"HEAD_TEXT": "수신상태"     	, "FIELD_NAME": "RECE_NM"},
                {"HEAD_TEXT": "신고금액원화" 	, "FIELD_NAME": "TOT_RPT_KRW"},
                {"HEAD_TEXT": "총중량"   	 	, "FIELD_NAME": "TOT_WT"},
                {"HEAD_TEXT": "신고일자"     	, "FIELD_NAME": "RPT_DAY"}
            ];
            gridWrapper = new GridWrapper({
                "actNm"        : "수출신고 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "dec.selectDecList",
                "headers"      : headers,
                "paramsGetter" : params,
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true
            })

            // 조회팝업
            $('#btnSearchPopup').on('click', function () {
                layerPop("<c:url value='/jspView.do?jsp='/>" + "mob/exp/decListPopup");
            });
            
         	// 전송버튼
            $('#btnSend').on('click', function () {
                fn_send();
            })
        })

        // 리스트 조회
        function fn_search(params){
            globalVar["fromRptDate"] = params["F_REG_DTM"];
            globalVar["toRptDate"]   = params["T_REG_DTM"];
            gridWrapper.setParams(params);
            gridWrapper.requestToServer();
        }
		
        // 상세보기
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            mfn_forward("mob/exp/decDetail", data);
        }
        
     	// 전송
        function fn_send() {
        	var size = gridWrapper.getSelectedSize();
            if(size < 1){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다
                return;
            }
            
            if(!fn_chkStatus()) {
        		return;
        	}

            if(!confirm($.comm.getMessage("C00000015"))){ // 전송 하시겠습니까?
                return;
            }
            
            var idendtifyId = fn_getIdentifier("ECC");
        	if(!idendtifyId) {
        		alert($.comm.getMessage("W00000064"), "식별자"); //식별자가 존재하지 않습니다.
        		return;
        	}

            var rows = gridWrapper.getSelectedRows();
            for(var i=0; i < rows.length; i++) {
        		rows[i]["REQ_KEY"] = rows[i]["RPT_NO"];
        		rows[i]["SNDR_ID"] = idendtifyId;
        		rows[i]["RECP_ID"] = "KCS4G001";
        		rows[i]["DOC_TYPE"] = "GOVCBR830";
        	}

            $.comm.send("/dec/saveExpDecSend.do", rows, fn_callback, "수출신고 전송");
        }
     	
     	// 상태 체크
        function fn_chkStatus() {
        	var selectDataList = gridWrapper.getSelectedRows();
        	var status = [];
        	var rece = [];
        	var msg = "";
        	var flag = true;
        	for(var i=0; i < selectDataList.length; i++) {
        		status[i] = selectDataList[i]["SEND"];
        		rece[i] = selectDataList[i]["RECE"];
        		if(!"01".match(status[i]) && !"90".match(status[i])){
        			if(rece[i] === undefined || !"01".match(rece[i])){
	        			msg += selectDataList[i]["RPT_NO"] +"는 전송할 수 없는 상태입니다.\n";
	        			flag = false;
        			}
        		}
        	}
        	if(!flag){
        		msg += "등록, 전송실패(전송) 또는 오류(수신)만 전송할 수 있습니다.";
				alert(msg);        		
				return false;
        	}

            return true;
        }
     	
        function fn_getIdentifier(type) {
        	var returnData = "";
        	var param = {
        			"qKey": "dec.selectCmmIdentifier",
        			"TYPE": type
        	};
        	var data = $.comm.sendSync("/common/select.do", param, '식별자 조회').data;
        	if(data) {
        		returnData = data.IDENTIFY_ID;
        	}
        	return returnData;
        }
     	
        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
            	gridWrapper.requestToServer();
            }
        }
     
    </script>
</head>
<body>
    <div class="util_frame">
        <p class="total"></p>
        <div class="btn_frame">
            <a href="#전송" class="btn blue_btn" id="btnSend">전송</a>
            <a href="#조회" class="btn inquiry_btn" id="btnSearchPopup">조회</a>
        </div>
    </div>
    <ul class="list_style" id="gridLayer">
    </ul>
</body>
</html>
