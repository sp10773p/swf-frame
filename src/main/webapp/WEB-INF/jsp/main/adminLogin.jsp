<%--
    Class Name : adminLogin.jsp
    Description : 어드민사이트 로그인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성

    author : 성동훈
    since : 2017.01.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>

    <link rel="stylesheet" href="<c:url value='/css/admin/base.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/admin/admin.css'/>"/>
    <script src="<c:url value='/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
    <s:eval expression="@config.getProperty('login.admin.action.url')" var="actionUrl"/>

    <script>
        var saveIdKey = "goglobalAdminId";

        $(function () {
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
                    alert($.comm.getMessage("W00000067")); // 아이디를 입력해 주십시오.
                    e.focus();
                    return false;
                }
                e = $('#usrPswd');
                if ($.trim(e.val()) === '') {
                    alert($.comm.getMessage("W00000068")); // 비밀번호를 입력해 주십시오.
                    e.focus();
                    return false;
                }
                loginAction();
            });

            if(!$.comm.isNull('${msg}')){
                alert('${msg}');
            }

            var saveIdVal = localStorage.getItem(saveIdKey);

            if(!$.comm.isNull(saveIdVal)){
                $('#usrId').val(saveIdVal);
                $('#saveId').prop("checked", true);
                $('#usrPswd').focus();

            }else{
                $('#usrId').focus();
            }

        });

        function fn_saveid() {
            if ($('#saveId').prop("checked") == true) {
                localStorage.setItem(saveIdKey, $('#usrId').val());
            }else{
                localStorage.removeItem(saveIdKey);
            }
        }

        function loginAction() {
            fn_saveid();
            $('form:first').attr('action', '<c:url value="${actionUrl}"/>').submit();
        }
    </script>
</head>
<body>
<div id="loginWrap" >
    <header>
        <div>
            <h1><a href="#" id="logo_login"><img src="/images/admin/logo_login.png" alt="goGLOBAL" /></a></h1>
            <div>
                <p>전자상거래 수출지원플랫폼</p>
                <p>KTNET goGLOBAL</p>
                <p>Administrator</p>
            </div>
        </div>
    </header>
    <div>
        <form method="post">
            <input id="sessionDiv" name="sessionDiv" type="hidden" value="M"/>
            <p>
                <label for="usrId">ID</label>
                <input type="text" id="usrId" name="usrId" title="아이디를 입력해주세요." placeholder="아이디를 입력해주세요." value="admin" tabindex="1">
            </p>
            <p>
                <label for="usrPswd">Password</label>
                <input type="password" id="usrPswd" name="usrPswd" title="비밀번호를 입력해주세요." placeholder="비밀번호를 입력해주세요."  value="admin" tabindex="2" autocomplete="off">
            </p>
            <div id="rememberID" tabindex="3">
                <input type="checkbox" id="saveId" name="saveId"  tabindex="1"/>
                <label for="saveId"><span></span></label>
                <p>아이디저장</p>
            </div>
            <button type="submit" id="btnLogin"  tabindex="4">Login</button>
        </form>
    </div>
    <div class="copy_login">
        <p>Copyright &copy;  2016 KTNET All Rights Reservd.</p>
    </div>
</div> <!-- //wrap -->
<div id="layer"></div>
</body>
</html>
