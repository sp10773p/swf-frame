<%--
    Class Name : decDetail.jsp
    Description : 모바일 수출신고 상세
    Modification Information
       수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성
    author : 성동훈
    since : 2017.03.27
    2017.03.31  김회재 수정
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-mobile-header.jspf" %>
    <link rel="stylesheet" href="<c:url value='/css/mobile/view.css'/>"/>
    <script>
    	var gridMaster, headers, gridDetail, headersDetail;
    	var globalVar = {};
        $(function() {
        	fn_bind();		//데이터 바인드
        	
        	fn_setGrid();	//그리드 초기화
        });
        
        function fn_bind(){
        	var param = {
                "qKey"    : "dec.selectDecDetail",
                "RPT_NO"  : "${RPT_NO}"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
            		$.comm.bindData(data.data);
		            //gridMaster.requestToServer();
                },
                "수출신고 상세정보 조회"
            );
        }
        
    	function fn_setGrid(){
	   		headers = [
				{"HEAD_TEXT": "란번호"       	, "WIDTH": "80"   , "FIELD_NAME": "RAN_NO", "LINK":"fn_modelList"},
				{"HEAD_TEXT": "세번부호"     	, "WIDTH": "80"   , "FIELD_NAME": "HS"},
				{"HEAD_TEXT": "품명"     	, "WIDTH": "80"   , "FIELD_NAME": "STD_GNM"},
                {"HEAD_TEXT": "거래품명"		, "WIDTH": "100"  , "FIELD_NAME": "EXC_GNM"},
                {"HEAD_TEXT": "수량"       	, "WIDTH": "100"  , "FIELD_NAME": "WT"},
                {"HEAD_TEXT": "신고금액원화"	, "WIDTH": "120"  , "FIELD_NAME": "RPT_KRW"}
                
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "수출신고  란조회",
                "targetLayer"  : "gridRanLayer",
                "qKey"         : "dec.selectDecRanList",
                "countId"      : "totCnt1",
                "headers"      : headers,
                "paramsGetter" : {"RPT_NO":"${RPT_NO}", "RPT_SEQ":"${RPT_SEQ}"},
                "gridNaviId"   : "",
                "check"        : false,
                "firstLoad"    : true,
                "postScript"   : function (){fn_modelList(0);}
            });
        	
        	headersDetail = [
				{"HEAD_TEXT": "란번호"       	, "WIDTH": "80"   , "FIELD_NAME": "RAN_NO"},
				{"HEAD_TEXT": "순번"       	, "WIDTH": "80"   , "FIELD_NAME": "SIL"},
				{"HEAD_TEXT": "모델규격"     	, "WIDTH": "200"   , "FIELD_NAME": "GNM"},
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
                "countId"      : "totCnt2",
                "headers"      : headersDetail,
                "paramsFormId" : "",
                "gridNaviId"   : "",
                "check"        : false,
                "firstLoad"    : false
            });
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
            gridDetail.requestToServer();
        }

    </script>
</head>
<body>
    <div class="veiw_table">
        <div class="util_frame">
            <h2>기본정보</h2>
        </div>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>제출번호</th>
                <td><span id="RPT_NO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>주문번호</th>
                <td><span id="ORDER_ID" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>신고자상호</th>
                <td><span id="RPT_FIRM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>신고자성명</th>
                <td><span id="RPT_BOSS_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>신고일자</th>
                <td><span id="RPT_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>수리일자</th>
                <td><span id="EXP_LIS_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>적재의무기한</th>
                <td><span id="JUK_DAY" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>수출대행자 정보</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>상호</th>
                <td><span id="COMM_FIRM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>통관고유부호</th>
                <td><span id="COMM_TGNO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>수출자구분</th>
                <td><span id="EXP_DIVI_NM" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>수출화주</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>상호</th>
                <td><span id="EXP_FIRM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>통관고유부호</th>
                <td><span id="EXP_TGNO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>성명</th>
                <td><span id="EXP_BOSS_NAME" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>사업자번호</th>
                <td><span id="EXP_SDNO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>우편번호</th>
                <td><span id="EXP_POST" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>주소</th>
                <td><span id="EXP_ADDR1" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>상세주소</th>
                <td><span id="EXP_ADDR2" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>제조자정보</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>상호</th>
                <td><span id="MAK_FIRM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>통관고유부호</th>
                <td><span id="MAK_TGNO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>우편번호</th>
                <td><span id="MAK_POST" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>산업단지부호</th>
                <td><span id="INLOCALCD_NM" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>물품소재지/구매자</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>우편번호</th>
                <td><span id="GDS_POST" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>주소</th>
                <td><span id="GDS_ADDR1" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>상호</th>
                <td><span id="BUY_FIRM" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>환급신청인/통관구분</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>간이환급신청</th>
                <td><span id="RET_DIVI_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>세관</th>
                <td><span id="RPT_CUS_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>과</th>
                <td><span id="RPT_SEC_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>결제방법</th>
                <td><span id="CON_MET_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>운송수단</th>
                <td><span id="TRA_MET_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>목적국</th>
                <td><span id="TA_ST_ISO_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>적재항</th>
                <td><span id="FOD_CODE_NM" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>신고물품내역</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>총중량</th>
                <td><span id="TOT_WT" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>중량단위</th>
                <td><span id="UT" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>총포장수</th>
                <td><span id="TOT_PACK_CNT" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>포장단위</th>
                <td><span id="TOT_PACK_UT_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>인도조건</th>
                <td><span id="AMT_COD_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>통화</th>
                <td><span id="CUR_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>결제금액</th>
                <td><span id="AMT" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>운임원화</th>
                <td><span id="FRE_KRW" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>보험료원화</th>
                <td><span id="INSU_KRW" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>결제환율</th>
                <td><span id="EXC_RATE_CUR" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>미화환율</th>
                <td><span id="EXC_RATE_USD" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>신고금액원화</th>
                <td><span id="TOT_RPT_KRW" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>신고금액미화</th>
                <td><span id="TOT_RPT_USD" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>총란수</th>
                <td><span id="TOT_RAN" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="veiw_table">
        <h2>신고인기재란</h2>
        <table>
            <caption class="blind">수출신고 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>신고인기재란</th>
                <td><span id="RPT_USG" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="view_list">
        <h2>란 목록</h2>
        <div class="util_frame">
            <p class="total" id="totCnt1"></p>
        </div>
        <ul class="list_style" id="gridRanLayer">
        </ul>
    </div>
    <div class="view_list">
        <h2>모델&규격 목록</h2>
        <div class="util_frame">
            <p class="total" id="totCnt2"></p>
        </div>
        <ul class="list_style" id="subGridLayer">
        </ul>
    </div>
</body>
</html>
