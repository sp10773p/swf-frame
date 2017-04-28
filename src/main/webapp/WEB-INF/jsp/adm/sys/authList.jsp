<%--
    Class Name : authList.jsp
    Description : 권한 관리
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
            authCd   : "",
            menuId   : "",
            menuNm   : ""
        };
        var gridAuth, gridMenuBtn, authHeaders, menuBtnHeaders;
        $(function () {
            authHeaders = [
                {"HEAD_TEXT": "권한코드" , "WIDTH": "150" , "FIELD_NAME": "AUTH_CD", "LINK":"fn_detail", "POSIT":true},
                {"HEAD_TEXT": "권한명"   , "WIDTH": "*"   , "FIELD_NAME": "AUTH_NM"},
                {"HEAD_TEXT": "사용여부" , "WIDTH": "120" , "FIELD_NAME": "USE_YN"}
            ];

            menuBtnHeaders = [
                {"HEAD_TEXT": "버튼ID" , "WIDTH": "150", "FIELD_NAME": "BTN_ID"},
                {"HEAD_TEXT": "버튼명" , "WIDTH": "*"  , "FIELD_NAME": "BTN_NM", "ALIGN":"left"}
            ];

            gridAuth = new GridWrapper({
                "actNm"        : "권한 조회",
                "targetLayer"  : "gridAuthLayer",
                "qKey"         : "auth.selectCmmAuth",
                "headers"      : authHeaders,
                "firstLoad"    : false,
                "check"        : true,
                "displayNone"  : ["countId"],
                "postScript"   : function (){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnDel"   , "type": "D", "targetURI": "/auth/deleteAuth.do"}
                ]
            });

            gridMenuBtn = new GridWrapper({
                "actNm"        : "메뉴별버튼권한 조회",
                "targetLayer"  : "gridMenuBtnLayer",
                "qKey"         : "auth.selectCmmMenuBtnAuth",
                "headers"      : menuBtnHeaders,
                "firstLoad"    : false,
                "displayNone"  : ["countId", "pageRowCombo"],
                "check"        : true
            });

            // 신규
            $('#btnNew').on('click', function (e) {
                fn_new();
            });

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 버튼권한 저장
            $('#btnSaveBtn').on('click', function (e) {
                fn_saveBtnAuth();
            });

            // 메뉴구분 변겨
            $('#MENU_DIV').on('change', function (e) {
                fn_drawMenuTree();
            });

            fn_select();
        });

        // 메뉴 트리 생성
        function fn_drawMenuTree() {
            var param = {
                "qKey": "auth.selectCmmAuthMenu",
                "AUTH_CD"  : globalVar.authCd,
                "MENU_DIV" : $('#MENU_DIV').val()
            };
            var menuList = $.comm.sendSync("/common/selectList.do", param).dataList;
            $.comm.drawTree("menuTree", menuList, "MENU_LEVEL", "MENU_NM", "fn_btnAuth", "MENU_ID", "PMENU_ID", "MENU_NM", true, fn_menuCheckClick);
        }

        // 메뉴 트리 체크박스 체크시 상위 체크 및 하위 체크해제
        function fn_menuCheckClick(){
            var chk = this.checked;
            if(chk == true){
                var pid = $(this).attr("pid");
                while(true) {
                    var pObj = $('#' + pid);
                    if(pObj.length == 0){
                        break;
                    }

                    $(pObj).prop("checked", true);
                    pid = $(pObj).attr("pid");
                }
            }else if(chk == false){
                var treeRemoveCheck = function (obj){
                    $.each($(obj), function () {
                        $(this).prop("checked", false);
                        var id = $(this).attr("id");
                        treeRemoveCheck($("input[pid="+id+"]"));
                    })
                };
                var id = $(this).attr("id");
                treeRemoveCheck($("input[pid="+id+"]"));
            }
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_select();
            }
        };

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $.comm.readonly("AUTH_CD", false);
            $('#detailForm')[0].reset();

            fn_detail();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            if($.comm.validation("detailForm") == false){
                return;
            }

            var menuAuth = [];
            $.each($('input[name=check]'), function () {
                var chk = this.checked;
                //if(chk == true){
                    var menuMap = {};
                    menuMap["MENU_ID"] = $(this).attr("id");
                    menuMap["CHK"]     = (chk ? "1" : "0");
                    menuAuth.push(menuMap);
                //}
            });

            var param = {
                "auth"     : $.comm.getFormData("detailForm"),
                "MENU_DIV" : $('#MENU_DIV').val(),
                "menuAuth" : menuAuth
            };
            $.comm.send("/auth/saveAuth.do", param, fn_callback, "권한정보 저장");
        }

        // 버튼권한 저장
        function fn_saveBtnAuth() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var param = {
                "AUTH_CD"  : globalVar.authCd,
                "MENU_ID"  : globalVar.menuId,
                "btnAuth"  : gridMenuBtn.getSelectedRows()
            };

            $.comm.send("/auth/saveBtnAuth.do", param, null, "메뉴별 버튼권한 저장");
        }

        // 조회
        function fn_select() {
            gridAuth.requestToServer();
        }

        // 메뉴 조회
        function fn_detail(index) {
            // 신규 클릭시
            if($.comm.isNull(index)){
                globalVar.authCd  = "";
                globalVar.menuId  = "";

                fn_drawMenuTree();

                $("input[name='check']").prop("checked", false);
                return;
            }

            var data = {};
            var size = gridAuth.getSize();
            if(size == 0){
                globalVar.authCd  = "";
                globalVar.menuId  = "";
            }else{
                data = gridAuth.getRowData(index);
                $.comm.bindData(data);
                $.comm.readonly("AUTH_CD", true);

                $('#SAVE_MODE').val("U");

                globalVar.authCd = data.AUTH_CD;

                $('#menuAuthTitle').html(data.AUTH_NM + " 메뉴권한 정보");

                fn_drawMenuTree();
            }

            fn_btnAuth();
        }

        // 버튼 권한 조회
        function fn_btnAuth(menuId, pMenuId, menuNm) {
            if(!menuId){
                gridMenuBtn.drawGrid();
                $('#btnAuthTitle').html("버튼권한 정보");
                return;
            }
            $('#btnAuthTitle').html(menuNm + " 버튼권한 정보");

            var data = {
                "AUTH_CD" : globalVar.authCd,
                "MENU_ID" : menuId
            };

            var isChecked = $("input:checkbox[id='"+menuId+"']").is(":checked") ;

            if(isChecked == false){
                gridMenuBtn.check = false;
            }else{
                gridMenuBtn.check = true;
            }

            gridMenuBtn.drawGrid();

            gridMenuBtn.setParams(data);
            gridMenuBtn.requestToServer();

            globalVar.menuId = menuId;
            globalVar.menuNm = menuNm;
        }
    </script>
