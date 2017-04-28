<%--
    Class Name : pcrIssueListPopup.jsp
    Description : 구매확인서 발급 목록
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-17  정안균   최초 생성

    author : 정안균
    since : 2017-02-17
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var grid, headers;
        $(function (){
            headers = [
                {"HEAD_TEXT": "구매확인서번호", "WIDTH": "100", "FIELD_NAME": "PCR_LIC_ID", "LINK":"fn_return"},        
                {"HEAD_TEXT": "상태"		  , "WIDTH": "80" , "FIELD_NAME": "DOC_STAT_NM"},
                {"HEAD_TEXT": "확인기관"      , "WIDTH": "120", "FIELD_NAME": "CONF_ORG_NM"},
                {"HEAD_TEXT": "확인일자"      , "WIDTH": "120", "FIELD_NAME": "CONF_DT", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "공급자"        , "WIDTH": "150", "FIELD_NAME": "SUP_ORG_NM"},
                {"HEAD_TEXT": "금액"          , "WIDTH": "100", "FIELD_NAME": "TOT_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "통화단위"      , "WIDTH": "70" , "FIELD_NAME": "CURRENCY"}
            ];

            grid = new GridWrapper({
                "actNm"        : "구매확인서 발급 목록 조회",
                "targetLayer"  : "gridLayer",
                "paramsGetter" : {"ISSUE_YN" : "Y"},  
                "paramsFormId" : "searchForm",
                "qKey"         : "pcr.selectPcrLicList",
                "headers"      : headers,
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : true,
                "defaultSort"  : "DOC_ID DESC",
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
         	// 닫기
            $("#btnClose").click(function() {
                self.close();
            });

        });
        
        // 상위메뉴 선택
        function fn_return(index) {
            var retVal = grid.getRowData(index);
            $.comm.setModalReturnVal(retVal);
            self.close();
        }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>구매확인서 발급 목록</h1>
    </div><!-- layerTitle -->
    <div class="layer_content">
	    <form id="searchForm" name="searchForm">
	    	<div class="search_toggle_frame">
		        <div class="search_frame on">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="F_CONF_DT" class="search_title">확인일자</label>
		                    <label for="T_CONF_DT" class="search_title" style="display: none">확인일자</label>
		                    <div class="search_date">
	                        	<fieldset>
	                            	<input type="text" id="F_CONF_DT" name="F_CONF_DT" class="input" <attr:datefield to="T_CONF_DT" value="-1m"/>/>
	                                <span>~</span>
	                                <input type="text" id="T_CONF_DT" name="T_CONF_DT" class="input" <attr:datefield value="0"/>/>
	                            </fieldset>
	                        </div>
		                </li>
		                <li>
		                    <label for="SEARCH_COL" class="search_title">조회조건</label>
		                    <label for="SEARCH_TXT" class="search_title" style="display: none">조회조건</label>
		                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
		                        <option value="A.PCR_LIC_ID">구매확인서 번호</option>
	          		    		<option value="A.SUP_ORG_NM">공급자 상호</option>
		                    </select>
		                    <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" class="search_input" placeholder=""/>
		                </li>
		            </ul>
		        <!-- search_sectionC -->
		        <a href="#" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
		        </div>
	        	<a href="#" class="search_toggle close">검색접기</a><!-- search_toggle_frame -->
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
