<%--
    Class Name : mobileLogin.jsp
    Description : 모바일 로그인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성

    author : 성동훈
    since : 2017.03.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 | goGlobal</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="<c:url value='/css/mobile/base.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/mobile/common.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/mobile/login.css'/>"/>

    <script src="<c:url value='/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/js/mobile/autosize.js'/>"></script>
    <script src="<c:url value='/js/mobile/view.js'/>"></script>
    <script src="<c:url value='/js/common.js'/>"></script>

    <s:eval expression="@config.getProperty('login.mobile.action.url')" var="actionUrl"/>

    <script>
        $(function () {
            $.comm.setGlobalVar("sessionDiv", "B"); // 사이트 구분

            $('#usrId').on('keypress', function(event) {
                if (event.which === 13) {
                    event.preventDefault();
                    $('#usrPswd').focus();
                }
            });
            $('#usrPswd').on('keypress', function(event) {
                if (event.which === 13) {
                    event.preventDefault();
                    $('#btnLogin').trigger('click');
                }
            });
            $('#btnLogin').on('click', function(event) {
                var e = $('#usrId');
                if ($.trim(e.val()) === '') {
                    alert("아이디를 입력해 주십시오.");
                    e.focus();
                    return false;
                }
                e = $('#usrPswd');
                if ($.trim(e.val()) === '') {
                    alert("비밀번호를 입력해 주십시오.");
                    e.focus();
                    return false;
                }
                loginAction();
            });

            if('<c:out value="${msg}"/>' != ''){
                alert('<c:out value="${msg}"/>');
            }

            $('#usrId').focus();

        });

        function loginAction() {
            $('form:first').attr('action', '<c:url value="${actionUrl}"/>').submit();
        }
    </script>
</head>

<body>
<div id="wrap">a
    <div id="header">
        <h1><img src="images/color_logo.png" alt=""></h1>
        <p>쉽고 빠르게 전자상거래수출신고<br/> 서비스를 이용하세요.</p>
        <span></span>
    </div>
    <!--//header-->

    <div id="container">
        <form action="" method="post">
            <fieldset>
                <legend class="blind">로그인 입력 폼 입니다.</legend>
                <p>
                    <label for="usrId" class="blind">아이디</label>
                    <input type="text" id="usrId" name="usrId" title="아이디를 입력해주세요." placeholder="아이디를 입력해주세요.">
                </p>
                <p>
                    <label for="usrPswd" class="blind">비밀번호</label>
                    <input type="password" id="usrPswd" name="usrPswd" title="비밀번호를 입력해주세요." placeholder="비밀번호를 입력해주세요." autocomplete="off">
                </p>
            </fieldset>
            <input type="submit" value="로그인" id="btnLogin" class="login_btn">
        </form>
    </div>
    <!--//container-->

    <div id="footer">
        <h1>ktnet</h1>
        <p class="copy">Copyright 2016 KTNET All Right Reserved.</p>
    </div>
    <!--//footer-->
</div>
<!-- //wrap -->
</body>

</html>

