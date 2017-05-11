<%--
    Class Name : main.jsp
    Description : 사용자 사이트 메인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성

    author : 성동훈
    since : 2017.01.15
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<title>goGLOBAL</title>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="description" content="goGLOBAL">
	<meta name="author" content="한국무역정보통신">

	<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js" charset="utf-8"></script>

	<script src="${pageContext.request.contextPath}/js/jquery.nicescroll.js"></script>
	<script src="${pageContext.request.contextPath}/js/dtree.js"></script>
	<script src="${pageContext.request.contextPath}/js/popup.js"></script>
	<script src="${pageContext.request.contextPath}/js/view.js"></script>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/base.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mainlayout.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/expandcollapse.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/layerPop.css" />

	<s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>
	<s:eval expression="@config.getProperty('main.url')" var="mainUrl"/>

	<script>
		var MAIN_VARS = {
		    "isLogin"    : ($.comm.isNull("${userId}") ? false : true),
            "SN"         : "${SN}", 		// 공지사항 SN
			"DEC_STATUS" : "${DEC_STATUS}", // 수출신고 건수 페이지 이동
			"loadMenuId" : "${loadMenuId}",
			"subMenuList": {}
		}

		// iframe 화면에서 main 의 값을 사용 할때 사용하는 함수
		function mfn_getVariable(key){
		    return MAIN_VARS[key];
		}
		function mfn_setVariable(key, value){
		    return MAIN_VARS[key] = value;
		}

		// mainFrame을 반환
		function mfn_getMainFrame(){
            return $('#mainFrame').contents();
		}

		function mfn_leftMenuSelect(menuId, menuNm, loadMenuId){
            MAIN_VARS["loadMenuId"] = loadMenuId;
            fn_menu(menuId, menuNm, false);
		}

		function fn_menu(menuId, menuNm, isMenuClick){
            $('#topMenuNm').html(menuNm);
            var params = {
                "menuId"  : menuId,
                "menuDiv" : sessionStorage.getItem("sessionDiv")
            };

            var isDrawMenu = false;
            var loadSubMenu = function (menuList){
                var firstMenuId = $.comm.isNull(MAIN_VARS["loadMenuId"]) ? null : MAIN_VARS["loadMenuId"];
                var firstUrl, firstMenuNm, firstDashUrl;

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
					for (var index in targetMenuList){
					    var menu = targetMenuList[index];
                        var menuId  = menu["MENU_ID"];
                        var menuNm  = menu["MENU_NM"];
                        var menuDiv = menu["MENU_DIV"];
                        var menuUrl = ($.comm.isNull(menu["MENU_PATH"]) ? "" : menu["MENU_PATH"] + "/" + menu["MENU_URL"]);
                        var dashUrl = ($.comm.isNull(menu["DASH_PATH"]) ? "" : menu["DASH_PATH"] + "/" + menu["DASH_URL"]);

                        var li = $('<li class="off">');
                        var a = $('<a class="toggle">');

                        li.attr("menuid", menuId);

                        if(!$.comm.isNull(menuUrl)){
                            a.attr("onclick", "fn_menuClick('" + menuId + "', '" + menuUrl + "', '" + menuNm + "', '" + menuDiv + "', '" + dashUrl + "')");

                            if ($.comm.isNull(firstMenuId) || (!$.comm.isNull(MAIN_VARS["loadMenuId"]) && MAIN_VARS["loadMenuId"] == menuId)){
                                if (menu["LINK_YN"] != "Y"){
                                    return null;
                                }

                                firstMenuId  = menuId;
                                firstUrl     = menuUrl;
                                firstMenuNm  = menuNm;
                                firstDashUrl = dashUrl;

                                MAIN_VARS["loadMenuId"] = null;
                                isDrawMenu = true;
                            }
                        }

                        a.html((menu["MENU_LEVEL"] == "3") ? "-&nbsp;".concat(menuNm) : menuNm);
                        li.append(a);

                        var childMneu = findChildMenu(menuId);
                        if(childMneu.length > 0){
                            li.append(appendMenu(childMneu));
                        }
                        ul.append(li);
                    }

                    return ul;
                }

				for (var index in menuList){
                    var menu = menuList[index];
                    var menuId  = menu["MENU_ID"];
                    var menuLvl = menu["MENU_LEVEL"];

                    if(menuLvl == "1"){
                        var ul = appendMenu(findChildMenu(menuId));
						if (isDrawMenu){
                            $('#leftMenu').empty();
                            $('#leftMenu').append(ul.html());

                            break;
                        }else{
                            MAIN_VARS["loadMenuId"] = null;
						    return; // 상세화면으로 메뉴 그리지 않음
                        }
                    }
                }

                gfn_lmenuExpand();

                fn_findLeftMenu(firstMenuId, firstUrl, firstMenuNm, firstDashUrl);
                if ($.comm.isNull(isMenuClick) || isMenuClick){
                    fn_menuClick(firstMenuId, firstUrl, firstMenuNm, null, firstDashUrl);
                }
            }


            if (MAIN_VARS["subMenuList"][menuId]){
                loadSubMenu(MAIN_VARS["subMenuList"][menuId]);

            }else{
                $.comm.send('<c:out value="/menu/menuList.do"/>', params,
                    function(data){
                        MAIN_VARS["subMenuList"][data['data']['menuId']] = data.dataList;
                        loadSubMenu(data.dataList);
                    }
                )
            }
		}

		function fn_menuClick(menuId, url, menuNm, menuDiv, dashUrl){
            $.comm.removeGlobalVar("PAGE_PARAMETER");
			if(!$.comm.isNull(dashUrl)){
				$.comm.disabled("dash_toggle", false);
                if(localStorage.getItem("goglobal_use_dash_on") == null && $('#dash_toggle').hasClass('dash_off')){
                    $('#dash_toggle').click();
                }

                $('#dashBoardFrame').attr('src', "/jspView.do?jsp=" + dashUrl + "&MENU_DIV="+$.comm.getGlobalVar("sessionDiv"));
            }else{
                $.comm.disabled("dash_toggle", false);
                if($('#dash_toggle').hasClass("dash_on")){
					$('#dash_toggle').click();
				}
                $.comm.disabled("dash_toggle", true);
                $('#dashBoardFrame').empty();
			}

            $('#mainTitle').html(menuNm);
            $('#mainFrame').attr('src', "/jspView.do?jsp=" + url + "&MENU_ID=" + menuId + "&MENU_NM="+ encodeURIComponent(menuNm) + "&MENU_DIV="+$.comm.getGlobalVar("sessionDiv")/*menuDiv*/);
		}

		// left 메뉴 찾아가는 함수 ( menuid의 level을 3으로 보고 찾음 )
		function fn_findLeftMenu(menuId) {
            var li = $("[menuid=" + menuId + "]");
            var ul = li.closest("ul");
            var root = ul.closest("li");
            root.removeClass("off");

            root.addClass("on");
            ul.addClass("show");
            ul.css("display", "block");
            li.addClass("on");
        }

        function fn_logout() {
            if(!confirm("로그아웃 하시겠습니까?")){
                return;
            }
            $.comm.logout('<c:out value="${logoutUrl}" />');
        }

        // 개인정보수정
        function fn_profWrite() {
            fn_menuClick("200055", "basic/prof/profWrite", "회원정보", "W");
        }

        // 회원가입
        function fn_join(){
            location.href = "<c:url value="/jspView.do?jsp="/>home/mem/join01";
		}

        $(function () {
            if($.comm.isNull("${userId}")){
                $('#loginInfo').hide();
                $('#noneLogin').show();
                $('#loginFooter').hide();

                $('.foot-content').attr("style", "padding-top: 120px");
                $('#noneLoginFooter').show();
            }

            $.comm.setGlobalVar("sessionDiv", "${sessionDiv}"); // 사이트 구분
            $.comm.setGlobalVar("GLOBAL_LOGIN_USER_ID", "${userId}"); // 사용자 ID

            fn_menu('${topMenuId}', '${topMenuNm}');

            // 로그아웃
            $('#btnLogout').on('click', function () {
                fn_logout();
            })

            // 개인정보수정
            $('#btnProfWrite').on('click', function () {
                fn_profWrite();
            })

            // 로그인
            $('.gnb_login').on('click', function () {
                location.href = "<c:out value="/"/>";
            })

            // 회원가입
            $('.gnb_join').on('click', function () {
                fn_join();
            })

            $('#btnFTAHSInfo').on("click", function () {
                var spec = "dialogWidth:1080px;dialogHeight:820px;scroll:yes;status:no;center:yes;resizable:yes;";
                $.comm.dialog("https://fta.utradehub.or.kr/fta/origin/agrifta/hscode/hsCodeCategorySearchList.do?menuId=GB_AGRI&popUpYN=", spec);
            })

            $('#btnCUSTHSInfo').on("click", function () {
                var spec = "dialogWidth:1080px;dialogHeight:820px;scroll:yes;status:no;center:yes;resizable:yes;";
                $.comm.dialog("http://trass.or.kr/static-html/bcc/hsnavigation.jsp?", spec);
            })

            $('#btnExchInfo').on("click", function () {
            	var spec = "dialogWidth:990px;dialogHeight:820px;scroll:auto;status:no;center:yes;resizable:yes;";
                $.comm.dialog("<c:out value='/jspView.do?jsp=/basic/exch/exchListPopup' />", spec);
            })
        })

	</script>
