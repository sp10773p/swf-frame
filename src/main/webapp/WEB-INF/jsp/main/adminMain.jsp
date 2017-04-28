<%--
    Class Name : adminMain.jsp
    Description : 어드민사이트 메인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성

    author : 성동훈
    since : 2017.01.15
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.pe.frame.cmm.core.base.Constant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>goGLOBAL 어드민사이트</title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="description" content="goGLOBAL 어드민사이트">
    <meta name="author" content="한국무역정보통신">

    <script src="<c:url value='/js/jquery.min.js'/>"></script>

    <%-- 화면 --%>
    <script src="<c:url value='/js/admin/view.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>

    <%-- 기능 --%>
    <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>

    <link rel="stylesheet" href="<c:url value='/css/admin/base.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/admin/admin.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/admin/expandcollapse.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dtree.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/admin/layer.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/admin/layerPop.css'/>" />

    <c:set var="session" value='<%= request.getSession(false).getAttribute(Constant.SESSION_KEY_ADM.getCode())%>'/>

    <c:set var="loadMenuId" value="${session.getMenuModelList().get(0).getMenuId()}"/>
    <c:set var="loadMenuNm" value="${session.getMenuModelList().get(0).getMenuNm()}"/>
    <c:set var="userId" value="${session.getUserId()}"/>
    <c:set var="userNm" value="${session.getUserNm()}"/>

    <c:set var="sessionDiv" value="<%= Constant.ADM_SESSION_DIV.getCode() %>"/>

    <s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>

    <script>
        function fn_menu(menuId, menuNm, isClick) {
            if(isClick == true){
                $('.head_btn > a').removeClass('on');
                $(this).addClass("on");
            }

            var params = {
                "menuId": menuId,
                "menuDiv": $.comm.getGlobalVar("sessionDiv")
            };

            $.comm.removeGlobalVar(menuId);

            $.comm.send('<c:out value="/menu/menuList.do"/>', params,
                function (data, status) {
                    var leftMenu = $('#subMenu');
                    leftMenu.empty();

                    var firstMenuId, firstUrl, firstMenuNm;
                    var menuList = data.dataList;

                    var findChildMenu = function(menuId){
                        var retList = [];
                        $.each(menuList, function (idx, menu) {
                            var pMenuId  = menu["PMENU_ID"];
                            if(menuId == pMenuId){
                                retList.push(menu);
                            }
                        })

                        return retList;
                    }
                    var appendMenu = function (targetMenuList){
                        var ul = $('<ul class="inner link">');
                        $.each(targetMenuList, function(index, menu){
                            var menuId  = menu["MENU_ID"];
                            var menuNm  = menu["MENU_NM"];
                            var menuDiv = menu["MENU_DIV"];
                            var menuUrl = ($.comm.isNull(menu["MENU_PATH"]) ? "" : menu["MENU_PATH"] + "/" + menu["MENU_URL"]);

                            var li = $('<li class="off">');
                            var a = $('<a class="toggle">');

                            li.attr("menuid", menuId);

                            if(!$.comm.isNull(menuUrl)){
                                a.attr("onclick", "fn_menuClick('" + menuId+ "', '" + menuUrl + "', '" + menuNm + "', '" + menuDiv + "')");

                                if ($.comm.isNull(firstMenuId)){
                                    firstMenuId  = menuId;
                                    firstUrl     = menuUrl;
                                    firstMenuNm  = menuNm;
                                }
                            }

                            a.html(menuNm);
                            li.append(a);

                            var childMneu = findChildMenu(menuId);
                            if(childMneu.length > 0){
                                li.append(appendMenu(childMneu));
                            }
                            ul.append(li);
                        })

                        return ul;
                    }

                    $.each(menuList, function (idx, menu) {
                        var menuId  = menu["MENU_ID"];
                        var menuLvl = menu["MENU_LEVEL"];

                        if(menuLvl == "1"){
                            var ul = appendMenu(findChildMenu(menuId));
                            leftMenu.append(ul.html());
                        }
                    });

                    gfn_lmenuExpand();

                    fn_findLeftMenu(firstMenuId, firstUrl, firstMenuNm);
                }
            );
        }

        function fn_menuClick(menuId, url, menuNm) {
            $.comm.removeGlobalVar("PAGE_PARAMETER");
            $('#mainFrame').attr('src', "/jspView.do?jsp=" + url + "&MENU_ID=" + menuId + "&MENU_NM=" + encodeURIComponent(menuNm) + "&MENU_DIV=" + $.comm.getGlobalVar("sessionDiv"));
        }

        // left 메뉴 찾아가는 함수 ( menuid의 level을 3으로 보고 찾음 )
        function fn_findLeftMenu(menuId, url, menuNm) {
            var li = $("[menuid=" + menuId + "]");
            var ul = li.closest("ul");
            var root = ul.closest("li");
            root.removeClass("off");

            root.addClass("on");
            ul.addClass("show");
            ul.css("display", "block");
            li.addClass("on");

            fn_menuClick(menuId, url, menuNm);
        }


        function fn_logout() {
            if(!confirm("로그아웃 하시겠습니까?")){
                return;
            }
            $.comm.logout('<c:out value="${logoutUrl}" />');
        }

        $(function () {
            $('#userInfo').html("${userNm}(${userId})님 반갑습니다. ");

            $.comm.setGlobalVar("sessionDiv", "${sessionDiv}"); // 사이트 구분
            $.comm.setGlobalVar("GLOBAL_LOGIN_USER_ID", "${userId}"); // 사용자 ID

            fn_menu('${loadMenuId}', '${loadMenuNm}');

            $('#btnExch').on("click", function () {
                fn_menuClick("300049", "basic/info/exchList", "환율조회");
            })

            $('#btnHs').on("click", function () {
                fn_menuClick("300054", "basic/info/hsList", "HS조회");
            })
        });


    </script>
