<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
	<script>
    var gridWrapper, headers;
    
    $(function (){
        headers = [
			{"HEAD_TEXT": "수출신고번호", "WIDTH": "150" , "FIELD_NAME": "RPT_NO"}, 
			{"HEAD_TEXT": "란", "WIDTH": "30" , "FIELD_NAME": "RAN_NO"},
			{"HEAD_TEXT": "규격" , "WIDTH": "30" , "FIELD_NAME": "SIL"},
			{"HEAD_TEXT": "HS부호" , "WIDTH": "100" , "FIELD_NAME": "HS"},
			{"HEAD_TEXT": "수리일자", "WIDTH": "100" , "FIELD_NAME": "EXP_LIS_DAY"},
			{"HEAD_TEXT": "수출국", "WIDTH": "40" , "FIELD_NAME": "TA_ST_ISO"},
			{"HEAD_TEXT": "규격", "WIDTH": "150" , "FIELD_NAME": "GNM1"},
			{"HEAD_TEXT": "수량", "WIDTH": "80" , "FIELD_NAME": "QTY"},
			{"HEAD_TEXT": "단위", "WIDTH": "30" , "FIELD_NAME": "QTY_UT"},
			{"HEAD_TEXT": "단가", "WIDTH": "80" , "FIELD_NAME": "PRICE"},
			{"HEAD_TEXT": "금액", "WIDTH": "80" , "FIELD_NAME": "AMT"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm" : "수출신고 목록 조회",
			"targetLayer" : "gridLayer",
			"qKey" : "imp.selectExpItem",
			"requestUrl" : "/imp/selectExpItemList.do",
			"headers" : headers,
			"paramsFormId" : "searchForm",
			"paramsGetter" : {"REQ_NO" : $.comm.getModalArguments()["REQ_NO"], "REGNO" : $.comm.getModalArguments()["REGNO"], "FOD_ST_ISO" : $.comm.getModalArguments()["FOD_ST_ISO"]}, 
			"gridNaviId" : "gridPagingLayer",
			"check" : true,
			"firstLoad" : true,
			"controllers" : [
				 {"btnName": "btnSearch", "type": "S"}
			]
		});
		            
		$('#btn_sel').on("click", function (e) {
			var size = gridWrapper.getSelectedSize();
            if(size == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없스니다.
                return;
            }
           
            $.comm.send(
            		$.comm.getModalArguments()["REQ_NO"] ? "/imp/createImpReqItems.do" : "/imp/createImpKotraItems.do", 
            		gridWrapper.getSelectedRows(), 
    	       		function(data, status){
            			self.close();
    				}, $.comm.getModalArguments()["REQ_NO"] ? "반품수입신고모델 추가" : "KOTRA 수출신고 정보 추가"
    		);
		});
	});
	</script>
</head>
<body>
<div class="layerContainer">
	<div class="layerTitle">
		<h1>수출수리내역</h1>
	</div>
	<div class="layer_btn_frame"></div> 	
	<div class="layer_content">
		<div class="search_frame on">
			<form id="searchForm">		
				<ul class="search_sectionB">
					<li>
						<label for="" class="search_title">수리일자</label>
						<div class="search_date">
							<fieldset>
								<legend class="blind">달력</legend>
								<label for="F_EXP_LIS_DAY" style="display: none">검식기준시작일</label>
								<input type="text" id="F_EXP_LIS_DAY" name="F_EXP_LIS_DAY" class="input" <attr:datefield to="T_EXP_LIS_DAY"  value="0"/> />
	                                  <span>~</span>
								<label for="T_EXP_LIS_DAY" style="display: none">검식기준종료일</label>
								<input type="text" id="T_EXP_LIS_DAY" name="T_EXP_LIS_DAY" class="input" <attr:datefield  value="0"/> />
							</fieldset>
						</div>
					</li>
					<li>
						<label for="RPT_NO" class="search_title">수출신고번호</label>
						<input type="text" class="search_input" id="RPT_NO" name="RPT_NO" />
					</li>
				</ul><!-- search_sectionB -->
				<a href="#" class="btn_inquiryB"  id="btnSearch">조회</a>
			</form>			
		</div><!-- search_frame -->
        <div class="list_typeA">
            <div class="util_left64">
                <p class="total">Total <span id="totCnt"></span><span id="gridLayerTempSelect" style="background: #15a4fa;">적출국코드와 동일한 수출국 수출신고 건만 조회됩니다.</span>
            </div>        
            <div class="util_frame">
                 <a href="#" class="btn white_84" id="btn_sel">적용</a>
            </div>
            <div id="gridLayer" style="height: 300px"></div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>		
	</div><!-- layer_content -->
</div>	
</body>
</html>