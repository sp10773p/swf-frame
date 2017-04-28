<%--
  User: jjkhj
  Date: 2017-01-20
  Form: 수출신고업로드 팝업
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
	<script>
    	var gridError, headersError;
    	$(function() {
    		var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
    	    var sn = arguments.SN;
    	    var seq = arguments.SEQ;
	        
	        headersError = [ 
                {"HEAD_TEXT" : "항목"     ,	"WIDTH" : "200",	"FIELD_NAME" : "ERROR_COLUMN_DATA",		"ALIGN" : "center",	"COLR" : ""},
                {"HEAD_TEXT" : "오류내용"  ,	"WIDTH" : "600",	"FIELD_NAME" : "ERROR_MESSAGE",			"ALIGN" : "left",	"COLR" : ""} 
            ];
            gridError = new GridWrapper({
                "actNm"        : "오류 확인",
                "targetLayer"  : "gridErrorLayer",
                "qKey"         : "upl.selectDecExcelDetailErrList",
                "headers"      : headersError,
                "paramsFormId" : "searchForm",
                "gridNaviId" : "gridPagingLayer",
                "countId"      : "totErrorCnt",
                "firstLoad"    : false
            });
	        
            $("#SN").val(sn);
            $("#SEQ").val(seq);
            
            gridError.requestToServer();
    });
    
</script>
</head>
<body>
<div class="layerContainer">
     <form id="searchForm">
        <input type="hidden" id="SN" name="SN" />
        <input type="hidden" id="SEQ" name="SEQ" />
    </form>
	<div class="layerTitle">
		<h1>오류확인</h1>
	</div><!-- layerTitle -->
	<div class="layer_btn_frame">
    </div>
	<div class="title_frame">
            
        <div id="gridErrorLayer" style="height: 250px"></div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer"></div>
        </div>
    </div>
    
</div><!-- //layerContainer -->
        
<%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
