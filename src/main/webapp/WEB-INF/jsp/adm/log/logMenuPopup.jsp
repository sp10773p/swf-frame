<%--
    Class Name : logMngPopup.jsp
    Description : 로그필터관리 팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.02.27  성동훈   최초 생성
    author : 성동훈
    since : 2017.02.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
        var globalVar = {
            menuList : [],
            menuId   : "",
            isScreen : false
        }
        $(function () {

            $('#btnChoice').on('click', function () {
                fn_choice();
            })

            fn_drawMenuTree();
        });

        // 선택
        function fn_choice(){
            for(var i=0; i<globalVar.menuList.length; i++){
                var menu = globalVar.menuList[i];
                if($.comm.isNull(globalVar.menuId) ||
                    (menu.MENU_ID == globalVar.menuId && ($.comm.isNull(menu["MENU_URL"]) || $.comm.isNull(menu["MENU_PATH"])))) {

                    alert($.comm.getMessage("W00000052")); // 화면 메뉴를 선택하세요
                    return;
                }
            }

            $.comm.setModalReturnVal(globalVar.menuId);
            self.close();
        }

        // 메뉴 트리 생성
        function fn_drawMenuTree() {
            var param = {
                "qKey": "menu.selectCmmMenuTree"
            };
            var menuList = $.comm.sendSync("/common/selectList.do", param).dataList;
            globalVar.menuList = menuList;

            $.comm.drawTree("menuTree", menuList, "MENU_LEVEL", "MENU_NM", "fn_menuClick", "MENU_ID");
        }

        // 트리메뉴 클릭
        function fn_menuClick(menuId) {
            globalVar.menuId = menuId;
        }

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <div class="white_frame">
        <div class="util_frame">
            <a href="#선택" class="btn blue_84" id="btnChoice">선택</a>
        </div>
        <div class="inner_scroll_line" style="height:500px;">
            <div id="menuTree"></div><!-- dTree -->
        </div><!-- inner_scroll_line -->
    </div>

</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
