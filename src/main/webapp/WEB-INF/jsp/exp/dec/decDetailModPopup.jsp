<%--
    Class Name : decDetailModPopup.jsp
    Description : 수출정정 팝업
    Modification Information
        수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.02.20  김회재   최초 생성
    author : 김회재
    since : 2017.02.20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
        $(function () {
        	fn_setCombo(); 	//공통콤보  조회
        	
        	 $('#btnModSave').on("click", function (e) { fn_modSave(); });	//취하 저장
        });
		
        function fn_setCombo(){
        	$.comm.bindCombos.addComboInfo("MOD_CD" 				, "CUS0029", true, null, null, null, 3);	//정정사유코드
        	$.comm.bindCombos.addComboInfo("MOD_OBL_REASONCD" 		, "CUS0028", true, null, null, null, 3);	//귀책사유코드
        	
        	$.comm.bindCombos.draw();
        }
        
      	//정정저장
      	function fn_modSave(){
      		var params = openerFormData("detailForm");
      		params["MODI_DIVI"] = $("#MOD_CD").val();
      		params["MODI_COT"] = $("#MOD_REASON").val();
      		params["DUTY_CODE"] = $("#MOD_OBL_REASONCD").val();
      		params["SEND_DIVI"] = "A";	//신청구분(A:정정, B:신고취하, C:기간연장)
      		
      		if(fn_modChkCnt(params) != "0"){
      			if(fn_modChkRece(params) != "05" && fn_modChkRece(params) != "07"){
         			alert($.comm.getMessage("W00000073")); //수출정정 진행중입니다.
         			return;
         		}
     		}
      		
      		if(!fn_validate()){
      			return;
      		}
      		
      		if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                return;
            }
 
      		
      		$.comm.send("/dec/saveExpDecMod.do", params, fn_callback, "수출신고 정정");
      		
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
      		params["MODI_SEQ"] = data.data.MODI_SEQ;
      		params["SEND_DIVI"] = data.data.SEND_DIVI;
      		params["CALL_TYPE"] = "MOD_POP";
      		$.comm.setModalReturnVal(params);
            close();
        }
      	
      	function fn_validate(){
   			if($.comm.isNull($('#MOD_CD').val())){
   				alert($.comm.getMessage("W00000046", "정정사유코드")); // 정정사유코드를 선택하세요.
   				return false;
   			}
			if($.comm.isNull($('#MOD_REASON').val())){
				alert($.comm.getMessage("W00000004", "정정사유")); // 정정사유를 입력하세요.
				return false;
			} 
			if($.comm.isNull($('#MOD_OBL_REASONCD').val())){
				alert($.comm.getMessage("W00000046", "귀책사유코드")); // 귀책사유코드를 선택하세요.
				return false;
			} 
      		
      		return true;
      	}
      	
     	// 수출정정 요청확인(건수)
    	 function fn_modChkCnt(params){
	    	var cnt = "";
	    	params["qKey"] = "mod.selectExpCusDmrChkCnt";
	        var modInfo = $.comm.sendSync("/common/select.do", params, "수출정정 진행확인 조회_count").data;
	        cnt = modInfo.CNT;
	        return cnt;
	    }
    	
    	// 수출정정 요청확인(상태)
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
       <h1>정정사유</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
		<a href="#" class="title_frame_btn" id="btnModSave">저장</a>
	</div>
    <div class="layer_content" style="overflow: hidden;">
        <div class="title_frame">
		    <p>수출신고에 대한 정정 요청하시려면 아래 항목을 입력하세요.</p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">수출정정</caption>
				<colgroup>
					<col width="20%" />
                   	<col width="*" />
				</colgroup>
				<tr>
					<td>정정사유코드</td>
					<td>
						<label for="MOD_CD" style="display: none;">정정사유코드</label>
						<select id="MOD_CD" name="MOD_CD"></select>
					</td>
				</tr>
				<tr>
					<td>정정사유</td>
					<td>
						<label for="MOD_REASON" style="display: none;">정정사유</label>
						<textarea id="MOD_REASON" name="MOD_REASON" style="width:100%; min-height:170px; border:none;"></textarea>
					</td>
				</tr>
				<tr>
					<td>귀책사유코드</td>
					<td>
						<label for="MOD_OBL_REASONCD" style="display: none;">귀책사유코드</label>
						<select id="MOD_OBL_REASONCD" name="MOD_OBL_REASONCD"></select>
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
