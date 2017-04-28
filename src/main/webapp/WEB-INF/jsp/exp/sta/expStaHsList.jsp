<%--
  User: jjkhj
  Date: 2017-01-19
  Form: 반품수입의뢰 목록
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var gridWrapper, headers;
    
    $(function (){
        var obj = $('#EXP_LIS_YEAR');

        $('option', obj).remove();
        var maxIndex = 10;
        var fromYear = 2016;
        var toYear = (new Date()).getFullYear();
        for(var i=toYear; i>=fromYear; i--){
            if(maxIndex == 0) break;
            maxIndex--;

            var opt = $('<option>', {
                value: i,
                text : i
            })
            obj.append(opt);
        }
        
        headers = [
			{"HEAD_TEXT": "HS부호", "WIDTH": "100", "FIELD_NAME": "HS"},
			{"HEAD_TEXT": "표준품명", "WIDTH": "200", "FIELD_NAME": "STD_GNM", "ALIGN":"left"},
			{"HEAD_TEXT": "총란수", "WIDTH": "50", "FIELD_NAME": "TOT_CNT", "ALIGN":"right"},
			{"HEAD_TEXT": "총신고금액", "WIDTH": "130", "FIELD_NAME": "TOT_KRW", "ALIGN":"right"},
			{"HEAD_TEXT": "1월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT01", "ALIGN":"right"},
			{"HEAD_TEXT": "1월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW01", "ALIGN":"right"},
			{"HEAD_TEXT": "2월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT02", "ALIGN":"right"},
			{"HEAD_TEXT": "2월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW02", "ALIGN":"right"},
			{"HEAD_TEXT": "3월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT03", "ALIGN":"right"},
			{"HEAD_TEXT": "3월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW03", "ALIGN":"right"},
			{"HEAD_TEXT": "4월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT04", "ALIGN":"right"},
			{"HEAD_TEXT": "4월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW04", "ALIGN":"right"},
			{"HEAD_TEXT": "5월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT05", "ALIGN":"right"},
			{"HEAD_TEXT": "5월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW05", "ALIGN":"right"},
			{"HEAD_TEXT": "6월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT06", "ALIGN":"right"},
			{"HEAD_TEXT": "6월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW06", "ALIGN":"right"},
			{"HEAD_TEXT": "7월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT07", "ALIGN":"right"},
			{"HEAD_TEXT": "7월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW07", "ALIGN":"right"},
			{"HEAD_TEXT": "8월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT08", "ALIGN":"right"},
			{"HEAD_TEXT": "8월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW08", "ALIGN":"right"},
			{"HEAD_TEXT": "9월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT09", "ALIGN":"right"},
			{"HEAD_TEXT": "9월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW09", "ALIGN":"right"},
			{"HEAD_TEXT": "10월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT10", "ALIGN":"right"},
			{"HEAD_TEXT": "10월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW10", "ALIGN":"right"},
			{"HEAD_TEXT": "11월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT11", "ALIGN":"right"},
			{"HEAD_TEXT": "11월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW11", "ALIGN":"right"},
			{"HEAD_TEXT": "12월란수", "WIDTH": "80", "FIELD_NAME": "TOT_CNT12", "ALIGN":"right"},
			{"HEAD_TEXT": "12월신고금액", "WIDTH": "110", "FIELD_NAME": "TOT_KRW12", "ALIGN":"right"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm" : "HS부호별수출현황 조회",
			"targetLayer" : "gridLayer",
			"qKey" : "sta.expStaHs",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"gridNaviId" : "gridPagingLayer",
			"check" : true,
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
                <form id="searchForm">            
	                <ul class="search_sectionC">
                        <li>
                            <label class="search_title" for="EXP_LIS_YEAR">검색기준년도</label>
                            <select class="search_input_select" id="EXP_LIS_YEAR" name="EXP_LIS_YEAR"></select>
                        </li>
                    </ul>
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