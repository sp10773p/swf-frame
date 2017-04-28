<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2017-04-03
  Time: 오후 2:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<html>
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

    <script type="text/javascript">
        $(function(){
            $('.inner-box').niceScroll();
        });//스크롤바 script
    </script>
</head>
<body>
<div class="inner-box bg_sky">
    <div class="padding_box">
        <div class="bg_frame_content">
            <div class="title_frame">
                <p>goGLOBAL 서비스 개요</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>복잡한 전자상거래 관련 무역업무를 쉽고 빠르게 처리하는 서비스로 <strong>글로벌셀러 및 역직구 오픈마켓의 수출신고, 물류, 반품수입신고, 구매확인서, 수출실적명세, 관세환급</strong> 등 무역업무와 관련된 업무를 처리할 수 있습니다. </li>
                </ul>
                <div class="box">
                    <img src="<c:url value="/images/service_info01.png"/>" alt="">
                </div>
            </div>
            <div class="title_frame">
                <p>EMS 및 특송사 배송예약</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>사용자가 엑셀 업로드 또는 오픈API를 이용하여 배송정보를 전송하면, 수출신고 내역을 결합하여 EMS의 경우 배송예약 및 물류 추적을 할 수 있도록 해주며, 특송 배송의 경우 특송사가 적하목록신고를 할 수 있도록 도와줍니다.</li>
                </ul>
                <div class="box">
                    <img src="<c:url value="/images/service_info02.png"/>" alt="">
                </div>
            </div>
            <div class="title_frame">
                <p>반품 수입신고 의뢰</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>사용자가 엑셀 업로드 또는 오픈API를 이용하여 반품수입신고를 요청하면, 수출신고 내역을 및 수입관련서류를 검토하여 관세사가 수입신고를 대행합니다.</li>
                </ul>
                <div class="box">
                    <img src="<c:url value="/images/service_info03.png"/>" alt="">
                </div>
            </div>
            <div class="title_frame">
                <p>구매확인서 간편발급 수출실적명세, 관세환급</p>
                <ul class="info_box box">
                    <li><span>ㆍ</span>글로벌셀러는 구매확인서를 보다 간편하게 신청하여 매입물품에 대해 부가세 영세율 혜택을 받으실 수 있습니다.</li>
                    <li><span>ㆍ</span>납품업체는 구매확인서를 수령하여 영세율 혜택 및 간접수출실적을 인정 받을 수있습니다.</li>
                    <li><span>ㆍ</span>글로벌셀러는 부가세신고를 위한 수출실적명세 자료를 엑셀로 다운로드 가능합니다.</li>
                </ul>
                <div class="box">
                    <img src="<c:url value="/images/service_info04.png"/>" alt="">
                </div>
            </div>
        </div><!-- //bg_frame_content -->
    </div><!-- //padding_box -->
</div><!-- //inner-box -->
</body>
</html>
