<%--
    Class Name : keyList.jsp
    Description : KEY관리
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
        var gridMaster, gridDetail, headers, headersDetail;
        $(function (){
            headers = [
                {"HEAD_TEXT": "사용자ID"    , "WIDTH": "100", "FIELD_NAME": "USER_ID", "LINK":"fn_detail"},
                {"HEAD_TEXT": "APIKey"      , "WIDTH": "500", "FIELD_NAME": "API_KEY"},
                {"HEAD_TEXT": "유효기간시작", "WIDTH": "100", "FIELD_NAME": "VALID_FROM_DT"},
                {"HEAD_TEXT": "유효기간종료", "WIDTH": "100", "FIELD_NAME": "VALID_TO_DT"},
                {"HEAD_TEXT": "API키상태"   , "WIDTH": "80" , "FIELD_NAME": "API_REQ_STATUS_NM"},
                {"HEAD_TEXT": "API신청일자" , "WIDTH": "100", "FIELD_NAME": "API_REQ_DT"},
                {"HEAD_TEXT": "API승인일자" , "WIDTH": "100", "FIELD_NAME": "API_APPORVE_DT"}
            ];

            headersDetail = [
                {"HEAD_TEXT": "APIKey"         , "WIDTH": "500", "FIELD_NAME": "API_KEY", "LINK":"fn_logDetail"},
                {"HEAD_TEXT": "API설명"        , "WIDTH": "200", "FIELD_NAME": "API_NM" },
                {"HEAD_TEXT": "월최대처리건수" , "WIDTH": "100", "FIELD_NAME": "LIMIT_DETAIL_CNT", "FIELD_TYPE":"NUM"},
                {"HEAD_TEXT": "일일호출건수"   , "WIDTH": "100", "FIELD_NAME": "DAILY_CALL_CNT"  , "FIELD_TYPE":"NUM"},
                {"HEAD_TEXT": "회당처리건수"   , "WIDTH": "100", "FIELD_NAME": "PER_CALL_CNT"    , "FIELD_TYPE":"NUM"}
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "API키관리 조회",
                "targetLayer"  : "gridMasterLayer",
                "qKey"         : "api.selectCmmApiKeyMngList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "countId"      : "totCnt",
                "scrollPaging" : true,
                "firstLoad"    : false,
                "postScript"   : function (){fn_detail(0);},
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });

            gridDetail = new GridWrapper({
                "actNm"        : "API키관리상세 조회",
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "api.selectCmmApiKeyDtlList",
                "headers"      : headersDetail,
                "countId"      : "totDetailCnt",
//                "scrollPaging" : true,
                "firstLoad"    : false
            });

            // 항목저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            $('#btnSearch').click(); // postScript 실행시 gridDetail 객체를 확보하기 위해 GridWrapper 생성후 조회
        });

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                $('#btnSearch').click();
            }
        };

        // 항목저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000014"))) { // 항목저장 하시겠습니까?
                return;
            }

            var modDataList = gridDetail.getUpdateData();
            if(modDataList.length == 0){
                alert($.comm.getMessage("I00000013"));// 변경된 내용이 없습니다.
                return;
            }
            $.comm.send("/adm/api/saveApiKeyDtl.do", modDataList, fn_callback, "항목저장");
        }

        function fn_detail(index){
            var size = gridMaster.getSize();
            if(size == 0){
                gridDetail.drawGrid();
                return;
            }
            var data = gridMaster.getRowData(index);
            gridDetail.setParams(data);
            gridDetail.requestToServer();
        }

        // API처리내역
        function fn_logDetail(index) {
            var data = gridDetail.getRowData(index);
            $.comm.forward("adm/api/keyDetail", data);
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
                        <label for="F_API_REQ_DT">API신청일자</label><label for="T_API_REQ_DT"
                                                                  style="display: none">API신청일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_API_REQ_DT" name="F_API_REQ_DT" class="input" <attr:datefield to="T_API_REQ_DT" value="-1m"/> />
                                    <span>~</span>
                                    <input type="text" id="T_API_REQ_DT" name="T_API_REQ_DT" class="input" <attr:datefield  value="0"/>/>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="USER_ID">판매자ID</label>
                        <input id="USER_ID" name="USER_ID" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <label for="SEARCH_TXT" style="display: none">검색조건 TEXT</label>
                        <select id="SEARCH_COL" name="SEARCH_COL" style="width: 100px">
                            <option value="API_KEY">APIKey</option>
                        </select>
                        <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" style="width:calc(100% - 300px)"/>
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
                <a href="#엑셀다운로드" class="btn white_100" id="btnExcel">엑셀다운로드</a>
            </div>
            <div id="gridMasterLayer" style="height: 160px;">
            </div>
        </div>
    </div>
    <div class="title_frame">
        <p><a href="#API키관리상세" class="btnToggle">API키관리상세</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#엑셀다운로드" class="btn white_100" id="btnSave">항목저장</a>
            </div>
            <div id="gridDetailLayer" style="height: 180px;">
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
