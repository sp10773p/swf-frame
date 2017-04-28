<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridError, headersError;
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var regno = arguments.REGNO;
                
        headersError = [ 
            {"HEAD_TEXT" : "항목",						"WIDTH" : "200",	"FIELD_NAME" : "ERROR_CODE",			"ALIGN" : "left",	"COLR" : ""},
            {"HEAD_TEXT" : "오류내용",					"WIDTH" : "2000",	"FIELD_NAME" : "ERROR_MESSAGE",			"ALIGN" : "left",	"COLR" : ""} 
        ];
        gridError = new GridWrapper({
            "actNm"        : "오류 확인",
            "targetLayer"  : "gridErrorLayer",
            "qKey"         : "ems.selectPickReqErrorList",
            "headers"      : headersError,
            "paramsGetter" : {"REGNO":regno},
            "gridNaviId"   : "gridPagingLayer",
            "countId"      : "totErrorCnt",
            "firstLoad"    : false
        });
        
        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridError.requestToServer();
    });
</script>
</head>
<body>
    <div class="layerContainer">
        <div class="layerTitle">
            <h1>오류확인</h1>
        </div><!-- layerTitle -->
        
        <div class="layer_btn_frame">
        </div><!-- layer_btn_frame -->
        
        <div class="title_frame">
            <div class="util_frame">
                <a href="##" class="btn white_84" id="btn_close">닫기</a> 
            </div><!-- //util_frame -->
            
            <div id="gridErrorLayer" style="height: 400px"></div>
            <div class="bottom_util">
                <div class="paging" id="gridPagingLayer">
                </div>
            </div>
        </div><!-- //title_frame -->
    </div><!-- //layerContainer -->

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
