<%--
    Class Name : apiClient.jsp
    Description : OPEN API 클리이언트
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  김진호   최초 생성
    author : 김진호
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
                {"HEAD_TEXT": "APIID"        , "WIDTH": "120", "FIELD_NAME": "API_ID", "LINK":"fn_textarea"},
                {"HEAD_TEXT": "설명"         , "WIDTH": "150", "FIELD_NAME": "API_NM", "LINK":"fn_detail", "ALIGN":"left"},
                {"HEAD_TEXT": "월최대처리건" , "WIDTH": "80" , "FIELD_NAME": "LIMIT_DETAIL_CNT", "ALIGN":"right"},
                {"HEAD_TEXT": "일최대호출건" , "WIDTH": "80" , "FIELD_NAME": "DAILY_CALL_CNT"  , "ALIGN":"right"},
                {"HEAD_TEXT": "회당처리건"   , "WIDTH": "80" , "FIELD_NAME": "PER_CALL_CNT"    , "ALIGN":"right"},
                {"HEAD_TEXT": "URL"          , "WIDTH": "175", "FIELD_NAME": "API_URL"         , "ALIGN":"left"},
                {"HEAD_TEXT": "버전"         , "WIDTH": "50" , "FIELD_NAME": "API_VERSION"},
                {"HEAD_TEXT": "사용클래스"   , "WIDTH": "250", "FIELD_NAME": "CLASS_ID"        , "ALIGN":"left"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "API관리 조회",
                "targetLayer"  : "gridMasterLayer",
                "qKey"         : "api.selectCmmApiMngList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "firstLoad"    : true,
                "check"        : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "qKey":"api.deleteApiMng"}
                ]
            });

            // 신규
            $('#btnNew').on('click', function (e) {
                fn_new();
            })
        });

        // 신규
        function fn_new() {
            $.comm.forward("adm/api/apiDetail", {"SAVE_MODE":"I"});
        }

        // 상세화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            data["SAVE_MODE"] = "U";

            $.comm.forward("adm/api/apiDetail", data);
        }

        // 샘플 JSON, API 설명
        function fn_textarea(index){
            var size = gridWrapper.getSize();
            if(size == 0){
                gridDetail.drawGrid();
                return;
            }
            var data = gridWrapper.getRowData(index);
            
            $('#SAMPLE_JSON').val(data.SAMPLE_JSON);
            $('#API_DESC').val(data.API_DESC);
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
                        <label for="API_ID">API ID</label>
                        <input id="API_ID" name="API_ID" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="API_VERSION">버전</label>
                        <input id="API_VERSION" name="API_VERSION" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="CLASS_ID">사용클래스</label>
                        <input id="CLASS_ID" name="CLASS_ID" style="width:calc(100% - 300px)"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <%-- Master Code List 영역--%>
    <div class="title_frame">
        <p><a href="#API키관리" class="btnToggle">API키관리</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#삭제" class="btn white_84" id="btnDel">삭제</a>
                <a href="#신규" class="btn white_84" id="btnNew">신규</a>
            </div>
            <div id="gridMasterLayer" style="height: 280px;">
            </div>
        </div>

        <div class="vertical_frame">
            <div class="vertical_frame_left55">
                <div class="white_frame">
                    <div class="util_frame">
                        <p class="util_title"><label for="SAMPLE_JSON">샘플 JSON</label></p>
                    </div>
                    <table class="table_typeA darkgray">
                        <tr>
                            <td>
                                <textarea name="SAMPLE_JSON" id="SAMPLE_JSON" rows="200" cols="200" style="padding: 5px; width: 100%; height: 150px" readonly></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="vertical_frame_right55">
                <div class="white_frame">
                    <div class="util_frame">
                        <p class="util_title"><label for="API_DESC">API설명</label></p>
                    </div>
                    <table class="table_typeA darkgray">
                        <tr>
                            <td>
                                <textarea name="API_DESC" id="API_DESC" rows="200" cols="200" style="padding: 5px; width: 100%; height: 150px" readonly></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
