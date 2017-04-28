<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출신고조회  란
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridMaster, headers, gridDetail, headersDetail;
        var globalVar = {
                "RPT_NO"  : "",
                "refColName": ""
            }
        $(function (){
        	globalVar.refColName = ""; // detail 참조 컬럼
        	
        	init();
        	
        	headers = [
				{"HEAD_TEXT": "란번호"       	, "WIDTH": "80"   , "FIELD_NAME": "RAN_NO"},
				{"HEAD_TEXT": "세번부호"     	, "WIDTH": "80"   , "FIELD_NAME": "HS", "LINK":"fn_detail"},
                {"HEAD_TEXT": "거래품명"		, "WIDTH": "100"  , "FIELD_NAME": "EXC_GNM"},
                {"HEAD_TEXT": "수량"       	, "WIDTH": "100"  , "FIELD_NAME": "WT"},
                {"HEAD_TEXT": "신고금액원화"	, "WIDTH": "120"  , "FIELD_NAME": "RPT_KRW"}
                
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "수출신고  란조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "dec.selectDecRanList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "",
                "check"        : true,
                "firstLoad"    : false,
                "pageRow"      : 15,
                "postScript"   : function (){fn_setForm();},
                "controllers"  : [
                                  {"btnName": "btnSearch", "type": "S"}
                              ]
            });
        	
        	headersDetail = [
				{"HEAD_TEXT": "순번"       	, "WIDTH": "80"   , "FIELD_NAME": "SIL"},
				{"HEAD_TEXT": "모델규격"     	, "WIDTH": "80"   , "FIELD_NAME": "GNM"},
                {"HEAD_TEXT": "성분"     	, "WIDTH": "120"  , "FIELD_NAME": "COMP"},
                {"HEAD_TEXT": "수량"         , "WIDTH": "120"  , "FIELD_NAME": "QTY"},
                {"HEAD_TEXT": "단위"     	, "WIDTH": "150"  , "FIELD_NAME": "QTY_UT"},
                {"HEAD_TEXT": "단가"       	, "WIDTH": "100"  , "FIELD_NAME": "PRICE"},
                {"HEAD_TEXT": "금액"       	, "WIDTH": "100"  , "FIELD_NAME": "AMT"}
                
            ];

            gridDetail = new GridWrapper({
                "actNm"        : "수출신고 규격조회",
                "targetLayer"  : "subGridLayer",
                "qKey"         : "dec.selectDecModelList",
                "headers"      : headersDetail,
                "paramsFormId" : "",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : false,
                "pageRow"      : 5,
                "controllers"  : []
            });
        	
	     	// 공통 btn
	        $('#btnComm').on("click", function (e) {
	        	//$.comm.pageBack();
	        	$.comm.forward("exp/dec/decDetail", {"RPT_NO":"${RPT_NO}"});
	        });
	     	
	        $('#btnSearch').click(); // postScript 실행시 gridDetail 객체를 확보하기 위해 GridWrapper 생성후 조회
	        
	      	//controll 처리
        	fn_controll();
        });
        
        function init(){
        	$("#RPT_NO").val("${RPT_NO}");
        }
        
        
        //상세정보
        function fn_detail(index){
            var gridData = gridMaster.getRowData(index);
            var param = {  "qKey" : "dec.selectDecRanDetail"
            		     , "RPT_NO": gridData.RPT_NO
            		     , "RPT_SEQ": gridData.RPT_SEQ
            		     , "RAN_NO": gridData.RAN_NO
            			};
			
         	$.comm.send("/common/select.do", param,
                function(data, status){
        			$.comm.bindData(data.data);
                    //gridMaster.setParams(data.data);
                    //gridMaster.requestToServer();
                },
                "란 상세정보 조회"
            );
         	
         	fn_detailList(index);
         	
        }
        
        function fn_detailList(index){
            var size = gridMaster.getSize();
            if(size == 0){
                globalVar.RPT_NO = "";
                return;
            }
            var data = gridMaster.getRowData(index);
            globalVar.RPT_NO = data["RPT_NO"];
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
        
        function fn_setForm(){
        	var size = gridMaster.getSize();
        	
        	//조회된 란List 가 없을때 상세정보 초기화
            if(size == 0){
            	$("#ranTable > tbody > tr > td > :text").val('');
            	 
              	return;
            }
            
            fn_detail(0);
        }
        
		function fn_controll(){
        	$.comm.disabled("RAN_NO", true);
        	$.comm.disabled("HS", true);
        	$.comm.disabled("SUN_UT", true);
        }

    </script>
</head>
<body>
<div id="main_wrap">
    <!-- content 시작 -->
    <div id="content">
        <div class="con_box">
            <h2>${ACTION_MENU_NM}</h2>
            <!-- 검색 시작 -->
            <div class="search_gray" style="margin-bottom: 5px !important; display: none;">
                <form id="searchForm">
                	<button type="button" name="btnSearch" id="btnSearch" class="btn btn-info">조회</button>
                	<input id="RPT_NO" name="RPT_NO" type="hidden" maxlength="50" />
                </form>
            </div>
            <!-- 검색 끝 -->
            
			<nav class="w3-sidenav w3-collapse w3-white w3-animate-left" style="top:135px; width:400px; " id="mySidenav">
			    <div id="gridLayer" style="padding: 0px; width: 100%; height: 780px;"></div>
			</nav>
			
			<div class="w3-main w3-container" style="margin-left:430px;">
				<!-- 버튼 시작 -->
	            <div class="btnBlock" style="padding-bottom: 10px !important;">
	                <a href="#" class="btn_bom" id="btnComm">공통</a>
	            </div>
	            <!--// 버튼 끝 -->
            
                <table class="tableView2" summary="란 상세정보" id="ranTable">
                    <caption class="skip">란 상세정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label for="RAN_NO">란번호</label></th>
                            <td><input type="text" name="RAN_NO" id="RAN_NO" style="width: 40% !important "></td>
                            <th><label for="HS">세번부호</label></th>
                            <td><input type="text" name="HS" id="HS" style="width: 60% !important "><label style="background-color: red;"  >버튼</label></td>
                            <th><label for="MG_CODE">송품장번호</label></th>
                            <td><input type="text" name="MG_CODE" id="MG_CODE" style="background-color: yellow;"></td>
                        </tr>
                        <tr>
                            <th><label for="STD_GNM">품명</label></th>
                            <td colspan="5"><input type="text" name="STD_GNM" id="STD_GNM"></td>
                        </tr>
                        <tr>
                            <th><label for="EXC_GNM">거래품명</label></th>
                            <td colspan="5"><input type="text" name="EXC_GNM" id="EXC_GNM"></td>
                        </tr>
                        <tr>
                            <th><label for="MODEL_GNM">상표명</label></th>
                            <td colspan="3"><input type="text" name="MODEL_GNM" id="MODEL_GNM"></td>
                            <th><label for="ATT_YN">서류첨부여부</label></th><!-- Combo,CMM_STD_CODE.YN -->
                            <td><input type="text" name="ATT_YN" id="ATT_YN"  style="width: 20% !important"></td>
                        </tr>
                        <tr>
                            <th>
                            	<label for="RPT_KRW">신고가격</label>
                                <label for="RPT_KRW" style="display: none;">신고금액원화</label>
                                <label for="RPT_USD" style="display: none;">신고금액미화</label>
                            </th>
                            <td colspan="3">
                            	<label>￦ </label><input type="text" name="RPT_KRW" id="RPT_KRW" style="width: 40% !important">
                            	<label>$ </label><input type="text" name="RPT_USD" id="RPT_USD" style="width: 40% !important">
                            </td>
                            <th><label for="CON_AMT">결제금액</label></th>
                            <td><input type="text" name="CON_AMT" id="CON_AMT"></td>
                        </tr>
                        <tr>
                            <th>
                            	<label>순중량</label>
                                <label for="SUN_WT" style="display: none;">순중량</label>
                                <label for="SUN_UT" style="display: none;">순중량단위</label>
                            </th>
                            <td>
                            	<input type="text" name="SUN_WT" id="SUN_WT" style="width: 60% !important">
                            	<input type="text" name="SUN_UT" id="SUN_UT" style="width: 20% !important">
                            </td>
                            <th>
                            	<label>수량</label>
                                <label for="WT" style="display: none;">수량</label>
                                <label for="UT" style="display: none;">수량단위</label>
                            </th>
                            <td>
                            	<input type="text" name="WT" id="WT" style="width: 60% !important">
                            	<input type="text" name="UT" id="UT" style="width: 20% !important">
                            </td>
                            <th>
                            	<label>포장갯수</label>
                                <label for="PACK_CNT" style="display: none;">포장갯수</label>
                                <label for="PACK_UT" style="display: none;">포장단위</label>
                            </th>
                            <td>
                            	<input type="text" name="PACK_CNT" id="PACK_CNT" style="width: 60% !important">
                            	<input type="text" name="PACK_UT" id="PACK_UT" style="width: 20% !important">
                            </td>
                        </tr>
                        <tr>
                            <th>
                            	<label>원산지</label>
                                <label for="ORI_ST_MARK1" style="display: none;">원산지국가</label><!-- Combo,CMM_STD_CODE.CUS0005 -->
                                <label for="ORI_ST_MARK2" style="display: none;">원산지결정기준</label><!-- Combo,CMM_STD_CODE.CUS0024 -->
                                <label for="ORI_ST_MARK3" style="display: none;">원산지표시여부</label><!-- Combo,CMM_STD_CODE.CUS0025 -->
                                <label for="ORI_FTA_YN" style="display: none;">원산지발급여부</label><!-- Combo,CMM_STD_CODE.CUS1005 -->
                            </th>
                            <td colspan="5">
                            	<label>국가  </label><input type="text" name="ORI_ST_MARK1" id="ORI_ST_MARK1" style="width: 10% !important">
                            	<label>결정기준  </label><input type="text" name="ORI_ST_MARK2" id="ORI_ST_MARK2" style="width: 10% !important">
                            	<label>표시여부  </label><input type="text" name="ORI_ST_MARK3" id="ORI_ST_MARK3" style="width: 10% !important">
                            	<label>발급여부  </label><input type="text" name="ORI_FTA_YN" id="ORI_FTA_YN" style="width: 10% !important">
                            </td>
                            <!-- 
                            <th>
                            	<label>수입신고번호/란</label>
                                <label for="IMP_RPT_SEND" style="display: none;">수입신고번호</label>
                                <label for="IMP_RAN_NO" style="display: none;">수입신고란번호</label>
                            </th>
                            <td>
                            	<input type="text" name="IMP_RPT_SEND" id="IMP_RPT_SEND" style="width: 60% !important; background-color: yellow;">/
                            	<input type="text" name="IMP_RAN_NO" id="IMP_RAN_NO" style="width: 20% !important; background-color: yellow;">
                            </td>
                             -->
                        </tr>
                    </tbody>
                </table>
                
                <h3>규격정보</h3>
                <div id="subGridLayer" style="padding: 0px; width: 100%;"></div>
                
			</div>
           
           
        </div> <%-- // con_box --%>
    </div><%-- // content--%>

</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
