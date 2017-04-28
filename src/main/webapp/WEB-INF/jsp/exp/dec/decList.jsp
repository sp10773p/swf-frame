<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출신고조회 목록
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
	<s:eval expression="@config.getProperty('summary.from.date.period')" var="datePeriod"/>
    <script>
        var gridWrapper, headers;
        $(function (){
            $.comm.bindCombo("RECE"   , "AAA1002",  true, null, null, null, 1);	//상태

            // 로그인 화면의 수출신고건수에서 링크
            if(!$.comm.isNull(parent.mfn_getVariable("DEC_STATUS"))){
                var status = parent.mfn_getVariable("DEC_STATUS");
                if(status == "SELLER_COUNT"){ // 신고처리
                    $('#RECE').val("03");

                }else if(status == "SELLER_ERR_COUNT") { // 신고오류
                    $('#RECE').val("01");

                }

                $('#SEARCH_DTM').val("A.RPT_DAY");

                $('#F_REG_DTM').val(new Date().dateAdd2("d", parseInt("${datePeriod}")*-1).format('YYYY-MM-DD'));
                $('#T_REG_DTM').val(new Date().format('YYYY-MM-DD'));

                parent.mfn_getVariable("DEC_STATUS", null);
            }

            headers = [
				{"HEAD_TEXT": "전송"        	, "WIDTH": "80"   , "FIELD_NAME": "SEND_NM"		, "ALIGN":"left"},
				{"HEAD_TEXT": "수신"        	, "WIDTH": "80"  , "FIELD_NAME": "RECE_NM"		, "ALIGN":"left", "LINK":"fn_resList"},
                {"HEAD_TEXT": "수출신고번호"  	, "WIDTH": "150"  , "FIELD_NAME": "RPT_NO"		, "LINK":"fn_detail"},
                {"HEAD_TEXT": "주문번호"    	, "WIDTH": "150"  , "FIELD_NAME": "ORDER_ID"},
                {"HEAD_TEXT": "수출자"    	, "WIDTH": "200"  , "FIELD_NAME": "EXP_FIRM"	, "ALIGN":"left"},
                {"HEAD_TEXT": "해외구매자"  	, "WIDTH": "200"  , "FIELD_NAME": "BUY_FIRM"	, "ALIGN":"left"},
                {"HEAD_TEXT": "신고일자"     	, "WIDTH": "100"  , "FIELD_NAME": "RPT_DAY"},
                {"HEAD_TEXT": "수리일자"    	, "WIDTH": "100"  , "FIELD_NAME": "EXP_LIS_DAY"	, "LINK":"fn_resInfo"},
                {"HEAD_TEXT": "선적일자"    	, "WIDTH": "100"  , "FIELD_NAME": "SHIP_DAY"},
                {"HEAD_TEXT": "출항일자"    	, "WIDTH": "100"  , "FIELD_NAME": "LEAVE_DAY"	, "LINK":"fn_runHis"},
                {"HEAD_TEXT": "총중량(kg)"   	, "WIDTH": "80"   , "FIELD_NAME": "TOT_WT" 		, "ALIGN":"right"},
                {"HEAD_TEXT": "총포장수"    	, "WIDTH": "80"   , "FIELD_NAME": "TOT_PACK_CNT", "ALIGN":"right"},
                {"HEAD_TEXT": "통화"       	, "WIDTH": "80"   , "FIELD_NAME": "CUR"},
                {"HEAD_TEXT": "결제금액"    	, "WIDTH": "120"  , "FIELD_NAME": "AMT"			, "ALIGN":"right"},
                {"HEAD_TEXT": "총신고액(원화)"	, "WIDTH": "120"  , "FIELD_NAME": "TOT_RPT_KRW"	, "ALIGN":"right"},
                {"HEAD_TEXT": "목적국"       	, "WIDTH": "150"  , "FIELD_NAME": "TA_ST_ISO"},
                {"HEAD_TEXT": "적재항"       	, "WIDTH": "150"  , "FIELD_NAME": "FOD_CODE"},
                {"HEAD_TEXT": "결제환율"    	, "WIDTH": "120"  , "FIELD_NAME": "EXC_RATE_CUR", "ALIGN":"right"}
                
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출신고 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "dec.selectDecList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL", "qKey":"dec.selectDecList"}
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
            	var gridSelectedRows = gridWrapper.getSelectedRows();
            	var params = {};
            	var cnt = 0;
            	$.each (gridSelectedRows, function(index, data) {
            		cnt = cnt + 1;
            		params["pRPT_NO." + cnt] = data["RPT_NO"];
                   
                });
        		if(cnt > 1) {
        			fnMultiReportPrint('GOVCBR830V', params, "수출신고서 출력", cnt); 
        		} else {
          			params["pRPT_NO"] = params["pRPT_NO.1"];
        			fnReportPrint('GOVCBR830V', params, '수출신고서 출력');
        		}
            })
            
    		new FileUtil({
                "addBtnId" : "btn_upload",
                "addUrl" : "/dec/uploadResFile.do",
    			"successCallback" : function(rst) {
    				gridWrapper.requestToServer();
    			}
            });
         	
            $('#LEAVE_CHK').on("click", function (e) {
				var val = $("input:checkbox[id='LEAVE_CHK']").is(":checked") ? 'Y' : '';
				$("#LEAVE_YN").val(val);
	        });

        });

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);

            $.comm.forward("exp/dec/decDetail", data);
        }

        // 수리정보팝업
        function fn_resInfo(index){
        	var data = gridWrapper.getRowData(index);
            // 모달 호출
            $.comm.setModalArguments({"RPT_NO":data["RPT_NO"]});
            var spec = "width:800px;height:700px;scroll:auto;status:no;center:yes;resizable:yes;";
            $.comm.dialog("<c:out value='/jspView.do?jsp=exp/dec/decResInfoPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    	
                    }
                }
            );
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
        		rows[i]["REQ_KEY"] = rows[i]["RPT_NO"];
        		rows[i]["SNDR_ID"] = idendtifyId;
        		rows[i]["RECP_ID"] = "KCS4G001";
        		rows[i]["DOC_TYPE"] = "GOVCBR830";
        	}

            $.comm.send("/dec/saveExpDecSend.do", rows, fn_callback, "수출신고 전송");
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
        
     	// 이행내역팝업
        function fn_runHis(index){
        	var data = gridWrapper.getRowData(index);
            // 모달 호출
            $.comm.setModalArguments({"RPT_NO":data["RPT_NO"]});
            var spec = "width:800px;height:700px;scroll:auto;status:no;center:yes;resizable:yes;";
            $.comm.dialog("<c:out value='/jspView.do?jsp=exp/dec/decRunHisPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    	
                    }
                }
            );
        }
     	
     	// 세관통보문서 화면이동
        function fn_resList(index){
        	var data = gridWrapper.getRowData(index);
        	data["CALL_TYPE"] = "DEC";
        	$.comm.forward("exp/res/resList", data);
        }

    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
	                <input type="hidden" id="LEAVE_YN" name="LEAVE_YN">
	                <ul class="search_sectionC">
	                    <li>
	                        <label for="SEARCH_DTM" class="search_title">검색기준일자</label>
	                        <select id="SEARCH_DTM" name="SEARCH_DTM" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="A.RPT_DAY" selected>신고일자</option>
	                            <option value="A.EXP_LIS_DAY">수리일자</option>
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
	                        <label for="SEARCH_COL" class="search_title">검색조건</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/> >
	                            <option value="A.RPT_NO">수출신고번호</option>
	                            <option value="A.ORDER_ID">주문번호</option>
	                        </select>
	                        <input type="text" name="SEARCH_TXT" id="SEARCH_TXT" class="search_input inputHeight" <attr:pk/> />
	                    </li>
	                    <li style='height:30px;'>
	                        <label for="LEAVE_CHK" class="search_title">이행여부</label>
	                        <input type="checkbox" id="LEAVE_CHK" name="LEAVE_CHK" value='Y'/><label for="LEAVE_CHK"><span></span>이행</label>
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
                 <a href="#" class="btn white_147" id="btn_upload">수출신고결과업로드</a>            
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