</head>
<body>

	<!-- Header Area Start -->
	<header>
		<h1 class="logo"><a href="javascript:location.href='/'"><img src="<c:out value="/images/logo.gif"/>" alt="" /></a></h1>
		<ul class="gnb">
			<c:forEach var="menu" items="${menuList}" varStatus="status">
				<c:if test="${menu.getMenuLevel() eq '1' and menu.getLinkYn() eq 'Y'}">
					<li><a href="javascript:void(0)" onclick="fn_menu('${menu.getMenuId()}', '${menu.getMenuNm()}')"><c:out value="${menu.getMenuNm()}"/></a></li>
				</c:if>
			</c:forEach>
		</ul>
		<%--<div class="util" id="noneLogin" style="display: none">
			<button class="image-type gnb_join" title="회원가입">회원가입</button><button class="image-type gnb_login" title="로그인">로그인</button>
		</div>
		<div class="util" id="loginInfo">
			<p class="greeting"><strong>${userId}</strong>님 반갑습니다.<br /><span>[최근접속일 : ${loginLastTime}]</span></p>
			&lt;%&ndash;<button class="image-type setting">환경설정</button>&ndash;%&gt;<button class="image-type logout" id="btnLogout" title="로그아웃">로그아웃</button>
		</div>--%>
	</header>
	<!-- Header Area End// -->

	<!-- Container Area Start -->
	<div id="container">

		<!-- Navi Ar ea End// -->
		<div class="nav">
			<div class="login_info">
				<!--로그인 전-->
				<div id="noneLogin" style="display: none">
					<p class="info_txt">서비스 이용을 위해서는 <strong>로그인</strong> <br />또는 <strong>회원가입</strong>이 필요합니다.</p>
					<div class="clearfix">
						<button class="gnb_login" title="로그인">로그인</button>
						<button class="gnb_join" title="회원가입">회원가입</button>
					</div>
				</div>
				<!--//로그인 전-->
				<!--로그인 후-->
				<div id="loginInfo">
					<p class="greeting"><strong>${userId}</strong><%--님 반갑습니다.--%><br/><span>[최근접속일 : ${loginLastTime}]</span></p>
					<div class="clearfix">
						<button class="setting" id="btnProfWrite">개인정보수정</button>
						<button class="logout" id="btnLogout" title="로그아웃">로그아웃</button>
					</div>
				</div>
				<!--//로그인 후-->
			</div>
			<div class="title blue-type"><strong id="topMenuNm"></strong></div>
			<div class="inner-box">
				<div class="dash-toggle">
					<p>Dashboard<a id="dash_toggle" class="dash_off" href="#" disabled="disabled"><img src="<c:out value="/images/btn/btn_dash_off.png"/>" alt="dash-toggle" /></a></p><!-- 300, 560 onclick="layoutResize(); -->
				</div><!-- //dash-toggle -->
				<div class="lnb inner-box">
					<ul class="accordion" id="leftMenu">
					</ul><!-- //depth_01 -->
				</div><!-- lnb -->
				<div class="footer">
					<div class="foot-content">
						<ul id="loginFooter">
							<li><a href="#" id="btnFTAHSInfo">HS정보(FTA Korea)</a></li>
							<li><a href="#" id="btnCUSTHSInfo">HS정보(관세무역개발원)</a></li>
							<li><a href="#" id="btnExchInfo">환율정보</a></li>
							<li><a href="javascript:layerPop('tutorial_start')">서비스 튜터리얼</a></li>
						</ul>
						<ul id="noneLoginFooter" style="display:none">
							<li><a href="javascript:layerPop('tutorial_start')">서비스 튜터리얼</a></li>
						</ul>
					</div>
					<div class="copy">
						<p>Copyright 2016 KTNET<br /> All Right Reserved.</p>
					</div>
				</div>
			</div>
		</div>
		<!-- Navi Area End// -->

		<!-- Chart Area Start// -->
		<div class="chart" style="width: 0px;">
			<div class="title green-type"><strong>Dashboard</strong><button class="close"></button></div><!-- onclick="layoutResize(); 0,240 -->
			<iframe width="100%" name="dashBoardFrame" id="dashBoardFrame" class="" scrolling="no" frameborder="0"></iframe>
		</div><!-- //chart -->
		<!-- Chart Area End// -->

		<!-- Contents Area End// -->
		<div class="contents depth2-layout" style="left:240px">
			<div class="title gray-type">
				<strong id="mainTitle"></strong>
				<div class="title_btn_section clearfix">
					<%--<a href="#" id="btn_search_toggle"></a>--%>
					<%--<a  href="#" class="title_btn">프린트</a>--%>
				</div>
			</div>
			<iframe src="" width="100%" name="mainFrame" id="mainFrame" class="" scrolling="no" frameborder="0"></iframe>
		</div>
		<!-- Contents Area End// -->
		<a href="#" id="popup_btn"></a><!-- //팝업 -->

	</div> <!-- Container Area End -->

	<div id="layer"></div>
	<div id="main_win_dim"></div>
</body>
</html>