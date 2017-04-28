<%--
  User: jjkhj
  Date: 2017-04-05
  Form: 세관통보문서 조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    	var gridWrapper, headers;
        $(function (){
        	headers = [
			    
                {"HEAD_TEXT": "수출신고번호"  	, "WIDTH": "120"  , "FIELD_NAME": "REQ_KEY"},
                {"HEAD_TEXT": "수신문서종류"  	, "WIDTH": "150"  , "FIELD_NAME": "DOC_TYPE_NM", "ALIGN":"left" , "LINK":"fn_detail"},
                {"HEAD_TEXT": "수신일시"    	, "WIDTH": "150"  , "FIELD_NAME": "SND_RCV_DTM"},
                {"HEAD_TEXT": "수출화주명"    , "WIDTH": "150"  , "FIELD_NAME": "ORG_NM"},
                {"HEAD_TEXT": "등록자"      	, "WIDTH": "100"  , "FIELD_NAME": "REG_ID"},
                {"HEAD_TEXT": "등록일자"   	, "WIDTH": "110"  , "FIELD_NAME": "REG_DTM"}
                
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "세관통보문서 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "res.selectResList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : false,
                "controllers"  : [
                    {"btnName": "btnSearch" , "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL", "qKey":"res.selectResList"}
                ]
            });
            
            $.comm.bindCombo("DOC_TYPE_R", "DOC_TYPE_R", true);
            $.comm.initPageParam();
            $('#RPT_NO').val("${RPT_NO}");
            $('#CALL_TYPE').val("${CALL_TYPE}");
            gridWrapper.requestToServer();
            
            $('#btnExpDec').on("click", function (e) { fn_decList(); });  //수출신고 목록
            
        });
        
     	// 상세화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            var docType = data["DOC_TYPE"].toLowerCase();;
            var formNm = docType+"Detail";

            $.comm.forward("exp/res/"+formNm, data);
        }
     	
     	function fn_decList(){
     		var callType =  $('#CALL_TYPE').val();
     		if(callType == 'DEC'){
     			$.comm.pageBack(); 
     		}else if(callType == 'MOD'){
         		$.comm.pageBack(); 
     		}else{
     			$.comm.forward("exp/dec/decList", null);
     		}
     	}
        
    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
	                <input type="hidden" id="CALL_TYPE" name="CALL_TYPE"/>
	                <ul class="search_sectionC">
	                    <li>
	                        <label class="search_title">수신일자</label>
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
	                        <label for="" class="search_title">문서명</label>
                        	<select name="DOC_TYPE_R" id="DOC_TYPE_R"></select>
	                    </li>
	                    <li>
	                        <label for="RPT_NO" class="search_title">수출신고번호</label>
	                        <input type="text" id="RPT_NO" name="RPT_NO" class="search_input" <attr:pk/>/>
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
                <a href="#" class="btn white_147" id="btnExpDec">수출/정정신고목록</a>
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
