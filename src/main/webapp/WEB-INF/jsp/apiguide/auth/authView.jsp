<%--
    Class Name : authView.jsp
    Description : 인증키 확인
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-03-30  정안균   최초 생성

    author : 정안균
    since : 2017-03-30
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<html>
<head>
	<link rel="stylesheet" href="<c:url value='/css/base.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/sub.css'/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/nicescroll.css'/>" />
	
	<script src="<c:url value='/js/jquery.min.js'/>"></script>
	<script src="<c:url value='/js/jquery.form.js'/>"></script>
	<script src="<c:url value='/js/jquery-ui.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
	<script src="<c:url value='/js/dtree.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
	<script>

	    $(function () {
	    	$.comm.send("/apiguide/selectCmmApiKeyMng.do", {},
	                function(data){
	                    var status = data.status;
	                    if(status == -1) return;
	                    var apiKeyInfo = data.data;
	                    $.comm.bindData(apiKeyInfo);
	                    var apiKeyList = data.dataList;

	                    for(var i in apiKeyList) {
	                    	var apiInfo = apiKeyList[i];
	                    	var html = "<tr>";
	                    	html += "<th>" + apiInfo["API_NM"] + "</th>";
	                    	html += "<th>" + apiInfo["LIMIT_DETAIL_CNT"] + "</th>";
	                    	html += "<th>" + apiInfo["DAILY_CALL_CNT"] + "</th>";
	                    	html += "<th>" + apiInfo["PER_CALL_CNT"] + "</th>";
	                    	html += "</tr>";
	                    	$('#apiDetail').append(html);
	                    }

	                },
	                "인증키 확인"
	        );
	    });
	</script>
</head>
<body>
<div class="inner-box bg_sky">
	<div class="padding_box">
		<div class="bg_frame_content">
            <ul class="info_box box">
                <li><span>ㆍ</span>오픈 API(Open API)를 통해 간이수출신고 자동연계 시스템을 개발하기 위해서는 먼저 사이트에 회원가입 한 후, 로그인 하시기 바랍니다.</li>
                <li><span>ㆍ</span>오픈키(Key)를 발급받으시려면, 아래 키발급을 신청하시기 바랍니다.</li>
                <li><span>ㆍ</span>관리자가 인증키 발급 승인이 완료되면 자동으로 API 인증키를 확인하실 수 있습니다.</li>
            </ul>
            <div class="title_frame">
			    <p>Open API 인증키 현황</p>
                <div class="list_typeB">
                    <table>
                        <colgroup>
                            <col width="135px"/>
                            <col width="135px"/>
                            <col width="*"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th><label for="API_REQ_DT">신청일</label></th>
                                <th><label for="API_APPORVE_DT">발급일</label></th>
                                <th><label for="API_KEY">발급키</label></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span id="API_REQ_DT"></span></td>
                                <td><span id="API_APPORVE_DT"></span></td>
                                <td><span id="API_KEY"></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
			</div>
            <div class="title_frame">
			    <p>Open API 인증키 사용 제한 기준</p>
                <div class="table_typeC">
                    <table style="text-align: center;">
                        <colgroup>
                            <col width="270px"/>
                            <col width="*"/>
                            <col width="*"/>
                            <col width="*"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2">API 종류</th>
                                <th colspan="3">API 쿼터기준</th>
                            </tr>
                            <tr>
                                <th>1회 호출 건수</th>
                                <th>1일 호출 건수</th>
                                <th>동시접속 건수</th>
                            </tr>
                        </thead>
                        <tbody id="apiDetail">
   
                        </tbody>
                    </table>
                </div>
			</div>
		</div><!-- //bg_frame_content -->
	</div><!-- //padding_box -->
</div><!-- //inner-box -->

</body>
</html>
