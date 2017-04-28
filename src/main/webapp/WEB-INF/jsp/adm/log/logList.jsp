<%--
    Class Name : logList.jsp
    Description : 로그목록조회
    Modification Information
    수정일      수정자   수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성
    author : 성동훈
    since : 2017.01.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
                {"HEAD_TEXT": "로그일자"   , "WIDTH": "120", "FIELD_NAME": "LOG_DTM"},
                {"HEAD_TEXT": "로그구분"   , "WIDTH": "100", "FIELD_NAME": "LOG_DIV_NM"},
                {"HEAD_TEXT": "사용자ID"   , "WIDTH": "100", "FIELD_NAME": "USER_ID"},
                {"HEAD_TEXT": "사용자IP"   , "WIDTH": "150", "FIELD_NAME": "LOGIN_IP"},
                {"HEAD_TEXT": "사용화면ID" , "WIDTH": "100", "FIELD_NAME": "SCREEN_ID" , "LINK":"fn_popup"},
                {"HEAD_TEXT": "사용화면명" , "WIDTH": "150", "FIELD_NAME": "SCREEN_NM"},
                {"HEAD_TEXT": "URI"        , "WIDTH": "200", "FIELD_NAME": "URI"},
                {"HEAD_TEXT": "비고"       , "WIDTH": "200", "FIELD_NAME": "RMK", "ALIGN":"left"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "로그목록 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "log.selectLogList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "firstLoad"    : true,
                "check"        : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            // 로그제외
            $('#btnLogPass').on('click', function () {
                fn_logPass();
            })

            // 로그필터관리 팝업
            $('#btnLogFilter').on('click', function () {
                fn_logFilterPopup();
            })

        });

        //로그제외
        function fn_logPass(){
            var selectedSize = gridWrapper.getSelectedSize();
            if(selectedSize == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return;
            }

            if(!confirm($.comm.getMessage("C00000032"))){ // 로그제외 하시겠습니까?
                return;
            }

            $.comm.send("/log/saveLogPass.do", gridWrapper.getSelectedRows(), null, "로그제외");


        }

        // 로그필터관리 팝업
        function fn_logFilterPopup(){
            var spec = "dialogWidth:1220px;dialogHeight:800px;scroll:auto;status:no;center:yes;resizable:yes;";
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/log/logMngPopup"/>", spec);
        }

        // 상세팝업
        function fn_popup(index){
            var data = gridWrapper.getRowData(index);
            $.comm.setModalArguments({"SID":data.SID});
            var spec = "dialogWidth:700px;dialogHeight:400px;scroll:auto;status:no;center:yes;resizable:yes;";
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/log/logPopup"/>", spec);
        }
    </script>
</head>
<body>
<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <div class="search_frame">
                <ul class="search_sectionB">
                    <li>
                        <label for="F_LOG_DTM">로그일자</label><label for="T_LOG_DTM"
                                                                  style="display: none">로그일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_LOG_DTM" name="F_LOG_DTM" class="input" <attr:datefield to="T_LOG_DTM" value="0"/> />
                                    <span>~</span>
                                    <input type="text" id="T_LOG_DTM" name="T_LOG_DTM" class="input" <attr:datefield  value="0"/>/>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="USER_ID">사용자ID</label>
                        <input id="USER_ID" name="USER_ID" type="text">
                    </li>
                    <li>
                        <label for="LOG_DIV">로그구분</label>
                        <select id="LOG_DIV" name="LOG_DIV">
                            <option value="">선택</option>
                            <option value="W">사용자</option>
                            <option value="M">어드민</option>
                            <option value="S">모바일</option>
                        </select>
                    </li>
                    <li>
                        <label for="SCREEN_ID">사용화면ID</label>
                        <input id="SCREEN_ID" name="SCREEN_ID" type="text">
                    </li>
                    <li>
                        <label for="SCREEN_NM">사용화면명</label>
                        <input id="SCREEN_NM" name="SCREEN_NM" type="text">
                    </li>
                    <li>
                        <label for="RMK">비고</label>
                        <input id="RMK" name="RMK" type="text">
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="white_frame">
        <div class="util_frame">
            <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
            <a href="#로그필터관리"  class="btn white_100" id="btnLogFilter">로그필터관리</a>
            <a href="#로그제외" class="btn white_100" id="btnLogPass">로그제외</a>
        </div>
        <div id="gridLayer" style="height: 430px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>

    </div>
    <%-- white_frame --%>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
