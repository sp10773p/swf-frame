<%--
    Class Name : selList.jsp
    Description : 셀러정보
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
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "사업자등록번호" , "WIDTH": "120", "FIELD_NAME": "BIZ_NO"},
                {"HEAD_TEXT": "셀러ID"         , "WIDTH": "80" , "FIELD_NAME": "USER_ID"},
                {"HEAD_TEXT": "셀러명"         , "WIDTH": "100", "FIELD_NAME": "SELLER_NM",   "ALIGN":"left"},
                {"HEAD_TEXT": "통관부호"       , "WIDTH": "130", "FIELD_NAME": "TG_NO"},
                {"HEAD_TEXT": "신고인부호"     , "WIDTH": "65" , "FIELD_NAME": "APPLICANT_ID"},
                {"HEAD_TEXT": "주소"           , "WIDTH": "200", "FIELD_NAME": "ADDRESS",     "ALIGN":"left"},
                {"HEAD_TEXT": "우편번호"       , "WIDTH": "60" , "FIELD_NAME": "POST_NO"},
                {"HEAD_TEXT": "전화번호"       , "WIDTH": "100", "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "이메일"         , "WIDTH": "150", "FIELD_NAME": "EMAIL_ADDRESS"},
                {"HEAD_TEXT": "자동신고여부"   , "WIDTH": "90" , "FIELD_NAME": "AUTO_SEND_YN"},
                {"HEAD_TEXT": "등록몰ID"       , "WIDTH": "70" , "FIELD_NAME": "REG_MALL_ID"},
                {"HEAD_TEXT": "식별자"         , "WIDTH": "130", "FIELD_NAME": "IDENTIFY_ID"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "셀러정보 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectSellerList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });
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
                        <label for="F_REG_DTM">등록일자</label>
                        <label for="T_REG_DTM" style="display: none">등록일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" <attr:datefield to="T_REG_DTM" value="-1m"/> >
                                    <span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" <attr:datefield value="0"/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="SELLER_NM">셀러명</label>
                        <input id="SELLER_NM" name="SELLER_NM" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="BIZ_NO">사업자등록번호</label>
                        <input id="BIZ_NO" name="BIZ_NO" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="TG_NO">통관부호</label>
                        <input id="TG_NO" name="TG_NO" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="APPLICANT_ID">신고인부호</label>
                        <input id="APPLICANT_ID" name="APPLICANT_ID" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <label for="SEARCH_TXT" style="display: none">검색조건 TEXT</label>
                        <select id="SEARCH_COL" name="SEARCH_COL" style="width: 100px">
                            <option value="IDENTIFY_ID">식별자</option>
                            <option value="REG_MALL_ID">등록몰ID</option>
                        </select>
                        <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" style="width:calc(100% - 300px)"/>
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
        </div>
        <div id="gridLayer" style="overflow: auto; height: 430px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>

    </div>
    <%-- white_frame --%>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