</head>
<body>

<div id="wrap">
    <!-- left menu -->
    <div id="lnb_section">
        <div class="logo">
            <a href="#goglobal" onclick="location.reload()"><img src="/images/admin/logo.png" alt="goglobal logo"/></a>
        </div>
        <!-- lnb -->
        <div class="lnb">
            <ul class="accordion" id="subMenu">
            </ul><!-- //depth_01 -->
        </div>
        <!-- //lnb -->
        <div class="copy">
            <p>Copyright 2016 KTNET All Rights Reservd.</p>
        </div>
    </div>
    <%-- left menu--%>

    <%-- top & main--%>
    <div id="container">
        <div id="header">
            <div class="head_menu">
                <div class="head_btn">
                    <c:forEach var="menu" items="${session.getMenuModelList()}" varStatus="status">
                        <c:if test="${menu.getMenuLevel() eq '1' and menu.getLinkYn() eq 'Y'}">
                            <a href="#" onclick="fn_menu('${menu.getMenuId()}', '${menu.getMenuNm()}', true)"
                               <c:if test="${status.index eq 0}">class="on"</c:if> ><c:out
                                    value="${menu.getMenuNm()}"/></a>
                        </c:if>
                    </c:forEach>
                </div>
                <p><span id="userInfo"></span><a href="#" onclick="fn_logout()">로그아웃</a></p>
            </div><!-- //head_menu -->
        </div><!-- //header -->
        <div id="content">
            <div class="content_head">
                <a href="#" id="lnb_btn"><img src="/images/admin/btn/btn_admin_lnb.png" alt=""/></a>
                <p class="section_title" id="mainTitle"></p>
                <div>
                    <a href="#환율조회" id="btnExch">환율조회</a>
                    <a href="#HS조회" id="btnHs">HS조회</a>
                </div>
            </div><!-- content_head -->
            <!-- 내용을 넣어 주세요 Start-->
            <iframe id="mainFrame" src="" style="width: 100%; height: 837px; border: 0;" scrolling="auto"></iframe>
            <!-- 내용을 넣어 주세요 End-->
        </div><!-- //content -->
    </div><!-- //container -->
</div>
<%-- wrap --%>
<div id="layer"></div>
<div id="main_win_dim"></div>
</body>
</html>