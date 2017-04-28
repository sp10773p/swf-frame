<%--
  User: jjkhj
  Date: 2017-01-19
  Form: 반품수입의뢰 목록
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <s:eval expression="@config.getProperty('summary.from.date.period')" var="datePeriod"/>
    <script>
    var gridWrapper, headers;
    
    $(function (){
        // 로그인 화면의 반품수입신고의뢰 링크
        if(!$.comm.isNull(parent.mfn_getVariable("DEC_STATUS"))){
            var status = parent.mfn_getVariable("DEC_STATUS");

            $('#SEARCH_DTM').val("REG_DTM");

            $('#F_DTM').val(new Date().dateAdd2("d", parseInt("${datePeriod}")*-1).format('YYYY-MM-DD'));
            $('#T_DTM').val(new Date().format('YYYY-MM-DD'));

            parent.mfn_getVariable("DEC_STATUS", null);
        }

        headers = [
			{"HEAD_TEXT": "의뢰관리번호", "WIDTH": "150" , "FIELD_NAME": "REQ_NO", "LINK" : fn_detail}, 
			{"HEAD_TEXT": "상태", "WIDTH": "80" , "FIELD_NAME": "STATUS"},
			{"HEAD_TEXT": "주문번호" , "WIDTH": "150" , "FIELD_NAME": "ORDER_ID"},
			{"HEAD_TEXT": "수입신고번호" , "WIDTH": "100" , "FIELD_NAME": "RPT_NO"},
			{"HEAD_TEXT": "BL번호", "WIDTH": "100" , "FIELD_NAME": "BLNO"},
			{"HEAD_TEXT": "인도조건", "WIDTH": "80" , "FIELD_NAME": "CON_COD"},
			{"HEAD_TEXT": "결제통화", "WIDTH": "80" , "FIELD_NAME": "CON_CUR"},
			{"HEAD_TEXT": "결제금액", "WIDTH": "80" , "FIELD_NAME": "CON_AMT" , "ALIGN":"right"},
			{"HEAD_TEXT": "운임", "WIDTH": "80" , "FIELD_NAME": "FRE_AMT", "ALIGN":"right"},
			{"HEAD_TEXT": "보험료", "WIDTH": "80" , "FIELD_NAME": "INSU_AMT", "ALIGN":"right"},
			{"HEAD_TEXT": "적출국", "WIDTH": "80" , "FIELD_NAME": "FOD_ST_ISO"},
			{"HEAD_TEXT": "해외거래처 상호" , "WIDTH": "80" , "FIELD_NAME": "SUP_FIRM"},
			{"HEAD_TEXT": "총포장갯수" , "WIDTH": "80" , "FIELD_NAME": "TOT_PACK_CNT", "ALIGN":"right"},
			{"HEAD_TEXT": "포장단위", "WIDTH": "80" , "FIELD_NAME": "TOT_PACK_UT"},
			{"HEAD_TEXT": "총중량(KG)", "WIDTH": "80" , "FIELD_NAME": "TOT_WT", "ALIGN":"right"},
			{"HEAD_TEXT": "수입자상호" , "WIDTH": "80" , "FIELD_NAME": "IMP_FIRM"},
			{"HEAD_TEXT": "수입자통관부호" , "WIDTH": "80" , "FIELD_NAME": "IMP_TGNO"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm" : "수입신고요청 조회",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectImpReq",
			"requestUrl" : "/imp/selectImpReqList.do",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"gridNaviId" : "gridPagingLayer",
			"check" : true,
			"firstLoad" : true,
			"controllers" : [
				 {"btnName": "btnSearch", "type": "S"},
				 {"btnName": "btn_excel", "type": "EXCEL"}, 
                 {"btnName": "btn_del" , "type": "D", "targetURI":"/imp/deleteImpReqs.do"}
			], 
			"postScript" : function(grid) {
				var data = grid.getData();
				for(var i in data) {
					if(data[i]['STATUS'] == '수리') {
						grid.setCheckDisabled(data[i]['RIDX'], true);    
					}
				}
			}
		});
		            
		$('#btn_new').on("click", function (e) {
			fn_detail();
		});
		
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
            $.comm.fileDownload({"REQ_NOS" : reqNos}, "수출신고 의뢰파일다운로드(ZIP)", "/imp/downloadImpReqInZip.do");
		});
	});

	function fn_detail(rIdx){
		var reqNo = "";
		if(arguments.length != 0) {
			reqNo = gridWrapper.getData()[rIdx]['REQ_NO'];
		}
		$.comm.forward("exp/imp/impReqDetail", {'REQ_NO' : reqNo ? reqNo : ""});
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
									<option value="REG_DTM" selected>등록일자</option>
									<option value="MOD_DTM">수정일자</option>
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
	                            <label class="search_title" for="STATUS">상태</label>
	                            <select class="search_input_select" id="STATUS" name="STATUS">
	                                <option value="" selected>전체</option>
	                                <option value="RG">등록</option>
	                                <option value="RR">수리</option>
	                            </select>
	                        </li>     
	                        <li>
	                            <label class="search_title" for="SEARCH_COL">검색조건</label>
	                            <select class="search_input_select" id="SEARCH_COL" name="SEARCH_COL">
									<option value="REQ_NO" selected>의뢰관리번호</option>
									<option value="ORDER_ID">주문번호</option>
									<option value="IMP_FIRM">수입자상호</option>
									<option value="IMP_TGNO">수입자통관부호</option>
	                            </select>
	                            <input class="search_input" type="text" id="SEARCH_TXT" name="SEARCH_TXT" >
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
					<a href="#" class="btn white_147" id="btn_down">의뢰파일다운로드</a>
					<a href="#" class="btn white_84" id="btn_del">삭제</a>
					<a href="#" class="btn white_84" id="btn_new">신규</a>
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