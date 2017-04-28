<%--
    Class Name : menuPopup.jsp
    Description : 상위메뉴 선택 팝업
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
            var params = $.comm.getModalArguments();
            if(params){
                var menuDiv = params["MENU_DIV"];
                $('#MENU_DIV').val(menuDiv);
            }

            headers = [
                {"HEAD_TEXT": "상위메뉴명"   , "WIDTH": "*"   , "FIELD_NAME": "MENU_NM", "LINK":"fn_return", "ALIGN":"left"},
                {"HEAD_TEXT": "상위메뉴코드" , "WIDTH": "120" , "FIELD_NAME": "MENU_ID", "LINK":"fn_return"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "상위메뉴조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "menu.selectCmmPmenu",
                "headers"      : headers,
                "firstLoad"    : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
        });

        // 상위메뉴 선택
        function fn_return(index) {
            var retVal = gridWrapper.getRowData(index);
            $.comm.setModalReturnVal(retVal);
            self.close();
        }

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <form id="popSearchForm" name="popSearchForm">
        <div class="search_frame layer">
            <ul class="search_sectionE">
                <li>
                    <label for="MENU_NM">메뉴명</label>
                    <input id="MENU_NM" name="MENU_NM"/>
                </li>
                <li>
                    <label for="MENU_DIV">메뉴구분</label>
                    <select id="MENU_DIV" name="MENU_DIV">
                        <option value="W">사용자</option>
                        <option value="M">어드민</option>
                    </select>
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
