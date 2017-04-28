<%--
  User: jjkhj
  Date: 2017-02-20
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf" %>
    <script>
        var gridWrapper, headers;
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var target = arguments && arguments.TARGET ? arguments.TARGET : '';
        $(function () {
            headers = [
				{"HEAD_TEXT": "우편번호" , "WIDTH": "80", "FIELD_NAME": "ZIP_CD"},
                {"HEAD_TEXT": "주소" , "WIDTH": "*", "FIELD_NAME": "NAME_KR", "ALIGN": "left" , "LINK":"fn_return"}
               /*  {"HEAD_TEXT": "ADDRESS" , "WIDTH": "120", "FIELD_NAME": "ADDRESS"},
                {"HEAD_TEXT": "ADDR_DIV" , "WIDTH": "120"  , "FIELD_NAME": "ADDR_DIV"},
                {"HEAD_TEXT": "ADDR_DET" , "WIDTH": "120"  , "FIELD_NAME": "ADDR_DET"},
                {"HEAD_TEXT": "RMGMTNO" , "WIDTH": "120"  , "FIELD_NAME": "RMGMTNO"},
                {"HEAD_TEXT": "ZIPCODE" , "WIDTH": "120"  , "FIELD_NAME": "ZIPCODE"},
                {"HEAD_TEXT": "ZIPCODE1" , "WIDTH": "120"  , "FIELD_NAME": "ZIPCODE1"},
                {"HEAD_TEXT": "ZIPCODE2" , "WIDTH": "120"  , "FIELD_NAME": "ZIPCODE2"},
                {"HEAD_TEXT": "ROADCD" , "WIDTH": "120"  , "FIELD_NAME": "ROADCD"},
                {"HEAD_TEXT": "BLDGNO" , "WIDTH": "120"  , "FIELD_NAME": "BLDGNO"} */
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "우편번호조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                //"requestUrl"   : "/dec/selectZipCode.do",
                "qKey"         : "zip.selectZipCode",
                "dbPoolName"   : "zip",
                "headers"      : headers,
                "firstLoad"    : false,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            if(target && target == 'NON' ) { //로그인 전 화면에서 호출시
            	gridWrapper.requestUrl = "/common/selectZipcodePagingList.do"
            }
        });

        // 상위메뉴 선택
        function fn_return(index) {
            var retVal = gridWrapper.getRowData(index);
            $.comm.setModalReturnVal(retVal);
            self.close();
        }

    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>주소찾기</h1>
    </div>
    <div class="title_frame" style="margin-top: 10px; margin-bottom: 0px;">
    	<p style="background: none; font-size: 15px;">도로명을 이용해서 검색해 보세요.<br />건물번호를 함께 입력하시면 더욱 정확한 결과가 검색됩니다.<br />예) 판교역로 235, 제주 첨단로 242, 영동대로 511</p>
    </div>
    <form id="popSearchForm" name="popSearchForm">
    <div class="layer_content">
       <div class="search_toggle_frame">
			<div class="search_frame on">
				<ul class="search_sectionB">
	                <li>
	                    <select id="SEARCH_COL" name="SEARCH_COL" class="search_input_select" <attr:changeNoSearch/>>
	                        <option value='서울특별시'>서울특별시</option>
				            <option value='부산광역시'>부산광역시</option>
				            <option value='대구광역시'>대구광역시</option>
				            <option value='인천광역시'>인천광역시</option>
				            <option value='광주광역시'>광주광역시</option>
				            <option value='대전광역시'>대전광역시</option>
				            <option value='울산광역시'>울산광역시</option>
				            <option value='경기도'>경기도</option>
				            <option value='강원도'>강원도</option>
				            <option value='충청북도'>충청북도</option>
				            <option value='충청남도'>충청남도</option>
				            <option value='세종특별자치시'>세종특별자치시</option>
				            <option value='전라북도'>전라북도</option>
				            <option value='전라남도'>전라남도</option>
				            <option value='경상북도'>경상북도</option>
				            <option value='경상남도'>경상남도</option>
				            <option value='제주특별자치도'>제주특별자치도</option>
	                    </select>
	                    <input type="text" id="SEARCH_TXT" name="SEARCH_TXT" class="search_input" />
	                </li>
	            </ul><!-- search_sectionC -->
            	<a href="#" class="btn_inquiryB" id="btnSearch">조회</a>
            </div>
        </div>
    </div>
    </form>
    <div class="white_frame">
        <div class="util_frame">
        </div>
        <div id="gridLayer" style="height: 320px;">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
