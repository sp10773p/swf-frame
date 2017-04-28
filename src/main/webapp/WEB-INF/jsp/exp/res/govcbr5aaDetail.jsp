<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수리통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
    $(function (){
     	//초기화
     	init();
         
         // 목록 btn
         $('#btn_list').on("click", function (e) {
           	$.comm.pageBack();
         })
    });
     
    function init(){
    	var param = {
             "qKey"    : "res.select5aaDetail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수리통보 상세조회"
         );
    }
</script>
</head>
<body>
<div class="inner-box">
    <form id="detailForm" name="detailForm" method="post">
    <div class="padding_box">
    	<div class="title_frame">
    		<div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
				<div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btn_list">목록</a>
				</div>
			</div>
			<p><a href="#" class="btnToggle_table">수리통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="*" />
                    </colgroup>
                        <tr>
                            <td><label for="RPT_NO">수출신고번호</label></td>
                            <td><span id="RPT_NO" /></td>
                            <td><label for="LIS_DTM">수리일시</label></td>
                            <td><span id="LIS_DTM" /></td>
                            <td><label for="RCV_DTM">세관수신일시</label></td>
                            <td><span id="RCV_DTM" /></td>
                        </tr>
                        <tr>
                            <td><label for="JUK_DTM">적재의무기한</label></td>
                            <td><span id="JUK_DTM" /></td>
                            <td><label for="TOT_RPT_KRW">총신고가격원화</label></td>
                            <td><span id="TOT_RPT_KRW" /></td>
                            <td><label for="TOT_RPT_USD">총신고가격미화</label></td>
                            <td><span id="TOT_RPT_USD" /></td>
                        </tr>
                        <tr>
	                        <td><label for="CUS_NOTICE1">세관기재란</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id=CUS_NOTICE1></span></div>
	                        </td>
                        </tr>
                        <tr>
	                        <td><label for="CUS_NOTICE2">도로명표기안내</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id=CUS_NOTICE2></span></div>
	                        </td>
                        </tr>
                        <tr>
	                        <td><label for="CUS_NOTICE3">특이사항</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id=CUS_NOTICE3></span></div>
	                        </td>
                    	</tr>
                	</table>
               	</div><!-- //table_typeA 3단구조 -->
            </div><!-- //title_frame -->
                                                             
        </div><%-- // padding_box--%>
    </form>
</div><%-- // inner-box--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
