<%--
  User: 김회재
  Date: 2017-04-05
  Form: 시스템오류통보 상세조회
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
             "qKey"    : "res.selectInfDetail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "시스템오류통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">시스템오류통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="*" />
                    </colgroup>
                        <tr>
	                        <td><label for="RPT_NO">수출신고번호</label></td>
	                        <td><span id="RPT_NO" /></td>
	                        <td><label for="MSG_ID">오류발생 메시지ID</label></td>
	                        <td><span id="MSG_ID" /></td>
	                        <td><label for="RCV_DTM">수신일시</label></td>
	                        <td><span id="RCV_DTM" /></td>
	                        
	                    </tr>
	                    <tr>
	                        <td><label for="DOC_CD">문서구분</label></td>
	                        <td><span id="DOC_CD" /></td>
	                        <td><label for="CONT_ID">오류발생 컨텐트ID</label></td>
	                        <td><span id="CONT_ID" /></td>
	                        <td><label for="DPT_DTM">통보일시</label></td>
	                        <td><span id="DPT_DTM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="ERROR_CD">오류코드</label></td>
	                        <td colspan="5"><span id="ERROR_CD" /></td>
	                    </tr>
	                   
	                    <tr>
	                        <td><label for="ERROR_TXT">오류내역</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id="ERROR_TXT"></span></div>
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
