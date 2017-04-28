<%--
    Class Name : exchList.jsp
    Description : 환율
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
        var gridWrapper, gridWrapper2, headers, headers2;
        $(function () {
            headers = [
                {"HEAD_TEXT": "기준일자"   , "WIDTH": "120", "FIELD_NAME": "APPLY_DATE"},
                {"HEAD_TEXT": "국가코드"   , "WIDTH": "100", "FIELD_NAME": "NATION"},
                {"HEAD_TEXT": "수출환율"   , "WIDTH": "100", "FIELD_NAME": "EXP_CURR_VAL"},
                {"HEAD_TEXT": "수입환율"   , "WIDTH": "100", "FIELD_NAME": "IMP_CURR_VAL"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "주요환율정보 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectMajExchangeRateList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : false,
                "postScript"        : function () {
                    var params = {
                        "F_APPLY_DATE" : $('#F_APPLY_DATE').val().trim().replace(/\/|-/g, ''),
                        "T_APPLY_DATE" : $('#T_APPLY_DATE').val().trim().replace(/\/|-/g, ''),
                        "NATION"       : $('#NATION').val()
                    };

                    gridWrapper2.setParams(params);
                    gridWrapper2.requestToServer();

                },
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });

            headers2 = [
                {"HEAD_TEXT": "기준일자"   , "WIDTH": "120", "FIELD_NAME": "APPLY_DATE"},
                {"HEAD_TEXT": "국가코드"   , "WIDTH": "100", "FIELD_NAME": "NATION"},
                {"HEAD_TEXT": "수출환율"   , "WIDTH": "100", "FIELD_NAME": "EXP_CURR_VAL"},
                {"HEAD_TEXT": "수입환율"   , "WIDTH": "100", "FIELD_NAME": "IMP_CURR_VAL"}
            ];

            gridWrapper2 = new GridWrapper({
                "actNm"             : "전체환율정보 조회",
                "targetLayer"       : "gridLayer2",
                "qKey"              : "sel.selectExchangeRateList",
                "headers"           : headers2,
                "gridNaviId"        : "gridPagingLayer2",
                "firstLoad"         : false,
                "controllers": [
                    {"btnName": "btnExcel2", "type": "EXCEL"}
                ]
            });

            $('#NATION').on("keyup", function () {
                $(this).val($(this).val().toUpperCase());
            });

            gridWrapper.requestToServer();
        });

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
                        <label for="F_APPLY_DATE">기준일자</label>
                        <label for="T_APPLY_DATE" style="display: none">기준일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_APPLY_DATE" name="F_APPLY_DATE" <attr:datefield to="T_APPLY_DATE" value="-7"/> <attr:mandantory/> >
                                    <span>~</span>
                                    <input type="text" id="T_APPLY_DATE" name="T_APPLY_DATE" <attr:datefield value="0"/> <attr:mandantory/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="NATION">국가코드</label>
                        <input id="NATION" name="NATION" style="width:calc(100% - 300px)"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left55">
            <div class="title_frame">
                <p><a href="#주요 국가환율" class="btnToggle">주요 국가환율</a></p>
            </div>
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                </div>
                <div id="gridLayer" style="overflow: auto; height: 430px">
                </div>
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer">
                    </div>
                </div>
            </div><%-- white_frame --%>
        </div>

        <div class="vertical_frame_right55">
            <div class="title_frame">
                <p><a href="#전체 국가환율" class="btnToggle">전체 국가환율</a></p>
            </div>
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel2">엑셀 다운로드</a>
                </div>
                <div id="gridLayer2" style="overflow: auto; height: 430px">
                </div>
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer2">
                    </div>
                </div>
            </div><%-- white_frame --%>
        </div>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
