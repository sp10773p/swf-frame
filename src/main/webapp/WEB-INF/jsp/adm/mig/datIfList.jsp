<%--
    Class Name : datIfList.jsp
    Description : DATA I/F 관리
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
            asisTableName  : "",
            tobeTableName  : ""
        };
        var fileUtil;
        var gridWrapper, headers, gridWrapper2, headers2;
        $(function () {
            headers = [
                {"HEAD_TEXT": "AS-IS 테이블"  , "WIDTH": "200", "FIELD_NAME": "ASIS_TABLE"},
                {"HEAD_TEXT": "TO-BE 테이블"  , "WIDTH": "200", "FIELD_NAME": "TOBE_TABLE"   , "LINK":"fn_detail"},
                {"HEAD_TEXT": "데이터이관구분", "WIDTH": "80" , "FIELD_NAME": "DATA_MIG_TYPE_NM" }
            ];

            headers2 = [
                {"HEAD_TEXT": "ASIS 테이블명", "WIDTH": "200", "FIELD_NAME": "ASIS_TABLE",     "FIELD_TYPE":"TXT"},
                {"HEAD_TEXT": "ASIS 컬럼명"  , "WIDTH": "150", "FIELD_NAME": "ASIS_COL",       "FIELD_TYPE":"TXT"},
                {"HEAD_TEXT": "TOBE 테이블명", "WIDTH": "200", "FIELD_NAME": "TOBE_TABLE"},
                {"HEAD_TEXT": "TOBE 컬럼명"  , "WIDTH": "150", "FIELD_NAME": "TOBE_COL"},
                {"HEAD_TEXT": "변환규칙"     , "WIDTH": "200", "FIELD_NAME": "SUB",            "FIELD_TYPE":"TXT"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "테이블변경 조회",
                "qKey"         : "mig.selectMigTableList",
                "targetLayer"  : "gridLayer",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "firstLoad"    : false,
                "postScript"   : function () {fn_detail(0)},
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });

            gridWrapper2 = new GridWrapper({
                "actNm"             : "DATA I/F 조회",
                "targetLayer"       : "gridLayer2",
                "qKey"              : "mig.selectDataMigList",
                "headers"           : headers2,
                "countId"           : "totCnt2",
                "firstLoad"         : false,
                "controllers": [
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });

            fileUtil = new FileUtil({
                "id"           : "file",
                "addBtnId"     : "btnUpload",
                "addUrl"       : "/mig/saveDataMig.do",
                "extNames"     : ["xls", "xlsx"],
                "isFileWrite"  : false,
                "successCallback" : function (data) {
                    gridWrapper2.addParam("TABLE_NAME", data.data.TOBE_TABLE);
                    gridWrapper2.requestToServer();
                }
            });

            $('#SEARCH_TXT').on("keyup", function () {
                this.value = this.value.toUpperCase();
            });

            // 그리드 저장
            $('#btnSave').on('click', function () {
                fn_save();
            });

            // WHERE조건 저장
            $('#btnSaveJoin').on('click', function () {
                fn_saveJoin();
            });

            // 매핑정의서 출력
            $('#btnReport').on('click', function () {
                fn_report();
            });

            // 전체 매핑정의서 출력
            $('#btnReportAll').on('click', function () {
                fn_reportAll();
            });

            // 전체 SCRIPT 출력
            $('#btnDataScript').on('click', function () {
                fn_dataScript();
            });

            $('#MIG_TYPE').on('change', function () {
                $('#DATA_MIG_TYPE').val("");
            });

            gridWrapper.requestToServer();
        });

        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var dataList = gridWrapper2.getData();

            $.comm.send("/mig/updateDataMig.do", dataList, function () {
                gridWrapper2.requestToServer();
            }, "인터페이스매핑 저장");

        }

        function fn_saveJoin() {
            if($.comm.isNull(globalVar.tobeTableName)){
                alert($.comm.getMessage("W00000003")); // 선택한 데이터가 없습니다.
                return;
            }

            var param = {
                "qKey"       : "mig.updateJoin",
                "JOIN"       : $('#JOIN').val(),
                "ASIS_TABLE" : globalVar.asisTableName,
                "TOBE_TABLE" : globalVar.tobeTableName
            };
            $.comm.send("/common/update.do", param, function () {
                gridWrapper.requestToServer();
            }, "JOIN 저장");
        }

        function fn_detail(index) {
            if(gridWrapper.getSize() == 0){
                gridWrapper2.drawGrid();
                return;
            }
            var data = gridWrapper.getRowData(index);

            globalVar.asisTableName = data["ASIS_TABLE"];
            globalVar.tobeTableName = data["TOBE_TABLE"];
            gridWrapper2.addParam("TABLE_NAME", data["TOBE_TABLE"]);
            gridWrapper2.requestToServer();

            $('#JOIN').val(data["JOIN"]);

            $.comm.send("/mig/selectScript.do", data, function (data) {
                var ret = data.data;

                $('#SCRIPT').val(ret["RET_MAP"]);
            }, "SCRIPT 조회");
        }

        var executeExcel = function (type) {
            if (!confirm("전체 매핑정의서를 다운로드 하시겠습니까?")) {
                return;
            }

            var params = $.extend({}, globalVar);
            params["TYPE"] = $.comm.isNull(type) ? "ONE" : type;

            $.comm.fileDownload(null, "전체 매핑정의서 다운로드", "<c:out value="/mig/printReport.do"/>");
        }

        function fn_report() {
            executeExcel();
        }

        function fn_reportAll() {
            executeExcel("ALL");
        }

        function fn_dataScript() {
            if (!confirm("전체 DATA SCRIPT를 다운로드 하시겠습니까?")) {
                return;
            }

            $.comm.fileDownload(null, "데이터이관스크립트 다운로드", "<c:out value="/mig/printScript.do"/>");
        }

    </script>
