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
        var pHs = arguments.HS;
        $(function () {
            headers = [
                {"HEAD_TEXT": "HS코드" 		, "WIDTH": "100"  , "FIELD_NAME": "HS_CD"		, "ALIGN": "center" , "LINK":"fn_return"},
                {"HEAD_TEXT": "품명(한글)" 	, "WIDTH": "150"  , "FIELD_NAME": "STD_NM_HN"	, "ALIGN": "left"},
                {"HEAD_TEXT": "품명(영문)" 	, "WIDTH": "150"  , "FIELD_NAME": "STD_NM_EN"	, "ALIGN": "left", "LINK":"fn_return"},
                {"HEAD_TEXT": "수량단위" 		, "WIDTH": "80"  , "FIELD_NAME": "PKG_UNIT"},
                {"HEAD_TEXT": "중량단위" 		, "WIDTH": "80"  , "FIELD_NAME": "WT_UNIT"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "HS조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "qKey"         : "sel.selectHsList",
                "headers"      : headers,
                "firstLoad"    : false,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            
            $("#P_HS_CD").val(pHs);
            gridWrapper.requestToServer();
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
        <h1>HS코드</h1>
    </div>
    <form id="popSearchForm" name="popSearchForm">
		<div class="search_frame on">
			<ul class="search_sectionB">
                <li>
                    <label for="P_HS_CD" class="search_title">HS코드</label>
                    <input type="text" id="P_HS_CD" name="P_HS_CD" class="search_input" />
                </li>
                <li>
                    <label for="P_STD_NM_HN" class="search_title">품명(한글)</label>
                    <input type="text" id="P_STD_NM_HN" name="P_STD_NM_HN" class="search_input" />
                </li>
                <li>
                    <label for="P_STD_NM_EN" class="search_title">HS품명(영문)</label>
                    <input type="text" id="P_STD_NM_EN" name="P_STD_NM_EN" class="search_input" />
                </li>
            </ul><!-- search_sectionC -->
           	<a href="#" class="btn_inquiryB" id="btnSearch">조회</a>
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
