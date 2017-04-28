<%--
    Class Name : pcrList.jsp
    Description : 구매확인서 목록 조회
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-03  정안균   최초 생성

    author : 정안균
    since : 2017-02-03
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var gridWrapper, headers, docStatSearch = false;
        $(function (){
            headers = [
				{"HEAD_TEXT": "문서번호"                  , "WIDTH": "170", "FIELD_NAME": "DOC_ID", "LINK":"fn_detail"},       
                {"HEAD_TEXT": "신청구분"                  , "WIDTH": "60" , "FIELD_NAME": "REQ_TYPE_NM"},
                {"HEAD_TEXT": "공급자상호"                , "WIDTH": "130", "FIELD_NAME": "SUP_ORG_NM"},
                {"HEAD_TEXT": "공급자사업자번호"          , "WIDTH": "110", "FIELD_NAME": "SUP_ORG_ID"},
                {"HEAD_TEXT": "총수량"                    , "WIDTH": "120", "FIELD_NAME": "TOT_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "총금액"                    , "WIDTH": "120", "FIELD_NAME": "TOT_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "상태"                      , "WIDTH": "60" , "FIELD_NAME": "DOC_STAT_NM", "HTML_FNC":"fn_noticeLink"},
                {"HEAD_TEXT": "변경/취소전 구매확인서번호", "WIDTH": "170", "FIELD_NAME": "BEF_PCR_LIC_ID"},
                {"HEAD_TEXT": "등록일자"                  , "WIDTH": "80" , "FIELD_NAME": "REG_DTM", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "수정일자"                  , "WIDTH": "80" , "FIELD_NAME": "MOD_DTM", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "확인기관명"                , "WIDTH": "100", "FIELD_NAME": "CONF_ORG_NM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "구매확인서신청 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "pcr.selectPcrLicList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "postScript"   : function (){
                					var docStat = $('#DOC_STAT').val();
                					if(docStat && (docStat == 'D1' || docStat == 'P4_N' || docStat == 'P4_M')) {
                						docStatSearch = true;
                					} else {
                						docStatSearch = false;
                					}
                				 },
                "check"        : true,
                "firstLoad"    : false,
                "defaultSort"  : "DOC_ID DESC",
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel", "type": "D", "targetURI":"/pcr/deletePcrLicList.do", "preScript": fn_deleteValid},
                    {"btnName": "btnExcel", "type": "EXCEL", "qKey":"pcr.selectPcrLicListAll"}
                ]
            });
			
            if($.comm.getGlobalVar("IS_COPY")) {
            	gridWrapper.PAGE_INDEX = 0;
            	$.comm.removeGlobalVar("IS_COPY");
            }
            gridWrapper.requestToServer();            

            // 구매확인서 신규
            $('#btnNew').on("click", function (e) {
                var params = {"BTN_TYPE":"NEW"};
                $.comm.forward("pcr/pcrDetail",params);
            })
            
            // 구매확인서 수정
            $('#btnEdit').on("click", function (e) {
            	var size = gridWrapper.getSelectedSize();
            	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
            	if(size > 1) {
            		alert("항목을 한개만 선택하세요");
                    return;
            	}
            	
            	var dataList = gridWrapper.getSelectedRows();
            	var data = dataList[0];
            	var docParam = {
 	                    "qKey": "pcr.selectPcrLicStat",
 	                    "BEF_DOC_ID":data.DOC_ID
 	            };
 	            var data = $.comm.sendSync("/common/select.do", docParam, '구매확인서 상태 조회').data;
 	            if(data) {
 	            	var docStat = data["DOC_STAT"];
 	            	if(docStat && (docStat != "A2" && docStat != "G1")) {
                   		alert("전송중 또는 전송 이후 상태는 수정할 수 없습니다.");
                   		return;
                   	}
 	            }
 	            
            	var params = {"BTN_TYPE":"EDIT", "DOC_ID":data.DOC_ID};
                $.comm.forward("pcr/pcrDetail",params);
            	
            })
            
            // 이력조회
            $('#btnHistory').on("click", function (e) {
            	var size = gridWrapper.getSelectedSize();
            	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
            	if(size > 1) {
            		alert("항목을 한개만 선택하세요");
                    return;
            	}
            	var dataList = gridWrapper.getSelectedRows();
            	var data = dataList[0];
            	var spec = "windowname:pcrBtnHistory;dialogWidth:970px;dialogHeight:600px;scroll:yes;status:no;center:yes;resizable:yes;";
                // 모달 호츨
                $.comm.setModalArguments({"DOC_ID" : data.DOC_ID, "PCR_LIC_ID" : data.PCR_LIC_ID, "BEF_PCR_LIC_ID" : data.BEF_PCR_LIC_ID}); // 모달 팝업에 전달할 인자 지정
                $.comm.dialog("<c:out value='/jspView.do?jsp=/pcr/pcrHistoryListPopup' />", spec,
                    function () { // 리턴받을 callback 함수
                        var ret = $.comm.getModalReturnVal();
                    	if(ret) {
                    		
                    	}
                        
                    }
                );
            })
            
            // 전송
            $('#btnSend').on("click", function (e) {
            	var size = gridWrapper.getSelectedSize();
            	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
            	
            	if(!fn_chkStatus("SEND")) {
            		return;
            	}
            	
            	var docIdList = [];
            	
            	var idendtifyId = fn_getIdentifier("ECP");
            	if(!idendtifyId) {
            		alert($.comm.getMessage("00000064"), "식별자"); //식별자가 존재하지 않습니다.
            		return;
            	}
            	
            	var rows = gridWrapper.getSelectedRows();
            	for(var i=0; i < rows.length; i++) {
            		rows[i]["REQ_KEY"] = rows[i]["DOC_ID"]
            		rows[i]["SNDR_ID"] = idendtifyId;
            		rows[i]["RECP_ID"] = "EKTNET";
            		var reqType = rows[i]["REQ_TYPE"];
            		if(reqType == "N") {
            			rows[i]["DOC_TYPE"] = "APPPCR2CG";
            		} else {
            			rows[i]["DOC_TYPE"] = "APPPCR2CH";
            		} 
            	}
 
                $.comm.send("/pcr/savePcrSend.do", rows, fn_callback, "구매확인신청서 전송");
            })
            
            // 출력
            $('#btnPrint').on("click", function (e) {
            	if(!docStatSearch) {
            		alert("상태조건을 전송완료/발급완료/변경완료 중 선택하고\n먼저 조회를 하십시오.");
            		return;
            	}
            	var size = gridWrapper.getSelectedSize();
            	if(size < 1) {
            		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                    return;
                }
            	var gridSelectedRows = gridWrapper.getSelectedRows();
            	var params = {};
            	var cnt = 0;
            	$.each (gridSelectedRows, function(index, data) {
            		cnt = cnt + 1;
            		params["KEY." + cnt] = data["DOC_ID"];
                   
                });
            	var reportFile = '';
            	var actNm = '';
            	var docStat = $('#DOC_STAT').val();
            	if(docStat && docStat == 'D1') {
            		reportFile = "APPPCR";
            		actNm = "구매확인신고서 출력";
            	} else if(docStat == 'P4_N' || docStat == 'P4_M') {
            		reportFile = "PCRLIC";
            		actNm = "구매확인서 출력";
            	}
        		if(cnt > 1) {
        			fnMultiReportPrint(reportFile, params, actNm, cnt); 
        		} else {
          			params["KEY"] = params["KEY.1"];
        			fnReportPrint(reportFile, params, actNm);
        		}
            })
            
        });
        
        function fn_deleteValid(e) {
        	var size = gridWrapper.getSelectedSize();
        	if(size < 1) {
        		alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return false;
            }
        	
        	if(!fn_chkStatus()) {
        		return false;
        	}
        	return true;
        }

        // 상태 체크
        function fn_chkStatus(type) {
        	var selectDataList = gridWrapper.getSelectedRows();
        	var docId = [];
        	for(var i=0; i < selectDataList.length; i++) {
           		docId = selectDataList[i]["DOC_ID"];
           		if(type && type == 'SEND') {
     	            var docParam = {
     	                    "qKey": "pcr.selectPcrLicSendDocList",
     	                    "DOC_ID":docId
     	            };
     	            var docDataList = $.comm.sendSync("/common/selectList.do", docParam, '구매확인서 수출신고필증 조회').dataList;
     	            if(!docDataList || docDataList.length < 1) {
    	            	alert("수출신고필증 목록이 존재하지 않습니다. 구매확인서신청 상세화면에서 등록해 주십시오.");
    	            	return false;
    	            }
     	            for(var idx in docDataList) {
      	            	var shipDt = docDataList[idx]["SHIP_DT"];
     	            	if(!shipDt) {
     	    				alert("문서번호[" + docId + "]는 수출신고필증 목록에서 선적일자가 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
     	    				return false;
     	    			}
     	            }
     	            
     	           var param = {
                           "qKey": "pcr.selectPcrLicSendItemList",
                           "DOC_ID":docId
                   };
                   var dataList = $.comm.sendSync("/common/selectList.do", param, '구매물품목록 상태조회').dataList;
                   for(var idx in dataList) {
	               		var docId = dataList[idx]["DOC_ID"];
	               		var docStat = dataList[idx]["DOC_STAT"];
	               		var pcrDt = dataList[idx]["PCR_DT"];
	               		var hsId = dataList[idx]["HS_ID"];
	               		var itemNm = dataList[idx]["ITEM_NM"];
	               		var itemAmt = dataList[idx]["ITEM_AMT"];
	               		var totalCurrency = dataList[idx]["CURRENCY"];
	               		var itemCurrency = dataList[idx]["ITEM_CURRENCY"];
	               		var issueDt = dataList[idx]["TAX_INFO"];
	               		if(idx < 1) {
	               			if(docStat != "A2" && docStat != "B2" && docStat != "G1" &&
	    	                		docStat != "G2" && docStat != "G3" && docStat != "G4" && docStat != "G5") {
	    	                		alert("문서번호[" + docId + "]는 전송할 수 없는 상태입니다.\n작성완료, 승인, 변환실패, 전송실패 문서만 전송할 수 있습니다.");
	    	                		return false;
	    	                } 
	               		}
	               		
	               		if(!hsId) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\nHS부호가 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		}
	               		
	               		if(!itemNm) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\n품목이 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		}
	               		
	               		if(!pcrDt) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\n구매일자가 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		} 
	               		
	               		if(!itemAmt) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\n금액이 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		}
	               		
	               		if(!itemCurrency) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\n통화단위가 입력되어 있지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		}
	               		
	               		if(totalCurrency != itemCurrency) {
	               			alert("문서번호[" + docId + "]는 구매물품 목록에서\n통화단위가 총금액 통화단위와 일치하지 않습니다.\n구매확인서신청 상세화면에서 저장해 주십시오.");
	               			return false;
	               		}

                    }
                    if(!fn_chkTaxValidation(docId, issueDt)) return false;
                } else {
                	var docParam = {
     	                    "qKey": "pcr.selectPcrLicStat",
     	                    "BEF_DOC_ID":docId
     	            };
     	            var data = $.comm.sendSync("/common/select.do", docParam, '구매확인서 상태 조회').data;
     	            if(data) {
     	            	var docStat = data["DOC_STAT"];
     	            	if(docStat != "A2" && docStat != "B1" &&
     	                	docStat != "B2" && docStat != "B3" && docStat != "G1" && docStat != "G2" ) {
     	                   	var msgParam = "문서번호[" + docId + "]";
     	                    alert($.comm.getMessage("W00000037", msgParam)); // 문서번호["00000"]는 전송중 또는 전송완료된 이후에는 삭제할 수 없습니다.
     	                    return false;
     	                }
     	            }
                	
                }
        	}
            return true;
        }

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            data["BTN_TYPE"] = "LINK";

            $.comm.forward("pcr/pcrDetail", data);
        }
        
     	// 오류 및 취소통보 링크
        function fn_noticeLink(index, val) {
            var data = gridWrapper.getRowData(index);
            if (data["DOC_STAT"] == "95" || data["DOC_STAT"] == "E2") {
                return "<a href='#this' onclick='gfn_gridLink(\"fn_showNoticeList\", \"" + (index) + "\")'><span style='color:red'>" + data["DOC_STAT_NM"] + "</span></a>";
            } else {
                return "<span style='color:green'>" + data["DOC_STAT_NM"] + "</span>";
            }
        }
     	
        // 오류내용 팝업 (upload)
        function fn_showNoticeList(index) {
            var data = gridWrapper.getRowData(index);
            $.comm.setModalArguments({"DOC_ID":data["DOC_ID"], "DOC_STAT":data["DOC_STAT"]});
            var spec = "windowname:pcrSendNoticePopup;width:880px;height:530px;scroll:auto;status:no;center:yes;resizable:yes;";
            $.comm.dialog('<c:out value="/jspView.do?jsp=pcr/pcrSendNoticePopup" />', spec); // 모달 호츨
        }
             
        function fn_getIdentifier(type) {
        	var returnData = "";
        	var param = {
        			"qKey": "pcr.selectCmmIdentifier",
        			"TYPE": type
        	};
        	var data = $.comm.sendSync("/common/select.do", param, '구매확인서 식별자 조회').data;
        	if(data) {
        		returnData = data.IDENTIFY_ID;
        	}
        	return returnData;
        }
        
        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
            	gridWrapper.requestToServer();
            }
        }

        function fn_chkTaxValidation(docId, issueDt) {
        	var nowDate = $.date.currdate("YYYYMMDD"); //오늘날짜
        	var holidayDiv = ''; //휴일구분
        	var minPcrDt = '';   //구매물품 목록중 가장 빠른 구매일자
        	var maxPcrDt = '';   //구매물품 목록중 가장 느린 구매일자
        	var minShipDt = '';  //수출신고필증 목록중 가장 빠른 선적일자
        	var maxShipDt = '';  //수출신고필증 목록중 가장 느린 선적일자
        	var nowDate2 = nowDate.toDate("YYYYMMDD");
        	var holidayParams = {"qKey":"pcr.selectHolidayDiv", "dbPoolName":"trade",
        					 "DOC_ID": docId, "YEAR":nowDate2.getFullYear() + '', "MONTH":(nowDate2.getMonth() + 1) + '', "DAY":nowDate2.getDate() + ''};
        	var holidayData = $.comm.sendSync("/common/select.do", holidayParams).data;
        	if(holidayData) {
        		holidayDiv = holidayData["DIV"];
        	}
        	
        	var params = {"qKey":"pcr.selectPcrDtAndShipDt", "DOC_ID": docId};
	       	var resultData = $.comm.sendSync("/common/select.do", params).data;
	       	if(resultData) {
	       		minPcrDt = resultData["MIN_PCR_DT"]?resultData["MIN_PCR_DT"]:'';
	       		maxPcrDt = resultData["MAX_PCR_DT"]?resultData["MAX_PCR_DT"]:'';
	       		minShipDt = resultData["MIN_SHIP_DT"]?resultData["MIN_SHIP_DT"]:'';
	       		maxShipDt = resultData["MAX_SHIP_DT"]?resultData["MAX_SHIP_DT"]:'';
	       	}
        	
        	// 구매물품 목록중 가장 빠른 구매일자의 익월 10일 (예: 20170125 -> 20170210)
        	var minPcrDt_nextMonth_10 = new Date(minPcrDt.substring(0,4),minPcrDt.substring(4,6), 10).format("YYYYMMDD"); 
        	var beforeMonth_10 = new Date(nowDate.substring(0,4),nowDate.substring(4,6), 10).format("YYYYMMDD"); // 오늘날짜의지난월 10일
			if(minPcrDt_nextMonth_10) {
				if (minPcrDt_nextMonth_10 < nowDate) {
	        		if(!issueDt) {
	        			if (holidayDiv == "" ) {
							alert("문서번호[" + docId + "]는 구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록해주세요.");
							return false;
						} else if (holidayDiv != "" && holidayDiv != "10A" && holidayDiv != "10") {
							alert("문서번호[" + docId + "]는 구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록 해주세요.");
							return false;
						} else if (holidayDiv != "" && (holidayDiv == "10A" || holidayDiv == "10") ) {
							// 현재일자의 지난달 10일 보다 세금계산서의 익월 10일이 작을경우 마감일시간(10)이나 휴일(10A)이라도 세금계산서 있어야함
							if ( minPcrDt_nextMonth_10 < beforeMonth_10 ) {
								alert("문서번호[" + docId + "]는 구매일 기준으로 익월 10일 이후 입력할 경우 세금계산서 내역 입력이 필수입니다.  \n세금계산서 정보를 등록 해주세요.");
								return false;
							}
						}
	        		}
	        		
	        	}
	        	if(minShipDt && maxShipDt) {
	        		if(minPcrDt > minShipDt || maxPcrDt > maxShipDt){
						alert("문서번호[" + docId + "]의 구매일은 선적기일 이후일 수 없습니다.\n구매물품 목록의 구매일자와 수출신고필증 정보의 선적기일을 확인해주시기 바랍니다.");
						return false;
					}
	        	}
			}
        	return true;
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
	                        <label for="SEARCH_DTM" class="search_title">조회기간</label>
	                        <label for="F_DTM" class="search_title" style="display: none">조회기간</label>
	                        <label for="T_DTM" class="search_title" style="display: none">조회기간</label>
	                        <select id="SEARCH_DTM" name="SEARCH_DTM" class="search_input_select before_date" <attr:changeNoSearch/>>
	                            <option value="REG_DTM" selected>등록일자</option>
	                            <option value="MOD_DTM">수정일자</option>
	                        </select>
	                        <div class="search_date">
	                            <form action="#">
	                                <fieldset>
	                                    <legend class="blind">달력</legend>
	                                    <input type="text" id="F_DTM" name="F_DTM" class="input" <attr:datefield to="T_DTM" value="-1m"/> />
	                                    <span>~</span>
	                                    <input type="text" id="T_DTM" name="T_DTM" class="input" <attr:datefield  value="0"/>/>
	                                </fieldset>
	                            </form>
	                        </div>
	                    </li>
	                    <li>
	                        <label for="DOC_STAT" class="search_title">상태조건</label>
	                        <select id="DOC_STAT" name="DOC_STAT" class="search_input_select inputHeight">
	                            <option value="">전체</option>
			    				<option value="A2">작성완료</option>
			    				<option value="C1">전송중</option>
			    				<option value="D1">전송완료</option>
			    				<option value="G1">전송실패</option>
			    				<option value="P4_N">발급완료</option>
			    				<option value="P4_M">변경완료</option>
			    				<option value="95">취소완료</option>
			    				<option value="E2">오류통보</option>
	                        </select>
	                    </li>
	                    <li>
	                        <label for="SEARCH_COL" class="search_title">조회조건</label>
	                        <label for="SEARCH_TXT" class="search_title" style="display: none">조회기간</label>
	                        <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
	                            <option value="SUP_ORG_NM" selected>공급자상호</option>
	                            <option value="SUP_ORG_ID">공급사사업자번호</option>
	                            <option value="DOC_ID">문서번호</option>
	                            <option value="BEF_PCR_LIC_ID">변경/취소전 구매확인서번호</option>
	                        </select>
	                        <input type="text" name="SEARCH_TXT" id="SEARCH_TXT" class="search_input inputHeight"/>
	                    </li>
	                </ul><!-- search_sectionC -->
	                <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
	            </form>
	        </div><!-- search_frame -->
	        <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
                <a href="#" class="btn white_100" id="btnExcel">엑셀다운로드</a>
                <a href="#" class="btn white_84" id="btnPrint">출력</a>
                <a href="#" class="btn white_84" id="btnHistory">이력조회</a>
                <a href="#" class="btn white_84" id="btnSend">전송</a>
                <a href="#" class="btn white_84" id="btnDel">삭제</a>
                <a href="#" class="btn white_84" id="btnEdit">수정</a>
                <a href="#" class="btn white_84" id="btnNew">신규</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 400px">
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