</head>
<body>

<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <input type="hidden" name="MIG_TYPE" value="M">
            <div class="search_frame">
                <ul class="search_sectionB">
                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <select id="SEARCH_COL" name="SEARCH_COL">
                            <option value="TOBE_TABLE">TO-BE 테이블</option>
                            <option value="ASIS_TABLE">AS-IS 테이블</option>
                        </select>
                        <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" style="width: calc(100% - 300px)" />
                    </li>
                    <%--<li>
                        <label for="MIG_TYPE">데이터이관구분</label>
                        <select id="MIG_TYPE" name="MIG_TYPE" <attr:changeNoSearch/> >
                            <option value="M">테이블변경</option>
                            <option value="N">신규생성</option>
                        </select>
                    </li>--%>
                    <li>
                        <label for="DATA_MIG_TYPE">데이터이관구분</label>
                        <select id="DATA_MIG_TYPE" name="DATA_MIG_TYPE" <attr:changeNoSearch/> >
                            <option value="">선택</option>
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
        <div class="vertical_frame_left46">
            <div class="white_frame">
                <div class="util_frame">
                    <p class="total">Total <span id="totCnt"></span></p>
                    <a href="#전체SCRIPT" class="btn white_147" id="btnDataScript">전체 DATA SCRIPT</a>
                    <a href="#전체매핑정의서" class="btn white_147" id="btnReportAll">전체 매핑정의서</a>
                </div>
                <div id="gridLayer" style="height: 400px">
                </div>
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer">
                    </div>
                </div>
            </div>
            <div class="white_frame">
                <div class="util_frame">
                    <p class="util_title"><label for="JOIN">데이터추출 조건</label></p>
                    <a href="#저장" class="btn blue_84" id="btnSaveJoin">저장</a>
                </div>
                <table class="table_typeA darkgray">
                    <tr>
                        <td>
                            <textarea name="JOIN" id="JOIN" rows="200" cols="200" style="padding: 5px; width: 100%; height: 350px" ></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="vertical_frame_right46">
            <div class="white_frame">
                <div class="util_frame">
                    <div class="util_left46">
                        <p class="total">Total <span id="totCnt2"></span></p>
                    </div>
                    <div class="util_right46">
                        <a href="#저장" class="btn white_84" id="btnSave">저장</a>
                        <a href="#업로드" class="btn white_84" id="btnUpload">엑셀 업로드</a>
                        <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                        <a href="#매핑 정의서" class="btn white_100" id="btnReport">매핑 정의서</a>
                    </div>
                </div>
                <div id="gridLayer2" style="height: 460px">
                </div>
            </div>
            <div class="white_frame">
                <div class="util_frame">
                    <p class="util_title"><label for="SCRIPT">Script</label></p>
                </div>
                <table class="table_typeA darkgray">
                    <tr>
                        <td>
                            <textarea name="SCRIPT" id="SCRIPT" rows="200" cols="200" style="padding: 5px; width: 100%; height: 350px" ></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
