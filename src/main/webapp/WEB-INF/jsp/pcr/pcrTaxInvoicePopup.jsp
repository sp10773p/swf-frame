<%--
    Class Name : pcrTaxInvoicePopup.jsp
    Description : 세금계산서 등록
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-15  정안균   최초 생성

    author : 정안균
    since : 2017-02-15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var docId = arguments.DOC_ID;
        $(function (){
        	$("#DOC_ID").val(docId);
        	headers = [
                {"HEAD_TEXT": "세금계산서 번호", "WIDTH": "180", "FIELD_NAME": "TAX_INVOICE_ID", "LINK":"fn_detail"},
                {"HEAD_TEXT": "품명"    	   , "WIDTH": "130", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"    	   , "WIDTH": "130", "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "공급가액(KRW)"  , "WIDTH": "120" , "FIELD_NAME": "CHARGE_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "세액(KRW)"      , "WIDTH": "120" , "FIELD_NAME": "TAX_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "수량"		   , "WIDTH": "80" , "FIELD_NAME": "ITEM_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "작성일자"	   , "WIDTH": "80" , "FIELD_NAME": "ISSUE_DT", "DATA_TYPE":"DAT"}
            ];

        	gridWrapper = new GridWrapper({
        		"actNm"        : "세금계산서 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "pcr.selectPcrTaxInvoiceList",
                "paramsGetter" : {"DOC_ID":docId},
                "headers"      : headers,
                "check"        : true,
                "scrollPaging" : true,
                "firstLoad"    : true,
                "defaultSort"  : "TAX_INVOICE_ID, SN",
                "controllers"  : [
                    {"btnName": "btnDel", "type": "D", "qKey":"pcr.deleteTaxInvoice", "postScript":fn_searchOpenerFunc}
                ]
            });

            $('#btnUthTaxInvoiceSearch').on("click", function (e) {
            	 var spec = "windowname:pcrUthTaxInvoiceListPopup;width:800px;height:800px;scroll:auto;status:no;resizable:yes;";
                 $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrUthTaxInvoiceListPopup' />", spec,
                     function () { // 리턴받을 callback 함수
                         var ret = $.comm.getModalReturnVal();
                         if (ret) {
                         }
                     }
                 );
            })

            $('#btnSave').on("click", function (e) {
            	if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                	return;
                }	
					
            	$.comm.sendForm("/pcr/savePcrTaxInvoice.do", "frm", fn_callback, "세금계산서 저장", null, false, {"ISSUE_DT": $('#ISSUE_DT').val().trim().replace(/\/|-/g, '')});
            })
           
           $("#ITEM_QTY_UNIT_SELECT").change(function(){
    			$("#ITEM_QTY_UNIT").val($(this).val());
    	   });
            
           $('#ITEM_NM').on("blur", function (e) {
           		fn_delTextBlank($('#ITEM_NM').get(0));
           })

           $.comm.disabled("ISSUE_DT", true);
           gfn_closeDimLoading();

        });
        
     	// 상세정보 
        function fn_detail(index){
        	$('#frm')[0].reset();
        	var param = gridWrapper.getRowData(index);
        	fn_select(param, false);
        }
     	
        var fn_callback = function (data) {
        	var result = data.data;
        	var param = {};
        	param["DOC_ID"] = result["DOC_ID"];
        	param["TAX_INVOICE_ID"] = result["TAX_INVOICE_ID"];
        	param["SN"] = result["SN"];
        	fn_select(param, true);
        }
        
        function fn_select(data, isSave) {
        	data["qKey"] = "pcr.selectPcrTaxInvoice";
        	$.comm.send("/common/select.do", data,
                     function(data, status){
                 		var resultData = data.data;
                 		$.comm.bindData(resultData);
                 		gridWrapper.requestToServer();
                 		$("#ITEM_QTY_UNIT_SELECT").val(resultData["ITEM_QTY_UNIT"]);
                 		$("#CHARGE_AMT").val(resultData["CHARGE_AMT"] ? $.comm.numberWithCommas(resultData["CHARGE_AMT"]) : '0');
                 		$("#TAX_AMT").val(resultData["TAX_AMT"] ? $.comm.numberWithCommas(resultData["TAX_AMT"]) : '0');
                 		$("#ITEM_QTY").val(resultData["ITEM_QTY"] ? $.comm.numberWithCommas(resultData["ITEM_QTY"]) : '');
                     },
                     "세금계산서 상세 조회"
            );
        	if(isSave) {
        		fn_searchOpenerFunc();
        	}
        }
        
        function fn_searchOpenerFunc() {
        	window.opener.searchTaxInvoice();
        }
        
     	// uTradeHub 세금계산서 정보 
        function fn_setUthTaxInfo(data){
        	$('#frm')[0].reset();
        	$.comm.bindData(data);
        	$("#DOC_ID").val(docId);
        }
     	
     	// 텍스트 공백제거 
        function fn_delTextBlank(obj){
     		var val = $(obj).val();
        	if (val == "" ) return;
        	var val = val.replace(/(\r\n|\n|\n\n)/gi,'[split]');
        	var txtAry = val.split("[split]");
        	var result = "";
        	var isBlank = false;
        	var newLine = "";
        	for( var ii=0;ii<txtAry.length;ii++){ 
        		var tmp = $.trim(txtAry[ii]);
        		if (tmp != "" ) {
        			result += newLine + tmp;
        			newLine = "\n"; 
        		}else{
        			isBlank = true;
        		}		
        	}	
        	if (isBlank) {
        		alert("품명 및 비고 항목에는 공백라인이 들어갈 수 없습니다.\n공백라인을 삭제하겠습니다.");
        	}
        	$(obj).val(result);
        }
    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>세금계산서</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
		<a href="#" class="title_frame_btn" id="btnSave">저장</a>
	</div>
    <div class="layer_content">
        <form id="frm" name="frm" method="post"> 
        <input type="hidden" name="DOC_ID" id="DOC_ID" value="">
        <input type="hidden" name="SN" id="SN" value=""> 
		    <div class="title_frame">	
		    	<div class="table_typeA gray table_toggle">
		    		<table style="table-layout:fixed;" >
		    			<caption class="blind">세금계산서 등록</caption>
		    			<colgroup>
                        	<col width="19%" />
                        	<col width="35%" />
                        	<col width="15%" />
                        	<col width="31%" />
                    	</colgroup>
                    	<tr>
                            <td><label for="TAX_INVOICE_ID">세금계산서 번호</label></td>
                            <td colspan="3"><input type="text" name="TAX_INVOICE_ID" id="TAX_INVOICE_ID" <attr:mandantory/> class="td_input readonly" readonly></td>
                        </tr>
                        <tr>
                            <td><label for="btnUthTaxInvoiceSearch">uTradeHub 세금계산서</label></td>
                            <td colspan="3"><a href="#" id="btnUthTaxInvoiceSearch" class="btn_inquiryC">선택</a></td>
                        </tr>
                        <tr>
                            <td><label for="ITEM_NM">품명</label></td>
                            <td colspan="3"><textarea name="ITEM_NM" id="ITEM_NM" rows="5" <attr:length value='175'/>></textarea></td>
                        </tr>
                        <tr>
                            <td><label for="ITEM_DEF">규격</label></td>
                            <td colspan="3"><textarea name="ITEM_DEF" id="ITEM_DEF" rows="5" <attr:length value='1750'/>></textarea></td>
                        </tr>
                        <tr>
                            <td><label for="ITEM_QTY">수량</label><label for="ITEM_QTY_UNIT" style="display: none;">수량</label></td>
                            <td colspan="3">
                            	<input type="text" name="ITEM_QTY" id="ITEM_QTY" <attr:numberOnly/> <attr:length value='15'/> style="width: 40% !important" class="td_input">&nbsp;
                            	<input type="text" name="ITEM_QTY_UNIT" id="ITEM_QTY_UNIT" <attr:length value='3'/> <attr:alphaOnly/> style="width: 20% !important" class="td_input">
                            	<select name="ITEM_QTY_UNIT_SELECT" id="ITEM_QTY_UNIT_SELECT" class="td_input" style="width: 15% !important">
				                    <option value="">수량코드</option>
				                    <option value="EA">EA</option>
									<option value="PC">PC</option>
									<option value="KG">KG</option>
									<option value="CT">CT</option>
									<option value="YD">YD</option>
									<option value="M">M</option>
									<option value="SET">SET</option>
									<option value="MT">MT</option>
									<option value="BOX">BOX</option>
									<option value="RO">RO</option>
									<option value="UN">UN</option>
									<option value="PR">PR</option>
									<option value="SF">SF</option>
									<option value="M2">M2</option>
									<option value="LO">LO</option>
				                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="CHARGE_AMT">공급가액</label></td>
                            <td><input type="text" name="CHARGE_AMT" id="CHARGE_AMT" class="td_input readonly" style="width: 80% !important" readonly <attr:mandantory/> <attr:numberOnly/>>KRW</td>
                            <td><label for="TAX_AMT">세액</label></td>
                            <td><input type="text" name="TAX_AMT" id="TAX_AMT" class="td_input readonly" style="width: 80% !important" readonly <attr:mandantory/> <attr:numberOnly/>>KRW</td>
                        </tr>
                        <tr>
                            <td><label for="CHARGE_DT">공급일자</label></td>
                            <td><input type="text" name="CHARGE_DT" id="CHARGE_DT" class="td_input" <attr:datefield/>></td>
                            <td><label for="ISSUE_DT">작성일자</label></td>
                            <td><input type="text" name="ISSUE_DT" id="ISSUE_DT" <attr:mandantory/> style="width: 40% !important" class="td_input readonly"></td>
                        </tr>
		    		</table>
		    	</div>
		    	<div style="padding:16px 20px;margin:15px 0 15px 0;border:1px solid #e1e2e6;background-color:#f3f4f7;">
					<p>
						* 구매물품 목록(구매원료.기재의 내용) 의 총금액과 공급가액의 총합이 다른 경우 
						품명, 규격, 수량 항목을 반드시 기재하여야 합니다.<br>
					</p>
				</div>
		    </div>
	    <div class="white_frame">
	        <div class="util_frame">
	            <a href="#" class="btn white_84" style="width:64px;" id="btnDel">삭제</a>
            </div>
	        <div id="gridLayer" style="height: 150px">
	        </div>
	    </div>
	    </form>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>

</body>
</html>
