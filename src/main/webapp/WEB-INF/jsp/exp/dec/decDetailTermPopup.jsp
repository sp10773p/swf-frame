<%--
  User: jjkhj
  Date: 2017-02-20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
	    var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
	    var rptNo = arguments.RPT_NO;
	    var jukDay = arguments.JUK_DAY;
        $(function () {
        	fn_setCombo(); 	//공통콤보  조회
        	
        	$('#btnTermSave').on("click", function (e) { fn_termSave(); });		//기간연장 저장
        	
        	$("#ISSUEDATE").val(jukDay);
        });
		
        function fn_setCombo(){
        	$.comm.bindCombos.addComboInfo("TERM_CD" 				, "CUS0029", true, null, null, null, 3);	//정정사유코드
        	$.comm.bindCombos.addComboInfo("TERM_OBL_REASONCD" 		, "CUS0028", true, null, null, null, 3);	//귀책사유코드
        	
        	$.comm.bindCombos.draw();
        }
        
      //기간연장
      	function fn_termSave(){
      		var params = openerFormData("detailForm");
      		params["MODI_DIVI"] = $("#TERM_CD").val();
      		params["MODI_COT"] = $("#TERM_REASON").val();
      		params["DUTY_CODE"] = $("#TERM_OBL_REASONCD").val();
      		params["JUK_DAY_CHG"] = $("#ISSUEDATE").val();
      		params["SEND_DIVI"] = "C";	//신청구분(A:정정, B:신고취하, C:기간연장)
      		
      		if(fn_modChkCnt(params) != "0"){
      			if(fn_modChkRece(params) != "05" && fn_modChkRece(params) != "07"){
      				alert($.comm.getMessage("W00000073")); //수출정정 진행중입니다.
         			return;
         		}
     		}
      		
      		if(!fn_validate()){
      			return;
      		}
      		
      		if(!confirm($.comm.getMessage("C00000036"))){ // 신청 하시겠습니까?
                return;
            }
 
      		
      		$.comm.send("/dec/saveExpDecTerm.do", params, fn_callback, "수출신고 기간연장");
      		
      	}
      	
      	var openerFormData = function (formId) {
            var paramObj = {};
            var a = opener.$('#' + formId).serializeArray();
            $.each(a, function () {
                if(this.value != null && this.value != ''){
                    // 날짜필드이면 '-' 삭제
                    if(opener.$('#'+this.name).is('[datefield]')){
                        this.value = this.value.trim().replace(/\/|-/g, '');
                    }
                    paramObj[this.name] = this.value;
                }
            })

            return paramObj;
        }
      	
      	var fn_callback = function (data) {
      		var params = openerFormData("detailForm");
      		$.comm.setModalReturnVal({"RPT_NO":params["RPT_NO"]});
            close();
        }
      	
      	function fn_validate(){
   			if($.comm.isNull($('#TERM_CD').val())){
   				alert($.comm.getMessage("W00000046", "정정사유코드")); // 정정사유코드를 선택하세요.
   				return false;
   			}
			if($.comm.isNull($('#TERM_REASON').val())){
				alert($.comm.getMessage("W00000004", "기간연장사유")); // 기간연장사유를 입력하세요.
				return false;
			} 
			if($.comm.isNull($('#TERM_OBL_REASONCD').val())){
				alert($.comm.getMessage("W00000046", "귀책사유코드")); // 귀책사유코드를 선택하세요.
				return false;
			}
			if($.comm.isNull($('#ISSUEDATE').val())){
				alert($.comm.getMessage("W00000004", "기간연장일")); // 기간연장일를 입력하세요.
				return false;
			}
			var beforeDay = jukDay.replace(/\/|-/g, '');
			var afterDay = $("#ISSUEDATE").val().replace(/\/|-/g, '');
			if(beforeDay >= afterDay){
				alert("기간연장일은 현재일보다 커야 합니다.");
				return false;
			}
      		
      		return true;
      	}
      	
     	// 수출기간연장 요청확인
    	 function fn_modChkCnt(params){
	    	var cnt = "";
	    	params["qKey"] = "mod.selectExpCusDmrChkCnt";
	        var modInfo = $.comm.sendSync("/common/select.do", params, "수출정정 진행확인 조회_count").data;
	        cnt = modInfo.CNT;
	        return cnt;
	    }
    	
    	// 수출기간연장 요청확인
    	 function fn_modChkRece(params){
	    	var rece = "";
	    	params["qKey"] = "mod.selectExpCusDmrChkRece";
	        var modInfo = $.comm.sendSync("/common/select.do", params, "수출정정 진행확인 조회_rece").data;
	        rece = modInfo.RECE;
	        return rece;
	    }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
       <h1>기간연장사유</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
		<a href="#" class="title_frame_btn" id="btnTermSave">신청</a>
	</div>
    <div class="layer_content" style="overflow: hidden;">
        <div class="title_frame">
		    <p>수출신고에 대한 기간연장 요청하시려면 아래 항목을 입력하세요.</p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">수출기간연장</caption>
				<colgroup>
					<col width="20%" />
                   	<col width="*" />
				</colgroup>
				<tr>
					<td>정정사유코드</td>
					<td>
						<label for="TERM_CD" style="display: none;">정정사유코드</label>
						<select id="TERM_CD" name="TERM_CD"></select>
					</td>
				</tr>
				<tr>
					<td>기간연장사유</td>
					<td>
						<label for="TERM_REASON" style="display: none;">기간연장사유</label>
						<textarea id="TERM_REASON" name="TERM_REASON" style="width:100%; min-height:170px; border:none;"></textarea>
					</td>
				</tr>
				<tr>
					<td>귀책사유코드</td>
					<td>
						<label for="TERM_OBL_REASONCD" style="display: none;">귀책사유코드</label>
						<select id="TERM_OBL_REASONCD" name="TERM_OBL_REASONCD"></select>
					</td>
				</tr>
				<tr>
					<td>기간연장일</td>
					<td>
						<label for="ISSUEDATE" style="display: none;">기간연장일</label>
						<div class="search_date">
							<input type="text" id="ISSUEDATE" name="ISSUEDATE" class="input" <attr:datefield  value="0"/>/>
						</div>
					</td>
				</tr>
			</table>
			</div><!-- //table_typeA 3단구조 -->  
    	</div><!-- /title_frame -->  
    </div><!-- /layer_content -->
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
