<%--
    Class Name : index.jsp
    Description : 사용자 사이트 로그인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성

    author : 성동훈
    since : 2017.03.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.pe.frame.cmm.core.base.Constant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title>goGLOBAL</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/base.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/layerPop.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/swiper.min.css"/>
	<%--<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/tutorial.css"/>--%>

	<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js" charset="utf-8"></script>
	<script src="${pageContext.request.contextPath}/js/main.js" charset="utf-8"></script>
	<script src="${pageContext.request.contextPath}/js/swiper.jquery.js" charset="utf-8"></script>
	<script src="${pageContext.request.contextPath}/js/TweenMax.js" charset="utf-8"></script>
	<script src="${pageContext.request.contextPath}/js/popup.js" charset="utf-8"></script>
	<script src="${pageContext.request.contextPath}/js/tutorial.js" charset="utf-8"></script>

	<c:set var="session" value='<%= request.getSession(false).getAttribute(Constant.SESSION_KEY_USR.getCode())%>'/>
	<c:set var="userId" value='${session.getUserId()}'/>
	<c:set var="userNm" value='${session.getUserNm()}'/>
	<c:set var="userDiv" value='${session.getUserDiv()}'/>
	<c:set var="loginLast" value='${session.getLoginLast()}'/>

	<c:choose>
		<c:when test="${session eq null}">
			<c:set var="isLogin" value="false" />
		</c:when>
		<c:when test="${session ne null}">
			<c:set var="isLogin" value="true" />
		</c:when>
	</c:choose>

	<s:eval expression="@config.getProperty('login.action.url')" var="actionUrl"/>
	<s:eval expression="@config.getProperty('logout.action.url')" var="logoutUrl"/>
	<s:eval expression="@config.getProperty('main.url')" var="mainUrl"/>

	<script>
		var MAIN_VARS = {
		    "isLogin" : false
		}
        $(function () {
            $.comm.setGlobalVar("sessionDiv", "W"); // 사이트 구분

            $('#usrId').on('keypress', function(event) {
                if (event.which === 13) {
                    event.preventDefault();
                    $('#usrPswd').focus();
                }
            });
            $('#usrPswd').on('keypress', function(event) {
                if (event.which === 13) {
                    event.preventDefault();
                    $('.login_btn').trigger('click');
                }
            });

            // 로그인
            $('.login_btn').on('click', function() {
                var e = $('#usrId');
                if ($.trim(e.val()) === '') {
                    alert($.comm.getMessage("W00000067")); // 아이디를 입력해 주십시오.
                    e.focus();
                    return false;
                }
                e = $('#usrPswd');
                if ($.trim(e.val()) === '') {
                    alert($.comm.getMessage("W00000068")); // 비밀번호를 입력해 주십시오.
                    e.focus();
                    return false;
                }
                loginAction();
            });

            //로그아웃
            $('.logout_btn').on('click', function(){
                logoutAction();
            });

            //ID/PW 찾기
            $('#btnFindId').on('click', function(){
                location.href = "<c:url value="/jspView.do?jsp="/>home/login/idFnd";
            });

            //회원가입
            $('#btnJoin').on('click', function(){
                location.href = "<c:url value="/jspView.do?jsp="/>home/mem/join01";
            });


            if('<c:out value="${isLogin}"/>' == 'true'){
                fn_afterLogin();
                MAIN_VARS["isLogin"] = true;
            }

            if(!$.comm.isNull('${msg}')){
                alert('${msg}');
            }

            fn_load();
        });

        function fn_load() {
            $.comm.send('<c:url value="/common/selectIndexLoad.do"/>', null,
                function (ret) {
                	var data = ret["data"];

                	// 공시사항 리스트
                    $('#notice').find("ul").remove();
                    var ul = $("<ul>");
                    $.each(data["noticeList"], function (index, data) {
                        var li = $("<li>");
                        var a  = $("<a>");

                        a.attr("href", "#");
                        a.html(data["TITLE"]);
                        a.on('click', function () {
                            fn_goMain("help/ntc/ntcList", "SN", data["SN"]);
                        })

                        li.append(a);
                        li.append("<span>" + data["REG_DTM"] + "</span>");

                        ul.append(li);
                    })

                    $('#notice').append(ul);

                	// 뉴스레터 리스트
                    $('#news').find("ul").remove();
                    ul = $("<ul>");
                    $.each(data["newsList"], function (index, data) {
                        var li = $("<li>");
                        var a  = $("<a>");

                        a.attr("href", "#");
                        a.html(data["SUBJECT"]);
                        a.on('click', function () {
                            fn_goMain("help/ntc/newsList", "SN", data["SN"]);
                        })

                        li.append(a);
                        li.append("<span>" + data["REG_DTM"] + "</span>");

                        ul.append(li);
                    })

                    $('#news').append(ul);

					// 팝업 공지사항
                    var top = 100;
                    var left = 20;
                    $.each(data["popupNoticeList"], function (index, ntc) {
                        var sn = ntc["SN"];

                        if (localStorage.getItem("goglobalSaveNoticePopupKey" + sn) != "done" ){
                            var url = "<c:out value='/jspView.do?jsp=/cmm/popup/noticePopup' />&SN=" + sn;
                            var name = "noticePopup" + sn;

                            $.comm.setGlobalVar(name, JSON.stringify(ntc));
                            $.fn.popupwindow({
                                url:url,
                                windowName:name,
                                height : 471,
                                width : 458,
                                dimmed : 0,
                                center: 0,
                                top : top += 50,
                                left : left += 50
                            });
                        }
                    })
                }, "Index화면 온로드 조회"
            )

        }

        function loginAction() {
            $('#loginForm').attr('action', '<c:url value="${actionUrl}"/>').submit();
        }

        function logoutAction() {
            if(!confirm($.comm.getMessage("C00000037"))){ // 로그아웃 하시겠습니까?
                return;
            }

            $.comm.logout('<c:url value="${logoutUrl}"/>');
        }

        function fn_afterLogin() {
            $.comm.setGlobalVar("GLOBAL_LOGIN_USER_ID", "${userId}"); // 사용자 ID

            // id / pw 값 삭제
            $('#usrId').val("");
            $('#usrPswd').val("");

            $('.login_before').css('display','none');
            $('.login_after').css('display','block');
            $('.login_area').animate({'height': 212});

            if("${userDiv}" == "E"){ // 특송사
                $('.ems_menu').css('display','block');

            }else if("${userDiv}" == "G"){ // 관세사
                $('.customs_menu').css('display','block');

            }else{
                $('.seller_menu').css('display','block');

            }


            // 신고일자 기준(금월) 조회
            $.comm.send('<c:url value="/common/selectDecSummary.do"/>', null,
                function (ret) {
                    var countData = ret["data"];
					$.comm.bindData(countData);

                }, "수출신고건수 요약 조회"
            )
        }

	</script>

