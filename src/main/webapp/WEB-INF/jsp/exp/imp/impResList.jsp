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
    var fileUtil;
    
    $(function (){
        headers = [
			{"HEAD_TEXT": "수입신고번호", "WIDTH": "130" , "FIELD_NAME": "RPT_NO", "LINK":fn_detail},
			{"HEAD_TEXT": "의뢰관리번호", "WIDTH": "130", "FIELD_NAME": "IMP_REQ_NO"},
			{"HEAD_TEXT": "신고일자", "WIDTH": "100" , "FIELD_NAME": "RPT_DAY"},
			{"HEAD_TEXT": "수리일자", "WIDTH": "100" , "FIELD_NAME": "LIS_DAY"},
			{"HEAD_TEXT": "BL번호", "WIDTH": "160" , "FIELD_NAME": "BLNO"},
			{"HEAD_TEXT": "적출국", "WIDTH": "50" , "FIELD_NAME": "FOD_MARK"},
			{"HEAD_TEXT": "해외구매자상호", "WIDTH": "200", "FIELD_NAME": "SUP_FIRM"},
			{"HEAD_TEXT": "인도조건", "WIDTH": "50", "FIELD_NAME": "CON_COD"},
			{"HEAD_TEXT": "통화", "WIDTH": "50", "FIELD_NAME": "CON_CUR"},
			{"HEAD_TEXT": "결제금액", "WIDTH": "110", "FIELD_NAME": "CON_AMT", "ALIGN":"right"},
			{"HEAD_TEXT": "총신고액(원화)", "WIDTH": "110", "FIELD_NAME": "TOT_TAX_KRW", "ALIGN":"right"},
			{"HEAD_TEXT": "총신고액(미화)", "WIDTH": "110", "FIELD_NAME": "TOT_TAX_USD", "ALIGN":"right"},
			{"HEAD_TEXT": "총관세", "WIDTH": "110", "FIELD_NAME": "TOT_GS", "ALIGN":"right"},
			{"HEAD_TEXT": "총부가세", "WIDTH": "110", "FIELD_NAME": "TOT_VAT", "ALIGN":"right"},
			{"HEAD_TEXT": "총세액", "WIDTH": "80", "FIELD_NAME": "TOT_TAX_SUM", "ALIGN":"right"},
			{"HEAD_TEXT": "총중량", "WIDTH": "100", "FIELD_NAME": "TOT_WT", "ALIGN":"right"},
			{"HEAD_TEXT": "총포장수", "WIDTH": "80", "FIELD_NAME": "TOT_PACK_CNT", "ALIGN":"right"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm" : "반품수입신고결과 조회",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectImpRes",
			"requestUrl" : "/imp/selectImpResList.do",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"gridNaviId" : "gridPagingLayer",
			"firstLoad" : true,
			"controllers" : [
				 {"btnName": "btnSearch", "type": "S"},
				 {"btnName": "btn_excel", "type": "EXCEL"}
			]
		});
		       
		fileUtil = new FileUtil({
            "addBtnId" : "btn_upload",
            "addUrl" : "/imp/uploadResFile.do",
			"successCallback" : function(rst) {
				gridWrapper.requestToServer();
			}
        });
	});

	function fn_detail(rIdx){
		var rptNo = "";
		if(arguments.length != 0) {
			rptNo = gridWrapper.getData()[rIdx]['RPT_NO'];
		}
		$.comm.forward("exp/imp/impResDetail", {'RPT_NO' : rptNo ? rptNo : ""});
	}
    </script>
</head>
<body>
    <div class="inner-box">
        <div class="padding_box">
            <div class="search_toggle_frame">        
            	<div class="search_frame on">
	                <form id="searchForm">            
		                <ul class="search_sectionC">
	                        <li>
	                            <label class="search_title" for="SEARCH_DTM">검색기준일자</label>
	                            <select class="search_input_select before_date" id="SEARCH_DTM" name="SEARCH_DTM">
									<option value="RPT_DAY" selected>신고일자</option>
									<option value="LIS_DAY">수리일자</option>
	                            </select>
	                            <div class="search_date">
									<fieldset>
										<legend class="blind">달력</legend>
										<label for="F_DTM" style="display: none">검식기준시작일</label>
										<input type="text" id="F_DTM" name="F_DTM" class="input" <attr:datefield to="T_DTM"  value="-1m"/> />
	                                    <span>~</span>
										<label for="T_DTM" style="display: none">검식기준종료일</label>
										<input type="text" id="T_DTM" name="T_DTM" class="input" <attr:datefield  value="0"/> />
									</fieldset>
	                            </div>
	                        </li>
							<li>
								<label for="RPT_NO" class="search_title">수입신고번호</label>
								<input type="text" class="search_input" id="RPT_NO" name="RPT_NO" />
							</li>                                               
	                        <li>
								<label for="IMP_REQ_NO" class="search_title">의뢰관리번호</label>
								<input type="text" class="search_input" id="IMP_REQ_NO" name="IMP_REQ_NO" />
	                        </li>                     
	                    </ul>
	                    <a href="#" class="btn_inquiryB" style="float:right;" id="btnSearch">조회</a>
	                </form>
		        </div><!-- search_frame -->
		        <a href="#" class="search_toggle close">검색접기</a>	                
            </div> <%-- // search_gray --%>
            <!-- 검색 끝 -->

	        <div class="list_typeA">
	            <div class="util_frame">
                  <a href="#" class="btn white_100" id="btn_excel">엑셀다운로드</a>         
                  <a href="#" class="btn white_147" id="btn_upload">수입신고결과업로드</a>
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