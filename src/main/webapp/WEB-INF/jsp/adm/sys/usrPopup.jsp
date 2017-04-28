<%--
    Class Name : usrPopup.jsp
    Description : 사용자 조회 팝업
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
            var from = $.comm.getModalArguments();
            headers = [
                {"HEAD_TEXT": "사용자ID" , "WIDTH": "120", "FIELD_NAME": "USER_ID", "LINK":"fn_return"},
                {"HEAD_TEXT": "사용자명" , "WIDTH": "120", "FIELD_NAME": "USER_NM"}
            ];

            if(from){
                var fromName = from["FROM"];
                if(fromName == "admExpStaNatList"){ // 수출현황정보 > 국가별수출현황 조회
                    $('#IS_ADMIN').val("F"); // 일반사용자로 조회
                    headers.push({"HEAD_TEXT": "사업자등록번호" , "WIDTH": "100"  , "FIELD_NAME": "BIZ_NO"});
                }

                var searchType = from["SEARCH_TYPE"];
                if(searchType == "express"){
                    $('#S_USER_DIV').val("'E'"); // 특송사 조회

                }else if(searchType == "seller"){
                    $('#S_USER_DIV').val("'S', 'M'"); // 판매자 조회
                }

            }else{
                headers.push({"HEAD_TEXT": "권한정보" , "WIDTH": "*"  , "FIELD_NAME": "AUTH_NM"});
            }

            gridWrapper = new GridWrapper({
                "actNm"        : "사용자조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "acc.selectAdminUsrPopList",
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
        <input type="hidden" name="IS_ADMIN" id="IS_ADMIN" value="T">
        <input type="hidden" name="S_USER_DIV" id="S_USER_DIV">
        <div class="search_frame layer">
            <ul class="search_sectionE">
                <li style="width: 100%">
                    <label for="SEARCH_COL1">검색조건</label>
                    <label for="SEARCH_TXT1" style="display: none">검색조건 SEARCH_TXT1</label>
                    <select id="SEARCH_COL1" name="SEARCH_COL1" style="width:100px;" <attr:changeNoSearch/>>
                        <option value="USER_ID">사용자ID</option>
                        <option value="USER_NM">사용자명</option>
                        <option value="BIZ_NO">사업자번호</option>
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
