<%--
  User: jjkhj
  Date: 2017-01-12
  Form: 오류통보 목록조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <c:set var="applicantId" value="${session.getApplicantId()}" />
    <script>
        var gridMaster, gridDetail, headers, headersDetail;
        var globalVar = {
            "KEY_NO"  : "",
            "refColName": ""
        }
        $(function (){
            globalVar.refColName = ""; // detail 참조 컬럼

            headers = [
                {"HEAD_TEXT": "수출신고번호"  , "WIDTH": "180"  , "FIELD_NAME": "RPT_NO", "LINK":"fn_detail"},
                {"HEAD_TEXT": "정정차수"     , "WIDTH": "60" 	  , "FIELD_NAME": "RPT_SEQ"},
                {"HEAD_TEXT": "문서구분"     , "WIDTH": "120"  , "FIELD_NAME": "DOC_CD"},
                {"HEAD_TEXT": "세관"        , "WIDTH": "150"  , "FIELD_NAME": "CUS_NM", "ALIGN":"left"},
                {"HEAD_TEXT": "과"          , "WIDTH": "150"  , "FIELD_NAME": "SEC_NM", "ALIGN":"left"},
                {"HEAD_TEXT": "수신일시"     , "WIDTH": "120"  , "FIELD_NAME": "RCV_DTM"},
                {"HEAD_TEXT": "통보일시"     , "WIDTH": "120"  , "FIELD_NAME": "DPT_DTM"}
            ];

            headersDetail = [
                {"HEAD_TEXT": "란번호"  		, "WIDTH": "100" , "FIELD_NAME": "ERR_RAN_NO"},
                {"HEAD_TEXT": "오류위치"    	, "WIDTH": "100" , "FIELD_NAME": "ERR_POS"},
                {"HEAD_TEXT": "오류문서 KEY"  , "WIDTH": "100" , "FIELD_NAME": "ERR_KEY"},
                {"HEAD_TEXT": "오류내용"     , "WIDTH": "500" , "FIELD_NAME": "ERR_REASON" , "ALIGN":"left" }
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "오류통보 목록조회",
                "targetLayer"  : "gridMasterLayer",
                "qKey"         : "res.selectR20List",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "countId"      : "totCnt",
                //"gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "scrollPaging" : true,
                "firstLoad"    : false,
                "postScript"   : function (){fn_detail(0);},
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL", "qKey":"res.selectR20List"}
                ]
            });

            gridDetail = new GridWrapper({
                "actNm"        : "오류통보 상세목록조회",
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "res.selectR20DetailList",
                "headers"      : headersDetail,
                "countId"      : "totDetailCnt",
                "check"        : false,
                "scrollPaging" : true,
                "firstLoad"    : false,
                "controllers"  : [
                    {"btnName": "btnExcelDetail" , "type": "EXCEL", "qKey":"res.selectR20DetailList", "postScript": "fn_ableExcel" }
                ]
            });

            $('#btnSearch').click(); // postScript 실행시 gridDetail 객체를 확보하기 위해 GridWrapper 생성후 조회
        });

        function fn_ableExcel(){
            var size = gridDetail.getSize();
            if(size == 0) return false;
            return true;
        }
        
        /***
         * 마스터 코드 클래스 링크
         * - 디테일 코드 조회
         * @param index
         */
        function fn_detail(index){
            var size = gridMaster.getSize();
            if(size == 0){
                globalVar.KEY_NO = "";
                return;
            }
            var data = gridMaster.getRowData(index);
            globalVar.KEY_NO = data["KEY_NO"];
            globalVar.refColName = "";

            // Detail Header Setting
            var h = new Array();
            h = $.merge(h , headersDetail);
           
            if(globalVar.refColName.length > 0){
                globalVar.refColName = globalVar.refColName.substring(0, globalVar.refColName.length-1);
            }

            gridDetail.setParams(data);
            gridDetail.setHeaders(h);
            gridDetail.drawGrid();
            gridDetail.requestToServer();
        }

    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
	            	<input type="hidden" id="APPLICANT_ID" name="APPLICANT_ID" value="${applicantId}"/>
	                <ul class="search_sectionC">
	                    <li>
	                        <label for="SEARCH_DAY" class="search_title">검색기준일자</label>
	                        <select id="SEARCH_DAY" name="SEARCH_DAY" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="RCV_DTM" selected>수신일시</option>
	                            <option value="DPT_DTM">통보일시</option>
	                        </select>
	                        <div class="search_date">
	                                <fieldset>
	                                    <legend class="blind">달력</legend>
	                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1y"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="S_RPT_NO" class="search_title">수출신고번호</label>
	                        <input type="text" id="S_RPT_NO" name="S_RPT_NO" class="search_input" <attr:pk/>/>
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
		</div><!-- search_toggle_frame -->

        <div class="title_frame">
	        <div class="white_frame">
	            <div class="util_frame">
	                <a href="#" class="btn white_100" id="btnExcel">엑셀다운로드</a>
	            </div>
	            <div id="gridMasterLayer" style="height: 220px">
	            </div>
	        </div>
        </div>
        
        <div class="title_frame">
        	<p><a href="#" class="btnToggle_table">상세정보</a></p>
	        <div class="white_frame">
	            <div class="util_frame" style="margin-top: -10px">
	                <a href="#" class="btn white_100" id="btnExcelDetail">엑셀다운로드</a>
	            </div>
	            <div id="gridDetailLayer" style="height: 150px">
	            </div>
	        </div>
        </div>
        
    </div> <%-- padding_box --%>
</div> <%-- inner-box --%>

<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
