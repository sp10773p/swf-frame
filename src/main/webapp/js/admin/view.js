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
    //header메뉴
    $('.head_btn > a').each(function(){
        $(this).click(function(){
            $(this).addClass('on');
            $(this).siblings().removeClass('on');
        });
    });

    //날짜검색버튼
    $('.btn_day > a').each(function(){
        $(this).click(function(e){
            $(this).addClass('day_select');
            $(this).siblings().removeClass();
            e.preventDefault();
        });
    });

    //search_frame_toggle
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
            }
        });
    });

    //제목을 누르면 닫히는 프레임
    $('.btnToggle').click(function(e){
        $('~ .white_frame', this.parentNode).toggle();
        e.preventDefault();
    });
    //제목을 누르면 table이 닫히는 프레임
    $('.btnToggle_table').click(function(e){
        $('~ .table_toggle', this.parentNode).toggle();
        e.preventDefault();
    });


    //lnb토글
    $('#lnb_btn').click(function(e){
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
            $(this).parent().siblings().children().next().children().removeClass('on');
            e.preventDefault();
        });
    });

    $('.toggle').click(function(e) {
        e.preventDefault();

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