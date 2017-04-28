<%--
  User: jjkhj
  Date: 2017-02-20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
        $(function () {
        	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
    	    var sErrDesc = arguments.ERROR_DESC;
        	$("#ERROR_DESC").val(sErrDesc);
        });
		

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
       <h1>오류정보</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
		<!-- <a href="#" class="title_frame_btn" id="btnCancelSave">저장</a> -->
	</div>
    <div class="layer_content" style="overflow: hidden;">
        <div class="title_frame">
		    <p>작성오류</p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">작성오류</caption>
				<colgroup>
					<col width="20%" />
                   	<col width="*" />
				</colgroup>
				<tr>
					<td><label for="ERROR_DESC">작성오류</label></td>
					<td>
						<textarea  name="ERROR_DESC" id="ERROR_DESC" rows="3" style="height: 100px; border: 0px; background-color: white;" disabled="disabled" ></textarea>
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
