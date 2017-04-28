<%--
  User: jinhokim
  Date: 2017-01-10
  Form: 반품수입신고의뢰 상세조회
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var reqNo = "${REQ_NO}";	// 최초 파라미터 전달 값, 이후 저장 시 갱신됨
    
    var gridWrapper, headers;
    var fileUtil;
    var prevData;	// 최종 조회 값
    
    $(function (){
    	$.comm.bindCombos.addComboInfo("SUP_ST", "CUS0005", true);
    	$.comm.bindCombos.addComboInfo("IMP_DIVI", "CUS1072", true);
    	$.comm.bindCombos.addComboInfo("CUS", "CUS0015", true);
    	$.comm.bindCombos.addComboInfo("SEC", "CUS0004", true);
    	$.comm.bindCombos.addComboInfo("RPT_DIVI_MARK", "CUS1067", true);
    	
    	$.comm.bindCombos.addComboInfo("EXC_DIVI_MARK", "CUS1056", true);
    	$.comm.bindCombos.addComboInfo("IMP_KI_MARK", "CUS1078", true);
    	$.comm.bindCombos.addComboInfo("LEV_FORM", "CUS1120", true);
    	$.comm.bindCombos.addComboInfo("ORI_ST_PRF_YN", "CUS1100", true);
    	$.comm.bindCombos.addComboInfo("AMT_RPT_YN", "YN", true);
    	$.comm.bindCombos.addComboInfo("FOD_ST_ISO", "CUS0005", true);
    	
    	$.comm.bindCombos.addComboInfo("ARR_MARK", "CUS0046", true);
    	$.comm.bindCombos.addComboInfo("TRA_MET", "CUS0034", true);
    	$.comm.bindCombos.addComboInfo("TRA_CTA", "CUS0035", true);
    	$.comm.bindCombos.addComboInfo("SHIP_ST_ISO", "CUS0005", true);
    	$.comm.bindCombos.addComboInfo("TOT_PACK_UT", "CUS0043", true);
    	
    	$.comm.bindCombos.addComboInfo("CON_COD", "CUS0038", true);
    	$.comm.bindCombos.addComboInfo("CON_CUR", "CUS0042", true);
    	$.comm.bindCombos.addComboInfo("CON_KI", "CUS0003", true);
    	
    	$.comm.bindCombos.draw();
    	
    	$.comm.bindCustCombo('RPT_MARK', "imp.selectCustoms", true);
    	
    	headers = [
			{"HEAD_TEXT" : "수출신고번호", "WIDTH" : "120", "FIELD_NAME" : "EXP_RPT_NO"},
			{"HEAD_TEXT" : "란", "WIDTH" : "40",  "FIELD_NAME" : "EXP_RAN_NO"},
			{"HEAD_TEXT" : "규격", "WIDTH" : "40",  "FIELD_NAME" : "EXP_SIL"},
			{"HEAD_TEXT" : "HS부호", "WIDTH" : "100",  "FIELD_NAME" : "HS_NO"},
			{"HEAD_TEXT" : "규격수량", "WIDTH" : "80", "FIELD_NAME" : "QTY", "ALIGN":"right"},
			{"HEAD_TEXT" : "반품수량", "WIDTH" : "80", "FIELD_NAME" : "USE_QTY", "FIELD_TYPE":"NUM"},
			{"HEAD_TEXT" : "관세면제", "WIDTH" : "60", "FIELD_NAME" : "GS_YN", "FIELD_TYPE" : "CMB", "COMBO" : [{"code":'N', "value":'N'}, {"code":'Y', "value":'Y'}]},
			{"HEAD_TEXT" : "부가세면제", "WIDTH" : "70", "FIELD_NAME" : "VAT_YN", "FIELD_TYPE" : "CMB", "COMBO" : [{"code":'N', "value":'N'}, {"code":'Y', "value":'Y'}]},
			{"HEAD_TEXT" : "수출국", "WIDTH" : "50",  "FIELD_NAME" : "ORI_ST_MARK1"},
			{"HEAD_TEXT" : "거래품명", "WIDTH" : "250",  "FIELD_NAME" : "MODEL_DESC"},
			{"HEAD_TEXT" : "중량", "WIDTH" : "80",  "FIELD_NAME" : "SUN_WT", "ALIGN":"right"},
			{"HEAD_TEXT" : "단가", "WIDTH" : "100", "FIELD_NAME" : "PRICE", "ALIGN":"right"},
			{"HEAD_TEXT" : "금액", "WIDTH" : "100", "FIELD_NAME" : "AMT", "ALIGN":"right"}
		];

		gridWrapper = new GridWrapper({
			"actNm" : "수출신고 모델조회(반품수입신고의뢰상세)",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectImpReqItem",
			"requestUrl" : "/imp/selectImpReqItemList.do",
			"headers" : headers,
			"check" : true,
			"firstLoad" : false, 
            "controllers"  : [
				{
					"btnName": "btn_del", "type": "D", "targetURI":"/imp/deleteImpReqItems.do",  
					"preScript" : function(obj) {
		            	if($('#STATUS').text() == '수리') {
		            		alert($.comm.getMessage("W00000045", '수출신고 모델규격 삭제'));
		            		
		            		return false;
		            	}
	
		                return true;
		            }
				}
			]			
		});
               
		function loadFileData() {
            fileUtil.setAtchFileId(prevData['ATCH_FILE_ID']);
            fileUtil.selectFileList({"ATCH_FILE_ID" : prevData['ATCH_FILE_ID']}); // 첨부파일 목록 조회
		}
		
        fileUtil = new FileUtil({
            "gridDiv" : "gridWrapLayer", 
            "addBtnId" : "btn_file_add", 
            "delBtnId" : "btn_file_del", 
            "downloadFn"  : function(rIdx) {
            	fileUtil.fileDownload(rIdx);
            }, 
            "preAddScript" : function(obj) {
            	if($('#STATUS').text() == '수리') {
            		alert($.comm.getMessage("W00000045", '첨부파일 추가'));
            		
            		return false;
            	}
            	
				if(!reqNo){
                    alert($.comm.getMessage("W00000035"));// 상세정보를 먼저 저장하세요.
                    return false;
                } else {
                    fileUtil.addParam("REQ_NO", reqNo);
                }

                return true;
            },
            "preDelScript" : function(obj) {
            	if($('#STATUS').text() == '수리') {
            		alert($.comm.getMessage("W00000045", '첨부파일 삭제'));
            		
            		return false;
            	}

            	fileUtil.addParam("REQ_NO", reqNo);
            	
                return true;
            },            
			"successCallback" : function(rst) {
				prevData["ATCH_FILE_ID"] = rst.data["ATCH_FILE_ID"];
				loadFileData();
            },
            "postService"  : "impService.saveImpReqFile", 
            "postDelScript" : function() {
				prevData["ATCH_FILE_ID"] = "";
				loadFileData();
            }
        });  

        function loadData() {
            $.comm.send(
            		"/imp/selectImpReq.do", 
            		{"qKey" : "imp.selectImpReq", "REQ_NO" : reqNo}, 
    	       		function(data, status){
            			prevData = data.data;
    					$.comm.bindData(prevData);
    					
    					if(prevData['ATCH_FILE_ID']) loadFileData();
    					gridWrapper.addParam("REQ_NO", reqNo);
    					
    					gridWrapper.requestToServer();
    				}, "반품수입신고의뢰 상세조회"
    		);
        }

        if(reqNo) {
        	loadData();
        } else {	// 세션정보 셋팅
        	$('#REQ_NO').text('저장시 자동생성');
        	$('#STATUS').text('신규');
        	$('#SELLER_ID').text('${session.userId}');
        	$('#IMP_FIRM').text('${session.userNm}');
        	$('#IMP_TGNO').text('${session.tgNo}');
        	$('#IMP_DIVI').text('A');
        	$('#NAB_FIRM').text('${session.userNm}');
        	$('#NAB_NAME').text('${session.repNm}');
        	$('#NAB_PA_MARK').text('${session.zipCd}');
        	$('#NAB_ADDR').text('${session.address}');
        	$('#NAB_TGNO').text('${session.tgNo}');
        	$('#NAB_SDNO').text('${session.bizNo}');
        	$('#NAB_TELNO').text('${session.telNo}');        	
        	$('#NAB_EMAIL').text('${session.email}');        	
        	
        	$('#FRE_UT').text('KRW');
        	$('#INSU_UT').text('KRW');   
        	$('#ADD_UT').text('KRW');   
        	$('#SUB_UT').text('KRW');   
        }
      
        $('#btn_save').on("click", function (e) {
        	if($('#STATUS').text() == '수리') {
        		alert($.comm.getMessage("W00000045", '저장'));
        		
        		return;
        	}
        	
        	// 수출신고 모델규격 체크
        	var data = gridWrapper.getUpdateData();
			for(var i in data) {
				if(!data[i]['USE_QTY'] || Number(data[i]['USE_QTY']) < 1) {
					alert('반품수량을 0보다 큰 값이어야 합니다.');
					return;
				}
				
				if(Number(data[i]['QTY']) < Number(data[i]['USE_QTY'])) {
					alert('반품수량은 규격수량보다 클 수 없습니다.');
					return;
				}
			}
        	
        	var addParams = {
        			"REQ_NO" : reqNo,
        			"STATUS" : $('#STATUS').text(),
        			"SELLER_ID" : $('#SELLER_ID').text(),
        			"IMP_FIRM" : $('#IMP_FIRM').text(), 
        			"IMP_TGNO" : $('#IMP_TGNO').text(), 
        			"IMP_DIVI" : $('#IMP_DIVI').text(), 
        			"NAB_FIRM" : $('#NAB_FIRM').text(), 
        			"NAB_NAME" : $('#NAB_NAME').text(), 
        			"NAB_PA_MARK" : $('#NAB_PA_MARK').text(), 
        			"NAB_ADDR" : $('#NAB_ADDR').text(), 
        			"NAB_TGNO" : $('#NAB_TGNO').text(), 
        			"NAB_SDNO" : $('#NAB_SDNO').text(), 
        			"NAB_TELNO" : $('#NAB_TELNO').text(), 
        			"NAB_EMAIL" : $('#NAB_EMAIL').text(), 
        			"FRE_UT" : $('#FRE_UT').text(), 
        			"INSU_UT" : $('#INSU_UT').text(), 
        			"ADD_UT" : $('#ADD_UT').text(), 
        			"SUB_UT" : $('#SUB_UT').text(), 
        			"MODEL_ITEMS" : data, 
        			"ERR_MSG" : $.comm.getMessage("W00000045", '저장')	// 수리건 체크 
        	};

        	$.comm.sendForm("/imp/saveImpReq.do", "detailForm", 
        			function(rst){
        				if(rst && rst['code'] && rst['code'].indexOf('I') == 0) {
	        				reqNo = rst.data['REQ_NO'];
	        				loadData();
        				}
        			}, 
        			"수출신고 저장", function() {}, false, addParams);
        });
        
        $('#btn_mail').on("click", function (e) {
        	if(!reqNo) {
        		alert($.comm.getMessage("W00000035"));
        		
        		return;
        	}
        	
        	if($('#STATUS').text() == '수리') {
        		alert($.comm.getMessage("W00000045", '의뢰메일전송'));
        		
        		return;
        	}
        	
        	var addParams = {
        			"REQ_NO" : reqNo, 
        			"IMP_FIRM" : $('#IMP_FIRM').text(), 
        			"NAB_TELNO" : $('#NAB_TELNO').text(), 
        			"ERR_MSG" : $.comm.getMessage("W00000045", '의뢰메일전송')	// 수리건 체크 
        	};

        	$.comm.sendForm("/imp/sendImpReq.do", "detailForm", function(){}, "수출신고 의뢰메일전송", function() {}, false, addParams);
        });        
        
        $('#btn_down').on("click", function (e) {
        	if(!reqNo) {
        		alert($.comm.getMessage("W00000035"));
        		
        		return;
        	}
        	
        	if($('#STATUS').text() == '수리') {
        		alert($.comm.getMessage("W00000045", '의뢰파일다운로드'));
        		
        		return;
        	}
        	
        	$.comm.fileDownload({"REQ_NO" : reqNo}, "수출신고 의뢰파일다운로드", "/imp/downloadImpReq.do");
        });
        
        $('#btn_list').on("click", function (e) {
            $.comm.pageBack();
        });
        
        $('#btn_add').on("click", function (e) {
        	if(!reqNo) {
        		alert($.comm.getMessage("W00000035"));
        		
        		return;
        	}
        	
        	if($('#STATUS').text() == '수리') {
        		alert($.comm.getMessage("W00000045", '수출신고 모델규격 추가'));
        		
        		return;
        	}
        	
            $.comm.setModalArguments({"REQ_NO" : reqNo, "FOD_ST_ISO" : $('#FOD_ST_ISO').val()});
            var spec = "width:1100px;height:800px;scroll:auto;status:no;center:yes;resizable:yes;windowName:a";
            $.comm.dialog("/jspView.do?jsp=exp/imp/impReqDetailPopup", spec,
                function () { 
					var ret = $.comm.getModalReturnVal();
                    gridWrapper.requestToServer();
                }
            );
        });
    });
    </script>
