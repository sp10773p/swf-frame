<%--
  User: jjkhj
  Date: 2017-01-10
  Form: 반품수입신고결과조회 상세
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
    var gridRan, gridRanItem;
    var ranDtlLast, ranItemDtlLast;
    
    $(function (){
    	var ranHeader = [
			{"HEAD_TEXT": "란번호" , "WIDTH": "80", "FIELD_NAME": "RAN_NO"},
			{"HEAD_TEXT": "세번부호", "WIDTH": "80", "FIELD_NAME": "HS", 
				"LINK": function (rIdx){
						ranDtlLast = gridRan.getData()[rIdx];
						for(var id in ranDtlLast) {
							if($('#' + id)) $('#' + id).text(ranDtlLast[id]);
						}

						gridRanItem.addParam('RAN_NO', gridRan.getData()[rIdx]['RAN_NO']);
						gridRanItem.requestToServer();
					}, "POSIT" : true
			},
			{"HEAD_TEXT": "거래품명", "WIDTH": "120", "FIELD_NAME": "EXC_GNAME"},
			{"HEAD_TEXT": "과세가격원화", "WIDTH": "120", "FIELD_NAME": "TAX_KRW"},
			{"HEAD_TEXT": "관세", "WIDTH": "120", "FIELD_NAME": "GS"},
			{"HEAD_TEXT": "부가세", "WIDTH": "120", "FIELD_NAME": "VAT"}
		];
    	
    	gridRan = new GridWrapper({
            "actNm": "반품수입신고결과조회  란조회",
            "targetLayer": "gridRanLayer",
            "qKey": "imp.selectImpResRan",
            "requestUrl": "/imp/selectImpResRanList.do",
            "headers": ranHeader,
            "paramsGetter" : {"RPT_NO" : "${RPT_NO}"}, 
            "firstLoad": false,
            "postScript": function (){
            	if(gridRan.getData().length > 0) {
            		ranDtlLast = gridRan.getData()[0];
					for(var id in ranDtlLast) {
						if($('#' + id)) $('#' + id).text(ranDtlLast[id]);
					}
            		
            		gridRanItem.addParam('RAN_NO', gridRan.getData()[0]['RAN_NO']);
            		gridRanItem.requestToServer();
            	} else {
            		gridRanItem.drawGrid();
            		if(ranDtlLast) {
    					for(var id in ranDtlLast) {
    						if($('#' + id)) $('#' + id).text('');
    					}
    					ranDtlLast = null;
            		}
            	}
			}
        });
    	
    	var ranItemHeader = [
			{"HEAD_TEXT": "순번", "WIDTH": "80", "FIELD_NAME": "SIL"},
			{"HEAD_TEXT": "모델규격", "WIDTH": "200", "FIELD_NAME": "IMP_GNAME1"},
			{"HEAD_TEXT": "성분", "WIDTH": "120", "FIELD_NAME": "COMPOENT1"},
			{"HEAD_TEXT": "수량", "WIDTH": "120", "FIELD_NAME": "QTY"},
			{"HEAD_TEXT": "단위", "WIDTH": "150", "FIELD_NAME": "UT"},
			{"HEAD_TEXT": "단가"	, "WIDTH": "100", "FIELD_NAME": "UPI"},
			{"HEAD_TEXT": "금액", "WIDTH": "100", "FIELD_NAME": "AMT"}
   		];
    	         	
    	gridRanItem = new GridWrapper({
			"actNm": "반품수입신고결과조회  란 아이템 조회",
			"targetLayer": "gridRanItemLayer",
			"qKey": "imp.selectImpResRanItem",
			"requestUrl": "/imp/selectImpResRanItemList.do",
			"headers": ranItemHeader,
			"paramsGetter" : {"RPT_NO" : "${RPT_NO}"}, 
			"firstLoad": false
		});    	
               
		$.comm.send(
			"/imp/selectImpRes.do", 
			{"qKey" : "imp.selectImpRes", "RPT_NO" : "${RPT_NO}"}, 
			function(data, status){
				$.comm.bindData(data.data);
				gridRan.requestToServer();
			}, "반품수입신고결과 상세조회"
   		);
        
        $('#btn_back').on("click", function (e) {
            $.comm.pageBack();
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
                    <a href="#" class="title_frame_btn" id="btn_back">목록</a>                       
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
                        <td><label for="RPT_NO">신고번호</label></td>
                        <td><span id="RPT_NO"></span></td>
                        <td><label for="IMP_REQ_NO">의뢰관리번호</label></td>
                        <td><span id="IMP_REQ_NO"></span></td>
                        <td>
                            <label>신고일자/수리일자</label>
                            <label for="RPT_DAY" style="display: none;">신고일자</label>
                            <label for="LIS_DAY" style="display: none;">수리일자</label>
                        </td>
                        <td><span id="RPT_DAY"></span> / <span id="LIS_DAY"></span></td>                        
                    </tr>
                    <tr>
                        <td>
                            <label>BL번호/분할여부</label>
                            <label for="BLNO" style="display: none;">BL번호</label>
                            <label for="BL_YN" style="display: none;">분할여부</label>
                        </td>
                        <td><span id="BLNO"></span> / <span id="BL_YN"></span></td>                        
                        <td><label for="MAS_BLNO">Master B/L</label></td>
                        <td><span id="MAS_BLNO"></span></td>
                        <td>
                            <label>화물관리번호</label>
                            <label for="MRN" style="display: none;">화물관리번호MRN</label>
                            <label for="MSN" style="display: none;">화물관리번호MSN</label>
                            <label for="HSN" style="display: none;">화물관리번호HSN</label>
                        </td>
                        <td><span id="MRN"></span> / <span id="MSN"></span> / <span id="HSN"></span></td>
                    </tr>                    
                </table>
            </div>
        </div>
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>신고인</p>
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
                        <td><label for="RPT_FIRM">상호</label></td>
                        <td><span id="RPT_FIRM"></span></td>
                        <td><label for="RPT_NAME">대표자성명</label></td>
                        <td><span id="RPT_NAME"></span></td>
                        <td><label for="RPT_TELNO">전화번호</label></td>
                        <td><span id="RPT_TELNO"></span></td>                        
                    </tr>   
                    <tr>
                        <td><label for="RPT_EMAIL">이메일주소</label></td>
                        <td><span id="RPT_EMAIL"></span></td>
                        <td><label for="RPT_TELNO_EXTENSION">내선전화번호</label></td>
                        <td><span id="RPT_TELNO_EXTENSION"></span></td>    
                        <td></td>
                        <td></td>                            
                   </tr>                           
                </table>
            </div>
        </div>    
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>수입자</p>
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
                        <td><label for="IMP_FIRM">상호</label></td>
                        <td><span id="IMP_FIRM"></span></td>
                        <td><label for="IMP_TGNO">통관고유부호</label></td>
                        <td><span id="IMP_TGNO"></span></td>
                        <td><label for="IMP_DIVI">수입자구분</label></td>
                        <td><span id="IMP_DIVI"></span></td>                        
                    </tr>   
                </table>
            </div>
        </div>       
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>납세의무자</p>
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
                        <td><span id="NAB_FIRM"></span></td>
                        <td><label for="NAB_NAME">대표자성명</label></td>
                        <td><span id="NAB_NAME"></span></td>
                        <td><label for="NAB_TGNO">통관고유부호</label></td>
                        <td><span id="NAB_TGNO"></span></td>                        
                    </tr>   
                    <tr>
                        <td><label for="NAB_SDNO">사업자번호</label></td>
                        <td><span id="NAB_SDNO"></span></td>
                        <td><label for="NAB_TELNO">전화번호</label></td>
                        <td><span id="NAB_TELNO"></span></td>
                        <td><label for="NAB_EMAIL">메일주소</label></td>
                        <td><span id="NAB_EMAIL"></span></td>                        
                    </tr>                       
                    <tr>
                        <td>
	                    	<label>우편번호/주소</label>
	                        <label for="NAB_PA_MARK" style="display: none;">우편번호</label>
	                        <label for="NAB_ADDR1" style="display: none;">주소</label>
						</td>
                        <td colspan="3"><span id="NAB_PA_MARK"></span> / <span id="NAB_ADDR1"></span></td>
                        <td>
	                    	<label>건물번호/도로명코드</label>
	                        <label for="NAB_BLDG_NO" style="display: none;">건물번호</label>
	                        <label for="NAB_ROAD_CD" style="display: none;">도로명코드</label>
                        </td>
                        <td><span id="NAB_BLDG_NO"></span> / <span id="NAB_ROAD_CD"></span></td>    
                   </tr>                           
                </table>
            </div>
        </div>    
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>해외공급자</p>
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
                        <td><label for="SUP_FIRM">상호</label></td>
                        <td><span id="SUP_FIRM"></span></td>
                        <td><label for="SUP_MARK">해외거래처부호</label></td>
                        <td><span id="SUP_MARK"></span></td>
                        <td><label for="SUP_ST">국가코드</label></td>
                        <td><span id="SUP_ST"></span></td>                        
                    </tr>   
                </table>
            </div>
        </div>   
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>신고정보</p>
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
                        <td><span id="CUS"></span> / <span id="SEC"></span></td>
                        <td><label for="RPT_DIVI_MARK">신고구분</label></td>
                        <td><span id="RPT_DIVI_MARK"></span></td>
                        <td><label for="EXC_DIVI_MARK">거래구분</label></td>
                        <td><span id="EXC_DIVI_MARK"></span></td>                        
                    </tr>   
                    <tr>
                        <td>
	                    	<label>수입종류/징수형태</label>
	                        <label for="IMP_KI_MARK" style="display: none;">수입종류</label>
	                        <label for="LEV_FORM" style="display: none;">징수형태</label>
                        </td>
                        <td><span id="IMP_KI_MARK"></span> / <span id="LEV_FORM"></span></td>
                        <td><label for="ORI_ST_PRF_YN">원산지증명서유무</label></td>
                        <td><span id="ORI_ST_PRF_YN"></span></td>
                        <td><label for="AMT_RPT_YN">가격신고서유무</label></td>
                        <td><span id="AMT_RPT_YN"></span></td>                        
                    </tr>                       
                    <tr>
                        <td><label for="FOD_MARK">적출국코드</label></td>
                        <td><span id="FOD_MARK"></span></td>
                        <td><label for="ARR_MARK">도착항코드</label></td>
                        <td><span id="ARR_MARK"></span></td>                        
                        <td>
	                    	<label>운송수단/운송용기</label>
	                        <label for="TRA_MET" style="display: none;">운송수단</label>
	                        <label for="TRA_CTA" style="display: none;">운송용기</label>
                        </td>
                        <td><span id="TRA_MET"></span> / <span id="TRA_CTA"></span></td>
                    </tr>              
                    <tr>
                        <td>
	                    	<label>선기명/국적</label>
	                        <label for="SHIP" style="display: none;">선기명</label>
	                        <label for="ST_CODE" style="display: none;">선기국적</label>
                        </td>
                        <td><span id="SHIP"></span> / <span id="ST_CODE"></span></td>
                        <td>
	                    	<label>총포장개수/단위</label>
	                        <label for="TOT_PACK_CNT" style="display: none;">총포장개수</label>
	                        <label for="TOT_PACK_UT" style="display: none;">총포장단위</label>
                        </td>
                        <td><span id="TOT_PACK_CNT"></span> / <span id="TOT_PACK_UT"></span></td>
                        <td><label for="TOT_WT">중량합계</label></td>
                        <td><span id="TOT_WT"></span></td>                        
                    </tr>  
                    <tr>
                        <td><label for="ARR_DAY">입항일자</label></td>
                        <td><span id="ARR_DAY"></span></td>
                        <td><label for="INC_DAY">반입일자</label></td>
                        <td><span id="INC_DAY"></span></td>
                        <td><label for="TRA_CHF_MARK">운수기관부호</label></td>
                        <td><span id="TRA_CHF_MARK"></span></td>                        
                    </tr>              
                    <tr>
                        <td>
	                    	<label>검사장소부호/위치</label>
	                        <label for="CHK_PA_MARK" style="display: none;">검사장소부호</label>
	                        <label for="CHK_PA" style="display: none;">검사장소위치</label>
                        </td>
                        <td><span id="CHK_PA_MARK"></span> / <span id="CHK_PA"></span></td>
                        <td><label for="CHK_PA_NAME">검사장소명</label></td>
                        <td><span id="CHK_PA_NAME"></span></td>
                        <td><label for="TOT_RAN_CNT">총란수</label></td>
                        <td><span id="TOT_RAN_CNT"></span></td>                        
                    </tr>                                 
                </table>
            </div>
        </div>  
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>결제금액 / 신고금액</p>
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
	                    	<label>인도조건-통화단위</label>
	                        <label for="CON_COD" style="display: none;">인도조건</label>
	                        <label for="CON_CUR" style="display: none;">통화단위</label>
                        </td>
                        <td><span id="CON_COD"></span> - <span id="CON_CUR"></span></td>
                        <td>
	                    	<label>운임/보험료</label>
	                        <label for="FRE_KRW" style="display: none;">운임</label>
	                        <label for="INSU_KRW" style="display: none;">보험료</label>
                        </td>
                        <td><span id="FRE_KRW"></span> / <span id="INSU_KRW"></span></td>
                        <td>
	                    	<label>가산금액/공제금액</label>
	                        <label for="AD_CST_KRW" style="display: none;">가산금액</label>
	                        <label for="SUB_CST_KRW" style="display: none;">공제금액</label>
                        </td>
                        <td><span id="AD_CST_KRW"></span> / <span id="SUB_CST_KRW"></span></td>                  
                    </tr>   
                    <tr>
                        <td>
	                    	<label>결제금액-결제방법</label>
	                        <label for="CON_AMT" style="display: none;">결제금액</label>
	                        <label for="CON_KI" style="display: none;">결제방법</label>
                        </td>
                        <td><span id="CON_AMT"></span> - <span id="CON_KI"></span></td>
                        <td>
	                    	<label>총신고금액원화/미화</label>
	                        <label for="TOT_TAX_KRW" style="display: none;">총신고금액원화</label>
	                        <label for="TOT_TAX_USD" style="display: none;">총신고금액미화</label>
                        </td>
                        <td><span id="TOT_TAX_KRW"></span> / <span id="TOT_TAX_USD"></span></td>
                        <td>
	                    	<label>결제환율/미화환율</label>
	                        <label for="CON_RATE" style="display: none;">결제환율</label>
	                        <label for="CON_RATE_USD" style="display: none;">미화환율</label>
                        </td>
                        <td><span id="CON_RATE"></span> / <span id="CON_RATE_USD"></span></td>                  
                    </tr>                       
                </table>
            </div>
        </div>  
        
        <div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>총세액내역</p>
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
                        <td><label for="TOT_GS">총관세</label></td>
                        <td><span id="TOT_GS"></span></td>
                        <td><label for="TOT_TS">총개별소비세</label></td>
                        <td><span id="TOT_TS"></span></td>
                        <td><label for="TOT_HOF">총주세</label></td>
                        <td><span id="TOT_HOF"></span></td>                        
                    </tr>   
                    <tr>
                        <td><label for="TOT_GT">교통세</label></td>
                        <td><span id="TOT_GT"></span></td>
                        <td><label for="TOT_KY">총교육세</label></td>
                        <td><span id="TOT_KY"></span></td>
                        <td><label for="TOT_NT">총농특세</label></td>
                        <td><span id="TOT_NT"></span></td>                        
                    </tr>          
                    <tr>
                        <td><label for="TOT_VAT">부가세</label></td>
                        <td><span id="TOT_VAT"></span></td>
                        <td><label for="VAT_TAX_CT">부가세 과세과표</label></td>
                        <td><span id="VAT_TAX_CT"></span></td>
                        <td><label for="VAT_FREE_CT">부가세면세과표</label></td>
                        <td><span id="VAT_FREE_CT"></span></td>                        
                    </tr>        
                    <tr>
                        <td><label for="TOT_TAX_SUM">총세액합계</label></td>
                        <td><span id="TOT_TAX_SUM"></span></td>
                        <td><label for="TOT_DLY_TAX">총신고지연가산세</label></td>
                        <td><span id="TOT_DLY_TAX"></span></td>
                        <td><label for="TOT_ADD_TAX">미신고가산세</label></td>
                        <td><span id="TOT_ADD_TAX"></span></td>                        
                    </tr>        
                    <tr>
                        <td><label for="NAB_NO">납부고지번호</label></td>
                        <td><span id="NAB_NO"></span></td>
                        <td><label for="NAB_DELI_DAY">납부고지서발행일자</label></td>
                        <td><span id="NAB_DELI_DAY"></span></td>
                        <td><label for="SP_DELI">특송업체부호</label></td>
                        <td><span id="SP_DELI"></span></td>                        
                    </tr>                                                             
                </table>
            </div>
        </div>
		<div class="title_frame" style="margin-bottom: 5px;">
            <div class="title_btn_frame clearfix">
                <p>란</p>
            </div>         
			<div class="vertical_frame">
				<div class="vertical_frame_left46">
					<div id="gridRanLayer" style="height: 285px;"></div>
               	</div>
				<div class="vertical_frame_right46">
					<div class="table_typeA gray table_toggle">
						<table style="table-layout:fixed;" >
							<caption class="blind">란 상세정보</caption>
							<colgroup>
								<col width="15%" />
		                        <col width="18%" />
		                        <col width="15%" />
		                        <col width="18%" />
		                        <col width="15%" />
		                        <col width="18%" />
							</colgroup>
							<tr>
								<td>
									<label>란번호/세번부호</label>
									<label for="RAN_NO" style="display: none;">란번호</label>
									<label for="HS" style="display: none;">세번부호</label>	                           
								</td>
								<td><span id="RAN_NO"></span> / <span id="HS"></span></td>
								<td>
	                            	<label>상표코드/상표명</label>
	                                <label for="STD_CODE" style="display: none;">상표코드</label>
	                                <label for="MODEL_GNAME" style="display: none;">상표명</label>								
								</td>
								<td colspan="3"><span id="STD_CODE"></span> / <span id="MODEL_GNAME"></span></td>
	                        </tr>
	                        <tr>
	                            <td><label for="STD_GNAME">품명</label></td>
	                            <td colspan="5"><span id="STD_GNAME"></span></td>
	                        </tr>
	                        <tr>
	                            <td><label for="EXC_GNAME">거래품명</label></td>
	                            <td colspan="5"><span id="EXC_GNAME"></span></td>
	                        </tr>
							<tr>
								<td><label for="SUN_WT">순중량</label></td>
								<td><span id="SUN_WT"></span></td>
								<td>
	                            	<label>수량/단위</label>
	                                <label for="QTY" style="display: none;">수량</label>
	                                <label for="QTY_UT" style="display: none;">수량단위</label>					
								</td>
								<td><span id="QTY"></span> / <span id="QTY_UT"></span></td>								
								<td>
	                            	<label>환급물량/단위</label>
	                                <label for="REF_WT" style="display: none;">환급물량</label>
	                                <label for="REF_UT" style="display: none;">환급물량단위</label>						
								</td>
								<td><span id="REF_WT"></span> / <span id="REF_UT"></span></td>
	                        </tr>
							<tr>
								<td><label for="TAX_KRW">과세가격원화</label></td>
								<td><span id="TAX_KRW"></span></td>
								<td><label for="TAX_USD">과세가격미화</label></td>
								<td><span id="TAX_USD"></span></td>								
								<td>
	                            	<label>원산지</label>
	                                <label for="ORI_ST_MARK1" style="display: none;">원산지국가부호</label>
	                                <label for="ORI_ST_MARK2" style="display: none;">원산지 표시유무</label>
	                                <label for="ORI_ST_MARK3" style="display: none;">원산지 방법</label>
	                                <label for="ORI_ST_MARK4" style="display: none;">원산지 형태</label>			
								</td>
								<td><span id="ORI_ST_MARK1"></span> - <span id="ORI_ST_MARK2"></span> - <span id="ORI_ST_MARK3"></span> - <span id="ORI_ST_MARK4"></span></td>								
	                        </tr>	  
							<tr>
								<td><label for="GS">관세</label></td>
								<td><span id="GS"></span></td>
								<td>
	                            	<label>관세율/구분</label>
	                                <label for="GS_RATE" style="display: none;">관세율</label>
	                                <label for="GS_DIVI" style="display: none;">관세구분</label>		
								</td>
								<td><span id="GS_RATE"></span> / <span id="GS_DIVI"></span></td>								
								<td><label for="GS_RMV_MARK">감면분납부호</label></td>
								<td><span id="GS_RMV_MARK"></span></td>
	                        </tr>	        
							<tr>
								<td><label for="NG">내국세액</label></td>
								<td><span id="NG"></span></td>
								<td><label for="KY">교육세</label></td>
								<td><span id="KY"></span></td>
								<td><label for="NT">농특세</label></td>
								<td><span id="NT"></span></td>								
	                        </tr>	  
							<tr>
								<td><label for="VAT">부가세</label></td>
								<td><span id="VAT"></span></td>
								<td><label for="RAN_VAT_TAX_CT">과세과표</label></td>
								<td><span id="RAN_VAT_TAX_CT"></span></td>
								<td><label for="RAN_VAT_FREE_CT">면세과표</label></td>
								<td><span id="RAN_VAT_FREE_CT"></span></td>								
	                        </tr>	  	
							<tr>
								<td><label for="TOT_SIZE_CNT">총규격수</label></td>
								<td><span id="TOT_SIZE_CNT"></span></td>
								<td><label for="TOT_EXP_CNT">총수출면세수입수</label></td>
								<td><span id="TOT_EXP_CNT"></span></td>
								<td><label for="TOT_C4_CNT">총요건비대상수</label></td>
								<td><span id="TOT_C4_CNT"></span></td>								
	                        </tr>	  	                                                
						</table>
					</div>
				</div>
			</div>
		</div>
            
		<div class="title_frame">
            <div class="title_btn_frame clearfix">
                <p>모델&amp;규격</p>
			</div>
            <div class="list_typeB">
                <div id="gridRanItemLayer" style="height: 214px;"></div>
            </div>
		</div>	
		            
	</div>                    
    </form>
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
