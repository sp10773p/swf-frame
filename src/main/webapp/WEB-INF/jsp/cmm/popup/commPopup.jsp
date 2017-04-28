<%--
    Class Name : commonPopup.jsp
    Description : 공통코드 팝업
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
            var arguments = $.comm.getModalArguments();
            var classId = arguments.CLASS_ID;
            if($.comm.isNull(classId)){
                alert("CLASS_ID 인자가 없습니다.");
                self.close();
            }

            // 초기 조회조건
            if($.comm.isNull(arguments.CODE)){
                $('#CODE').val(arguments.CODE);
            }
            if($.comm.isNull(arguments.CODE_NM)){
                $('#CODE_NM').val(arguments.CODE_NM);
            }

            $('#CLASS_ID').val(classId);

            headers = [
                {"HEAD_TEXT": "코드"   , "WIDTH": "100", "FIELD_NAME": "CODE"   , "LINK":"fn_return"},
                {"HEAD_TEXT": "코드명" , "WIDTH": "120", "FIELD_NAME": "CODE_NM", "LINK":"fn_return", "ALIGN":"left"}
            ];

            var params = {"CLASS_ID":classId, "qKey":"common.selectCommCodeRefInfo"};
            var userRefInfo = $.comm.sendSync("/common/select.do", params, "공통코드 사용자컬럼 조회").data;

            // 타이틀 지정
            if(userRefInfo["CLASS_NM"])
                $('#title').html(userRefInfo["CLASS_NM"]);

            for(var i=1; i<=5; i++){
                var headText = userRefInfo["USER_REF"+i];

                if($.comm.isNull(headText))
                    continue;

                var header = {"HEAD_TEXT": headText, "WIDTH": "100", "FIELD_NAME":"USER_REF"+i};
                headers.push(header);
            }

            gridWrapper = new GridWrapper({
                "actNm"        : "공통코드 조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "common.selectCommCodePagingList",
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
        <h1 id="title">${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <form id="popSearchForm" name="popSearchForm">
        <input type="hidden" name="CLASS_ID" id="CLASS_ID">
        <div class="search_frame layer">
            <ul class="search_sectionE">
                <li style="width: 100%">
                    <label for="SEARCH_COL1">검색조건</label>
                    <label for="SEARCH_TXT1" style="display: none">검색조건 SEARCH_TXT1</label>
                    <select id="SEARCH_COL1" name="SEARCH_COL1" style="width:100px;" <attr:changeNoSearch/>>
                        <option value="CODE">코드</option>
                        <option value="CODE_NM">코드명</option>
                    </select>
                    <input id="SEARCH_TXT1" name="SEARCH_TXT1" type="text" style="width:120px"/>
                </li>
            </ul><!-- search_sectionC -->
            <a href="#조회" class="btn_inquiryD" id="btnSearch">조회</a>
        </div>
    </form>
    <div class="white_frame">
        <div class="util_frame">
        </div>
        <div id="gridLayer" style="height: 410px">
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
