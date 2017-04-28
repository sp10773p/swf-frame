<%--
    Class Name : selValList.jsp
    Description : 신고서기본값
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
            var combo = [];
            $.each($.comm.getCommCode("BASE_VAL_DIV"), function(){
                var code  = this.CODE;
                var value = this.CODE_NM;
                combo.push({"code":code, "value":value});

            });
            headers = [
                {"HEAD_TEXT": "문서구분"        , "WIDTH": "70" , "FIELD_NAME": "DOC_ID"},
                {"HEAD_TEXT": "수출신고항목코드", "WIDTH": "160", "FIELD_NAME": "DOC_ITEM"},
                {"HEAD_TEXT": "항목설명"        , "WIDTH": "180", "FIELD_NAME": "ITEM_DESC"        , "FIELD_TYPE":"TXT", "LENGTH":"50"},
                {"HEAD_TEXT": "API항목명"       , "WIDTH": "180", "FIELD_NAME": "API_ITEM_NM"      , "FIELD_TYPE":"TXT", "LENGTH":"50"},
                {"HEAD_TEXT": "기본값"          , "WIDTH": "100", "FIELD_NAME": "BASE_VAL"         , "FIELD_TYPE":"TXT", "LENGTH":"100"},
                {"HEAD_TEXT": "구분"            , "WIDTH": "100", "FIELD_NAME": "BASE_VAL_DIV"     , "FIELD_TYPE":"CMB",  "COMBO":combo},
                /*{"HEAD_TEXT": "기본값구분명"    , "WIDTH": "100", "FIELD_NAME": "BASE_VAL_DIV_NM"},*/
                {"HEAD_TEXT": "테이블명"        , "WIDTH": "130", "FIELD_NAME": "TABLE_NM"         , "FIELD_TYPE":"TXT", "LENGTH":"50"},
                {"HEAD_TEXT": "순서"            , "WIDTH": "50" , "FIELD_NAME": "ORDR"             , "FIELD_TYPE":"TXT", "LENGTH":"4"},
                {"HEAD_TEXT": "사이즈체크"      , "WIDTH": "100", "FIELD_NAME": "CHECK_SIZE"       , "FIELD_TYPE":"NUM", "LENGTH":"38"},
                {"HEAD_TEXT": "공통코드체크"    , "WIDTH": "100", "FIELD_NAME": "CHECK_CODE"       , "FIELD_TYPE":"TXT", "LENGTH":"20"},
                {"HEAD_TEXT": "칼럼명"          , "WIDTH": "120", "FIELD_NAME": "COLUMN_NM"        , "FIELD_TYPE":"TXT", "LENGTH":"50"},
                {"HEAD_TEXT": "노드명"          , "WIDTH": "80" , "FIELD_NAME": "NODE_NM"          , "FIELD_TYPE":"TXT", "LENGTH":"100"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "신고서기본값 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectBasevalList",
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

            $.comm.send("sel/saveBaseval.do", modDataList, fn_callback, "신고서기본값 저장");
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
                        <label for="BASEVAL_DOC_ID">문서구분</label>
                        <select id="BASEVAL_DOC_ID" name="BASEVAL_DOC_ID" style="width: 100px" <attr:selectfield/> >
                    </li>
                    <li>
                        <label for="BASE_VAL_DIV">기본값구분</label>
                        <select id="BASE_VAL_DIV" name="BASE_VAL_DIV" style="width: 100px" <attr:selectfield/> >
                    </li>
                    <li>
                        <label for="DOC_ITEM">수출신고항목코드</label>
                        <input id="DOC_ITEM" name="DOC_ITEM" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="API_ITEM_NM">API항목명</label>
                        <input id="API_ITEM_NM" name="API_ITEM_NM" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="BASE_VAL">기본값</label>
                        <input id="BASE_VAL" name="BASE_VAL" style="width:calc(100% - 300px)"/>
                    </li>

                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <label for="SEARCH_TXT" style="display: none">검색조건 TEXT</label>
                        <select id="SEARCH_COL" name="SEARCH_COL" style="width: 100px" <attr:changeNoSearch/> >
                            <option value="NODE_NM">노드명</option>
                            <option value="TABLE_NM">테이블명</option>
                            <option value="COLUMN_NM">칼럼명</option>
                            <option value="ORDR">순서</option>
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
