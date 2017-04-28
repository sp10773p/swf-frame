<%--
  User: jjkhj
  Date: 2017-02-21
  Form: 수출정정취하 신고 POPUP
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
    	var gridMaster, headers, gridDetail, headersDetail, sRptNo, sRptSeq, sModiSeq;
	   	var globalVar = {
            "RPT_NO"  : "",
            "refColName": ""
        }
	   	
        $(function (){
        	
        	var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
    	    sRptNo = arguments.RPT_NO;
    	    sRptSeq = arguments.RPT_SEQ;
    	    sModiSeq = arguments.MODI_SEQ;
    	    
            fn_setGrid();	//그리드 초기화
        	
        	fn_setCombo(); 	//공통콤보  조회
        	
        	fn_bind();		//데이터 바인드
        	
        	fn_controll();	//화면 controll
          	
            $('#btnCommSave').on("click", function (e) { fn_commSave("A"); });	//공통저장
          	
            $('#btnRanSave').on("click", function (e) { fn_commSave("B"); });	//란 저장
            
            $('#btnModelSave').on("click", function (e) { fn_commSave("C"); });	//모델저장
            
            $('#btnZip').on("click", function (e) { fn_zipPopup(); });			//주소검색
            
            $('#btnHs').on("click", function (e) { fn_hsPopup(); });			//HS검색
            
            $("#MODI_SEQ").val(sModiSeq);
        });
        
	   	function fn_setGrid(){
	   		headers = [
				{"HEAD_TEXT": "란번호"       	, "WIDTH": "80"   , "FIELD_NAME": "RAN_NO"},
				{"HEAD_TEXT": "세번부호"     	, "WIDTH": "80"   , "FIELD_NAME": "HS" , "LINK":"fn_ranDetail", "POSIT":"true"},
                {"HEAD_TEXT": "거래품명"		, "WIDTH": "100"  , "FIELD_NAME": "EXC_GNM"},
                {"HEAD_TEXT": "수량"       	, "WIDTH": "100"  , "FIELD_NAME": "WT"},
                {"HEAD_TEXT": "신고금액원화"	, "WIDTH": "120"  , "FIELD_NAME": "RPT_KRW"}
                
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "수출신고  란조회",
                "targetLayer"  : "gridRanLayer",
                "qKey"         : "dec.selectDecRanList",
                "headers"      : headers,
                //"paramsFormId" : "detailForm",
                "paramsGetter" : {"RPT_NO":sRptNo, "RPT_SEQ":sRptSeq},
                "gridNaviId"   : "",
                "check"        : false,
                "firstLoad"    : false,
                "postScript"   : function (){fn_setForm();},
                "controllers"  : [ ]
            });
        	
        	headersDetail = [
				{"HEAD_TEXT": "순번"       	, "WIDTH": "80"   , "FIELD_NAME": "SIL"},
				{"HEAD_TEXT": "모델규격"     	, "WIDTH": "200"   , "FIELD_NAME": "GNM", "LINK":"fn_modelDetail", "POSIT":"true"},
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
                "gridNaviId"   : "",
                "check"        : false,
                "firstLoad"    : false,
                "postScript"   : function (){fn_setFormModel();},
                "controllers"  : []
            });
	   	}
	   	
        function fn_setCombo(){
        	//viewType = 1 : CODE_NM , 2 : CODE, 3 : [CODE]CODE_NM
			//bindCombos.addComboInfo([targetId, std, isAll, likeCode, likeName, filterStr, valueType]);
    	
        	//$.comm.bindCombos.addComboInfo("RES_YN"      			, "CUS0036", true, null, 3);	//응답형태
        	$.comm.bindCombos.addComboInfo("EXP_DIVI"    			, "CUS0027", true, null, 3);	//수출자구분
        	$.comm.bindCombos.addComboInfo("INLOCALCD"   			, "CUS0013", true, null, 3);	//산업단지부호
        	$.comm.bindCombos.addComboInfo("REF_DIVI"    			, "CUS0048", true, null, 3);	//환급신청인
        	$.comm.bindCombos.addComboInfo("RET_DIVI"    			, "CUS0001", true, null, 3);	//간이환급신청
        	$.comm.bindCombos.addComboInfo("RPT_CUS"     			, "CUS0015", true, null, 3);	//세관
        	$.comm.bindCombos.addComboInfo("RPT_SEC"     			, "CUS0004", true, null, 3);	//과
        	$.comm.bindCombos.addComboInfo("RPT_DIVI"    			, "CUS0021", true, null, 3);	//신고구분
        	$.comm.bindCombos.addComboInfo("EXC_DIVI"    			, "CUS0017", true, null, 3);	//거래구분
        	$.comm.bindCombos.addComboInfo("EXP_KI"      			, "CUS0018", true, null, 3);	//수출종류
        	$.comm.bindCombos.addComboInfo("CON_MET"     			, "CUS0003", true, null, 3);	//결제방법
        	$.comm.bindCombos.addComboInfo("TA_ST_ISO"   			, "CUS0005", true, null, 3);	//목적국
        	$.comm.bindCombos.addComboInfo("FOD_CODE"    			, "CUS0046", true, null, 3);	//적재항
        	$.comm.bindCombos.addComboInfo("TRA_MET"     			, "CUS0034", true, null, 3);	//운송수단
        	$.comm.bindCombos.addComboInfo("TRA_CTA"	   			, "CUS0035", true, null, 3);	//운송용기
        	$.comm.bindCombos.addComboInfo("CHK_MET_GBN" 			, "CUS0002", true, null, 3);	//검사방법
        	$.comm.bindCombos.addComboInfo("UP5AC_DIVI"  			, "CUS0039", true, null, 3);	//사전임시개청
        	$.comm.bindCombos.addComboInfo("USED_DIVI"   			, "CUS0008", true, null, 3);	//물품상태
        	$.comm.bindCombos.addComboInfo("MRN_DIVI"    			, "CUS0047", true, null, 3);	//화물번호전송구분
        	$.comm.bindCombos.addComboInfo("BAN_DIVI"	   			, "CUS2015", true, null, 3);	//반송사유
        	$.comm.bindCombos.addComboInfo("CONT_IN_GBN" 			, "YN",      true, null, 1);	//컨테이너적입여부
        	$.comm.bindCombos.addComboInfo("TOT_PACK_UT" 			, "CUS0043", true, null, 3);	//포장단위
        	$.comm.bindCombos.addComboInfo("AMT_COD"	   			, "CUS0038", true, null, 3);	//인도조건
        	$.comm.bindCombos.addComboInfo("CUR"         			, "CUS0042", true, null, 3);	//통화단위
        	$.comm.bindCombos.addComboInfo("ATT_YN"	   				, "YN",      true, null, 1);	//첨부여부
        	$.comm.bindCombos.addComboInfo("ORI_ST_MARK1"   		, "CUS0005", true, null, 1);	//원산지국가
    		$.comm.bindCombos.draw();
        }
        
        function fn_bind(){
        	var param = {
                "qKey"    : "dec.selectDecDetail",
                "RPT_NO"  : sRptNo
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
                    $.comm.bindData(data.data);
		            gridMaster.requestToServer();
                },
                "수출신고 상세정보 조회"
            );
        }
        
        function fn_controll(){
	    	
        	$.comm.disabled("RPT_NO", true);
        	$.comm.disabled("ORDER_ID", true);
        	$.comm.disabled("RPT_FIRM", true);
        	$.comm.disabled("RPT_BOSS_NM", true);
        	$.comm.disabled("RPT_DAY", true);
        	$.comm.disabled("EXP_LIS_DAY", true);
        	$.comm.disabled("JUK_DAY", true);
        	$.comm.disabled("EXC_RATE_CUR", true);
        	$.comm.disabled("EXC_RATE_USD", true);
        	$.comm.disabled("TOT_RPT_KRW", true);
        	$.comm.disabled("TOT_RPT_USD", true);
        	$.comm.disabled("TOT_RAN", true);
        	$.comm.disabled("RAN_NO", true);
        	$.comm.disabled("RPT_KRW", true);
        	$.comm.disabled("RPT_USD", true);
        	$.comm.disabled("CON_AMT", true);
        	//$.comm.disabled("AMT", true);
        	$.comm.disabled("COMM_FIRM", true);
        	$.comm.disabled("COMM_TGNO", true);
        	$.comm.disabled("EXP_FIRM", true);
        	$.comm.disabled("EXP_TGNO", true);
        	$.comm.disabled("EXP_BOSS_NAME", true);
        	$.comm.disabled("EXP_SDNO", true);
        	$.comm.disabled("EXP_POST", true);
        	$.comm.disabled("EXP_ADDR1", true);
        	$.comm.disabled("EXP_ADDR2", true);
        	
        	//기타내역
        	var disArr = new Array();
        	disArr.push("RPT_DIVI");
        	disArr.push("EXC_DIVI");
        	disArr.push("EXP_KI"); 
        	disArr.push("TRA_CTA");
        	disArr.push("REF_DIVI");
        	disArr.push("UP5AC_DIVI");
        	disArr.push("USED_DIVI");
        	disArr.push("MRN_DIVI");
        	disArr.push("BAN_DIVI");
        	disArr.push("CONT_IN_GBN");
        	disArr.push("MAK_FIN_DAY");
        	disArr.push("LCNO");
        	disArr.push("BOSE_RPT_FIRM");
        	disArr.push("BOSE_RPT_DAY1");
        	disArr.push("BOSE_RPT_DAY2");
        	$.comm.disabled(disArr, true);
        	
        }
        
        function fn_controll_item(){
        	var disItemArr = new Array();
    		disItemArr.push("GNM");
    		disItemArr.push("COMP");
    		disItemArr.push("QTY");
    		disItemArr.push("QTY_UT");
    		disItemArr.push("PRICE");
    		disItemArr.push("M_AMT");
    		$.comm.disabled(disItemArr, true);
    		$("#btnModelSave").css({"display":"none"});
        }
        
        function fn_setForm(){
        	var size = gridMaster.getSize();
        	//조회된 란List 가 없을때 상세정보 초기화
            if(size == 0){
              	return;
            }
            
            fn_ranDetail(0);
        }
        
      	//란 상세정보
        function fn_ranDetail(index){
        	fn_clean("ranTable");
      		
      		var gridData = gridMaster.getRowData(index);
            var param = {  "qKey" : "dec.selectDecRanDetail"
            		     , "RPT_NO": gridData.RPT_NO
            		     , "RPT_SEQ": gridData.RPT_SEQ
            		     , "RAN_NO": gridData.RAN_NO
            			};
			
         	$.comm.send("/common/select.do", param,
                function(data, status){
        			$.comm.bindData(data.data);
                },
                "란 상세정보 조회"
            );
         	
         	fn_modelList(index);
         	
        }
      	
 		function fn_setFormModel(){
        	
        	fn_modelDetail(0);
        }
        
      	// 모델 List
        function fn_modelList(index){
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
            //fn_modelDetail(0);
        }
        
      	//모델 상세정보
        function fn_modelDetail(index){
        	fn_clean("itemTable");
      		var size = gridDetail.getSize();
        	if(size == 0){
        		fn_controll_item();
        		return;
        	}
            var gridData = gridDetail.getRowData(index);
            var param = {  "qKey" : "dec.selectDecModelDetail"
            		     , "RPT_NO": gridData.RPT_NO
            		     , "RPT_SEQ": gridData.RPT_SEQ
            		     , "RAN_NO": gridData.RAN_NO
            		     , "SIL": gridData.SIL
            			};
			
         	$.comm.send("/common/select.do", param,
                function(data, status){
        			$.comm.bindData(data.data);
                },
                "모델 상세정보 조회"
            );
        }
      	
     	// 저장
        function fn_commSave(gbn){
        	if(!fn_validate(gbn)){
      			return;
      		}
     		if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                return;
            }
            var etcParams = {"GBN": gbn, "ITEM_SIZE":gridDetail.getSize()};
            if(gbn == "C") etcParams = {"GBN": gbn, "AMT":$("#M_AMT").val(), "ITEM_SIZE":gridDetail.getSize()};
            $.comm.sendForm("/dec/saveModExpDecDtl.do", "detailForm", fn_callback, "정정내역생성", null, null, etcParams);
        }
      	
      	function fn_validate(gbn){
      		if(gbn == "A"){
      			var sCod = $('#AMT_COD').val();
      			var sInsu = $('#INSU_KRW').val();	//보험금액
      			var sFre = $('#FRE_KRW').val();		//운임금액

      			if(sCod=="CIF"||sCod=="CIP"||sCod=="DAF"||sCod=="DDP"||sCod=="DDU"||sCod=="DEQ"||sCod=="DES"||sCod=="DAT"||sCod=="DAP"){
      				if($.comm.isNull(sInsu)||sInsu <= 0 || $.comm.isNull(sFre) || sFre <= 0){
      					alert("인도조건이 "+ sCod+"인 경우에 운임, 보험료 둘다 0보다 커야 합니다.");
      					return false;
      				}
      			}else if(sCod=="CIN"){
      				if($.comm.isNull(sInsu)||sInsu <= 0 || (!$.comm.isNull(sFre) && sFre > 0 )){
      					alert("인도조건이 "+ sCod+"이면 보험료는 0보다 커야하고, 운임은 0이어야 한다.");
      					return false;
      				}
      			}else if(sCod=="CFR"||sCod=="CPT"){
      				if((!$.comm.isNull(sInsu) && sInsu > 0) || $.comm.isNull(sFre) || sFre <= 0){
      					alert("인도조건이 "+ sCod+"이면 보험료는 0이어야 하고, 운임은 0보다 커야 한다.");
      					return false;
      				}
      			}else if(sCod=="FOB"||sCod=="EXW"||sCod=="FAS"||sCod=="FCA"){
      				if((!$.comm.isNull(sInsu) && sInsu > 0) || (!$.comm.isNull(sFre) && sFre > 0)){
      					alert("인도조건이 "+ sCod+"인 경우에는 운임,보험료 둘다 0이어야 한다.");
      					return false;
      				}
      			}
				
      		}else if(gbn == "B"){
      			
      		}else{
      			var sQty   = $('#QTY').val();
      			var sPrice = $('#PRICE').val();
      			var sMamt  = $('#M_AMT').val();
      			if(sMamt != sQty * sPrice){
      				alert($.comm.getMessage("W00000059")); // 수량*단가의 곱이 금액과 일치하지 않습니다.
      				return false;
      			}
      		}
      		
      		return true;
      	}
      	
      	var fn_callback = function (data) {
            if(data.code.indexOf('I') == 0){
                fn_select();
                opener.gridWrapper.requestToServer();
            }
        }
      	
      	function fn_zipPopup(gbn){
      		var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;windowName:zipPopup";
            // 모달 호출
            $.comm.dialog("<c:out value='/jspView.do?jsp=cmm/popup/zipPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                        $('#GDS_POST').val(ret.ZIP_CD);   // 우편번호
                        $('#GDS_ADDR1').val(ret.NAME_KR); // 주소 
                    }
                }
            );
      	}
      	
      	function fn_hsPopup(){
      		$.comm.setModalArguments({"HS" : $("#HS").val()});
      		var spec = "width:900px;height:800px;scroll:auto;status:no;center:yes;resizable:yes;windowName:hsPopup";
            // 모달 호출
            $.comm.dialog("<c:out value='/jspView.do?jsp=cmm/popup/hsPopup' />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                    	$('#HS').val(ret.HS_CD);   		// 
                    	$('#STD_GNM').val(ret.STD_NM_EN); // 
                    	
                    }
                }
            );
      	}
      	
      	function fn_select(){
      		fn_setGrid();	//그리드 초기화
         	fn_bind();		//데이터 바인드
         	fn_controll();	//화면 controll
      	}
      	
      	function fn_clean(tableNm){
	  		 var selector = $('#'+tableNm+'> tbody > tr > td > :text');
	         selector.each(function(idx, obj){
		         var id = $(obj).get(0).id;
		         var e = $(obj);
		         if(e.get(0).tagName.toLowerCase() == 'input' && e.attr('type').toLowerCase() == 'text'){
		        	 $('#' + id).val("");
		         }
	         });
     	}
      	        
    </script>
