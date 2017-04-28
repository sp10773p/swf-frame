<%--
    Class Name : menuList.jsp
    Description : 메뉴관리
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
        var globaVar = {
            menuTreeList : []
        };
        var gridBtn, btnHeaders;
        $(function () {
            btnHeaders = [
                {"HEAD_TEXT": "버튼ID", "WIDTH": "120", "FIELD_NAME": "BTN_ID"},
                {"HEAD_TEXT": "버튼명", "WIDTH": "*", "FIELD_NAME": "BTN_NM", "LINK": "fn_detailBtn"}
            ];
            gridBtn = new GridWrapper({
                "actNm"         : "메뉴별 버튼조회",
                "targetLayer"   : "gridBtnLayer",
                "qKey"          : "menu.selectCmmMenuBtn",
                "headers"       : btnHeaders,
                "firstLoad"     : false,
                "check"         : true,
                "pageRow"       : 30,
                "controllers": [
                    {"btnName": "btnDelBtn", "type": "D", "targetURI": "/menu/deleteMenuBtn.do"}
                ]
            });

            // 신규
            $('#btnNew').on('click', function (e) {
                fn_new();
            });

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 삭제
            $('#btnDel').on('click', function (e) {
                fn_delete();
            });

            // 버튼신규
            $('#btnNewBtn').on('click', function (e) {
                fn_newBtn();
            });

            // 버튼저장
            $('#btnSaveBtn').on('click', function (e) {
                fn_saveBtn();
            });

            // 상위메뉴 선택
            $('#btnPmenu').on('click', function (e) {
                fn_pmenu();
            });

            // 메뉴구분
            $('#P_MENU_DIV').on('change', function (e) {
                fn_drawMenuTree();
            });

            $.comm.readonly(["MENU_ID", "PMENU_ID", "MENU_LEVEL"], true); // 메뉴코드, 상위메뉴코드, 메뉴레벨

            fn_select();
        });

        // 메뉴 트리 생성
        function fn_drawMenuTree() {
            var param = {
                "qKey": "menu.selectCmmMenuTree",
                "P_MENU_DIV" : $('#P_MENU_DIV').val()
            };
            var menuList = $.comm.sendSync("/common/selectList.do", param, "메뉴 트리 조회").dataList;
            $.comm.drawTree("menuTree", menuList, "MENU_LEVEL", "MENU_NM", "fn_menuClick", "MENU_ID");
            globaVar.menuTreeList = menuList;
        }

        // 트리메뉴 클릭
        function fn_menuClick(menuId) {
            $.comm.send("<c:out value="/common/select.do" />", {
                    "qKey": "menu.selectMenuDetail",
                    "MENU_ID": menuId
                },
                function (data, status) {
                    $('#detailForm')[0].reset();
                    $.comm.bindData(data.data);
                    $('#SAVE_MODE').val("U");
                    $('#ORG_PMENU_ID').val(data.data.PMENU_ID);

                },
                "메뉴상세 조회"
            );

            fn_btn(menuId);
        }

        // 버튼 리스트 조회
        function fn_btn(menuId) {
            var param = {
                "MENU_ID" : menuId
            };
            gridBtn.setParams(param);
            gridBtn.requestToServer();
        }

        // 상위메뉴코드 조회 팝업
        function fn_pmenu() {
            $.comm.setModalArguments({"MENU_DIV" : $('#P_MENU_DIV').val()});

            var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/menuPopup" />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                        $('#PMENU_ID').val(ret.MENU_ID); // 상위메뉴코드 지정
                        $('#MENU_DIV').val(ret.MENU_DIV);

                    }else{
                        $('#PMENU_ID').val(""); // 상위메뉴코드 지정
                        $('#MENU_DIV').val($('#P_MENU_DIV').val());

                    }
                }
            );
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_select();
            }
        };

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $('#detailForm')[0].reset();

        }

        // 버튼 신규
        function fn_newBtn() {
            $('#BTN_SAVE_MODE').val("I");
            $('#btnForm')[0].reset();

            $.comm.readonly('BTN_ID', false);
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }
            var orgPmenuId = $('#ORG_PMENU_ID').val();
            var pmenuId    = $('#PMENU_ID').val();

            $.comm.sendForm("<c:out value="/menu/saveMenu.do"/>", "detailForm", fn_callback, "메뉴 저장");
        }

        // 버튼 저장
        function fn_saveBtn() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var params = {
                "MENU_ID": $('#MENU_ID').val(),
                "BTN_ID": $('#BTN_ID').val(),
                "BTN_NM": $('#BTN_NM').val(),
                "BTN_SAVE_MODE": $('#BTN_SAVE_MODE').val()
            };
            $.comm.send("<c:out value="/menu/saveMenuBtn.do"/>", params,
                function (data) {
                    if (data.code.indexOf('I') == 0) {
                        fn_newBtn();
                        gridBtn.requestToServer();
                    }
                }, "메뉴별 버튼 저장");
        }

        // 조회
        function fn_select() {
            fn_drawMenuTree();
            fn_new();
        }

        // 삭제
        function fn_delete() {
            var saveMode = $('#SAVE_MODE').val();
            if (saveMode == "I") {
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return;
            }

            if (!confirm($.comm.getMessage("C00000001"))) { // 삭제 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:out value="/menu/deleteMenu.do"/>", "detailForm", fn_callback, "메뉴 삭제");
        }

        // 버튼 그리드 클릭
        function fn_detailBtn(index) {
            var data = gridBtn.getRowData(index);
            $('#BTN_ID').val(data.BTN_ID);
            $('#BTN_NM').val(data.BTN_NM);
            $('#BTN_SAVE_MODE').val("U");

            $.comm.readonly('BTN_ID', true);
        }

    </script>
</head>
<body>
<div id="content_body">
    <div class="vertical_frame">
        <div class="vertical_frame_left37">
            <div class="title_frame">
                <p><a href="#버튼정보" class="btnToggle">메뉴트리</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <label for="P_MENU_DIV" hidden>메뉴구분</label>
                        <select id="P_MENU_DIV" class="select" style="width: 100px">
                            <option value="W">사용자</option>
                            <option value="S">모바일</option>
                            <option value="M">어드민</option>
                        </select>
                    </div>
                    <div class="inner_scroll_line" style="height:750px;">
                        <div id="menuTree"></div><!-- dTree -->
                    </div><!-- inner_scroll_line -->
                </div><!-- //white_frame -->
            </div>
        </div><!-- vertical_frame_left -->

        <div class="vertical_frame_right37">
            <div class="title_frame">
                <p><a href="#메뉴정보" class="btnToggle">메뉴정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#메뉴삭제" class="btn blue_84" id="btnDel">삭제</a>
                        <a href="#메뉴저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#메뉴신규" class="btn blue_84" id="btnNew">신규</a>
                    </div>

                    <form name="detailForm" id="detailForm">
                        <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                        <input type="hidden" id="ORG_PMENU_ID" name="ORG_PMENU_ID">
                        <input type="hidden" id="IS_LEVEL_DIFF" name="IS_LEVEL_DIFF">
                        <div class="table_separation">
                            <div class="table_typeA darkgray">
                                <table style="table-layout:fixed;">
                                    <caption class="blind">메뉴정보</caption>
                                    <colgroup>
                                        <col width="107px"/>
                                        <col width="*"/>
                                    </colgroup>
                                    <tr>
                                        <td><label for="MENU_ID">메뉴코드</label></td>
                                        <td>
                                            <input type="text" name="MENU_ID" id="MENU_ID"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_NM">메뉴명</label></td>
                                        <td>
                                            <input type="text" name="MENU_NM" id="MENU_NM"
                                            <attr:mandantory/> <attr:length value="50"/>>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_PATH">메뉴경로</label></td>
                                        <td>
                                            <input type="text" name="MENU_PATH" id="MENU_PATH" <attr:length value="100"/>/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="DASH_PATH">대시보드 경로</label></td>
                                        <td>
                                            <input type="text" name="DASH_PATH" id="DASH_PATH" <attr:length value="100"/>/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_LEVEL">메뉴레벨</label></td>
                                        <td>
                                            <input type="text" name="MENU_LEVEL" id="MENU_LEVEL">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_DC">메뉴설명</label></td>
                                        <td>
                                            <input type="text" name="MENU_DC" id="MENU_DC" <attr:length value="500"/>/>
                                        </td>
                                    </tr>
                                </table>
                            </div><!-- //table_typeA -->
                        </div>
                        <div class="table_separation">
                            <div class="table_typeA darkgray">
                                <table style="table-layout:fixed;">
                                    <caption class="blind">메뉴정보</caption>
                                    <colgroup>
                                        <col width="107px"/>
                                        <col width="*"/>
                                    </colgroup>
                                    <tr>
                                        <td><label for="PMENU_ID">상위메뉴코드</label></td>
                                        <td class="td_input_recheck">
                                            <input type="text" name="PMENU_ID" id="PMENU_ID" style="width: calc(100% - 96px)" <attr:mandantory/>>
                                            <a href="#상위메뉴" class="btn" id="btnPmenu">상위메뉴</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_DIV">메뉴구분</label></td>
                                        <td>
                                            <select id="MENU_DIV" name="MENU_DIV" <attr:mandantory/> >
                                                <option value="W">사용자</option>
                                                <option value="S">모바일</option>
                                                <option value="M">어드민</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_URL">메뉴URL</label></td>
                                        <td>
                                            <input type="text" name="MENU_URL" id="MENU_URL" <attr:length value="100"/>>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="DASH_URL">대시보드 URL</label></td>
                                        <td>
                                            <input type="text" name="DASH_URL" id="DASH_URL" <attr:length value="100"/>/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="LINK_YN">메뉴표시여부</label></td>
                                        <td>
                                            <select id="LINK_YN" name="LINK_YN">
                                                <option value="Y">Y</option>
                                                <option value="N">N</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="MENU_ORDR">메뉴순서</label></td>
                                        <td>
                                            <input type="text" name="MENU_ORDR" id="MENU_ORDR" <attr:numberOnly value="true"/> <attr:length value="10"/> />
                                        </td>
                                    </tr>
                                </table>
                            </div><!-- //table_typeA -->
                        </div>
                    </form>
                </div>
                <div class="title_frame">
                    <p><a href="#버튼정보" class="btnToggle">버튼정보</a></p>
                    <div class="white_frame">
                        <div class="util_frame">
                            <p class="total">Total <span id="totCnt">0</span></p>
                            <a href="#버튼삭제" class="btn blue_84" id="btnDelBtn">삭제</a>
                            <a href="#버튼저장" class="btn blue_84" id="btnSaveBtn">저장</a>
                            <a href="#버튼신규" class="btn blue_84" id="btnNewBtn">신규</a>
                        </div><!-- //util_frame -->
                        <div class="vertical_frame">
                            <div class="vertical_frame_left64">
                                <div class="list_typeB" id="gridBtnLayer">
                                </div><!-- //list_typeB -->
                            </div>
                            <div class="vertical_frame_right64">
                                <form id="btnForm" name="btnForm">
                                    <input type="hidden" id="BTN_SAVE_MODE" name="BTN_SAVE_MODE" value="I">
                                    <div class="table_typeA darkgray">
                                        <table style="table-layout:fixed;">
                                            <colgroup>
                                                <col width="132px">
                                                <col width="*">
                                            </colgroup>
                                            <tbody><tr>
                                                <td><label for="BTN_ID">버튼ID</label></td>
                                                <td>
                                                    <input type="text" name="BTN_ID" id="BTN_ID" <attr:mandantory/> <attr:length value="15"/>/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><label for="BTN_NM">버튼명</label></td>
                                                <td>
                                                    <input type="text" name="BTN_NM" id="BTN_NM" <attr:mandantory/> <attr:length value="20"/>/>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div><!-- //white_frame -->
            </div>
        </div><!-- //vertical_frame_right -->
    </div><!-- //vertical_frame -->
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
