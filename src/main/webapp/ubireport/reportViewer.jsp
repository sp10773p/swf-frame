<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	int reportCnt = 1;
	try{
		reportCnt = Integer.parseInt((String)request.getAttribute("reportCnt"));
	} catch(Exception e){}
	request.setAttribute("reportCnt", String.valueOf(reportCnt));
	
	String protocol = "HTTPS"; 
	if(request.getHeader("referer") != null) protocol = request.getHeader("referer").toString().toUpperCase().indexOf("HTTPS") !=-1 ? "HTTPS": "HTTP";
	request.setAttribute("protocol", protocol.toLowerCase());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<title>UbiReport</title>
<script src="/ubireport/ajax/js4/ubiajax.js"></script>
<script type="text/javascript">
/* 기본 정보 */
var host = self.location.host;						// ip:port
var app = "";										// WebApplication 명.

// os.name이 유닉스에서도 되는지 확인 필요
<% if(System.getProperty("os.name").toLowerCase().startsWith("windows")) { %>
	var url = "http://" + host + (app==""?"":("/" + app));	// WebApplication URL.
<% } else { %>
	var url = "https://" + host + (app==""?"":("/" + app));	// WebApplication URL.
<% } %>

/* 환경 설정 정보 */
//var key = "";														사용자 세션 유지용 값. 일반적으로 JSP에서 session.getId() 사용.
var jrf = "${reportFile}";											// 리포트파일명.
//var jrf = "ubi_sample.jrf";
var arg = "${args}".split("|").join("#");							// 아규먼트
//var arg = "qwer.1#하나#qwer.2#둘#qwer.3#셋#";
var res_id = "UBIAJAX";												// ubidaemon.property에 등록된 리소스 아이디.
var viewer_id = "UbiAjaxViewer";									// 뷰어 DIV 아이디.
var scale = "120";												// 미리보기 배율.
var multicount = "${reportCnt}";									// 출력 건수
var timeout = "600000";												// 응답시간 타임아웃(1분).

var w_gap = 12; // 가로 크기 조정.
var h_gap = 12; // 세로 크기 조정.

function Ubi_Resize() { // 브라우저 리사이즈 시 오브젝트 크기 조정.

	var w = ((self.innerWidth || (document.documentElement && document.documentElement.clientWidth) || document.body.clientWidth)) - w_gap;
	var h = ((self.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight)) - h_gap;
	document.getElementById(viewer_id).style.width = w + 'px';
	document.getElementById(viewer_id).style.height = h + 'px';
}

function Ubi_LoadReport() {// 리포트 로드.
	var w = ((self.innerWidth || (document.documentElement && document.documentElement.clientWidth) || document.body.clientWidth)) - w_gap;
	var h = ((self.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight)) - h_gap;
	document.getElementById(viewer_id).style.width = w + 'px';
	document.getElementById(viewer_id).style.height = h + 'px';
	var viewer = new UbiViewer( {

		key       : '<%= session.getId() %>',
		gatewayurl: url + '/UbiGateway.jsp',
		resource  : url + '/ubireport/ajax/js4',
		jrffile   : jrf,
		arg       : arg,
		resid     : res_id,
		divid     : viewer_id,
		scale     : scale,
		ismultireport : 'true',
		multicount : multicount,
		scrollpage : 'true',
		isstreaming : 'true',
		timeout   : timeout
	});
	viewer.showReport();
}
</script>
</head>
<body style='margin:3px' onresize='Ubi_Resize()'>
<div id="UbiAjaxViewer" style="border: solid 1px #aaa; position:relative;"></div>
<script>Ubi_LoadReport();</script>
</body>
</html>
