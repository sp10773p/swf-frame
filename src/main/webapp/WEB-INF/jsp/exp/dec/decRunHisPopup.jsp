<%--
  User: jjkhj
  Date: 2017-01-20
  Form: 수출이행내역 팝업
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
	<script>
	var gridWrapper, headers;
	$(function (){
    	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
	    var sRptNo = arguments.RPT_NO;
    	var param = {
            "qKey"    : "dec.selectRunHis",
            "RPT_NO"  : sRptNo
        };
        fn_setGrid();

        $.comm.send("/dec/selectRunHis.do", param,
            function(data, status){
                $.comm.bindData(data.data);
                gridWrapper.loadData(data);
            },
            "수출이행내역 상세조회"
        );
        
    });
	
	function fn_setGrid(){
		headers = [
           {"HEAD_TEXT": "B/L번호"   	, "WIDTH": "200"   , "FIELD_NAME": "shpmPckUt" ,"POSIT":"true"},
           {"HEAD_TEXT": "출항일자"      	, "WIDTH": "100"   , "FIELD_NAME": "tkofDt"},
           {"HEAD_TEXT": "선기적포장개수" 	, "WIDTH": "200"   , "FIELD_NAME": "shpmPckGcnt"},
           {"HEAD_TEXT": "선기적중량(KG)"	, "WIDTH": "150"   , "FIELD_NAME": "blNo"}
       ];

       gridWrapper = new GridWrapper({
           "actNm": "수출정정취하 결과통보 목록조회",
           "targetLayer": "gridLayer",
           "headers": headers,
           "check": false,
           "firstLoad": false
       });
	}
    
</script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
       <h1>수출이행내역</h1>
    </div><!-- layerTitle -->
   	<div class="layer_btn_frame">
   	</div>
    <div class="layer_content" style="padding-top: 0px;">
        <div class="title_frame">
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">수출이행내역</caption>
				<colgroup>
					<col width="15%" />
                    <col width="20%" />
                    <col width="15%" />
                    <col width="20%" />
                    <col width="15%" />
                   	<col width="*" />
				</colgroup>
				<tr>
                    <td>
                    	<label for="exppnConm">수출화주/대행자</label>
                    </td>
                    <td colspan="5">
                    	<span id="exppnConm" />
                    </td>
                    
                </tr>
                <tr>
                    <td><label for="mnurConm">제조자</label></td>
                    <td><span id="mnurConm" /></td>
                    <td><label for="loadDtyTmlm">적재의무기한</label></td>
                    <td><span id="loadDtyTmlm" /></td>
                    <td><label for="acptDt">수리일자</label></td>
                    <td><span id="acptDt" /></td>
                </tr>
                <tr>
                    <td><label for="csclPckGcnt">통관포장개수</label></td>
                    <td><span id="csclPckGcnt" /></td>
                    <td><label for="csclWght">통관중량</label></td>
                    <td><span id="csclWght" /></td>
                    <td><label for="shpmCmplYn">기적완료여부</label></td>
                    <td><span id="shpmCmplYn" /></td>
                </tr>
                <tr>
                    <td><label for="shpmPckGcnt">선적포장개수</label></td>
                    <td><span id="shpmPckGcnt" /></td>
                    <td><label for="shpmWght">선적중량</label></td>
                    <td><span id="shpmWght" /></td>
                    <td><label for="">선박명</label></td>
                    <td><span id="" /></td>
                </tr>
			</table>
			</div><!-- //table_typeA 3단구조 -->  
    	</div><!-- /title_frame -->
    	
    	<div class="title_frame">
            <div id="gridLayer" style="height: 220px">
            </div>
        </div>
          
    </div><!-- /layer_content -->
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
