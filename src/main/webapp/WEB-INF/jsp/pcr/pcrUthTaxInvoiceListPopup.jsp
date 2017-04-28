<%--
    Class Name : pcrUthTaxInvoiceListPopup.jsp
    Description : uTradeHub 세금계산서 목록 조회
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-20 정안균   최초 생성

    author : 정안균
    since : 2017-02-20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
                {"HEAD_TEXT": "세금계산서번호" , "WIDTH": "180", "FIELD_NAME": "TAX_INVOICE_ID", "LINK":"fn_return"},        
                {"HEAD_TEXT": "작성일자"  	   , "WIDTH": "80" , "FIELD_NAME": "ISSUE_DT", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "공급자"    	   , "WIDTH": "150", "FIELD_NAME": "ORG_NM"},
                {"HEAD_TEXT": "공급자 전화번호", "WIDTH": "100", "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "공급자 주소"    , "WIDTH": "400", "FIELD_NAME": "ADDR"},
                {"HEAD_TEXT": "공급받는자"	   , "WIDTH": "150", "FIELD_NAME": "BYRORGNM"},
                {"HEAD_TEXT": "수신처"	   	   , "WIDTH": "100", "FIELD_NAME": "RCVCD"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "uTradeHub 세금계산서 목록 조회",
                "targetLayer"  : "gridLayer",
                "dbPoolName"   : "trade",
                "qKey"   	   : "pcr.selectPcrUthTaxInvoiceList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
         	// 닫기
            $("#btnClose").click(function() {
                self.close();
            });

        });
        
        // 부모창에 데이터 전달
        function fn_return(index) {
            var retVal = gridWrapper.getRowData(index);
            opener.fn_setUthTaxInfo(retVal);
            self.close();
        }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>uTradeHub 세금계산서 목록 조회</h1>
    </div><!-- layerTitle -->
    <div class="layer_content">
	    <form id="searchForm" name="searchForm">
	    	<div class="search_toggle_frame">
		        <div class="search_frame on">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="F_DTM" class="search_title">작성일</label>
		                    <label for="T_DTM" class="search_title" style="display: none">작성일</label>
		                    <div class="search_date">
	                        	<fieldset>
	                            	<input type="text" id="F_DTM" name="F_DTM" class="input" <attr:datefield to="T_DTM" value="-1m"/>/>
	                                <span>~</span>
	                                <input type="text" id="T_DTM" name="T_DTM" class="input" <attr:datefield value="0"/>/>
	                            </fieldset>
	                        </div>
		                </li>
		                <li>
		                    <label for="SEARCH_COL" class="search_title">조회조건</label>
		                    <label for="SEARCH_TXT" class="search_title" style="display: none">조회조건</label>
		                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
		                    	<option value="DOCID">문서번호</option>
	           	    			<option value="ORG_NM">공급자</option>
					    		<option value="BYRORGNM">공급받는자</option>
		                    </select>
		                    <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" class="search_input" placeholder=""/>
		                </li>
		            </ul>
		        <!-- search_sectionC -->
		        <a href="#" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
		        </div>
		        <a href="#" class="search_toggle close">검색접기</a>
	        </div><!-- search_toggle_frame -->
	    </form>
	    <div class="white_frame">
	        <div id="gridLayer" style="height: 400px">
	        </div>
	        <div class="bottom_util">
	            <div class="paging" id="gridPagingLayer">
	            </div>
	        </div>
	    </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>

</body>
</html>
