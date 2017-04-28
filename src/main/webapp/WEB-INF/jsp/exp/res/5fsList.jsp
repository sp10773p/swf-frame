<%--
  User: jjkhj
  Date: 2017-01-13
  Form: 수출미선적통보 목록조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function (){
            headers = [
			    
                {"HEAD_TEXT": "수출신고번호"	, "WIDTH": "150"  , "FIELD_NAME": "RPT_NO"},
                {"HEAD_TEXT": "수리일자"     	, "WIDTH": "100"  , "FIELD_NAME": "LIS_DTM"},
                {"HEAD_TEXT": "수출화주명"   	, "WIDTH": "150"  , "FIELD_NAME": "EXP_FIRM"},
                {"HEAD_TEXT": "신고인부호"   	, "WIDTH": "100"  , "FIELD_NAME": "RPT_MARK"},
                {"HEAD_TEXT": "제조자통관부호"	, "WIDTH": "150"  , "FIELD_NAME": "MAK_TGNO"},
                {"HEAD_TEXT": "품명"        	, "WIDTH": "200"  , "FIELD_NAME": "STD_GNM" 		, "ALIGN":"left" },
                {"HEAD_TEXT": "총포장수"    	, "WIDTH": "80"   , "FIELD_NAME": "TOT_PACK_CNT" 	, "ALIGN":"right" },
                {"HEAD_TEXT": "포장단위"     	, "WIDTH": "80"   , "FIELD_NAME": "TOT_PACK_UT" },
                {"HEAD_TEXT": "총중량"      	, "WIDTH": "80"   , "FIELD_NAME": "TOT_WT" },
                {"HEAD_TEXT": "중량단위"    	, "WIDTH": "80"   , "FIELD_NAME": "TOT_UT" }
                
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출미선적통보 목록조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "res.select5fsList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch" , "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL", "qKey":"res.select5fsList"}
                ]
            });
        });
        

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
	                        <label class="search_title">수리일자</label>
	                        <div class="search_date">
	                            <fieldset>
	                                <legend class="blind">달력</legend>
	                                <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/> />
	                                <span>~</span>
	                                <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                            </fieldset>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="SEARCH_COL" class="search_title">검색조건</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/> >
	                            <option value="RPT_NO">수출신고번호</option>
	                            <option value="EXP_FIRM">수출화주명</option>
	                            <option value="RPT_MARK">신고인부호</option>
	                            <option value="MAK_TGNO">제조자통관부호</option>
	                        </select>
	                        <input type="text" name="SEARCH_TXT" class="search_input" <attr:pk/>/>
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
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
