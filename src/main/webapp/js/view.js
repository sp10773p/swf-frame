var pageControl = {
	isFrame : true,
	isSearch : true,
	isLnb : true
};

//lnb메뉴 스크립트
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-36251023-1']);
_gaq.push(['_setDomainName', 'jqueryscript.net']);
_gaq.push(['_trackPageview']);


$(document).ready(function() {
	//nav 링크
	$('.nav ul.link > li > a').click(function(){
		setTitle($(this).attr('title'));
	}).eq(0).trigger('click');

	if($('.inner-box').length > 0){
        $('.inner-box').niceScroll();
    }

	//nav 링크
	$('.nav ul.link > li > a').click(function(){
		var _this = $(this).attr('value');
		
		if(_this == 'view'){
			$('#btn_search_toggle').css('display','none');
		} else if (_this == 'list'){
			$('#btn_search_toggle').css('display','block');
        }
    });


	//header메뉴
	$('.head_btn > a').each(function(){
		$(this).click(function(){
			$(this).addClass('on');
			$(this).siblings().removeClass('on');
		});
	});

	//lnb메뉴
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

	//lnb메뉴 hover, click
	$('.accordion > li > a').each(function(){
		$(this).on('mouseover',function(){
			$(this).addClass('on');
		});
		$(this).on('mouseleave',function(){
			$(this).removeClass('on');
		});
		$(this).click(function(){
			$(this).next().children().removeClass('on');
		});
		$(this).on('click',function(){
			var _this = $(this).parent();
			if($(this).parent().hasClass('off')){
				_this.addClass('on');
				_this.removeClass('off');
				_this.siblings().removeClass('on').addClass('off');
			}else if($(this).parent().hasClass('on')){
				_this.removeClass('on');
				_this.addClass('off');
				_this.siblings().removeClass('on').addClass('off');
            }
        });
	});
	//lnb메뉴 inner 클릭
	$('.inner > li > a').each(function(){
		$(this).on('click',function(e){
			$(this).parent().addClass('on');
			$(this).parent().siblings().removeClass('on');
			$(this).next().children().removeClass('on');
		});
	});
	//날짜검색버튼
	$('.search_btn_day > a').each(function(){
		$(this).click(function(e){
			$(this).addClass('day_select');
			$(this).siblings().removeClass();
			e.preventDefault();
		});
	});

	/*//search_frame_toggle 각각 검색 닫기 버튼 필요할때 사용
	$('.search_toggle').each(function(){
		$(this).click(function(e){
			$('.search_frame', this.parentNode).toggle();
			e.preventDefault();
			if($(this).hasClass('close')){
				$(this).text('검색열기');
				$(this).removeClass('close').addClass('open');
			}else if($(this).hasClass('open')){
				$(this).text('검색접기');
				$(this).removeClass('open').addClass('close');
			};
		});
	});*/
	
	//search_frame_토글
	$('#btn_search_toggle').click(function(){
		if($('#mainContents').contents().find('.search_frame').hasClass('on')){
			$('#mainContents').contents().find('.search_frame').css('display','none');
			$('#mainContents').contents().find('.search_frame').removeClass('on').addClass('off');
		} else if($('#mainContents').contents().find('.search_frame').hasClass('off')){
			$('#mainContents').contents().find('.search_frame').css('display','block');
			$('#mainContents').contents().find('.search_frame').removeClass('off').addClass('on');
        }
    });

    //search_frame checkbox,radiobox
    $('input[type="checkbox"]').parent('li').css('padding-top','6px');
    $('.radio').parent('li').css('padding-top','5px');

	//lnb토글
	$('#lnb_toggle').click(function(e){
		if(pageControl.isLnb == true){
			$('#container').animate({paddingLeft:'0'})
			$('.head_menu, #header').animate({width:'100%'});
			$('.content_head').animate({left:'0',width:'100%'});
			$('#lnb_section').animate({left:'-240px'});
			pageControl.isLnb = false;
		}else if(pageControl.isLnb == false){
			var widthNum = $(window).width() - 240;
			$('#container').animate({paddingLeft:'240px'});
			$('.head_menu, #header').animate({width:widthNum});
			$('.content_head').animate({left:'240px',width:widthNum});
			$('#lnb_section').animate({left:'0'});
			pageControl.isLnb = true;
        }
        e.preventDefault();
	});
	$('.close').click(function(){
        localStorage.setItem("goglobal_use_dash_on", false);

		$("#container > div.chart .inner-box").niceScroll().remove();
		$('#dash_toggle > img').attr('src','/images/btn/btn_dash_off.png');
		$('#container > div.contents').addClass('depth2-layout');
		$('#container > div.chart').stop().animate({width:0}, 250);
		$('#container > div.contents').stop().animate({left:240}, 300);
		$('#dash_toggle').removeClass('dash_on').addClass('dash_off');
	});

	//iframe_popup
	$('.layerPopup').click(function(){
		var url = $(this).attr('value');
		$('#popup_btn', parent.document).attr('onclick',url);
		$('#popup_btn', parent.document).trigger('click');
	});
	
	//트리메뉴
	if($(".dTree").length > 0){
        $(".dTree").dTree();
    }

	//페이지넘버
	pageNumber();
	//dash_board toggle
	layoutResize();
	//제목을 누르면 닫히는 토글
	titleToggle();
	//제목을 누르면 테이블이 닫히는 토글
	tableToggle();
    //td_input 크기
    td_input();
    //search_toggle_frame
    searchToggle();
});

