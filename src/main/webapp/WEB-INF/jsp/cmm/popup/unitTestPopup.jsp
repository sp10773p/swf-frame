<%--
    Class Name : unitTestPopup.jsp
    Description : 단위테스트 매핑 팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성

    author : 성동훈
    since : 2017.01.15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "시간"          , "WIDTH": "80" , "FIELD_NAME": "LOG_DTM"},
                {"HEAD_TEXT": "Action명"      , "WIDTH": "80" , "FIELD_NAME": "RMK"},
                {"HEAD_TEXT": "URI"           , "WIDTH": "120", "FIELD_NAME": "URI"      ,"LINK":"fn_return", "ALIGN":"left"},
                {"HEAD_TEXT": "요청데이터"    , "WIDTH": "200", "FIELD_NAME": "PARAM"    ,"LINK":"fn_param", "ALIGN":"left"},
                {"HEAD_TEXT": "전체요청데이터", "WIDTH": "200", "FIELD_NAME": "ALL_PARAM","LINK":"fn_allParam", "ALIGN":"left"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "테스트 로그 조회",
                "targetLayer"  : "gridLayer",
                "paramsFormId" : "popSearchForm",
                "gridNaviId"   : "gridPagingLayer",
                "requestUrl"   : "/common/selectCmmLogTest.do",
                "headers"      : headers,
                "firstLoad"    : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
        });

        function fn_param(index) {
            var data = gridWrapper.getRowData(index);
            var param = data["PARAM"];

            $.comm.setModalArguments({"JSON_TEXT":param.replace(/,/gi, "\r\n")});

            var spec = "dialogWidth:700px;dialogHeight:600px;scroll:auto;status:no;center:yes;resizable:yes;;windowName:UNIT_TEST_PARAM_POPUP";
            $.comm.dialog("<c:out value="/jspView.do?jsp=cmm/popup/unitTestDetailPopup"/>", spec);
        }

        function fn_allParam(index) {
            var data = gridWrapper.getRowData(index);
            var allParam = data["ALL_PARAM"];
            allParam = JSON.parse(allParam);
            $.comm.setModalArguments({"JSON_TEXT":JSON.stringify(allParam, null, '\t')});

            var spec = "dialogWidth:700px;dialogHeight:800px;scroll:auto;status:no;center:yes;resizable:yes;;windowName:UNIT_TEST_ALL_PARAM_POPUP";
            $.comm.dialog("<c:out value="/jspView.do?jsp=cmm/popup/unitTestDetailPopup"/>", spec, function () {
                var ret = $.comm.getModalReturnVal();
                if(ret && ret["RETURN_VAL"]){
                    gridWrapper.setCellData(index, "ALL_PARAM", ret["RETURN_VAL"]);
                }
            });
        }

        function fn_return(index) {
            var data = gridWrapper.getRowData(index);
            var allParam = data["ALL_PARAM"];

            if($.comm.isNull(allParam)) return;

            var data = JSON.parse(allParam);
            for(var key in data){
                var val = data[key];
                var obj = opener.$('#' + key);
                if($.comm.isNull(key) || obj.length == 0)
                    continue;

                var tagObj = obj[0];
                if(tagObj.tagName.toLowerCase() == "span") {
                    obj.html(val);

                }else if(tagObj.tagName.toLowerCase() == "select"){
                    obj.val(val).attr("selected", "selected");

                }else if(tagObj.tagName.toLowerCase() == "input" && obj.attr('type').toLowerCase() == 'checkbox'){
                    $('input:checkbox[name="'+key+'"]').each(function() {
                        if(this.value == val){
                            this.checked = true;
                        }
                    });
                }else{
                    obj.val(val);
                }
            }
        }

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${TARGET_NM} 테스트</h1>
    </div><!-- layerTitle -->
    <form id="popSearchForm" name="popSearchForm">
        <input type="hidden" name="SCREEN_ID" id="SCREEN_ID" value="${TARGET_ID}">
        <div class="search_frame layer">
            <ul class="search_sectionE">
                <li>
                    <label for="F_LOG_DTM">로그일자</label><label for="T_LOG_DTM"
                                                              style="display: none">로그일자</label>
                    <div class="dateSearch">
                        <form action="#">
                            <fieldset>
                                <legend class="blind">달력</legend>
                                <input type="text" id="F_LOG_DTM" name="F_LOG_DTM" class="input" <attr:datefield to="T_LOG_DTM" value="0"/> />
                                <span>~</span>
                                <input type="text" id="T_LOG_DTM" name="T_LOG_DTM" class="input" <attr:datefield  value="0"/>/>
                            </fieldset>
                        </form>
                    </div>
                </li>
                <li>
                    <label for="SEARCH_COL1">검색조건</label>
                    <label for="SEARCH_TXT1" style="display: none">검색조건 SEARCH_TXT1</label>
                    <select id="SEARCH_COL1" name="SEARCH_COL1" style="width:100px;" <attr:changeNoSearch/>>
                        <option value="RMK">Action명</option>
                        <option value="ALL_PARAM">전체요청데이터</option>
                        <option value="URI">URI</option>
                    </select>
                    <input id="SEARCH_TXT1" name="SEARCH_TXT1" type="text" style="width:220px"/>
                </li>
            </ul><!-- search_sectionC -->
            <a href="#조회" class="btn_inquiryD" id="btnSearch">조회</a>
        </div>
    </form>
    <div class="white_frame">
        <div class="util_frame">
        </div>
        <div id="gridLayer" style="height: 410px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
