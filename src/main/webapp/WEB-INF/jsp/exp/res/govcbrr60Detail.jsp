<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출자동보완통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
	var gridWrapper, headers;
    $(function (){
    	headers = [
		    {"HEAD_TEXT": "일련번호"  		, "WIDTH": "50"  , "FIELD_NAME": "SEQ"},
            {"HEAD_TEXT": "자동보완 검증모델명" , "WIDTH": "300" , "FIELD_NAME": "CARGO_GNM"},
            {"HEAD_TEXT": "자동보완 내역" 		, "WIDTH": "500" , "FIELD_NAME": "REASON"}
		];
		
		gridWrapper = new GridWrapper({
            "actNm"        : "수출자동보완통보 상세목록조회",
            "targetLayer"  : "gridLayer",
            "qKey"         : "res.selectR60DetailList",
            "headers"      : headers,
            "paramsGetter" : {"KEY_NO":"${DOC_ID}"},
            "countId"      : "totCnt",
            "check"        : false,
            "scrollPaging" : true,
            "firstLoad"    : true,
            "controllers"  : [
                {"btnName": "btnExcelDetail" , "type": "EXCEL", "qKey":"res.selectR20DetailList", "postScript": "fn_ableExcel" }
            ]
        });
    	
    	//초기화
     	initForm();
         
         // 목록 btn
         $('#btn_list').on("click", function (e) {
           	$.comm.pageBack();
         })
    });
     
    function initForm(){
    	var param = {
             "qKey"    : "res.selectR60Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출자동보완통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출자동보완통보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="15%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="*" />
                    </colgroup>
                        <tr>
                            <td><label for="RPT_NO">수출신고번호</label></td>
                            <td><span id="RPT_NO" /></td>
                            <td><label for="DPT_DTM">통보일시</label></td>
                            <td><span id="DPT_DTM" /></td>
                            <td><label for="CUS_NM">세관</label></td>
                            <td><span id="CUS_NM" /></td>
                        </tr>
                        <tr>
                            <td><label for="EXP_TGNO">수출화주 통관고유부호</label></td>
                            <td><span id="EXP_TGNO" /></td>
                            <td><label for="RCV_DTM">수신일시</label></td>
                            <td><span id="RCV_DTM" /></td>
                            <td><label for="SEC_NM">과</label></td>
                            <td><span id="SEC_NM" /></td>
                        </tr>
                        <tr>
                            <td><label for="EXP_FIRM">수출화주 상호</label></td>
                            <td colspan="5"><span id="EXP_FIRM" /></td>
                        </tr>
                	</table>
               	</div><!-- //table_typeA 3단구조 -->
            </div><!-- //title_frame -->
	        
	        <div class="title_frame">
		        <p><a href="#" class="btnToggle_table">상세내역</a></p>
		        <div class="white_frame">
		        	<div class="util_frame" style="margin-top: -10px">
		            </div>
		            <div id="gridLayer" style="height: 220px">
		            </div>
		        </div>
	        </div>
        </div><%-- // padding_box--%>
    </form>
    
    
</div><%-- // inner-box--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
