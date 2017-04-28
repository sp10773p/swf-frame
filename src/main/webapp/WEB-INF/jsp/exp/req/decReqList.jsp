<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출신고요청조회 목록
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
				{"HEAD_TEXT": "상태"        			, "WIDTH": "100"   , "FIELD_NAME": "STATUS_NM"},
				{"HEAD_TEXT": "요청방식"        		, "WIDTH": "80"   , "FIELD_NAME": "REGIST_METHOD"},
                {"HEAD_TEXT": "판매자ID"      		, "WIDTH": "120"  , "FIELD_NAME": "SELLER_ID", "ALIGN":"left"},
                {"HEAD_TEXT": "주문번호"       		, "WIDTH": "150"  , "FIELD_NAME": "ORDER_ID"},
                {"HEAD_TEXT": "수출신고번호"       	, "WIDTH": "200"  , "FIELD_NAME": "RPT_NO"},
                {"HEAD_TEXT": "수출상태"    			, "WIDTH": "100"  , "FIELD_NAME": "RECE_NM"},
                {"HEAD_TEXT": "배송방법"    			, "WIDTH": "100"  , "FIELD_NAME": "DELIVERY_METHOD"},
                {"HEAD_TEXT": "결제금액"    			, "WIDTH": "80"   , "FIELD_NAME": "PAYMENTAMOUNT" , "ALIGN":"right"},
                {"HEAD_TEXT": "결제통화"    			, "WIDTH": "80"   , "FIELD_NAME": "PAYMENTAMOUNT_CUR"},
                {"HEAD_TEXT": "목적국"    			, "WIDTH": "80"   , "FIELD_NAME": "DESTINATIONCOUNTRYCODE"},
                {"HEAD_TEXT": "구매자상호"    		, "WIDTH": "200"  , "FIELD_NAME": "BUYERPARTYORGNAME", "ALIGN":"left"},
                {"HEAD_TEXT": "총포장갯수"    		, "WIDTH": "80"   , "FIELD_NAME": "SUMMARY_TOTALQUANTITY", "ALIGN":"right"},
                {"HEAD_TEXT": "포장단위"    			, "WIDTH": "80"   , "FIELD_NAME": "SUMMARY_TOTALQUANTITY_UC"},
                {"HEAD_TEXT": "중량합계"    			, "WIDTH": "80"   , "FIELD_NAME": "SUMMARY_TOTALWEIGHT", "ALIGN":"right"},
                {"HEAD_TEXT": "중량단위"    			, "WIDTH": "80"   , "FIELD_NAME": "SUMMARY_TOTALWEIGHT_UC"},
                {"HEAD_TEXT": "판매자상호"    		, "WIDTH": "200"   , "FIELD_NAME": "EOCPARTYORGNAME2", "ALIGN":"left"},
                {"HEAD_TEXT": "판매자사업자등록번호"   	, "WIDTH": "150"  , "FIELD_NAME": "EOCPARTYPARTYIDID1"},
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출신고요청 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "req.selectDecReqList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btn_excel", "type": "EXCEL", "qKey":"req.selectDecReqList"}
                ]
            });
            
          	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
            $.comm.bindCombo("REQ_STATUS"   , "REQ_STATUS",  true, null, null, null, 1);	//상태
    		
            $('#btn_down').on("click", function (e) {
            	var size = gridWrapper.getSelectedSize();
                if(size == 0){
                    alert($.comm.getMessage("W00000003")); //선택한 데이터가 없스니다.
                    return;
                }
               
                var reqNos = new Array();
                var rows = gridWrapper.getSelectedRows();
                for(var idx in rows) {
                	reqNos.push(rows[idx]['REQ_NO']);
                }
                
                console.log(reqNos)
                $.comm.fileDownload({"REQ_NOS" : reqNos}, "수출신고 의뢰파일다운로드(ZIP)", "/dec/downloadExpReqInZip.do");
    		});
        });

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            data["SAVE_MODE"] = "";

            $.comm.forward("exp/req/decReqDetail", data);
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
	                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" class="input" <attr:datefield to="T_REG_DTM" value="-1m"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                            </form>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="REQ_STATUS" class="search_title">상태</label>
	                        <select id="REQ_STATUS" name="REQ_STATUS" class="search_input_select"></select>
	                    </li>
	                    <li>
	                        <label for="SEARCH_COL" class="search_title">검색조건</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/> >
	                            <option value="A.REQ_NO" selected>요청관리번호</option>
	                            <option value="B.RPT_NO">수출신고번호</option>
	                            <option value="A.SELLER_ID">판매자ID</option>
	                            <option value="A.ORDER_ID">주문번호</option>
	                            <option value="A.BUYERPARTYORGNAME">구매자상호</option>
	                            <option value="A.EOCPARTYPARTYIDID1">판매자사업자등록번호</option>
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
				<a href="#" class="btn white_147" id="btn_down">의뢰파일다운로드</a>
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
