<%--
    Class Name : keyDetail.jsp
    Description : API처리내역
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
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
        var globalVar = {
            "data" : {}
        };
        var gridWrapper;
        $(function (){
            // 첨부파일 그리드
            var headers = [
                {"HEAD_TEXT": "로그시간" , "WIDTH": "150", "FIELD_NAME": "LOG_DTM"},
                {"HEAD_TEXT": "수신일시" , "WIDTH": "150", "FIELD_NAME": "ACCECP_DTM"},
                {"HEAD_TEXT": "APIID"    , "WIDTH": "100", "FIELD_NAME": "API_ID"    , "LINK":"fn_detail"},
                {"HEAD_TEXT": "판매자ID" , "WIDTH": "100", "FIELD_NAME": "USER_ID"},
                {"HEAD_TEXT": "원본순번" , "WIDTH": "100", "FIELD_NAME": "ORG_SEQ"},
                {"HEAD_TEXT": "처리결과" , "WIDTH": "100", "FIELD_NAME": "RESULT_CD"},
                {"HEAD_TEXT": "수신번호" , "WIDTH": "100", "FIELD_NAME": "REQ_NO"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "API처리내역 조회",
                "targetLayer"  : "gridWrapLayer",
                "qKey"         : "api.selectCmmApiLogDetailList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "firstLoad"    : false,
                "postScript"   : function (){fn_detail(0);},
                "pageRow"      : 5,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });

            //목록
            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });

            gridWrapper.requestToServer();

        });

        function fn_detail(index) {
            var data = gridWrapper.getRowData(index);
            if(data){
                var jsonStr = data.ORG_JSON;
                var jsonObj = JSON.parse(jsonStr);
                var jsonPretty = JSON.stringify(jsonObj, null, '\t');

                $('#ORG_JSON').val(jsonPretty);
                $('#ERROR_DESC').val(data.ERROR_DESC);
            }
        }


    </script>
</head>
<body>
<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <input type="hidden" name="USER_ID" id="USER_ID" value="${USER_ID}"/>
            <input type="hidden" name="API_ID" id="API_ID" value="${API_ID}"/>
            <div class="search_frame">
                <ul class="search_sectionB">
                    <li>
                        <label for="F_ACCECP_DTM">수신일자</label>
                        <label for="T_ACCECP_DTM" style="display: none">수신일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_ACCECP_DTM" name="F_ACCECP_DTM" class="input" <attr:datefield to="T_ACCECP_DTM" value="0"/> />
                                    <span>~</span>
                                    <input type="text" id="T_ACCECP_DTM" name="T_ACCECP_DTM" class="input" <attr:datefield  value="0"/>/>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <%-- 그리드 영역 --%>
    <div class="white_frame">
        <div class="util_frame">
            <a href="#목록" class="btn white_100" id="btnList">목록</a>
        </div>
        <div id="gridWrapLayer" style="height: 220px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left55">
            <div class="white_frame">
                <div class="util_frame">
                    <p class="util_title"><label for="ORG_JSON">원본 JSON</label></p>
                </div>
                <table class="table_typeA darkgray">
                    <tr>
                        <td>
                            <textarea name="ORG_JSON" id="ORG_JSON" rows="200" cols="200" style="padding: 5px; width: 100%; height: 150px" readonly></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="vertical_frame_right55">
            <div class="white_frame">
                <div class="util_frame">
                    <p class="util_title"><label for="ERROR_DESC">오류내용</label></p>
                </div>
                <table class="table_typeA darkgray">
                    <tr>
                        <td>
                            <textarea name="ERROR_DESC" id="ERROR_DESC" rows="200" cols="200" style="padding: 5px; width: 100%; height: 150px" readonly></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
