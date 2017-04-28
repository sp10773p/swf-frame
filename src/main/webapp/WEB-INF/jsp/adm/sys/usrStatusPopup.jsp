<%--
    Class Name : usrStatusPopupt.jsp
    Description : 사용자 상태 변경 내역 팝업
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
        var gridWrapper, headers;
        $(function () {
            var args = $.comm.getModalArguments();
            $('#USER_ID').val(args.USER_ID);
            headers = [
                {"HEAD_TEXT": "변경상태" , "WIDTH": "80" , "FIELD_NAME": "USER_STATUS_NM"},
                {"HEAD_TEXT": "변경사유" , "WIDTH": "*"  , "FIELD_NAME": "DESCRIPTION", "ALIGN":"left"},
                {"HEAD_TEXT": "변경자"   , "WIDTH": "100", "FIELD_NAME": "REG_ID"},
                {"HEAD_TEXT": "변경일자" , "WIDTH": "80" , "FIELD_NAME": "REG_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "상태변경사유 조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "usr.selectCmmStatusHis",
                "headers"      : headers,
                "firstLoad"    : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
        });

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <form id="popSearchForm" name="popSearchForm">
        <input type="hidden" id="USER_ID" name="USER_ID">
        <div class="search_frame layer">
            <ul class="search_sectionE">
                <li>
                    <label for="USER_STATUS">변경상태</label>
                    <select id="USER_STATUS" name="USER_STATUS" <attr:selectfield/> ></select>
                </li>
            </ul><!-- search_sectionC -->
            <a href="#조회" class="btn_inquiryD" id="btnSearch">조회</a>
        </div>
    </form>
    <div class="white_frame">
        <div class="util_frame">
        </div>
        <div id="gridLayer" style="height: 400px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