</head>
<body>
<div class="layerContainer">
    <form id="detailForm" name="detailForm" method="post">
    	<input type="hidden" id="RPT_SEQ" name="RPT_SEQ" />
    	<input type="hidden" id="MODI_SEQ" name="MODI_SEQ" />
    	<input type="hidden" id="COMM_CODE" name="COMM_CODE" /><!-- 수출대행자코드 -->
    	<input type="hidden" id="EXP_CODE" name="EXP_CODE" /><!-- 수출화주코드 -->
    	<input type="hidden" id="RPT_MARK" name="RPT_MARK" /><!-- 신고인부호 -->
    <div class="layerTitle">
       <h1>정정내역생성</h1>
    </div><!-- layerTitle -->
 
	<div class="layer_btn_frame">
       	<c:if test="${REG_ID eq userId && (RECE eq NULL || RECE eq '' || RECE eq '01')}">
        	<a href="#" class="title_frame_btn" id="btnCommSave">저장</a>
       	</c:if>
	</div>
					
	<div class="layer_content">
        <div class="title_frame">
			<p><a href="#" class="btnToggle_table">상세정보</a></p>
           	<div class="table_typeA gray">
               <table style="table-layout:fixed;" >
                   <caption class="blind">제출번호 및 신고형태</caption>
                   <colgroup>
                        <col width="12%" />
                        <col width="21%" />
                        <col width="12%" />
                        <col width="21%" />
                        <col width="12%" />
                        <col width="*" />
                   </colgroup>
                       <tr>
                           <td><label for="RPT_NO">제출번호</label></td>
                           <td><input type="text" name="RPT_NO" id="RPT_NO"></td>
                           <td><label for="ORDER_ID">주문번호</label></td>
                           <td><input type="text" name="ORDER_ID" id="ORDER_ID"  ></td>
                           <td><label for="RPT_FIRM">신고자상호/성명</label></td>
                           <td>
                           	<input type="text" name="RPT_FIRM" id="RPT_FIRM" style="width: 50% !important">
                           	<input type="text" name="RPT_BOSS_NM" id="RPT_BOSS_NM" style="width: 30% !important">
                           </td>
                       </tr>
                       <tr>
                           <td><label for="RPT_DAY">신고일자</label></td>
                           <td><input type="text" name="RPT_DAY" id="RPT_DAY" style="width: 40% !important"></td>
                           <td>
                               <label for="EXP_LIS_DAY">수리일자</label>
                           </td>
                           <td>
                             <input type="text" name="EXP_LIS_DAY" id="EXP_LIS_DAY" style="width: 40% !important">
                           </td>
                           <td>
                               <label for="JUK_DAY">적재의무기한</label>
                           </td>
                           <td>
                             <input type="text" name="JUK_DAY" id="JUK_DAY" style="width: 40% !important">
                           </td>
                           <!-- <td>
                           	<label>송신구분/응답형태</label>Combo,CMM_STD_CODE.CUS0036
                               <label for="SEND_DIVI" style="display: none;">송신구분</label>
                               <label for="RES_YN" style="display: none;">응답형태</label>
                           </td>
                           <td>
                              <input type="text" name="SEND_DIVI" id="SEND_DIVI" style="width: 40% !important">
                              <select id="RES_YN" name="RES_YN" style="width: 40% !important"></select>
                           </td> -->
                       </tr>
               	</table>
         	</div><!-- //table_typeA 3단구조 -->
        </div><!-- //title_frame -->
            
            <div class="title_frame">
				<p><a href="#" class="btnToggle_table">수출대행자</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">수출대행자</caption>
						<colgroup>
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="*" />
						</colgroup>
						<tr>
                            <td><label for="COMM_FIRM">상호</label></td>
                            <td><input type="text" name="COMM_FIRM" id="COMM_FIRM" <attr:length value="28" />></td>
                            <td><label for="COMM_TGNO">통관고유부호</label></td>
                            <td><input type="text" name="COMM_TGNO" id="COMM_TGNO"  <attr:length value="15" />></td>
                            <td><label for="EXP_DIVI">수출자구분</label></td><!-- Combo,CMM_STD_CODE.CUS0027 -->
                            <td><select id="EXP_DIVI" name="EXP_DIVI"></select></td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">수출화주</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">수출화주</caption>
						<colgroup>
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="*" />
						</colgroup>
						<tr>
                            <td><label for="EXP_FIRM">상호</label></td>
                            <td><input type="text" name="EXP_FIRM" id="EXP_FIRM" <attr:length value="28" />></td>
                            <td><label for="EXP_TGNO">통관고유부호</label></td>
                            <td><input type="text" name="EXP_TGNO" id="EXP_TGNO" <attr:length value="15" /> ></td>
                            <td>
                            	<label>성명/사업자번호 </label>
                                <label for="EXP_BOSS_NAME" style="display: none;">성명</label>
                                <label for="EXP_SDNO" style="display: none;">사업자번호</label>
                            </td>
                            <td>
                               <input type="text" name="EXP_BOSS_NAME" id="EXP_BOSS_NAME"  style="width: 40% !important" <attr:length value="12" />>
                               <input type="text" name="EXP_SDNO" id="EXP_SDNO"  style="width: 40% !important" <attr:length value="13" />>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label>우편번호/주소</label>
                                <label for="EXP_POST" style="display: none;">우편번호</label>
                                <label for="EXP_ADDR1" style="display: none;">주소</label>
                            </td>
                            <td colspan="5">
                              <input type="text" name="EXP_POST" id="EXP_POST"   style="width: 10% !important" <attr:length value="5" />>
                              <input type="text" name="EXP_ADDR1" id="EXP_ADDR1"   style="width: 80% !important" <attr:length value="150" />>
                            </td>
                        </tr>
                        <tr>
                        	<td>
                                <label for="EXP_ADDR2">상세주소</label>
                            </td>
                            <td colspan="5">
                              <input type="text" name="EXP_ADDR2" id="EXP_ADDR2" <attr:length value="35" />>
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">제조자</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">제조자</caption>
						<colgroup>
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="*" />
						</colgroup>
						<tr>
                            <td><label for="MAK_FIRM">상호</label></td>
                            <td><input type="text" name="MAK_FIRM" id="MAK_FIRM"  <attr:length value="28" />></td>
                            <td><label for="MAK_TGNO">통관고유부호</label></td>
                            <td><input type="text" name="MAK_TGNO" id="MAK_TGNO"  <attr:length value="15" />></td>
                            <td>
                            	<label>우편번호/산업단지부호</label>
                                <label for="MAK_POST" style="display: none;">우편번호</label>
                                <label for="INLOCALCD" style="display: none;">산업단지부호</label><!-- Combo,CMM_STD_CODE.CUS0013 -->
                            </td>
                            <td>
                            	<input type="text" name="MAK_POST" id="MAK_POST"  style="width: 30% !important" <attr:length value="5" />>
                            	<select id="INLOCALCD" name="INLOCALCD" style="width: 60% !important"></select>
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">물품소재지/구매자</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">물품소재지/구매자</caption>
						<colgroup>
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="21%" />
	                        <col width="12%" />
	                        <col width="*" />
						</colgroup>
						<tr>
                            <td><label for="GDS_POST">물품소재지 우편번호</label></td>
                            <td>
                            	<input type="text" name="GDS_POST" id="GDS_POST" style="width: calc(100% - 110px)" <attr:length value="5" />>
                            	<a href="#" class="btn_table" style="margin-left: 0px;" id="btnZip">주소찾기</a>
                            </td>
                            <td><label for="GDS_ADDR1">물품소재지 주소</label></td>
                            <td colspan="3">
                            	<input type="text" name="GDS_ADDR1" id="GDS_ADDR1" <attr:length value="70" />>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="BUY_FIRM">구매자상호</label></td>
                            <td colspan="5">
                            	<input type="text" name="BUY_FIRM" id="BUY_FIRM" <attr:length value="60" />>
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">환급신청인/통관구분</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">환급신청인/통관구분</caption>
						<colgroup>
							<col width="12%" />
                        	<col width="38%" />
                        	<col width="12%" />
                        	<col width="*" />
						</colgroup>
						<tr>
                            <td>
                            	<label for="RET_DIVI">간이환급신청</label><!-- Combo,CMM_STD_CODE.CUS0001 -->
                            </td>
                            <td>
                            	<select id="RET_DIVI" name="RET_DIVI" style="width: 40% !important"></select>
                            </td>
                            <td>
                            	<label>세관 - 과</label>
                            	<label for="RPT_CUS" style="display: none;">세관</label><!-- Combo,CMM_STD_CODE.CUS0015 -->
                            	<label for="RPT_SEC" style="display: none;">과</label><!-- Combo,CMM_STD_CODE.CUS0004 -->
                            </td>
                            <td>
                            	<select id="RPT_CUS" name="RPT_CUS" style="width: 40% !important"></select>-
                            	<select id="RPT_SEC" name="RPT_SEC" style="width: 40% !important"></select>
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                            	<label for="CON_MET">결제방법</label><!-- Combo,CMM_STD_CODE.CUS0003 -->
                            </td>
                            <td>
                            	<select id="CON_MET" name="CON_MET"></select>
                            </td>
                            <td>
                            	<label for="TRA_MET">운송수단</label><!-- Combo,CMM_STD_CODE.CUS0034 -->
                            </td>
                            <td>
                            	<select id="TRA_MET" name="TRA_MET"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label for="TA_ST_ISO">목적국</label><!-- Combo,CMM_STD_CODE.CUS0005 -->
                            </td>
                            <td>
                            	<select id="TA_ST_ISO" name="TA_ST_ISO"></select>
                            </td>
                            <td>
                            	<label for="FOD_CODE">적재항</label><!-- Combo,CMM_STD_CODE.CUS0046 -->
                            </td>
                            <td>
                            	<select id="FOD_CODE" name="FOD_CODE"></select>
                            </td>
                        </tr>
                        
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">신고물품내역</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">신고물품내역</caption>
						<colgroup>
							<col width="12%" />
                        	<col width="38%" />
                        	<col width="12%" />
                        	<col width="*" />
						</colgroup>
						<tr>
                            <td>
                            	<label for="TOT_WT">총중량</label>
                            	<label for="UT" style="display: none;">중량단위</label>
                            </td>
                            <td>
                            	<input type="text" name="TOT_WT" id="TOT_WT" style="width: 60% !important;" <attr:length value="16" /> <attr:numberOnly/> <attr:decimalFormat value="16,3"/> >
                            	<input type="text" name="UT" id="UT" style="width: 20% !important;" <attr:length value="3" />>
                            </td>
                            <td>
                            	<label for="TOT_PACK_CNT">총포장수</label>
                            	<label for="TOT_PACK_UT" style="display: none;">포장단위</label><!-- Combo,CMM_STD_CODE.CUS0043 -->
                            </td>
                            <td>
                            	<input type="text" name="TOT_PACK_CNT" id="TOT_PACK_CNT" style="width: 30% !important" <attr:length value="6" /> <attr:numberOnly/>>
                            	<select id="TOT_PACK_UT" name="TOT_PACK_UT" style="width: 60% !important"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label>인도조건-통화-결제금액</label>
                                <label for="AMT_COD" style="display: none;">인도조건</label><!-- Combo,CMM_STD_CODE.CUS0038 -->
                                <label for="CUR" style="display: none;">통화단위</label><!-- Combo,CMM_STD_CODE.CUS0042 -->
                                <label for="AMT" style="display: none;">결제금액</label>
                            </td>
                            <td colspan="3">
                            	<select id="AMT_COD" name="AMT_COD" style="width: 35% !important"></select>-
                            	<select id="CUR" name="CUR" style="width: 20% !important"></select>-
                            	<input type="text" id="AMT" name="AMT" style="width: 25% !important" <attr:length value="18" /> <attr:numberOnly/>>
                            </td>
                            
                        </tr>
                        <tr>
                            <td><label>운임원화/보험료원화</label>
                                 <label for="FRE_KRW" style="display: none;">운임원화</label>
                                 <label for="INSU_KRW" style="display: none;">보험료원화</label>
                            </td>
                            <td>
                            	<input type="text" name="FRE_KRW" id="FRE_KRW" style="width: 40% !important;" <attr:length value="14" /> <attr:numberOnly/>>
                            	<input type="text" name="INSU_KRW" id="INSU_KRW" style="width: 40% !important;" <attr:length value="14" /> <attr:numberOnly/>>
                            </td>
                            <td>
                            	<label>환율(결제환율/USD)</label>
                                <label for="EXC_RATE_CUR" style="display: none;">결제환율</label>
                                <label for="EXC_RATE_USD" style="display: none;">미화환율</label>
                            </td>
                            <td>
                            	<input type="text" name="EXC_RATE_CUR" id="EXC_RATE_CUR" style="width: 40% !important; ">
                            	<input type="text" name="EXC_RATE_USD" id="EXC_RATE_USD" style="width: 40% !important; " >
                            </td>
                        </tr>
                        <tr>
                            <td>
                            	<label>신고금액원화/미화</label>
                                <label for="TOT_RPT_KRW" style="display: none;">신고금액원화</label>
                                <label for="TOT_RPT_USD" style="display: none;">신고금액미화</label>
                            </td>
                            <td>
                            	<input type="text" name="TOT_RPT_KRW" id="TOT_RPT_KRW" style="width: 40% !important; ">
                            	<input type="text" name="TOT_RPT_USD" id="TOT_RPT_USD" style="width: 40% !important; ">
                            </td>
                            <td><label for="TOT_RAN">총란수</label></td>
                            <td>
                            	<input type="text" name="TOT_RAN" id="TOT_RAN" style="width: 20% !important; ">
                            </td>
                        </tr>
                       
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">신고인기재란</a></p>
				<div class="table_typeA gray table_toggle">
					<table style="table-layout:fixed;" >
						<caption class="blind">신고인기재란</caption>
						<colgroup>
							<col width="12%" />
                        	<col width="38%" />
                        	<col width="12%" />
                        	<col width="*" />
						</colgroup>
						
                        <tr>
                            <td>
                            	<label for="RPT_USG">신고인기재란</label>
                            </td>
                            <td colspan="3">
                            	<textarea  name="RPT_USG" id="RPT_USG" rows="3" style="height: 100px; " <attr:length value="500" />></textarea>
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->
			
			<div class="title_frame">
				<p><a href="#" class="btnToggle_table">기타내역</a></p>
				<div class="table_typeA gray table_toggle" style="display: none;">
					<table style="table-layout:fixed;" >
						<caption class="blind">기타내역</caption>
						<colgroup>
							<col width="12%" />
                        	<col width="38%" />
                        	<col width="12%" />
                        	<col width="*" />
						</colgroup>
						<tr>
                            <td>
                            	<label for="RPT_DIVI">신고구분</label><!-- Combo,CMM_STD_CODE.CUS0021 -->
                            </td>
                            <td>
                            	<select id="RPT_DIVI" name="RPT_DIVI"></select>
                            </td>
                            <td>
                            	<label for="EXC_DIVI">거래구분</label><!-- Combo,CMM_STD_CODE.CUS0017 -->
                            </td>
                            <td>
                            	<select id="EXC_DIVI" name="EXC_DIVI"></select>
                            </td>
                        </tr>
						<tr>
							<td>
                            	<label for="EXP_KI">수출종류</label><!-- Combo,CMM_STD_CODE.CUS0018 -->
                            </td>
                            <td>
                            	<select id="EXP_KI" name="EXP_KI"></select>
                            </td>
							
							<td>
                            	<label for="TRA_CTA">운송용기</label><!-- Combo,CMM_STD_CODE.CUS0035 -->
                            </td>
                            <td>
                            	<select id="TRA_CTA" name="TRA_CTA"></select>
                            </td>
                        </tr>
						<tr>
                            <td>
                            	<label for="REF_DIVI">환급신청인 </label><!-- Combo,CMM_STD_CODE.CUS0048 -->
                            </td>
                            <td>
                            	<select id="REF_DIVI" name="REF_DIVI" style="width: 40% !important"></select>
                            </td>
                            <td><label for="MAK_FIN_DAY">검사희망일</label></td>
                            <td>
                            	<input type="text" id="MAK_FIN_DAY" name="MAK_FIN_DAY" style="width: 30% !important" />
                            	<!-- <div class="search_date">
	                                <input type="text" id="MAK_FIN_DAY" name="MAK_FIN_DAY" class="datepicker" <attr:datefield  value=""/>/>
                                </div> -->
                            </td>
                           
                        </tr>
                       
                        <tr>
                            <td><label for="UP5AC_DIVI">사전임시개청</label></td><!-- Combo,CMM_STD_CODE.CUS0039 -->
                            <td>
                            	<select id="UP5AC_DIVI" name="UP5AC_DIVI"></select>
                            </td>
                            <td><label for="USED_DIVI">물품상태</label></td><!-- Combo,CMM_STD_CODE.CUS0008 -->
                            <td>
                            	<select id="USED_DIVI" name="USED_DIVI"></select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="MRN_DIVI">화물번호전송구분</label></td><!-- Combo,CMM_STD_CODE.CUS0047 -->
                            <td>
                            	<select id="MRN_DIVI" name="MRN_DIVI"></select>
                            </td>
                            <td><label for="BAN_DIVI">반송사유</label></td><!-- Combo,CMM_STD_CODE.CUS2015 --> 
                            <td>
                            	<select id="BAN_DIVI" name="BAN_DIVI"></select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="CONT_IN_GBN">컨테이너적입여부</label></td><!-- Combo,CMM_STD_CODE.YN -->
                            <td>
                            	<select id="CONT_IN_GBN" name="CONT_IN_GBN"></select>
                            </td>
                            <td><label for="LCNO">L/C번호</label></td>
                            <td>
                            	<input type="text" name="LCNO" id="LCNO" style="width: 80% !important" <attr:length value="20" />>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="BOSE_RPT_FIRM">보세운송신고인상호</label></td>
                            <td>
                            	<input type="text" name="BOSE_RPT_FIRM" id="BOSE_RPT_FIRM" style="width: 60% !important" <attr:length value="30" />>
                            </td>
                            <td>
                            	<label>보세운송신고기간</label>
                            	<label for="BOSE_RPT_DAY1" style="display: none;">보세운송신고기간 시작일</label>
                            	<label for="BOSE_RPT_DAY2" style="display: none;">보세운송신고기간 종료일</label>
                            </td>
                            <td>
                            	<input type="text" id="BOSE_RPT_DAY1" name="BOSE_RPT_DAY1" style="width: 30% !important" />
                            	<input type="text" id="BOSE_RPT_DAY2" name="BOSE_RPT_DAY2" style="width: 30% !important" />
                            	<!-- <div class="search_date">
	                            	<input type="text" id="BOSE_RPT_DAY1" name="BOSE_RPT_DAY1" class="datepicker" <attr:datefield to="BOSE_RPT_DAY2" value=""/> />
	                                <span>~</span>
	                                <input type="text" id="BOSE_RPT_DAY2" name="BOSE_RPT_DAY2" class="datepicker" <attr:datefield  value=""/>/>
                                </div> -->
                            </td>
                        </tr>
					</table>
				</div><!-- //table_typeA 3단구조 -->
			</div><!-- //title_frame -->

			<div class="title_frame" style="margin-bottom: 5px;">
				<c:choose>
					<c:when test="${REG_ID eq userId && (RECE eq NULL || RECE eq '' || RECE eq '01')}">
						<p style="margin-bottom: 5px !important;">
							<a href="#" class="btnToggle_table">란 상세정보</a>
							<a href="#" class="btn blue_84" id="btnRanSave" style="margin-right: 25px;">저장</a>
						</p>
					</c:when>
					<c:otherwise>
						<p><a href="#" class="btnToggle_table">란 상세정보</a></p>
					</c:otherwise>
				</c:choose>           
				<div class="vertical_frame">
	               	<div class="vertical_frame_left46">
	               		<div id="gridRanLayer" style="height: 218px;"></div>
	               	</div>
               		<div class="vertical_frame_right46">
						<div class="table_typeA gray table_toggle">
							<table style="table-layout:fixed;" id="ranTable">
							<caption class="blind">란 상세정보</caption>
							<colgroup>
								<col width="13%" />
		                        <col width="20%" />
		                        <col width="13%" />
		                        <col width="20%" />
		                        <col width="13%" />
		                        <col width="20%" />
							</colgroup>
							<tr>
	                            <td><label for="RAN_NO">란번호</label></td>
	                            <td><input type="text" name="RAN_NO" id="RAN_NO" style="width: 40% !important "></td>
	                            <td><label for="HS">세번부호</label></td>
	                            <td colspan="3">
	                            	<input type="text" name="HS" id="HS" style="width: 80% !important" <attr:length value="10" />>
	                                <a href="#" class="td_find_btn" id="btnHs"></a>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td><label for="STD_GNM">품명</label></td>
	                            <td colspan="5"><input type="text" name="STD_GNM" id="STD_GNM" <attr:length value="50" /> <attr:alphaNumber/> ></td>
	                        </tr>
	                        <tr>
	                            <td><label for="EXC_GNM">거래품명</label></td>
	                            <td colspan="5"><input type="text" name="EXC_GNM" id="EXC_GNM" <attr:length value="50" /> <attr:alphaNumber/> ></td>
	                        </tr>
	                        <tr>
	                            <td><label for="MODEL_GNM">상표명</label></td>
	                            <td colspan="3"><input type="text" name="MODEL_GNM" id="MODEL_GNM" <attr:length value="30" /> <attr:alphaNumber/> ></td>
	                            <td><label for="ATT_YN">서류첨부여부</label></td><!-- Combo,CMM_STD_CODE.YN -->
	                            <td>
	                            	<select id="ATT_YN" name="ATT_YN" style="width: 50% !important"></select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                            	<label for="RPT_KRW">신고가격</label>
	                                <label for="RPT_KRW" style="display: none;">신고금액원화</label>
	                                <label for="RPT_USD" style="display: none;">신고금액미화</label>
	                            </td>
	                            <td colspan="3">
	                            	<label>원화</label>&nbsp;<input type="text" name="RPT_KRW" id="RPT_KRW" style="width: 38% !important" <attr:length value="18" />>
	                            	<label>미화</label>&nbsp;<input type="text" name="RPT_USD" id="RPT_USD" style="width: 38% !important" <attr:length value="12" />>
	                            </td>
	                            <td><label for="CON_AMT">결제금액</label></td>
	                            <td><input type="text" name="CON_AMT" id="CON_AMT" <attr:length value="18" />></td>
	                        </tr>
	                        <tr>
	                            <td>
	                            	<label>순중량</label>
	                                <label for="SUN_WT" style="display: none;">순중량</label>
	                                <label for="SUN_UT" style="display: none;">순중량단위</label>
	                            </td>
	                            <td>
	                            	<input type="text" name="SUN_WT" id="SUN_WT" style="width: 50% !important" <attr:length value="16"/> <attr:numberOnly/> <attr:decimalFormat value="16,3"/>>
	                            	<input type="text" name="SUN_UT" id="SUN_UT" style="width: 30% !important" <attr:length value="3" />>
	                            </td>
	                            <td>
	                            	<label>수량</label>
	                                <label for="WT" style="display: none;">수량</label>
	                                <label for="RAN_UT" style="display: none;">수량단위</label>
	                            </td>
	                            <td>
	                            	<input type="text" name="WT" id="WT" style="width: 60% !important" <attr:length value="10" /> <attr:numberOnly/> >
	                            	<input type="text" name="RAN_UT" id="RAN_UT" style="width: 20% !important" <attr:length value="3" />>
	                            </td>
	                            <td>
	                            	<label>포장갯수</label>
	                                <label for="PACK_CNT" style="display: none;">포장갯수</label>
	                                <label for="PACK_UT" style="display: none;">포장단위</label>
	                            </td>
	                            <td>
	                            	<input type="text" name="PACK_CNT" id="PACK_CNT" style="width: 50% !important" <attr:length value="10" /> <attr:numberOnly/>>
	                            	<input type="text" name="PACK_UT" id="PACK_UT" style="width: 30% !important" <attr:length value="2" />>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <label for="ORI_ST_MARK1">원산지국가</label><!-- Combo,CMM_STD_CODE.CUS0005 -->
	                            </td>
	                            <td colspan="3">
	                            	<select id="ORI_ST_MARK1" name="ORI_ST_MARK1"  style="width: 50%"></select>
	                            </td>
	                            <td><label for="MG_CODE">송품장번호</label></td>
                            	<td><input type="text" name="MG_CODE" id="MG_CODE" <attr:length value="17" />></td>
	                        </tr>
							</table>
						</div><!-- //table_typeA --> 
					</div><!-- //vertical_frame_right46 -->    
				</div><!-- //vertical_frame -->
            </div><!-- //title_frame -->
            
			<div class="title_frame">
	            <c:choose>
					<c:when test="${REG_ID eq userId && (RECE eq NULL || RECE eq '' || RECE eq '01')}">
						<p style="margin-bottom: 5px !important;">
							<a href="#" class="btnToggle_table">모델&규격 상세정보</a>
							<a href="#" class="btn blue_84" id="btnModelSave" style="margin-right: 25px;">저장</a>
						</p>
					</c:when>
					<c:otherwise>
						<p><a href="#" class="btnToggle_table">모델&규격 상세정보</a></p>
					</c:otherwise>
				</c:choose>
            	<div class="vertical_frame">
	               	<div class="vertical_frame_left46">
	               		<div id="subGridLayer" style="height: 214px;"></div>
	               	</div>
               		<div class="vertical_frame_right46">
						<div class="table_typeA gray table_toggle">
							<table style="table-layout:fixed;"  id="itemTable">
								<input type="hidden" id="SIL" name="SIL" />
								<caption class="blind">모델&규격 상세정보</caption>
								<colgroup>
									<col width="13%" />
			                        <col width="20%" />
			                        <col width="13%" />
			                        <col width="20%" />
			                        <col width="13%" />
			                        <col width="20%" />
								</colgroup>
								<tr>
		                            <td><label for="GNM">모델규격</label></td>
		                            <td colspan="5"><input type="text" name="GNM" id="GNM" <attr:length value="300" />></td>
		                        </tr>
		                        <tr>
		                             <td><label for="COMP">성분</label></td>
		                             <td colspan="3"><input type="text" name="COMP" id="COMP" <attr:length value="70" />></td>
		                             <td><label for="QTY">수량</label></td>
		                            <td><input type="text" name="QTY" id="QTY" <attr:length value="14" /> <attr:numberOnly/>></td>
		                        </tr>
		                        
		                        <tr>
		                            <td><label for="QTY_UT">단위</label></td>
		                            <td><input type="text" name="QTY_UT" id="QTY_UT" <attr:length value="3" />></td>
		                             <td><label for="PRICE">단가</label></td>
		                            <td><input type="text" name="PRICE" id="PRICE" <attr:length value="18" /> <attr:numberOnly/>></td>
		                             <td><label for="M_AMT">금액</label></td>
		                            <td><input type="text" name="M_AMT" id="M_AMT" <attr:length value="16" /> <attr:numberOnly/>></td>
		                        </tr>
							</table>
						</div><!-- //table_typeA --> 
					</div><!-- //vertical_frame_right46 -->    
				</div><!-- //vertical_frame -->
            </div><!-- //title_frame -->
        </div>  
    </form>
</div><%-- // layer_content--%>

<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
