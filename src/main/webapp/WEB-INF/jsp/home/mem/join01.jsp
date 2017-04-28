<%--
    Class Name : join01.jsp
    Description : 가입여부 확인
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

	<script>
		$(function (){
			// 다음 화면으로 이동
            $('#btnNext').on("click", function (e) {
            	var isBizNo = true;
	            var bizObj = "";
	            if ($.trim($('#bizNo1').val()) === '') {
	            	isBizNo = false;
	            	bizObj = $('#bizNo1');
	            } else if($.trim($('#bizNo2').val()) === '') {
	            	isBizNo = false;
	            	bizObj = $('#bizNo2');
	            } else if($.trim($('#bizNo3').val()) === '') {
	            	isBizNo = false;
	            	bizObj = $('#bizNo3');
	            }
	            if(!isBizNo) {
	            	alert($.comm.getMessage("W00000004", "사업자등록번호")); //사업자등록번호를 입력하십시오.
	            	$(bizObj).focus();
	            	return false;
	            }
            	var bizNo = $('#bizNo1').val() + $('#bizNo2').val() + $('#bizNo3').val();
            	if(!checkBizID(bizNo)) {
            		alert($.comm.getMessage("W00000004", "정확한 사업자등록번호")); //정확한 사업자등록번호를 입력하십시오.
            		 return false;
            	}
            	
             	var param = {
                    "BIZ_NO" : bizNo,
                    "USER_DIV" : $(':radio[name="userDiv"]:checked').val(),
                    "ACTION_MENU_ID" : "join01",
                    "ACTION_MENU_NM" : "회원가입여부 확인"
                };
                var callback = function(data, status){
                   	var result = data.data;
                    if(result && result["USER_ID"]) {
                    	var usrStatus = result["USER_STATUS"] + '';
                    	if(usrStatus && usrStatus == '0') {
                    		alert($.comm.getMessage("W00000081")); //가입승인 중입니다.
                    	}else if(usrStatus == '8') {
                    		alert($.comm.getMessage("I00000043")); //탈퇴요청 중입니다.
                    	} else if(usrStatus == '9') {
                    		alert($.comm.getMessage("I00000042")); //탈퇴 상태입니다.
                    	} else {
                    		alert($.comm.getMessage("W00000076")); //이미 가입된 회원입니다.
                    	}
                   	 	return false;
                    } else {
                    	var param = {"bizNo": bizNo, "userDiv": $(':radio[name="userDiv"]:checked').val()};
                     	$.comm.forward("home/mem/join02", param);
                    }
                           	
                };
            	$.comm.send("/homeLogin/idFnd.do", param, callback, "가입된 회원인지 체크");	
            });
			
            $("#bizNo1, #bizNo2").keyup (function () {
                var maxLength = $(this).attr("maxlength");
                if (this.value.length == Number(maxLength)) {
                    $(this).nextAll("input[type=text]")[0].focus();
                    return false;
                }
            });
             
		});
		
		//사업자등록번호 체크 
		function checkBizID(bizID){ 
		    // bizID는 숫자만 10자리로 해서 문자열로 넘긴다. 
		    var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1); 
		    var tmpBizID, i, chkSum=0, c2, remander; 
		    bizID = bizID.replace(/-/gi,''); 

		    for (i=0; i<=7; i++) chkSum += checkID[i] * bizID.charAt(i); 
		    c2 = "0" + (checkID[8] * bizID.charAt(8)); 
		    c2 = c2.substring(c2.length - 2, c2.length); 
		    chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1)); 
		    remander = (10 - (chkSum % 10)) % 10 ; 

		    if (Math.floor(bizID.charAt(9)) == remander) return true ; 
		    return false; 
		} 

	</script>
</head>
<body>
<div id="wrap">
	<%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>

	<div id="container">
		<!-- content -->
		<div id="content" style="height: 720px; border-top: 1px solid;">
			<div class="inner-box bg_sky" style="margin: auto">
				<div class="padding_box">
					<div class="bg_frame_content" style="margin: auto">
						<div class="join_step">
							<img src="/images/join_step01.png" alt="가입여부 확인 단계">
						</div>
						<p class="wc_tit"><strong>전자상거래무역 서비스의 회원가입을 환영합니다.</strong><br />먼저 가입여부확인을 해주시기 바랍니다.</p>
						<div class="form_area find">
							<form action="" method="post" class="login_input">
								<fieldset class="clearfix">
									<legend class="blind">가입여부 확인</legend>
									<div class="company_num">
										<label id="bizNo">사업자등록번호</label>
										<input type="text" name="bizNo1" id="bizNo1" maxlength="3">
										<span>-</span>
										<input type="text" name="bizNo2" id="bizNo2" maxlength="2">
										<span>-</span>
										<input type="text" name="bizNo3" id="bizNo3" maxlength="5">
									</div>
									<div>
										<label>구분</label>
										<div class="radio">
											<input type="radio" name="userDiv" id="userDiv1" value="S" checked="checked"/>
											<label for="userDiv1"><span></span>셀러(신고인)</label>
										</div>
										<div class="radio">
											<input type="radio" name="userDiv" id="userDiv2" value="M" />
											<label for="userDiv2"><span></span>몰관리자</label>
										</div>
										<div class="radio">
											<input type="radio" name="userDiv" id="userDiv3" value="G" />
											<label for="userDiv3"><span></span>관세사</label>
										</div>
										<div class="radio">
											<input type="radio" name="userDiv" id="userDiv4" value="E" />
											<label for="userDiv4"><span></span>특송사</label>
										</div>
									</div>
								</fieldset>
								<div class="btn_area clearfix" style="width:285px;">
									<a href="#확인" class="b_btn blue_btn" id="btnNext">확인</a>
									<a href="<c:out value='/' />" class="b_btn gray_btn">취소</a>
								</div>
							</form>
						</div>
					</div>
				</div><!-- //padding_box -->
				<form id="commonForm" name="commonForm"></form>
			</div><!-- //inner-box -->
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/main/include-main-footer.jsp" %>
</div>
</body>
</html>
