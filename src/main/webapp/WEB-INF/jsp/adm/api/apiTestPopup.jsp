<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
    var param = $.comm.getModalArguments();
	$(function () {
		$('#API_NM').text(param['API_NM']);
		$('#REQ_DATA').val(param['SAMPLE_JSON']);
		$.comm.bindCustCombo('USER_ID', "api.selectApiUsers", false, param['API_ID']);
		
	    // 신규
	    $('#btnSend').on("click", function () {
	    	var req = null;
			try{ 
				var req = jQuery.parseJSON($('#REQ_DATA').val());
				$('#REQ_DATA').val(JSON.stringify(req, null, '\t'));
			} catch(e) {
				console.log(e);
				alert("요청 데이터가 정확한 JSON 포멧이 아닙니다.");
				return;
			}
			
	    	$.comm.setGlobalVar('api_consumer_key', $('#USER_ID').val());
            $.comm.send(
            		param['API_URL'], 
            		$('#REQ_DATA').val(), 
    	       		function(data, status){
            			var jsonStr = JSON.stringify(data);
            			var jsonObj = JSON.parse(jsonStr);
            			var jsonPretty = JSON.stringify(jsonObj, null, '\t');
            			
            			$('#RES_DATA').val(jsonPretty);
            			$.comm.removeGlobalVar('api_consumer_key');
    				}, '${ACTION_MENU_NM} [' + param['API_NM'] + ']', 
    				null, true, null, true
    		);
	    })
	});
    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}&nbsp;&nbsp;[<span id="API_NM"></span>]</h1>
    </div><!-- layerTitle -->

    <div class="white_frame">
        <form id="popDetailForm" name="popDetailForm">
            <div class="table_typeA ">
                <table style="table-layout:fixed;">
                    <colgroup>
                        <col width="110px">
                        <col width="*">
                    </colgroup>
                    <tr>
                        <td>사용자ID</td>
                        <td class="table_search">
                            <select name="USER_ID" id="USER_ID" class="input_searchSelect inputHeight" style="width:200px;"></select>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
	<div class="white_frame">
		<div class="util_frame">
			<p class="util_title"><label for="REQ_DATA">요청 데이터</label></p><a href="#전송" class="btn blue_84" id="btnSend">전송</a>
		</div>
        <table class="table_typeA darkgray">
            <tr>
                <td>
                    <textarea name="REQ_DATA" id="REQ_DATA" rows="300" cols="200" style="padding: 5px; width: 100%; height: 240px" ></textarea>
                </td>
            </tr>
        </table>
	</div>
	<div class="white_frame">
		<div class="util_frame">
			<p class="util_title"><label for="RES_DATA">응답 데이터</label></p>
		</div>
        <table class="table_typeA darkgray">
            <tr>
                <td>
                    <textarea name="RES_DATA" id="RES_DATA" rows="300" cols="200" style="padding: 5px; width: 100%; height: 240px" ></textarea>
                </td>
            </tr>
        </table>
	</div>	
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
