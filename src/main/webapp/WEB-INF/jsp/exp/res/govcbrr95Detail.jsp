<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출검사완료통보 상세조회
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
             "qKey"    : "res.selectr95Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출검사완료통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출검사완료통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                    </colgroup>
                        <tr>
	                        <td rowspan="2"><label for="RPT_NO">수출신고번호</label></td>
	                        <td rowspan="2"><span id="RPT_NO" /></td>
	                        <td><label for="CHK_SEQ">검사차수</label></td>
	                        <td><span id="CHK_SEQ" /></td>
	                        <td><label for="CUS_NM">세관</label></td>
	                        <td><span id="CUS_NM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="CHK_DTM">검사일자</label></td>
	                        <td><span id="CHK_DTM" /></td>
	                        <td><label for="SEC_NM">과</label></td>
	                        <td><span id="SEC_NM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="RPT_FIRM">신고인 상호</label></td>
	                        <td><span id="RPT_FIRM" /></td>
	                        <td><label for="CHK_PERSON_NM">검사담당자</label></td>
	                        <td><span id="CHK_PERSON_NM" /></td>
	                        <td><label for="CUS_PERSON_TELNO">세관담당자 전화번호</label></td>
	                        <td><span id="CUS_PERSON_TELNO" /></td>
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
