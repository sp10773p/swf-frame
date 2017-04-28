<%--
    Class Name : profWrite.jsp
    Description : 회원 관리
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.07  정안균   최초 생성

    author : 정안균
    since : 2017.03.07
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <c:set var="userDiv" value="${session.getUserDiv()}" />
    <s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>
    <script type="text/javascript" src="<c:url value='/js/jquery.leanModal.min.js'/>"></script>
    <script>
    	var fileUtil;
        $(function (){
            fn_select(); 
            
         	// 첨부파일 정의
            fileUtil = new FileUtil({
                "addBtnId"        : "btnUpload",      // 파일 업로드 버튼 ID
                "downBtnId"       : "btnDownload",    // 파일 다운로드 버튼 ID
                "extNames"     	  : ["jpg", "gif", "png", "jpeg", "bmp", "tif", "pdf"],
                "successCallback" : fn_uploadCallback,
                "postService"     : "profService.updateCmmFileAttchId",
            });
         	
    	  	//이메일 인증번호 발송
            $('#btnEmailCertSend').on('click', function(event) {
            	var frm = new JForm();
            	frm.add(new JCustom(function() {
    	        	if($('#EMAIL').val() == '') {
    	        		alert($.comm.getMessage("W00000004", "이메일")); // 이메일을(를) 입력하십시오.
    	        		 $('#EMAIL').focus();
    	        		return false;
    	        	}
    	        	return true;
            	}));
            	frm.add(new JEmail('EMAIL'));
            	if(!frm.validate()) return;
            	var param = {"EMAIL":$('#EMAIL').val()};
    	        $.comm.send("/prof/saveEmailAuth.do", param,
    	                function(data, status){
    	        			var data = data.data;
    	        			if(data["AUTHENTICATION_KEY"]) {
    	        				emailAuthKey = data["AUTHENTICATION_KEY"];
    	        				$('#EMAIL_CHECK').val("Y");
    	        			}
    	                }
    	        );
    	    });
          	
          	//이메일 인증번호 확인
            $('#btnEmailCertConf').on('click', function(event) {
            	var frm = new JForm();
            	frm.add(new JCustom(function() {
    	        	if($('#EMAIL_CHECK').val() != 'Y') {
    	        		alert($.comm.getMessage("W00000048", "이메일 인증키 발송")); // 이메일 인증키 발송을(를) 먼저 해주십시오.
    	        		return false;
    	        	}
    	        	return true;
            	}));
            	if(!frm.validate()) return;
            	var param = {"EMAIL":$('#EMAIL').val()};
            	$.comm.wait(true);
    	        $.comm.send("/prof/selectEmailAuth.do", param,
    	                function(data, status){
    	        			$.comm.wait(false);
    	        			var data = data.data;
    	        			if(!data || !data["DIFF"] || parseInt(data["DIFF"]) > 300) {
    	        				alert($.comm.getMessage("W00000049")); // 인증 시간이 만료 되었습니다.
    	        			} else {
    	        				if(emailAuthKey == $('#EMAIL_C').val()) {
    	        					$('#EMAIL_CERT').val("Y");
    	        					alert($.comm.getMessage("I00000033")); // 인증이 완료되었습니다.;
    	        				} else {
    	        					alert($.comm.getMessage("W00000050", '인증키')); // 인증키를 확인해 주십시오
    	        				}
    	        			}
    	                }
    	        );
    	    });
          	
          	//우편번호 검색
            $('#btnZipSearch').on('click', function(event) {
            	var spec = "windowname:profBtnZipSearch;width:800px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
                // 모달 호츨
                $.comm.dialog("<c:out value='/jspView.do?jsp=cmm/popup/zipPopup' />", spec,
                    function () { // 리턴받을 callback 함수
                        var ret = $.comm.getModalReturnVal();
                        if (ret) {
                        	$('#ZIP_CD').val(ret.ZIP_CD);   // 우편번호
                            $('#ADDRESS').val(ret.NAME_KR); // 주소 
                        }
                    }
                );
    	    });
          	
            //저장
	        $('#btnSave').on('click', function(event) {
	        	var frm = new JForm();
	        	frm.add(new JCustom(function() {
		        
					if(!fn_checkPassWord($('#USER_PW').val())) return false;
		        	
		        	if($('#USER_PW').val() != $('#USER_PW2').val()) {
		        		alert("비밀번호와 비밀번호 재입력 번호가 맞지 않습니다.");
		        		return false;
		        	}
		        	
		        	if($('#EMAIL_CHECK').val() != 'Y' || $('#EMAIL_CERT').val() != 'Y') {
		        		alert("이메일 인증이 필요합니다.");
		        		return false;
		        	}
		        	
		        	if($('#ATCH_FILE_ID').val() == '') {
		        		alert("사업자등록증 사본을 첨부해 주세요.");
		        		return false;
		        	}     
		        	 
	            	if($('#UTH_USER_ID').val()) {
		         		var param = {"USER_ID" : $('#UTH_USER_ID').val(), "BIZ_NO": $('#BIZ_NO').html()};

						var resutData = $.comm.sendSync("/prof/selectUthUsr.do", param, "uTradeHub 아이디 존재 확인").data;
						if(!resutData || !resutData["USER_ID"]) {
							alert("입력하신 uTradeHub 아이디는 존재하지 않은 아이디 입니다.");
							return false;
						}
	            	}
	            	
	            	if("${userDiv}" == 'S') {
	        			if($('#TG_NO').val() == '') {
	        				alert($.comm.getMessage("W00000004", "통관고유부호")); // 통관고유부호를 입력하십시오.
			        		return false;
	        			}
	            		
	                	var param = {
	                    	"qKey"  : "mem.selectTgNoCnt",
	                        "TG_NO" : $('#TG_NO').val()
	                    };

	        			var resutData = $.comm.sendSync("/common/select.do", param, "통관고유부호 COUNT 조회").data;
	        			if(resutData) {
	        				var cnt = parseInt(resutData.CNT);
	        				if(cnt > 0) {
	        					alert($.comm.getMessage("W00000077", "통관고유부호")); // 중복된 통관고유부호가 존재합니다.
	        					return false;
	                       	}
	        			}
	        		}
	            	
	            	if(!$('#TG_NO').val() == '') {
	            		frm.add(new JLength("통관고유부호", "TG_NO", "15,15"))
	            		var regEx = /^([가-힣]{2}[*]{4}|[가-힣]{3}[*]{2}|[가-힣]{4})([a-zA-Z0-9]{7})/gi;
	        			if(!regEx.test($('#TG_NO').val())) {
	        				alert("유효하지 않은 통관고유부호입니다.\n예)통관부호1234567, 통관****1234567, 무역업**1234567");
	        				return false;
	        			}
	            	}
	        		
	        		if("${userDiv}" == 'S' || "${userDiv}" == 'G') {
	        			if($('#APPLICANT_ID').val() == '') {
	        				alert($.comm.getMessage("W00000004", "신고인부호")); // 신고인부호를 입력하십시오.
			        		return false;
	        			}
	            		
	                	var param = {
	                    	"qKey"  : "mem.selectApplicantIdCnt",
	                        "APPLICANT_ID" : $('#APPLICANT_ID').val()
	                    };

	        			var resutData = $.comm.sendSync("/common/select.do", param, "신고인부호 COUNT 조회").data;
	        			if(resutData) {
	        				var cnt = parseInt(resutData.CNT);
	        				if(cnt > 0) {
	        					alert($.comm.getMessage("W00000077", "신고인부호")); // 중복된 신고인부호가 존재합니다.
	        					return false;
	                       	}
	        			}
	        		}
	        		
		        	return true;
	        	}));
	        	frm.add(new JEmail('EMAIL'));
	        	if(!frm.validate()) return;
	        	
	        	if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                    return;
                }
	        	
	        	$.comm.sendForm("/prof/saveUserInfo.do", "detailForm", fn_callback, "회원정보 저장");
	
		    });
		    
		     //탈퇴요청
	        $('#btnWithdrawSave').on('click', function(event) {
	        	var frm = new JForm();
	        	frm.add(new JCustom(function() {
		        	if($('#WITHDRAW_REASON').val() == '') {
		        		alert($.comm.getMessage("W00000004"), "탈퇴사유"); //탈퇴사유을(를) 입력하십시오.
		        		return false;
		        	}
		        	return true;
	        	}));
	        	if(!frm.validate()) return;
	        	
	        	if(!confirm($.comm.getMessage("C00000016"))){ // 탈퇴요청 하시겠습니까?
                    return;
                }
	        	var param = {"WITHDRAW_REASON": $("#WITHDRAW_REASON").val()}
                $.comm.send("/prof/saveUserWithdraw.do", param, fn_withdrawCallback, "사용자 탈퇴 저장");
	
		    });
		     
	        //uTradeHub 아이디 사용여부 체크
	        $('#btnUthIdChk').on('click', function(event) {
	        	if($('#UTH_USER_ID').val() === '') {
            		alert("uTradeHub 아이디를 입력해 주십시오.");
	                $('#UTH_USER_ID').focus();
	                return false;
	            }
	        	
		        var param = {
	                "USER_ID" : $('#UTH_USER_ID').val(),
	                "BIZ_NO" : $('#BIZ_NO').html()
	            };
	            var callback = function(data, status){
	               	var result = data.data;
	                if(result && result["USER_ID"]) {
	                	alert("확인되었습니다.");
	                } else {
	                	alert("uTradeHub에 존재하지 않은 아이디 입니다. 다시 입력하세요.");
	                	$('#UTH_USER_ID').val('');
	                }
	                       	
	            };
	        	$.comm.send("/prof/selectUthUsr.do", param, callback, "uTradeHub 아이디 존재 확인");
		    });
		    
		    $("#btnWithdraw").leanModal({ top : 130, overlay : 0.8, closeButton : ".hidemodal" }); 		//탈퇴 Modal
          	
            
         });	
        
     	// 업로드 callback
        function fn_uploadCallback(){
        	fn_select();
        }

        var fn_callback = function (data) {
        	if(data) {
        		fn_select();
        	}
        }
        
        var fn_withdrawCallback = function (data) {
        	if(data) {
        		parent.$.comm.logout('<c:out value="${logoutUrl}" />');
        	}
        }
        
        function fn_checkPassWord(str){
			var pw = str;
			var num = pw.search(/[0-9]/g);
			var eng = pw.search(/[a-z]/g);
			var eng2 = pw.search(/[A-Z]/g);
			var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
			
			if(pw.length < 10 || pw.length > 20){
		  		alert("비밀번호는 10자리 ~ 20자리 이내로 입력해주세요.");	
		  		return false;
			}
		 	if(pw.search(/₩s/) != -1){
		  		alert("비밀번호는 공백없이 입력해주세요.");
		  		return false;
		 	} 
		 	if(num < 0 || eng < 0 || spe < 0 || eng2 < 0 ){
		  		alert("비밀번호는 영문, 영문 대문자, 숫자, 특수문자를 혼합하여 입력해주세요.");
		  		return false;
		 	}
		 	return true;	
		}
        
        // 조회
        function fn_select(){
        	$.comm.send("/prof/selectUsr.do", {"qKey" : "prof.selectUser"},
	                function(data){
        				var data = data.data;
	                    var status = data.status;
	                    if(status == -1) return;
	                    $.comm.bindData(data);
	                    if(data && data["TEL_NO"]) {
	                    	var telNo = data["TEL_NO"];
	                    	var phone_num = telNo.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
	                    	var arrTelNo = phone_num.split("-");
	                    	$('#TEL_NO1').val(arrTelNo[0]);
	                    	$('#TEL_NO2').val(arrTelNo[1])
	                    	$('#TEL_NO3').val(arrTelNo[2])
	                    }
	                    
	                    if(data && data["HP_NO"]) {
	                    	var telNo = data["HP_NO"];
	                    	var phone_num = telNo.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
	                    	var arrTelNo = phone_num.split("-");
	                    	$('#HP_NO1').val(arrTelNo[0]);
	                    	$('#HP_NO2').val(arrTelNo[1])
	                    	$('#HP_NO3').val(arrTelNo[2])
	                    }
	
	                },
	                "회원정보 조회"
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
	                <a href="#withdraw_layer_popup" class="title_frame_btn" id="btnWithdraw">탈퇴</a>
	                <a href="#" class="title_frame_btn" id="btnSave">저장</a>
                </div>
            </div>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">회원정보</caption>
	                <colgroup>
	                    <col width="132px">
						<col width="*">
						<col width="132px">
						<col width="*">
	                </colgroup>
	                <tr>
	                    <td><label for="USER_DIV_NM">구분</label></td>
	                    <td><span id="USER_DIV_NM"></span></td>
	                    <td><label for="USER_ID">아이디</label></td>
	                    <td><span id="USER_ID"></span></td>
	                </tr>
	                <tr>
	                    <td><label for="USER_PW">비밀번호</label></td>
	                    <td colspan="3"><input type="text" name="USER_PW" id="USER_PW" <attr:mandantory/> <attr:length value='10,20'/> class="td_input" style="width: 30% !important"> 영문자+숫자+특수문자+대문자 포함 혼용 (10~20자리)</td>
	                </tr>
	                <tr>
	                    <td><label for="USER_PW2">비밀번호 재입력</label></td>
	                    <td colspan="3"><input type="text" name="USER_PW2" id="USER_PW2" <attr:mandantory/> <attr:length value='10,20'/> class="td_input" style="width: 30% !important"></td>
	                </tr>
	                <tr>
	                    <td><label for="USER_NM">업체명</label></td>
	                    <td colspan="3"><span id="USER_NM"></span></td>
	                </tr>
	                <tr>
	                    <td><label for="CO_NM_ENG">업체 영문명</label></td>
	                    <td colspan="3"><span id="CO_NM_ENG"></span></td>
	                </tr>
	                <tr>
	                    <td><label for="REP_NM">대표자명</label></td>
	                    <td colspan="3"><span id="REP_NM"></span></td>
	                </tr>
	                <tr>
	                    <td><label for="REP_NM_ENG">대표자 영문명</label></td>
	                    <td colspan="3"><span id="REP_NM_ENG"></span></td>
	                </tr>
	                <tr>
	                    <td><label for="BIZ_NO">사업자등록번호</label></td>
	                    <td><span id="BIZ_NO"></span></td>
	                    <td><label for="CHARGE_NM">담당자명</label></td>
	                    <td><input type="text" name="CHARGE_NM" id="CHARGE_NM" <attr:mandantory/> <attr:length value='10'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="DEPT">부서</label></td>
	                    <td><input type="text" name="DEPT" id="DEPT" <attr:length value='20'/> class="td_input"></td>
	                    <td><label for="POS">직위</label></td>
	                    <td><input type="text" name="POS" id="POS" <attr:length value='20'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="TEL_NO1">연락처</label><label for="TEL_NO2" style="display: none;">연락처</label><label for="TEL_NO3" style="display: none;">연락처</label></td>
	                    <td colspan="3">
	                    	<select class="td_input" name="TEL_NO1" id="TEL_NO1" style="width: 80px;">
		                   		<option value="02">02</option>
		                   		<option value="031">031</option>
		                   		<option value="032">032</option>
		                   		<option value="033">033</option>
		                   		<option value="041">041</option>
		                   		<option value="042">042</option>
		                   		<option value="043">043</option>
		                   		<option value="044">044</option>
		                   		<option value="051">051</option>
		                   		<option value="052">052</option>
		                   		<option value="053">053</option>
		                   		<option value="054">054</option>
		                   		<option value="055">055</option>
		                   		<option value="061">061</option>
		                   		<option value="062">062</option>
		                   		<option value="063">063</option>
		                   		<option value="064">064</option>
		                   		<option value="070">070</option>
		                   		<option value="010">010</option>
		                   		<option value="011">011</option>
		                   		<option value="016">016</option>
		                   		<option value="017">017</option>
		                   		<option value="018">018</option>
		                   		<option value="019">019</option>
		                  	</select>-
		                  	<input type="text" name="TEL_NO2" id=TEL_NO2 class="td_input" <attr:mandantory/> <attr:numberOnly value='true'/> <attr:length value='4'/> style="width: 10% !important;margin-left: 10px;" />-<input type="text"name="TEL_NO3" id="TEL_NO3" class="td_input" <attr:mandantory/> <attr:numberOnly value='true'/> <attr:length value='4'/> style="width: 10% !important;margin-left: 10px;" />
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="HP_NO1">휴대폰</label><label for="HP_NO2" style="display: none;">휴대폰</label><label for="HP_NO3" style="display: none;">휴대폰</label></td>
	                    <td colspan="3">
	                    	<select class="td_input" name="HP_NO1" id="HP_NO1" style="width: 80px;">
		                   		<option value="010">010</option>
		                   		<option value="011">011</option>
		                   		<option value="016">016</option>
		                   		<option value="017">017</option>
		                   		<option value="018">018</option>
		                   		<option value="019">019</option>
		                  	</select>- 
		                  	<input type="text" name="HP_NO2" id=HP_NO2 class="td_input" <attr:numberOnly value='true'/> <attr:length value='4'/> style="width: 10% !important;margin-left: 10px;" />-<input type="text"name="HP_NO3" id="HP_NO3" class="td_input" <attr:numberOnly value='true'/> <attr:length value='4'/> style="width: 10% !important;margin-left: 10px;"/>
	                    </td>
	                </tr>
	                <tr>
		                <td><label for="EMAIL">이메일</label></td>
		                <td colspan="3">
		                	<input type="text" name="EMAIL" id="EMAIL" class="td_input" <attr:mandantory/> <attr:length value='50'/>  style="width: 20% !important" /> 
		                	<a href="#" id="btnEmailCertSend" class="btn_table" style="margin-left: 0px;">이메일 인증키 발송</a>
		                	<input type="text" name="EMAIL_C" id="EMAIL_C" class="td_input" <attr:length value='15'/> style="width: 20% !important;margin-left: 10px;" />
		                	<input type="hidden" name="EMAIL_CHECK" id="EMAIL_CHECK" value="N" />
		                	<a href="#" id="btnEmailCertConf" class="btn_table" style="margin-left: 0px;">이메일 인증 확인</a>
		                	<input type="hidden" name="EMAIL_CERT" id="EMAIL_CERT" value="N"  />
		                </td>
		            </tr>
		            <tr>
		                <td><label for="ZIP_CD">우편번호</label></td>
		                <td colspan="3">
		                	<input type="text" name="ZIP_CD" id="ZIP_CD" class="td_input readonly" <attr:mandantory/> <attr:length value='5'/> readonly style="width: 20% !important" />  
		                	<a href="#" id="btnZipSearch" class="btn_table" style="margin-left: 0px;">우편번호 검색</a>
		                </td>
		            </tr>
		            <tr>
		                <td><label for="ADDRESS2">상세주소</label></td>
		                <td colspan="3"><input type="text" name="ADDRESS" id="ADDRESS" class="td_input readonly" readonly style="width: 45% !important"/> <input type="text" name="ADDRESS2" id="ADDRESS2" class="td_input" <attr:mandantory/> <attr:length value='100'/> style="width: 50% !important"/> </td>
		            </tr>
	                <tr>
		                <td><label for="ADDRESS_EN">영문주소</label>영문주소</td>
		                <td colspan="3"><input type="text" name="ADDRESS_EN" id="ADDRESS_EN" class="td_input" <attr:alphaNumber value='true'/> <attr:length value='100'/> /></td>
		            </tr>
		            <tr>
		            	<td><label for="TG_NO">통관고유부호</label><c:if test="${userDiv eq 'S'}"><span>*</span></c:if></td>
		                <td><input type="text" name="TG_NO" id="TG_NO" class="td_input" <attr:length value='15'/> /></td>
		                <td><label for="APPLICANT_ID">신고인부호</label><c:if test="${userDiv eq 'S' || userDiv eq 'G'}"><span>*</span></c:if></td>
		                <td><input type="text" name="APPLICANT_ID" id="APPLICANT_ID" class="td_input" <attr:length value='5'/> /></td>
		            </tr>
		            <tr>
	                	<td><label for="UTH_USER_ID">uTradeHub 아이디</label></td>
	                	<td colspan="3"><input type="text" name="UTH_USER_ID" id="UTH_USER_ID" class="td_input" <attr:length value='20'/> <attr:alphaNumber/> style="width: 20% !important" />
							<a href="#" id="btnUthIdChk" class="btn_table" style="margin-left: 0px;margin-right: 5px;">사용확인</a>
							* uTradeHub 전자세금계산서를 연계하여 사용하실 분은 입력 후 확인하여 주세요.
						</td>
					</tr>	
		            <tr>
	                	<td><label for="ATCH_FILE_ID">사업자등록증 사본</label></td>
		                <td colspan="3">
		                	<input type="hidden" name="ATCH_FILE_ID" id="ATCH_FILE_ID" <attr:mandantory/>/>
		                	<input type="text" name="FILE_NM" id="FILE_NM" class="td_input" style="width: 20% !important"/>
		                	<a href="#" id="btnUpload" class="btn_table" style="margin-left: 0px;">파일 업로드</a>
		                	<a href="#" id="btnDownload" class="btn_table" style="margin-left: 0px;">파일 다운로드</a>
		                </td>
		            </tr>
	            </table>
            </div>
        </div><!-- //title_frame -->
    </div>
    </form>
    
</div>

<!-- 탈퇴 팝업레이어 -->
<div id="withdraw_layer_popup" class="layerContainer" style="display: none; margin-top: -80px; width: 700px; height: 325px;">
    <div class="layerTitle">
		<h1>탈퇴사유</h1>
		<a href="#" class="hidemodal"></a>
	</div>
	<div class="layer_content">
        <div class="title_frame" style="margin-top: 5px;">
		    <div class="title_btn_frame clearfix">
				<div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btnWithdrawSave">탈퇴요청</a>
				</div>
			</div>
		    <p>탈퇴사유를 입력하세요.</p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;" >
				<caption class="blind">탈퇴사유</caption>
				<colgroup>
                   	<col width="*" />
				</colgroup>
				<tr>
					<td>
						<textarea id="WITHDRAW_REASON" name="WITHDRAW_REASON" <attr:length value='50'/> style="min-height:170px; border:none;"></textarea>
					</td>
				</tr>
			</table>
			</div><!-- //table_typeA 3단구조 -->  
    	</div><!-- /title_frame -->  
    </div><!-- /layer_content -->  
</div><!-- /layerContainer -->  

<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
