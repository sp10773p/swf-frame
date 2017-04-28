<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출수리취소예정통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
	var gridWrapper, headers;
    $(function (){
    	headers = [
		    {"HEAD_TEXT": "수출신고번호"  , "WIDTH": "200" , "FIELD_NAME": "RPT_NO"},
            {"HEAD_TEXT": "신고일자"      , "WIDTH": "150" , "FIELD_NAME": "RPT_DTM"},
            {"HEAD_TEXT": "수리일자"      , "WIDTH": "150" , "FIELD_NAME": "LIS_DTM"},
            {"HEAD_TEXT": "적재기간"      , "WIDTH": "150" , "FIELD_NAME": "JUK_DTM"},
            {"HEAD_TEXT": "수출자상호"    , "WIDTH": "200" , "FIELD_NAME": "EXP_FIRM"},
            {"HEAD_TEXT": "품명"         , "WIDTH": "300" , "FIELD_NAME": "ITEM_GNM"},
            {"HEAD_TEXT": "포장개수"      , "WIDTH": "100" , "FIELD_NAME": "PACK_CNT" , "ALIGN":"right" },
            {"HEAD_TEXT": "중량"         , "WIDTH": "100" , "FIELD_NAME": "WT" , "ALIGN":"right"}
		];
		
		gridWrapper = new GridWrapper({
            "actNm"        : "수출수리취소예정통보 상세목록조회",
            "targetLayer"  : "gridLayer",
            "qKey"         : "res.selectR98DetailList",
            "headers"      : headers,
            "paramsGetter" : {"KEY_NO":"${DOC_ID}"},
            "countId"      : "totCnt",
            "check"        : false,
            "scrollPaging" : true,
            "firstLoad"    : true,
            "controllers"  : [
                {"btnName": "btnExcelDetail" , "type": "EXCEL", "qKey":"res.selectR98DetailList", "postScript": "fn_ableExcel" }
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
             "qKey"    : "res.selectR98Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출수리취소예정통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출수리취소예정통보</a></p>
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
                            <td><label for="RPT_FIRM">수신인</label></td>
                            <td><span id="RPT_FIRM" /></td>
                            <td><label for="DPT_DTM">통보일시</label></td>
                            <td colspan="3"><span id="DPT_DTM" /></td>
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
