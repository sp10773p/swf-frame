<%--
  User: jjkhj
  Date: 2017-01-19
  Form: 수출신고업로드 목록
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers, gridDetail, headersDetail;
        $(function (){
            headers = [
				{"HEAD_TEXT" : "업로드 일시"       	,  	"FIELD_NAME" : "REG_DTM",		"WIDTH" : "300",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "엑셀 건수"         	,	"FIELD_NAME" : "TOT_CNT",		"WIDTH" : "200",	"ALIGN" : "right"},
				{"HEAD_TEXT" : "등록 건수"         	,	"FIELD_NAME" : "REG_CNT",		"WIDTH" : "200",	"ALIGN" : "right",		"COLR" : "GREEN"},
				{"HEAD_TEXT" : "오류 건수"			,	"FIELD_NAME" : "ERR_CNT",		"WIDTH" : "200",	"ALIGN" : "right",		"COLR" : "RED"},
				{"HEAD_TEXT" : "업로드 내역"       	,	"FIELD_NAME" : "업로드 내역",		"WIDTH" : "300",	"ALIGN" : "center",		"BTN_FNC" : "fn_excel_popup"},
				{"HEAD_TEXT" : "오류건 엑셀 다운로드"	,	"FIELD_NAME" : "다운로드",		"WIDTH" : "250",	"ALIGN" : "center",		"BTN_FNC" : "fn_excel_down"},
            ];

            
            gridWrapper = new GridWrapper({
                "actNm"        : "수출신고업로드 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "upl.selectDecExcelList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                ]
            });
            
            headersDetail = [
				/* 몰관리자 통합에 따른 판매자정보 주석처리 
				{"HEAD_TEXT" : "사업자번호"			,  "FIELD_NAME" : "EOCPARTYPARTYIDID1"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "판매업체명"			,  "FIELD_NAME" : "EOCPARTYORGNAME2"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "대표자명"				,  "FIELD_NAME" : "EOCPARTYORGCEONAME"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "신고인부호"			,  "FIELD_NAME" : "APPLICANTPARTYORGID"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "통관고유부호" 			,  "FIELD_NAME" : "EOCPARTYPARTYIDID2"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "우편번호"    			,  "FIELD_NAME" : "EOCPARTYLOCID"			,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "주소"       			,  "FIELD_NAME" : "EOCPARTYADDRLINE"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "몰이름"     			,  "FIELD_NAME" : "MALL_ID"					,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				*/
				
				{"HEAD_TEXT" : "주문번호"				,  "FIELD_NAME" : "ORDER_ID"				,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "상품ID"				,  "FIELD_NAME" : "MALL_ITEM_NO"			,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "상품명 (영문)"				,  "FIELD_NAME" : "ITEMNAME_EN"				,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "주문수량"				,  "FIELD_NAME" : "LINEITEMQUANTITY"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "결제금액" 			,  "FIELD_NAME" : "PAYMENTAMOUNT"			,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "결제통화코드" 			,  "FIELD_NAME" : "PAYMENTAMOUNT_CUR"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "구매자상호명" 			,  "FIELD_NAME" : "BUYERPARTYORGNAME"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "목적국 국가코드" 		,  "FIELD_NAME" : "DESTINATIONCOUNTRYCODE"	,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "HS코드"				,  "FIELD_NAME" : "CLASSIDHSID"				,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "중량"				,  "FIELD_NAME" : "NETWEIGHTMEASURE"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "가격"				,  "FIELD_NAME" : "DECLARATIONAMOUNT"		,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "도메인명"				,  "FIELD_NAME" : "SELL_MALL_DOMAIN"		,	"WIDTH" : "200",	"ALIGN" : "center"},
				
				{"HEAD_TEXT" : "제조자" 				,  "FIELD_NAME" : "MAKER_NM"				,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "제조자사업자번호" 		,  "FIELD_NAME" : "MAKER_REG_ID"			,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "제조자사업장일련번호"	,  "FIELD_NAME" : "MAKER_LOC_SEQ"			,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "제조자통관고유부호"		,  "FIELD_NAME" : "MAKER_ORG_ID"			,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "제조장소(우편번호)"	,  "FIELD_NAME" : "MAKER_POST_CD"			,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "산업단지부호"			,  "FIELD_NAME" : "MAKER_LOC_CD"			,	"WIDTH" : "200",	"ALIGN" : "center"},

				{"HEAD_TEXT" : "인도조건" 			,  "FIELD_NAME" : "AMT_COD"					,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "운임원화"       		,  "FIELD_NAME" : "FRE_KRW"					,	"WIDTH" : "200",	"ALIGN" : "center"}, 
				{"HEAD_TEXT" : "보험료원화"    		,  "FIELD_NAME" : "INSU_KRW"				,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "상품성분명"     		,  "FIELD_NAME" : "COMP"					,	"WIDTH" : "200",	"ALIGN" : "center"},
				{"HEAD_TEXT" : "주문수량단위"     		,  "FIELD_NAME" : "LINEITEMQUANTITY_UC"		,	"WIDTH" : "200",	"ALIGN" : "center"}
				
            ];
            
            gridDetail = new GridWrapper({
                "actNm"        : "수출신고업로드 오류상세",
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "upl.selectDecExcelErrList",
                "headers"      : headersDetail,
                "paramsFormId" : "searchForm",
                "countId"      : "",
                "check"        : false,
                "scrollPaging" : false,
                "firstLoad"    : false,
                "controllers"  : [
                ]
            });
            
            singleFileUtil = new FileUtil({
                "id"				: "file",
                "addBtnId"			: "btnUpload",
                "extNames"			: ["xls", "xlsx"],
                "successCallback"	: fn_callback,
                "postService"		: "uplService.uploadDecExcel"
            });
            
        });
		
        function fn_callback(){
        	gridWrapper.requestToServer();
        	var fn_callback = function (data) {
                //console.log(data);
            }
        }
        
        //업로드내역 상세 팝업
        function fn_excel_popup(index) {
            var data = gridWrapper.getRowData(index);
            $.comm.setModalArguments({"SN":data["SN"]});
            var spec = "width:1100px;height:700px;scroll:auto;status:no;center:yes;resizable:yes;windowName:decExcelPopup";
            $.comm.dialog("<c:out value='/jspView.do?jsp=exp/upl/decExcelPopup' />", spec,
                function () { 
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    	
                    }
                }
            );
        }
        
        //오류건 엑셀 다운로드
        function fn_excel_down(index){
        	var data = gridWrapper.getRowData(index);
        	var errCnt = data["ERR_CNT"];
        	if(errCnt == 0){
        		alert("오류건이 없습니다.");
        		return;
        	}
        	$("#SN").val(data["SN"]);
        	var param = {};
        	param.btn_type = "EXCEL";
        	gridDetail.requestToServer(param);
        }

    </script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
	        <div class="search_frame on">
	            <form id="searchForm" name="searchForm">
	            	<input type="hidden" id="SN" name="SN" />
	                <ul class="search_sectionC">
	                    <li>
	                        <label class="search_title">등록일자</label>
	                        <div class="search_date">
	                            <fieldset>
	                                <legend class="blind">달력</legend>
	                                <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/> />
	                                <span>~</span>
	                                <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                            </fieldset>
	                        </div>
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div>

        <div class="list_typeA">
            <div class="util_frame">
            	<form>
                    <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
                    <input type="hidden" id="FILE_SN" name="FILE_SN" />
                    <a href="<c:url value="/form/Orderlist_new.xls" />" class="btn white_173">표준 엑셀폼 다운로드</a>
                    <a href="#파일업로드" class="btn white_100" id="btnUpload">엑셀 업로드</a>
                </form>
                
      
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 400px"></div>
            <div id="gridDetailLayer" style="display: none;"></div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer"></div>
        </div>
    </div>
</div> <%-- inner-box --%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