</head>
<body>
<div id="content_body">
    <div class="vertical_frame">
        <div class="vertical_frame_left64">
            <div class="title_frame">
                <p><a href="#권한정보" class="btnToggle">권한정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#삭제" class="btn white_84" id="btnDel">삭제</a>
                    </div>
                    <div id="gridAuthLayer" style="height: 300px">
                    </div>
                    <div class="util_frame">
                        <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
                    </div>
                    <form name="detailForm" id="detailForm">
                        <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                        <div class="table_typeA darkgray">
                            <table style="table-layout:fixed;">
                                <caption class="blind">메뉴정보</caption>
                                <colgroup>
                                    <col width="107px"/>
                                    <col width="*"/>
                                    <col width="107px"/>
                                    <col width="*"/>
                                    <col width="107px"/>
                                    <col width="107px"/>
                                </colgroup>
                                <tr>
                                    <td><label for="AUTH_CD">권한코드</label></td>
                                    <td>
                                        <input type="text" name="AUTH_CD" id="AUTH_CD" <attr:mandantory/> />
                                    </td>
                                    <td><label for="AUTH_NM">권한명</label></td>
                                    <td>
                                        <input type="text" name="AUTH_NM" id="AUTH_NM" <attr:mandantory/> <attr:length value="50" />>
                                    </td>
                                    <td><label for="USE_YN">사용여부</label></td>
                                    <td>
                                        <select id="USE_YN" name="USE_YN">
                                            <option value="Y" selected>사용</option>
                                            <option value="N">미사용</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
            <div class="title_frame">
                <p><a href="#버튼권한 정보" class="btnToggle">버튼권한 정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#버튼권한 저장" class="btn white_100" id="btnSaveBtn">버튼권한 저장</a>
                    </div>
                    <div id="gridMenuBtnLayer">
                    </div>
                </div>
            </div>
        </div><%-- vertical_frame_left64 --%>
        <div class="vertical_frame_right64">
            <div class="title_frame">
                <p><a href="#메뉴권한 정보" class="btnToggle" id="menuAuthTitle">메뉴권한 정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <label for="MENU_DIV" hidden>메뉴구분</label>
                        <select id="MENU_DIV" class="select" style="width: 100px">
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
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
