<%@ page import="kr.pe.frame.cmm.core.base.Constant" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>

<s:eval expression="@config.getProperty('dashBoard.from.date.period')" var="datePeriod"/>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>goGLOBAL user page</title>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main/base.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/mainlayout.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/expandcollapse.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>

	<script src="<c:url value='/js/jquery.min.js'/>"></script>
	<script src="<c:url value='/js/jquery.nicescroll.js'/>"></script>
	<script src="<c:url value='/js/view.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>

	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

	<script type="text/javascript">
        $(function (){
            fn_selectMonthCnt();

            fn_drawCharts();
            
            $('#linkAll').on("click", function (e) { fn_linkDecList(''); });		//전체Count
            $('#linkR02').on("click", function (e) { fn_linkDecList('02'); });		//수리Count
            $('#linkR01').on("click", function (e) { fn_linkDecList('01'); });		//오류Count
        });

        function fn_selectMonthCnt(){
            var param = {
                "qKey"    : "dash.selectModMonthCnt",
                "P_DATE"  	: "${datePeriod}"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
                    $.comm.bindData(data.data);
                    fn_setComma();
                },
                "최근수출정정현황 (${datePeriod}일 이내)"
            );
        }

        function fn_drawCharts(){
            var drawChart = function() {
            	var param = {
	                "qKey"    : "dash.selectSendDiviCnt",
	                "P_DATE"  	: "${datePeriod}"
	            };
            
            	var dataList = $.comm.sendSync("/common/selectList.do", param, '신고구분별 건수 현황').dataList;
            	var dataTable = [];
            	var arr = ["bed3e1", "value", { role: "style" } ];
            	dataTable.push(arr);
            	for(var i=0; i<dataList.length; i++){
                    var data = dataList[i];
            		arr = [data["SEND_DIVI_NM"], data["SEND_DIVI_CNT"], $.comm.chartColor(i)];
            		dataTable.push(arr);
            	}

                var view = $.comm.chartView(dataTable);
                var chart = new google.visualization.BarChart(document.getElementById("cnt_barchart_values"));
                chart.draw(view, $.comm.chartOptions());
            }

            google.charts.load("current", {packages:["corechart"]});
            google.charts.setOnLoadCallback(drawChart);

        }
        
        function fn_linkDecList(gbn){
        	var obj = parent.mfn_getMainFrame();
        	obj.find('#RECE').val(gbn);
        	obj.find('#btnSearch').click();
        }
        
        function fn_setComma(){
           	$("#TOT_CNT").html($.comm.numberWithCommas($("#TOT_CNT").html()));
           	$("#R02_CNT").html($.comm.numberWithCommas($("#R02_CNT").html()));
           	$("#R01_CNT").html($.comm.numberWithCommas($("#R01_CNT").html()));
        }
	</script>
</head>
<body>
<div class="dashboard inner-box">
	<div class="chart_content">
		<div class="export clearfix">
			<div class="chart_title">
				최근수출정정현황 ( <c:out value="${datePeriod}"/>일 이내)
			</div>
			<dl style="width: 34%;">
				<dt class="color_number"><a href="#" id="linkAll"><span id="TOT_CNT"/></a></dt>
				<dd>전체</dd>
			</dl>
			<dl style="width: 33%;">
				<dt><a href="#" id="linkR02"><span id="R02_CNT" style="display: inline;"/></a></dt>
				<dd>접수</dd>
			</dl>
			<dl style="width: 33%;">
				<dt><a href="#" id="linkR01"><span id="R01_CNT" style="display: inline;"/></a></dt>
				<dd>오류</dd>
			</dl>
		</div><!-- export -->
		<br>
		<div class="horizental_bar_graph">
			<div class="chart_title">
				신고구분별 접수건수 현황
			</div>
			<div id="cnt_barchart_values" style="width: 295px; height: 250px;"></div>
		</div><!-- //horizental_bar_graph ::: cnt -->

	</div><!-- //chart_content -->
</div>
</body>
</html>