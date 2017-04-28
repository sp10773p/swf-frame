<%--
    Class Name : ntcViewPopup.jsp
    Description : 공지사항 미리보기 팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성
    author : 성동훈
    since : 2017.01.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
        $(function () {
            var args = $.comm.getModalArguments();
            $('#TITLE').html(args.TITLE);
            $('#CONTENTS').html(args.CONTENTS);
        });

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <form id="popSearchForm" name="popSearchForm">
        <div class="search_frame layer">
            <ul class="search_sectionE" style="width: 100%">
                <li style="width: 100%">
                    <label style="font-size: 16px" id="TITLE"></label>
                </li>
            </ul>
        </div>
    </form>
    <div class="white_frame">
        <div id="CONTENTS" style="overflow: auto; height: 400px">
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