</head>
<body>
<div class="inner-box">
    <form autocomplete="off" id="detailForm" name="detailForm" method="post">
    <div class="padding_box">
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>상세정보</p>
                <div class="title_btn_inner">
                    <a href="#" class="title_frame_btn" id="btn_list">목록</a>                       
                    <a href="#" class="title_frame_btn" id="btn_save">저장</a>   
                    <a href="#" class="title_frame_btn" id="btn_down">의뢰파일다운로드</a>
                    <a href="#" class="title_frame_btn" id="btn_mail">의뢰메일전송</a>
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td>
                            <label>의뢰관리번호/상태</label>
                            <label for="REQ_NO" style="display: none;">의뢰관리번호</label>
                            <label for="STATUS" style="display: none;">상태</label>
                        </td>
                        <td><span id="REQ_NO" <attr:mandantory/>></span> / <span id="STATUS" <attr:mandantory/>></span></td>
                        <td><label for="ORDER_ID">주문번호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="ORDER_ID" id="ORDER_ID" <attr:length value="50" />  <attr:mandantory/>/></td>
                        <td><label for="RPT_MARK">의뢰관세사부호</label></td>
                        <td><select class="td_select inputHeight" id="RPT_MARK" name="RPT_MARK" <attr:mandantory/>></select></td>                        
                    </tr>
                    <tr>
                        <td><label for="SELLER_ID">판매자 ID</label></td>
                        <td><span id="SELLER_ID" <attr:mandantory/>></span></td>
                        <td><label for="LIS_DAY">수리일자</label></td>
                        <td><span id="LIS_DAY"></span></td>
                        <td><label for="RPT_NO">수입신고번호</label></td>
                        <td><span id="RPT_NO"></span></td>                        
                    </tr> 
                    <tr>
                        <td><label for="BLNO">B/L 번호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="BLNO" id="BLNO" <attr:length value="20" /> <attr:mandantory/>/></td>
                        <td><label for="MAS_BLNO">Master B/L</label></td>
                        <td><input type="text" class="td_input inputHeight" name="MAS_BLNO" id="MAS_BLNO" <attr:length value="20" />/></td>
                        <td><label for="MRN_NO">화물관리번호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="MRN_NO" id="MRN_NO" <attr:length value="30" />/></td>                        
                    </tr>              
                    <tr>
                        <td><label for="SUP_FIRM">해외공급자상호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="SUP_FIRM" id="SUP_FIRM" <attr:length value="60" /> <attr:mandantory/>/></td>
                        <td><label for="SUP_MARK">해외공급자부호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="SUP_MARK" id="SUP_MARK" <attr:length value="13" />/></td>
                        <td><label for="SUP_ST">해외공급자국가</label></td>
                        <td><select class="td_select inputHeight" id="SUP_ST" name="SUP_ST"></select></td>                        
                    </tr>                                              
                </table>
            </div>
        </div>
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>수입자정보</p>
                <div class="title_btn_inner">
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td><label for="IMP_FIRM">수입자상호</label></td>
                        <td><span id="IMP_FIRM" <attr:mandantory/>></span></td>
                        <td><label for="IMP_TGNO">수입자통관고유부호</label></td>
                        <td><span id="IMP_TGNO" <attr:mandantory/>></span></td>
                        <td><label for="MRN_NO">수입자구분</label></td>
                        <td><span id="IMP_DIVI" <attr:mandantory/>></span></td>                        
                    </tr>              
                </table>
            </div>
        </div>    
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>납세의무자정보</p>
                <div class="title_btn_inner">
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td><label for="NAB_FIRM">상호</label></td>
                        <td><span id="NAB_FIRM" <attr:mandantory/>></span></td>
                        <td><label for="NAB_NAME">대표자명</label></td>
                        <td><span id="NAB_NAME" <attr:mandantory/>></span></td>
                        <td><label for="NAB_SDNO">사업자등록번호</label></td>
                        <td><span id="NAB_SDNO" <attr:mandantory/>></span></td>                        
                    </tr>      
                    <tr>
                        <td>
                            <label>우편번호/주소</label>
                            <label for="NAB_PA_MARK" style="display: none;">우편번호</label>
                            <label for="NAB_ADDR" style="display: none;">주소</label>
                        </td>
                        <td colspan="3">
                            <span id="NAB_PA_MARK" <attr:mandantory/>></span> / <span id="NAB_ADDR"></span>
                        </td>
                        <td><label for="NAB_TGNO">통관고유부호</label></td>
                        <td><span id="NAB_TGNO"></span></td>
                    </tr>
                    <tr>
                        <td><label for="NAB_EMAIL">메일주소</label></td>
                        <td colspan="3"><span id="NAB_EMAIL"></span></td>
                        <td><label for="NAB_TELNO">전화번호</label></td>
                        <td><span id="NAB_TELNO"></span></td>
                    </tr>
                </table>
            </div>
        </div> 
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>신고내역</p>
                <div class="title_btn_inner">
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td>
                            <label>세관/과</label>
                            <label for="CUS" style="display: none;">세관</label>
                            <label for="SEC" style="display: none;">과</label>
                        </td>
                        <td>
                        	<select class="td_select inputHeight" id="CUS" name="CUS" style="width: 110px;"></select>
                        	<select class="td_select inputHeight" id="SEC" name="SEC" style="width: calc(100% - 140px)"></select>
                        </td>
                        <td><label for="RPT_DIVI_MARK">신고구분</label></td>
                        <td><select class="td_select inputHeight" id="RPT_DIVI_MARK" name="RPT_DIVI_MARK"></select></td>
                        <td><label for="EXC_DIVI_MARK">거래구분</label></td>
                        <td><select class="td_select inputHeight" id="EXC_DIVI_MARK" name="EXC_DIVI_MARK"></select></td>                        
                    </tr>      
                    <tr>
                        <td>
                            <label>수입종류/징수형태</label>
                            <label for="IMP_KI_MARK" style="display: none;">수입종류</label>
                            <label for="LEV_FORM" style="display: none;">징수형태</label>
                        </td>
                        <td>
                        	<select class="td_select inputHeight" id="IMP_KI_MARK" name="IMP_KI_MARK"  style="width: 120px;"></select>
                            <select class="td_select inputHeight" id="LEV_FORM" name="LEV_FORM"  style="width: calc(100% - 150px)"></select>
                        </td>
                        <td><label for="RPT_DIVI_MARK">원산지증명서유무</label></td>
                        <td><select class="td_select inputHeight" id="ORI_ST_PRF_YN" name="ORI_ST_PRF_YN"></select></td>
                        <td><label for="EXC_DIVI_MARK">가격신고서유무</label></td>
                        <td><select class="td_select inputHeight" id="AMT_RPT_YN" name="AMT_RPT_YN"></select></td>                        
                    </tr>      
                    <tr>
                        <td><label for="FOD_ST_ISO">적출국코드</label></td>
                        <td><select class="td_select inputHeight" id="FOD_ST_ISO" name="FOD_ST_ISO" <attr:mandantory/>></select></td>
                        <td><label for="ARR_MARK">도착항코드</label></td>
                        <td><select class="td_select inputHeight" id="ARR_MARK" name="ARR_MARK"></select></td>
                        <td>
	                        <label>운송수단/운송용기</label>
	                        <label for="TRA_MET" style="display: none;">운송수단</label>
	                        <label for="TRA_CTA" style="display: none;">운송용기</label>
                        </td>
                        <td>
                            <select class="td_select inputHeight" id="TRA_MET" name="TRA_MET" style="width: 140px;"></select>
                            <select class="td_select inputHeight" id="TRA_CTA" name="TRA_CTA" style="width: calc(100% - 170px)"></select>
                        </td>                      
                    </tr>   
                    <tr>
                        <td>
	                        <label>선기명/국적</label>
	                        <label for="SHIP_NM" style="display: none;">선기명</label>
	                        <label for="SHIP_ST_ISO" style="display: none;">선기국적</label>                        
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="SHIP_NM" id="SHIP_NM" style="width: 70px;"  <attr:length value="20" />/>
                            <select class="td_select inputHeight" id="SHIP_ST_ISO" name="SHIP_ST_ISO" style="width: calc(100% - 100px)"></select>                            
                        </td>  
                        <td>
	                        <label>총포장개수/단위</label>
	                        <label for="TOT_PACK_CNT" style="display: none;">총포장개수</label>
	                        <label for="TOT_PACK_UT" style="display: none;">총포장단위</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="TOT_PACK_CNT" id="TOT_PACK_CNT" style="width: 70px;"  <attr:length value="8" /> <attr:numberOnly/>/>
                            <select class="td_select inputHeight" id="TOT_PACK_UT" name="TOT_PACK_UT" style="width: calc(100% - 100px)"></select>                                    
                        </td>
                        <td><label for="FOD_ST_ISO">중량합계</label></td>
                        <td><input type="text" class="td_input inputHeight" name="TOT_WT" id="TOT_WT" <attr:length value="16" /> <attr:numberOnly/>/></td>                    
                    </tr>                                                     
                </table>
            </div>
        </div>
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>결제금액정보</p>
                <div class="title_btn_inner">
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td>
                            <label>인도조건-통화단위</label>
                            <label for="CON_COD" style="display: none;">인도조건</label>
                            <label for="CON_CUR" style="display: none;">통화단위</label>
                        </td>
                        <td>
                            <select class="td_select inputHeight" id="CON_COD" name="CON_COD" style="width: 140px;" <attr:mandantory/>></select>
                            <select class="td_select inputHeight" id="CON_CUR" name="CON_CUR" style="width: calc(100% - 170px)" <attr:mandantory/>></select>                        
                        </td>
                        <td>
                            <label>운임</label>
                            <label for="FRE_AMT" style="display: none;">운임</label>
                            <label for="FRE_UT" style="display: none;">통화</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="FRE_AMT" id="FRE_AMT" style="width: 120px;" <attr:length value="16" /> <attr:numberOnly/> <attr:decimalFormat value="15,2"/>/>
                            <span id="FRE_UT"></span>
                        </td>
                        <td>
                            <label>보험료</label>
                            <label for="INSU_AMT" style="display: none;">보험료</label>
                            <label for="INSU_UT" style="display: none;">통화</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="INSU_AMT" id="INSU_AMT" style="width: 120px;" <attr:length value="16" /> <attr:numberOnly/> <attr:decimalFormat value="15,2"/>/>
                            <span id="INSU_UT"></span>
                        </td>                 
                    </tr>  
                    <tr>
                        <td>
                            <label>결제금액-결제방법</label>
                            <label for="CON_AMT" style="display: none;">결제금액</label>
                            <label for="CON_KI" style="display: none;">결제방법</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="CON_AMT" id="CON_AMT" style="width: 120px;" <attr:length value="18" /> <attr:mandantory/> <attr:numberOnly/>/>
                            <select class="td_select inputHeight" id="CON_KI" name="CON_KI" style="width: calc(100% - 150px)"></select>                                     
                        </td>
                        <td>
	                        <label>가산금액</label>
	                        <label for="ADD_AMT" style="display: none;">가산금액</label>
	                        <label for="ADD_UT" style="display: none;">통화</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="ADD_AMT" id="ADD_AMT" style="width: 120px;" <attr:length value="17" /> <attr:numberOnly/> <attr:decimalFormat value="16,4"/>/>
                            <span id="ADD_UT"></span>
                        </td>
                        <td>
                            <label>공제금액</label>
                            <label for="SUB_AMT" style="display: none;">공제금액</label>
                            <label for="SUB_UT" style="display: none;">통화</label>
                        </td>
                        <td>
                            <input type="text" class="td_input inputHeight" name="SUB_AMT" id="SUB_AMT" autocomplete="off" style="width: 120px;" <attr:length value="17" /> <attr:numberOnly/> <attr:decimalFormat value="16,4"/>/>
                            <span id="SUB_UT"></span>
                        </td>                 
                    </tr>                      
                </table>
            </div>
        </div>
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>추가정보</p>
                <div class="title_btn_inner">
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px" />
                        <col width="*" />
                    </colgroup>                
                    <tr>
                        <td>
                            <label for="REQ_TXT" >수입의뢰첨부내용</label>
                        </td>                    
						<td>
                            <textarea name="REQ_TXT" id="REQ_TXT" rows="200" cols="200" style="height: 80px" <attr:length value="1000" />></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>       
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>수입의뢰첨부파일</p>
                <div class="title_btn_inner">
                    <a href="#삭제" class="title_frame_btn" id="btn_file_del">삭제</a>   
                    <a href="#추가" class="title_frame_btn" id="btn_file_add">추가</a>
                </div>
            </div>
            <div class="list_typeB">
                <div id="gridWrapLayer" style="height: 80px"></div>
            </div>
        </div>
		
		<div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>수출신고 모델규격</p>
                <div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btn_del">삭제</a>
					<a href="#" class="title_frame_btn" id="btn_add">추가</a>
				</div>
			</div>
            <div class="list_typeB">
                <div id="gridLayer" style="height: 150px"></div>
            </div>
		</div>		
    </div>
    </form>
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
