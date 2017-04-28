<%--
    Class Name : tabModList.jsp
    Description : 테이블 변경관리
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
        var gridWrapper, headers, gridWrapper2, headers2, gridWrapper3, headers3, gridWrapper4, headers4;
        $(function (){
            headers = [
                {"HEAD_TEXT": "테이블명"      , "WIDTH": "150", "FIELD_NAME": "TABLE_COMMENT"},
                {"HEAD_TEXT": "AS-IS 테이블"  , "WIDTH": "200", "FIELD_NAME": "ASIS_TABLE_NAME"},
                {"HEAD_TEXT": "TO-BE 테이블"  , "WIDTH": "200", "FIELD_NAME": "TOBE_TABLE_NAME"   , "LINK":"fn_detail"},
                {"HEAD_TEXT": "이관구분"      , "WIDTH": "100", "FIELD_NAME": "MIG_TYPE_NM" },
                {"HEAD_TEXT": "데이터이관구분", "WIDTH": "100", "FIELD_NAME": "DATA_MIG_TYPE_NM" }
            ];

            headers2 = [
                {"HEAD_TEXT": "TO-BE 테이블"  , "WIDTH": "150", "FIELD_NAME": "TABLE_NAME"},
                {"HEAD_TEXT": "컬럼명"        , "WIDTH": "200", "FIELD_NAME": "COLUMN_NAME" },
                {"HEAD_TEXT": "변경내용"      , "WIDTH": "*"  , "FIELD_NAME": "MODIFY_DESC" }
            ];

            headers3 = [
                {"HEAD_TEXT": "INDEX 명"      , "WIDTH": "120", "FIELD_NAME": "INDEX_NAME"},
                {"HEAD_TEXT": "컬럼명"        , "WIDTH": "100", "FIELD_NAME": "COLUMN_NAME" },
                {"HEAD_TEXT": "컬럼 POSITION" , "WIDTH": "100", "FIELD_NAME": "COLUMN_POSITION" }
            ];

            headers4 = [
                {"HEAD_TEXT": "INDEX 명"      , "WIDTH": "120", "FIELD_NAME": "INDEX_NAME"},
                {"HEAD_TEXT": "컬럼명"        , "WIDTH": "100", "FIELD_NAME": "COLUMN_NAME" },
                {"HEAD_TEXT": "컬럼 POSITION" , "WIDTH": "100", "FIELD_NAME": "COLUMN_POSITION" }
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "테이블변경 조회",
                "targetLayer"  : "gridLayer",
                //"requestUrl"   : "/mig/selectTabModList.do",
                "qKey"         : "selectMigTableMngExcel",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel", "type": "D", "qKey":"deleteMigTableMng"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            gridWrapper2 = new GridWrapper({
                "actNm"        : "변경컬럼 정보 조회",
                "targetLayer"  : "gridLayer2",
                "requestUrl"   : "/mig/selectTabColModList.do",
                "headers"      : headers2,
                "displayNone"  : ["countId"],
                "firstLoad"    : false,
                "controllers"  : [
                    {"btnName": "btnExcel2" , "type": "EXCEL"}
                ]
            });

            gridWrapper3 = new GridWrapper({
                "actNm"        : "AS-IS INDEX 조회",
                "targetLayer"  : "gridLayer3",
                "requestUrl"   : "/mig/selectTabIndexList.do",
                "paramsGetter" : {"TYPE": "ASIS"},
                "headers"      : headers3,
                "displayNone"  : ["countId"],
                "firstLoad"    : false
            });

            gridWrapper4 = new GridWrapper({
                "actNm"        : "TO-BE INDEX 조회",
                "targetLayer"  : "gridLayer4",
                "requestUrl"   : "/mig/selectTabIndexList.do",
                "paramsGetter" : {"TYPE": "TOBE"},
                "headers"      : headers4,
                "displayNone"  : ["countId"],
                "firstLoad"    : false
            });

            //신규
            $('#btnNew').on("click", function (e) {
                fn_new();
            });

            //저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            //이관스크립트
            $('#btnScript').on('click', function (e) {
                fn_script();
            });

            $('#SEARCH_TXT').on("keyup", function () {
                this.value = this.value.toUpperCase();
            })
        });

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");

            $.comm.readonly(['ASIS_TABLE', 'TOBE_TABLE'], false);

            $('#detailForm')[0].reset();

            gridWrapper2.initializeLayer();
            gridWrapper3.initializeLayer();
            gridWrapper4.initializeLayer();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:out value="/mig/saveMigTableMng.do"/>", "detailForm", fn_callback, "변경테이블이관 저장");
        }

        // 이관스크립트
        function fn_script() {
            if (!confirm("이관 스크립트를 다운로드 하시겠습니까?")) {
                return;
            }

            $.comm.fileDownload(null, "이관스크립트 다운로드", "<c:out value="/mig/scriptDownload.do"/>");
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_new();
                gridWrapper.requestToServer();
            }
        };

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            $('#SAVE_MODE').val("U");

            $('#ORG_ASIS_TABLE').val(data["ASIS_TABLE_NAME"]);
            $('#ORG_TOBE_TABLE').val(data["TOBE_TABLE_NAME"]);

            $('#ASIS_TABLE').val(data["ASIS_TABLE_NAME"]);
            $('#TOBE_TABLE').val(data["TOBE_TABLE_NAME"]);
            $('#MIG_TYPE').val(data["MIG_TYPE"]);
            $('#DATA_MIG_TYPE').val(data["DATA_MIG_TYPE"]);

            $.comm.readonly(['ASIS_TABLE', 'TOBE_TABLE'], true);

            if(data["MIG_TYPE"] == "N"){
                gridWrapper2.drawGrid();
                gridWrapper3.drawGrid();
                gridWrapper4.drawGrid();
            }else{
                gridWrapper2.setParams(data);
                gridWrapper2.requestToServer();

                gridWrapper3.setParams(data);
                gridWrapper3.requestToServer();

                gridWrapper4.setParams(data);
                gridWrapper4.requestToServer();
            }
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
                        <label for="SEARCH_COL">검색조건</label>
                        <select id="SEARCH_COL" name="SEARCH_COL">
                            <option value="TOBE_TABLE">TO-BE 테이블</option>
                            <option value="ASIS_TABLE">AS-IS 테이블</option>
                        </select>
                        <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" style="width: calc(100% - 300px)"/>
                    </li>
                    <%--<li>
                        <label for="IS_COL_MOD">컬럼변경여부</label>
                        <select id="IS_COL_MOD" name="IS_COL_MOD">
                            <option value="">선택</option>
                            <option value="Y">Y</option>
                            <option value="N">N</option>
                        </select>
                    </li>--%>
                    <li>
                        <label for="P_MIG_TYPE">이관구분</label>
                        <select id="P_MIG_TYPE" name="P_MIG_TYPE">
                            <option value="">선택</option>
                            <option value="M">테이블변경</option>
                            <option value="N">신규생성</option>
                        </select>
                    </li>
                    <li>
                        <label for="P_DATA_MIG_TYPE">데이터이관구분</label>
                        <select id="P_DATA_MIG_TYPE" name="P_DATA_MIG_TYPE">
                            <option value="">선택</option>
                            <option value="X">필요없음</option>
                            <option value="A">1:1이관</option>
                            <option value="C">N:1이관</option>
                            <option value="N">신규이관</option>
                        </select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left64">
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                    <a href="#삭제" class="btn white_100" id="btnDel">삭제</a>
                    <a href="#이관스크립트" class="btn white_100" id="btnScript">이관스크립트</a>
                </div>
                <div id="gridLayer" style="height: 410px">
                </div>
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer">
                    </div>
                </div>
            </div>
        </div>

        <div class="vertical_frame_right64">
            <div class="white_frame">
                <div class="util_frame">
                    <div class="util_left46">
                        <p class="util_title">변경테이블 정보</p>
                    </div>
                    <div class="util_right46">
                        <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
                    </div>
                </div>
                <form name="detailForm" id="detailForm">
                    <input type="hidden" id="ORG_ASIS_TABLE" name="ORG_ASIS_TABLE">
                    <input type="hidden" id="ORG_TOBE_TABLE" name="ORG_TOBE_TABLE">
                    <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                    <div class="table_typeA darkgray table_toggle">
                        <table style="table-layout:fixed;" >
                            <colgroup>
                                <col width="145px"/>
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ASIS_TABLE">AS-IS 테이블</label></td>
                                <td><input type="text" name="ASIS_TABLE" id="ASIS_TABLE"></td>
                            </tr>
                            <tr>
                                <td><label for="TOBE_TABLE">TO-BE 테이블</label></td>
                                <td><input type="text" name="TOBE_TABLE" id="TOBE_TABLE" <attr:mandantory/>/></td>
                            </tr>
                            <tr>
                                <td><label for="MIG_TYPE">이관구분</label></td>
                                <td>
                                    <select id="MIG_TYPE" name="MIG_TYPE">
                                        <option value="M">테이블변경</option>
                                        <option value="N">신규생성</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="DATA_MIG_TYPE">데이터이관구분</label></td>
                                <td>
                                    <select id="DATA_MIG_TYPE" name="DATA_MIG_TYPE">
                                        <option value="X">필요없음</option>
                                        <option value="A">1:1</option>
                                        <option value="C">N:1</option>
                                        <option value="N">신규이관</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="title_frame">
                <p><a href="#변경컬럼 정보" class="btnToggle">변경컬럼 정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel2">엑셀 다운로드</a>
                    </div>
                    <div id="gridLayer2" style="height: 210px">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="title_frame">
        <p><a href="#INDEX 정보 비교" class="btnToggle">INDEX 정보 비교</a></p>
        <div class="vertical_frame">
            <div class="vertical_frame_left55">
                <div class="white_frame">
                    <div class="util_frame">
                        <p class="util_title">AS-IS INDEX</p>
                    </div>
                    <div id="gridLayer3" style="height: 150px">
                    </div>
                </div>
            </div>
            <div class="vertical_frame_right55">
                <div class="white_frame">
                    <div class="util_frame">
                        <p class="util_title">TO-BE INDEX</p>
                    </div>
                    <div id="gridLayer4" style="height: 150px">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
