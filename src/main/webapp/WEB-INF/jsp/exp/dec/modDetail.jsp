<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출정정신청 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <c:set var="userId" value="${session.getUserId()}" />
    <script>
        $(function (){
        	
        	$("#MOD_TYPE").val("${SEND_DIVI}");
        	$("#CALL_TYPE").val("${CALL_TYPE}");
        	
        	fn_setCombo();  //공통콤보  조회
        	
        	fn_bind(); 		//데이터 바인드
        	
        	fn_controll();	//화면 controll
        	
        	gridInit();		//그리드 초기화
            
        	$('#btnList').on("click", function (e) {
        		if($("#CALL_TYPE").val() == "MOD_POP"){
        			$.comm.forward("exp/dec/modList", {"RPT_NO":"${RPT_NO}"});
           	  	}else{
           	  		$.comm.forward("exp/dec/modList", '');
           	  	}
        		//$.comm.pageBack(); 
        		
        	});	//목록btn
        	
        	$('#btnPrint').on("click", function (e) { fn_print(); });		//출력
        	
        	$('#btnCommSave').on("click", function (e) { fn_commSave(); });	//공통저장
        	
        	$('#btnDtlAdd').on("click", function (e) { fn_dtlPopup(); });	//정정내역생성
            
        });
        
        function fn_setCombo(){
        	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
        	$.comm.bindCombo("CUS"      			, "CUS0015", true, null, null, null, 3);	//세관
        	$.comm.bindCombo("SEC"    				, "CUS0004", true, null, null, null, 3);	//과
        	//$.comm.bindCombo("SEND_DIVI"    		, "CUS0030", true, null, null, null, 3);	//정정신청구분
        	if($("#MOD_TYPE").val() == "B"){
       	  		$.comm.bindCombo("MODI_DIVI"    		, "CUS0032", true, null, null, null, 3);
       	  	}else{
       	  		$.comm.bindCombo("MODI_DIVI"    		, "CUS0029", true, null, null, null, 3);
       	  	}
            $.comm.bindCombo("DUTY_CODE"    		, "CUS0028", true, null, null, null, 3);	//귀책사유

        }
        
        function fn_bind(){
        	var param = {
                "qKey"    : "mod.selectModDetail",
                "RPT_NO"  : "${RPT_NO}",
                "MODI_SEQ"  : "${MODI_SEQ}"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
                    $.comm.bindData(data.data);
                    
                },
                "수출정정신청 상세조회"
            );
        }
        
        function gridInit(){
           headers = [
			   //{"HEAD_TEXT": "순번"        		, "WIDTH": "20"    , "FIELD_NAME": "SEQ_NO"},
			   {"HEAD_TEXT": "구분"        		, "WIDTH": "80"    , "FIELD_NAME": "RAN_DIVI"},
               {"HEAD_TEXT": "란"       			, "WIDTH": "80"    , "FIELD_NAME": "RAN_NO"},
               {"HEAD_TEXT": "규격"       	    , "WIDTH": "80"    , "FIELD_NAME": "SIZE_NO"},
               {"HEAD_TEXT": "항목"      		, "WIDTH": "120"   , "FIELD_NAME": "ITEM_NO"},
               {"HEAD_TEXT": "항목명"       		, "WIDTH": "150"   , "FIELD_NAME": "ITEM_NM"   , "ALIGN":"left"},
               {"HEAD_TEXT": "정정전내역"       	, "WIDTH": "250"   , "FIELD_NAME": "MODIFRONT" , "ALIGN":"left"},
               {"HEAD_TEXT": "정정후내역"       	, "WIDTH": "250"   , "FIELD_NAME": "MODIAFTER" , "ALIGN":"left"}
           ];
           
           gridWrapper = new GridWrapper({
               "actNm"        : "수출정정 내역 조회",
               "targetLayer"  : "gridLayer",
               "qKey"         : "mod.selectModSubList",
               "headers"      : headers,
               //"paramsFormId" : "detailForm",
               "paramsGetter" : {"RPT_NO":"${RPT_NO}", "MODI_SEQ":"${MODI_SEQ}"},
               "check"        : false,
               "firstLoad"    : true,
               "controllers"  : []
           });
           
        }
        
 		function fn_controll(){
	    	
        	$.comm.disabled("RPT_NO", true);
        	$.comm.disabled("MODI_SEQ", true);
        	$.comm.disabled("DPT_DAY", true);
        	$.comm.disabled("DPT_NO", true);
        	$.comm.disabled("JU_MARK", true);
        	$.comm.disabled("JU_NAME", true);
        	$.comm.disabled("RPT_DAY", true);
        	$.comm.disabled("LIS_DAY", true);
        	$.comm.disabled("EXP_NAME", true);
        	$.comm.disabled("EXP_TGNO", true);
        	$.comm.disabled("EXP_ADDR1", true);
        	$.comm.disabled("EXP_ADDR2", true);
        	$.comm.disabled("SEND_DIVI_NM", true);
            
 		}
 		
 		function fn_print(){
           	var param = {
                "qKey"    : "dec.selectExpDecStatusForPrint",
                "RPT_NO"  : $("#RPT_NO").val(),
                "MODI_SEQ"  : $("#MODI_SEQ").val()
            };
            
            var result = $.comm.sendSync("/common/select.do", param, "수출정정신청 출력시 상태조회").data;
            if(result) {
            	var status = result.STATUS;
            	if(!status || status == 'N') {
            		alert($.comm.getMessage("I00000020")); //[접수, 승인, 서류변경, 기각] 상태 일때만 출력할 수 있습니다.
        			return;
            	}
            } else {
            	alert($.comm.getMessage("I00000020")); //[접수, 승인, 서류변경, 기각] 상태 일때만 출력할 수 있습니다.
    			return;
            }

           	var params = {};
       		params["pRPT_NO"] = $("#RPT_NO").val();
       		params["pMODI_SEQ"] = $("#MODI_SEQ").val();
       		fnReportPrint('CUSDMR5ASV', params, '수출신고 정정/취하/적재기간연장 승인서 출력');
 		}
 		
 		// 저장
        function fn_commSave(){
            if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                return;
            }
            $.comm.sendForm("/dec/saveModExpDecAll.do", "detailForm", fn_callback, "수출정정취하신고 수정");
        }
 		
        var fn_callback = function (data) {
            if(data.code.indexOf('I') == 0){
                //alert("fn_callback");
            }
        }
 		
 		//정정내역생성
 		function fn_dtlPopup(){
 			//정정내역의 최종차수는 무조건 '00' 이므로 '00'을 보내준다
 			$.comm.setModalArguments({"RPT_NO":"${RPT_NO}", "RPT_SEQ":"00", "MODI_SEQ":"${MODI_SEQ}"});
 			var spec = "width:1300px;height:780px;scroll:1;status:no;center:yes;resizable:yes;";
            // 모달 호출
            $.comm.dialog("<c:out value='/jspView.do?jsp=exp/dec/modDetailPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    	
                    }
                }
            );
 		}
        
    </script>
