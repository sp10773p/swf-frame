<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출분석결과통보 상세조회
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
         
        $.comm.readonly("RPT_NO", true);
     	$.comm.readonly("RAN_NO", true);
     	$.comm.readonly("SEQ_NO", true);
    });
     
    function init(){
    	var param = {
             "qKey"    : "res.selectR96Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출분석결과통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출분석결과통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="14%" />
                        <col width="28%" />
                        <col width="13%" />
                        <col width="15%" />
                        <col width="13%" />
                        <col width="*" />
                    </colgroup>
                        <tr>
	                        <td>
	                        	<label>수출신고번호/란/규격</label>
	                        	<label for="RPT_NO" style="display: none;">수출신고번호</label>
	                        	<label for="RAN_NO" style="display: none;">란</label>
	                        	<label for="SEQ_NO" style="display: none;">규격</label>
	                        </td>
	                        <td>
	                        	<input type="text" name="RPT_NO" id="RPT_NO" class="td_input inputHeight" style="width: 50% !important">
	                        	<input type="text" name="RAN_NO" id="RAN_NO" class="td_input inputHeight" style="width: 18% !important">
	                            <input type="text" name="SEQ_NO" id="SEQ_NO" class="td_input inputHeight" style="width: 18% !important">
	                        </td>
	                        <td><label for="DOC_NO">분석회보 문서번호</label></td>
	                        <td><span id="DOC_NO"></span></td>
	                        <td><label for="CONF_HS">결정세번</label></td>
	                        <td><span id="CONF_HS"></span></td>
	                    </tr>
	                    <tr>
	                        <td><label for="RPT_DTM">신고일자</label></td>
	                        <td><span id="RPT_DTM"></span></td>
	                        <td><label for="DPT_DATE">안내일자</label></td>
	                        <td><span id="DPT_DATE"></span></td>
	                        <td><label for="HS">신고세번</label></td>
	                        <td><span id="HS"></span></td>
	                    </tr>
	                    <tr>
	                        <td><label for="CARGO_GNM">신고품명</label></td>
	                        <td><span id="CARGO_GNM"></span></td>
	                        <td><label for="RPT_FIRM">신고인상호</label></td>
	                        <td><span id="RPT_FIRM"></span></td>
	                        <td><label for="EXP_FIRM">화주상호</label></td>
	                        <td><span id="EXP_FIRM"></span></td>
	                    </tr>
	                    <tr>
	                        <td><label for="ITEM_GNM">모델규격</label></td>
	                        <td colspan="5"><span id="ITEM_GNM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="REASON">분류의견</label></td>
	                        <td colspan="5"><span id="REASON" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="NOTICE1">참고사항1</label></td>
	                        <td colspan="5"><span id="NOTICE1" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="NOTICE2">참고사항2</label></td>
	                        <td colspan="5"><span id="NOTICE2" /></td>
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
