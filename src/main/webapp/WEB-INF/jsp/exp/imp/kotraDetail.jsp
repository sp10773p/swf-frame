<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var regNo = "${REGNO}";	// 최초 파라미터 전달 값, 이후 저장 시 갱신됨
    var prevData;	// 최종 조회 값
    
    $(function (){
    	$.comm.bindCombos.addComboInfo("SERVICE_DIVI", "AAA2001", true);
    	$.comm.bindCombos.addComboInfo("EXP_TYPE", "AAA2002", true);
    	$.comm.bindCombos.addComboInfo("TOT_PACK_UT", "CUS0043", true);
    	$.comm.bindCombos.addComboInfo("AMT_UT", "CUS0042", true);
    	
    	$.comm.bindCombos.draw();
    	
    	headers = [
			{"HEAD_TEXT" : "수출자명", "WIDTH" : "250", "FIELD_NAME" : "EXP_NM"},
			{"HEAD_TEXT" : "수출신고번호", "WIDTH" : "120",  "FIELD_NAME" : "RPT_NO"},
			{"HEAD_TEXT" : "총 금액", "WIDTH" : "100", "FIELD_NAME" : "TOT_AMT", "ALIGN":"right"},
			{"HEAD_TEXT" : "총 중량", "WIDTH" : "100", "FIELD_NAME" : "TOT_WT", "ALIGN":"right"}, 
			{"HEAD_TEXT" : "총 박스수", "WIDTH" : "80", "FIELD_NAME" : "TOT_PACK_CNT", "ALIGN":"right"},
			{"HEAD_TEXT" : "총 란수", "WIDTH" : "80", "FIELD_NAME" : "TOT_RAN", "ALIGN":"right"},
			{"HEAD_TEXT" : "해당 란수", "WIDTH" : "80", "FIELD_NAME" : "RAN_NO", "ALIGN":"right"},
			{"HEAD_TEXT" : "해당 NO.", "WIDTH" : "80", "FIELD_NAME" : "SIL", "ALIGN":"right"},
			{"HEAD_TEXT" : "상품명", "WIDTH" : "250",  "FIELD_NAME" : "STD_GNM"},
			{"HEAD_TEXT" : "수출신고 품명", "WIDTH" : "250",  "FIELD_NAME" : "EXC_GNM"},
			{"HEAD_TEXT" : "브랜드명", "WIDTH" : "250",  "FIELD_NAME" : "MODEL_GNM"},
			{"HEAD_TEXT" : "수량", "WIDTH" : "80", "FIELD_NAME" : "QTY", "ALIGN":"right"},
			{"HEAD_TEXT" : "화폐단위", "WIDTH" : "60", "FIELD_NAME" : "AMT_UT"},
			{"HEAD_TEXT" : "단가", "WIDTH" : "100", "FIELD_NAME" : "PRICE", "ALIGN":"right"},
			{"HEAD_TEXT" : "금액", "WIDTH" : "100", "FIELD_NAME" : "AMT", "ALIGN":"right"},
			{"HEAD_TEXT" : "HS CODE", "WIDTH" : "100", "FIELD_NAME" : "HS"}
		];

    	gridWrapper = new GridWrapper({
			"actNm" : "수출신고 정보",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectImpKotraItem",
			"requestUrl" : "/imp/selectImpKotraItemList.do",
			"headers" : headers,
			"check" : true,
			"firstLoad" : false, 
            "controllers"  : [
				{
					"btnName": "btn_del", "type": "D", "targetURI":"/imp/deleteImpKotraItems.do"
				}
			]			
		});    	

        function loadData() {
            $.comm.send(
            		"/imp/selectImpKotra.do", 
            		{"qKey" : "imp.selectImpKotra", "REGNO" : regNo}, 
    	       		function(data, status){
            			prevData = data.data;
    					$.comm.bindData(prevData);
    					
    					gridWrapper.addParam("REGNO", regNo);
    					
    					gridWrapper.requestToServer();
    				}, "반품수입신고의뢰 상세조회"
    		);
        }

        if(regNo) {
        	loadData();
        } else {	// 세션정보 셋팅
        	$('#REGNO').text('저장시 자동생성');
        }
      
        $('#btn_save').on("click", function (e) {
        	var addParams = {
        			"REGNO" : regNo
        	};

        	$.comm.sendForm("/imp/saveImpKotra.do", "detailForm", 
        			function(rst){
        				regNo = rst.data['REGNO'];
        				loadData();
        			}, 
        			"KOTRA WMS 반품의뢰 저장", function() {}, false, addParams);
        });
        
        $('#btn_list').on("click", function (e) {
            $.comm.pageBack();
        });
        
        $('#btn_add').on("click", function (e) {
        	if(!regNo) {
        		alert($.comm.getMessage("W00000035"));
        		
        		return;
        	}
        	
            $.comm.setModalArguments({"REGNO" : regNo, "FOD_ST_ISO" : 'CN'});
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
                <p>반품정보</p>
                <div class="title_btn_inner">
                    <a href="#" class="title_frame_btn" id="btn_list">목록</a>                       
                    <a href="#" class="title_frame_btn" id="btn_save">저장</a>   
                </div>
            </div>
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="160px"/>
                        <col width="*" />
                        <col width="160px" />
                        <col width="*" />
                        <col width="160px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td>
                            <label>주문번호 / 등록번호</label>
                            <label for="ORDER_ID" style="display: none;">주문번호</label>
                            <label for="REGNO" style="display: none;">등록번호</label>
                        </td>
                        <td><input type="text" class="td_input inputHeight" name="ORDER_ID" id="ORDER_ID"  style="width: calc(100% - 160px)" <attr:length value="35" /> <attr:mandantory/>/> / <span id="REGNO"></span></td>
                        <td><label for="SERVICE_DIVI">서비스구분</label></td>
                        <td><select class="td_select inputHeight" id="SERVICE_DIVI" name="SERVICE_DIVI" <attr:mandantory/>></select></td>
                        <td><label for="RETERN_NM">반품센터</label></td>
                        <td><input type="text" class="td_input inputHeight" name="RETERN_NM" id="RETERN_NM" <attr:length value="100" /> <attr:mandantory/>/></td>                        
                    </tr>
                    <tr>
                        <td><label for="EXP_WAYBILL_NO">화물수출운송장번호</label></td>
                        <td><input type="text" class="td_input inputHeight" name="EXP_WAYBILL_NO" id="EXP_WAYBILL_NO" <attr:length value="35" /> <attr:mandantory/>/></td>
                        <td><label for="EXP_RPT_NM">한국수출신고인</label></td>
                        <td><input type="text" class="td_input inputHeight" name="EXP_RPT_NM" id="EXP_RPT_NM" <attr:length value="70" /> <attr:mandantory/>/></td>
                        <td><label for="CONSIGNOR_NM">송화인 이름(중문)</label></td>
                        <td><input type="text" class="td_input inputHeight" name="CONSIGNOR_NM" id="CONSIGNOR_NM" <attr:length value="70" /> <attr:mandantory/>/></td>                        
                    </tr> 
                    <tr>
                        <td><label for="CONSIGNOR_TELNO">송화인 연락처(중문)</label></td>
                        <td><input type="text" class="td_input inputHeight" name="CONSIGNOR_TELNO" id="CONSIGNOR_TELNO" <attr:length value="35" /> <attr:mandantory/>/></td>
                        <td><label for="CONSIGNOR_ADDR">송화인 주소(중문)</label></td>
                        <td colspan="3"><input type="text" class="td_input inputHeight" name="CONSIGNOR_ADDR" id="CONSIGNOR_ADDR" <attr:length value="280" /> <attr:mandantory/>/></td>
                    </tr>              
                    <tr>
                        <td><label for="MD_NM">담당자(MD)</label></td>
                        <td><input type="text" class="td_input inputHeight" name="MD_NM" id="MD_NM" <attr:length value="35" /> <attr:mandantory/>/></td>
                        <td><label for="GOODS_NM">상품명(중문)</label></td>
                        <td colspan="3"><input type="text" class="td_input inputHeight" name="GOODS_NM" id="GOODS_NM" <attr:length value="280" /> <attr:mandantory/>/></td>
                    </tr>     
                    <tr>
                        <td><label for="WAYBILL_NO">반품배송송장번호(중문)</label></td>
                        <td><input type="text" class="td_input inputHeight" name="WAYBILL_NO" id="WAYBILL_NO" <attr:length value="35" />/></td>
                        <td><label for="DELIVERY_FIRM">반품배송택배사(중문)</label></td>
                        <td colspan="3"><input type="text" class="td_input inputHeight" name="DELIVERY_FIRM" id="DELIVERY_FIRM" <attr:length value="70" />/></td>
                    </tr>          
                    <tr>
                        <td><label for="EXP_TYPE">수출통관형태</label></td>
                        <td colspan="5"><select class="td_select inputHeight" id="EXP_TYPE" name="EXP_TYPE" style="width:150px;"></select></td>
                    </tr>                                                                         
                </table>
            </div>
		</div>
		
		<div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>수출신고 정보</p>
                <div class="title_btn_inner">
					<a href="#" class="title_frame_btn" id="btn_del">삭제</a>
					<a href="#" class="title_frame_btn" id="btn_add">추가</a>
				</div>
			</div>
            <div class="list_typeB">
                <div id="gridLayer" style="height: 300px"></div>
            </div>
		</div>	          
    </div>
    </form>
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
