<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        headers = [
            {"HEAD_TEXT" : "운송장번호",		"FIELD_NAME" : "REGINO",		"WIDTH" : "120",	"ALIGN" : "center",	"COLR" : "",	"LINK":"fn_popup"}, 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDERNO",		"WIDTH" : "120",	"ALIGN" : "center",	"COLR" : ""}, 
            {"HEAD_TEXT" : "수취인명",		"FIELD_NAME" : "RECEIVENAME",	"WIDTH" : "100",	"ALIGN" : "center",	"COLR" : ""},
            {"HEAD_TEXT" : "수취인국가코드",	"FIELD_NAME" : "COUNTRYCD",		"WIDTH" : "100",	"ALIGN" : "center",	"COLR" : ""},
            {"HEAD_TEXT" : "이벤트시간",		"FIELD_NAME" : "EVENTHMS",		"WIDTH" : "100",	"ALIGN" : "center",	"COLR" : ""},
            {"HEAD_TEXT" : "발생우체국명",	"FIELD_NAME" : "EVENTREGIPONM",	"WIDTH" : "100",	"ALIGN" : "left",	"COLR" : ""}, 
            {"HEAD_TEXT" : "배달결과설명",	"FIELD_NAME" : "DELIVRSLTNM",	"WIDTH" : "100",	"ALIGN" : "left",	"COLR" : ""}, 
            {"HEAD_TEXT" : "배달완료여부",	"FIELD_NAME" : "DELIVERYYN",	"WIDTH" : "80",		"ALIGN" : "center",	"COLR" : ""}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "배송현황 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectStatList",
            "requestUrl" : "/ems/stat/selectStatList.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : true,
            "defaultSort"  : "REGNO DESC",
            "controllers" : [
                {"btnName" : "btnSearch", "type" : "S"} 
            ]
        });
        
        fn_setCombo();
        
        // toUpperCase
//         $('[id=SEARCH_COUNTRY_CD]').on("keyup", function(e) {
//             $(this).val($(this).val().toUpperCase());
//         });
    });

    function fn_setCombo() {
        $.comm.bindCombos.addComboInfo("SEARCH_COUNTRY_CD", "CUS0005", true, null, 3, true);	//수취인국가
        $.comm.bindCombos.draw();
    }
    
    // 배송이력 조회 (팝업)
    function fn_popup(index) {
        var data = gridWrapper.getRowData(index);
        var REGINO = data["REGINO"];
//         $.comm.open("tracePopup", '<c:out value="/jspView.do?jsp=ems/stat/statTracePopup" />'+"&REGINO="+REGINO, 1000, 900);
        
        $.comm.setModalArguments({"REGINO":REGINO});
        var spec = "width:1000px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;windowName:statTracePopup";
        $.comm.dialog('<c:out value="/jspView.do?jsp=ems/stat/statTracePopup" />', spec); // 모달 호츨
    }
</script>
</head>
<body>
<div class="inner-box">
    <div class="padding_box">
        <div class="search_toggle_frame">
            <div class="search_frame on">
                <form id="searchForm" name="searchForm">
                    <ul class="search_sectionC">
                        <li>
                            <label for="F_REG_DTM" class="search_title">등록일자</label>
                            <label for="T_REG_DTM" class="search_title" style="display: none">등록일자</label>
                            <div class="search_date">
                                <fieldset>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" <attr:datefield to="T_REG_DTM" value="-1m"/> >
                                    <span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" <attr:datefield value="0"/>>
                                </fieldset>
                            </div>
                        </li>
                        <li>
                            <label for="SEARCH_DELIVERY_YN" class="search_title">배달완료여부</label> 
                            <select name="SEARCH_DELIVERY_YN" id="SEARCH_DELIVERY_YN" class="search_input_select">
                                <option value="" selected>전체</option>
                                <option value="Y">Y</option>
                                <option value="N">N</option>
                            </select>
                        </li>
                        <li>
                            <label for="SEARCH_COL" class="search_title">검색조건</label> 
                            <label for="SEARCH_TXT" class="search_title" style="display: none">검색조건 TEXT</label>
                            <select name="SEARCH_COL" id="SEARCH_COL" class="search_input_select">
                                <option value="order_no" selected>주문번호</option>
                                <option value="exprt_no">수출신고번호</option>
                                <option value="regi_no">운송장번호</option>
                            </select>
                            <input type="text" class="search_input" id="SEARCH_TXT" name="SEARCH_TXT" <attr:pk/> />
                        </li>
                        <li>
                            <label for="SEARCH_COUNTRY_CD" class="search_title">수취국가코드</label> 
<!--                             <input type="text" class="search_input" id="SEARCH_COUNTRY_CD" name="SEARCH_COUNTRY_CD" maxlength="2" style="width:50px;" <attr:alphaOnly/> /> -->
                            <select name="SEARCH_COUNTRY_CD" id="SEARCH_COUNTRY_CD" class="search_input_select" style="width:300px;"></select>
                        </li>
                    </ul>
                    <!-- search_sectionC -->
                    <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float: right;">조회</a>
                </form>
            </div><!-- search_frame -->
            <a href="#" class="search_toggle close">검색접기</a>
        </div><!-- search_toggle_frame -->

        <div class="list_typeA">
            <div class="util_frame">
            </div><!-- //util_frame -->
            <div id="gridLayer" style="height: 400px">
            </div>
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<!-- //inner-box -->
<%@ include file="/WEB-INF/include/include-body.jspf"%>
</body>
</html>
