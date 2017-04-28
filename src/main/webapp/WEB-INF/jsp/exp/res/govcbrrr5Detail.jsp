<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출처리결과통보 상세조회
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
             "qKey"    : "res.selectRr5Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출처리결과통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출처리결과통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="15%" />
                        <col width="20%" />
                        <col width="14%" />
                        <col width="20%" />
                        <col width="14%" />
                        <col width="*" />
                    </colgroup>
                        <tr>
	                        <td><label for="RPT_NO">수출신고번호</label></td>
	                        <td><span id="RPT_NO"></span></td>
	                        <td><label for="RPT_DTM">수출신고 신고일자</label></td>
	                        <td colspan="3"><span id="RPT_DTM"></span></td>
	                    </tr>
	                    <tr>
	                        <td><label for="CUS_PERSON_CD">담당자 부호</label></td>
	                        <td><span id="CUS_PERSON_CD"></span></td>
	                        <td><label for="CHG_PERSON_CD">변경담당자 부호</label></td>
	                        <td><span id="CHG_PERSON_CD"></span></td>
	                         <td><label for="CUS_NM">접수세관</label></td>
	                        <td><span id="CUS_NM"></span></td>
	                    </tr>
	                    <tr>
	                    	<td><label for="CUS_PERSON_NM">담당자 명</label></td>
	                        <td><span id="CUS_PERSON_NM"></span></td>
	                        <td><label for="CHG_PERSON_NM">변경담당자명</label></td>
	                        <td><span id="CHG_PERSON_NM"></span></td>
	                        <td><label for="SEC_NM">접수과</label> </td>
	                        <td><span id="SEC_NM"></span></td>
	                    </tr>
	                    <tr>    
	                        <td><label for="RESULT_CD_NM">변경결과사유부호</label></td>
	                        <td><span id="RESULT_CD_NM"></span></td>
	                        <td><label for="RESULT_CHG_CD_NM">검사변경통보부호</label></td>
	                        <td colspan="3"><span id="RESULT_CHG_CD_NM"></span></td>
	                    </tr>   
	                    <tr>
	                        <td><label for="RESULT_TXT">변경사유내용</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id="RESULT_TXT"></span></div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td><label for="RESULT_ETC_TXT">검사변경사유 기타내용</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id="RESULT_ETC_TXT"></span></div>
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
