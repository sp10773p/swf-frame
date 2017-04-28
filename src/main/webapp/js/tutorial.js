$(document).ready(function(){
    var curNum = 0; //현재페이지
    var isQ = [true, false, false, false, false, false, false]; //페이지 활성 여부
    var chkLogin = MAIN_VARS["isLogin"]; //로그인 체크 변수

    if(chkLogin == true){
        $('.tut_nav li').eq(6).find("p").html("goGLOBAL 수출신고를 하세요")
    }
    //nav 각 넘버 클릭시
    $('.tut_nav a').on('click', function(){
        var numIdx = $(this).parent().index();

        if(isQ[numIdx] == true){
            if(numIdx == 6 && chkLogin == true){
                numIdx = 7;
            }

            $('.tut_nav li').eq(curNum == 7 ? 6 : curNum).removeClass('on');
            $('.tut_nav li').eq(curNum == 7 ? 6 : curNum).addClass('last');
            $('.tut_con li').eq(curNum).hide();
            $('.tut_con li').eq(numIdx).fadeIn(200);
            $('.tut_nav li').eq(numIdx == 7 ? 6 : numIdx).removeClass('last');
            $('.tut_nav li').eq(numIdx == 7 ? 6 : numIdx).addClass('on');
            curNum = numIdx;
        }
    });

    //yes 버튼 클릭시
    $('.yes').on('click', function(){

        var numIdx = $(this).parents('li').index();
        isQ[numIdx+1] = true;

        if(numIdx < isQ.length-1){
            if(numIdx == 5  && chkLogin == true){
                $('.tut_nav li').removeClass('on');
                $('.tut_nav li').eq(numIdx + 1).removeClass('last');
                $('.tut_nav li').eq(numIdx).addClass('last');
                $('.tut_nav li').eq(numIdx + 1).addClass('on');
                $('.tut_con li').hide();
                $('.tut_con li').eq(numIdx+2).fadeIn(200);
                curNum = numIdx+2;

            } else {
                $('.tut_nav li').removeClass('on');
                $('.tut_nav li').eq(numIdx + 1).removeClass('last');
                $('.tut_nav li').eq(numIdx).addClass('last');
                $('.tut_nav li').eq(numIdx + 1).addClass('on');
                $('.tut_con li').hide();
                $('.tut_con li').eq(numIdx+1).fadeIn(200);
                curNum = numIdx+1;
            }
        }

    });

    $('.q_yn > .no').on('click', function() {

        var numIdx = $(this).parents('li').index();
        if (Number(numIdx) == 4){
            window.open("http://trass.or.kr/static-html/bcc/hsnavigation.jsp");
        }
    })

    //no 버튼 클릭시
    $('.answer .no').on('click', function(){
        $(this).parent('div').hide();
        $(this).parent('div').next('div').fadeIn(200);
        $(this).parents('li').find($('.q_yn')).fadeIn();
    });

});
