<%@ page import="kr.pe.frame.cmm.core.base.Constant" %><%--
    Class Name : mobileLogin.jsp
    Description : 모바일사이트 메인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성

    author : 성동훈
    since : 2017.03.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>goGlobal</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" /> <!--모바일 뷰 설정-->
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <meta name="format-detection" content="telephone=no">

    <link rel="stylesheet" href="<c:url value='/css/mobile/base.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/mobile/common.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/css/mobile/layerPop.css'/>"/>

    <script src="<c:url value='/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/js/jquery.form.js'/>"></script>
    <script src="<c:url value='/js/mobile/view.js'/>"></script>
    <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>

    <c:set var="session" value='<%= request.getSession(false).getAttribute(Constant.SESSION_KEY_MBL.getCode())%>'/>
    <s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>

    <script>
        var pageHistory = []; // 페이지 history
        var globalMenu = [];  // menu list

        $(function(){
            $.comm.setGlobalVar("sessionDiv", "${Constant.MBL_SESSION_DIV.getCode()}");
            $.comm.setGlobalVar("GLOBAL_LOGIN_USER_ID", "${session.getUserId()}");

            $($('#gnb').find("li")[0]).find("a").addClass("on");
            mfn_movePage('${loadMenuId}', '${loadMenuNm}', '${loadMenuPath}', '${loadMenuUrl}');
        })

        // 로그아웃
        function mfn_logout(){
            $.comm.logout('<c:out value="${logoutUrl}" />');
        }

        // 메뉴 클릭
        function mfn_movePage(menuId, menuNm, menuPath, menuUrl){
            if($.comm.isNull(menuPath) || $.comm.isNull(menuPath)){
                return;
            }

            pageHistory = [];
            $(".back_btn").hide();
            $('#menu .btn_menu_close').click();

            mfn_loadPage(menuId, menuNm, menuPath+"/"+menuUrl);
        }

        // 페이지 이동
        function mfn_forward(jsp, param){
            if(globalMenu.length == 0){
                var p = {
                    "qKey" : "menu.selectMobileMenuList"
                }
                var d = $.comm.sendSync("<c:url value="/common/selectList.do"/>", p);
                globalMenu = d["dataList"];
            }

            var menuId, menuNm;
            for(var i=0; i<globalMenu.length; i++){
                var data = globalMenu[i];
                if(!$.comm.isNull(data["MENU_PATH"]) && !$.comm.isNull(data["MENU_URL"])){
                    var url = data["MENU_PATH"] + "/" + data["MENU_URL"];

                    if(url == jsp){
                        menuId = data["MENU_ID"];
                        menuNm = data["MENU_NM"];
                    }
                }
            }

            pageHistory.push($('#ACTION_MENU_ID').val());

            $(".back_btn").show();
            mfn_loadPage(menuId, menuNm, jsp, param);
        }

        // 페이지 로드
        function mfn_loadPage(menuId, menuNm, jsp, param){
            $('.content_title').find("h1").html(menuNm);

            var url = "<c:url value="/jspView.do?jsp="/>" + jsp;
            url += "&MENU_ID=" + menuId + "&MENU_NM="+ encodeURIComponent(menuNm) + "&MENU_DIV="+$.comm.getGlobalVar("sessionDiv");
            $('.contents').load(url, param, function() {
                $('.contents').fadeIn(1);
                $('#menu .btn_menu_close').click();
            });


            if(pageHistory.length == 0){
                $(".back_btn").hide();
            }

            $('#ACTION_MENU_ID').val(menuId);
            $('#ACTION_MENU_NM').val(menuNm);
            $('#ACTION_MENU_DIV').val($.comm.getGlobalVar("sessionDiv"));
        }

        // 뒤로 이동
        function mfn_geBack(){
            var menuId = pageHistory.pop();

            for(var i=0; i<globalMenu.length; i++){
                var data = globalMenu[i];
                var url = data["MENU_PATH"] + "/" + data["MENU_URL"];

                if(menuId == data["MENU_ID"]){
                    mfn_loadPage(menuId, data["MENU_NM"], url);
                    return;
                }
            }
        }
    </script>
</head>

<body>
<div id="wrap">
    <div id="header">
        <div class="top">
            <h1><a href="<c:url value='/mobile'/>">goGlobal</a></h1>
            <button type="button" class="btn_menu">메뉴열기</button>
        </div>

        <div id="menu">
            <div class="inner">
                <h1>Menu</h1>
                <div class="menu_top">
                    <p><strong>${session.getUserId()}</strong> 님 반갑습니다.</p>
                    <a href="#" onclick="mfn_logout()" class="btn logout_btn">로그아웃</a>
                </div>
                <!-- //menu_top -->
                <div class="menu_bottom">
                    <nav>
                        <ul id="gnb">
                            <c:forEach var="menu" items="${session.getMenuModelList()}" varStatus="status">
                                <c:if test="${menu.getLinkYn() eq 'Y'}">

                                    <c:set var="pMenuLevel" value="" />
                                    <c:if test="${menu.getMenuLevel() eq '1'}">
                                        <c:if test="${pMenuLevel eq '2'}">
                                            </ul>
                                        </c:if>
                                        </li>
                                        <li><a href="#" onclick="mfn_movePage('${menu.getMenuId()}', '${menu.getMenuNm()}', '${menu.getMenuPath()}', '${menu.getMenuUrl()}')"><span>${menu.getMenuNm()}</span></a>
                                    </c:if>
                                    <c:if test="${menu.getMenuLevel() eq '2'}">
                                            <c:if test="${pMenuLevel eq '1'}">
                                                <ul>
                                            </c:if>

                                            <li><a href="#" onclick="mfn_movePage('${menu.getMenuId()}', '${menu.getMenuNm()}', '${menu.getMenuPath()}', '${menu.getMenuUrl()}')"><span>${menu.getMenuNm()}</span></a></li>
                                    </c:if>
                                    <c:set var="pMenuLevel" value="${menu.getMenuLevel()}" />
                                </c:if>
                                <c:if test="${status.index-1 eq session.getMenuModelList().size()}">
                                    </li>
                                </c:if>
                            </c:forEach>
                    </nav>
                </div>
                <!-- //menu_bottom -->
                <div id="footer">
                    <h1>KTNET</h1>
                    <p class="copy">Copyright 2016 KTNET All Rights Reserved.</p>
                </div>
                <p><button type="button" class="btn_menu_close">메뉴닫기</button></p>
            </div>
        </div>
        <!-- //menu -->
        <div class="menu_bg"></div>
    </div>

    <div id="container">
        <div class="content_title">
            <h1></h1>
            <a href="#" onclick="mfn_geBack()" class="btn back_btn" style="display: none;">이전페이지로 이동</a>
        </div>
        <div class="contents">

        </div>
        <!--//contents-->
        <div class="top_move">
            <img src="<c:url value="/images/btn/btn_top_move.png"/>" alt="상단으로 이동하기 버튼">
        </div>
    </div>
    <!--//container-->
    <div id="layer"></div>
</div>
<form id="commonForm" name="commonForm"></form>
<input type="hidden" id="ACTION_MENU_ID" name="ACTION_MENU_ID" />
<input type="hidden" id="ACTION_MENU_NM" name="ACTION_MENU_NM" />
<input type="hidden" id="ACTION_MENU_DIV" name="ACTION_MENU_DIV" />
<!-- //wrap -->
</body>

</html>
