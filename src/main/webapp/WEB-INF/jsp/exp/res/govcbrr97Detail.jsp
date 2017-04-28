<%--
  User: 김회재
  Date: 2017-04-05
  Form: 수출정정취하각하내역통보 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<script>
	var gridWrapper, headers;
    $(function (){
    	headers = [
            {"HEAD_TEXT": "란번호"        	 	, "WIDTH": "100"   , "FIELD_NAME": "RAN_NO" , "LINK":"fn_detail"},
            {"HEAD_TEXT": "란정정구분"          	, "WIDTH": "150"   , "FIELD_NAME": "RAN_DIVI"},
            {"HEAD_TEXT": "란정정항목번호"       	, "WIDTH": "200"   , "FIELD_NAME": "ITEM_CD"},
            {"HEAD_TEXT": "규격번호"            	, "WIDTH": "200"   , "FIELD_NAME": "SEQ_NO"},
            {"HEAD_TEXT": "컨테이너 일련번호"     	, "WIDTH": "200"   , "FIELD_NAME": "CONT_SEQNO"},
            {"HEAD_TEXT": "법령 일련번호"  	   	, "WIDTH": "200"   , "FIELD_NAME": "LAW_SEQNO"},
            {"HEAD_TEXT": "차대관리번호 일련번호"  	, "WIDTH": "200"   , "FIELD_NAME": "CAR_SEQNO"}
        ];
		
		gridWrapper = new GridWrapper({
            "actNm"        : "수출정정취하각하내역통보 상세목록조회",
            "targetLayer"  : "gridLayer",
            "qKey"         : "res.selectR97RanList",
            "headers"      : headers,
            "paramsGetter" : {"KEY_NO":"${DOC_ID}"},
            "countId"      : "totCnt",
            "check"        : false,
            "scrollPaging" : true,
            "firstLoad"    : true,
            "controllers"  : [
                {"btnName": "btnExcelDetail" , "type": "EXCEL", "qKey":"res.selectR97RanList", "postScript": "fn_ableExcel" }
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
             "qKey"    : "res.selectR97Detail",
             "KEY_NO"  : "${DOC_ID}"
         };

         $.comm.send("/common/select.do", param,
             function(data, status){
                 $.comm.bindData(data.data);
             },
             "수출정정취하각하내역통보 상세조회"
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
			<p><a href="#" class="btnToggle_table">수출정정취하각하내역통보</a></p>
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
	                        <td><label for="MODI_TYPE_NM">정정구분</label></td>
	                        <td colspan="3">
	                        	<span id="MODI_TYPE_NM"/>
	                        	<label>&nbsp;A:정정, B:취하, C:각하 </label>
	                        </td>
	                       
	                    </tr>
	                    <tr>
	                        <td><label for="EXP_FIRM">수출화주 상호</label></td>
	                        <td><span id="EXP_FIRM" /></td>
	                        <td><label for="MODI_DTM">정정일자</label></td>
	                        <td><span id="MODI_DTM" /></td>
	                        <td><label for="CUS_NM">세관</label></td>
	                        <td><span id="CUS_NM"/></td>
	                    </tr>
	                    
	                    <tr>
	                        <td><label for="EXP_TGNO">수출화주 통관고유부호</label></td>
	                        <td><span id="EXP_TGNO" /></td>
	                        <td><label for="IMPUT_CD_NM">귀책사유코드</label></td>
	                        <td><span id="IMPUT_CD_NM" /></td>
	                        <td><label for="SEC_NM">과</label></td>
	                        <td><span id="SEC_NM"/></td>
	                    </tr>
	                    <tr>
	                        <td><label for="CUS_PERSON">담당자</label></td>
	                        <td><span id="CUS_PERSON" /></td>
	                        <td><label for="MODI_CD_NM">정정사유코드</label></td>
	                        <td colspan="3"><span id="MODI_CD_NM" /></td>
	                    </tr>
	                   
	                    <tr>
	                        <td><label for="REASON">정정/취하/각하사유</label></td>
	                        <td colspan="5">
	                        	<div style="padding: 5px 0 5px 0;line-height:2.3em;overflow: auto;height: 150px;"><span id="REASON"></span></div>
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
