$(document).ready(function(){
	//footer family site
	$('.family_site span').on('click', function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on').next('ul').slideUp();

		}else{
			$(this).addClass('on').next('ul').slideDown();
		}
	});
	$('.family_site ul li a').on('click', function(){
		$('.family_site > span').removeClass('on');
		$(this).parent().parent('ul').slideUp();
	});

	//메인 비주얼 슬라이드 설정값
	var swiperMain = new Swiper('.before_slide', {
        pagination: '.before_slide .swiper-pagination',
        nextButton: '.btn_next',
        prevButton: '.btn_prev',
        slidesPerView: 1,
        paginationClickable: true,
		autoplayDisableOnInteraction: false,
		speed: 700,
		simulateTouch: false,
        autoplay: 5000,  //자동 플레이 기능 설정 및  시간설정
    	loop: true
    });

	//소개 슬라이드
	var visual = $('.service_slide > li');
    var button = $('.pagination > li');
    var current = 0;

    button.on('click', function(e){
		e.preventDefault();
		var tg = $(this);
		var i = tg.index();

		button.removeClass('on');
		tg.addClass('on');

		move(i);
    });

    function move(i){
        if(current == i) return;

        var currentEl = visual.eq(current);
        var nextEl = visual.eq(i);

        currentEl.css({left:0}).stop().animate({left:'-100%'});
        nextEl.css({left:'100%'}).stop().animate({left:0});

        current = i;
    }

    //배너 드래그 방지
    $('.introduction_area').on('selectstart', function(e){
        return false;
    });

    $('.introduction_area').on('dragstart', function(e){
        return false;
    });

});

//visual 텍스트 롤링
$(function() {
	window.currentIdx = null;
    var topPos = 86;  //20170420 높이값 변경
	var topUpPos = 50;
	var topDownPos = 200;

	var textNum = $("li.hashtag").length;

	function initText(){
		$("li.hashtag").each(function(idx) {
			if(idx === 0){
				TweenMax.set( $(this), {top: topPos, scale: 1, alpha: 1} );
			} else {
				TweenMax.set( $(this), {top: 250, scale: 0.5, alpha: 0} );
			}
		});

		$(".hashtag_subtxt li").each(function(idx) {
			if (idx === 0) {
				$(this).css("display", "block");
			}
		});
        $(".bracket,.hashtag_move").css('display','block');
	}
	initText();

	window.cntRollingUp = function() {
		var nIdx = window.currentIdx+1;
		for (var i = 0; i < textNum; i++) {
			if(nIdx == i){
				TweenMax.to( $("li.hashtag").eq(i),1, {top: topPos, scale: 1, alpha: 1, ease:Power4.easeOut} );
				TweenMax.to( $(".hashtag_subtxt li").eq(i),1,{alpha:1, ease:Power4.easeOut});
				//$(".hashtag_subtxt li").eq(i).fadeIn();
			} else {
				if(nIdx == textNum){
					TweenMax.to( $("li.hashtag").eq(0),1, {top: topPos, scale: 1, alpha: 1, ease:Power4.easeOut} );
					TweenMax.to( $(".hashtag_subtxt li").eq(0),1,{alpha:1, ease:Power4.easeOut});
					//$(".hashtag_subtxt li").eq(0).fadeIn();
				}
				TweenMax.to( $("li.hashtag").eq(i),1, {top: topUpPos, scale: 0.5, alpha: 0, ease:Power4.easeOut, onComplete:locatedCenter(i)} );
				TweenMax.to( $(".hashtag_subtxt li").eq(i),1,{alpha:0, ease:Power4.easeOut});
				//$(".hashtag_subtxt li").eq(i).fadeOut();
			}
		}
	    };

    window.cntRollingDown = function() {
		var nIdx = window.currentIdx;
		if(nIdx === 0){
			TweenMax.to( $("li.hashtag").eq(0),1, {top: topUpPos, scale: 0.5, alpha: 0, ease:Power4.easeOut} );
			TweenMax.to( $(".hashtag_subtxt li").eq(0),1,{alpha:0, ease:Power4.easeOut});
			TweenMax.to( $("li.hashtag").eq(textNum-1),1, {top: topPos, scale: 1, alpha: 1, ease:Power4.easeOut} );
			TweenMax.to( $(".hashtag_subtxt li").eq(textNum-1),1,{alpha:1, ease:Power4.easeOut});
		} else {
			for(var i = 0; i < textNum; i++){
				if(i == nIdx){
					TweenMax.to( $("li.hashtag").eq(i-1),1, {top: topPos, scale: 1, alpha: 1, ease:Power4.easeOut} );
					TweenMax.to( $(".hashtag_subtxt li").eq(i-1),1,{alpha:1, ease:Power4.easeOut});
				} else {
					TweenMax.to( $("li.hashtag").eq(i-1),1, {top: topUpPos, scale: 0.5, alpha: 0, ease:Power4.easeOut} );
					TweenMax.to( $(".hashtag_subtxt li").eq(i-1),1,{alpha:0, ease:Power4.easeOut});
				}

			}
		}
    };

		window.cntRollingIndex = function(index) {
		$("li.hashtag").each(function(idx) {
			if(idx == index-1){
				TweenMax.to( $("li.hashtag").eq(idx),1, {top: topPos, scale: 1, alpha: 1, ease:Power4.easeOut} );
				TweenMax.to( $(".hashtag_subtxt li").eq(idx),1,{alpha:1, ease:Power4.easeOut});
			} else {
				TweenMax.to( $("li.hashtag").eq(idx),1, {top: topUpPos, scale: 0.5, alpha: 0, ease:Power4.easeOut} );
				TweenMax.to( $(".hashtag_subtxt li").eq(idx),1,{alpha:0, ease:Power4.easeOut});
			}
        });
	};

	function locatedCenter(txtObj){
		$("li.hashtag").each(function(idx) {
            if(idx == txtObj){
				$(this).css('top',topDownPos);
			}
        });
	}

});

//레이어팝업
function layerPop(url) {
	var wTop = $(window).scrollTop();
	if (url === '' || url === null) {
		$('#layer').fadeOut(200);
		$('body').removeClass('layer');
		wTop = parseInt($('#container').css('top')) * -1;
		$('#container').css('top', '0');
		$('body').css('overflow', 'auto');
		$(window).scrollTop(wTop);
	} else {
		url = 'layer/' + url + '.html';
		$('#layer').load(url, function() {
			$('#layer').fadeIn(300);
			$('body').addClass('layer');
			$('body').css('overflow', 'hidden');
			$('#container').css('top', -wTop + 'px');
		});
	}
	$('#header').css('top', '0');
}
