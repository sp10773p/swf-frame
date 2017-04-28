<%--
  User: 김회재
  Date: 2017-04-05
  Form: 오류통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
	var gridWrapper, headers;
    $(function (){
    	headers = [
		    {"HEAD_TEXT": "란번호"  		, "WIDTH": "100" , "FIELD_NAME": "ERR_RAN_NO"},
		    {"HEAD_TEXT": "오류위치"    	, "WIDTH": "100" , "FIELD_NAME": "ERR_POS"},
		    {"HEAD_TEXT": "오류문서 KEY"  , "WIDTH": "120" , "FIELD_NAME": "ERR_KEY"},
		    {"HEAD_TEXT": "오류내용"     , "WIDTH": "500" , "FIELD_NAME": "ERR_REASON" , "ALIGN":"left" }
		];
		
		gridWrapper = new GridWrapper({
            "actNm"        : "오류통보 상세목록조회",
            "targetLayer"  : "gridLayer",
            "qKey"         : "res.selectR20DetailList",
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
             "qKey"    : "res.selectR20Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "오류통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">오류통보</a></p>
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
                            <td><label for="RCV_DTM">수신일시</label></td>
                            <td><span id="RCV_DTM" /></td>
                            <td><label for="CUS_NM">세관</label></td>
                            <td><span id="CUS_NM" /></td>
                        </tr>
                        <tr>
                            <td><label for="RPT_SEQ">정정차수</label></td>
                            <td><span id="RPT_SEQ" /></td>
                            <td><label for="DPT_DTM">오류통보일시</label></td>
                            <td><span id="DPT_DTM" /></td>
                            <td><label for="SEC_NM">과</label></td>
                            <td><span id="SEC_NM" /></td>
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
