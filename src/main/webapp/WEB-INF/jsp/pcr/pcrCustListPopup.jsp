<%--
    Class Name : pcrCustListPopup.jsp
    Description : 거래처 목록 조회
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-16  정안균   최초 생성

    author : 정안균
    since : 2017-02-16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
				{"HEAD_TEXT": "거래처코드", "WIDTH": "90",  "FIELD_NAME": "CUST_CD"},       
                {"HEAD_TEXT": "거래처명"  , "WIDTH": "150", "FIELD_NAME": "ORG_NM"},
                {"HEAD_TEXT": "사업자번호", "WIDTH": "90", "FIELD_NAME": "ORG_ID", "LINK":"fn_return"},
                {"HEAD_TEXT": "대표자명"  , "WIDTH": "100", "FIELD_NAME": "ORG_CEO_NM"},
                {"HEAD_TEXT": "담당자명"  , "WIDTH": "120", "FIELD_NAME": "MANAGER_NM"},
                {"HEAD_TEXT": "전화번호"  , "WIDTH": "100", "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "주소"  	  , "WIDTH": "400", "FIELD_NAME": "ADDR"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "거래처 목록 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "cust.selectCustList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "firstLoad"    : false,
                "preScript"    : fn_preScript,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
            gridWrapper.requestToServer();
            
        });
        
        function fn_return(index) {
            var retVal = gridWrapper.getRowData(index);
            $.comm.setModalReturnVal(retVal);
            self.close();
        }
     	
     	function fn_preScript() {
     		var searchType = $('#SEARCH_TYPE').val();
     		if(searchType && searchType == 'GOGLOBAL') {
     			gridWrapper.setQKey("cust.selectCustList");
     			gridWrapper.setDbPoolName('default');
     		} else if(searchType && searchType == 'UTH') {
     			gridWrapper.setQKey("pcr.selectPcrUthTaxInvoiceList");
     			gridWrapper.setDbPoolName('trade');
     		}
     		return true;
     	}


    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>거래처 목록 조회</h1>
    </div><!-- layerTitle -->
    <div class="layer_content">
	    <form id="searchForm" name="searchForm">
	    	<div class="search_toggle_frame">
		        <div class="search_frame on">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="SEARCH_TYPE" class="search_title">구분</label>
		                    <select id="SEARCH_TYPE" name="SEARCH_TYPE" class="search_input_select">
		                        <option value="GOGLOBAL" selected>goGlobal 거래처</option>
		                        <option value="UTH">uTradeHub 세금계산서</option>
		                    </select>
		                </li>
		                <li>
		                    <label for="SEARCH_COL" class="search_title">조회조건</label>
		                    <label for="SEARCH_TXT" class="search_title" style="display: none">조회조건</label>
		                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
		                        <option value="ORG_NM" selected>거래처명</option>
		                        <option value="ORG_ID">사업자번호</option>
		                        <option value="ORG_CEO_NM">대표자명</option>
		                        <option value="MANAGER_NM">담당자명</option>
		                        <option value="TEL_NO">전화번호</option>
		                        <option value="ADDR">주소</option>
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
	        <div id="gridLayer" style="height: 413px">
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
