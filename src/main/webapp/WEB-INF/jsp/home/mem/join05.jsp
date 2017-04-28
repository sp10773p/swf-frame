<%--
    Class Name : join05.jsp
    Description : 가입정보 확인
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

	<script>
	    $(function () {
	    	$.comm.send("/mem/selectUsr.do", {"qKey" : "usr.selectUser", "USER_ID": "${USER_ID}"},
	                function(data){
	                    var status = data.status;
	                    if(status == -1) return;
	                    $.comm.bindData(data.data);

	                },
	                "가입정보 확인"
	        );
	    });
	</script>
</head>

<body>
<div id="wrap">
	<%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>

	<div id="container">
		<!-- content -->
		<div id="content" style="height: 970px; border-top: 1px solid;">
			<div class="inner-box bg_sky" style="margin: auto">
				<div class="padding_box">
					<div class="bg_frame_content" style="margin: auto">
						<div class="join_step">
							<img src="/images/join_step05.png" alt="가입정보확인 단계">
						</div>
						<p class="wc_tit"><strong>입력하신 회원가입 정보 입니다.</strong><br />관리자 최종 승인 완료되면, 사이트 이용이 가능합니다.</p>
						<div class="white_frame" style="max-width: 1200px;margin: auto;">
							<div class="table_typeA gray">
								<table>
									<caption class="blind">회원가입 정보</caption>
									<colgroup>
										<col width="132px">
										<col width="*">
										<col width="132px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<td>아이디</td>
											<td><span id="USER_ID"></span></td>
											<td>사업자등록번호</td>
											<td><span id="BIZ_NO"></span></td>
										</tr>
										<tr>
											<td>업체명</td>
											<td><span id="USER_NM"></span></td>
											<td>업체 영문명</td>
											<td><span id="CO_NM_ENG"></span></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="table_typeA gray">
								<table>
									<caption class="blind">회원가입 정보</caption>
									<colgroup>
										<col width="132px">
										<col width="*">
										<col width="132px">
										<col width="*">
									</colgroup>
									<tbody>
										<tr>
											<td><label for="REP_NM">대표자명</label></td>
											<td><span id="REP_NM"></span></td>
											<td><label for="REP_NM_ENG">대표자 영문명</label></td>
											<td><span id="REP_NM_ENG"></span></td>
										</tr>
										<tr>
											<td><label for="CHARGE_NM">담당자명</label></td>
											<td><span id="CHARGE_NM"></span></td>
											<td><label for="DEPT">부서/직위</label><label for="POS" style="display: none;">부서/직위</label></td>
											<td><span id="DEPT"></span>/<span id="POS"></span></td>
										</tr>
										<tr>
											<td><label for="TEL_NO">연락처</label></td>
											<td><span id="TEL_NO"></span></td>
											<td><label for="HP_NO">휴대폰</label></td>
											<td><span id="HP_NO"></span></td>
										</tr>
										<tr>
											<td><label for="EMAIL">이메일</label></td>
											<td colspan="3"><span id="EMAIL"></span></td>
										</tr>
										<tr>
											<td><label for="ZIP_CD">우편번호</label></td>
											<td><span id="ZIP_CD"></span></td>
										</tr>
										<tr>
											<td><label for="ADDRESS2">상세주소</label></td>
											<td colspan="3"><span id="ADDRESS2"></span></td>
										</tr>
										<tr>
											<td><label for="ADDRESS_EN">영문주소</label></td>
											<td colspan="3"><span id="ADDRESS_EN"></span></td>
										</tr>
										<tr>
											<td><label for="TG_NO">통관고유부호</label></td>
											<td><span id="TG_NO"></span></td>
											<td><label for="APPLICANT_ID">신고인부호</label></td>
											<td><span id="APPLICANT_ID"></span></td>
										</tr>
										<tr>
											<td><label for="UTH_USER_ID">UTH 아이디</label></td>
											<td><span id="UTH_USER_ID"></span></td>
											<td><label for="SIGN_VALUE">전자서명</label></td>
											<td><span id="SIGN_VALUE"></span></td>
										</tr>
										<tr>
											<td><label for="ATCH_FILE_ID">사업자등록증사본</label></td>
											<td colspan="3"><span id="ATCH_FILE_ID"></span></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_area btn_1 clearfix">
							<a href="<c:out value='/' />" class="b_btn blue_btn">확인</a>
						</div>
					</div>

				</div>
				<!-- //padding_box -->
			</div>
			<!-- //inner-box -->
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/main/include-main-footer.jsp" %>
</div>
</body>
</html>
