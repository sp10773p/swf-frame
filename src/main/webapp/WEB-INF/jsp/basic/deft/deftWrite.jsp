<%--
    Class Name : deftWrite.jsp
    Description : 신고서 기본값 관리
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.02  정안균   최초 생성

    author : 정안균
    since : 2017.03.02
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script type="text/javascript" src="<c:url value='/js/jquery.leanModal.min.js'/>"></script>
    <script>
        $(function (){
            fn_setCombo();

            fn_selectDetailInfo();
            
           	//우편번호 검색
	        $('#btnZipSearch').on('click', function(event) {
	        	var spec = "windowname:deftBtnZipSearch;width:800px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
	            // 모달 호츨
	            $.comm.dialog("<c:out value='/jspView.do?jsp=cmm/popup/zipPopup' />", spec,
	                function () { // 리턴받을 callback 함수
	                    var ret = $.comm.getModalReturnVal();
	                    if (ret) {
	                    	$('#ZIP_CD').val(ret.ZIP_CD);   // 우편번호
	                        $('#ADDRESS').val(ret.NAME_KR); // 주소 
	                    }
	                }
	            );
		    });
           
	      	//물품소재지 우편번호 검색
	        $('#btnGoodsZipSearch').on('click', function(event) {
	        	var spec = "windowname:deftBtnGoodsZipSearch;width:800px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
	            // 모달 호츨
	            $.comm.dialog("<c:out value='/jspView.do?jsp=cmm/popup/zipPopup' />", spec,
	                function () { // 리턴받을 callback 함수
	                    var ret = $.comm.getModalReturnVal();
	                    if (ret) {
	                    	$('#GOODSLOCATIONID1').val(ret.ZIP_CD);   // 우편번호
	                        $('#GOODSLOCATIONNAME').val(ret.NAME_KR); // 주소 
	                      
	                        var param = {
		                  	 	"qKey"    : "deft.selectPostCusInfo",
		                        "POST_NO" : ret.ZIP_CD
		                    };
		                    var selectCallback = function(data, status){
		                    	var result = data.data;
		                        if(result) {
		                        	$('#CUSTOMORGANIZATIONID').val(result.CUS); //세관코드
		                        	$('#CUSTOMDEPARTMENTID').val(result.SEC);   //세관과 코드
		                        }
		                     };
		                     $.comm.send("/common/select.do", param, selectCallback, "우편번호세관부호연계 조회");
		                     
	                    }
	                }
	            );
		    });
	      	
	      	//특송사 검색
	        $('#btnExpUsrSearch').on('click', function(event) {
	        	var spec = "windowname:deftBtnExpUsrSearch;width:800px;height:800px;scroll:auto;status:no;center:yes;resizable:yes;";
	        	$.comm.setModalArguments({"USER_DIV" : 'E'}); // 모달 팝업에 전달할 인자 지정
	            // 모달 호츨
	            $.comm.dialog("<c:out value='/jspView.do?jsp=basic/deft/deftUsrListPopup' />", spec,
	                function () { // 리턴받을 callback 함수
	                    var ret = $.comm.getModalReturnVal();
	                    if (ret) {
	                    	$('#MAINEXPRESSNAME').val(ret.USER_NM);   
	                    	$('#MAINEXPRESSCODE').val(ret.BIZ_NO);   
	                    }
	                }
	            );
		    });
	      	
	        $('#btnExpUsrDelete').on('click', function(event) {
	            $("#MAINEXPRESSNAME").val("");
	            $("#MAINEXPRESSCODE").val("");
	        });
	      	
	      	//관세사 검색
	        $('#btnCusUsrSearch').on('click', function(event) {
	        	var spec = "windowname:deftBtnCusUsrSearch;width:800px;height:800px;scroll:auto;status:no;center:yes;resizable:yes;";
	        	$.comm.setModalArguments({"USER_DIV" : 'G'}); // 모달 팝업에 전달할 인자 지정
	            // 모달 호츨
	            $.comm.dialog("<c:out value='/jspView.do?jsp=basic/deft/deftUsrListPopup' />", spec,
	                function () { // 리턴받을 callback 함수
	                    var ret = $.comm.getModalReturnVal();
	                    if (ret) {
	                    	$('#MAINCUSUSERNAME').val(ret.USER_NM);   
	                    	$('#MAINCUSUSERCODE').val(ret.BIZ_NO);   
	                    }
	                }
	            );
		    });
	      	
	        $('#btnCusUsrDelete').on('click', function(event) {
	            $("#MAINCUSUSERNAME").val("");
	            $("#MAINCUSUSERCODE").val("");
	        });
            
            $('#btnSave').on("click", function (e) {
            	if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                    return;
                }
            	
            	var regEx = /^([가-힣]{2}[*]{4}|[가-힣]{3}[*]{2}|[가-힣]{4})([a-zA-Z0-9]{7})/gi;
				if(!regEx.test($('#TG_NO').val())) {
					alert("유효하지 않은 통관고유부호입니다.\n예)통관부호1234567, 통관****1234567, 무역업**1234567");
					return false;
				}
				
            	$.comm.sendForm("/deft/saveBaseVal.do", "detailForm", fn_callback, "신고서 기본값 상세 저장");
            })
            
            $.comm.disabled(["CUSTOMORGANIZATIONID", "CUSTOMDEPARTMENTID"], true);
        });	
        
        var fn_callback = function (data) {
        	if(data) {
        		fn_selectDetailInfo();
        	}
        }
        
        function fn_setCombo(){
        	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
        	$.comm.bindCombos.addComboInfo("CUSTOMORGANIZATIONID","CUS0015", true, null, null, null, 3);	//세관코드
        	$.comm.bindCombos.addComboInfo("CUSTOMDEPARTMENTID","CUS0004", true, null, null, null, 3);		//과코드
        	$.comm.bindCombos.addComboInfo("LODINGLOCATIONID","CUS0046", true, null, null, null, 3);		//적재항
        	$.comm.bindCombos.addComboInfo("PAYMENTTERMSTYPECODE", "CUS0003", true, null, null, null, 3);	//결제방법코드
        	$.comm.bindCombos.addComboInfo("DRAWBACKROLE", "CUS0048", true, null, null, null, 3);			//환급신청인
        	$.comm.bindCombos.addComboInfo("DELIVERYTERMSCODE", "CUS0038", true, null, null, null, 3);		//인도조건
        	$.comm.bindCombos.draw();
        }
        
        function fn_selectDetailInfo() {
        	 var selectCallback = function(data, status){
                	var result = data.data;
                	if(result) {
                		var userInfoList = result["USER_INFO"];
                		var userInfo = userInfoList[0];
                		$.comm.bindData(userInfo);
                		if(userInfo && userInfo["AUTO_SEND_YN"] == 'Y') {
                			$("#AUTO_SEND_YN").prop('checked', true);
                		} else {
                			$("#AUTO_SEND_YN").prop('checked', false);
                		}
                		var baseSellerList = result["BASE_SELLER_INFO"];
                		for(var i in baseSellerList) {
                			var docItem = baseSellerList[i]['DOC_ITEM'];
                			if(docItem) {
                				var eleId = docItem.toUpperCase();
                				var eleVal = baseSellerList[i]['BASE_VAL'];
                				$('#' + eleId).val(eleVal);
                				if(eleId == 'EXPORTERCLASSCODE' || eleId == 'INSPECTIONCODE' || eleId == 'TRANSPORTMEANSCODE') {
                					$('input:radio[name=' + eleId + ']').each(function() {
 	                                if(this.value == eleVal){
 	                                    this.checked = true;
 	                                }
 	                        	});
                				}
               			}
                		}
                		
                	}
             };
             $.comm.send("/deft/selectBaseVal.do", {}, selectCallback, "신고서 기본값 상세조회");
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
	                <a href="#" class="title_frame_btn" id="btnSave">저장</a>
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">판매자 신고정보</a></p>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">판매자 신고정보</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="85%" />
	                </colgroup>
	                <tr>
	                    <td><label for="AUTO_SEND_YN">신고 구분</label></td>
	                    <td>
	                    	<input type="checkbox" name="AUTO_SEND_YN" id="AUTO_SEND_YN" value='Y' <attr:mandantory/>/><label for="AUTO_SEND"><span></span>자동신고</label>
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="BIZ_NO">사업자등록번호</label></td>
	                    <td>
	                    	<input type="text" name="BIZ_NO" id="BIZ_NO" <attr:mandantory/> <attr:length value='10'/> class="td_input readonly" readonly>
                  			<input type="hidden" name="MODE" id="MODE" />
                  			<input type="hidden" name="REG_ID" id="REG_ID" />
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="USER_NM">판매자명</label></td>
	                    <td><input type="text" name="USER_NM" id="USER_NM" <attr:mandantory/> <attr:length value='30'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="REP_NM">대표자명</label></td>
	                    <td><input type="text" name="REP_NM" id="REP_NM" <attr:mandantory/> <attr:length value='12'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="TG_NO">통관고유부호</label></td>
	                    <td><input type="text" name="TG_NO" id="TG_NO" <attr:mandantory/> <attr:length value='15,15'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="APPLICANT_ID">신고인부호</label></td>
	                    <td><input type="text" name="APPLICANT_ID" id="APPLICANT_ID" <attr:mandantory/> <attr:length value='5'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="ZIP_CD">우편번호</label></td>
	                    <td>
	                    	<input type="text" name="ZIP_CD" id="ZIP_CD" class="td_input readonly" style="width: 10% !important" <attr:mandantory/> <attr:length value='5'/> readonly />  
		                	<a href="#" id="btnZipSearch" style="margin-left: 0px;" class="btn_table">우편번호 검색</a>
		               	</td>
	                </tr>
	                <tr>
	                    <td><label for="ADDRESS">주소</label></td>
	                    <td>
	                    	<input type="text" name="ADDRESS" id="ADDRESS" class="input readonly" readonly  style="width: 45% !important" /> <input type="text" name="ADDRESS2" id="ADDRESS2" <attr:mandantory/> <attr:length value='100'/>  style="width: 52% !important" /> 
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="IDENTIFY_ID">식별자</label></td>
	                    <td>관세사:<input type="text" name="CUS_IDENTIFY_ID" id="CUS_IDENTIFY_ID" <attr:length value='30'/> class="td_input readonly" readonly style="width: 28% !important">&nbsp;
	                        구매확인서:<input type="text" name="PUR_IDENTIFY_ID" id="PUR_IDENTIFY_ID" <attr:length value='30'/> class="td_input readonly" readonly style="width: 28% !important">(KTNET에서 부여 받은 고유키)</td>
	                </tr>
	                <tr>
	                    <td><label for="REG_MALL_ID">몰ID</label></td>
	                    <td><input type="text" name="REG_MALL_ID" id="REG_MALL_ID" <attr:length value='30'/> class="td_input" style="width: 69% !important">(API 제공값)</td>
	                </tr>
	            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">신고서 기본값 정보 관리</a></p>
            <div style="font-size:12px;font-family:Arial;">* 신고서 기본값에 대해 반드시 등록해주시기 바랍니다. </div>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">신고서 기본값 정보 관리</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="85%" />
	                </colgroup>
	                <tr>
	                    <td><label for="GOODSLOCATIONID1">물품소재지 우편번호</label></td>
	                    <td>
	                    	<input type="text" name="GOODSLOCATIONID1" id="GOODSLOCATIONID1" class="td_input readonly" style="width: 10% !important" <attr:mandantory/> <attr:length value='5'/> readonly />  
		                	<a href="#" id="btnGoodsZipSearch" class="btn_table" style="margin-left: 0px;">우편번호 검색</a>
		                </td>
	                </tr>
	                <tr>
	                    <td><label for="GOODSLOCATIONNAME">물품소재지</label></td>
	                    <td><input type="text" name="GOODSLOCATIONNAME" id="GOODSLOCATIONNAME" <attr:mandantory/> <attr:length value='100'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="CUSTOMORGANIZATIONID">세관코드</label></td>
	                    <td>
	                    	<select class="td_input" name="CUSTOMORGANIZATIONID" id="CUSTOMORGANIZATIONID" style="width: 15% !important" <attr:mandantory/>></select>
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="CUSTOMDEPARTMENTID">과코드</label></td>
	                    <td><select class="td_input" name="CUSTOMDEPARTMENTID" id="CUSTOMDEPARTMENTID" style="width: 15% !important" <attr:mandantory/>></select></td>
	                </tr>
	                <tr>
	                    <td><label for="LODINGLOCATIONID">적재항</label></td>
	                    <td><select class="td_input" name="LODINGLOCATIONID" id="LODINGLOCATIONID" style="width: 15% !important" <attr:mandantory/>></select></td>
	                </tr>
	                <tr>
	                    <td><label for="PAYMENTTERMSTYPECODE">결제방법코드</label></td>
	                    <td><select class="td_input" name="PAYMENTTERMSTYPECODE" id="PAYMENTTERMSTYPECODE" style="width: 30% !important" <attr:mandantory/>></select></td>
	                </tr>
	                <tr>
	                    <td><label for="EXPORTERCLASSCODE_A">수출자구분</label></td>
	                    <td>
	                    	<div class="radio"> 
								<input type="radio" name="EXPORTERCLASSCODE" id="EXPORTERCLASSCODE_A" value="A" checked="checked"/>
					        	<label for="EXPORTERCLASSCODE_A"><span></span>A</label>
							</div>
							<div class="radio"> 
								<input type="radio" name="EXPORTERCLASSCODE" id="EXPORTERCLASSCODE_B" value="B" />
					        	<label for="EXPORTERCLASSCODE_B"><span></span>B</label>
							</div>   
							<div class="radio"> 
								<input type="radio" name="EXPORTERCLASSCODE" id="EXPORTERCLASSCODE_C" value="C" />
					        	<label for="EXPORTERCLASSCODE_C"><span></span>C(완제품판매자)</label>
							</div>       
							<div class="radio"> 
								<input type="radio" name="EXPORTERCLASSCODE" id="EXPORTERCLASSCODE_D" value="D" />
					        	<label for="EXPORTERCLASSCODE_D"><span></span>D</label>
							</div>       	
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="DRAWBACKROLE">환급신청인</label></td>
	                    <td>
	                    	<select class="td_input" name="DRAWBACKROLE" id="DRAWBACKROLE" style="width: 15% !important" <attr:mandantory/>></select>
	                    	<input type="hidden" name="SIMPLEDRAWAPPINDICATOR" id="SIMPLEDRAWAPPINDICATOR" value="NO" />
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="INSPECTIONCODE_A">검사방법선택</label></td>
	                    <td>
	                    	<div class="radio"> 
								<input type="radio" name="INSPECTIONCODE" id="INSPECTIONCODE_A" value="A" checked="checked"/>
					        	<label for="INSPECTIONCODE_A"><span></span>A(신고지)</label>
							</div>
							<div class="radio"> 
								<input type="radio" name="INSPECTIONCODE" id="INSPECTIONCODE_B" value="B" />
					        	<label for="INSPECTIONCODE_B"><span></span>B(적재지) </label>
							</div>   
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="TRANSPORTMEANSCODE">주운송수단</label></td>
	                    <td>
	                    	<div class="radio"> 
								<input type="radio" name="TRANSPORTMEANSCODE" id="TRANSPORTMEANSCODE_40" value="40" checked="checked"/>
					        	<label for="TRANSPORTMEANSCODE_40"><span></span>항공기</label>
							</div>
							<div class="radio"> 
								<input type="radio" name="TRANSPORTMEANSCODE" id="TRANSPORTMEANSCODE_10" value="10" />
					        	<label for="TRANSPORTMEANSCODE_10"><span></span>선박</label>
							</div>   
	                    </td>
	                </tr>
	                <tr>
	                    <td><label for="DELIVERYTERMSCODE">인도조건</label></td>
	                    <td><select class="td_input" name="DELIVERYTERMSCODE" id="DELIVERYTERMSCODE" style="width: 30% !important" <attr:mandantory/>></select></td>
	                </tr>
	            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">EMS 정보 관리</a></p>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">EMS 정보 관리</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="85%" />
	                </colgroup>
	                <tr>
	                    <td><label for="CUSTNO">고객번호</label></td>
	                    <td><input type="text" name="CUSTNO" id="CUSTNO" <attr:length value='10'/> class="td_input"></td>
	                </tr>
	                <tr>
	                    <td><label for="DOC_ID">계약승인번호</label></td>
	                    <td>
	                    	EMS:<input type="text" name="APPRNO1" id="APPRNO1" <attr:length value='10'/> class="td_input" style="width:20%">&nbsp;
	                    	K-Packet:<input type="text" name="APPRNO2" id="APPRNO2" <attr:length value='10'/> class="td_input" style="width:20%">&nbsp;
<!-- 	                    	한중해상특송:<input type="text" name="APPRNO3" id="APPRNO3" <attr:length value='10'/> class="td_input" style="width:20%"> -->
	                    </td>
	                </tr>
	            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">특송사 정보 관리</a></p>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">특송사 정보 관리</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="85%" />
	                </colgroup>
	                <tr>
	                    <td><label for="MAIN_EXP_NM">주거래 특송사</label></td>
	                    <td>
	                    	<input type="text" name="MAINEXPRESSNAME" id="MAINEXPRESSNAME" <attr:length value='100'/> class="td_input" style="width: 25% !important" readonly>
	                    	<input type="hidden" name="MAINEXPRESSCODE" id="MAINEXPRESSCODE">
	                    	<a href="#" id="btnExpUsrSearch" class="btn_table" style="margin-left: 0px;">특송사 검색</a>
                            <a href="#" id="btnExpUsrDelete" class="btn_table" style="margin-left: 0px;">초기화</a>
	                    </td>
	                </tr>

	            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">관세사 정보 관리</a></p>
            <div class="table_typeA gray">
	            <table style="table-layout:fixed;">
	                <caption class="blind">주거래 관세사 관리</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="85%" />
	                </colgroup>
	                <tr>
	                    <td><label for="MAIN_CUS_USER_NM">주거래 관세사</label></td>
	                    <td>
	                    	<input type="text" name="MAINCUSUSERNAME" id="MAINCUSUSERNAME" <attr:length value='100'/> class="td_input" style="width: 25% !important" readonly>
	                    	<input type="hidden" name="MAINCUSUSERCODE" id="MAINCUSUSERCODE">
	                    	<a href="#" id="btnCusUsrSearch" class="btn_table" style="margin-left: 0px;">관세사 검색</a>
                            <a href="#" id="btnCusUsrDelete" class="btn_table" style="margin-left: 0px;">초기화</a>
	                    </td>
	                </tr>

	            </table>
            </div>
        </div><!-- //title_frame -->
    </div>
    </form>
    
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
