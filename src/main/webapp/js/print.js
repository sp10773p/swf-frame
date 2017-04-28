/**
 * 리포트 출력
 */
function fnReportPrint(reportFile, params, actionNm){
	try{
		var fileName = reportFile + ".jrf";

		var args = "";
		for(var sid in params){
			args += sid + "|" + params[sid] +"|";
		}

		fnPrintForBrowser(fileName, args, actionNm);
	} catch(e){ 
		alert(e);
	} 
}

//여러 건 출력
function fnMultiReportPrint(reportFile, params, actionNm, reportCnt){
	try{
		var fileName = reportFile + ".jrf";

		var args = "";
		for(var sid in params){
			args += sid + "|" + params[sid] +"|";
		}
		
		fnPrintForBrowser(fileName, args, actionNm, reportCnt);
	} catch(e){ 
		alert(e);
	} 
}

function fnPrintForBrowser(fileName, args, actionNm, reportCnt) {
	var param = new Object();
	param["reportFile"] = fileName;
	param["args"] = args;
	param["actionNm"] = actionNm; 
	param["screenId"] = $.page.getMenuId();
	param["screenNm"] = $.page.getMenuNm();
	if (reportCnt) {
		param["reportCnt"] = reportCnt + '';
	}

	$.comm.postOpen('/printMngt.do', 'WINDOW_REPORT_OPEN_123456789', param);
}
