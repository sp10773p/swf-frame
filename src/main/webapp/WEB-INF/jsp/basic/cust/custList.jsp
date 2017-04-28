<%--
    Class Name : custList.jsp
    Description : 거래처 관리
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.06  정안균   최초 생성

    author : 정안균
    since : 2017.03.06
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
				{"HEAD_TEXT": "거래처코드", "WIDTH": "70",  "FIELD_NAME": "CUST_CD", "LINK":"fn_detail"},
                {"HEAD_TEXT": "거래처명"  , "WIDTH": "150", "FIELD_NAME": "ORG_NM"},
                {"HEAD_TEXT": "사업자번호", "WIDTH": "80", "FIELD_NAME": "ORG_ID"},
                {"HEAD_TEXT": "대표자명"  , "WIDTH": "80", "FIELD_NAME": "ORG_CEO_NM"},
                {"HEAD_TEXT": "담당자명"  , "WIDTH": "80", "FIELD_NAME": "MANAGER_NM"},
                {"HEAD_TEXT": "전화번호"  , "WIDTH": "90", "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "주소"  	  , "WIDTH": "300", "FIELD_NAME": "ADDR"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "거래처 목록 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "cust.selectCustList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel", "type": "D", "targetURI":"/cust/deleteCustList.do", "preScript": fn_deleteValid},
                ]
            });
  

            // 거래처 정보 신규
            $('#btnNew').on("click", function (e) {
                $.comm.forward("basic/cust/custDetail", {});
            })
 
        });
        
        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            $.comm.forward("basic/cust/custDetail", data);
        }
        
        function fn_deleteValid(e) {
        	var size = gridWrapper.getSelectedSize();
        	if(size < 1) {
        		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
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
	                        <label for="SEARCH_DTM" class="search_title">조회기간</label>
	                        <select id="SEARCH_DTM" name="SEARCH_DTM" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="REG_DTM" selected>등록일자</option>
	                            <option value="MOD_DTM">수정일자</option>
	                        </select>
	                        <div class="search_date">
	                            <form action="#">
	                                <fieldset>
	                                    <legend class="blind">달력</legend>
	                                    <input type="text" id="F_DTM" name="F_DTM" class="input" <attr:datefield to="T_DTM" value="-1m"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_DTM" name="T_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                            </form>
	                        </div>
	                    </li>
	                    <li>
		                    <label for="SEARCH_COL" class="search_title">조회조건</label>
		                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select inputHeight" <attr:changeNoSearch/>>
		                        <option value="ORG_NM" selected>거래처명</option>
		                        <option value="ORG_ID">사업자번호</option>
		                        <option value="ORG_CEO_NM">대표자명</option>
		                        <option value="MANAGER_NM">담당자명</option>
		                        <option value="TEL_NO">전화번호</option>
		                        <option value="ADDR">주소</option>
		                    </select>
		                    <input id="SEARCH_TXT" name="SEARCH_TXT" type="text" class="search_input inputHeight" placeholder=""/>
		                </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_84" id="btnDel">삭제</a>
                <a href="#" class="btn white_84" id="btnNew">신규</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 400px">
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