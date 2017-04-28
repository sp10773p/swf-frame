<%--
  User: 김회재
  Date: 2017-04-05
  Form: 접수통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
	var gridWrapper, headers;
    $(function (){
    	headers = [
            {"HEAD_TEXT": "접수결과구분"     	, "WIDTH": "150"   , "FIELD_NAME": "RESULT_CD", "LINK":"fn_detail"},
            {"HEAD_TEXT": "접수결과내역"     	, "WIDTH": "150"   , "FIELD_NAME": "RESULT_TXT" , "ALIGN":"left"},
            {"HEAD_TEXT": "등록자ID"       	, "WIDTH": "150"   , "FIELD_NAME": "REG_ID" },
            {"HEAD_TEXT": "등록일시"      	, "WIDTH": "200"   , "FIELD_NAME": "REG_DTM"},
            {"HEAD_TEXT": "수정자ID"       	, "WIDTH": "150"   , "FIELD_NAME": "MOD_ID" },
            {"HEAD_TEXT": "수정일시"   		, "WIDTH": "200"   , "FIELD_NAME": "MOD_DTM"}
        ];
		
		gridWrapper = new GridWrapper({
            "actNm"        : "접수통보 상세목록조회",
            "targetLayer"  : "gridLayer",
            "qKey"         : "res.select5afItemList",
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
         
        $.comm.readonly("RCV_PERSON_CD", true);
     	$.comm.readonly("RCV_PERSON_NM", true);
     	$.comm.readonly("DPT_CUS_NM", true);
     	$.comm.readonly("DPT_SEC_NM", true);
     	$.comm.readonly("CHK_PERSON_CD", true);
     	$.comm.readonly("CHK_PERSON_NM", true);
     	$.comm.readonly("RCV_CUS_NM", true);
     	$.comm.readonly("RCV_SEC_NM", true);
     	$.comm.readonly("CHK_CUS_NM", true);
     	$.comm.readonly("CHK_SEC_NM", true);
    });
     
    function initForm(){
    	var param = {
             "qKey"    : "res.select5afDetail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "접수통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">접수통보</a></p>
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
	                        <td><label for="DPT_DTM">접수통보일시</label></td>
	                        <td><span id="DPT_DTM" /></td>
	                        <td><label for="RCV_DTM">신청문서 수신일시</label></td>
	                        <td><span id="RCV_DTM" /></td>
	                    </tr>
	                    <tr>
	                        <td><label for="RPT_SEQ">차수</label></td>
	                        <td><span id="RPT_SEQ" /></td>
	                        <td>
	                        	<label>세관담당자 부호/명</label>
	                        	<label for="RCV_PERSON_CD" style="display: none;">세관담당자 부호</label>
	                        	<label for="RCV_PERSON_NM" style="display: none;">세관담당자 명</label>
	                        </td>
	                        <td>
	                        	<input type="text" name="RCV_PERSON_CD" id="RCV_PERSON_CD" class="td_input inputHeight" style="width: 40% !important">
	                            <input type="text" name="RCV_PERSON_NM" id="RCV_PERSON_NM" class="td_input inputHeight" style="width: 40% !important">
	                        </td>
	                        <td>
	                        	<label>통보 세관/과</label>
	                        	<label for="DPT_CUS_NM" style="display: none;">통보 세관</label>
	                        	<label for="DPT_SEC_NM" style="display: none;">통보 과</label>
	                        </td>
	                        <td>
	                        	<input type="text" name="DPT_CUS_NM" id="DPT_CUS_NM" class="td_input inputHeight" style="width: 40% !important">
	                            <input type="text" name="DPT_SEC_NM" id="DPT_SEC_NM" class="td_input inputHeight" style="width: 40% !important">
	                        </td>
	                    </tr>
	                    <tr>
	                        <td><label for="DOC_CD">신청서 문서구분</label></td>
	                        <td><span id="DOC_CD" /></td>
	                        <td>
	                        	<label>심사담당자 부호/명</label>
	                        	<label for="CHK_PERSON_CD" style="display: none;">심사담당자 부호</label>
	                        	<label for="CHK_PERSON_NM" style="display: none;">심사담당자 명</label>
	                        </td>
	                        <td>
	                        	<input type="text" name="CHK_PERSON_CD" id="CHK_PERSON_CD" class="td_input inputHeight" style="width: 40% !important">
	                            <input type="text" name="CHK_PERSON_NM" id="CHK_PERSON_NM" class="td_input inputHeight" style="width: 40% !important">
	                        </td>
	                        <td>
	                        	<label>접수 세관/과</label>
	                        	<label for="RCV_CUS_NM" style="display: none;">접수 세관</label>
	                        	<label for="RCV_SEC_NM" style="display: none;">접수 과</label>
	                        </td>
	                        <td>
	                        	<input type="text" name="RCV_CUS_NM" id="RCV_CUS_NM" class="td_input inputHeight" style="width: 40% !important">
	                            <input type="text" name="RCV_SEC_NM" id="RCV_SEC_NM" class="td_input inputHeight" style="width: 40% !important">
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>
	                        	<label>심사 세관/과</label>
	                        	<label for="CHK_CUS_NM" style="display: none;">심사 세관</label>
	                        	<label for="CHK_SEC_NM" style="display: none;">심사 과</label>
	                        </td>
	                        <td colspan="5">
	                        	<input type="text" name="CHK_CUS_NM" id="CHK_CUS_NM" class="td_input inputHeight" style="width: 10% !important">
	                            <input type="text" name="CHK_SEC_NM" id="CHK_SEC_NM" class="td_input inputHeight" style="width: 10% !important">
	                        </td>
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
