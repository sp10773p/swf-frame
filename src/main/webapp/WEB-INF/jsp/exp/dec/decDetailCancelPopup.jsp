<%--
  User: jjkhj
  Date: 2017-02-20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
        $(function () {
        	fn_setCombo(); 	//공통콤보  조회
        	
        	$('#btnCancelSave').on("click", function (e) { fn_cancelSave(); });	//취하 저장
        });
		
        function fn_setCombo(){
        	$.comm.bindCombos.addComboInfo("AMENDTYPECD" 			, "CUS0032", true, null, null, null, 3);	//취하사유코드(수출취하사유)
        	$.comm.bindCombos.addComboInfo("OBLIGATIONREASONCD" 	, "CUS0028", true, null, null, null, 3);	//귀책사유코드
        	
        	$.comm.bindCombos.draw();
        }
        
      	//취하저장
      	function fn_cancelSave(){      		
      		var params = openerFormData("detailForm");
      		params["MODI_DIVI"] = $("#AMENDTYPECD").val();
      		params["MODI_COT"] = $("#AMENDREASON").val();
      		params["DUTY_CODE"] = $("#OBLIGATIONREASONCD").val();
      		params["SEND_DIVI"] = "B";	//신청구분(A:정정, B:신고취하, C:기간연장)
      		
      		if(fn_modChkCnt(params) != "0"){
      			if(fn_modChkRece(params) != "05" && fn_modChkRece(params) != "07"){
         			alert("수출취하 진행중입니다");
         			return;
         		}
     		}
      		
      		if(!fn_validate()){
      			return;
      		}
      		
      		if(!confirm($.comm.getMessage("C00000036"))){ // 신청 하시겠습니까?
                return;
            }
 
      		$.comm.send("/dec/saveExpDecCancel.do", params, fn_callback, "수출신고 취하");
      		
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
   			if($.comm.isNull($('#AMENDTYPECD').val())){
   				alert($.comm.getMessage("W00000046", "취하사유코드")); // 취하사유코드를 선택하세요.
   				return false;
   			}
			if($.comm.isNull($('#AMENDREASON').val())){
				alert($.comm.getMessage("W00000004", "취하사유")); // 취하사유를 입력하세요.
				return false;
			} 
			if($.comm.isNull($('#OBLIGATIONREASONCD').val())){
				alert($.comm.getMessage("W00000046", "귀책사유코드")); // 귀책사유코드를 선택하세요.
				return false;
			}
      		
      		return true;
      	}
      	
     	// 수출취하 요청확인
     	 function fn_modChkCnt(params){
	    	var cnt = "";
	    	params["qKey"] = "mod.selectExpCusDmrChkCnt";
	        var modInfo = $.comm.sendSync("/common/select.do", params, "수출정정 진행확인 조회_count").data;
	        cnt = modInfo.CNT;
	        return cnt;
	    }
     	
     	// 수출취하 요청확인
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
       <h1>취하사유</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
		<a href="#" class="title_frame_btn" id="btnCancelSave">신청</a>
	</div>
    <div class="layer_content" style="overflow: hidden;">
        <div class="title_frame">
		    <p>수출신고에 대한 취하 요청하시려면 아래 항목을 입력하세요.</p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">수출취하</caption>
				<colgroup>
					<col width="20%" />
                   	<col width="*" />
				</colgroup>
				<tr>
					<td>취하사유코드</td>
					<td>
						<label for="AMENDTYPECD" style="display: none;">취하사유코드</label>
						<select id="AMENDTYPECD" name="AMENDTYPECD"></select>
					</td>
				</tr>
				<tr>
					<td>취하사유</td>
					<td>
						<label for="AMENDREASON" style="display: none;">취하사유</label>
						<textarea id="AMENDREASON" name="AMENDREASON" style="width:100%; min-height:170px; border:none;"></textarea>
					</td>
				</tr>
				<tr>
					<td>귀책사유코드</td>
					<td>
						<label for="OBLIGATIONREASONCD" style="display: none;">귀책사유코드</label>
						<select id="OBLIGATIONREASONCD" name="OBLIGATIONREASONCD"></select>
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
