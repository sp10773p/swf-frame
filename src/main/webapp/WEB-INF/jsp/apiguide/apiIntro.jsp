<%--
    Class Name : apiIntro.jsp
    Description : Open API란
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-03-30  정안균   최초 생성

    author : 정안균
    since : 2017-03-30
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<html>
<head>
	<link rel="stylesheet" href="<c:url value='/css/base.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/sub.css'/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/nicescroll.css'/>" />
	
	<script src="<c:url value='/js/jquery.min.js'/>"></script>
	<script src="<c:url value='/js/jquery.form.js'/>"></script>
	<script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
	<script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
	<script>
	    $(function () {
	    	var param = {
                    "qKey": "apiguide.selectCmmApiMngList"
            };
	    	
	    	var fn_callback = function(data, status){
	    		var dataList = data.dataList;
	    		var html = "";
	            for(var i in dataList) {
	        		var apiNm = dataList[i]["API_NM"];
	        		html += "<li><span>ㆍ</span>" + apiNm + "</li>";
	            }
	            $("#API_TYPE_LIST").append(html);
            };
            
            $.comm.send("/common/selectListNonSession.do", param, fn_callback, 'Open API 종류 조회');
            
	    });
	</script>
</head>
<body>
<div class="inner-box bg_sky">
	<div class="padding_box">
		<div class="bg_frame_content">
			<div class="title_frame">
			    <p>Open API 소개</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>인터넷 이용자가 웹 검색 결과 및 사용자인터페이스(UI) 등을 제공받는 데 그치지 않고 직접 응용 프로그램과 서비스를 개발할 수 있도록 공개된 API입니다.</li>
                    <li><span>ㆍ</span>KTNET에서 제공하는 API 서비스를 활용하여 KTNET 간이수출신고가 자동으로 연계가 됩니다.</li>
                    <li><span>ㆍ</span>Open API 서비스를 이용하기 위해서는 아래 절차에 따라 인증키 신청을 하시기 바랍니다.</li>
                </ul>
			</div>
            <div class="title_frame">
			    <p>Open API 이용절차</p>
                <div class="api_step box">
                    <img src="/images/api_step.png" alt="1.회원가입 2.인증키 신청 3.인증키 발급 4.openAPI 사용">
                </div>
			</div>
            <div class="title_frame">
			    <p>Open API 종류</p>
                <ul class="box" id="API_TYPE_LIST">
                </ul>
			</div>
		</div><!-- //bg_frame_content -->
	</div><!-- //padding_box -->
</div><!-- //inner-box -->

</body>
</html>
