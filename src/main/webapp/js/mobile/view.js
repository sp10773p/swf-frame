$(window).ready(function() {
    common();
    //top 이동 이벤트
    $('.top_move').on('click', function() {
        $('html, body').animate({
            scrollTop: '0'
        }, 200);
    });
});

//scroll top button 이벤트
$(window).scroll(function() {

    sct = $(this).scrollTop();
    if (sct >= 100) {
        $('.top_move').css('display', 'block');
    } else {
        $('.top_move').css('display', 'none');
    }
}).scroll();

//메인메뉴 이벤트
function common() {
    $('#header .btn_menu').on('click', function() {
        $('#wrap').addClass('menu_open');
        $('#header .menu_bg').fadeIn(400);
        $('body').css({
            overflow: 'hidden',
            position: 'fixed'
        });
    });
    $('#menu .btn_menu_close, #header .menu_bg').on('click', function() {
        $('#wrap').removeClass('menu_open');
        $('#header .menu_bg').fadeOut(400);
        $('body').css({
            overflow: 'auto',
            position: ''
        });
    });

    $('#gnb > li > a').on('click', function() {
        var $parent = $(this).parent();
        if ($(this).parent().children('ul').length >= 1) {
            $parent.toggleClass('open');
            $('ul', $parent).slideToggle();
            return false;
        } else {
            $parent.siblings().children().removeClass('on');
            $(this).addClass('on');
        }
    });
}

//레이어팝업
function layerPop(url) {
    var wTop = $(window).scrollTop();
    if (url === '' || url === null) {
        $('#layer').fadeOut(200);
        $('body').removeClass('layer');
        wTop = parseInt($('#container').css('top')) * -1;
        $('#container').css('top', '0');
        $(window).scrollTop(wTop);
    } else {
        //url = 'layer/' + url + '.html';
        $('#layer').load(url, function() {
            $('#layer').fadeIn(300);
            $('body').addClass('layer');
            $('#container').css('top', -wTop + 'px');
        });
        $('#header').css('top', '0');
    }
}
