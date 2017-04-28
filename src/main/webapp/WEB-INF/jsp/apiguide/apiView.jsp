<%--
    Class Name : apiView.jsp
    Description : Open API별 상세정보
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-04-03  정안균   최초 생성

    author : 정안균
    since : 2017-04-03
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.pe.frame.cmm.core.base.Constant" %>
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
	<c:set var="session" value='<%= request.getSession().getAttribute(Constant.SESSION_KEY_USR.getCode())%>'/>
	<script>

	    $(function () {
          $.comm.send("/apiguide/selectApiInfo.do", {"API_ID": "${API_ID}"},
	                function(data){
	                    var result = data.data;
	                    if(result) {
	                    	var apiInfo = result["apiInfo"];
		                    if(apiInfo) {
		                    	$('#API_DESC').html("<span>ㆍ</span>" + apiInfo["API_DESC"]);
			                    $('#API_URL').html("https://www.goglobal.co.kr" + apiInfo["API_URL"]);
		                    }
		                    if("${session}" && "${session.getUserDiv()}") {
		                    	$.comm.display(["display"], true); 
		                    	
		                    	var reqTreeList = result["reqTreeList"];
			                    var maxReqLvl = parseInt(result["REQ_MAX_LVL"]);
			                    $('#REQ_TH_COL').attr("colspan", maxReqLvl); 
			                    for(var k=0; k < maxReqLvl; k++) {
			                    	if(k < maxReqLvl-1) {
			                    		$('#REQ_FIRST_COL').before("<col width='50px' />");
			                    	} else {
			                    		$('#REQ_FIRST_COL').before("<col width='*' />");
			                    	}
			                    }
			                    for(var i in reqTreeList) {
			                    	var html = "";
			                    	var reqTree = reqTreeList[i];
			                    	var lvl = parseInt(reqTree["LVL"]);
			                    	if(lvl > 0) {
			                    	 	html += "<tr>";
			                    		for(var j=0; j < (lvl-1); j++) {
			                    			html += "<td></td>";
			                    		}
			                    		var jsonKey = reqTree["JSON_KEY"] ? reqTree["JSON_KEY"] : "";
			                    		var loopYn = reqTree["LOOP_YN"] ? reqTree["LOOP_YN"] : "";
			                    		var mandiType = reqTree["MANDI_TYPE"] ? reqTree["MANDI_TYPE"] : "";
			                    		var dataType = reqTree["DATA_TYPE"] ? reqTree["DATA_TYPE"] : "";
			                    		var jsonNm = reqTree["JSON_NM"] ? reqTree["JSON_NM"] : "";
			                    		var jsonSamp = reqTree["JSON_SAMP"] ? reqTree["JSON_SAMP"] : "";
			                    		html += "<td colspan='" + (maxReqLvl-lvl+1) + "'>" + jsonKey + "</td>"
			                    		html += "<td>" + loopYn+ "</td>"
			                    		html += "<td>" + mandiType+ "</td>"
			                    		html += "<td>" + dataType + "</td>"
			                    		html += "<td>" + jsonNm + "</td>"
			                    		html += "<td>" + jsonSamp + "</td>"
			                    		html += "</tr>";
			                    	}
			                    	$('#REQ_TREE').append(html);
			                    }
			                    
			                    var resTreeList = result["resTreeList"];
			                    var maxResLvl = parseInt(result["RES_MAX_LVL"]);
			                    for(var k=0; k < maxResLvl; k++) {
			                    	if(k < maxResLvl-1) {
			                    		$('#RES_FIRST_COL').before("<col width='50px' />");
			                    	} else {
			                    		$('#RES_FIRST_COL').before("<col width='*' />");
			                    	}
			                    }
			                    $('#RES_TH_COL').attr("colspan", maxResLvl); 
			                    for(var i in resTreeList) {
			                    	var html = "";
			                    	var resTree = resTreeList[i];
			                    	var lvl = parseInt(resTree["LVL"]);
			                    	if(lvl > 0) {
			                    	 	html += "<tr>";
			                    		for(var j=0; j < (lvl-1); j++) {
			                    			html += "<td></td>";
			                    		}
			                    		var jsonKey = resTree["JSON_KEY"] ? resTree["JSON_KEY"] : "";
			                    		var loopYn = resTree["LOOP_YN"] ? resTree["LOOP_YN"] : "";
			                    		var mandiType = resTree["MANDI_TYPE"] ? resTree["MANDI_TYPE"] : "";
			                    		var dataType = resTree["DATA_TYPE"] ? resTree["DATA_TYPE"] : "";
			                    		var jsonNm = resTree["JSON_NM"] ? resTree["JSON_NM"] : "";
			                    		var jsonSamp = resTree["JSON_SAMP"] ? resTree["JSON_SAMP"] : "";
			                    		html += "<td colspan='" + (maxResLvl-lvl+1) + "'>" + jsonKey + "</td>"
			                    		html += "<td>" + loopYn+ "</td>"
			                    		html += "<td>" + mandiType+ "</td>"
			                    		html += "<td>" + dataType + "</td>"
			                    		html += "<td>" + jsonNm + "</td>"
			                    		html += "<td>" + jsonSamp + "</td>"
			                    		html += "</tr>";
			                    	}
			                    	$('#RES_TREE').append(html);
			                    }
			                    
			                    var jsonReqObj = JSON.parse(result["reqTreeJson"]);
			                    $('#REQ_JSON').html(JSON.stringify(jsonReqObj, null, '\t'));
			                    var jsonResObj = JSON.parse(result["resTreeJson"]);
			                    $('#RES_JSON').html(JSON.stringify(jsonResObj, null, '\t'));
		                    } 
	                    }
	                },
	                "API 정보 조회"
	        );
	    });
	</script>
