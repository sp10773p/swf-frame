<%--
    Class Name : newsViewPopup.jsp
    Description : 뉴스레터 미리보기 팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.04.11  성동훈   최초 생성
    author : 성동훈
    since : 2017.04.11
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
        $(function () {
            var args = $.comm.getModalArguments();
            $('.layerContent').html(args["CONTENTS"]);
            var divs = $('.layerContent div div table tbody tr td');
            $(divs[0].children[2]).css("display", "none");

            $('.layerContent').css("display", "block");
        });

    </script>
</head>
<body>
<div class="layerContent" style="display: none;">

</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
