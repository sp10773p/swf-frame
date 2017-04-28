<%--
    Class Name : pcrExpDecPopup.jsp
    Description : 수출신고필증 등록
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-10  정안균   최초 생성

    author : 정안균
    since : 2017-02-10
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridMaster, gridDetail, headers, headersDetail;
        $(function (){
        	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        	var data = arguments.PARAMS;
            headers = [
				{"HEAD_TEXT": "수신"        	, "WIDTH": "40" , "FIELD_NAME": "RECE"},
                {"HEAD_TEXT": "수출신고번호"    , "WIDTH": "120", "FIELD_NAME": "RPT_NO"      , "LINK":"fn_detail"},
                {"HEAD_TEXT": "주문번호"    	, "WIDTH": "150", "FIELD_NAME": "ORDER_ID"}   ,
                {"HEAD_TEXT": "수출자"    		, "WIDTH": "130", "FIELD_NAME": "COMM_FIRM"}  ,
                {"HEAD_TEXT": "신고일자"       	, "WIDTH": "80" , "FIELD_NAME": "RPT_DAY"     , "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "수리일자"    	, "WIDTH": "80" , "FIELD_NAME": "EXP_LIS_DAY" , "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "총중량(kg)"    	, "WIDTH": "130", "FIELD_NAME": "TOT_WT"      , "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "총포장수"    	, "WIDTH": "130", "FIELD_NAME": "TOT_PACK_CNT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "통화"       		, "WIDTH": "80" , "FIELD_NAME": "CUR"},
                {"HEAD_TEXT": "결제금액"    	, "WIDTH": "130", "FIELD_NAME": "AMT"         , "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "총신고액(원화)"  , "WIDTH": "130", "FIELD_NAME": "TOT_RPT_KRW" , "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "목적국"       	, "WIDTH": "80" , "FIELD_NAME": "TA_ST_ISO"},
                {"HEAD_TEXT": "적재항"       	, "WIDTH": "80" , "FIELD_NAME": "FOD_CODE"}
            ];
            
            headersDetail = [
                {"HEAD_TEXT": "HS부호", "WIDTH": "90", "FIELD_NAME": "HS_ID"},
                {"HEAD_TEXT": "품목"  , "WIDTH": "150", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"  , "WIDTH": "260", "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "수량"  , "WIDTH": "80" , "FIELD_NAME": "ITEM_QTY"       , "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "단가"  , "WIDTH": "100" , "FIELD_NAME": "BASE_PRICE_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "금액"  , "WIDTH": "100" , "FIELD_NAME": "ITEM_AMT"	   , "DATA_TYPE":"NUM"}
            ];             
          
            gridMaster = new GridWrapper({
                "actNm"        : "수출신고서 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "pcr.selectExpDecList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "check"        : false,
                "firstLoad"    : false,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
            gridDetail = new GridWrapper({
                "actNm"        : "HS부호 목록 조회",
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "pcr.selectExpDecItemList",
                "headers"      : headersDetail,
                "countId"      : "totDetailCnt",
                "check"        : true,
                "firstLoad"    : false
            });
           
            $('#btnSave').on("click", function (e) {
            	var size = gridDetail.getSelectedSize();
             	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
             	
         		data['ITEM'] = gridDetail.getSelectedRows();
         		$.comm.send("/pcr/savePcrDocAndItemList.do", data,
	                    function (data, status) {
	                		window.opener.searchDocAndItem(data.data.DOC_ID);
	                	}, "구매확인서 정보 저장");
            })
            
         	// 닫기
            $("#btnClose").click(function() {
                self.close();
            });  

        });
        
        // HS부호 조회
        function fn_detail(index){
        	var data = gridMaster.getRowData(index);
        	gridDetail.setParams(data);
        	gridDetail.requestToServer();
        	var offset = $("#gridDetailLayer").offset();
    		$('html, body').animate({scrollTop : offset.top}, 400);
        }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>수출신고필증 등록</h1>
    </div><!-- layerTitle -->
    <div class="layer_content" style="overflow-x:hidden;">
	    <form id="searchForm" name="searchForm">
	    	<div class="search_toggle_frame">
		        <div class="search_frame on">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="SEARCH_DTM" class="search_title">조회기간</label>
		                    <label for="F_REG_DTM" class="search_title" style="display: none">조회기간</label>
		                    <label for="T_REG_DTM" class="search_title" style="display: none">조회기간</label>
		                    <select name="SEARCH_DTM" id="SEARCH_DTM"class="search_input_select" style="width: 15% !important">
	                            <option value="RPT_DAY" selected>신고일자</option>
	                            <option value="EXP_LIS_DAY">수리일자</option>
	                        </select>
		                    <div class="search_date">
	                        	<fieldset>
	                            	<input type="text" name="F_REG_DTM" id="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/>/>
	                                <span>~</span>
	                                <input type="text" name="T_REG_DTM" id="T_REG_DTM" class="input" <attr:datefield value="0"/>/>
	                            </fieldset>
	                        </div>
		                </li>
		                <li>
		                    <label for="RPT_NO" class="search_title">수출신고번호</label>
		                    <input id="RPT_NO" name="RPT_NO" type="text" value="${RPT_NO}" class="search_input" placeholder=""/>
		                </li>
		            </ul>
		        <!-- search_sectionC -->
		        <a href="#" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
		        </div>
		        <a href="#" class="search_toggle close">검색접기</a>
	        </div><!-- search_toggle_frame -->
	    </form>
	    <div class="title_frame">
	        <div class="title_btn_frame clearfix">
				<p>수출신고서 목록</p>
			</div>
	    	<div class="white_frame">
		    	<div id="gridLayer" style="height: 200px"></div>
		    </div>
	    </div>
	   	<div class="title_frame">
	        <div class="title_btn_frame clearfix">
				<p style="width: 100%;">수출신고서 HS부호 목록(수출신고필증을 선택하면 수출신고필증과 구매물품으로 등록됨)</p>
			</div>
	    	<div class="white_frame">
		        <div class="util_frame">
	            	<a href="#" class="btn white_147" id="btnSave">수출신고필증 선택</a>
	            </div>
		        <div id="gridDetailLayer" style="height: 150px">
		        </div>
		    </div>
	    </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>

</body>
</html>
