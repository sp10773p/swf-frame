<%--
    Class Name : prodList.jsp
    Description : 상품관리
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.08  정안균   최초 생성

    author : 정안균
    since : 2017.03.08
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "몰명"      , "WIDTH": "100", "FIELD_NAME": "MALL_ID"},
                {"HEAD_TEXT": "몰상품번호", "WIDTH": "150", "FIELD_NAME": "MALL_ITEM_NO"},
                {"HEAD_TEXT": "상품명"    , "WIDTH": "250", "FIELD_NAME": "ITEM_NM", "LINK":"fn_detail"},
                {"HEAD_TEXT": "등록구분"  , "WIDTH": "70" , "FIELD_NAME": "REGIST_METHOD"},
                {"HEAD_TEXT": "HS코드"    , "WIDTH": "90" , "FIELD_NAME": "HS_CD"},
                {"HEAD_TEXT": "카테고리1" , "WIDTH": "100", "FIELD_NAME": "CATEGORY1"},
                {"HEAD_TEXT": "카테고리2" , "WIDTH": "100", "FIELD_NAME": "CATEGORY2"},
                {"HEAD_TEXT": "카테고리3" , "WIDTH": "100", "FIELD_NAME": "CATEGORY3"},
                {"HEAD_TEXT": "등록일자"  , "WIDTH": "80" , "FIELD_NAME": "REG_DTM", "DATA_TYPE":"DAT"}
            ];

            gridWrapper = new GridWrapper({
                "actNm": "상품정보 목록조회",
                "targetLayer": "gridLayer",
                "qKey": "prod.selectItemList",
                "headers": headers,
                "paramsFormId": "searchForm",
                "check": true,
                "firstLoad": true,
                "pageRow": "5",
                "gridNaviId"   : "gridPagingLayer",
                "postScript"   : function (){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel", "type": "D", "qKey":"prod.deleteItemInfo", "targetURI":"/common/deleteList.do"}
                ]
            });
            
            //저장
	        $('#btnSave').on('click', function(event) {
	        	if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                    return;
                }
	        	
	        	$.comm.sendForm("/prod/saveItemInfo.do", "detailForm", fn_callback, "회원정보 저장", null, null, 
	        						{"MALL_ID": $.trim($("#MALL_ID").html()), "MALL_ITEM_NO": $.trim($("#MALL_ITEM_NO").html())});
	
		    });
            
	        singleFileUtil = new FileUtil({
                "id"				: "file",
                "addBtnId"			: "btnUpload",
                "extNames"			: ["xls", "xlsx"],
                "successCallback" : function (data) {
                	gridWrapper.requestToServer(); 
                	if(data["msg"]) {
                		alert(data["msg"]);
                	}
                },
                "postService"		: "prodService.uploadItemInfoExcel"
            });
		    
            
        });

        // 상세정보 조회
        function fn_detail(index) {
            var data = gridWrapper.getRowData(index);
            if(data) {
            	 $.comm.send("/common/select.do", {"qKey": "prod.selectItem", "MALL_ID": data.MALL_ID, "BIZ_NO": data.BIZ_NO, "MALL_ITEM_NO": data.MALL_ITEM_NO},
                         function (data, status) {
                             $.comm.bindData(data.data);
                            
                         },
                         "상품정보 상세조회"
                  );
            } else {
            	$('div.title_frame input[type=text]').each(function(index) { 
                	$(this).val("");
                });
            	$("#MALL_ID").html("");
            	$("#MALL_ITEM_NO").html("");
            }
        }
        
        var fn_callback = function (data) {
        	if(data) {
        		 $.comm.send("/common/select.do", {"qKey": "prod.selectItem", "MALL_ID": $.trim($("#MALL_ID").html()), "BIZ_NO": $("#BIZ_NO").val(), "MALL_ITEM_NO": $.trim($("#MALL_ITEM_NO").html())},
                         function (data, status) {
                             $.comm.bindData(data.data);
                            
                         },
                         "상품정보 상세조회"
                  );
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
	                <ul class="search_sectionC">
	                	<li>
	                        <label for="SEARCH_COL" class="search_title">검색기준항목</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
	                            <option value="MALL_ITEM_NO">몰상품번호</option>
	                            <option value="BRAND_NM">상품명</option>
	                            <option value="HS_CD">HS코드</option>
	                        </select>
	                        <input type="text" name="SEARCH_TXT" id="SEARCH_TXT" class="search_input"/>
	                    </li>
	                    <li>
	                        <label for="S_REGIST_METHOD" class="search_title">등록구분</label>
	                        <select id="S_REGIST_METHOD" name="S_REGIST_METHOD" class="search_input_select">
	                        	<option value="" selected="selected">전체</option>
	                            <option value="API">표준API</option>
	                            <option value="FAPI">해외API</option>
	                            <option value="EXCEL">엑셀</option>
	                        </select>
	                    </li>
	                    <li>
	                        <label for="F_REG_DTM" class="search_title">등록일자</label>
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
	                        <label for="S_MALL_ID" class="search_title">몰명</label>
	                        <input type="text" id="S_MALL_ID" name="S_MALL_ID" class="search_input inputHeight"/>
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" name="btnSearch" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div>

        <div class="list_typeA">
            <div class="util_frame">
                <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
                <input type="hidden" id="FILE_SN" name="FILE_SN" />
                <a href="<c:url value="/form/ItemInfo.xlsx"/>" class="btn white_173">표준 엑셀폼 다운로드</a>
                <a href="#" class="btn white_100" id="btnDel">삭제</a>
                <a href="#" class="btn white_100" id="btnUpload">엑셀 업로드</a>
            </div>
            <div id="gridLayer" style="height: 185px">
            </div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
        <form id="detailForm" name="detailForm" method="post">
        <input type="hidden" name="BIZ_NO" id="BIZ_NO" /> 
        <div class="title_frame">
			<p><a href="#" class="btnToggle_table">상세정보</a></p>
			<div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
	        	<div class="title_btn_inner">
		            <a href="#" class="title_frame_btn" id="btnSave">저장</a>
	            </div>
            </div>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;" >
	                <caption class="blind">상세정보</caption>
	                <colgroup>
	                    <col width="10%" />
	                    <col width="15%" />
	                    <col width="10%" />
	                    <col width="15%" />
	                    <col width="13%" />
	                    <col width="15%" />
	                    <col width="10%" />
	                    <col width="12%" />
	                </colgroup>
	                <tr>
	                    <td><label for="MALL_ID">몰명</label></td>
	                    <td><span id="MALL_ID"></span></td>
	                    <td><label for="MALL_ITEM_NO">몰상품번호</label></td>
	                    <td><span id="MALL_ITEM_NO"></span></td>
	                    <td><label for="ITEM_NM">상품명(영문)</label></td>
	                    <td><input type="text" name="ITEM_NM" id="ITEM_NM" class="td_input" <attr:length value='50'/> <attr:alphaOnly/>></td>
	                     <td><label for="HS_CD">HS코드(숫자)</label></td>
	                    <td><input type="text" name="HS_CD" id="HS_CD" class="td_input" <attr:length value='10'/> <attr:numberOnly/>></td>
	                </tr>
	                <tr>
	                    <td><label for="BRAND_NM">상표명(영문)</label></td>
	                    <td><input type="text" name="BRAND_NM" id="BRAND_NM" class="td_input" <attr:length value='30'/> <attr:alphaOnly/>></td>
	                    <td><label for="ORG_NAT_CD">원산지 국가코드</label></td>
	                    <td><input type="text" name="ORG_NAT_CD" id="ORG_NAT_CD" class="td_input" <attr:length value='3'/> <attr:alphaOnly/>></td>
	                    <td><label for="WEIGHT">중량</label></td>
	                    <td><input type="text" name="WEIGHT" id="WEIGHT" class="td_input" <attr:length value='30'/> <attr:numberOnly/>></td>
	                    <td><label for="WEIGHT_UT">중량단위</label></td>
	                    <td><input type="text" name="WEIGHT_UT" id="WEIGHT_UT" class="td_input" <attr:length value='3'/> ></td>
	                </tr>
	                <tr>
	                    <td><label for="QUANTY_UT">수량단위</label></td>
	                    <td><input type="text" name="QUANTY_UT" id="QUANTY_UT" class="td_input" <attr:length value='3'/> ></td>
	                    <td><label for="CATEGORY1">카테고리1</label></td>
	                    <td><input type="text" name="CATEGORY1" id="CATEGORY1" class="td_input" <attr:length value='100'/> ></td>
	                    <td><label for="CATEGORY2">카테고리2</label></td>
	                    <td><input type="text" name="CATEGORY2" id="CATEGORY2" class="td_input" <attr:length value='100'/> ></td>
	                    <td><label for="CATEGORY3">카테고리3</label></td>
	                    <td><input type="text" name="CATEGORY3" id="CATEGORY3" class="td_input" <attr:length value='100'/> ></td>
	                </tr>
	                <tr>
	                    <td><label for="MAKER_NM">제조자</label></td>
	                    <td colspan="3"><input type="text" name="MAKER_NM" id="MAKER_NM" class="td_input" <attr:length value='28'/> ></td>
	                    <td><label for="MAKER_TGNO">제조자통관고유부호</label></td>
	                    <td><input type="text" name="MAKER_TGNO" id="MAKER_TGNO" class="td_input" <attr:length value='15'/> ></td>
	                    <td><label for="MAKER_POST_NO">제조자우편번호</label></td>
	                    <td><input type="text" name="MAKER_POST_NO" id="MAKER_POST_NO" class="td_input" <attr:length value='5'/> ></td>
	                </tr>
	                <tr>
	                    <td><label for="GNM">규격</label></td>
	                    <td colspan="7"><input type="text" name="GNM" id="GNM" class="td_input" <attr:length value='500'/> ></td>
	                </tr>
	                <tr>
	                    <td><label for="INGREDIENTS">성분</label></td>
	                    <td><input type="text" name="INGREDIENTS" id="INGREDIENTS" class="td_input" <attr:length value='70'/> ></td>
	                    <td><label for="ITEM_VIEW_URL">상품URL</label></td>
	                    <td><input type="text" name="ITEM_VIEW_URL" id="ITEM_VIEW_URL" class="td_input" <attr:length value='500'/> ></td>
	                    <td><label for="SPEC_DETAIL">상세스팩</label></td>
	                    <td colspan="3"><input type="text" name="SPEC_DETAIL" id="SPEC_DETAIL" class="td_input" <attr:length value='500'/> ></td>
	                </tr>
	            </table>
            </div><!-- //table_typeA 3단구조 -->
        </div><!-- //title_frame -->
        </form>
    </div> <%-- padding_box --%>
</div> <%-- inner-box --%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
