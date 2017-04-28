<%--
    Class Name : deftUsrListPopup.jsp
    Description : 사용자 조회 
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.15  정안균   최초 생성

    author : 정안균
    since : 2017.03.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        $(function () {
        	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
            var userDiv = arguments.USER_DIV;
        	
            headers = [
                {"HEAD_TEXT": "사용자명"       , "WIDTH": "250", "FIELD_NAME": "USER_NM", "ALIGN":"left", "LINK":"fn_return"},
                {"HEAD_TEXT": "사용자구분"     , "WIDTH": "70" , "FIELD_NAME": "USER_DIV_NM"},
                {"HEAD_TEXT": "사업자등록번호" , "WIDTH": "90", "FIELD_NAME": "BIZ_NO"},
                {"HEAD_TEXT": "주소"       	   , "WIDTH": "150" , "FIELD_NAME": "ADDR"},
                {"HEAD_TEXT": "업태"           , "WIDTH": "100" , "FIELD_NAME": "BIZ_CONDITION"},
                {"HEAD_TEXT": "종목"           , "WIDTH": "100" , "FIELD_NAME": "BIZ_LINE"}
            ];

  
            gridWrapper = new GridWrapper({
                "actNm"        : "사용자 목록 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "deft.selectUsrList",
                "paramsGetter" : {"USER_DIV": userDiv},
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
        });
        
        function fn_return(index) {
            var retVal = gridWrapper.getRowData(index);
            $.comm.setModalReturnVal(retVal);
            self.close();
        }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>사용자 목록 조회</h1>
    </div><!-- layerTitle -->
    <div class="layer_content">
	    <form id="searchForm" name="searchForm">
	    	<div class="search_toggle_frame">
		        <div class="search_frame on">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="F_REG_DTM" class="search_title">등록일</label>
		                    <div class="search_date">
	                        	<fieldset>
	                            	<input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/>/>
	                                <span>~</span>
	                                <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield value="0"/>/>
	                            </fieldset>
	                        </div>
		                </li>
		                <li>
		                    <label for="SEARCH_COL" class="search_title">조회조건</label>
		                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
		                        <option value="USER_NM" selected>사용자명</option>
		                        <option value="BIZ_NO">사업자등록번호</option>
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
