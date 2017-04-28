<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
    var commCodeMap = {
    		'SND_RCV_DIV' : {'S':'송신', 'R':'수신'}, 
    		'DOC_TYPE' : (function() {
                var rtn = {};
                $.each($.comm.getCommCode("DOC_TYPE"), function(){
                    var code  = this.CODE;
                    var value = this.CODE_NM;
                    rtn[this.CODE] = value;
                })
                
                return rtn;
    		})(), 
    		'DOC_STATUS' : (function() {
                var rtn = {};
                $.each($.comm.getCommCode("DOC_STATUS"), function(){
                    var code  = this.CODE;
                    var value = this.CODE_NM;
                    rtn[this.CODE] = value;
                })
                
                return rtn;
            })()
     };
    
    var gridWrapper, headers;
    $(function () {
    	$.comm.bindCombo("DOC_TYPE", "DOC_TYPE", true);
    	$.comm.bindCombo("DOC_STATUS", "DOC_STATUS", true);
    	$('#F_SND_RCV_DTM_HHMM').val('0000');
    	$('#T_SND_RCV_DTM_HHMM').val('2359');
    	
    	headers = [
           {"HEAD_TEXT" : "Type", "WIDTH" : "80", "FIELD_NAME" : "SND_RCV_DIV", "HTML_FNC" : function(rIdx, val){return commCodeMap['SND_RCV_DIV'][val]}},
           {"HEAD_TEXT" : "송/수신일시", "WIDTH" : "120" , "FIELD_NAME" : "SND_RCV_DTM"},
           {"HEAD_TEXT" : "메시지 ID", "WIDTH" : "210", "FIELD_NAME" : "DOC_ID", 
        	   "LINK" : function(rIdx){
                   $.comm.setModalArguments({"qKey" : "edi.selectSendRecv", 'SND_RCV_DIV' : [gridWrapper.getData()[rIdx]['SND_RCV_DIV']], "DOC_ID":gridWrapper.getData()[rIdx]['DOC_ID']});
                   var spec = "width:1500px;height:900px;scroll:auto;status:no;center:yes;resizable:yes;";
                   $.comm.dialog("<c:out value='/jspView.do?jsp=adm/edi/hisDtlPopup' />", spec);
        	    }},
           {"HEAD_TEXT" : "문서관리번호", "WIDTH" : "150", "FIELD_NAME" : "REQ_KEY"},           
           {"HEAD_TEXT" : "문서명", "WIDTH" : "150", "FIELD_NAME" : "DOC_TYPE", "HTML_FNC" : function(rIdx, val){return commCodeMap['DOC_TYPE'][val]}},
           {"HEAD_TEXT" : "문서상태", "WIDTH" : "80", "FIELD_NAME" : "DOC_STATUS", "HTML_FNC" : function(rIdx, val){return commCodeMap['DOC_STATUS'][val]}},
           {"HEAD_TEXT" : "등록구분", "WIDTH" : "80", "FIELD_NAME" : "REG_TYPE"},
           {"HEAD_TEXT" : "송신식별자", "WIDTH" : "100", "FIELD_NAME" : "SNDR_ID"},
           {"HEAD_TEXT" : "수신식별자", "WIDTH" : "100", "FIELD_NAME" : "RECP_ID"},
           {"HEAD_TEXT" : "상호명", "WIDTH" : "180", "FIELD_NAME" : "ORG_NM"}         
       ];

    	gridWrapper = new GridWrapper({
    	    "actNm"  : "사용자 조회",
    	    "targetLayer" : "gridLayer",
    	    "qKey"  : "edi.selectSendRecv",
    	    "requestUrl"  : "/edi/selectSendRecvList.do",
    	    "headers"  : headers,
    	    "paramsFormId"  : "searchForm",
    	    "gridNaviId"  : "gridPagingLayer",
    	    "check" : true,
    	    "controllers": [
    	        {"btnName": "btnSearch", "type": "S"},
    	        {"btnName": "btnExcel", "type": "EXCEL"}
    	    ], 
			"postScript" : function(grid) {
				var data = grid.getData();
				for(var i in data) {
					if(data[i]['SND_RCV_DIV'] == 'S' || data[i]['DOC_STATUS'] == 'RI' || data[i]['DOC_STATUS'] == 'RS' || !data[i]['FILE_NM']) {
						grid.setCheckDisabled(data[i]['RIDX'], true);    
					}
				}
			}
    	});
    	
    	
		$('#btnRetry').on('click', function (e) {
            if(gridWrapper.getSelectedSize() == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없스니다.
                return;
            }
            
            if (!confirm($.comm.getMessage("C00000035"))) { // 재처리 하시겠습니까?
                return;
            }

            var rows = gridWrapper.getSelectedRows();
		    var rtn = $.comm.sendSync("/edi/docReRecv.do", rows, "어드민 재처리");
		    
		    if(rtn.code == 'I00000018') {
		    	  gridWrapper.requestToServer();
		    }
		});
	    
        $('#oneWeek').on("click", function (e) {
        	var toDay = new Date();
        	$('#F_SND_RCV_DTM').val(toDay.format('YYYY-MM-DD'));
        	$('#F_SND_RCV_DTM_HHMM').val('0000');
        	$('#T_SND_RCV_DTM').val(toDay.dateAdd(0, 0, 7).format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('2359');
        });
        
        $('#oneMonth').on("click", function (e) {
            var toDay = new Date();
            $('#F_SND_RCV_DTM').val(toDay.format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('0000');
            $('#T_SND_RCV_DTM').val(toDay.dateAdd(0, 1, 0).format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('2359');
        });   
        
        $('#threeMonths').on("click", function (e) {
            var toDay = new Date();
            $('#F_SND_RCV_DTM').val(toDay.format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('0000');
            $('#T_SND_RCV_DTM').val(toDay.dateAdd(0, 3, 0).format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('2359');
        });         
        
        $('#sixMonths').on("click", function (e) {
            var toDay = new Date();
            $('#F_SND_RCV_DTM').val(toDay.format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('0000');
            $('#T_SND_RCV_DTM').val(toDay.dateAdd(0, 6, 0).format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('2359');
        });     
        
        $('#oneYear').on("click", function (e) {
            var toDay = new Date();
            $('#F_SND_RCV_DTM').val(toDay.format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('0000');
            $('#T_SND_RCV_DTM').val(toDay.dateAdd(1, 0, 0).format('YYYY-MM-DD'));
            $('#F_SND_RCV_DTM_HHMM').val('2359');
        });        
        
        new FileUtil({
            "id" : "file",
            "addBtnId" : "btnUpload",
            "successCallback" : function (data) {
            }, 
            "fileUploadScreenDiv" : "EDI_RECV_TEST"
        });
     });
    </script>
</head>
<body>
<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <div class="search_frame">
                <ul class="search_sectionA">
                    <li>
                        <label class="search_title" for="F_SND_RCV_DTM">송/수신일자</label><label for="T_SND_RCV_DTM" style="display: none">등록일자</label>
                        <div class="dateSearch" style="width:400px;">
	                        <fieldset>
	                            <legend class="blind">달력</legend>
	                            <input type="text" id="F_SND_RCV_DTM" name="F_SND_RCV_DTM" <attr:datefield to="T_SND_RCV_DTM"  value="-7d"/>>
	                            <input name="F_SND_RCV_DTM_HHMM" id="F_SND_RCV_DTM_HHMM" style="width: 45px;" type="text">
	                            <span>~</span>
	                            <input type="text" id="T_SND_RCV_DTM" name="T_SND_RCV_DTM" <attr:datefield  value="0"/>>
	                            <input name="T_SND_RCV_DTM_HHMM" id="T_SND_RCV_DTM_HHMM" style="width: 45px;" type="text">
	                        </fieldset>
                        </div>
                        <span class="btn_day">
                            <a href="#" id="oneWeek">1주일</a>
                            <a href="#" id="oneMonth">1개월</a>
                            <a href="#" id="threeMonths">3개월</a>
                            <a href="#" id="sixMonths">6개월</a>
                            <a href="#" id="oneYear">1년</a>
                        </span>
                    </li>
                    <li style='height:30px;'>
                        <label class="search_title" for="SND_RCV_DIV">송/수신구분</label>
                        <input type="checkbox" name="SND_RCV_DIV" value='S' checked="checked" id="a1" /><label for="a1"><span></span>송신</label>
                        <input type="checkbox" name="SND_RCV_DIV" value='R' checked="checked" id="a2" /><label for="a2"><span></span>수신</label>
                    </li>
                    <li>
                        <label for="" class="search_title">상호</label>
                        <input name="ORG_NM" id="ORG_NM" type="text" class="search_fixed inputHeight"/>
                    </li>
                    <li>
                        <label for="" class="search_title">사용자ID</label>
                        <input name="REG_ID" id="REG_ID" type="text" class="search_fixed inputHeight"/>
                    </li>      
                    <li>
                        <label for="" class="search_title">식별자</label>
                        <input name="SNDR_RECP_ID" id="SNDR_RECP_ID" type="text" class="search_fixed inputHeight"/>
                    </li> 
                    <li>
                        <label for="" class="search_title">문서명</label>
                        <select name="DOC_TYPE" id="DOC_TYPE" class="input_searchSelect inputHeight"></select>
                    </li>      
                    <li>
                        <label for="" class="search_title">문서상태</label>
                        <select name="DOC_STATUS" id="DOC_STATUS" class="input_searchSelect inputHeight"></select>
                    </li>    
                    <li>
                        <label for="" class="search_title">메시지 ID</label>
                        <input id="DOC_ID" name="DOC_ID" type="text" class="input_text inputHeight" />
                    </li>
                    <li>
                        <label for="" class="search_title">문서관리번호</label>
                        <input id="REQ_KEY" name="REQ_KEY" type="text" class="input_text inputHeight" />
                    </li>                    
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="white_frame">
        <div class="util_frame">
            <div class="util_left64">
                <p class="total">Total <span id="totCnt"></span></p>
            </div>
            <div class="util_right64">
                <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                <a href="#재처리" class="btn white_100" id="btnRetry">재처리</a>
                <a href="#수신테스트" class="btn white_100" id="btnUpload">수신테스트</a>
            </div>
        </div>
        <div id="gridLayer" style="height: 430px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
    <%-- white_frame --%>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
