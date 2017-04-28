<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출정정요청조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
	<s:eval expression="@config.getProperty('summary.from.date.period')" var="datePeriod"/>
    <script>
        var gridWrapper, headers;
        $(function (){

            // 로그인 화면의 수출신고건수에서 링크
            if(!$.comm.isNull(parent.mfn_getVariable("DEC_STATUS"))){
                $('#SEARCH_DTM').val("A.REG_DTM");
                $('#F_REG_DTM').val(new Date().dateAdd2("d", parseInt("${datePeriod}")*-1).format('YYYY-MM-DD'));
                $('#T_REG_DTM').val(new Date().format('YYYY-MM-DD'));

                parent.mfn_getVariable("DEC_STATUS", null);
            }

            headers = [
				{"HEAD_TEXT": "요청관리번호"      		, "WIDTH": "250"  , "FIELD_NAME": "REQ_NO", "LINK":"fn_detail"},
				{"HEAD_TEXT": "상태"        			, "WIDTH": "120"   , "FIELD_NAME": "STATUS_NM"},
				{"HEAD_TEXT": "관세사"        		, "WIDTH": "120"   , "FIELD_NAME": "CUS_USER_ID"},
                {"HEAD_TEXT": "수출신고번호"    		, "WIDTH": "150"  , "FIELD_NAME": "REFERENCEID"},
                {"HEAD_TEXT": "판매자ID"      		, "WIDTH": "120"  , "FIELD_NAME": "SELLER_ID"},
                {"HEAD_TEXT": "주문번호"       		, "WIDTH": "150"  , "FIELD_NAME": "ORDER_ID"},
                {"HEAD_TEXT": "정정구분"            	, "WIDTH": "120"  , "FIELD_NAME": "TYPECODE_NM"},
                {"HEAD_TEXT": "세관"       			, "WIDTH": "120"  , "FIELD_NAME": "OFFICECODE_NM"},
                {"HEAD_TEXT": "과"       			, "WIDTH": "150"  , "FIELD_NAME": "DEPARTMENTCODE_NM"},
                {"HEAD_TEXT": "정정요청내역"    		, "WIDTH": "250"  , "FIELD_NAME": "AMENDREASON", "ALIGN":"left"},
                {"HEAD_TEXT": "수출신고일자"    		, "WIDTH": "150"   , "FIELD_NAME": "ISSUEDATETIME"},
                {"HEAD_TEXT": "신고자대표자명"    		, "WIDTH": "120"   , "FIELD_NAME": "AGENTREPNAME"},
                {"HEAD_TEXT": "신고자상호"    		, "WIDTH": "250"   , "FIELD_NAME": "AGENTNAME", "ALIGN":"left"},
                {"HEAD_TEXT": "수출자성명"    		, "WIDTH": "250"   , "FIELD_NAME": "EXPORTERNAME", "ALIGN":"left"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출정정요청 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "req.selectModReqList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL", "qKey":"req.selectModReqList"}
                ]
            });
            
          	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
            $.comm.bindCombo("REQ_STATUS"   , "AAA1003",  true, null, null, null, 1);	//상태
            
        });

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            data["SAVE_MODE"] = "";

            $.comm.forward("exp/req/modReqDetail", data);
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
	                        <label for="SEARCH_DTM" class="search_title">검색기준일자</label>
	                        <select id="SEARCH_DTM" name="SEARCH_DTM" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="A.REG_DTM" selected>등록일자</option>
	                            <option value="A.MOD_DTM">수정일자</option>
	                        </select>
	                        <div class="search_date">
	                            <form action="#">
	                                <fieldset>
	                                    <legend class="blind">달력</legend>
	                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1y"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                            </form>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="REQ_STATUS" class="search_title">상태</label>
	                        <select id="REQ_STATUS" name="REQ_STATUS" class="search_input_select inputHeight"></select>
	                    </li>
	                    <li>
	                        <label for="SEARCH_COL" class="search_title">검색조건</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/> >
	                            <option value="REQ_NO" selected>요청관리번호</option>
	                            <option value="ORDER_ID">주문번호</option>
	                            <option value="REFERENCEID">수출신고번호</option>
	                        </select>
	                        <input type="text" id="SEARCH_TXT" name="SEARCH_TXT" class="search_input" <attr:pk/> />
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
		</div>
		
        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_100" id="btnExcel">엑셀다운로드</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 413px">
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
