<%--
    Class Name : logMngPopup.jsp
    Description : 로그필터관리 - 메뉴팝업
    Modification Information
    수정일      수정자   수정내용
    ----------- -------- ---------------------------
    2017.02.27  성동훈   최초 생성
    author : 성동훈
    since : 2017.02.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>

        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "화면ID" , "WIDTH": "100" , "FIELD_NAME": "SCREEN_ID", "LINK":"fn_popDetail"},
                {"HEAD_TEXT": "화면명" , "WIDTH": "100" , "FIELD_NAME": "SCREEN_NM"},
                {"HEAD_TEXT": "URI"    , "WIDTH": "200" , "FIELD_NAME": "URI"},
                {"HEAD_TEXT": "비고"   , "WIDTH": "150" , "FIELD_NAME": "RMK"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "로그필터관리조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "log.selectCmmLogMngListForPopup",
                "headers"      : headers,
                "firstLoad"    : true,
                "check"        : true,
                "pageRow"      : 5,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "qKey":"log.deleteCmmLogMng"}
                ]
            });

            // 신규
            $('#btnNew').on("click", function () {
                fn_new();
            })

            // 저장
            $('#btnSave').on("click", function () {
                fn_save();
            })

            // 메뉴팝업
            $('#btnMenu').on("click", function () {
                fn_menu();
            })
        });

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_new();
                gridWrapper.requestToServer();
            }
        };

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $('#popDetailForm')[0].reset();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            if($.comm.isNull($('#SCREEN_ID').val())
                && $.comm.isNull($('#URI').val())
                && $.comm.isNull($('#RMK').val())){
                alert($.comm.getMessage("W00000051")); // 입력한 정보가 없습니다.
                return;
            }

            $.comm.sendForm("/log/saveLogFilter.do", "popDetailForm", fn_callback, "로그필터관리 저장");
        }

        // 상세정보
        function fn_popDetail(index) {
            var data = gridWrapper.getRowData(index);
            $('#SAVE_MODE').val("U");
            $('#ORG_SCREEN_ID').val(data.SCREEN_ID);
            $('#ORG_URI').val(data.URI);
            $('#ORG_RMK').val(data.RMK);

            $('#SCREEN_ID').val(data.SCREEN_ID);
            $('#URI').val(data.URI);
            $('#RMK').val(data.RMK);

        }

        // 메뉴팝업
        function fn_menu() {
            var spec = "dialogWidth:500px;dialogHeight:740px;scroll:auto;status:no;center:yes;resizable:yes;windowName:logMenuPopup";
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/log/logMenuPopup"/>", spec,
                function () {
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                        $('#SCREEN_ID').val(ret); // 화면ID 지정
                    }
                }
            );
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
                    <label for="SCREEN_ID">화면ID</label>
                    <input id="P_SCREEN_ID" name="P_SCREEN_ID" style="width: 200px">
                </li>
                <li>
                    <label for="SEARCH_TXT">검색조건</label>
                    <select id="SEARCH_COL" name="SEARCH_COL" <attr:changeNoSearch/>>
                        <option value="SCREEN_NM">화면명</option>
                        <option value="URI">URI</option>
                        <option value="RMK">비고</option>
                    </select>
                    <input id="SEARCH_TXT" name="SEARCH_TXT" style="width: 200px">
                </li>
            </ul><!-- search_sectionC -->
            <a href="#조회" class="btn_inquiryD" id="btnSearch">조회</a>
        </div>
    </form>

    <div class="white_frame">
        <div class="util_frame">
            <a href="#삭제" class="btn white_100" id="btnDel">삭제</a>
        </div>
        <div id="gridLayer" style="height: 200px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>

    <div class="white_frame">
        <div class="util_frame">
            <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
            <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
        </div>
        <form id="popDetailForm" name="popDetailForm">
            <div class="table_typeA ">
                <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                <input type="hidden" id="ORG_SCREEN_ID" name="ORG_SCREEN_ID">
                <input type="hidden" id="ORG_URI" name="ORG_URI">
                <input type="hidden" id="ORG_RMK" name="ORG_RMK">
                <table style="table-layout:fixed;">
                    <colgroup>
                        <col width="110px">
                        <col width="*">
                        <col width="110px">
                        <col width="*">
                        <col width="110px">
                        <col width="*">
                    </colgroup>
                    <tr>
                        <td>화면ID</td>
                        <td class="table_search">
                            <input type="text" id="SCREEN_ID" name="SCREEN_ID" style="width:calc(100% - 50px)">
                            <a href="#메뉴" class="inputHeight" id="btnMenu"></a>
                        </td>
                        <td>URI</td>
                        <td><input type="text" id="URI" name="URI"></td>
                        <td>비고</td>
                        <td><input type="text" id="RMK" name="RMK"></td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
