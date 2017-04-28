<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var gridWrapper, headers;
    
    $(function (){
		headers = [
			{"HEAD_TEXT": "수출신고번호", "WIDTH": "100", "FIELD_NAME": "RPT_NO"},
			{"HEAD_TEXT": "수출수리일자", "WIDTH": "100", "FIELD_NAME": "EXP_LIS_DAY"},
			{"HEAD_TEXT": "선(기)적일자", "WIDTH": "100", "FIELD_NAME": "SHIP_DAY"},
			{"HEAD_TEXT": "통화코드", "WIDTH": "50", "FIELD_NAME": "CUR"},
			{"HEAD_TEXT": "환율", "WIDTH": "100", "FIELD_NAME": "EXC_RATE_USD"},
			{"HEAD_TEXT": "원화신고금액", "WIDTH": "100", "FIELD_NAME": "TOT_RPT_KRW"},
			{"HEAD_TEXT": "외화신고금액", "WIDTH": "100", "FIELD_NAME": "TOT_RPT_USD"}
		];

		gridWrapper = new GridWrapper({
			"actNm" : "수출실적명세 조회",
			"targetLayer"  : "gridLayer",
			"qKey" : "sta.selectExpStaResList",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"gridNaviId" : "gridPagingLayer",
			"firstLoad" : true,
			"controllers" : [
				 {"btnName": "btnSearch", "type": "S"},
				 {"btnName": "btn_excel", "type": "EXCEL"}
			]
		});
	});
    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_frame on">
            <form id="searchForm" name="searchForm">
                <ul class="search_sectionC">
                    <li>
                        <label class="search_title">수리일자</label>
                        <div class="search_date">
	                        <fieldset>
	                            <legend class="blind">달력</legend>
   								<label for="F_EXP_LIS_DAY" style="display: none">검식기준시작일</label>
	                            <input type="text" id="F_EXP_LIS_DAY" name="F_EXP_LIS_DAY" class="input" <attr:datefield to="T_EXP_LIS_DAY" value="-1y"/> />
	                            <span>~</span>
								<label for="T_EXP_LIS_DAY" style="display: none">검식기준종료일</label>	                            
	                            <input type="text" id="T_EXP_LIS_DAY" name="T_EXP_LIS_DAY" class="input" <attr:datefield  value="0"/>/>
	                        </fieldset>
                        </div>
                    </li>
                </ul><!-- search_sectionC -->
                    <a href="#" class="btn_inquiryB" style="float:right;" id="btnSearch">조회</a>
                </form>
            </div> <%-- // search_gray --%>
            <!-- 검색 끝 -->

	        <div class="list_typeA">
	            <div class="util_frame">
                  <a href="#" class="btn white_100" id="btn_excel">엑셀다운로드</a>         
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