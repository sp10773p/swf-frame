<%--
    Class Name : join04.jsp
    Description : 서비스 입력
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
	<script src="<c:url value='/js/jquery.form.js'/>"></script>
	<script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
	<script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/main.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/swiper.jquery.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/TweenMax.js'/>" charset="utf-8"></script>

	<style>
		#btnUthIdChk, #btnUpload{padding-top: 4px !important;}
	</style>
	<script>
	    $(function () {
	    	//uTradeHub 아이디 사용여부 체크
	        $('#btnUthIdChk').on('click', function(event) {
	        	if($('#UTH_USER_ID').val() === '') {
            		alert("uTradeHub 아이디를 입력해 주십시오.");
	                $('#UTH_USER_ID').focus();
	                return false;
	            }
	        	
		        var param = {
	                "USER_ID" : $('#UTH_USER_ID').val(),
	                "BIZ_NO" : $('#BIZ_NO').val()
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
	        	$.comm.send("/mem/selectUthUsr.do", param, callback, "uTradeHub 아이디 존재 확인");
	        	
	        	
		    });
	  
	      	//뒤로 버튼
	        $('#btnBack').on('click', function(event) {
	        	history.back();
	        	return false;
		    });
	        
	      	//가입신청
	        $('#btnApply').on('click', function(event) {
	        	if(!confirm("가입신청 하시겠습니까?")) return false;
				if(!$("#ATCH_FILE").val()) {
					alert("사업자등록증 사본을 선택해주십시오.");
					return;
				}

				$.comm.submit("<c:url value='/mem/saveMemberJoin.do'/>", "frm", function (response) {
                    var data = response.data;
                    var params = {"USER_ID":data.USER_ID};
                    $.comm.forward("home/mem/join05", params);
                })
		    })
		    
		    $("#SELECT_FILE_ID").change(function(){
    			var file = $("#SELECT_FILE_ID").val();
    			var ext = "";
    			if(file.lastIndexOf(".") > -1){
    				ext = file.substring(file.lastIndexOf(".") + 1).toLowerCase();
    				if(ext != 'jpg' && ext != 'gif' && ext != 'png' && ext != 'jpeg' && ext !='bmp' && ext !='tif' && ext !='pdf'){
        				alert("허용 가능한 확장자가 아닙니다.");
        				$("#SELECT_FILE_ID").val("");
        				return false;
        			}
    			}
    			$("#ATCH_FILE").val($("#SELECT_FILE_ID").val());
    		});
	      	
	      	//첨부 버튼
	        $('#btnUpload').on('click', function(event) {
	        	$("#SELECT_FILE_ID").click();
		    });
	      	
	        //영문 + 숫자 + 띄어쓰기 
	        $('#UTH_USER_ID').on("keyup", function() {
	            $(this).val( $(this).val().replace(/[^0-9a-zA-Z\s]/gi,"") );
	        });

	    });	

	</script>
</head>

<body>
<div id="wrap">
	<%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>

	<div id="container">
		<!-- content -->
		<div id="content" style="height: 720px; border-top: 1px solid;">
			<div class="inner-box bg_sky" style="margin: auto">
				<form id="frm" name="frm" method="post" enctype="multipart/form-data">
					<input type="hidden" name="USER_DIV" id="USER_DIV" value="${USER_DIV}"/>
					<input type="hidden" name="USER_ID" id="USER_ID" value="${USER_ID}"/>
					<input type="hidden" name="USER_PW" id="USER_PW" value="${USER_PW}"/>
					<input type="hidden" name="USER_PW2" id="USER_PW2" value="${USER_PW2}"/>
					<input type="hidden" name="BIZ_NO" id="BIZ_NO" value="${BIZ_NO}"/>
					<input type="hidden" name="USER_NM" id="USER_NM" value="${USER_NM}"/>
					<input type="hidden" name="CO_NM_ENG" id="CO_NM_ENG" value="${CO_NM_ENG}"/>
					<input type="hidden" name="REP_NM" id="REP_NM" value="${REP_NM}"/>
					<input type="hidden" name="REP_NM_ENG" id="REP_NM_ENG" value="${REP_NM_ENG}"/>
					<input type="hidden" name="CHARGE_NM" id="CHARGE_NM" value="${CHARGE_NM}"/>
					<input type="hidden" name="DEPT" id="DEPT" value="${DEPT}"/>
					<input type="hidden" name="POS" id="POS" value="${POS}"/>
					<input type="hidden" name="TEL_NO1" id="TEL_NO1" value="${TEL_NO1}"/>
					<input type="hidden" name="TEL_NO2" id="TEL_NO2" value="${TEL_NO2}"/>
					<input type="hidden" name="TEL_NO3" id="TEL_NO3" value="${TEL_NO3}"/>
					<input type="hidden" name="HP_NO1" id="HP_NO1"  value="${HP_NO1}"/>
					<input type="hidden" name="HP_NO2" id="HP_NO2"  value="${HP_NO2}"/>
					<input type="hidden" name="HP_NO3" id="HP_NO3"  value="${HP_NO3}"/>
					<input type="hidden" name="EMAIL" id="EMAIL"  value="${EMAIL}"/>
					<input type="hidden" name="ZIP_CD" id="ZIP_CD"  value="${ZIP_CD}"/>
					<input type="hidden" name="ADDRESS" id="ADDRESS"  value="${ADDRESS}"/>
					<input type="hidden" name="ADDRESS2" id="ADDRESS2"  value="${ADDRESS2}"/>
					<input type="hidden" name="ADDRESS_EN" id="ADDRESS_EN"  value="${ADDRESS_EN}"/>
					<input type="hidden" name="TG_NO" id="TG_NO"  value="${TG_NO}"/>
					<input type="hidden" name="APPLICANT_ID" id="APPLICANT_ID"  value="${APPLICANT_ID}"/>
					<div class="padding_box">
						<div class="bg_frame_content" style="margin: auto">
							<div class="join_step">
								<img src="/images/join_step04.png" alt="서비스가입확인 단계">
							</div>
							<div class="white_frame" style="max-width: 1200px;margin: auto;">
								<p style="margin-bottom: 5px;"><span style="color: #15a4fa;">*</span> 필수 입력 사항 입니다.</p>
								<div class="table_typeA gray">
									<table>
										<caption class="blind">필수 입력 사항</caption>
										<colgroup>
											<col width="132px">
											<col width="*">
										</colgroup>
										<tbody>
											<tr>
												<td><label for="UTH_USER_ID">uTradeHub 아이디</label></td>
												<td>
													<input type="text" class="td_input td_input_btn_harf" name="UTH_USER_ID" id="UTH_USER_ID" maxlength="20">
													<a href="#" class="td_recheck" id="btnUthIdChk">사용확인</a>
													<p style="padding-top: 8px;">* uTradeHub 전자세금계산서를 연계하여 사용하실 분은 입력 후 확인하여 주세요.</p>
												</td>
											</tr>
											<tr>
												<td><label for="PCRLIC_SVC">구매확인서비스</label></td>
												<td>
													<input type="checkbox" name="PCRLIC_SVC" id="PCRLIC_SVC" checked="checked"  disabled="disabled"/>
													<label for="PCRLIC_SVC"><span style="width: 19px"></span>사용</label>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="table_typeA gray">
									<table>
										<caption class="blind">첨부파일</caption>
										<colgroup>
											<col width="132px">
											<col width="*">
										</colgroup>
										<tbody>
											<tr>
												<td><label for="ATCH_FILE">사업자등록증 사본</label> <span>*</span></td>
												<td>
													<input type="text" class="td_input td_input_btn_harf" name="ATCH_FILE" id="ATCH_FILE">
													<input type="file" name="SELECT_FILE_ID" id="SELECT_FILE_ID" style="display: none;"/>
													<a href="#" class="auto_btn colorC" id="btnUpload">파일선택</a>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="btn_area btn_3 clearfix">
								<a href="#이전" class="b_btn dkgray_btn" id="btnBack">이전</a>
								<a href="#가입신청" class="b_btn blue_btn" id="btnApply">가입신청</a>
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
