<%--
    Class Name : decValList.jsp
    Description : 신고인신고서기본값
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
                {"HEAD_TEXT": "문서코드"      , "WIDTH": "80" , "FIELD_NAME": "DOC_ID"},
                {"HEAD_TEXT": "판매자ID"      , "WIDTH": "120", "FIELD_NAME": "USER_ID"},
                {"HEAD_TEXT": "판매자"        , "WIDTH": "120", "FIELD_NAME": "USER_NM"},
                {"HEAD_TEXT": "사업자등록번호", "WIDTH": "120", "FIELD_NAME": "BIZ_NO"},
                {"HEAD_TEXT": "수출신고항목"  , "WIDTH": "180", "FIELD_NAME": "ITEM_DESC"},
                {"HEAD_TEXT": "API항목코드"   , "WIDTH": "180", "FIELD_NAME": "API_ITEM_NM"},
                {"HEAD_TEXT": "기본값"        , "WIDTH": "240", "FIELD_NAME": "BASE_VAL"     , "FIELD_TYPE":"TXT", "LENGTH":"100"},
                {"HEAD_TEXT": "수정일자"      , "WIDTH": "100", "FIELD_NAME": "MOD_DTM"},
                {"HEAD_TEXT": "수정자ID"      , "WIDTH": "100", "FIELD_NAME": "MOD_ID"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "신고인신고서기본값 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectSellerBasevalList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });

            $('#btnSave').on('click', function () {
                fn_save();
            })

        });

        var fn_callback = function () {
            gridWrapper.requestToServer();
        };

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var modDataList = gridWrapper.getUpdateData();
            if(modDataList.length == 0){
                alert($.comm.getMessage("I00000013"));// 변경된 내용이 없습니다.
                return;
            }

            // 길이 체크
            if(!gridWrapper.checkLength()){
                return;
            }

            var params = {
                "dataList"  : modDataList,
                "DEC_GUBUN" : $('#DEC_GUBUN').val()
            };

            $.comm.send("sel/saveDecBaseval.do", params, fn_callback, "신고인신고서기본값 저장");
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
                        <label for="SEARCH_DATE">검색기준일자</label>
                        <select id="SEARCH_DATE" name="SEARCH_DATE" style="width:120px;">
                            <option value="A.MOD_DTM">수정일자</option>
                            <option value="A.REG_DTM">등록일자</option>
                        </select>
                        <div class="dateSearch">
                            <label for="F_SEARCH_DTM" style="display: none">검색기준일자</label>
                            <label for="T_SEARCH_DTM" style="display: none">검색기준일자</label>
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_SEARCH_DTM" name="F_SEARCH_DTM" <attr:datefield to="T_SEARCH_DTM"/>><span>~</span>
                                    <input type="text" id="T_SEARCH_DTM" name="T_SEARCH_DTM" <attr:datefield/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <label for="SEARCH_TXT" style="display: none">검색조건 TEXT</label>
                        <select id="SEARCH_COL" name="SEARCH_COL" style="width: 120px" <attr:changeNoSearch/> >
                            <option value="C.USER_ID">판매자ID</option>
                            <option value="C.USER_NM">판매자명</option>
                            <option value="A.BIZ_NO">사업자등록번호</option>
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
            <a href="#저장" class="btn white_84"  id="btnSave">저장</a>
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