//리사이즈시 lnb메뉴 반응
$(window).on('resize', function(){
	if(pageControl.isLnb == true){
		var winWidth = $(window).width() - 240;
		$('.head_menu, #header, .content_head').css('width',winWidth);
		pageControl.isLnb == false;
	}else if(pageControl.isLnb == false){
		var winWidth = $(window).width();
		$('.head_menu, #header, .content_head').css('width',winWidth);
		pageControl.isLnb == true;
    }
});

//레이어팝업
function layerPop(url) {
	var wTop = $(window).scrollTop();
	if (url == '' || url == null) {
		$('#layer').fadeOut(200);
		$('body').removeClass('layer');
		wTop = parseInt($('#container').css('top')) * -1;
		$('#container').css('top', '0');
		$(window).scrollTop(wTop);
		setTimeout(function(){
			$(".layer_content.inner-box").niceScroll().remove();
		}, 300);
	} else {
		url = 'layer/' + url + '.html';
		$('#layer').load(url, function() {
			$('#layer').fadeIn(300);
			$('body').addClass('layer');
			$('#container').css('top', -wTop + 'px');
			$(".layer_content.inner-box").niceScroll();
		});
	}
	$('#header').css('top', '0');
}

//윈도우팝업
function winPop(url,w,h,sb){
	var newWin;
	var setting = "width="+w+", height="+h+", top=5, left=20, location=no, resizeable=no, directories=no, scrollbars="+sb;
	var url = 'layer/winpop/' + url + '.html';
	newWin = window.open(url,"",setting);
	newWin.focus();
    $('#win_dim', parent.document).fadeIn(300);
}

//페이지 넘버 
function pageNumber(){
	$('.list_num > a').each(function(){
		$(this).click(function(e){
			$(this).addClass('thisPage');
			$(this).siblings().removeClass();
			e.preventDefault();
		});
	});
}
//dash_board toggle
function layoutResize(){
	$('#dash_toggle').click(function(){
        if($('#dash_toggle').attr("disabled") == "disabled"){
            return;
        }

        var target = $.comm.getTarget(event);
		if($('#dash_toggle').hasClass('dash_on')){
        	if($(target).attr("alt") == "dash-toggle"){
                localStorage.setItem("goglobal_use_dash_on", false);
            }

			$("#container > div.chart .inner-box").niceScroll().remove();
			$('#dash_toggle > img').attr('src','/images/btn/btn_dash_off.png');
			$('#container > div.contents').addClass('depth2-layout');
			$('#container > div.chart').stop().animate({width:0}, 250);
			$('#container > div.contents').stop().animate({left:240}, 300);
			$('#dash_toggle').removeClass('dash_on').addClass('dash_off');
			$('.chart_content').css('display','none');

		} else if($('#dash_toggle').hasClass('dash_off')){
            if($(target).attr("alt") == "dash-toggle"){
                localStorage.removeItem("goglobal_use_dash_on");
            }

			$('#container > div.contents').removeClass('depth2-layout');
			$('#dash_toggle > img').attr('src','/images/btn/btn_dash_on.png');
			$('#container > div.chart').stop().animate({width:300}, 300, function(){
				$("#container > div.chart .inner-box").niceScroll();
			});
			$('#container > div.contents').stop().animate({left:560}, 300);
			$('#dash_toggle').removeClass('dash_off').addClass('dash_on');
			setTimeout(function(){
				$('.chart_content').css('display','block');
			}, 300)
		}
	});
}

