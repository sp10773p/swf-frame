<%--
    Class Name : pcrDetail.jsp
    Description : 구매확인서 상세
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-06  정안균   최초 생성

    author : 정안균
    since : 2017-02-06
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script type="text/javascript" src="<c:url value='/js/jquery.leanModal.min.js'/>"></script>
    <script>
    	var gridViewBaseDoc, gridViewItem, gridViewTaxInvoice, headersViewBaseDoc, headersViewItem, headersViewTaxInvoice;
    	var gridEditBaseDoc, gridEditItem, gridEditTaxInvoice, headersEditBaseDoc, headersEditItem, headersEditTaxInvoice, singleFileUtil;
        $(function (){
        	if("${BTN_TYPE}" && "${BTN_TYPE}" == "NEW") { //조회화면에서 신규버튼 클릭시
        		$.comm.display(["editDiv"], true);
            	$.comm.display(["viewDiv", "btnNewCopy", "btnCopy", "btnView"], false);
            	$('.total').hide();
            	fn_initEditContents();
            	fn_getGeneralInfo();
            } else if("${BTN_TYPE}" == "LINK") { //조회화면 그리드에서 링크 클릭시
            	$.comm.display(["editDiv"], false);
            	$.comm.display(["viewDiv"], true);
            	fn_initViewContents();
            	fn_select("VIEW", "${DOC_ID}");
            } else if("${BTN_TYPE}" == "EDIT") { //조회화면 에서 수정버튼 클릭시
            	$.comm.display(["editDiv"], true);
            	$.comm.display(["viewDiv"], false);
            	fn_initEditContents();
            	fn_select("EDIT", "${DOC_ID}");
            }
            
        	$('#appInfo.btnToggle_table').click(function(e){
        		$('#appInfo > .table_toggle', this.parentNode).toggle();
        		e.preventDefault();
        	});
        	$('#appInfo.btnToggle_table').click();
            $('#btnSave').on("click", function (e) {
            	fn_save(true, "A2");
            })
            
            $('#btnNewCopy, #btnCopy').on("click", function (e) {
            	if (!confirm($.comm.getMessage("C00000034"))) { // 복사하시겠습니까?
                    return;
                }

            	$('#DOC_STAT').val("A2");
            	
            	var paramObj = $.comm.getFormData('detailForm');
            	var btnId = $(this).attr("ID");
            	if(btnId == "btnNewCopy") {
            		paramObj["COPY_TYPE"] = "N";
            	} else if(btnId == "btnCopy") {
            		paramObj["COPY_TYPE"] = "M";
            	}
                $.comm.send("/pcr/saveAllPcrLicCopyInfo.do", paramObj, fn_callbackForCopy, "구매확인서 복사");
            })
            
            $('#btnView').on("click", function (e) {
            	$.comm.display(["editDiv"], false);
            	$.comm.display(["viewDiv"], true);
            	fn_initViewContents();
            	fn_select("VIEW", "${DOC_ID}");
            })
            
            $('#btnItemSave').on("click", function (e) {
            	 if (!confirm($.comm.getMessage("C00000014"))) { // 항목저장 하시겠습니까?
                     return;
                 }

                 var modDataList = gridEditItem.getUpdateData();
                 if(!modDataList) return;
                 if(modDataList.length == 0){
                     alert($.comm.getMessage("I00000013"));// 변경된 내용이 없습니다.
                     return;
                 }
   
                 $.comm.send("/pcr/savePcrItemList.do", modDataList, fn_pcrItemCallback, "구매물품 목록 저장");
            })
            
            $('#btnBasisDocSave').on("click", function (e) {
            	var docId = $('#DOC_ID').val();
            	if(!docId || docId.indexOf("저장시 자동생성") > -1) {
            		alert("저장을 먼저 해주십시오.");
            		return;
            		
            	} else {
            		var paramObj = {"DOC_ID": $('#DOC_ID').val()};
        			pcrExpDecPopup(paramObj);
            	}
            }) 
            
            $('#btnCustMng').on("click", function (e) {
            	var spec = "windowname:pcrBtnCustMng;dialogWidth:800px;dialogHeight:770px;scroll:auto;status:no;center:yes;resizable:yes;";

                // 모달 호츨
                $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrCustListPopup' />", spec,
                    function () { // 리턴받을 callback 함수
                        var ret = $.comm.getModalReturnVal();
                    	if(ret && ret["ORG_ID"]) {
                    		$('#SUP_ORG_NM').val(ret["ORG_NM"]);
                    		$('#SUP_ORG_CEO_NM').val(ret["ORG_CEO_NM"]);
                    		$('#SUP_ORG_ID').val(ret["ORG_ID"]);
                    		$('#SUP_ADDR1').val(ret["ADDR1"]);
                    		$('#SUP_ADDR2').val(ret["ADDR2"]);
                    		$('#SUP_ADDR3').val(ret["ADDR3"]);
                    		$('#SUP_EMAIL_ID').val('');
                    		$('#SUP_EMAIL_DOMAIN').val('');
                    		$('#EMAIL_DOMAIN_SELECT').val('');
                    		var email = ret["MANAGER_EMAIL"];
                    		if(email && email.length > 1) {
                    			var idx = email.indexOf("@");
    	           				if(idx > -1) {
    	           					$('#SUP_EMAIL_ID').val(email.substring(0,idx));
    	               				$('#SUP_EMAIL_DOMAIN').val(email.substring(idx+1));
    	               				$('#EMAIL_DOMAIN_SELECT').val(email.substring(idx+1));
    	           				}
                    		}
                    	}
                        
                    }
                );
            })
            
            singleFileUtil = new FileUtil({
                "id"			  : "file",
                "addBtnId"		  : "btnTaxBillUpload",
                "extNames"		  : ["xml"],
                "preAddScript"    : fn_preUploadCheck,
                "successCallback" : function (data) {
                	searchTaxInvoice();
                	if(data["msg"]) {
                		alert(data["msg"]);
                	}
                },
                "params"          : {"DOC_ID":$("#BEF_DOC_ID").val()},
                "postService"	  :	"pcrService.uploadTaxInvoice"
            });
            
            $('#btnTaxBillSave').on("click", function (e) {
            	var docId = $('#DOC_ID').val();
            	if(!docId || docId.indexOf("저장시 자동생성") > -1) {
            		alert("저장을 먼저 해주십시오.");
            		return;
            	}
    			
    			pcrTaxPopup($('#DOC_ID').val());
            })
            
            $('#btnAppInfo').on("click", function (e) {
            	fn_getGeneralInfo();
            })
            
            $('#editBtnList, #readBtnList').on("click", function (e) {
                $.comm.pageBack();
            })
            
            $('input[name="REQ_TYPE"]').change(function(){
            	var reqType = $(this).val();
                if(reqType == "M" || reqType == "C") {
                	if("${BTN_TYPE}" == "NEW") {
	                	var spec = "windowname:pcrIssueListPopup;dialogWidth:800px;dialogHeight:750px;scroll:auto;status:no;center:yes;resizable:yes;";
	                	// 모달 호츨
	                    $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrIssueListPopup' />", spec,
	                        function () { // 리턴받을 callback 함수
	                            var ret = $.comm.getModalReturnVal();
	                            if(ret && ret.DOC_ID) {
	                            	$.comm.send("/pcr/selectPcrLic.do", {"qKey" : "pcr.selectPcrLic","DOC_ID": ret.DOC_ID},
	                                	function(data, status){
	                                    	var resultData = data.data;
	                                     	$.comm.bindData(resultData);
	                                     	var docStat = resultData["DOC_STAT"];
	                                     	if(docStat && (docStat == 'P4_N' || docStat == 'P4_M' || docStat == '95')) {
	                                     		$('#BEF_PCR_LIC_ID').val(resultData["PCR_LIC_ID"]);
	                                     	}
	                                    }, "구매확인서 신청 조회"
	                                );
	                            	gridEditBaseDoc.addParam("DOC_ID", ret.DOC_ID);
	                            	gridEditItem.addParam("DOC_ID", ret.DOC_ID);
	                            	gridEditTaxInvoice.addParam("DOC_ID", ret.DOC_ID);
	                            	
	                            	gridEditBaseDoc.requestToServer();
	                            	gridEditItem.requestToServer();
	                            	gridEditTaxInvoice.requestToServer();
	                            	fn_controll(reqType);
	                            	$.comm.setGlobalVar("PopUpWindowReturnVal", null);
	                        	}
	                        }
	                    );	 
                	} else {
                		if(!$('#PCR_LIC_ID').val()) {
                			$('#REQ_TYPE_N').prop("checked", true);
                			reqType = "N";
                			alert("구매확인서 발급 전 상태입니다. 변경/취소 할 수 없습니다.");
                		}
                		if(reqType== "M") {
                			
                     		var param = {
                                "qKey"    : "pcr.selectPcrLicStat",
                                "BEF_DOC_ID" : $('#BEF_DOC_ID').val()
                            };
                            var selectCallback = function(data, status){
    	                        var result = data.data;
    	                        var docStat = result["DOC_STAT"];
    	                        if(docStat && docStat == "95") {
    	                        	$('#REQ_TYPE_C').prop("checked", true);
    	                        	reqType = 'C';
		                        	alert("취소완료 상태는 변경신청할 수 없습니다.");
		                        }
                            }   
                			$.comm.send("/common/select.do", param, selectCallback, "구매확인서 상태 조회");
                			
                		}
                		fn_controll(reqType);
                	}
                	$('#BEF_PCR_LIC_ID').val($('#PCR_LIC_ID').val());
                } else if(reqType == "N") {
                	$('#BEF_PCR_LIC_ID').val('');
                	fn_controll(reqType);
                }
            });
            
            $('select[name="MTRL_USAGE_CD"]').change(function(){
                if($(this).val() == "ZZZ") {
                	$.comm.readonly(["MTRL_USAGE_DESC"], false);
                } else {
                	$.comm.readonly(["MTRL_USAGE_DESC"], true);
                }
            });
            
            $('#btnModify').on("click", function (e) {
         		var param = {
                   	"qKey"    : "pcr.selectPcrLicStat",
                   	"BEF_DOC_ID" : $('#BEF_DOC_ID').val()
                };

				var resutData = $.comm.sendSync("/common/select.do", param, "구매확인서 상태 조회").data;
				if(resutData) {
					var docStat = resutData.DOC_STAT;
					if(docStat && (docStat != "A2" && docStat != "G1")) {
                   		alert("전송중 또는 전송 이후 상태는 수정할 수 없습니다.");
                   		return;
                   	} else {
                   		$.comm.display(["editDiv"], true);
    	            	$.comm.display(["viewDiv"], false);
    	            	fn_initEditContents();
    	            	fn_select("EDIT", "${DOC_ID}");
                   	}
				}
                
            })
            
            $('select[name="EMAIL_DOMAIN_SELECT"]').change(function(){
            	if($(this).val()) {
            		$('#SUP_EMAIL_DOMAIN').val($(this).val());
            	} else {
            		$('#SUP_EMAIL_DOMAIN').val('');
            	}
            });
            
            $('select[name="TOT_ALLOW_CHARGE_INDI"]').change(function(){
                if($(this).val() == "") {
                	$.comm.disabled(["TOT_ALLOW_CHARGE_AMT", "TOT_ALLOW_CHARGE_USD_AMT"], true);
                } else {
                	$.comm.disabled(["TOT_ALLOW_CHARGE_AMT", "TOT_ALLOW_CHARGE_USD_AMT"], false);
                }
            });
            
            // 출력
            $('#btnPrint').on("click", function (e) {
         		var param = {
                   	"qKey"    : "pcr.selectPcrLicStat",
                   	"BEF_DOC_ID" : $('#BEF_DOC_ID').val()
                };

    			var resutData = $.comm.sendSync("/common/select.do", param, "구매확인서 상태 조회").data;
    			if(resutData) {
    				var reportFile = '';
    	        	var actNm = '';
    				var docStat = resutData.DOC_STAT;
    				if(docStat && docStat == "D1") {
    					reportFile = "APPPCR";
    	        		actNm = "구매확인신고서 출력";
                   	} else if(docStat == 'P4_N' || docStat == 'P4_M') {
                   		reportFile = "PCRLIC";
                		actNm = "구매확인서 출력";
                   	} else {
                   		alert("전송완료/발급완료/변경완료 상태일 경우에만 출력할 수 있습니다.");
                		return;
                   	}
    				var params = {"KEY": $('#BEF_DOC_ID').val()};
    				fnReportPrint(reportFile, params, actNm);
    			}
            });
        });
        
     	// 조회
        function fn_select(type, docId){
            $.comm.send("/pcr/selectPcrLic.do", {"qKey" : "pcr.selectPcrLic","DOC_ID": docId},
                function(data, status){
            		var resultData = data.data;
            		if(type && type == "VIEW") {
            			var appAddr = (resultData["APP_ADDR1"]?resultData["APP_ADDR1"]:'') + ' ' + (resultData["APP_ADDR2"]?resultData["APP_ADDR2"]:'')
            						+ ' ' + (resultData["APP_ADDR3"]?resultData["APP_ADDR3"]:'');
            			var supAddr = (resultData["SUP_ADDR1"]?resultData["SUP_ADDR1"]:'') + ' ' + (resultData["SUP_ADDR2"]?resultData["SUP_ADDR2"]:'') 
            						+ ' ' + (resultData["SUP_ADDR3"]?resultData["SUP_ADDR3"]:'');     
            			$('#R_APP_ADDR').html(appAddr);
            			$('#R_SUP_ADDR').html(supAddr);
             			for(var item in resultData) {
            				if((item != "APP_ADDR1" && item != "APP_ADDR2" && item != "APP_ADDR3"
            					&& item != "SUP_ADDR1" && item != "SUP_ADDR2" && item != "SUP_ADDR3")) {
            					$('#R_' + item).html(resultData[item]?resultData[item]:'');
            				}
            			}
             			var docStat = resultData["DOC_STAT"];
             			if(!resultData['PCR_LIC_ID']) {
             				$.comm.display(["btnCopy"], false);
             			} 
             			$('#BEF_DOC_ID').val(resultData["BEF_DOC_ID"]);
             			$('#R_DOC_ID').html("${DOC_ID}");
             			
            		} else {
            			 $.comm.bindData(resultData);
            			 var reqType = resultData["REQ_TYPE"];
            			 $('input:radio[name="REQ_TYPE"]').each(function() {
            				 if(resultData['PCR_LIC_ID']) {
            					 if(reqType != 'C') {
            						 reqType = 'M'; //구매확인서 발급상태 일 경우 신청구분을 변경신청로 선택하게 한다.
                					 $('#BEF_PCR_LIC_ID').val(resultData['PCR_LIC_ID']);
            					 }
            				 } else {
            					 
            				 }
                             if(this.value == reqType){
                                 this.checked = true;
                             }
                         });
            			 var email = resultData["SUP_EMAIL"];
            			 if(email) {
            				 var idx = email.indexOf("@");
            				 if(idx > -1) {
            					 $('#SUP_EMAIL_ID').val(email.substring(0,idx));
                				 $('#SUP_EMAIL_DOMAIN').val(email.substring(idx+1));
            				 }
            			 }
            			 fn_controll(reqType, resultData);
            		}
            		$('.total').show();
            		
                },
                "구매확인서 신청 조회"
            );
        }
        
        // 파일업로드 전 체크
        function fn_preUploadCheck(obj) {
        	var docId = $('#DOC_ID').val();
        	if(!docId || docId.indexOf("저장시 자동생성") > -1) {
        		alert("저장을 먼저 해주십시오.");
        		return;
        	}
        	singleFileUtil.addParam("DOC_ID", $('#BEF_DOC_ID').val());
            return true;
        }
     
   	    // 일반정보 조회 
     	function fn_getGeneralInfo() {
     		var param = {
            	"qKey"    : "usr.selectUser"
            };

            var selectCallback = function(data, status){
            	var result = data.data;
            	var retObj = {"APP_ORG_NM":"USER_NM", "APP_ORG_CEO_NM":"REP_NM", "APP_ORG_ID":"BIZ_NO", "APP_SIGN_ORG_NM":"USER_NM", "APP_SIGN_ORG_CEO_NM":"REP_NM", "APP_SIGN_VALUE":"SIGN_VALUE"} 
            	fn_setVal(retObj, result);
            	var addr = (result["ADDRESS"]?result["ADDRESS"]:'') + ' ' + (result["ADDRESS2"]?result["ADDRESS2"]:'');
            	var addrObj = {"ADDR": addr, "LAST_STR": false};
            	var addrObj1 = fn_getAddrString(addrObj, "APP_ADDR1");
            	var addrObj2 = fn_getAddrString(addrObj1, "APP_ADDR2");
            	var addrObj3 = fn_getAddrString(addrObj2, "APP_ADDR3");
            };

            $.comm.send("/usr/selectUsr.do", param, selectCallback, "일반정보 조회");
     	}
     	 
     	function fn_getAddrString(addrObj, eleId) {
     		var addr = addrObj["ADDR"];
     		var lastStr = addrObj["LAST_STR"];
     		if(lastStr) {
     			return {"ADDR": "", "LAST_STR": true};
     		} else {
     			var byteCnt = 0;
         		for ( k=0; k<addr.length; k++ ) {
            	    var nowChar = addr.charAt(k);

            	    if ( escape(nowChar).length > 4 ) {
            	    	byteCnt += 2;
            	    } else {
            	    	byteCnt++;
            	    }
             		var nextChar = addr.charAt(k+1);
             		if((byteCnt == 34 && (escape(nextChar).length > 4)) || byteCnt == 35) {
             			$("#" + eleId).val(addr.substring(0, k));
             			return {"ADDR": addr.substring(k), "LAST_STR": false}; 
             		}
                }
         		$("#" + eleId).val(addr);
         		return {"ADDR": addr, "LAST_STR": true};
     		}
     	} 
        
        function pcrExpDecPopup(paramObj) {
     		var spec = "windowname:pcrExpDecPopup;dialogWidth:850px;dialogHeight:800px;scroll:yes;status:no;center:yes;resizable:yes;";
        	// 모달 호츨

        	$.comm.setModalArguments({"PARAMS" : paramObj}); // 모달 팝업에 전달할 인자 지정
            $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrExpDecPopup' />", spec);
        }
        
        function pcrTaxPopup(docId) {
        	var spec = "windowname:pcrTaxInvoicePopup;dialogWidth:850px;dialogHeight:800px;scroll:yes;status:no;center:yes;resizable:yes;";
        	// 모달 호츨
        	$.comm.setModalArguments({"DOC_ID" : docId}); // 모달 팝업에 전달할 인자 지정
            $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrTaxInvoicePopup' />", spec, null);
        }
     	
     	// 화면 컨트롤
        function fn_controll(reqType, data){
     		var flag = false;
     		if(reqType && reqType == 'C') flag = true;
     		var notObj =  '#DOC_STAT_NM,#TOT_QTY,#QTY_UNIT,#TOT_AMT,#CURRENCY,#CONF_ORG_ID,#CONF_ORG_NM,#APP_SIGN_ORG_NM,#editHeader input[type=text]';
        	$('#editDiv input[type=text],select').not(notObj).each(function(index) { 
        		if($(this).attr("id")) {
        			var id = $(this).attr("id");
        			$.comm.disabled(id, flag);
            		if(id == "MTRL_USAGE_CD" || id == "EMAIL_DOMAIN_SELECT" || id == "TOT_ALLOW_CHARGE_INDI") {
            			$(this).attr("disabled", flag);
            		}
        		}
        	});
        	$.comm.display(["btnBasisDocSave", "btnBasisDocDel", "btnItemSave", "btnTaxBillSave", "btnTaxBillDel", "btnTaxBillUpload", "btnAppInfo", "btnCustMng"], flag?false:true);
        	if(reqType && reqType != 'C') {
        		if($('#MTRL_USAGE_CD').val() != 'ZZZ') {
        			$.comm.readonly('MTRL_USAGE_DESC', true);
        		}
        		if($('#TOT_ALLOW_CHARGE_INDI').val() == '') {
        			$.comm.readonly(['TOT_ALLOW_CHARGE_AMT', 'TOT_ALLOW_CHARGE_USD_AMT'], true);
        		}
        	}
        }
     	
     	function fn_setVal(obj, result) {
     		for(var eleId in obj) {
       			$('#' + eleId).val(result[obj[eleId]]);
     		}
     	}
     	
     	function fn_initViewContents() {
        	headersViewBaseDoc = [
                {"HEAD_TEXT": "수출신고번호", "WIDTH": "110", "FIELD_NAME": "REF_DOC_ID"},
                {"HEAD_TEXT": "HS부호"            , "WIDTH": "100" , "FIELD_NAME": "HS_ID"},
                {"HEAD_TEXT": "품목"              , "WIDTH": "280" , "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"   		      , "WIDTH": "280" , "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "금액" 		      , "WIDTH": "150" , "FIELD_NAME": "ITEM_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "선적기일" 		  , "WIDTH": "100" , "FIELD_NAME": "SHIP_DT", "DATA_TYPE":"DAT"}
            ];

        	headersViewItem = [
                {"HEAD_TEXT": "HS부호"  , "WIDTH": "90", "FIELD_NAME": "HS_ID"},
                {"HEAD_TEXT": "품목"    , "WIDTH": "250", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"    , "WIDTH": "250", "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "수량"    , "WIDTH": "100", "FIELD_NAME": "ITEM_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "수량코드", "WIDTH": "70", "FIELD_NAME": "ITEM_QTY_UNIT"},
                {"HEAD_TEXT": "구매일"  , "WIDTH": "100", "FIELD_NAME": "PCR_DT", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "단가"    , "WIDTH": "110", "FIELD_NAME": "BASE_PRICE_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "금액"    , "WIDTH": "120", "FIELD_NAME": "ITEM_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "통화단위", "WIDTH": "70", "FIELD_NAME": "ITEM_CURRENCY"}
            ];
        	
        	headersViewTaxInvoice = [
                {"HEAD_TEXT": "세금계산서 번호", "WIDTH": "150", "FIELD_NAME": "TAX_INVOICE_ID"},
                {"HEAD_TEXT": "품명"           , "WIDTH": "250", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"           , "WIDTH": "250" , "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "공급가액(KRW)"  , "WIDTH": "100" , "FIELD_NAME": "CHARGE_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "세액(KRW)"      , "WIDTH": "100" , "FIELD_NAME": "TAX_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "수량" 		   , "WIDTH": "100" , "FIELD_NAME": "ITEM_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "작성일자" 	   , "WIDTH": "100" , "FIELD_NAME": "ISSUE_DT", "DATA_TYPE":"DAT"}
            ];
        	
        	gridViewBaseDoc = new GridWrapper({
                "actNm"        : "수출신고필증 목록 조회",
                "targetLayer"  : "gridViewBaseDocLayer",
                "qKey"         : "pcr.selectPcrDocList",
                "paramsGetter" : {"DOC_ID":"${DOC_ID}"},
                "headers"      : headersViewBaseDoc,
                "countId"      : "totViewBaseDocCnt",
                "firstLoad"    : true,
                "defaultSort"  : "REF_DOC_ID, SN",
                "controllers"  : [

                ]
            });

        	gridViewItem = new GridWrapper({
                "actNm"        : "구매물품 목록 조회",
                "targetLayer"  : "gridViewItemLayer",
                "qKey"         : "pcr.selectPcrItemList",
                "paramsGetter" : {"DOC_ID":"${DOC_ID}"},
                "headers"      : headersViewItem,
                "countId"      : "totViewItemCnt",
                "firstLoad"    : true,
                "defaultSort"  : "SN"
            });
        	
        	gridViewTaxInvoice = new GridWrapper({
                "actNm"        : "세금계산서 목록 조회",
                "targetLayer"  : "gridViewTaxInvoiceLayer",
                "qKey"         : "pcr.selectPcrTaxInvoiceList",
                "paramsGetter" : {"DOC_ID":"${DOC_ID}"},
                "headers"      : headersViewTaxInvoice,
                "countId"      : "totViewTaxInvoiceCnt",
                "firstLoad"    : true,
                "defaultSort"  : "TAX_INVOICE_ID, SN",
                "controllers"  : [

                ]
            });

     	}
     	
     	function fn_initEditContents() {
        	headersEditBaseDoc = [
                {"HEAD_TEXT": "수출신고번호", "WIDTH": "110", "FIELD_NAME": "REF_DOC_ID"},
                {"HEAD_TEXT": "HS부호"            , "WIDTH": "100" , "FIELD_NAME": "HS_ID"},
                {"HEAD_TEXT": "품목"              , "WIDTH": "280" , "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"   		      , "WIDTH": "280" , "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "금액" 		      , "WIDTH": "150" , "FIELD_NAME": "ITEM_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "선적기일" 		  , "WIDTH": "100" , "FIELD_NAME": "SHIP_DT", "DATA_TYPE":"DAT"}
            ];

        	headersEditItem = [
                {"HEAD_TEXT": "HS부호"  , "WIDTH": "90", "FIELD_NAME": "HS_ID"},
                {"HEAD_TEXT": "품목"    , "WIDTH": "250", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"    , "WIDTH": "250", "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "수량"    , "WIDTH": "100", "FIELD_NAME": "ITEM_QTY"      , "FIELD_TYPE":"NUM", "LENGTH":"15", "IS_MAND":"true"},
                {"HEAD_TEXT": "수량코드", "WIDTH": "70", "FIELD_NAME": "ITEM_QTY_UNIT"},
                {"HEAD_TEXT": "구매일"  , "WIDTH": "100", "FIELD_NAME": "PCR_DT", "DATA_TYPE":"DAT", "FIELD_TYPE":"DAT", "LENGTH":"10", "IS_MAND":"true"},
                {"HEAD_TEXT": "단가"    , "WIDTH": "110", "FIELD_NAME": "BASE_PRICE_AMT", "FIELD_TYPE":"NUM", "LENGTH":"15", "IS_MAND":"true"},
                {"HEAD_TEXT": "금액"    , "WIDTH": "120", "FIELD_NAME": "ITEM_AMT"      , "FIELD_TYPE":"NUM", "LENGTH":"18", "IS_MAND":"true"},
                {"HEAD_TEXT": "통화단위", "WIDTH": "70", "FIELD_NAME": "ITEM_CURRENCY"}
            ];
        	
        	headersEditTaxInvoice = [
                {"HEAD_TEXT": "세금계산서 번호", "WIDTH": "150", "FIELD_NAME": "TAX_INVOICE_ID"},
                {"HEAD_TEXT": "품명"           , "WIDTH": "250", "FIELD_NAME": "ITEM_NM"},
                {"HEAD_TEXT": "규격"           , "WIDTH": "250" , "FIELD_NAME": "ITEM_DEF"},
                {"HEAD_TEXT": "공급가액(KRW)"  , "WIDTH": "100" , "FIELD_NAME": "CHARGE_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "세액(KRW)"      , "WIDTH": "100" , "FIELD_NAME": "TAX_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "수량" 		   , "WIDTH": "100" , "FIELD_NAME": "ITEM_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "작성일자" 	   , "WIDTH": "100" , "FIELD_NAME": "ISSUE_DT", "DATA_TYPE":"DAT"}
            ];
        	
        	gridEditBaseDoc = new GridWrapper({
                "actNm"        : "수출신고 목록 조회",
                "targetLayer"  : "gridEditBaseDocLayer",
                "qKey"         : "pcr.selectPcrDocList",
                "paramsGetter" : {"DOC_ID":("${BTN_TYPE}" == "NEW") ? $('#DOC_ID').val() : "${DOC_ID}"},
                "headers"      : headersEditBaseDoc,
                "countId"      : "totEditBaseDocCnt",
                "check"        : true,
                "firstLoad"    : true,
                "defaultSort"  :"REF_DOC_ID, SN",
                "controllers"  : [
					{"btnName": "btnBasisDocDel", "type": "D", "targetURI":"/pcr/deltePcrDocAndItemList.do", "postScript":searchDocAndItem}
                ]
            });

        	gridEditItem = new GridWrapper({
                "actNm"        : "구매물품 목록 조회",
                "targetLayer"  : "gridEditItemLayer",
                "qKey"         : "pcr.selectPcrItemList",
                "paramsGetter" : {"DOC_ID":("${BTN_TYPE}" == "NEW") ? $('#DOC_ID').val() : "${DOC_ID}"},
                "headers"      : headersEditItem,
                "countId"      : "totEditItemCnt",
                "firstLoad"    : true,
                "defaultSort"  : "SN"
            });
        	
        	gridEditTaxInvoice = new GridWrapper({
                "actNm"        : "세금계산서 목록 조회",
                "targetLayer"  : "gridEditTaxInvoiceLayer",
                "qKey"         : "pcr.selectPcrTaxInvoiceList",
                "paramsGetter" : {"DOC_ID":("${BTN_TYPE}" == "NEW") ? $('#DOC_ID').val() : "${DOC_ID}"},
                "headers"      : headersEditTaxInvoice,
                "countId"      : "totEditTaxInvoiceCnt",
                "check"        : true,
                "firstLoad"    : true,
                "defaultSort"  : "TAX_INVOICE_ID, SN",
                "controllers"  : [
					{"btnName": "btnTaxBillDel", "type": "D", "qKey":"pcr.deleteTaxInvoice", "postScript":searchTaxInvoice}
                ]
            });
        	
        	$.comm.bindCombos.addComboInfo("MTRL_USAGE_CD" , "MTRL_USAGE_CD", false, null, null, null, 3);	//공급물품 용도명세코드
            $.comm.bindCombos.draw();

     	}
     	
        // 저장
        function fn_save(askSaveYn, btnType){
        	var callBackFunc = fn_callback;
        	if(askSaveYn == true && !confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                return;
            }
            if(!fn_savaValidate(btnType)) return;
            
            var docSize = gridEditBaseDoc.getSize();
        	if(docSize < 1) {
        		
        	} else if(docSize > 999) {
        		alert("수출신고필증은 최대 999 개까지 등록하실 수 있습니다"); 
                return;
        	}
        	
        	var itemSize = gridEditItem.getSize();
        	if(itemSize < 1) {
        		
        	} else if(itemSize > 999) {
        		alert("구매물품은 최대 999 개까지 등록하실 수 있습니다"); 
                return;
        	}
        	
        	var taxSize = gridEditTaxInvoice.getSize();
        	if(taxSize > 999) {
         		alert("세금계산서는 최대 999 개까지 등록하실 수 있습니다"); 
                return;
         	}
        	
        	if($('select[name="TOT_ALLOW_CHARGE_INDI"]').val() != '') {
        		if($('#TOT_ALLOW_CHARGE_AMT').val() == '') {
        			alert("[총 할인/할증/변동내역]을 선택하신 경우, [총 할인/할증/변동 금액]을 입력해주셔야 합니다.");
					return;
        		}
        	}
        	
        	if($('#CURRENCY').val() && $('#CURRENCY').val() != "KRW" && $('#CURRENCY').val() != "USD"){
		    	if($('#TOT_USD_AMT').val() == ""){
		    		alert("총금액 단위가 KRW, USD가 아닌 경우에는\n'총금액(USD금액부기)'항목을 필히 입력해 주셔야 합니다.");
		    		$('#TOT_USD_AMT').focus()
		    		return;
		    	}
		    }
        	
        	var nowItemSize = gridEditItem.getSize();
        	if(nowItemSize && nowItemSize > 0) {
        		var itemListValidation = gridEditItem.getUpdateData();
                if(!itemListValidation) return;
                
            	var oldItemList = gridEditItem.dataObj;
                for(var i=0; i<oldItemList.length; i++){
                    var data = oldItemList[i];
                    var itemQty = data["ITEM_QTY"];
                    var pcrDt = data["PCR_DT"];
                    var basePriceAmt = data["BASE_PRICE_AMT"];
                    var itemAmt = data["ITEM_AMT"];
                    if(!itemQty || !pcrDt || !basePriceAmt || !itemAmt) {
                    	alert("구매물품 목록 필수항목들을 저장해야 합니다.");
                    	return;
                    }
                }
            	
            	var nowDate = $.date.currdate("YYYYMMDD"); //오늘날짜
            	var holidayDiv = ''; //휴일구분
            	var minPcrDt = '';   //구매물품 목록중 가장 빠른 구매일자
            	var maxPcrDt = '';   //구매물품 목록중 가장 느린 구매일자
            	var minShipDt = '';  //수출신고필증 목록중 가장 빠른 선적일자
            	var maxShipDt = '';  //수출신고필증 목록중 가장 느린 선적일자
            	var nowDate2 = nowDate.toDate("YYYYMMDD");
            	var holidayParams = {"qKey":"pcr.selectHolidayDiv", "dbPoolName":"trade",
            					 "DOC_ID": $('#DOC_ID').val(), "YEAR":nowDate2.getFullYear() + '', "MONTH":(nowDate2.getMonth() + 1) + '', "DAY":nowDate2.getDate() + ''};
            	var holidayData = $.comm.sendSync("/common/select.do", holidayParams).data;
            	if(holidayData) {
            		holidayDiv = holidayData["DIV"];
            	}
            	
            	var params = {"qKey":"pcr.selectPcrDtAndShipDt", "DOC_ID": $('#DOC_ID').val()};
    	       	var resultData = $.comm.sendSync("/common/select.do", params).data;
    	       	minPcrDt = resultData["MIN_PCR_DT"]?resultData["MIN_PCR_DT"]:'';
	       		maxPcrDt = resultData["MAX_PCR_DT"]?resultData["MAX_PCR_DT"]:'';
	       		minShipDt = resultData["MIN_SHIP_DT"]?resultData["MIN_SHIP_DT"]:'';
	       		maxShipDt = resultData["MAX_SHIP_DT"]?resultData["MAX_SHIP_DT"]:'';
            	
            	// 구매물품 목록중 가장 빠른 구매일자의 익월 10일 (예: 20170125 -> 20170210)
            	var minPcrDt_nextMonth_10 = new Date(minPcrDt.substring(0,4),minPcrDt.substring(4,6), 10).format("YYYYMMDD"); 
            	var beforeMonth_10 = new Date(nowDate.substring(0,4),nowDate.substring(4,6), 10).format("YYYYMMDD"); // 오늘날짜의지난월 10일
            	if (minPcrDt_nextMonth_10 < nowDate) {
	        		var taxSize = gridEditTaxInvoice.getSize();
	        		if(taxSize == 0) {
	        			if (holidayDiv == "" ) {
							alert("구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록해주세요.");
							return;
						} else if (holidayDiv != "" && holidayDiv != "10A" && holidayDiv != "10") {
							alert("구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록 해주세요.");
							return;
						} else if (holidayDiv != "" && (holidayDiv == "10A" || holidayDiv == "10") ) {
							// 현재일자의 지난달 10일 보다 세금계산서의 익월 10일이 작을경우 마감일시간(10)이나 휴일(10A)이라도 세금계산서 있어야함
							if ( minPcrDt_nextMonth_10 < beforeMonth_10 ) {
								alert("구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록 해주세요.");
								return;
							}
						}
	        		}
	        	}
            	if(minShipDt && maxShipDt) {
            		if(minPcrDt > minShipDt || maxPcrDt > maxShipDt){
    					alert("구매일은 선적기일 이후일 수 없습니다.\n구매물품 목록의 구매일자와 수출신고필증 정보의 선적기일을 확인해주시기 바랍니다.");
    					return;
    				}
            	}
            	
        	}

            $('#DOC_STAT').val(btnType);
            $.comm.sendForm("/pcr/savePcrLic.do", "detailForm", callBackFunc, "구매확인서 상세 저장", null, false);
        }
        
        function fn_savaValidate(btnType) {
        		var param = {
                   	"qKey"    : "pcr.selectPcrLicStat",
                   	"BEF_DOC_ID" : $('#BEF_DOC_ID').val()
                };

    			var resutData = $.comm.sendSync("/common/select.do", param, "구매확인서 상태 조회").data;
    			if(resutData) {
    				 var docStat = resutData.DOC_STAT;
    				 if(docStat && (docStat == "P4_M" || docStat == "P4_N")) {
    		         	var reqType = $(':radio[name="REQ_TYPE"]:checked').val();
    		             if(reqType == 'M') {
    		             	$('#DOC_STAT').val("A2")
    		             	var params = {"BEF_DOC_ID": $('#BEF_DOC_ID').val(),"DOC_STAT" : "A2" };
    		                 var data = $.comm.sendSync("/pcr/saveAllPcrLicCopyInfo.do", params);
    		                 if(data) {
    		                 	var data = data.data;
    		                 	$('#DOC_ID').val(data.DOC_ID);
    		                 	$('#BEF_DOC_ID').val(data.DOC_ID);
    		                 }
    		             } 
    		         }
    			}
           			
                var reqType	= $(':radio[name="REQ_TYPE"]:checked').val();
                if(reqType == 'M' || reqType == 'C') {
                	if($('#BEF_PCR_LIC_ID').val() == '') {
                		alert("변경전 구매확인서번호가 존재하지 않습니다.");
                		return false;
                	}
                } else {
                	if($('#BEF_PCR_LIC_ID').val() && ($('#BEF_PCR_LIC_ID').val()).legnth > 0) {
                		alert("신규신청시 변경전구매확인서번호를 등록할 수 없습니다.");
                		return false;
                	}
                }
                if(reqType != "C" && btnType == "A2" ) { //신청구분이 취소신청이 아니고 저장 버튼을 누를시에만 Validation 체크
                	 // 이메일 유효성검사
                    if(!$.comm.isNull($('#SUP_EMAIL_ID').val()) && $.comm.isNull($('#SUP_EMAIL_DOMAIN').val())) {
                    	alert("이메일 도메인을 입력하세요.");
                    	$('#SUP_EMAIL_DOMAIN').focus();
                    	return false;
                    }
                    if(!$.comm.isNull($('#SUP_EMAIL_DOMAIN').val()) && $.comm.isNull($('#SUP_EMAIL_ID').val())) {
                    	alert("이메일 ID를 입력하세요.");
                    	$('#SUP_EMAIL_ID').focus();
                    	return false;
                    }
                    
                    var frm = new JForm();
                    frm.add(new JEmailChk('SUP_EMAIL_ID'));
                    frm.add(new JEmailChk('SUP_EMAIL_DOMAIN'));
                    frm.add(new JCustom(function() {
                    	var mtrlUsageTypeCd = $('#MTRL_USAGE_CD').val();
                    	var mtrlUsageDesc = $('#MTRL_USAGE_DESC').val();
                    	if(mtrlUsageTypeCd == 'ZZZ') {
                    		if($.trim(mtrlUsageDesc).length < 1) {
                    			 alert("공급물품 용도명세의 사용자 입력을 입력해주세요."); 
                    			 $('#MTRL_USAGE_DESC').focus();
                                 return false;
                    		}
                    	}
                    	
                    	var appOrgId = $('#APP_ORG_ID').val();
                    	var supORgId = $('#SUP_ORG_ID').val();
                    	if($.trim(appOrgId).length > 0) {
                    		if($.trim(appOrgId).length != 10) {
                    			 alert("신청인 사업자등록번호가 잘못 되었습니다."); 
                    			 $('#APP_ORG_ID').focus();
                                 return false;
                    		}
                    	}
                    	if($.trim(supORgId).length > 0) {
                    		if($.trim(supORgId).length != 10) {
                    			 alert("공급자 사업자등록번호가 잘못 되었습니다."); 
                    			 $('#SUP_ORG_ID').focus();
                                 return false;
                    		}
                    	}

                    	return true;
                    }));

                    if(!frm.validate()){
                        return false;
                    }
                }
               
                return true;
               
        }
        function JEmailChk(name) {
            this.name = name;
            this.object = $("#" + name);

            this.validate =  function() {
                var value = this.object == null ? '' : this.object.val();
                if ($.trim(value).length > 0) {
                	var regEmail = '';
                	if(name == 'SUP_EMAIL_ID') {
                		regEmail = /([\w-\.]+)$/;
                	} else if(name == 'SUP_EMAIL_DOMAIN') {
                		regEmail = /((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
                	}
                    if (!regEmail.test(value)) {
                        alert($.comm.getMessage("W00000009")); //이메일 주소가 유효하지 않습니다.
                        this.object.focus();
                        return false;
                    }
                }

                return true;
            };
        }

        var fn_callback = function (data) {
        	if(data) {
        		alert($.comm.getMessage("I00000003")); //저장되었습니다.
            	var data = data.data;
                fn_select("EDIT", data.DOC_ID);
        	}
        }
        
        var fn_callbackForCopy = function (data) {
        	if(data) {
        		alert($.comm.getMessage("I00000034")); //복사되었습니다.
            	var data = data.data;
            	$.comm.display(["editDiv"], true);
            	$.comm.display(["viewDiv"], false);
            	fn_initEditContents();
                fn_select("EDIT", data.DOC_ID);
                $.comm.setGlobalVar("IS_COPY", "Y");
                gridEditBaseDoc.addParam("DOC_ID", data.DOC_ID);
            	gridEditItem.addParam("DOC_ID", data.DOC_ID);
            	gridEditTaxInvoice.addParam("DOC_ID", data.DOC_ID);
            	
            	gridEditBaseDoc.requestToServer();
            	gridEditItem.requestToServer();
            	gridEditTaxInvoice.requestToServer();
        	}
        }
        
        var fn_pcrItemCallback = function (data) {
            if (data.code.indexOf('I') == 0) {
            	gridEditItem.requestToServer();
            	var resultData = data.data;
            	if(resultData && resultData["TOT_QTY"]) {
            		$.comm.bindData(resultData);
            		$("#TOT_QTY").val(resultData["TOT_QTY"] ? $.comm.numberWithCommas(resultData["TOT_QTY"]) : '');
            		$("#TOT_AMT").val(resultData["TOT_AMT"] ? $.comm.numberWithCommas(resultData["TOT_AMT"]) : '');
            	}
            }
        }
        
        function searchDocAndItem(docObj) {
        	var docId = "";
        	if(!docObj) {
        		docId = $('#DOC_ID').val();
        	} else {
        		if(typeof docObj == 'string') {
        			docId = docObj;
        		} else {
        			docId = docObj.dataObj[0]["DOC_ID"];
        		} 
        	}
        	gridEditBaseDoc.addParam("DOC_ID", docId);
        	gridEditItem.addParam("DOC_ID", docId);
        	gridEditBaseDoc.requestToServer();
        	gridEditItem.requestToServer();
        	fn_select("EDIT", docId);
        }
        
        function searchTaxInvoice() {
        	gridEditTaxInvoice.addParam("DOC_ID", $('#DOC_ID').val());
        	gridEditTaxInvoice.requestToServer();
        }
    </script>
</head>
<body>
<div class="inner-box">
	<form id="detailForm" name="detailForm" method="post">
    <input type="hidden" name="DOC_STAT" id="DOC_STAT"/>
    <input type="hidden" name="BEF_DOC_ID" id="BEF_DOC_ID"/>
    <input type="hidden" name="PCR_LIC_ID" id="PCR_LIC_ID"/>
    <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
    <input type="hidden" id="FILE_SN" name="FILE_SN" />
    <input type="hidden" name="DOC_ID" id="DOC_ID" value="저장시 자동생성">
    <input type="hidden" name="RCV_CD_NM" id="RCV_CD_NM" value="KTNET(구매확인발급)">
    <div id="editDiv" class="padding_box" style="display:none;">
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
	                <a href="#" class="title_frame_btn" id="editBtnList">목록</a>
	                <a href="#" class="title_frame_btn" id="btnView">상세보기(BACK)</a>
	                <a href="#" class="title_frame_btn" id="btnSave">저장</a>
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">Header</a></p>
            <div class="table_typeA gray">
            <table id="editHeader" style="table-layout:fixed;">
                <caption class="blind">Header</caption>
                <colgroup>
                    <col width="13%" />
                    <col width="37%" />
                    <col width="13%" />
                    <col width="15%" />
                    <col width="10%" />
                    <col width="12%" />
                </colgroup>
                <tr>
                    <td><label for="REQ_TYPE_N">신청구분</label></td>
                    <td>
						<div class="radio"> 
							<input name="REQ_TYPE" type="radio" id="REQ_TYPE_N" value="N" checked="checked"/>
				        	<label for="REQ_TYPE_N"><span></span>신규신청</label>
						</div>
						<div class="radio"> 
							<input name="REQ_TYPE" type="radio" id="REQ_TYPE_M" value="M" />
				        	<label for="REQ_TYPE_M"><span></span>변경신청</label>
						</div>   
						<div class="radio"> 
							<input name="REQ_TYPE" type="radio" id="REQ_TYPE_C" value="C" />
				        	<label for="REQ_TYPE_C"><span></span>취소신청</label>
						</div>             	
                    </td>
                    <td><label for="BEF_PCR_LIC_ID">변경전 구매확인서번호</label></td>
                    <td><input type="text" name="BEF_PCR_LIC_ID" id="BEF_PCR_LIC_ID" class="td_input readonly" readonly></td>
                    <td><label for="DOC_STAT_NM">상태</label></td>
                    <td><input type="text" name="DOC_STAT_NM" id="DOC_STAT_NM" <attr:length value='70'/> class="td_input readonly" readonly></td>
                </tr>
            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
             <p><a href="#" id="appInfo" class="btnToggle_table">신청인정보</a></p>
             <div class="table_typeA gray table_toggle">
	             <table style="table-layout:fixed;">
	                <caption class="blind">신청인정보</caption>
	                <colgroup>
	                    <col width="13%" />
	                    <col width="21%" />
	                    <col width="13%" />
	                    <col width="21%" />
	                    <col width="10%" />
	                    <col width="22%" />
	                </colgroup>
					<tbody>
						<tr>
		                     <td><label for="APP_ORG_NM">상호</label></td>
		             		 <td><input type="text" id="APP_ORG_NM" name="APP_ORG_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input readonly" readonly></td>
		             		 <td><label for="APP_ORG_CEO_NM">성명</label></td>
		             		 <td ><input type="text" id="APP_ORG_CEO_NM" name="APP_ORG_CEO_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input" style="ime-mode:active"></td>
		             		 <td><label for="APP_ORG_ID">사업자등록번호</label></td>
		             		 <td><input type="text" id="APP_ORG_ID" name="APP_ORG_ID" <attr:length value='10'/> <attr:mandantory/> class="td_input readonly" style="width: 45%;" readonly><a href="#" class="btn_table" style="margin-left: 0px;" id="btnAppInfo">정보갱신</a></td>
		             	</tr>
		             	<tr>
		                     <td><label for="APP_ADDR1">주소</label><label for="APP_ADDR2" style="display: none">두번째 주소</label><label for="APP_ADDR3" style="display: none">세번째 주소</label></td>
		                     <td colspan="5">
		                     	<input type="text" name="APP_ADDR1" id="APP_ADDR1" <attr:length value='35'/> <attr:mandantory/> class="td_input" style="ime-mode:active;width: 33%;">
		                     	<input type="text" name="APP_ADDR2" id="APP_ADDR2" <attr:length value='35'/> class="td_input" style="ime-mode:active;width: 33%;">
		                     	<input type="text" name="APP_ADDR3" id="APP_ADDR3" <attr:length value='35'/> class="td_input" style="ime-mode:active;width: 30%;">
		                     </td>
		             	</tr>
		             	<tr>
		                     <td><label for="MTRL_USAGE_CD">공급물품 용도명세</label><label for="MTRL_USAGE_DESC" style="display: none">공급물품 용도명세</label></td>
		                     <td colspan="5" style="padding-top: 3px;">
		                         <select name="MTRL_USAGE_CD" id="MTRL_USAGE_CD" class="td_input" style="width: 15% !important">
		                                 <option value="2AA">원자재</option>
		                                 <option value="2AB">원자재임가공</option>
		                                 <option value="2AC">완제품임가공</option>
		                                 <option value="2AD">원자재(실적)</option>
		                                 <option value="2AE">원자재임가공(실적)</option>
		                                 <option value="2AF">완제품임가공(실적)</option>
		                                 <option value="2AJ">완제품</option>
		                                 <option value="2AK">완제품(수출대행)</option>
		                                 <option value="2AL">완제품(실적)</option>
		                                 <option value="2AM">완제품(수출대행)(실적)</option>
		                                 <option value="2AO">(위탁가공)원자재</option>
		                                 <option value="ZZZ">용도명세 사용자 입력</option>
		                          </select>
		                          <input type="text" name="MTRL_USAGE_DESC" id="MTRL_USAGE_DESC" <attr:length value='65'/> class="td_input readonly" readonly style="width: 80% !important;">
			                      <div style="margin: 3px 0 3px 0;color:#f7941d;">* 회색 입력란은 '용도명세 사용자 입력' 선택시 입력 가능</div>
		                     </td>
		                </tr>
	                 </tbody>
	             </table>
             </div>
         </div><!-- //title_frame -->
         <div class="title_frame">
             <p><a href="#" class="btnToggle_table">공급자정보</a></p>
             <div class="table_typeA gray table_toggle">
	             <table style="table-layout:fixed;">
	                <caption class="blind">공급자정보</caption>
	                <colgroup>
	                    <col width="13%" />
	                    <col width="21%" />
	                    <col width="13%" />
	                    <col width="21%" />
	                    <col width="10%" />
	                    <col width="22%" />
	                </colgroup>
					<tbody>
						<tr>
		                     <td><label for="SUP_ORG_NM">상호</label></td>
		                     <td><input type="text" id="SUP_ORG_NM" name="SUP_ORG_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input" style="ime-mode:active"></td>
		             		 <td><label for="SUP_ORG_CEO_NM">성명</label></td>
		                     <td><input type="text" id="SUP_ORG_CEO_NM" name="SUP_ORG_CEO_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input" style="ime-mode:active"></td>
		             		 <td><label for="SUP_ORG_ID">사업자등록번호</label></td>
		                     <td><input type="text" id="SUP_ORG_ID" name="SUP_ORG_ID" <attr:length value='10'/> <attr:mandantory/> class="td_input" style="width: 45%;" /><a href="#" class="btn_table" style="margin-left: 0px;" id="btnCustMng">거래처 찾기</a></td>
		             	</tr>
		             	<tr>
		                     <td><label for="SUP_ADDR1">주소</label><label for="SUP_ADDR2" style="display: none">두번째 주소</label><label for="SUP_ADDR3" style="display: none">세번째 주소</label></td>
		                     <td colspan="5">
		                     	<input type="text" name="SUP_ADDR1" id="SUP_ADDR1" <attr:length value='35'/> <attr:mandantory/> class="td_input" style="ime-mode:active;width: 33%;">
		                     	<input type="text" name="SUP_ADDR2" id="SUP_ADDR2" <attr:length value='35'/> class="td_input" style="ime-mode:active;width: 33%;">
		                     	<input type="text" name="SUP_ADDR3" id="SUP_ADDR3" <attr:length value='35'/> class="td_input" style="ime-mode:active;width: 30%;">
		                     </td>
		             	</tr>
		             	<tr>
		                     <td style="margin-right: 3px;">
		                     	<label for="SUP_EMAIL_ID">이메일주소</label><label for="SUP_EMAIL_DOMAIN" style="display: none">이메일 도메인</label>
		                     	<label for="EMAIL_DOMAIN_SELECT" style="display: none">이메일 도메인</label>
		                     </td>
		                     <td colspan="5" style="padding-top: 3px;">
		                     	<div class="email">
		                        	<input type="text" class="td_input" name="SUP_EMAIL_ID" id="SUP_EMAIL_ID" <attr:length value='30'/> style="ime-mode:disabled;"/>
									<span>@</span>
									<input type="text" class="td_input" name="SUP_EMAIL_DOMAIN" id="SUP_EMAIL_DOMAIN" <attr:length value='30'/> style="ime-mode:disabled;width:130px;"/>
								</div>
								<select name="EMAIL_DOMAIN_SELECT" id="EMAIL_DOMAIN_SELECT" class="td_input">
	                                <option value=""            >직접입력       </option>
	                                <option value="chollian.net">chollian.net   </option>
	                                <option value="dreamwiz.com">dreamwiz.com   </option>
	                                <option value="empal.com"   >empal.com      </option>
	                                <option value="freechal.com">freechal.com   </option>
	                                <option value="gmail.com"   >gmail.com      </option>
	                                <option value="hanafos.com" >hanafos.com    </option>
	                                <option value="hanmail.net" >hanmail.net    </option>
	                                <option value="hotmail.com" >hotmail.com    </option>
	                                <option value="korea.com"   >korea.com      </option>
	                                <option value="nate.com"    >nate.com       </option>
	                                <option value="naver.com"   >naver.com      </option>
	                                <option value="paran.com"   >paran.com      </option>
	                                <option value="yahoo.co.kr" >yahoo.co.kr    </option>
	                            </select>
	                            <div style="margin: 3px 0 3px 0;line-height:1.3em;color:#f7941d;">
	                                * 공급자에게 발급사실을 통지하는 경우 입력(선택사항)<br />
	                            	* 구매확인서 발급사실을 공급자에게 신속히 메일로 알려드리기 위해 기재하는 사항이며, 구매확인서 서류가 전달되진 않습니다.<br />
									* 이메일주소를 잘못 기재하여 제3자에게 메일 전송시, 그 책임은 구매확인신청인에게 있습니다.<br />
								 	&nbsp;&nbsp;&nbsp;(문서복사시 이메일정보를 다시 확인하시기 바랍니다.) 
	                            </div>
		                     </td>
		                     
		                </tr>
	                 </tbody>
	             </table>
             </div>
         </div><!-- //title_frame -->
         <div class="title_frame">
			 <p><a href="#" class="btnToggle_table">수출신고필증 정보(외화획득용 원료.기재라는 사실을 증명하는 서류)</a><span style="color: #f7941d">*</span></p>
			 <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
			 	<div class="util_left64">
		        	<p class="total">Total <span id="totEditBaseDocCnt"></span>
		        </div>
			 	<div class="title_btn_inner">
			 		<a href="#" class="btn white_84" id="btnBasisDocDel">삭제</a>
			 		<a href="#" class="btn white_147" id="btnBasisDocSave">수출신고필증 등록</a>
			 	</div>
			 </div>
             <div class="list_typeB table_toggle">
             	<div id="gridEditBaseDocLayer" style="height: 150px;"></div>
             </div>
         </div>
         <div class="title_frame">
             <p><a href="#" class="btnToggle_table">구매물품 목록(수출신고필증을 등록하면 자동으로 구매물품 등록)</a><span style="color: #f7941d">*</span></p>
             <div class="table_typeA gray table_toggle">
             <table id="editItemList" style="table-layout:fixed;">
                 <caption class="blind">구매물품 목록</caption>
                 <colgroup>
                     <col width="13%" />
                     <col width="37%" />
                     <col width="15%" />
                     <col width="35%" />
                 </colgroup>
                 <tr>
                     <td><label for="TOT_QTY">총수량</label><label for="QTY_UNIT" style="display: none">단위</label></td>
                     <td><input type="text" name="TOT_QTY" id="TOT_QTY" style="width:70%" <attr:length value='23'/> <attr:numberOnly value='true'/> class="readonly" readonly="readonly">&nbsp;
                         <input type="text" name="QTY_UNIT" id="QTY_UNIT" style="width:20%" class="readonly" readonly="readonly" <attr:length value='3'/>></td>
                     <td><label for="TOT_ALLOW_CHARGE_INDI">총 할인/할증/변동내역</label></td>
                     <td>
                     	 <select name="TOT_ALLOW_CHARGE_INDI" id="TOT_ALLOW_CHARGE_INDI" class="td_input" style="width: 40% !important">
                     	 	<option value="">선택</option>
                    		<option value="Q">Minus(Amount)</option>
							<option value="S">Plus(Amount)</option>
							<option value="U">Plus/Minus(Amount)</option>
						 </select>
                     </td>
                 </tr>
                 <tr>
                     <td><label for="TOT_AMT">총금액</label><label for="CURRENCY" style="display: none">통화</label></td>
                     <td><input type="text" name="TOT_AMT" id="TOT_AMT" style="width:70%" <attr:length value='23'/> <attr:numberOnly value='true'/> class="readonly" readonly="readonly">&nbsp;
                         <input type="text" name="CURRENCY" id="CURRENCY" style="width:20%" class="readonly" readonly="readonly" <attr:length value='3'/>></td>
                     <td><label for="TOT_ALLOW_CHARGE_AMT">총 할인/할증/변동금액</label></td>
                     <td><input type="text" name="TOT_ALLOW_CHARGE_AMT" id="TOT_ALLOW_CHARGE_AMT" <attr:length value='18'/> <attr:numberOnly value='true'/>></td>
                 </tr>
                 <tr>
                     <td><label for="TOT_USD_AMT">총금액(USD금액부기)</label></td>
                     <td><input type="text" name="TOT_USD_AMT" id="TOT_USD_AMT" <attr:length value='18'/> <attr:numberOnly value='true'/> ></td>
                     <td><label for="TOT_ALLOW_CHARGE_USD_AMT">총 할인/할증/변동금액(USD)</label></td>
                     <td><input type="text" name="TOT_ALLOW_CHARGE_USD_AMT" id="TOT_ALLOW_CHARGE_USD_AMT" <attr:length value='18'/> <attr:numberOnly value='true'/>></td>
                 </tr>
             </table>
             </div>
             <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
             	<div class="util_left64">
		        	<p class="total">Total <span id="totEditItemCnt"></span>
		        </div>
			 	<div class="title_btn_inner">
			 		<a href="#" class="btn white_84" id="btnItemSave">저장</a>
			 	</div>
			 </div>
			 <div class="list_typeB table_toggle">
             	<div id="gridEditItemLayer" style="height: 150px;"></div>
             </div>
          </div>  
          <div class="title_frame">  
          	 <p><a href="#" class="btnToggle_table">세금계산서 내용(외화획득용 원료.기재를 구매한 자가 신청하는 경우에만 해당)</a></p>  
             <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
             	<div class="util_left64">
		        	<p class="total">Total <span id="totEditTaxInvoiceCnt"></span>
		        </div>
				<div class="title_btn_inner">
					<a href="#" class="btn white_84" style="width:64px;" id="btnTaxBillDel">삭제</a>
					<a href="#" class="btn white_100" style="width:120px;" id="btnTaxBillSave">세금계산서 등록</a>
					<a href="#" class="btn white_173" id="btnTaxBillUpload">국세청 세금계산서 업로드</a>
				</div>
			 </div>
			 <div class="list_typeB table_toggle">
            	<div id="gridEditTaxInvoiceLayer" style="height: 150px;"></div>
             </div>
          </div>
          <div style="padding:16px 20px;margin:10px 0 10px 0;font-size:12px;font-family:Arial;background-color:#f3f4f7;line-height:1.3em;">
				<p>
					* 신청업체는 전자무역촉진에관한 법률 시행규정 제7조에 의거 첨부근거서류를 5년동안 보관하셔야 합니다.
					<br/>&nbsp;&nbsp;보관은  마이크로 필름, 광디스크, 전자문서보관소 등에 의해서도 보관할 수 있습니다.
					<br/><br/>
					&nbsp;(위의 사항을 대외무역법 제18조에 따라 신청합니다.)
				</p>
		  </div>    
          <div class="title_frame">    
                <p><a href="#" class="btnToggle_table">확인기관</a></p>  
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;">
	                    <caption class="blind">확인기관</caption>
	                    <colgroup>
	                        <col width="10%" />
	                        <col width="25%" />
	                        <col width="10%" />
	                        <col width="25%" />
	                        <col width="10%" />
	                        <col width="25%" />
	                    </colgroup>
	                    <tr>
	                        <td><label for="CONF_ORG_ID">코드</label></td>
	                        <td><input type="text" name="CONF_ORG_ID" id="CONF_ORG_ID" value="KTNET" <attr:mandantory/> class="readonly" readonly="readonly"></td>
	                        <td><label for="CONF_ORG_NM">기관명</label></td>
	                        <td><input type="text" name="CONF_ORG_NM" id="CONF_ORG_NM" value="한국무역정보통신" <attr:mandantory/> class="readonly" readonly="readonly"></td>
	                        <td><label for="CONF_BR_ORG_NM">지점명</label></td>
	                        <td><input type="text" name="CONF_BR_ORG_NM" id="CONF_BR_ORG_NM" <attr:length value='70'/>></td>
	                    </tr>
	                </table>
                </div>
  		  </div>
  		  <div class="title_frame">    
  		        <p><a href="#" class="btnToggle_table">전자서명</a></p>  
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;">
	                    <caption class="blind">전자서명</caption>
	                    <colgroup>
	                        <col width="10%" />
	                        <col width="25%" />
	                        <col width="10%" />
	                        <col width="25%" />
	                        <col width="10%" />
	                        <col width="25%" />
	                    </colgroup>
	                    <tr>
	                        <td><label for="APP_SIGN_ORG_NM">상호</label></td>
	                        <td><input type="text" name="APP_SIGN_ORG_NM" id="APP_SIGN_ORG_NM" <attr:mandantory/> class="readonly" readonly="readonly"></td>
	                        <td><label for="APP_SIGN_ORG_CEO_NM">대표자명</label></td>
	                        <td><input type="text" name="APP_SIGN_ORG_CEO_NM" id="APP_SIGN_ORG_CEO_NM" <attr:length value='35'/> <attr:mandantory/>></td>
	                        <td><label for="APP_SIGN_VALUE">전자서명</label></td>
	                        <td><input type="text" name="APP_SIGN_VALUE" id="APP_SIGN_VALUE" style="width: 50% !important" <attr:length value='10,10'/> <attr:mandantory/>><span>(숫자 10자리 입력)</span></td>
	                    </tr>
	                </table>
                </div>
  		  </div>
       </div>         
       <div id="viewDiv" class="padding_box" style="display:none;">
       		<div class="title_frame">
                <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
                	<div class="title_btn_inner">
                	    <a href="#" class="title_frame_btn" id="btnPrint">출력</a>
                		<a href="#" class="title_frame_btn" id="readBtnList">목록</a>
	                	<a href="#" class="title_frame_btn" id="btnCopy">복사(변경/취소)</a>
	                	<a href="#" class="title_frame_btn" id="btnNewCopy">복사(신규)</a>
	                	<a href="#" class="title_frame_btn" id="btnModify">수정</a>
                    </div>
                </div>
                <p><a href="#" class="btnToggle_table">Header</a></p>
                <div class="table_typeA gray">
                <table style="table-layout:fixed;">
                    <caption class="blind">Header</caption>
                    <colgroup>
                        <col width="13%" />
	                    <col width="37%" />
	                    <col width="13%" />
	                    <col width="15%" />
	                    <col width="10%" />
	                    <col width="12%" />
                    </colgroup>
                    <tr>
                        <td><label for="R_DOC_ID">전자문서번호</label></td>
                        <td><span id="R_DOC_ID"></span></td>
                        <td><label for="R_ISSUE_ORG_NM">수신처(발급기관)</label></td>
                        <td><span id="R_ISSUE_ORG_NM">KTNET(구매확인발급)</span></td>
                        <td><label for="R_DOC_STAT_NM">상태</label></td>
                    	<td><span id="R_DOC_STAT_NM"></span></td>
                    </tr>
                    <tr>
                        <td><label for="R_REQ_TYPE_NM">신청구분</label></td>
                        <td><span id="R_REQ_TYPE_NM"></span></td>
                        <td><label for="R_BEF_PCR_LIC_ID">변경전 구매확인서번호</label></td>
                        <td colspan="3"><span id="R_BEF_PCR_LIC_ID"></span></td>
                    </tr>
                </table>
                </div>
            </div>
            
            <div class="title_frame">
                <p><a href="#" class="btnToggle_table">신청인정보</a></p>
                <div class="table_typeA gray table_toggle">
                <table style="table-layout:fixed;">
                    <caption class="blind">신청인정보</caption>
                     <colgroup>
                         <col width="13%" />
	                     <col width="21%" />
	                     <col width="13%" />
	                     <col width="21%" />
	                     <col width="10%" />
	                     <col width="22%" />
                    </colgroup>
					<tbody>
						<tr>
	                        <td><label for="R_APP_ORG_NM">상호</label></td>
	                		<td><span id="R_APP_ORG_NM">&nbsp;</span></td>
	                		<td><label for="R_APP_ORG_CEO_NM">성명</label></td>
	                		<td><span id="R_APP_ORG_CEO_NM">&nbsp;</span></td>
	                		<td><label for="R_APP_ORG_ID">사업자등록번호</label></td>
	                		<td><span id="R_APP_ORG_ID">&nbsp;</span></td>
	                	</tr>
	                	<tr>
	                        <td><label for="R_APP_ADDR">주소</label></td>
	                        <td colspan="5"><span id="R_APP_ADDR">&nbsp;</span></td>
	                	</tr>
	                	<tr>
	                        <td><label for="R_MTRL_USAGE_NM">공급물품 용도명세</label></td>
	                        <td colspan="5"><span id="R_MTRL_USAGE_NM">&nbsp;</span></td>
	                    </tr>
                    </tbody>
                </table>
                </div>
         	</div>
         	
         	<div class="title_frame">
                <p><a href="#" class="btnToggle_table">공급자정보</a></p>
                <div class="table_typeA gray table_toggle">
                <table style="table-layout:fixed;">
                    <caption class="blind">공급자정보</caption>
                     <colgroup>
                         <col width="13%" />
	                     <col width="21%" />
	                     <col width="13%" />
	                     <col width="21%" />
	                     <col width="10%" />
	                     <col width="22%" />
                    </colgroup>
					<tbody>
						<tr>
	                        <td><label for="R_SUP_ORG_NM">상호</label></td>
	                        <td><span id="R_SUP_ORG_NM">&nbsp;</span></td>
	                		<td><label for="R_SUP_ORG_CEO_NM">성명</label></td>
	                        <td><span id="R_SUP_ORG_CEO_NM">&nbsp;</span></td>
	                		<td><label for="R_SUP_ORG_ID">사업자등록번호</label></td>
	                        <td><span id="R_SUP_ORG_ID">&nbsp;</span></td>
	                	</tr>
	                	<tr>
	                        <td ><label for="R_SUP_ADDR">주소</label></td>
	                        <td colspan="5"><span id="R_SUP_ADDR">&nbsp;</span></td>
	                	</tr>
	                	<tr>
	                        <td><label for="R_SUP_EMAIL">이메일주소</label></td>
	                        <td colspan="5"><span id="R_SUP_EMAIL">&nbsp;</span></td>
	                    </tr>
                    </tbody>
                </table>
                </div>
         	</div>
         	<div class="title_frame">
         		<p><a href="#" class="btnToggle_table">수출신고필증 정보(외화획득용 원료.기재라는 사실을 증명하는 서류)</a></p>
          		<div class="list_typeB table_toggle">
          		    <div class="util_left64">
		                <p class="total">Total <span id="totViewBaseDocCnt"></span>
		            </div>    
                	<div id="gridViewBaseDocLayer" style="height: 150px;"></div>
                </div>
            </div>
            <div class="title_frame">
                <p><a href="#" class="btnToggle_table">구매물품 목록(수출신고필증을 등록하면 자동으로 구매물품 등록)</a></p>
                <div class="table_typeA gray table_toggle">
                <table style="table-layout:fixed;">
                    <caption class="blind">구매물품 목록</caption>
                    <colgroup>
                        <col width="13%" />
                        <col width="37%" />
                        <col width="15%" />
                        <col width="35%" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <td><label for="R_TOT_QTY">총수량</label><label for="R_QTY_UNIT" style="display: none">단위</label></td>
                            <td><span id="R_TOT_QTY"></span>&nbsp;<span id="R_QTY_UNIT"></span></td>
                            <td><label for="R_TTOT_ALLOW_CHARGE_INDI_NM">총 할인/할증/변동내역</label></td>
                            <td><span id="R_TOT_ALLOW_CHARGE_INDI_NM"></span></td>
                        </tr>
                        <tr>
                            <td><label for="R_TOT_AMT">총금액</label><label for="R_CURRENCY" style="display: none">통화</label></td>
                            <td><span id="R_TOT_AMT"></span>&nbsp;<span id="R_CURRENCY"></span></td>
                            <td><label for="R_TOT_ALLOW_CHARGE_AMT">총 할인/할증/변동금액</label></td>
                            <td><span id="R_TOT_ALLOW_CHARGE_AMT"></span></td>
                        </tr>
                        <tr>
                            <td><label for="R_TOT_USD_AMT">총금액(USD금액부기)</label></td>
                            <td><span id="R_TOT_USD_AMT"></span></td>
                            <td><label for="R_TOT_ALLOW_CHARGE_USD_AMT">총 할인/할증/변동금액(USD)</label></td>
                            <td><span id="R_TOT_ALLOW_CHARGE_USD_AMT"></span></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <div class="list_typeB table_toggle">
                	<div class="util_left64">
		                <p class="total">Total <span id="totViewItemCnt"></span>
		            </div> 
                	<div id="gridViewItemLayer" style="height: 150px;"></div>
                </div>
          </div>
          <div class="title_frame">
          	<p><a href="#" class="btnToggle_table">세금계산서 내용(외화획득용 원료.기재를 구매한 자가 신청하는 경우에만 해당)</a></p>  
            <div class="list_typeB table_toggle">
                <div class="util_left64">
		        	<p class="total">Total <span id="totViewTaxInvoiceCnt"></span>
		        </div> 
            	<div id="gridViewTaxInvoiceLayer" style="height: 150px;"></div>
            </div>
          </div>
		  <div class="title_frame">
                <p><a href="#" class="btnToggle_table">확인기관</a></p>  
                <div class="table_typeA gray table_toggle">
                <table style="table-layout:fixed;">
                    <caption class="blind">확인기관</caption>
                    <colgroup>
                        <col width="10%" />
                        <col width="25%" />
                        <col width="10%" />
                        <col width="25%" />
                        <col width="10%" />
                        <col width="25%" />
                    </colgroup>
                    <tr>
                        <td>코드</td>
                        <td><span id="R_CONF_ORG_ID"></span></td>
                        <td>기관명</td>
                        <td><span id="R_CONF_ORG_NM"></span></td>
                        <td>지점명</td>
                        <td><span id="R_CONF_BR_ORG_NM"></span></td>
                    </tr>
                </table>
                </div>
          </div>
          <div class="title_frame">
                <p><a href="#" class="btnToggle_table">전자서명</a></p>  
                <div class="table_typeA gray table_toggle">
                <table style="table-layout:fixed;">
                    <caption class="blind">전자서명</caption>
                    <colgroup>
                        <col width="10%" />
                        <col width="25%" />
                        <col width="10%" />
                        <col width="25%" />
                        <col width="10%" />
                        <col width="25%" />
                    </colgroup>
                    <tr>
                        <td>상호</td>
                        <td><span id="R_APP_SIGN_ORG_NM"></span></td>
                        <td>대표자명</td>
                        <td><span id="R_APP_SIGN_ORG_CEO_NM"></span></td>
                        <td>전자서명</td>
                        <td><span id="R_APP_SIGN_VALUE"></span></td>
                    </tr>
                </table>
                </div>
          </div>

       </div>
    </form>
    
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
