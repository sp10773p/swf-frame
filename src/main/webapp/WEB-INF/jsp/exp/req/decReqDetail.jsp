<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 수출신고요청 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    	var gridWrapper, headers;
        $(function (){
        	//초기화
        	init();
        	
        	gridInit();
            
            // 목록 btn
            $('#btnList').on("click", function (e) {
                $.comm.forward("exp/req/decReqList",{});
            });
            
         	// 오류정보보기 btn
            $('#btnShowErr').on("click", function (e) {
            	fn_errPopup();
            });
            
            fn_controll();
            
            $('#btn_down').on("click", function (e) {
            	$.comm.fileDownload({"REQ_NO" : "${REQ_NO}"}, "수출신고 의뢰파일다운로드", "/dec/downloadExpReq.do");
            });
        });
        
        function init(){
        	var param = {
                "qKey"    : "req.selectDecReqDetail",
                "REQ_NO"  : "${REQ_NO}",
                "DOC_ID"  : "수출신고",
                "TABLE_NM" : "EXP_CUSDEC830"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
                    $.comm.bindData(data.data);
		            gridWrapper.requestToServer();
                },
                "수출신고요청 상세조회"
            );
        }
        
        function gridInit(){
        	headers = [
				{"HEAD_TEXT": "순번"        		, "WIDTH": "40"   , "FIELD_NAME": "SN"},
                {"HEAD_TEXT": "원산지"       		, "WIDTH": "50"   , "FIELD_NAME": "ORIGINLOCID"},
                {"HEAD_TEXT": "HS부호"       	, "WIDTH": "100"  , "FIELD_NAME": "CLASSIDHSID"},
                {"HEAD_TEXT": "거래품명"    		, "WIDTH": "200"  , "FIELD_NAME": "ITEMNAME_EN" , "ALIGN":"left"},
                {"HEAD_TEXT": "중량"      		, "WIDTH": "80"  , "FIELD_NAME": "NETWEIGHTMEASURE" , "ALIGN":"right"},
                {"HEAD_TEXT": "수량"       		, "WIDTH": "80"  , "FIELD_NAME": "LINEITEMQUANTITY" , "ALIGN":"right"},
                {"HEAD_TEXT": "수량단위"       	, "WIDTH": "100"  , "FIELD_NAME": "LINEITEMQUANTITY_UC"},
                {"HEAD_TEXT": "포장수"    		, "WIDTH": "80"   , "FIELD_NAME": "PACKAGINGQUANTITY" , "ALIGN":"right"},
                {"HEAD_TEXT": "포장단위"    		, "WIDTH": "80"   , "FIELD_NAME": "PACKAGINGQUANTITY_UC"},
                {"HEAD_TEXT": "통화"    			, "WIDTH": "80"   , "FIELD_NAME": "DECLARATIONAMOUNT_CUR"},
                {"HEAD_TEXT": "단가"    			, "WIDTH": "80"   , "FIELD_NAME": "BASEPRICEAMT" , "ALIGN":"right"},
                {"HEAD_TEXT": "가격"    			, "WIDTH": "80"   , "FIELD_NAME": "DECLARATIONAMOUNT" , "ALIGN":"right"},
                {"HEAD_TEXT": "몰상품코드"    	, "WIDTH": "120"   , "FIELD_NAME": "MALL_ITEM_NO" , "ALIGN":"left"},
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "수출신고요청 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "req.selectDecReqItemList",
                "headers"      : headers,
                //"paramsFormId" : "detailForm",
                "paramsGetter" : {"REQ_NO":"${REQ_NO}"},
                "gridNaviId"   : "",
                "firstLoad"    : false,
                "controllers"  : []
            });
        }
        
        function fn_controll(){
        	$.comm.disabled("REQ_NO", true);
        	$.comm.disabled("STATUS_NM", true);
        	$.comm.disabled("ORDER_ID", true);
        	$.comm.disabled("RPT_NO", true);
        	$.comm.disabled("SELLER_ID", true);
        	$.comm.disabled("EXPORTERCLASSCODE_NM", true);
        	$.comm.disabled("RECE_NM", true);
        	$.comm.disabled("BUYERPARTYORGNAME", true);
        	$.comm.disabled("DELIVERY_CHECK", true);
        	$.comm.disabled("DELIVERY_METHOD", true);
        	$.comm.disabled("MANUPARTYORGNAME", true);
        	$.comm.disabled("MANUPARTYORGID", true);
        	$.comm.disabled("MANUPARTYLOCID", true);
        	$.comm.disabled("GOODSLOCATIONID2 ", true);
        	$.comm.disabled("EOCPARTYORGNAME2", true);
        	$.comm.disabled("EOCPARTYORGCEONAME", true);
        	$.comm.disabled("EOCPARTYPARTYIDID1", true);
        	$.comm.disabled("EOCPARTYADDRLINE", true);
        	$.comm.disabled("EOCPARTYPARTYIDID2", true);
        	$.comm.disabled("GOODSLOCATIONID1", true);
        	$.comm.disabled("APPLICANTPARTYORGID", true);
        	$.comm.disabled("CUSTOMORGANIZATIONID", true);
        	$.comm.disabled("CUSTOMDEPARTMENTID", true);
        	$.comm.disabled("SIMPLEDRAWAPPINDICATOR", true);
        	$.comm.disabled("PAYMENTTERMSTYPECODE", true);
        	$.comm.disabled("DESTINATIONCOUNTRYCODE", true);
        	$.comm.disabled("LODINGLOCATIONID", true);
        	$.comm.disabled("LODINGLOCATIONTYPECODE", true);
        	$.comm.disabled("TRANSPORTMEANSCODE_NM", true);
        	$.comm.disabled("SUMMARY_TOTALQUANTITY", true);
        	$.comm.disabled("SUMMARY_TOTALQUANTITY_UC", true);
        	$.comm.disabled("SUMMARY_TOTALWEIGHT", true);
        	$.comm.disabled("SUMMARY_TOTALWEIGHT_UC", true);
        	$.comm.disabled("DELIVERYTERMSCODE", true);
        	$.comm.disabled("PAYMENTAMOUNT_CUR", true);
        	$.comm.disabled("PAYMENTAMOUNT", true);
        	$.comm.disabled("GOODSLOCATIONID1_1", true);
        	$.comm.disabled("GOODSLOCATIONNAME", true);
        	$.comm.disabled("RPT_MARK", true);

        }
        
        function fn_errPopup(){
        	$.comm.setModalArguments({"ERROR_DESC":$("#ERROR_DESC").val()});
        	var spec = "width:800px;height:600px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호출
            $.comm.dialog("<c:out value='/jspView.do?jsp=exp/req/decReqErrPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    }
                }
            );
      		
      	}
        
    </script>
