<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출보완통보 상세조회
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
             "qKey"    : "res.select5gxDetail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출보완통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출보완통보</a></p>
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
	                        <td><label for="RPT_NO">수출신고번호</label></td>
	                        <td><span id="RPT_NO" /></td>
	                        <td><label for="DPT_DTM">통보일자</label></td>
	                        <td colspan="3"><span id="DPT_DTM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="DOC_NO">문서번호</label></td>
	                        <td><span id="DOC_NO" /></td>
	                         <td><label for="RPT_DTM">신고일자</label></td>
	                        <td><span id="RPT_DTM" /></td>
	                        <td><label for="LIMIT_DTM">보완완료일자</label></td>
	                        <td><span id="LIMIT_DTM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="REASON_CD">보완요구사유 코드</label></td>
	                        <td><span id="REASON_CD"/></td>
	                        <td><label for="RPT_MARK">신고자 부호</label></td>
	                        <td><span id="RPT_MARK"/></td>
	                        <td><label for="CUS">보완통보 세관코드</label></td>
	                        <td><span id="CUS"/></td>
	                    </tr>
	                    <tr>
	                    	<td><label for="REASON_NM">보완요구사유 명</label></td>
	                        <td><span id="REASON_NM"/></td>
	                        <td><label for="RPT_MARK">신고자 상호</label></td>
	                        <td><span id="RPT_FIRM"/></td>
	                        <td><label for="CUS_NM">보완통보 세관명</label></td>
	                        <td><span id="CUS_NM"/></td>
	                    </tr>
	                    <tr>
	                        <td><label for="REQ_TXT">보완요구사항</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id="NOTICE_TXT"></span></div>
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