//컨텐츠 타이틀 설정
function setTitle(text){
	$('.contents > div.title strong').text(text);
}

//제목을 누르면 닫히는 프레임
function titleToggle(){
	$('.btnToggle').click(function(e){
		$('~ .white_frame', this.parentNode).toggle();
		e.preventDefault();
	});
}

//제목을 누르면 table이 닫히는 프레임
function tableToggle(){
	$('.btnToggle_table').click(function(e){
		$('~ .table_toggle', this.parentNode).toggle();
		e.preventDefault();
	});
}

function td_input(){
    //td_input 크기
    $('.td_recheck').prev().addClass('td_inputA');
    $('.td_find_btn').prev().addClass('td_inputB');
    $('.addressBtn').prev().addClass('address');
}

/*//페이지별 검색버튼 유무 변경
function pageLink(URL, pageType){
	location.href=URL;
	if(pageType == "list"){
		$('#btn_search_toggle', parent.document).css('display','block');
	} else if(pageType == "view" ){
		$('#btn_search_toggle', parent.document).css('display','none');
	}
}*/

function gfn_lmenuExpand(e) {
    //lnb메뉴
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

    //lnb메뉴 hover, click
    $('.accordion > li > a').each(function(){
        $(this).on('mouseover',function(){
            $(this).addClass('on');
        });
        $(this).on('mouseleave',function(){
            $(this).removeClass('on');
        });
        $(this).click(function(){
            $(this).next().children().removeClass('on');
        });
        $(this).on('click',function(){
            var _this = $(this).parent();
            if($(this).parent().hasClass('off')){
                _this.addClass('on');
                _this.removeClass('off');
                _this.siblings().removeClass('on').addClass('off');
            }else if($(this).parent().hasClass('on')){
                _this.removeClass('on');
                _this.addClass('off');
                _this.siblings().removeClass('on').addClass('off');
            };
        });
    });

    //lnb메뉴 inner 클릭
    $('.inner > li > a').each(function(){
        $(this).on('click',function(e){
            $(this).parent().addClass('on');
            $(this).parent().siblings().removeClass('on');
            $(this).next().children().removeClass('on');
        });
    });

    $('.toggle').click(function(e) {
        var $this = $(this);

        if ($this.next().hasClass('show')) {
            $this.next().removeClass('show');
            $this.next().slideUp(350);
        } else {
            $this.parent().parent().find('li .inner').removeClass('show');
            $this.parent().parent().find('li .inner').slideUp(350);
            $this.next().toggleClass('show');
            $this.next().slideToggle(350);
        }

        $("li a.toggle").not(this).removeClass('expanded'); //if clicking off from this toggle, will collapse all other list items
        $this.parents('.inner').siblings('a.toggle').addClass("expanded"); // ensures all ancestors of this class will also remain expanded
        $this.toggleClass("expanded"); // to expand or collapse arrow on click (toggle)
    });
}

//search_frame_toggle 각각 검색 닫기 버튼 필요할때 사용
function searchToggle() {
    $('.search_toggle').each(function(){
        $(this).click(function(e){
            $('.search_frame', this.parentNode).toggle();
            e.preventDefault();
            if($(this).hasClass('close')){
                $(this).text('검색열기');
                $(this).removeClass('close').addClass('open');
            }else if($(this).hasClass('open')){
                $(this).text('검색접기');
                $(this).removeClass('open').addClass('close');
            };
        });
    });
}