</head>
<body>
<div class="inner-box">
    <form id="detailForm" name="detailForm" method="post">
    <div class="padding_box">
    	<div class="title_frame">
    		<div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
				<div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btnList">목록</a>
                    <a href="#" class="title_frame_btn" id="btn_down">의뢰파일다운로드</a>
		            <input type="hidden" name="ERROR_DESC" id="ERROR_DESC" value="${ERROR_DESC}">
				</div>
			</div>
			<p><a href="#" class="btnToggle_table">상세정보</a></p>
            	<div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                        <col width="13%" />
                        <col width="20%" />
                    </colgroup>
                        <tr>
                            <td><label for="REQ_NO">요청관리번호</label></td>
                            <td><input type="text" name="REQ_NO" id="REQ_NO"></td>
                            <td><label for="STATUS">상태</label></td>
                            <td>
                            	<input type="hidden" name="STATUS" id="STATUS">
                            	<input type="text" name="STATUS_NM" id="STATUS_NM" style="width: 50% !important">
                            	<c:if test="${STATUS eq '04'}">
                            		<a href="#" class="btn_table" style="margin-left: 0px;" id="btnShowErr">오류정보보기</a>
                            	</c:if> 
                            </td>
                            <td><label for="ORDER_ID">주문번호</label></td>
                            <td><input type="text" name="ORDER_ID" id="ORDER_ID"></td>
                        </tr>
                        <tr>
                            <td><label for="RPT_NO">수출신고번호</label></td>
                            <td><input type="text" name="RPT_NO" id="RPT_NO"></td>
                            <td><label for="EXPORTERCLASSCODE">수출자구분</label></td>
                            <td colspan="3">
                            	<input type="hidden" name="EXPORTERCLASSCODE" id="EXPORTERCLASSCODE">
                            	<input type="text" name="EXPORTERCLASSCODE_NM" id="EXPORTERCLASSCODE_NM">
                            </td>
                            
                        </tr>
                        <tr>
                            <td><label for="RECE">수출신고상태</label></td>
                            <td>
                            	<input type="hidden" name="RECE" id="RECE">
                            	<input type="text" name="RECE_NM" id="RECE_NM">
                            </td>
                            <td><label for="DELIVERY_CHECK">배송구분</label></td>
                            <td><input type="text" name="DELIVERY_CHECK" id="DELIVERY_CHECK"></td>
                            <td><label for="DELIVERY_METHOD">배송방법</label></td>
                            <td><input type="text" name="DELIVERY_METHOD" id="DELIVERY_METHOD"></td>
                        </tr>
                        <tr>
                            <td><label for="BUYERPARTYORGNAME">구매자상호</label></td>
                            <td><input type="text" name="BUYERPARTYORGNAME" id="BUYERPARTYORGNAME"></td>
                        	<td><label for="SELLER_ID">판매자ID</label></td>
                            <td><input type="text" name="SELLER_ID" id="SELLER_ID"></td>
                        	<td><label for="RPT_MARK">의뢰관세사부호</label></td>
                            <td><input type="text" name="RPT_MARK" id="RPT_MARK"></td>
                        </tr>
                	</table>
               	</div><!-- //table_typeA 3단구조 -->
            </div><!-- //title_frame -->
            
            <div class="title_frame">
				<p><a href="#" class="btnToggle_table">제조자정보</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">제조자정보</caption>
						<colgroup>
							<col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
						</colgroup>
						<tr>
                            <td><label for="MANUPARTYORGNAME">제조자상호명</label></td>
                            <td><input type="text" name="MANUPARTYORGNAME" id="MANUPARTYORGNAME"></td>
                            <td><label for="MANUPARTYORGID">제조자통관고유부호</label></td>
                            <td><input type="text" name="MANUPARTYORGID" id="MANUPARTYORGID"></td>
                            <td>
                            	<label>제조자우편번호/산업단지부호</label>
                            	<label for="MANUPARTYLOCID" style="display: none;">제조자우편번호</label>
                            	<label for="GOODSLOCATIONID2" style="display: none;">산업단지부호</label>
                            </td>
                            <td>
                            	<input type="text" name="MANUPARTYLOCID" id="MANUPARTYLOCID" style="width: 40% !important">
                            	<input type="text" name="GOODSLOCATIONID2" id="GOODSLOCATIONID2" style="width: 40% !important">
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">판매자정보</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">판매자정보</caption>
						<colgroup>
							<col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
						</colgroup>
						<tr>
                            <td><label for="EOCPARTYORGNAME2">상호</label></td>
                            <td><input type="text" name="EOCPARTYORGNAME2" id="EOCPARTYORGNAME2"></td>
                            <td><label for="EOCPARTYORGCEONAME">대표자명</label></td>
                            <td><input type="text" name="EOCPARTYORGCEONAME" id="EOCPARTYORGCEONAME"></td>
                            <td><label for="EOCPARTYPARTYIDID1">사업자등록번호</label></td>
                            <td><input type="text" name="EOCPARTYPARTYIDID1" id="EOCPARTYPARTYIDID1"></td>
                        </tr>
                        <tr>
                            <td><label for="EOCPARTYADDRLINE">주소</label></td>
                            <td><input type="text" name="EOCPARTYADDRLINE" id="EOCPARTYADDRLINE"></td>
                            <td><label for="EOCPARTYPARTYIDID2">통관고유부호</label></td>
                            <td><input type="text" name="EOCPARTYPARTYIDID2" id="EOCPARTYPARTYIDID2"></td>
                            <td>
                            	<label>우편부호/신고인부호</label>
                            	<label for="GOODSLOCATIONID1" style="display: none;">우편부호</label>
                            	<label for="APPLICANTPARTYORGID" style="display: none;">신고인부호</label>
                            </td>
                            <td>
                            	<input type="text" name="GOODSLOCATIONID1" id="GOODSLOCATIONID1" style="width: 40% !important">
                            	<input type="text" name="APPLICANTPARTYORGID" id="APPLICANTPARTYORGID" style="width: 40% !important">
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">신고정보</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">신고정보</caption>
						<colgroup>
							<col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
	                        <col width="13%" />
	                        <col width="20%" />
						</colgroup>
						<tr>
                            <td>
                            	<label>세관-과</label>
                            	<label for="CUSTOMORGANIZATIONID" style="display: none;">세관</label>
                            	<label for="CUSTOMDEPARTMENTID" style="display: none;">과</label>
                            </td>
                            <td>
                            	<input type="text" name="CUSTOMORGANIZATIONID" id="CUSTOMORGANIZATIONID" style="width: 40% !important">
                            	<input type="text" name="CUSTOMDEPARTMENTID" id="CUSTOMDEPARTMENTID" style="width: 40% !important">
                            </td>
                            <td><label for="SIMPLEDRAWAPPINDICATOR">간이환급신청여부</label></td>
                            <td><input type="text" name="SIMPLEDRAWAPPINDICATOR" id="SIMPLEDRAWAPPINDICATOR" style="width: 40% !important"></td>
                            <td><label for="PAYMENTTERMSTYPECODE">결제방법코드</label></td>
                            <td><input type="text" name="PAYMENTTERMSTYPECODE" id="PAYMENTTERMSTYPECODE" style="width: 40% !important"></td>
                        </tr>
                        <tr>
                            <td><label for="DESTINATIONCOUNTRYCODE">목적국국가코드</label></td>
                            <td><input type="text" name="DESTINATIONCOUNTRYCODE" id="DESTINATIONCOUNTRYCODE" style="width: 40% !important"></td>
                            <td><label for="LODINGLOCATIONID">적재항코드</label></td>
                            <td><input type="text" name="LODINGLOCATIONID" id="LODINGLOCATIONID" style="width: 40% !important"></td>
                            <td>
                            	<label for="LODINGLOCATIONTYPECODE">적재항종류</label>
                            </td>
                            <td>
                            	<input type="text" name="LODINGLOCATIONTYPECODE" id="LODINGLOCATIONTYPECODE">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label>총포장개수/단위</label>
                            	<label for="SUMMARY_TOTALQUANTITY" style="display: none;">총포장개수</label>
                            	<label for="SUMMARY_TOTALQUANTITY_UC" style="display: none;">단위</label>
                            </td>
                            <td>
                            	<input type="text" name="SUMMARY_TOTALQUANTITY" id="SUMMARY_TOTALQUANTITY" style="width: 40% !important">
                            	<input type="text" name="SUMMARY_TOTALQUANTITY_UC" id="SUMMARY_TOTALQUANTITY_UC" style="width: 30% !important">
                            </td>
                            <td>
                            	<label>중량합계/단위</label>
                            	<label for="SUMMARY_TOTALWEIGHT" style="display: none;">중량합계</label>
                            	<label for="SUMMARY_TOTALWEIGHT_UC" style="display: none;">중량단위</label>
                            </td>
                            <td>
                            	<input type="text" name="SUMMARY_TOTALWEIGHT" id="SUMMARY_TOTALWEIGHT" style="width: 40% !important">
                            	<input type="text" name="SUMMARY_TOTALWEIGHT_UC" id="SUMMARY_TOTALWEIGHT_UC" style="width: 30% !important">
                            </td>
                            <td>
                            	<label for="TRANSPORTMEANSCODE">주운송수단</label>
                            </td>
                            <td>
                            	<input type="hidden" name="TRANSPORTMEANSCODE" id="TRANSPORTMEANSCODE">
                            	<input type="text" name="TRANSPORTMEANSCODE_NM" id="TRANSPORTMEANSCODE_NM">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label for="DELIVERYTERMSCODE">인도조건</label>
                            </td>
                            <td>
                            	<input type="text" name="DELIVERYTERMSCODE" id="DELIVERYTERMSCODE">
                            </td>
                            <td>
                            	<label for="PAYMENTAMOUNT_CUR">통화단위</label>
                            </td>
                            <td>
                            	<input type="text" name="PAYMENTAMOUNT_CUR" id="PAYMENTAMOUNT_CUR">
                            </td>
                            <td>
                            	<label for="PAYMENTAMOUNT">결제금액</label>
                            </td>
                            <td>
                            	<input type="text" name="PAYMENTAMOUNT" id="PAYMENTAMOUNT">
                            </td>
                        
                        </tr>
                        <tr>
                            <td>
                            	<label>물품소재지 우편번호/주소</label>
                            	<label for="GOODSLOCATIONID1_1" style="display: none;">물품소재지 우편번호</label>
                            	<label for="GOODSLOCATIONNAME" style="display: none;">물품소재지 주소</label>
                            </td>
                            <td colspan="5">
                            	<input type="text" name="GOODSLOCATIONID1_1" id="GOODSLOCATIONID1_1" style="width: 10% !important">
                            	<input type="text" name="GOODSLOCATIONNAME" id="GOODSLOCATIONNAME" style="width: 80% !important">
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->	
         	
         	<div class="title_frame">
            	<div class="title_btn_frame clearfix">
                	<p><a href="#" class="btnToggle_table">수출신고 요청상품</a></p>
            	</div>
	            <div id="gridLayer" style="height: 214px;"></div>   
            </div>
                                                 
        </div><%-- // padding_box--%>
    </form>
</div><%-- // inner-box--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
