<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2017-04-19
  Time: 오후 3:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="Generator" content="Atom">
    <meta name="Author" content="SY_Kim">
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>goGLOBAL</title>
    <style type="text/css" media="screen">
        @font-face{
            font-family:NG;
            src:url(/fonts/NanumGothic.eot);
            src:local(※), url(/fonts/NanumGothic.woff) format("woff"), url(/fonts/NanumGothic.ttf) format('truetype')
        }
        *{margin: 0; padding: 0; font-family: 'Dotum', '돋움';text-align: center;}
        a{text-decoration: none;}
        #wrap{position: relative;}
        .errorWrap{width: 646px;height: 424px;position: fixed;top: 50%;left: 50%;margin-top: -212px;margin-left: -323px;}
        .errorBox{width: 646px;height: 366px; box-sizing: border-box;border: 1px solid #ebebeb;padding: 170px 85px 35px;background: url(/images/bg_warn.png) center 40px no-repeat;border-radius: 2px;margin-bottom: 20px;}
        .errorBox h1{font-family: 'NG';color: #b6b8bc;font-size: 23px;margin-bottom: 5px;}
        .errorBox h2{font-family: 'NG';font-size: 26px;margin-bottom: 25px;}
        .errorBox p{font-size: 12px;color: #888;margin-bottom: 20px;line-height: 18px;letter-spacing: -0.04em;}
        .errorBox strong{font-size: 12px;color: #888;}
        .errorBox strong span{color: #f7941d;}
        .buttonWrap{width: 325px;height: 35px;margin: 0 auto;}
        .buttonWrap a{width: 160px;height: 12px;display: inline-block;float: left;padding: 12px 0 11px;border-radius: 3px;color: #fff;text-align: center;font-weight: bold;font-size: 12px;}
        a.btnPrev{background-color: #b6b8bc;margin-right: 5px;}
        a.btnHome{background-color: #15a4fa;}
    </style>
</head>

<body>
<div id="wrap">
    <div class="errorWrap">
        <div class="errorBox">
            <h1>이용에 불편을 드려 죄송합니다.</h1>
            <h2>웹 사이트에서 이 웹 페이지 표시를 거부했습니다.</h2>
            <strong>관련 문의사항은 <span>고객센터 : 02-6000-2169</span>로 문의하여 주십시오.</strong>
        </div>
        <div class="buttonWrap">
            <a href="javascript:history.back()" class="btnPrev">이전페이지로 이동</a>
            <a href="/" class="btnHome">홈페이지로 이동</a>
        </div>
    </div>
</div>
</body>

</html>
