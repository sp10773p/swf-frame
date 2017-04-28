<%--
    Class Name : join03.jsp
    Description : 회원정보 입력
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-23  정안균   최초 생성

    author : 정안균
    since : 2017-02-23
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/base.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/sub.css'/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/main.css'/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/layerPop.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/nicescroll.css'/>" />

	<script src="<c:url value='/js/jquery.min.js'/>"></script>
	<script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
	<script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/main.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/swiper.jquery.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/TweenMax.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/popup.js'/>" charset="utf-8"></script>

	<style>
		.gray .auto_btn{float:left;margin-left:0;padding-top: 4px;height:24px;} /*테이블 내부 자동사이즈 버튼*/
		#btnIdChk{padding-top: 4px !important}
	</style>

	<script>
		var emailAuthKey = '';
	    $(function () {
	    	//아이디 중복체크
	        $('#btnIdChk').on('click', function(event) {
	        	if($('#USER_ID').val() === '') {
            		alert("아이디를 입력해 주십시오.");
	                $('#USER_ID').focus();
	                return false;
	            }
	        	
		        var param = {
	                "USER_ID" : $('#USER_ID').val(),
	                "ACTION_MENU_ID" : "join03",
                    "ACTION_MENU_NM" : "회원정보 입력"
	            };
	            var callback = function(data, status){
	               	var result = data.data;
	                if(result && result["USER_ID"]) {
	                	alert("이미 사용중인 아이디 입니다.");
	                	 return false;
	                } else {
	                	alert("사용가능합니다.");
	                	$("#ID_CHK").val("Y");
	                }
	                       	
	            };
	        	$.comm.send("/mem/idFnd.do", param, callback, "아이디 중복 체크");
		    });
	  
	      	//뒤로 버튼
	        $('#btnBack').on('click', function(event) {
	        	history.back();
	        	return false;
		    });
	        
	     	// 다음 화면으로 이동
            $('#btnNext').on("click", function (e) {
            	if(!mandCheck()) return false;
            	
            	var frm = new JForm();
	        	frm.add(new JCustom(function() {
	        		
	        		if("${userDiv}" == 'S') {
	        			if($('#TG_NO').val() == '') {
	        				alert($.comm.getMessage("W00000004", "통관고유부호")); // 통관고유부호를 입력하십시오.
			        		return false;
	        			} else {
		                	var param = {
		                    	"qKey"  : "mem.selectTgNoCnt",
		                        "TG_NO" : $('#TG_NO').val()
		                    };

		        			var resutData = $.comm.sendSync("/common/selectNonSession.do", param, "통관고유부호 COUNT 조회").data;
		        			if(resutData) {
		        				var cnt = parseInt(resutData.CNT);
		        				if(cnt > 0) {
		        					alert($.comm.getMessage("W00000077", "통관고유부호")); // 중복된 통관고유부호가 존재합니다.
		        					return false;
		                       	}
		        			}
		        			
	        				frm.add(new JLength("통관고유부호", "TG_NO", "15,15"))
	        				
	        				var regEx = /^([가-힣]{2}[*]{4}|[가-힣]{3}[*]{2}|[가-힣]{4})([a-zA-Z0-9]{7})/gi;
	        				if(!regEx.test($('#TG_NO').val())) {
	        					alert("유효하지 않은 통관고유부호입니다.\n예)통관부호1234567, 통관****1234567, 무역업**1234567");
	        					return false;
	        				}
	        				
	        			}
	        		}
	        		
	        		if("${userDiv}" == 'S' || "${userDiv}" == 'G') {
	        			if($('#APPLICANT_ID').val() == '') {
	        				alert($.comm.getMessage("W00000004", "신고인부호")); // 신고인부호를 입력하십시오.
			        		return false;
	        			} else {
	        				if($('#APPLICANT_ID').val().length > 5) {
				        		alert($.comm.getMessage("W00000006", "신고인부호")); // 신고인부호의 글자수가 최대 글자수를 초과 하였습니다.
				        		$('#APPLICANT_ID').focus();
				        		return false;
	        				}
		            		
		                	var param = {
		                    	"qKey"  : "mem.selectApplicantIdCnt",
		                        "APPLICANT_ID" : $('#APPLICANT_ID').val()
		                    };

		        			var resutData = $.comm.sendSync("/common/selectNonSession.do", param, "신고인부호 COUNT 조회").data;
		        			if(resutData) {
		        				var cnt = parseInt(resutData.CNT);
		        				if(cnt > 0) {
		        					alert($.comm.getMessage("W00000077", "신고인부호")); // 중복된 신고인부호가 존재합니다.
		        					return false;
		                       	}
		        			}
	        			}
	        		}
	        		
	        		var idChek = $('#ID_CHK').val();
		        	if(idChek != 'Y') {
		        		alert("아이디 중복을 체크해 주세요.");
		        		return false;
		        	}
		        	
		        	if(!fn_checkPassWord($('#USER_PW').val())) return false;
		        	
		        	if($('#USER_PW').val() != $('#USER_PW2').val()) {
		        		alert("비밀번호와 비밀번호 재입력 번호가 맞지 않습니다.");
		        		return false;
		        	}
		        	
		        	if($('#EMAIL_CHECK').val() != 'Y' || $('#EMAIL_CERT').val() != 'Y') {
		        		alert("이메일 인증이 필요합니다.");
		        		return false;
		        	}
		        	
		        	return true;
	        	}));
	        	frm.add(new JEmail('EMAIL'));
	        	frm.add(new JEmail('EMAIL'));
	        	if(!frm.validate()) return;
	        	
            	var data = $.comm.getFormData("frm");
             	$.comm.forward("home/mem/join04", data);
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
		        $.comm.send("/mem/saveEmailAuth.do", param,
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
		        $.comm.send("/mem/selectEmailAuth.do", param,
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
	        	var spec = "windowname:joinBtnZipSearch;width:800px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
	            // 모달 호츨
	        	$.comm.setModalArguments({"TARGET" : "NON"}); // 모달 팝업에 전달할 인자 지정
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
	      	
	        // 숫자만 입력 가능
	        $('#TEL_NO2, #TEL_NO3, #HP_NO2, #HP_NO3').on("keyup", function() {
	        	 $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
	        });

            //영문 + 숫자 + 띄어쓰기 
	        $('#USER_ID, #CO_NM_ENG, #REP_NM_ENG').on("keyup", function() {
	            $(this).val( $(this).val().replace(/[^0-9a-zA-Z\s]/gi,"") );
	        });
	    });
	    
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
	    
        function mandCheck() {
        	var frm = new JForm();
            var mandSelector = ["USER_ID", "USER_PW", "USER_PW2", "USER_NM", "CO_NM_ENG", "REP_NM", "REP_NM_ENG", "CHARGE_NM", "HP_NO1", 
                                 "HP_NO2", "HP_NO3", "EMAIL", "ZIP_CD", "ADDRESS"
                               ];
            $.each(mandSelector, function(idx, id){
                var name = "";
                if($("label[for='"+id+"']")){
                    name = $("label[for='"+id+"']").html();
                }

                //Title이 없으면 체크안함
                if(!$.comm.isNull(name)){
                    var e = $("#" + id);
                    if(e.get(0).tagName.toLowerCase() == 'input'){

                        if(e.attr('type').toLowerCase() == 'text'){
                            frm.add(new JText(name, id));
                        }
                    }else if(e.get(0).tagName.toLowerCase() == 'select'){
                        frm.add(new JSelect(name, id));
                    }
                }
            });

            var selector;
			var formId = "frm";
            if($.comm.isNull(formId)){
                selector = $("*[maxlength]");
            }else{
                selector = $('#'+formId).find("*[maxlength]");
            }
            selector.each(function(idx, obj){
                var id = $(obj).get(0).id;

                var name = "";
                if($("label[for='"+id+"']")){
                    name = $("label[for='"+id+"']").html();
                }

                //Title이 없으면 체크안함
                if(!$.comm.isNull(name)){
                    var e = $(obj);
                    if(e.get(0).tagName.toLowerCase() == 'textarea' ||
                        (e.get(0).tagName.toLowerCase() == 'input' && e.attr('type').toLowerCase() == 'text')){
                        var len = $('#' + id).attr("maxlength");
                        if(id == "USER_ID") {
                        	len = "8,35";
                        } else if(id == "USER_PW" || id == "USER_PW2") {
                        	len = "10,20";
                        }
                        frm.add(new JLength(name, id, len));
                    }
                }
            });

            return frm.validate();
        }
	</script>
</head>

<body>
<div id="wrap">
	<%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>

	<div id="container">
		<!-- content -->
		<div id="content" style="height: 800px; border-top: 1px solid;">
			<div class="inner-box bg_sky" style="margin: auto">
				<form id="frm" name="frm" method="post">
					<div class="padding_box">
						<div class="bg_frame_content" style="margin: auto">
							<div class="join_step">
								<img src="/images/join_step03.png" alt="회원정보 입력 단계">
							</div>
							<div class="white_frame" style="max-width: 1200px;margin: auto;">
								<p style="margin-bottom: 5px;"><span style="color: #15a4fa;">*</span> 필수 입력 사항 입니다.</p>
								<div class="table_typeA gray">
									<table>
										<caption class="blind">필수 입력 사항</caption>
										<colgroup>
											<col width="132px">
											<col width="*">
											<col width="132px">
											<col width="*">
										</colgroup>
										<tbody>
											<tr>
												<td><label for="USER_DIV">작성자</label> <span>*</span></td>
												<td>
													<c:choose>
														<c:when test="${userDiv eq 'S'}">
															<div class="radio">
																<input type="radio" checked="checked" id="userDiv1">
																<label for="userDiv1"><span></span>셀러(신고인)</label>
															</div>
														</c:when>
														<c:when test="${userDiv eq 'M'}">
															<div class="radio">
																<input type="radio" checked="checked" id="userDiv2">
																<label for="userDiv2"><span></span>몰관리자</label>
															</div>
														</c:when>
														<c:when test="${userDiv eq 'G'}">
															<div class="radio">
																<input type="radio" checked="checked" id="userDiv3">
																<label for="userDiv3"><span></span>관세사</label>
															</div>
														</c:when>
														<c:when test="${userDiv eq 'E'}">
															<div class="radio">
																<input type="radio" checked="checked" id="userDiv4">
																<label for="userDiv4"><span></span>특송사</label>
															</div>
														</c:when>
													</c:choose>
													<input type="hidden" name="USER_DIV" id="USER_DIV" value="${userDiv}" />
												</td>
												<td><label for="BIZ_NO">사업자등록번호</label> <span>*</span></td>
												<td>${bizNo} <input type="hidden" name="BIZ_NO" id="BIZ_NO" value="${bizNo}" /></td>
											</tr>
											<tr>
												<td><label for="USER_ID">아이디</label> <span>*</span></td>
												<td colspan="3">
													<input type="text" class="td_input td_input_btn_harf" name="USER_ID" id="USER_ID" maxlength="35" placeholder="영문자, 숫자만 가능 (8~35자리)">
													<a href="#중복확인" class="td_recheck" id="btnIdChk">중복확인</a>
													<input type="hidden" id="ID_CHK" value="N" />
												</td>
											</tr>
											<tr>
												<td><label for="USER_PW">비밀번호</label> <span>*</span></td>
												<td>
													<input type="password" class="td_input td_input" name="USER_PW" id="USER_PW" maxlength="20" placeholder="영문 + 숫자 + 특수문자 + 대문자 포함 혼용 (10~20자리)">
												</td>
												<td><label for="USER_PW2">비밀번호 재입력</label> <span>*</span></td>
												<td>
													<input type="password" class="td_input td_input" name="USER_PW2" id="USER_PW2" maxlength="20">
												</td>
											</tr>
											<tr>
												<td><label for="USER_NM">업체명</label> <span>*</span></td>
												<td>
													<input type="text" class="td_input td_input" name="USER_NM" id="USER_NM" maxlength="60" >
												</td>
												<td><label for="CO_NM_ENG">업체 영문명</label> <span>*</span></td>
												<td>
													<input type="text" class="td_input td_input" name="CO_NM_ENG" id="CO_NM_ENG" maxlength="50">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="table_typeA gray">
									<table>
										<caption class="blind">필수 입력 사항</caption>
										<colgroup>
											<col width="132px">
											<col width="*">
											<col width="132px">
											<col width="*">
										</colgroup>
										<tbody>
											<tr>
												<td><label for="REP_NM">대표자명</label> <span>*</span></td>
												<td>
													<input type="text" class="td_input" name="REP_NM" id="REP_NM" maxlength="12">
												</td>
												<td><label for="REP_NM_ENG">대표자 영문명</label><span>*</span></td>
												<td>
													<input type="text" class="td_input" name="REP_NM_ENG" id="REP_NM_ENG" maxlength="50">
												</td>
											</tr>
											<tr>
												<td><label for="CHARGE_NM">담당자명</label> <span>*</span></td>
												<td>
													<input type="text" class="td_input" name="CHARGE_NM" id="CHARGE_NM" maxlength="10">
												</td>
												<td><label for="DEPT">부서/직위</label><label for="POS" style="display: none">직위</label></td>
												<td>
													<input type="text" class="td_input td_input_harf" name="DEPT" id="DEPT" maxlength="20">
													<span>/</span>
													<input type="text" class="td_input td_input_harf" name="POS" id="POS" maxlength="20">
												</td>
											</tr>
											<tr>
												<td><label for="TEL_NO1">연락처</label><label for="TEL_NO2" style="display: none">연락처</label>
													<label for="TEL_NO3" style="display: none">연락처</label>
												</td>
												<td class="td_input_3">
													<select name="TEL_NO1" id="TEL_NO1" class="td_input">
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
													</select>
													<span>-</span>
													<input type="text" class="td_input" name="TEL_NO2" id=TEL_NO2 maxlength="4">
													<span>-</span>
													<input type="text" class="td_input" name="TEL_NO3" id=TEL_NO3 maxlength="4">
												</td>
												<td><label for="HP_NO1">휴대폰</label> <span>*</span></td>
												<td class="td_input_3">
													<select name="HP_NO1" id="HP_NO1" class="td_input">
														<option value="010">010</option>
														<option value="011">011</option>
														<option value="016">016</option>
														<option value="017">017</option>
														<option value="018">018</option>
														<option value="019">019</option>
													</select>
													<span>-</span>
													<input type="text" class="td_input" name="HP_NO2" id="HP_NO2" maxlength="4">
													<span>-</span>
													<input type="text" class="td_input" name="HP_NO3" id="HP_NO3" maxlength="4">
												</td>
											</tr>
											<tr>
												<td><label for="EMAIL">이메일</label> <span>*</span></td>
												<td colspan="3" class="mail_input">
													<input type="text" class="td_input td_input_btn_harf" name="EMAIL" id="EMAIL" maxlength="50">
													<a href="#이메일 인증키 발송" class="auto_btn colorC" id="btnEmailCertSend">이메일 인증키 발송</a>
													<input type="text" class="td_input td_input_btn_harf" name="EMAIL_C" id="EMAIL_C" maxlength="15">
													<input type="hidden" name="EMAIL_CHECK" id="EMAIL_CHECK" value="N" />
													<a href="#이메일 인증 확인" class="auto_btn colorC" id="btnEmailCertConf">이메일 인증 확인</a>
													<input type="hidden" name="EMAIL_CERT" id="EMAIL_CERT" value="N"  />
												</td>
											</tr>
											<tr>
												<td><label for="ZIP_CD">우편번호</label> <span>*</span></td>
												<td colspan="3">
													<input type="text" class="td_input td_input_btn_harf" name="ZIP_CD" id="ZIP_CD" maxlength="5">
													<a href="#우편번호 검색" class="auto_btn colorC" id="btnZipSearch">우편번호 검색</a>
												</td>
											</tr>
											<tr>
												<td><label for="ADDRESS" style="display: none">상세주소</label> <label for="ADDRESS2">상세주소</label> <span>*</span></td>
												<td colspan="3" class="adress_input">
													<input type="text" class="td_input td_input_harf readonly" name="ADDRESS" id="ADDRESS">
													<input type="text" class="td_input td_input_harf" name="ADDRESS2" id="ADDRESS2" maxlength="100">
												</td>
											</tr>
											<tr>
												<td><label for="ADDRESS_EN">영문주소</label></td>
												<td colspan="3">
													<input type="text" class="td_input" name="ADDRESS_EN" id="ADDRESS_EN" maxlength="100">
												</td>
											</tr>
											<tr>
												<td><label for="TG_NO">통관고유부호</label> <c:if test="${userDiv eq 'S'}"><span>*</span></c:if></td>
												<td>
													<input type="text" class="td_input" name="TG_NO" id="TG_NO" maxlength="15">
												</td>
												<td><label for="APPLICANT_ID">신고인부호</label> <c:if test="${userDiv eq 'S' || userDiv eq 'G'}"><span>*</span></c:if></td>
												<td>
													<input type="text" class="td_input" name="APPLICANT_ID" id="APPLICANT_ID" maxlength="5">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="btn_area btn_3 clearfix">
								<a href="#이전" class="b_btn dkgray_btn" id="btnBack">이전</a>
								<a href="#다음" class="b_btn blue_btn" id="btnNext">다음</a>
								<a href="<c:out value='/' />" class="b_btn gray_btn">취소</a>
							</div>
						</div>

					</div>
				</form>
				<!-- //padding_box -->
			</div>
			<!-- //inner-box -->
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/main/include-main-footer.jsp" %>
</div>
<form id="commonForm" name="commonForm"></form>	
<div class="dim_laoding">
    <div class="dim_inner">
        <a href="#" id="loading" onclick="gfn_closeDimLoading()"><div class="cssload-loading"><i></i><i></i><i></i><i></i></div></a>
    </div>
</div>
</body>
</html>
