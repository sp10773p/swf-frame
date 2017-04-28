<%--
  User: jjkhj
  Date: 2017-01-20
  Form: 수출수리통보 팝업
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
	<script>
    $(function (){
    	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
	    var sRptNo = arguments.RPT_NO;
    	var param = {
            "qKey"    : "dec.select5aaDetail",
            "RPT_NO"  : sRptNo
        };

        $.comm.send("/common/select.do", param,
            function(data, status){
                $.comm.bindData(data.data);
            },
            "수출수리통보 상세조회"
        );
    });
    
</script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
       <h1>수출신고 수리통보</h1>
    </div><!-- layerTitle -->
   	<div class="layer_btn_frame">
   	</div>
    <div class="layer_content" style="padding-top: 0px;">
        <div class="title_frame">
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">수출신고 수리통보</caption>
				<colgroup>
					<col width="15%" />
                    <col width="20%" />
                    <col width="15%" />
                    <col width="20%" />
                    <col width="15%" />
                   	<col width="*" />
				</colgroup>
				<tr>
                    <td><label for="RPT_NO">수출신고번호</label></td>
                    <td><span id="RPT_NO" /></td>
                    <td><label for="LIS_DTM">수리일시</label></td>
                    <td><span id="LIS_DTM" /></td>
                     <td><label for="TOT_RPT_KRW">총신고가격원화</label></td>
                    <td><span id="TOT_RPT_KRW" /></td>
                </tr>
                <tr>
                    <td><label for="JUK_DTM">적재의무기한</label></td>
                    <td><span id="JUK_DTM" /></td>
                    <td><label for="RCV_DTM">세관수신일시</label></td>
                    <td><span id="RCV_DTM" /></td>
                    <td><label for="TOT_RPT_USD">총신고가격미화</label></td>
                    <td><span id="TOT_RPT_USD" /></td>
                </tr>
                <tr>
                 <td><label for="CUS_NOTICE1">세관기재란</label></td>
                 <td colspan="5">
                 	<textarea  name="CUS_NOTICE1" id="CUS_NOTICE1" rows="5" style="height: 100px; border: 0px; background-color: white;" disabled="disabled" ></textarea>
                 </td>
                </tr>
                <tr>
                 <td><label for="CUS_NOTICE2">도로명표기안내</label></td>
                 <td colspan="5">
                 	<textarea  name="CUS_NOTICE2" id="CUS_NOTICE2" rows="3" style="height: 100px; border: 0px; background-color: white;" disabled="disabled" ></textarea>
                 </td>
                </tr>
                <tr>
                 <td><label for="CUS_NOTICE3">특이사항</label></td>
                 <td colspan="5">
                 	<textarea  name="CUS_NOTICE3" id="CUS_NOTICE3" rows="7" style="height: 100px; border: 0px; background-color: white;" disabled="disabled" ></textarea>
                 </td>
            	</tr>
			</table>
			</div><!-- //table_typeA 3단구조 -->  
    	</div><!-- /title_frame -->  
    </div><!-- /layer_content -->
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
