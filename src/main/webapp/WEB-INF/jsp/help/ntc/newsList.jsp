<%--
    Class Name : newsList.jsp
    Description : 뉴스레터
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  정안균   최초 생성
    author : 정안균
    since : 2017.01.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    	var gridWrapper, headers;
    	$(function () {
            headers = [
                {"HEAD_TEXT": "제목"    , "WIDTH": "*"  , "FIELD_NAME": "SUBJECT", "ALIGN":"left", "LINK":"fn_detail"},
                {"HEAD_TEXT": "수신일"  , "WIDTH": "120", "FIELD_NAME": "REG_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "뉴스레터 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "ntc.selectCmmNewsList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });
        });

        // 상세보기
        function fn_detail(index) {
        	var data = gridWrapper.getRowData(index)
            var args = {
                "CONTENTS": data["CONTENTS"]
            };
            $.comm.setModalArguments(args);
            $.comm.open("news_letter", "<c:out value="/jspView.do?jsp=adm/ntc/newsViewPopup" />", 700, 840);
        }

    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
    	<div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
                    <input type="hidden" id="IS_OPEN" name="IS_OPEN" value="Y">
	                <ul class="search_sectionC">
	                    <li>
	                        <label for="F_REG_DTM" class="search_title">수신일</label><label for="T_REG_DTM" style="display: none">수신일</label>
                        	<div class="search_date">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-6m"/>><span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>>
                                </fieldset>
                            </form>
                        	</div>
	                    </li>
	                    <li>
                        	<label for="P_SUBJECT" class="search_title">제목</label>
                        	<input id="P_SUBJECT" name="P_SUBJECT" type="text" class="search_input inputHeight"/>
                    	</li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_100" id="btnExcel">엑셀다운로드</a>
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