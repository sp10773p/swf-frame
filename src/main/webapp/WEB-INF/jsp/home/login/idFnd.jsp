<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/base.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/sub.css'/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/main.css'/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/main/layerPop.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/nicescroll.css'/>" />

    <script src="<c:url value='/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
    <script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/main.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/swiper.jquery.js'/>" charset="utf-8"></script>
    <script src="<c:url value='/js/TweenMax.js'/>" charset="utf-8"></script>

    <script type="text/javascript">
        $(function(){
            $('#btnFindId').on('click', function() {
                if ($.trim($('#user_mail').val()) === '') {
                    alert("이메일을 입력해 주십시오.");
                    $('#user_mail').focus();
                    return false;
                }

                var isBizNo = true;
                var bizObj = "";
                if ($.trim($('#bizNo1').val()) === '') {
                    isBizNo = false;
                    bizObj = $('#bizNo1');
                } else if($.trim($('#bizNo2').val()) === '') {
                    isBizNo = false;
                    bizObj = $('#bizNo2');
                } else if($.trim($('#bizNo3').val()) === '') {
                    isBizNo = false;
                    bizObj = $('#bizNo3');
                }

                if(!isBizNo) {
                    alert("사업자번호를 입력해 주세요.");
                    $(bizObj).focus();
                    return false;
                }

                var userDiv = $(':radio[name="userDiv"]:checked').val();
                if ($.trim(userDiv) === '') {
                    alert("사용자 구분을 체크해 주십시오.");
                    return false;
                }

                var param = {
                    "qKey"           : "homeLogin.selectUser",
                    "EMAIL"          : $('#user_mail').val(),
                    "ACTION_MENU_ID" : "idFnd",
                    "ACTION_MENU_NM" : "아이디 찾기",
                    "BIZ_NO"         : $('#bizNo1').val() + $('#bizNo2').val() + $('#bizNo3').val(),
                    "USER_DIV"       : userDiv
                };

                $.comm.send("/homeLogin/idFnd.do", param,
                    function(data, status){
                        var resultData = data.data;
                        if(resultData && resultData["USER_ID"]) {
                            $("#find_id").html(resultData["USER_ID"]);
                            $.comm.display(["find_result"], true);

                        } else {
                            $.comm.display(["find_result"], false);
                            alert("일치하는 정보가 없습니다.");
                        }
                    }
                )
            })

            $('#btnFindPwPage').on('click', function () {
                location.href = "<c:url value="/jspView.do?jsp="/>home/login/pwdFnd";
            })
            
            $("#bizNo1, #bizNo2").keyup (function () {
                var maxLength = $(this).attr("maxlength");
                if (this.value.length == Number(maxLength)) {
                    $(this).nextAll("input[type=text]")[0].focus();
                    return false;
                }
            });
        })
    </script>
</head>
<body>
<div id="wrap">
    <%@ include file="/WEB-INF/jsp/main/include-main-header.jsp" %>

    <div id="container">
        <!-- content -->
        <div id="content" style="height: 720px; border-top: 1px solid;">
            <div class="inner-box bg_sky" style="width: 1350px; margin: auto">
                <div class="padding_box">
                    <div class="bg_frame_content">
                        <p class="wc_tit"><strong>전자상거래무역 서비스 사이트에 오신 것을 환영합니다.</strong><br />당 서비스는 회원가입을 하셔야 이용이 가능합니다.</p>
                        <div class="form_area find">
                            <form action="" method="post" class="login_input">
                                <fieldset class="clearfix">
                                    <legend class="blind">아이디 찾기</legend>
                                    <div>
                                        <label for="user_mail">이메일</label>
                                        <input type="text" id="user_mail">
                                    </div>
                                    <div class="company_num">
                                        <label for="bizNo1">사업자등록번호</label>
                                        <input type="text" name="bizNo1" id="bizNo1" maxlength="3">
                                        <span>-</span>
                                        <input type="text" name="bizNo2" id="bizNo2" maxlength="2">
                                        <span>-</span>
                                        <input type="text" name="bizNo3" id="bizNo3" maxlength="5">
                                    </div>
                                    <div>
                                        <label>구분</label>
                                        <div class="radio">
                                            <input type="radio" id="userDiv1" name="userDiv" value="S" checked="checked"/>
                                            <label for="userDiv1"><span></span>셀러</label>
                                        </div>
                                        <div class="radio">
                                            <input type="radio" id="userDiv2" name="userDiv" value="M" />
                                            <label for="userDiv2"><span></span>몰관리자</label>
                                        </div>
                                        <div class="radio">
                                            <input type="radio" id="userDiv3" name="userDiv" value="G" />
                                            <label for="userDiv3"><span></span>관세사</label>
                                        </div>
                                        <div class="radio">
                                            <input type="radio" id="userDiv4" name="userDiv" value="E" />
                                            <label for="userDiv4"><span></span>특송사</label>
                                        </div>
                                    </div>
                                </fieldset>
                                <div class="btn_area clearfix">
                                    <a href="#" class="b_btn blue_btn" id="btnFindId">확인</a>
                                    <a href="#" class="b_btn blue_btn" id="btnFindPwPage">PW 찾기</a>
                                    <a href="javascript:location.href='<c:url value="/"/>'" class="b_btn gray_btn">취소</a>
                                </div>
                            </form>
                        </div>
                        <div class="blue_box" id="find_result">
                            <p><strong>아이디를 꼭 기억해 주세요.</strong></p>
                            <p class="find_info">회원님의 아이디는 <strong id="find_id"></strong> 입니다.</p>
                        </div>
                    </div>
                </div><!-- //padding_box -->
            </div><!-- //inner-box -->
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/main/include-main-footer.jsp" %>
</div>
</body>
</html>
