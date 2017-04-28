<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출정정요청 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        $(function (){
        	$("#MOD_TYPE").val("${TYPECODE}");
        	
        	//공통콤보  조회
        	fn_setCombo();
        	
        	//데이터 바인드
        	fn_bind();
        	
            
            // 목록 btn
            $('#btn_list').on("click", function (e) {
                $.comm.forward("exp/req/modReqList",{});
            });
            
            $("#TYPECODE").change(function() {
           	  	var comboVal = $(this).val();
            	// 정정신청구분이 B(취하) 이면 Combo,CMM_STD_CODE.CUS0032, 아니면  Combo,CMM_STD_CODE.CUS0029 
           	  	if(comboVal == "B"){
           	  		$.comm.bindCombo("AMENDTYPECD"    		, "CUS0032", true, null, null, null, 3);
           	  	}else{
           	  		$.comm.bindCombo("AMENDTYPECD"    		, "CUS0029", true, null, null, null, 3);
           	  	}
           	});
            
            fn_controll();
            
        });
        
        function fn_setCombo(){
        	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
        	$.comm.bindCombo("STATUS"      			, "AAA1003", true, null, null, null, 3);	//상태
        	$.comm.bindCombo("OFFICECODE"      		, "CUS0015", true, null, null, null, 3);	//세관
        	$.comm.bindCombo("DEPARTMENTCODE"      	, "CUS0004", true, null, null, null, 3);	//과
        	
        	$.comm.bindCombo("TYPECODE"      		, "CUS0030", true, null, null, null, 3);	//정정신청구분
        	if($("#MOD_TYPE").val() == "B"){
        		$.comm.bindCombo("AMENDTYPECD"    		, "CUS0032", true, null, null, null, 3);	//정정/취하사유 부호 (default:CUS0032, CUS0029)
       	  	}else{
       	  		$.comm.bindCombo("AMENDTYPECD"    		, "CUS0029", true, null, null, null, 3);	//정정/취하사유 부호 (default:CUS0032, CUS0029)
       	  	}
        	
        	$.comm.bindCombo("OBLIGATIONREASONCD"   , "CUS0028", true, null, null, null, 3);	//귀책사유부호
        }
        
        function fn_bind(){
        	var param = {
                "qKey"    : "req.selectModReqDetail",
                "REQ_NO"  : "${REQ_NO}"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
                    $.comm.bindData(data.data);
                },
                "수출정정요청 상세조회"
            );
        }
        
        function fn_controll(){
        	$.comm.disabled("REQ_NO", true);
        	$.comm.disabled("ORDER_ID", true);
        	$.comm.disabled("REFERENCEID", true);
        	$.comm.disabled("STATUS", true);
        	$.comm.disabled("REGIST_METHOD", true);
        	$.comm.disabled("SELLER_ID", true);
        	$.comm.disabled("REQUEST_DIV", true);
        	$.comm.disabled("APPLICANTPARTYORGID", true);
        	$.comm.disabled("AGENTNAME", true);
        	$.comm.disabled("AGENTREPNAME", true);
        	$.comm.disabled("OFFICECODE", true);
        	$.comm.disabled("DEPARTMENTCODE", true);
        	$.comm.disabled("TYPECODE", true);
        	$.comm.disabled("AMENDTYPECD", true);
        	$.comm.disabled("OBLIGATIONREASONCD ", true);
        	$.comm.disabled("AMENDREASON", true);
        	$.comm.disabled("MODI_CONTENTS", true);
        	$.comm.disabled("ATCH_FILE_ID", true);
        	
        	$(':input[type=text]').each(function(){
	            $(this).addClass("td_input inputHeight");
            });
            
            $('select').each(function(){
	            $(this).addClass("td_select inputHeight");
            });

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
		            <input type="hidden" name="SAVE_MODE" id="SAVE_MODE" value="${SAVE_MODE}">
		            <input type="hidden" name="MOD_TYPE" id="MOD_TYPE" value="">
				</div>
			</div>
			<p><a href="#" class="btnToggle_table">상세정보</a></p>
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
                            <td><label for="REQ_NO">요청관리번호</label></td>
                            <td>
                            	<input type="text" name="REQ_NO" id="REQ_NO">
                            </td>
                            <td><label for="ORDER_ID">주문번호</label></td>
                            <td><input type="text" name="ORDER_ID" id="ORDER_ID"></td>
                            <td><label for="REFERENCEID">수출신고번호</label></td>
                            <td>
                            	<input type="text" name="REFERENCEID" id="REFERENCEID" style="width: 60% !important">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label>상태/등록구분</label><!-- Combo,CMM_STD_CODE.CUS0036 -->
                                <label for="STATUS" style="display: none;">상태</label>
                                <label for="REGIST_METHOD" style="display: none;">등록구분</label>
                            </td>
                            <td>
                               <select id="STATUS" name="STATUS" style="width: 40%;"></select>
                               <input type="text" name="REGIST_METHOD" id="REGIST_METHOD" style="width: 40% !important">
                            </td>
                            <td><label for="SELLER_ID">판매자ID</label></td>
                            <td><input type="text" name="SELLER_ID" id="SELLER_ID"></td>
                            <td><label for="REQUEST_DIV">요청구분</label></td>
                            <td><input type="text" name="REQUEST_DIV" id="REQUEST_DIV" style="width: 20% !important">N:신규,U:수정</td>
                        </tr>
                	</table>
               	</div><!-- //table_typeA 3단구조 -->
            </div><!-- //title_frame -->
            
            <div class="title_frame">
				<p><a href="#" class="btnToggle_table">신고자정보</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">신고자정보</caption>
						<colgroup>
							<col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
						</colgroup>
						<tr>
                            <!-- POP-UP(신고인부호, 신고자상호, 상고자대표자 성명을 가져한다.
                            SELECT APPLICANT_ID, USER_NM, REP_NM 
                              FROM CMM_USER
                             WHERE USER_DIV = 'G'  -->
                            <td><label for="APPLICANTPARTYORGID">신고인부호</label></td>
                            <td><input type="text" name="APPLICANTPARTYORGID" id="APPLICANTPARTYORGID"></td>
                            <td><label for="AGENTNAME">신고자상호</label></td>
                            <td><input type="text" name="AGENTNAME" id="AGENTNAME"></td>
                            <td><label for="AGENTREPNAME">신고자대표자성명</label></td>
                            <td><input type="text" name="AGENTREPNAME" id="AGENTREPNAME" ></td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">정정/취하내역</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">정정/취하내역</caption>
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
                                <label for="OFFICECODE">세관</label><!-- Combo,CMM_STD_CODE.CUS0015 -->
                            </td>
                            <td>
                            	<select id="OFFICECODE" name="OFFICECODE"></select>
                            </td>
                            <td>
                                <label for="DEPARTMENTCODE">과</label><!-- Combo,CMM_STD_CODE.CUS0004 -->
                            </td>
                            <td colspan="3">
                            	<select id="DEPARTMENTCODE" name="DEPARTMENTCODE"></select>
                            </td>
                    	</tr>
                        <tr>
                            
                            <td><label for="TYPECODE">정정신청구분</label></td><!-- Combo,CMM_STD_CODE.CUS0030 -->
                            <td>
                            	<select id="TYPECODE" name="TYPECODE"></select>
                            </td>
                            <td>
                            	<label for="AMENDTYPECD" >정정/취하사유부호</label>
                            	<!-- 정정신청구분이 B(취하) 이면 Combo,CMM_STD_CODE.CUS0032 아니면  Combo,CMM_STD_CODE.CUS0029 -->
                            </td>
                            <td>
                            	<select id="AMENDTYPECD" name="AMENDTYPECD"></select>
                            </td>
                            <td><label for="OBLIGATIONREASONCD">귀책사유부호</label></td><!-- Combo,CMM_STD_CODE.CUS0028 -->
                            <td>
                            	<select id="OBLIGATIONREASONCD" name="OBLIGATIONREASONCD"></select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="AMENDREASON">정정/취하 사유</label></td>
                            <td colspan="5"><input type="text" name="AMENDREASON" id="AMENDREASON" ></td>
                        </tr>
                        <tr>
                            <td><label for="MODI_CONTENTS">정정요청내역</label></td>
                            <td colspan="5"><input type="text" name="MODI_CONTENTS" id="MODI_CONTENTS"></td>
                        </tr>
                        <tr>
                            <td><label for="ATCH_FILE_ID">정정의뢰첨부파일</label></td>
                            <td colspan="5"><input type="text" name="ATCH_FILE_ID" id="ATCH_FILE_ID"></td>
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
