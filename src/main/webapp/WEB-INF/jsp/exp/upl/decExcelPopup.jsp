<%--
  User: jjkhj
  Date: 2017-01-20
  Form: 수출신고업로드 팝업
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
	<script type="text/javascript" src="<c:url value='/js/jquery.leanModal.min.js'/>"></script>
	<script>
    	var gridWrapper, headers;
    	$(function() {
    		var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
    	    var sn = arguments.SN;
        	headers = [ 
				{"HEAD_TEXT" : "상태"				,  "FIELD_NAME" : "상태"						,   "WIDTH" : "100",	"ALIGN" : "center",	"HTML_FNC": "fn_error"},
	            /* 
	            {"HEAD_TEXT" : "사업자번호"			,  "FIELD_NAME" : "EOCPARTYPARTYIDID1"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "판매업체명"			,  "FIELD_NAME" : "EOCPARTYORGNAME2"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "대표자명"				,  "FIELD_NAME" : "EOCPARTYORGCEONAME"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "신고인부호"			,  "FIELD_NAME" : "APPLICANTPARTYORGID"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "통관고유부호" 			,  "FIELD_NAME" : "EOCPARTYPARTYIDID2"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "우편번호"    			,  "FIELD_NAME" : "EOCPARTYLOCID"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "주소"       			,  "FIELD_NAME" : "EOCPARTYADDRLINE"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},  
				{"HEAD_TEXT" : "몰이름"     			,  "FIELD_NAME" : "MALL_ID"					,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				*/
				
				{"HEAD_TEXT" : "주문번호"				,  "FIELD_NAME" : "ORDER_ID"				,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "상품ID"				,  "FIELD_NAME" : "MALL_ITEM_NO"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "상품명"				,  "FIELD_NAME" : "ITEMNAME_EN"				,	"WIDTH" : "200",	"ALIGN" : "left",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "주문수량"				,  "FIELD_NAME" : "LINEITEMQUANTITY"		,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "결제금액" 			,  "FIELD_NAME" : "PAYMENTAMOUNT"			,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "결제통화코드" 			,  "FIELD_NAME" : "PAYMENTAMOUNT_CUR"		,	"WIDTH" : "150",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "구매자상호명" 			,  "FIELD_NAME" : "BUYERPARTYORGNAME"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "목적국 국가코드" 		,  "FIELD_NAME" : "DESTINATIONCOUNTRYCODE"	,	"WIDTH" : "150",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "HS코드"				,  "FIELD_NAME" : "CLASSIDHSID"				,	"WIDTH" : "150",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "중량"				,  "FIELD_NAME" : "NETWEIGHTMEASURE"		,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "가격"				,  "FIELD_NAME" : "DECLARATIONAMOUNT"		,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "도메인명"				,  "FIELD_NAME" : "SELL_MALL_DOMAIN"		,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				
				{"HEAD_TEXT" : "제조자" 				,  "FIELD_NAME" : "MAKER_NM"				,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "제조자사업자번호" 		,  "FIELD_NAME" : "MAKER_REG_ID"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "제조자사업장일련번호"	,  "FIELD_NAME" : "MAKER_LOC_SEQ"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "제조자통관고유부호"		,  "FIELD_NAME" : "MAKER_ORG_ID"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "제조장소(우편번호)"	,  "FIELD_NAME" : "MAKER_POST_CD"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "산업단지부호"			,  "FIELD_NAME" : "MAKER_LOC_CD"			,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				
				{"HEAD_TEXT" : "인도조건" 			,  "FIELD_NAME" : "AMT_COD"					,	"WIDTH" : "150",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "운임원화"       		,  "FIELD_NAME" : "FRE_KRW"					,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"}, 
				{"HEAD_TEXT" : "보험료원화"    		,  "FIELD_NAME" : "INSU_KRW"				,	"WIDTH" : "100",	"ALIGN" : "right",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "상품성분명"     		,  "FIELD_NAME" : "COMP"					,	"WIDTH" : "200",	"ALIGN" : "center",	"HTML_FNC": "fn_html"},
				{"HEAD_TEXT" : "주문수량단위"     		,  "FIELD_NAME" : "LINEITEMQUANTITY_UC"		,	"WIDTH" : "150",	"ALIGN" : "center",	"HTML_FNC": "fn_html"}
	        ];
        	
	        gridWrapper = new GridWrapper({
	            "actNm" : "수출신고업로드 팝업 목록조회",
	            "targetLayer" : "gridLayer",
	            "qKey" : "upl.selectDecExcelDetailList",
	            "headers" : headers,
	            "paramsFormId" : "searchForm",
	            "gridNaviId" : "gridPagingLayer",
	            "check" : false,
	            "firstLoad" : false,
	            "controllers" : [
	
	            ]
	        });
	        
	        headersError = [ 
                {"HEAD_TEXT" : "항목"     ,	"WIDTH" : "200",	"FIELD_NAME" : "ERROR_COLUMN_DATA",		"ALIGN" : "center",	"COLR" : ""},
                {"HEAD_TEXT" : "오류내용"  ,	"WIDTH" : "600",	"FIELD_NAME" : "ERROR_MESSAGE",			"ALIGN" : "left",	"COLR" : ""} 
            ];
            gridError = new GridWrapper({
                "actNm"        : "오류 확인",
                "targetLayer"  : "gridErrorLayer",
                "qKey"         : "upl.selectDecExcelDetailErrList",
                "headers"      : headersError,
                "countId"      : "totErrorCnt",
                "firstLoad"    : false
            });
            
            $("#err_layer_popup_trigger").leanModal({
                top : 110,
                overlay : 0.8,
                closeButton : ".hidemodal"
            });

	        // 수출신고 요청하기
	        $("#btnReq").click(function() {
	            fn_req();
	        });
	        
	     	$("#SN").val(sn);
	        
	        gridWrapper.requestToServer();
    });
    
   	function fn_html(index, val, field) {
        return checkError(index, val, field);
    }
	
    function checkError(index, val, col) {
        var str = "";
        var data = gridWrapper.getRowData(index);
        var statusDesc = getSafeString(data["STATUS_DESC"]);
        var errCols = statusDesc.split("/");
        var isMatch = false;
        
        list: {
            for (i in errCols) {
                if (errCols[i] == (col)) {
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
	
    //오류버튼 유무
    function fn_error(index, val) {
        var data = gridWrapper.getRowData(index);
        var str = "정상";
        if (data["STATUS"] == "E") {
            str = "<a href='#this' class='btn_inquiryC' onclick='gfn_gridLink(\"fn_showErrorList\", \"" + (index) + "\")'>오류</a>";
        }
        return str;
    }
    
 	// 오류 상세정보 화면
    function fn_showErrorList(index) {
        var size = gridWrapper.getSize();
        if(size == 0){
            gridError.drawGrid();
            return;
        }
        /* 
        $("#err_layer_popup_trigger").click();
        
        var data = gridWrapper.getRowData(index);
        gridError.setParams(data);
        gridError.requestToServer(); */
        
        var data = gridWrapper.getRowData(index);
        $.comm.setModalArguments({"SN":data["SN"], "SEQ":data["SEQ"]});
        var spec = "width:1100px;height:600px;scroll:auto;status:no;center:yes;resizable:yes;windowName:decExcelErrPopup";
        $.comm.dialog("<c:out value='/jspView.do?jsp=exp/upl/decExcelErrPopup' />", spec,
            function () { // 리턴받을 callback 함수
                var ret = $.comm.getModalReturnVal();
                if (ret) {
                }
            }
        );
    }
 	
 	//수출신고 요청확인
    function fn_reqChk(){
    	var cnt = "";
    	var	sn = $("#SN").val();
    	var params = {"SN":sn, "qKey":"selectExpdecReqExcelChk"};
        var reqInfo = $.comm.sendSync("/common/select.do", params, "수출신고요청확인 조회").data;
        cnt = reqInfo.CNT;
        return cnt;
    }
 	
 	//수출신고 전체에러 확인 : 
 	function fn_allErrChk(){
 		var isAllErr = true;
 		var size = gridWrapper.getSize();
 		for(var i=0; i < size; i++){
 			var data = gridWrapper.getRowData(i);
 			if (data["STATUS"] != "E") {
 				isAllErr = false;
 			}
 		}
 		return isAllErr;
 	}
 	
 	// 수출신고 요청하기
 	function fn_req(){
 		if(fn_reqChk() != "0"){
 			alert($.comm.getMessage("W00000024")); //이미 수출신고 요청하셨습니다
 		}else{
 			if(fn_allErrChk()){
 				alert("요청할 내용이 없습니다.");
 			}else{
 				if(confirm("요청하시겠습니까?")){
 					$.comm.sendForm("/dec/saveExpDecReq.do", "searchForm", fn_callback, "수출신고 요청");
 				}
 			}
 		}
 	}
 	
 	var fn_callback = function (data) {
 		if (data.code.indexOf('I') == 0) {
 			//alert($.comm.getMessage("I00000003")); //저장되었습니다.
 			opener.gridWrapper.requestToServer();
        }
    }
    
 	function getSafeString(val) {
        return (val === undefined) ? "" : val;
    }
    
    
</script>
</head>
<body>
<div class="layerContainer">
     <form id="searchForm">
        <input type="hidden" id="SN" name="SN" />
    </form>
	<div class="layerTitle">
		<h1>엑셀업로드 상세내역</h1>
	</div><!-- layerTitle -->
	
    <div class="layer_btn_frame">
        <a href="#" class="title_frame_btn" id="btnReq">수출신고요청하기</a>
    </div>
	<div class="title_frame">
            
        <div id="gridLayer" style="height: 410px"></div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer"></div>
        </div>
    </div>
    
</div><!-- //layerContainer -->
    
<a href="#err_layer_popup" style="display: none;" id="err_layer_popup_trigger">오류 확인</a>

<!-- 팝업레이어 -->
<div id="err_layer_popup" class="layerContainer" style="display: none; margin-top: -80px; width: 800px; height: 500px;">
    <div class="layerTitle">
		<h1>오류확인</h1>
		<a href="#" class="hidemodal"></a>
	</div><!-- layerTitle -->
    <div class="layer_content">
        <div class="title_frame">
		    <p>총&nbsp;<span id="totErrorCnt">0</span>&nbsp;건 </p>
			<div id="gridErrorLayer"></div>
    	</div>
    </div>
</div>
        
<%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
