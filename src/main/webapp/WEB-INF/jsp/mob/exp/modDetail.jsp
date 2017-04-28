<%--
    Class Name : modDetail.jsp
    Description : 모바일 수출정정취하신고  상세
    Modification Information
       수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.04.03  김회재   최초 생성

    author : 김회재
    since : 2017.04.03
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-mobile-header.jspf" %>
    <link rel="stylesheet" href="<c:url value='/css/mobile/view.css'/>"/>
    <script>
    var gridItem, headersItem;
    	var globalVar = {};
        $(function() {
        	fn_bind();		//데이터 바인드
     
        	fn_setGrid();	//그리드 초기화
        });
        
        function fn_bind(){
        	var param = {
    			"qKey"    : "mod.selectModDetail",
                "RPT_NO"  : "${RPT_NO}",
                "MODI_SEQ"  : "${MODI_SEQ}"
            };

            $.comm.send("/common/select.do", param,
                function(data, status){
            		$.comm.bindData(data.data);
                },
                "수출정정취하신고 상세정보 조회"
            );
        }
        
    	function fn_setGrid(){
    		headersItem = [
                {"HEAD_TEXT": "구분"        		, "WIDTH": "80"    , "FIELD_NAME": "RAN_DIVI"},
                {"HEAD_TEXT": "란"       		, "WIDTH": "80"    , "FIELD_NAME": "RAN_NO"},
                {"HEAD_TEXT": "규격"       	    , "WIDTH": "80"    , "FIELD_NAME": "SIZE_NO"},
                {"HEAD_TEXT": "항목"      		, "WIDTH": "120"   , "FIELD_NAME": "ITEM_NO"},
                {"HEAD_TEXT": "항목명"       		, "WIDTH": "150"   , "FIELD_NAME": "ITEM_NM"   , "ALIGN":"left"},
                {"HEAD_TEXT": "정정전내역"       	, "WIDTH": "250"   , "FIELD_NAME": "MODIFRONT" , "ALIGN":"left"},
                {"HEAD_TEXT": "정정후내역"       	, "WIDTH": "250"   , "FIELD_NAME": "MODIAFTER" , "ALIGN":"left"}
                
            ];

    		gridItem = new GridWrapper({
		   		"actNm"        : "수출정정 내역 조회",
	            "targetLayer"  : "gridItemLayer",
	            "qKey"         : "mod.selectModSubList",
	            "countId"      : "totCnt1",
                "headers"      : headersItem,
                "paramsGetter" : {"RPT_NO":"${RPT_NO}", "MODI_SEQ":"${MODI_SEQ}"},
                "gridNaviId"   : "",
                "check"        : false,
                "firstLoad"    : true,
                "postScript"   : function (){fn_setForm();}
            });
        	
	   	}
    	
    	function fn_setForm(){
        	var size = gridItem.getSize();
        	//조회된 List가 없을때 그리드 삭제
            if(size == 0){
            	$("#gridItemDiv").hide();
            }
        }
    	
    </script>
</head>
<body>
    <div class="veiw_table">
        <div class="util_frame">
            <h2>기본정보</h2>
        </div>
        <table>
            <caption class="blind">수출정정 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>제출번호</th>
                <td><span id="RPT_NO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>차수</th>
                <td><span id="MODI_SEQ" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>정정승인일자</th>
                <td><span id="DPT_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>승인번호</th>
                <td><span id="DPT_NO" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>심사담당자부호</th>
                <td><span id="JU_MARK" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>심사담당자부성명</th>
                <td><span id="JU_NAME" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>세관</th>
                <td><span id="CUS_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>과</th>
                <td><span id="SEC_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>정정신청일자</th>
                <td><span id="MODI_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>수출신고일자</th>
                <td><span id="RPT_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>수출수리일자</th>
                <td><span id="LIS_DAY" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>수출자상호</th>
                <td><span id="EXP_NAME" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>통관고유부호</th>
                <td><span id="EXP_TGNO" style="display: inline;"/></td>
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
        <h2>신청구분/사유</h2>
        <table>
            <caption class="blind">수출정정 상세정보에 대한 표입니다.</caption>
            <tbody>
            <tr>
                <th>신청구분</th>
                <td><span id="SEND_DIVI_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>정정/취하사유 부호</th>
                <td><span id="MODI_DIVI_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>귀책사유</th>
                <td><span id="DUTY_CODE_NM" style="display: inline;"/></td>
            </tr>
            <tr>
                <th>정정/취하사유</th>
                <td><span id="MODI_COT" style="display: inline;"/></td>
            </tr>
            </tbody>
        </table>
    </div>
    <c:if test="${SEND_DIVI eq 'A' || SEND_DIVI eq 'C'}">
	    <div id="gridItemDiv"  class="view_list">
		    <h2>정정내역</h2>
		    <div class="util_frame">
	            <p class="total" id="totCnt"></p>
	        </div>
		    <ul class="list_style" id="gridItemLayer">
		    </ul>
	    </div>
    </c:if>
</body>
</html>