</head>
<body>
<div class="inner-box">
    <form id="detailForm" name="detailForm" method="post">
	    <input type="hidden" name="REQ_NO" id="REQ_NO">
	    <input type="hidden" name="MOD_TYPE" id="MOD_TYPE">
	    <input type="hidden" name="CALL_TYPE" id="CALL_TYPE">
    <div class="padding_box">
    	<div class="title_frame">
    		<div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
				<div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btnList">목록</a>
	               	<a href="#" class="title_frame_btn" id="btnPrint">출력</a>
	               	<c:if test="${REG_ID eq userId && (RECE eq NULL || RECE eq '' || RECE eq '01')}">
	               		<a href="#" class="title_frame_btn" id="btnCommSave">저장</a>
	               	</c:if>
				</div>
			</div>
			<p><a href="#" class="btnToggle_table">수출신고정보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">수출신고정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                    </colgroup>
                        <tr>
                            <td>
                            	<label>제출번호/차수</label>
                                <label for="RPT_NO" style="display: none;">제출번호</label>
                                <label for="MODI_SEQ" style="display: none;">수출정정차수</label>
                            </td>
                            <td>
                            	<input type="text" name="RPT_NO" id="RPT_NO" style="width: 60% !important; ">
                            	<input type="text" name="MODI_SEQ" id="MODI_SEQ" style="width: 30% !important; ">
                            </td>
                            <td>
                            	<label>정정승인일자/승인번호</label>
                                <label for="DPT_DAY" style="display: none;">정정승인일자</label>
                                <label for="DPT_NO" style="display: none;">정정승인번호</label>
                            </td>
                            <td>
                            	<input type="text" name="DPT_DAY" id="DPT_DAY" style="width: 40% !important; " >
                            	<input type="text" name="DPT_NO" id="DPT_NO" style="width: 40% !important; " >
                            </td>
                            <td>
                            	<label>심사담당자부호/성명</label>
                                <label for="JU_MARK" style="display: none;">심사담당자부호</label>
                                <label for="JU_NAME" style="display: none;">심사담당자성명</label>
                            </td>
                            <td>
                            	<input type="text" name="JU_MARK" id="JU_MARK" style="width: 40% !important; " >
                            	<input type="text" name="JU_NAME" id="JU_NAME" style="width: 40% !important; " >
                            </td>
                        </tr>
                        <tr>
                            <td><label for="CUS">세관</label></td>
                            <td><select id="CUS" name="CUS"></select></td>
                            <td><label for="SEC">과</label></td>
                            <td colspan="3"><select id="SEC" name="SEC" style="width: 30%;"></select></td>
                        </tr>
                        <tr>
                            <td><label for="MODI_DAY">정정신청일자</label></td>
                            <td><input type="text" name="MODI_DAY" id="MODI_DAY" <attr:datefield/>></td>
                            <td><label for="RPT_DAY">수출신고일자</label></td>
                            <td><input type="text" name="RPT_DAY" id="RPT_DAY" style="width: 40% !important; " ></td>
                            <td><label for="LIS_DAY">수출수리일자</label></td>
                            <td><input type="text" name="LIS_DAY" id="LIS_DAY" style="width: 40% !important; " ></td>
                        </tr>
                        <tr>
                            <td><label for="EXP_NAME">수출자상호</label></td>
                            <td colspan="3"><input type="text" name="EXP_NAME" id="EXP_NAME" style=""></td>
                            <td><label for="EXP_TGNO">통관고유부호</label></td>
                            <td><input type="text" name="EXP_TGNO" id="EXP_TGNO"  style=""></td>
                        </tr>
                        <tr>
                            <td>
                            	<label>주소</label>
                                <label for="EXP_ADDR1" style="display: none;">주소1</label>
                                <label for="EXP_ADDR2" style="display: none;">주소2</label>
                            </td>
                            <td colspan="5">
                            	<input type="text" name="EXP_ADDR1" id="EXP_ADDR1"  style="width: 50% !important; " >
                            	<input type="text" name="EXP_ADDR2" id="EXP_ADDR2"  style="width: 30% !important; " >
                            </td>
                        </tr>
                	</table>
               	</div><!-- //table_typeA 3단구조 -->
            </div><!-- //title_frame -->
            
            <div class="title_frame">
				<p><a href="#" class="btnToggle_table">신청구분/사유</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">신청구분/사유</caption>
						<colgroup>
							<col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
						</colgroup>
						<tr>
                            <td><label for="SEND_DIVI_NM">신청구분</label></td><!-- Combo,CMM_STD_CODE.CUS0030 -->
                            <td>
                            	<!-- <select id="SEND_DIVI" name="SEND_DIVI"></select> -->
                            	<input type="text" name="SEND_DIVI_NM" id="SEND_DIVI_NM">
                            </td>
                            <!-- 정정신청구분이 B(취하) 이면 Combo,CMM_STD_CODE.CUS0032, 아니면  Combo,CMM_STD_CODE.CUS0029 -->
                            <td><label for="MODI_DIVI">정정/취하사유 부호</label></td>
                            <td>
                            	<select id="MODI_DIVI" name="MODI_DIVI"></select>
                            </td>
                            <td><label for="DUTY_CODE">귀책사유</label></td><!-- Combo,CMM_STD_CODE.CUS0028 -->
                            <td>
                            	<select id="DUTY_CODE" name="DUTY_CODE"></select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="MODI_COT">정정/취하사유</label></td>
                            <td colspan="5">
                            	<textarea  name="MODI_COT" id="MODI_COT" rows="3" style="height: 100px; " <attr:length value="500" />></textarea>
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->	
         	
            <c:if test="${SEND_DIVI eq 'A' || SEND_DIVI eq 'C'}">
	         	<div class="title_frame">
	            	<div class="title_btn_frame clearfix">
	                	<p><a href="#" class="btnToggle_table">정정내역</a></p>
			                <c:if test="${SEND_DIVI eq 'A'}">
			                	<c:if test="${REG_ID eq userId && (RECE eq NULL || RECE eq '' || RECE eq '01')}">
					                <div class="title_btn_inner">
					                    <a href="#" class="title_frame_btn" id="btnDtlAdd">정정내역생성</a>   
					                </div>
				                </c:if>
			                </c:if>
	            	</div>
		            <div id="gridLayer" style="height: 214px;"></div>   
	            </div>
            </c:if>
                                                 
        </div><%-- // padding_box--%>
    </form>
</div><%-- // inner-box--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
