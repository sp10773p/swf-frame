<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var gridWrapper, headers;
    
    $(function (){
        headers = [
			{"HEAD_TEXT": "등록번호", "WIDTH": "150" , "FIELD_NAME": "REGNO", "LINK" : fn_detail}, 
			{"HEAD_TEXT": "주문번호", "WIDTH": "150" , "FIELD_NAME": "ORDER_ID"}, 
            {"HEAD_TEXT": "수출운송장번호", "WIDTH": "130", "FIELD_NAME": "EXP_WAYBILL_NO"},
            {"HEAD_TEXT": "반품배송 송장번호", "WIDTH": "130", "FIELD_NAME": "WAYBILL_NO"},
            {"HEAD_TEXT": "수출신고번호", "WIDTH": "120", "FIELD_NAME": "RPT_NO"},
            {"HEAD_TEXT": "반품센터", "WIDTH": "150", "FIELD_NAME": "RETERN_NM"},
            {"HEAD_TEXT": "상품명", "WIDTH": "200", "FIELD_NAME": "GOODS_NM"},
            {"HEAD_TEXT": "송하인 성명", "WIDTH": "150", "FIELD_NAME": "CONSIGNOR_NM"},
            {"HEAD_TEXT": "송하인 중문연락처", "WIDTH": "150", "FIELD_NAME": "CONSIGNOR_TELNO"},
            {"HEAD_TEXT": "담당자 (MD)", "WIDTH": "150", "FIELD_NAME": "MD_NM"},
            {"HEAD_TEXT": "반품배송 택배사", "WIDTH": "150", "FIELD_NAME": "DELIVERY_FIRM"},
            {"HEAD_TEXT": "등록일자", "WIDTH": "150", "FIELD_NAME": "REG_DTM"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm" : "KOTRA WMS 반품 조회",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectImpKotra",
			"requestUrl" : "/imp/selectImpKotraList.do",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"gridNaviId" : "gridPagingLayer",
			"check" : true,
			"firstLoad" : true,
			"controllers" : [
				 {"btnName": "btnSearch", "type": "S"},
				 {"btnName": "btn_excel", "type": "EXCEL"}, 
                 {"btnName": "btn_del" , "type": "D", "targetURI":"/imp/deleteImpKotras.do"}
			]
		});
		            
		$('#btn_new').on("click", function (e) {
			fn_detail();
		});
        
        $('#btn_down').on("click", function (e) {
        	if(gridWrapper.getSelectedRows().length == 0) {
        		alert($.comm.getMessage("W00000003"));
        		
        		return;
        	}
        	
        	var regNos = [];
        	for(var idx in gridWrapper.getSelectedRows()) {
        		regNos.push(gridWrapper.getSelectedRows()[idx]['REGNO']);
        	}
        	$.comm.fileDownload({"REG_NOS" : regNos}, "반품요청 다운로드", "/imp/downloadImpKotra.do");
        });
	});

	function fn_detail(rIdx){
		var regNo = "";
		if(arguments.length != 0) {
			regNo = gridWrapper.getData()[rIdx]['REGNO'];
		}
		$.comm.forward("exp/imp/kotraDetail", {'REGNO' : regNo ? regNo : ""});
	}
    </script>
</head>
<body>
    <div class="inner-box">
        <div class="padding_box">
            <div class="search_toggle_frame">            
	            <div class="search_frame on">
	                <form id="searchForm">            
		                <ul class="search_sectionC">
	                        <li>
	                            <label class="search_title" >등록일자</label>
								<label for="F_REG_DTM" style="display: none">검식기준시작일</label>
								<label for="T_REG_DTM" style="display: none">검식기준종료일</label>
	                            <div class="search_date">
									<fieldset>
										<legend class="blind">달력</legend>
										<input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM"  value="0"/> />
	                                    <span>~</span>
										<input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/> />
									</fieldset>
	                            </div>
	                        </li>
	                        <li>
	                            <label class="search_title" for="SEARCH_COL">검색조건</label>
	                            <select class="search_input_select" id="SEARCH_COL" name="SEARCH_COL">
		                         	<option value="ORDER_ID" selected>주문번호</option>
		                         	<option value="EXP_WAYBILL_NO">수출운송장번호</option>
		                         	<option value="WAYBILL_NO">반품배송 송장번호</option>
		                         	<option value="GOODS_NM">상품명</option>
	                            </select>
	                            <input class="search_input" type="text" id="SEARCH_TXT" name="SEARCH_TXT" >
	                        </li>                                            
	                    </ul>
	                    <a href="#" class="btn_inquiryB" style="float:right;" id="btnSearch">조회</a>
	                </form>
		        </div><!-- search_frame -->
		        <a href="#" class="search_toggle close">검색접기</a>	                        
            </div> <%-- // search_gray --%>
            <!-- 검색 끝 -->

	        <div class="list_typeA">
	            <div class="util_frame">
					<a href="#" class="btn white_100" id="btn_excel">엑셀다운로드</a>         
					<a href="#" class="btn white_147" id="btn_down">반품요청 다운로드</a>      
					<a href="#" class="btn white_84" id="btn_del">삭제</a>
					<a href="#" class="btn white_84" id="btn_new">신규</a>
	            </div><!-- //util_frame -->
	            <div id="gridLayer" style="height: 400px"></div>
	        </div>
	        <div class="bottom_util">
	            <div class="paging" id="gridPagingLayer">
	            </div>
	        </div>
	    </div>
	</div><%-- // content--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>