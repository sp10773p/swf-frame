<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2017-04-03
  Time: 오후 2:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.pe.frame.cmm.core.base.Constant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<html>
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/base.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/sub.css'/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/main.css'/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/layerPop.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/nicescroll.css'/>" />
	<s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>
    <script src="<c:url value='/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
    <c:set var="session" value='<%= request.getSession(false).getAttribute(Constant.SESSION_KEY_USR.getCode())%>'/>
	<c:set var="userDiv" value="${session.getUserDiv()}" />

    <script type="text/javascript">
        $(function(){
            $('.inner-box').niceScroll(); //스크롤바 script
            if("${userDiv}" != "G") {
            	$(".btn_area").show();
            }
            $('.btn_area').on('click', function(event) {
            	parent.$.comm.logout('<c:out value="${logoutUrl}" />');
            });
        });
    </script>
</head>
<body>
<div class="inner-box bg_sky">
    <div class="padding_box">
        <div class="bg_frame_content">
            <div class="title_frame">
                <p>goGLOBAL 서비스 개요</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>관세사는 회원가입을 한 후 관세사 전용프로그램을 설치하셔서 수출신고정정/취하 및 반품수입신고업무 등을 수행할 수 있습니다.</li>
                </ul>
                <div class="box">
                    <img src="/images/customs_info.png" alt="">
                </div>
            </div>
            <div class="btn_area btn_1" style="display: none;">
                <a href="#" class="b_btn orange_btn">관세사 회원가입하기</a>
            </div>
        </div><!-- //bg_frame_content -->
    </div><!-- //padding_box -->
</div><!-- //inner-box -->
</body>
</html>