</head>
<body>
<div class="inner-box bg_sky">
	<div class="padding_box">
		<div class="bg_frame_content">
            <ul class="info_box box">
                <li id="API_DESC"></li>
            </ul>
            <div class="title_frame">
				<p>요청 URL</p>
				<div class="padding_box url">
					<p id="API_URL"></p>
				</div>
            </div>
			<div class="title_frame">
				<p>HTTP Request/response</p>
				<div class="table_typeC">
					<table style="text-align: center;">
						<colgroup>
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>Method</th>
								<th>Content-Type</th>
								<th>Data Format</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>요청</th>
								<td>POST</td>
								<td>Application/ison</td>
								<td>JSON</td>
							</tr>
							<tr>
								<th>응답</th>
								<td></td>
								<td>Application/ison</td>
								<td>JSON</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div id="display" style="display: none;">
				<div class="title_frame">
					<p>요청 JSON 데이터 피라미터 정의(M: 필수, O: 비필수)</p>
					<div class="list_typeB">
						<table>
							<colgroup>
								<col width="50px" id="REQ_FIRST_COL"/>
								<col width="50px" />
								<col width="257px" />
								<col width="257px" />
								<col width="202px" />
							</colgroup>
							<thead>
								<tr>
									<th id="REQ_TH_COL">JSON Key</th>
									<th>반복</th>
									<th>필수</th>
									<th>데이터타입</th>
									<th>설명</th>
									<th>샘플</th>
								</tr>
							</thead>
							<tbody id="REQ_TREE">
								
							</tbody>
						</table>
					</div>
				</div>
				<div class="title_frame">
					<p>요청 데이터 샘플</p>
					<div class="box data_sample" style="white-space:pre;" id="REQ_JSON">
					</div>
				</div>
				<div class="title_frame">
					<p>응답 데이터 항목 정의 (M: 필수, O: 선택)</p>
					<div class="list_typeB">
						<table>
							<colgroup>
								<col width="50px" id="RES_FIRST_COL"/>
								<col width="50px" />
								<col width="257px" />
								<col width="257px" />
								<col width="202px" />
							</colgroup>
							<thead>
								<tr>
									<th id="RES_TH_COL">JSON Key</th>
									<th>반복</th>
									<th>필수</th>
									<th>데이터타입</th>
									<th>설명</th>
									<th>샘플</th>
								</tr>
							</thead>
							<tbody id="RES_TREE">
							</tbody>
						</table>
					</div>
				</div>
				<div class="title_frame">
					<p>응답 JSON 데이터 샘플</p>
					<div class="box data_sample" style="white-space:pre;" id="RES_JSON">
					</div>
				</div>
			</div>
		</div><!-- //bg_frame_content -->
	</div><!-- //padding_box -->
</div><!-- //inner-box -->

</body>
</html>