</head>
<body>
<div id="wrap">
	<!-- skip -->
	<p class="skipmenu blind"><a href="#container">본문바로가기</a></p>
	<!-- //skip -->
	<!-- header -->
	<div id="header">
        <%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>
		<div class="visual">
			<!--로그인전-->
			<div class="login_before">
				<div class="bracket">
					<span class="bracket_left"></span>
					<span class="bracket_right"></span>
				</div>
				<div class="hashtag_move">

					<ul>
						<li class="hashtag">#수출신고 &nbsp;#부가세신고</li>
						<li class="hashtag">#EMS픽업예약 &nbsp;#이행신고</li>
						<li class="hashtag">#반품 &nbsp;#수입관세</li>
						<li class="hashtag">#전자상거래 &nbsp;#물품구매</li>
					</ul>
					<ul class="hashtag_subtxt">
						<li>
							<p>goGLOBAL이 함께합니다.</p>
							<span class="division_line"></span>
							<p>goGlobal은 관세청과 직접 연결되어 엑셀, 오픈API 방식으로 수출신고가 가능합니다. <br/>또한, 부가세신고를 위한 수출실적 명세자료를 다양한 형태로 받아보실 수 있습니다.</p>
						</li>
						<li>
							<p>한번에 해결하세요.</p>
							<span class="division_line"></span>
							<p>수출신고 후 EMS 픽업예약을 하시면 수출이행까지 완료되어 당신의 수출실적이 됩니다.<br/>전세계로 향하는 당신의 상품을 언제 어디서나 확인하실 수 있습니다.</p>
						</li>
						<li>
							<p>고민에서 벗어나세요.</p>
							<span class="division_line"></span>
							<p>goGlobal을 통해 수출신고를 하고, 반품 재수입신고를 전문 관세사에게 의뢰가 가능하여<br/>반품 상품에 대한 수입관세가 없어집니다.</p>
						</li>
						<li>
							<p>부가세 없이 공급 받으세요.</p>
							<span class="division_line"></span>
							<p>수출신고서가 구매확인서 근거서류로, 세금계산서가 구매확인서 거래내역이 됩니다.<br/>빠르고 간편한 전자상거래 전용 구매확인서를 이용하시면 영세율로 물품 구매가 가능합니다.</p>
						</li>
					</ul>
				</div>
				<div class="before_slide">
					<div class="swiper-wrapper">
						<div class="swiper-slide bf_slide01"></div>
						<div class="swiper-slide bf_slide02"></div>
						<div class="swiper-slide bf_slide03"></div>
						<div class="swiper-slide bf_slide04"></div>
					</div>
					<div class="swiper-pagination"></div>
					<div class="btn_next">
						<img src="/images/btn_slide_next.png" alt="">
					</div>
					<div class="btn_prev">
						<img src="/images/btn_slide_prev.png" alt="">
					</div>
				</div>
			</div>
			<!--//로그인전-->
			<!--로그인후-->
			<div class="login_after">
				<div class="inner_wrap after_menu">
					<!--셀러일 경우-->
					<ul class="clearfix seller_menu" style="display:none">
						<li>
							<a href="#수출신고" onclick="fn_goSite('decExp')">
								<img src="/images/icon_01.png">
								<img src="/images/icon_01_on.png" class="go_on">
								<p>수출신고</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#구매확인" onclick="fn_goSite('pcr')">
								<img src="/images/icon_02.png">
								<img src="/images/icon_02_on.png" class="go_on">
								<p>구매확인</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#배송요청" onclick="fn_goSite('ems')">
								<img src="/images/icon_03.png">
								<img src="/images/icon_03_on.png" class="go_on">
								<p>배송요청</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#수출실적명세" onclick="fn_goSite('expSta')">
								<img src="/images/icon_04.png">
								<img src="/images/icon_04_on.png" class="go_on">
								<p>수출실적명세</p>
								<div class="go_on">GO</div>
							</a>
						</li>
					</ul>
					<!--//셀러-->
					<!--관세사일 경우-->
					<ul class="clearfix customs_menu" style="display:none">
						<li>
							<a href="#수출신고의뢰" onclick="fn_goSite('decReq')">
								<img src="/images/icon_05.png">
								<img src="/images/icon_05_on.png" class="go_on">
								<p>수출신고의뢰</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#수출정정의뢰" onclick="fn_goSite('modReq')">
								<img src="/images/icon_06.png">
								<img src="/images/icon_06_on.png" class="go_on">
								<p>수출정정의뢰</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#수출신고" onclick="fn_goSite('decExp')">
								<img src="/images/icon_01.png">
								<img src="/images/icon_01_on.png" class="go_on">
								<p>수출신고</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#반품수입신고의뢰" onclick="fn_goSite('impReq')">
								<img src="/images/icon_07.png">
								<img src="/images/icon_07_on.png" class="go_on">
								<p>반품수입신고의뢰</p>
								<div class="go_on">GO</div>
							</a>
						</li>
					</ul>
					<!--//관세사-->
					<!--특송사일 경우-->
					<ul class="clearfix ems_menu" style="display:none">
						<li>
							<a href="#배송요청" onclick="fn_goSite('xpr')">
								<img src="/images/icon_03.png">
								<img src="/images/icon_03_on.png" class="go_on">
								<p>배송요청</p>
								<div class="go_on">GO</div>
							</a>
						</li>
						<li>
							<a href="#OpenAPI안내" onclick="fn_goSite('apiExpFull')">
								<img src="/images/icon_08.png">
								<img src="/images/icon_08_on.png" class="go_on">
								<p>Open API 안내</p>
								<div class="go_on">GO</div>
							</a>
						</li>
					</ul>
					<!--//특송사-->
				</div>
			</div>
			<!--//로그인후-->
		</div>
		<div class="login_area">
			<!--로그인전-->
			<div class="login_before clearfix inner_wrap">
				<p class="intro_text"><strong>쉽고 빠르게 전자상거래수출신고</strong><br />서비스를 이용하세요.</p>
				<form action="" method="post" class="login_input" id="loginForm">
					<input id="sessionDiv" name="sessionDiv" type="hidden" value="W"/>
					<fieldset class="clearfix">
						<legend>로그인</legend>
						<p>
							<label for="usrId" class="blind">아이디</label>
							<input type="text" id="usrId" name="usrId" placeholder="아이디를 입력해 주세요.">
						</p>
						<p>
							<label for="usrPswd" class="blind">비밀번호</label>
							<input type="password" id="usrPswd" name="usrPswd" placeholder="비밀번호를 입력해 주세요.">
						</p>
					</fieldset>
					<div class="btn_area">
						<input type="submit" value="로그인" class="login_btn" id="login">
						<a href="#회원가입" class="join_btn" id="btnJoin">회원가입</a>
						<a href="#ID/PW 찾기" class="join_btn find_id_btn" id="btnFindId">ID/PW 찾기</a>
					</div>
				</form>
			</div>
			<!--//로그인전-->
			<!--로그인후-->
			<div class="login_after">
				<div class="inner_wrap clearfix">
					<p class="intro_text"><strong>${userNm}</strong> 님 반갑습니다.</p>
					<p class="last_time"><span>[</span> <strong>최근로그인</strong> ${loginLast} <span>]</span></p>
					<div class="btn_area clearfix ">
						<a href="#" onclick="fn_goMain()" class="busisyt_btn">업무시스템 바로가기</a>
						<a href="#" onclick="fn_goSite('modifyMyinfo')" class="adjust_btn">회원정보수정</a>
						<a href="#0" class="logout_btn">로그아웃</a>
					</div>
				</div>
				<div class="individual_menu">
					<img src="/images/bg_after_line.jpg" class="line_arrow">
					<div class="inner_wrap">
						<!--셀러일경우-->
						<ul class="seller_menu" style="display:none">
							<li>
								<a href="#신고요청" onclick="fn_goMain('exp/req/decReqList', 'DEC_STATUS', 'SELLER_REQ_COUNT')">
									<img src="/images/icon_individual_menu01.png"> 신고요청
									<strong id="SELLER_REQ_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#신고처리" onclick="fn_goMain('exp/dec/decList', 'DEC_STATUS', 'SELLER_COUNT')">
									<img src="/images/icon_individual_menu02.png"> 신고처리
									<strong id="SELLER_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#신고오류" onclick="fn_goMain('exp/dec/decList', 'DEC_STATUS', 'SELLER_ERR_COUNT')">
									<img src="/images/icon_individual_menu03.png"> 신고오류
									<strong id="SELLER_ERR_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#정정신청" onclick="fn_goMain('exp/req/modReqList', 'DEC_STATUS', 'SELLER_MOD_COUNT')">
									<img src="/images/icon_individual_menu04.png"> 정정신청
									<strong id="SELLER_MOD_COUNT"></strong><span>건</span>
								</a>
							</li>

						</ul>
						<!--//셀러-->
						<!--관세사일 경우-->
						<ul class="customs_menu" style="display:none">
							<li>
								<a href="#수출신고의뢰" onclick="fn_goMain('exp/req/decReqList', 'DEC_STATUS', 'CUSTOMS_REQ_COUNT')">
									<img src="/images/icon_individual_menu05.png">
									<p>수출신고<br/>의뢰</p>
									<strong id="CUSTOMS_REQ_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#수출정정의뢰" onclick="fn_goMain('exp/req/modReqList', 'DEC_STATUS', 'CUSTOMS_MOD_COUNT')">
									<img src="/images/icon_individual_menu04.png">
									<p>수출정정<br/>의뢰</p>
									<strong id="CUSTOMS_MOD_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#수출신고" onclick="fn_goMain('exp/dec/decList', 'DEC_STATUS', 'CUSTOMS_DEC_COUNT')">
									<img src="/images/icon_individual_menu01.png">
									<p>수출신고<br/>&nbsp;</p>
									<strong id="CUSTOMS_DEC_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#반품수입신고의뢰" onclick="fn_goMain('exp/imp/impReqList', 'DEC_STATUS', 'CUSTOMS_IMP_REQ_COUNT')">
									<img src="/images/icon_individual_menu06.png">
									<p>반품수입<br/>신고의뢰</p>
									<strong id="CUSTOMS_IMP_REQ_COUNT"></strong><span>건</span>
								</a>
							</li>
						</ul>
						<!--//관세사
                        <!-- 특송사일 경우-->
						<ul class="ems_menu" style="display:none">
							<li>
								<a href="#배송요청" onclick="fn_goMain('xpr/ship/shipReqList', 'DEC_STATUS', 'EXPRESS_REQ_COUNT')">
									<img src="/images/icon_individual_menu01.png"> 배송요청
									<strong id="EXPRESS_REQ_COUNT"></strong><span>건</span>
								</a>
							</li>
							<li>
								<a href="#배송요청접수확인" onclick="fn_goMain('xpr/ship/shipReqList', 'DEC_STATUS', 'EXPRESS_REC_COUNT')">
									<img src="/images/icon_individual_menu02.png"> 배송요청 접수확인
									<strong id="EXPRESS_REC_COUNT"></strong><span>건</span>
								</a>
							</li>
						</ul>
						<!--//특송사-->
					</div>
				</div>
			</div>
			<!--//로그인후-->
		</div>
	</div>
	<!-- //header -->

	<div id="container">
		<!-- content -->
		<div id="content">

			<div class="content_area inner_wrap">
				<div class="clearfix">
					<div class="notice" id="notice">
						<h2>공지사항</h2>
						<a href="#공지사항" onclick="fn_goSite('ntc')" class="notice_more">더보기 <span>+</span></a>
					</div>
					<div class="service guide">
						<a href="#서비스 안내" onclick="fn_goSite('help')">
							<h2>서비스 안내</h2>
							<p>복잡한 전자상거래 수출신고 업무를 쉽고 <br/>빠르게 처리할 수 있는 서비스를 안내 합니다.</p>
						</a>
					</div>
					<div class="api guide">
						<a href="#Open API 안내" onclick="fn_goSite('openapi')">
							<h2>Open API 안내</h2>
							<p>KTNET에서 제공하는 API 서비스를 활용하여 <br/>KTNET 간이수출신고가 자동으로 연계됩니다.</p>
						</a>
					</div>
					<div class="link_area">
						<ul>
							<li class="link_tut"><a href="javascript:layerPop('tutorial_start')">서비스 튜터리얼</a></li>
							<li class="link_gallery"><a href="http://kr.tradekorea.com/groupmarketing.do" target="_blnak">온라인 전시관</a></li>
							<li class="link_navi"><a href="http://www.tradenavi.or.kr/" target="_blnak">유망시장전출보고서</a></li>
						</ul>
					</div>
				</div>
				<div class="clearfix">
					<div class="notice" id="news">
						<h2>뉴스레터</h2>
						<%--<ul>
							<li><a href="#0">온라인쇼핑협회 클리핑 뉴스 (제 1764호)</a><span>2017-02-03</span></li>
							<li><a href="#0">온라인쇼핑협회 클리핑 뉴스 (제 1763호)</a><span>2017-02-03</span></li>
							<li><a href="#0">온라인쇼핑협회 클리핑 뉴스 (제 1762호)</a><span>2017-02-03</span></li>
						</ul>--%>
						<a href="#뉴스레터" onclick="fn_goSite('news')"  class="notice_more">더보기 <span>+</span></a>
					</div>
					<ul class="sns_area">
						<li><a href="#0"><strong>ID</strong> : ktnet1234</a></li>
						<li><strong>ID</strong> : ktnet1234</li>
					</ul>
					<div class="introduction_area">
						<ul class="service_slide">
							<li class="seller_service">
								<div class="clearfix">
									<div class="explanation">
										<p>엑셀업로드 및 수출신고 처리과정을 관리하고 <br/>OpenAPI Key 발급 요청 및 이력관리를 할 수 있습니다. <br />OpenAPI를 연계한 간이수출신고서비스를 제공합니다.</p>
									</div>
								</div>
							</li>
							<li class="customs_service">
								<div class="clearfix">
									<div class="explanation">
										<p>상품별 HS코드 분류, 오류/정정 의뢰 접수 및 대행 처리,<br />간이수출신고를 통한 관세업무서비스를 제공합니다.</p>
									</div>
								</div>
							</li>
							<li class="ems_service">
								<div class="clearfix">
									<div class="explanation">
										<p>셀러가 배송요청한 정보를 특송사별 양식에 맞게 설정하여 <br />엑셀파일로 다운받을 수 있으며, 수출이행신고를 위한 수출신고정보를 <br />OpenAPI 또는 엑셀파일로 받을 수 있는 서비스를 제공합니다.</p>
									</div>
								</div>
							</li>
							<li class="mobile_service">
								<div class="clearfix">
									<div class="explanation">
										<p>수출신고와 정정취하신고의 진행상태 및 상세내역을 조회 할 수 <br />있으며, 관세청으로 신고서를 전송 할 수 있는 기능을 제공합니다. <br />http://www.goglobal.co.kr/mobile로 접속하시면 이용 가능합니다.</p>
									</div>
								</div>
							</li>
						</ul>
						<ul class="pagination">
							<li class="on">셀러</li>
							<li>관세사</li>
							<li>특송사</li>
							<li>모바일</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!-- //content -->
	</div>
    <%@ include file="/WEB-INF/jsp/main/include-main-footer.jsp" %>
</div>
</body>
</html>
