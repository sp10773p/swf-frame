<%--
  User: jjkhj
  Date: 2017-01-11
  Form: 수출정정신청  List
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
				{"HEAD_TEXT": "전송"        		, "WIDTH": "80"    	, "FIELD_NAME": "SEND_NM"},
				{"HEAD_TEXT": "수신"        		, "WIDTH": "80"    	, "FIELD_NAME": "RECE_NM", "LINK":"fn_resList"},
                {"HEAD_TEXT": "수출신고번호"      	, "WIDTH": "150"   	, "FIELD_NAME": "RPT_NO" , "LINK":"fn_detail"},
                {"HEAD_TEXT": "차수"       	    , "WIDTH": "60"   	, "FIELD_NAME": "MODI_SEQ"},
                {"HEAD_TEXT": "구분"       		, "WIDTH": "120"    , "FIELD_NAME": "SEND_DIVI_NM"},
                {"HEAD_TEXT": "정정신청일자"    	, "WIDTH": "100"   	, "FIELD_NAME": "MODI_DAY"},
                {"HEAD_TEXT": "수출신고일자"     	, "WIDTH": "100"   	, "FIELD_NAME": "RPT_DAY"},
                {"HEAD_TEXT": "수출수리일자"     	, "WIDTH": "100"   	, "FIELD_NAME": "LIS_DAY"},
                {"HEAD_TEXT": "정정승인일자"      	, "WIDTH": "100"   	, "FIELD_NAME": "DPT_DAY"},
                {"HEAD_TEXT": "수출자상호"    	, "WIDTH": "150"    , "FIELD_NAME": "EXP_NAME" , "ALIGN": "left"},
                {"HEAD_TEXT": "정정사유부호"    	, "WIDTH": "200"   	, "FIELD_NAME": "MODI_DIVI_NM" , "ALIGN": "left"},
                {"HEAD_TEXT": "귀책사유부호"    	, "WIDTH": "150"   	, "FIELD_NAME": "DUTY_CODE_NM" , "ALIGN": "left"},
                {"HEAD_TEXT": "정정취하사유"    	, "WIDTH": "150"   	, "FIELD_NAME": "MODI_COT" , "ALIGN": "left"},
                {"HEAD_TEXT": "세관"    			, "WIDTH": "150"   	, "FIELD_NAME": "CUS_NM" , "ALIGN": "left"},
                {"HEAD_TEXT": "과"    			, "WIDTH": "150"   	, "FIELD_NAME": "SEC_NM" , "ALIGN": "left"},
                {"HEAD_TEXT": "담당자"    		, "WIDTH": "100"    , "FIELD_NAME": "JU_NAME"}
                
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출정정신청 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "mod.selectModList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL", "qKey":"mod.selectModList"}
                ]
            });
            
         	// 전송
            $('#btnSend').on('click', function (e) {
                fn_send();
            });
         	
         	// 출력
            $('#btnPrint').on("click", function (e) {
            	var size = gridWrapper.getSelectedSize();
            	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
            	
            	//상태값을 체크해서 출력가능 상태만 다시 체크해준다.
            	var gridData = gridWrapper.getData();
            	if(!fn_chkStatusPrint()) {
            		$.each (gridData, function(index, data) {
            			if($("input:checkbox[id='gridLayerChk" + index + "']").is(":checked")){
	            			if(data["RECE"] !== undefined &&("02".match(data["RECE"]) || "05".match(data["RECE"]) || "07".match(data["RECE"]) || "09".match(data["RECE"]))){
	                			gridWrapper.setCheck(index, true);
	               			}else{
	               				gridWrapper.setCheck(index, false);
	               			}
            			}
                    });
            		return;
            	}
            	
            	var gridSelectedRows = gridWrapper.getSelectedRows();
            	var params = {};
            	var cnt = 0;
            	$.each (gridSelectedRows, function(index, data) {
            		cnt = cnt + 1;
            		params["pRPT_NO." + cnt] = data["RPT_NO"];
            		params["pMODI_SEQ." + cnt] = data["MODI_SEQ"];
                   
                });
        		if(cnt > 1) {
        			fnMultiReportPrint('CUSDMR5ASV', params, "수출신고 정정/취하/적재기간연장 승인(신청)서 출력", cnt); 
        		} else {
        			params["pRPT_NO"] = params["pRPT_NO.1"];
        			params["pMODI_SEQ"] = params["pMODI_SEQ.1"];
        			fnReportPrint('CUSDMR5ASV', params, '수출신고 정정/취하/적재기간연장 승인(신청)서 출력');
        		}
            });
            
            $.comm.bindCombo("RECE"   , "AAA1003",  true, null, null, null, 1);	//상태
        });

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            data["SAVE_MODE"] = "";

            $.comm.forward("exp/dec/modDetail", data);
        }
        
     	// 전송
        function fn_send() {
        	var size = gridWrapper.getSelectedSize();
            if(size < 1){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다
                return;
            }
            
            if(!fn_chkStatus()) {
        		return;
        	}

            if(!confirm($.comm.getMessage("C00000015"))){ // 전송 하시겠습니까?
                return;
            }
            
            var idendtifyId = fn_getIdentifier("ECC");
        	if(!idendtifyId) {
        		alert($.comm.getMessage("W00000064"), "식별자"); //식별자가 존재하지 않습니다.
        		return;
        	}

            var rows = gridWrapper.getSelectedRows();
            for(var i=0; i < rows.length; i++) {
        		rows[i]["REQ_KEY"] = rows[i]["RPT_NO"]+"_"+rows[i]["MODI_SEQ"]
        		rows[i]["SNDR_ID"] = idendtifyId;
        		rows[i]["RECP_ID"] = "KCS4G001";
        		rows[i]["DOC_TYPE"] = "GOVCBR5AS";
        	}

            $.comm.send("/mod/saveExpDmrSend.do", rows, fn_callback, "수출정정 전송");
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
            	gridWrapper.requestToServer();
            }
        }
        
     	// 상태 체크
        function fn_chkStatus() {
        	var selectDataList = gridWrapper.getSelectedRows();
        	var status = [];
        	var rece = [];
        	var msg = "";
        	var flag = true;
        	for(var i=0; i < selectDataList.length; i++) {
        		status[i] = selectDataList[i]["SEND"];
        		rece[i] = selectDataList[i]["RECE"];
        		if(!"01".match(status[i]) && !"90".match(status[i])){
        			if(rece[i] === undefined || !"01".match(rece[i])){
	        			msg += selectDataList[i]["RPT_NO"] +"는 전송할 수 없는 상태입니다.\n";
	        			flag = false;
        			}
        		}
        	}
        	if(!flag){
        		msg += "등록, 전송실패(전송) 또는 오류(수신)만 전송할 수 있습니다.";
				alert(msg);        		
				return false;
        	}

            return true;
        }
     	
        function fn_getIdentifier(type) {
        	var returnData = "";
        	var param = {
        			"qKey": "dec.selectCmmIdentifier",
        			"TYPE": type
        	};
        	var data = $.comm.sendSync("/common/select.do", param, '식별자 조회').data;
        	if(data) {
        		returnData = data.IDENTIFY_ID;
        	}
        	return returnData;
        }
        
     	// 세관통보문서 화면이동
        function fn_resList(index){
        	var data = gridWrapper.getRowData(index);
        	data["CALL_TYPE"] = "MOD";
        	$.comm.forward("exp/res/resList", data);
        }
     	
     	// 출력상태 체크
        function fn_chkStatusPrint() {
        	var selectDataList = gridWrapper.getSelectedRows();
        	var rece = [];
        	var msg = "";
        	var flag = true;
        	for(var i=0; i < selectDataList.length; i++) {
        		rece[i] = selectDataList[i]["RECE"];
       			if(rece[i] === undefined || (!"02".match(rece[i])&& !"05".match(rece[i])&& !"07".match(rece[i])&& !"09".match(rece[i]))){
        			msg += selectDataList[i]["RPT_NO"] +"는 출력할 수 없는 상태입니다.\n";
        			flag = false;
       			}
        	}
        	if(!flag){
        		alert(msg + $.comm.getMessage("I00000020")); //[접수, 승인, 서류변경, 기각] 상태 일때만 출력할 수 있습니다.
				return false;
        	}

            return true;
        }

    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
	                <ul class="search_sectionC">
	                    <li>
	                        <label for="SEARCH_DTM" class="search_title">검색기준일자</label>
	                        <select id="SEARCH_DTM" name="SEARCH_DTM" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="MODI" selected>정정신청일자</option>
	                            <option value="RPT">수출신고일자</option>
	                            <option value="LIS">수출수리일자</option>
	                        </select>
	                        <div class="search_date">
	                            <form action="#">
	                                <fieldset>
	                                    <legend class="blind">달력</legend>
	                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                            </form>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="RECE" class="search_title">수신</label>
	                        <select id="RECE" name="RECE" class="search_input_select inputHeight"></select>
	                    </li>
	                    <li>
	                        <label for="RPT_NO" class="search_title">수출신고번호</label>
	                        <input id="RPT_NO" name="RPT_NO" type="text" value='<c:if test="${RPT_NO ne null}"><c:out value="${RPT_NO}"></c:out></c:if>' class="search_input" <attr:pk/> />
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div>

        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_100" id="btnExcel">엑셀다운로드</a>
                <a href="#" class="btn white_84" id="btnPrint">출력</a>
                <a href="#" class="btn white_84" id="btnSend">전송</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 413px">
            </div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div> <%-- inner-box --%>


<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
