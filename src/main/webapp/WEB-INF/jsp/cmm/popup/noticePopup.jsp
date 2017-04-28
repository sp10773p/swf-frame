<%--
    Class Name : noticePopup.jsp
    Description : 공지사항 팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.31  정안균   최초 생성

    author : 정안균
    since : 2017.03.31
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="<c:url value='/css/base.css'/>"/>
	<link rel="stylesheet" href="<c:url value='/css/notice.css'/>"/>

    <script src="<c:url value='/js/jquery.min.js'/>"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>

    <script>
	    $(function (){
            var ret = opener.$.comm.getGlobalVar("noticePopup${SN}");
            var ntc = JSON.parse(ret);

            opener.sessionStorage.removeItem("noticePopup${SN}");

            $('#title').html(ntc["TITLE"]);
            $('#contents').html(ntc["CONTENTS"]);

        	$('#stop_looking').on("click", function (e) {
                localStorage.setItem("goglobalSaveNoticePopupKey${SN}", "done");
                self.close();
            })
		});
	    
    </script>
</head>
<body>
    <div id="wrap">
        <div id="header">
            <h1 id="title"></h1>
        </div>
        <div id="container">
            <div id="contents" style="height:350px;overflow: auto;">
            </div>
        </div>
        <div id="footer">
            <div class="inner">
                <div>
                    <input type="checkbox" id="stop_looking" name="Notice" value="Y">
                    <label for="stop_looking">오늘 하루 그만보기</label>
                </div>
                <a href="javascript:self.close();" class="close_popup">닫기</a>
            </div>
        </div>
    </div>
</body>
</html>
