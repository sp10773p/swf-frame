<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        headers = [
            {"HEAD_TEXT" : "우편물구분",				"FIELD_NAME" : "PREMIUMCD_NM",		"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "물품종류",				"FIELD_NAME" : "EM_EE_NM",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "예약번호",				"FIELD_NAME" : "REQNO",				"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "운송장번호",				"FIELD_NAME" : "REGINO",			"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "등록일자",				"FIELD_NAME" : "REG_DATE",			"WIDTH" : "100",	"ALIGN" : "center"}, 
            {"HEAD_TEXT" : "진행상태",				"FIELD_NAME" : "EVENTNM",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "총중량(g)",				"FIELD_NAME" : "TOTWEIGHT",			"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "총요금",					"FIELD_NAME" : "PRERECEVPRC",		"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "발송인명",				"FIELD_NAME" : "SENDER",			"WIDTH" : "150",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인명",				"FIELD_NAME" : "RECEIVENAME",		"WIDTH" : "150",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수취인전화번호",			"FIELD_NAME" : "RECEIVETELNO",		"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수취인국가코드",			"FIELD_NAME" : "COUNTRYCD",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수취인국가명",			"FIELD_NAME" : "COUNTRYNM",			"WIDTH" : "150",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수취인우편번호",			"FIELD_NAME" : "RECEIVEZIPCODE",	"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수취인주소",				"FIELD_NAME" : "RECEIVEADDR",		"WIDTH" : "400",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "승인번호",				"FIELD_NAME" : "APPRNO",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "보험가입여부",			"FIELD_NAME" : "BOYN",				"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "보험가입금액",			"FIELD_NAME" : "BOPRC",				"WIDTH" : "100",	"ALIGN" : "right"},
            {"HEAD_TEXT" : "고객주문번호",			"FIELD_NAME" : "ORDERNO",			"WIDTH" : "150",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "발송인전화번호",			"FIELD_NAME" : "SENDERTELNO",		"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "발송인휴대전화",			"FIELD_NAME" : "SENDERMOBILE",		"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "발송인우편번호",			"FIELD_NAME" : "SENDERZIPCODE",		"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "발송인주소",				"FIELD_NAME" : "SENDERADDR",		"WIDTH" : "400",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "주문인명",				"FIELD_NAME" : "ORDERPRSNNM",		"WIDTH" : "200",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "주문인전화번호",			"FIELD_NAME" : "ORDERPRSNTELNO",	"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "주문인휴대전화",			"FIELD_NAME" : "ORDERPRSNHTELNO",	"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "주문인우편번호",			"FIELD_NAME" : "ORDERPRSNZIPCD",	"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "주문인주소",				"FIELD_NAME" : "ORDERPRSNADDR",		"WIDTH" : "400",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출우편물관세청제공여부",	"FIELD_NAME" : "ECOMMERCEYN",		"WIDTH" : "150",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "사업자번호",				"FIELD_NAME" : "BIZREGNO",			"WIDTH" : "150",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수출화주 성명 또는 상호",	"FIELD_NAME" : "EXPORTSENDPRSNNM",	"WIDTH" : "150",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출화주 주소",			"FIELD_NAME" : "EXPORTSENDPRSNADDR","WIDTH" : "400",	"ALIGN" : "left"},
            {"HEAD_TEXT" : "수출이행등록여부",			"FIELD_NAME" : "XPRTNOYN",			"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "수출신고번호1",			"FIELD_NAME" : "XPRTNO1",			"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량/분할 발송여부",		"FIELD_NAME" : "TOTDIVSENDYN1",		"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "선기적 포장개수",			"FIELD_NAME" : "WRAPCNT1",			"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "수출신고번호2",			"FIELD_NAME" : "XPRTNO2",			"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량/분할 발송여부",		"FIELD_NAME" : "TOTDIVSENDYN2",		"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "선기적 포장개수",			"FIELD_NAME" : "WRAPCNT2",			"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "수출신고번호3",			"FIELD_NAME" : "XPRTNO3",			"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량/분할 발송여부",		"FIELD_NAME" : "TOTDIVSENDYN3",		"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "선기적 포장개수",			"FIELD_NAME" : "WRAPCNT3",			"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "수출신고번호4",			"FIELD_NAME" : "XPRTNO4",			"WIDTH" : "130",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량/분할 발송여부",		"FIELD_NAME" : "TOTDIVSENDYN4",		"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "선기적 포장개수",			"FIELD_NAME" : "WRAPCNT4",			"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "추천우체국",				"FIELD_NAME" : "RECOMPOREGIPOCD",	"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "SKU재고관리번호",			"FIELD_NAME" : "SKUSTOCKMGMTNO",	"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "결제수단",				"FIELD_NAME" : "PAYTYPECD",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "결제통화",				"FIELD_NAME" : "CURRUNIT",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "결제승인번호",			"FIELD_NAME" : "PAYAPPRNO",			"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "관세납부자",				"FIELD_NAME" : "DUTYPAYPRSNCD",		"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "납부관세액",				"FIELD_NAME" : "DUTYPAYAMT",		"WIDTH" : "100",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "관세납부통화",			"FIELD_NAME" : "DUTYPAYCURR",		"WIDTH" : "100",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "박스가로길이(cm)",		"FIELD_NAME" : "BOXLENGTH",			"WIDTH" : "110",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "박스세로길이(cm)",		"FIELD_NAME" : "BOXWIDTH",			"WIDTH" : "110",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "박스높이(cm)",			"FIELD_NAME" : "BOXHEIGHT",			"WIDTH" : "110",	"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "대표내용물",				"FIELD_NAME" : "CONTENTS",			"WIDTH" : "300",	"ALIGN" : "left"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "기표지출력 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectCovList",
            "requestUrl" : "/ems/cov/selectCovList.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : false,
            "defaultSort"  : "REQNO",
            "controllers" : [
                {"btnName" : "btnSearch", "type" : "S"}
            ]
        });
        
        fn_setCombo();
        
        // toUpperCase
//         $('[id=SEARCH_COUNTRY_CD]').on("keyup", function(e) {
//             $(this).val($(this).val().toUpperCase());
//         });
        
        gridWrapper.requestToServer();
    });
    
    function fn_setCombo() {
        $.comm.bindCombos.addComboInfo("SEARCH_COUNTRY_CD", "CUS0005", true, null, 3, true);	//수취인국가
        $.comm.bindCombos.draw();
    }

    function fn_ExecPrintEmsP() {
        if (!gridWrapper.getSelectedSize() > 0) {
            alert($.comm.getMessage("I00000029")); //인쇄할 항목을 선택해 주세요.
            return;
        }
        
        var rows = gridWrapper.getSelectedRows();
        var params = {};
        var EM_KIND = new Array(); // 물품종류
        var cnt = 0;
        $.each (rows, function(index, data) {
            cnt = cnt + 1;
            params["pREGNO." + cnt] = data["REGNO"];
            
            var em_ee = getSafeString(data['EM_EE']);
            if ($.inArray(em_ee, EM_KIND) == -1) { // EM_KIND에 해당 물품종류가 없을경우
                EM_KIND.push(em_ee);
            }
        });
        
        if (EM_KIND.length > 1) {
            alert($.comm.getMessage("I00000030")); // 서로 다른 종류의 기표지는 함께 인쇄 할수 없습니다. 서류형, 비서류형 또는 K-Packet, K-Packet-Light 별로 선택후 인쇄해 주세요
            return;
        }
        
        if (EM_KIND == "ee" || EM_KIND == "em") { // 서류 / 비서류
            $.comm.setModalArguments({"EM_KIND":EM_KIND, "PARAMS":params});
            var spec = "width:300px;height:230px;scroll:auto;status:no;center:yes;resizable:yes;windowName:choosePopup";
            $.comm.dialog('<c:out value="/jspView.do?jsp=ems/cov/choosePopup" />', spec); // 모달 호츨
        }
        else {
            reportPrint(EM_KIND, "", params);
        }
    }
    
    function reportPrint(emKind, labelType, params) {
        if (emKind == "ee") { // 서류
            if (labelType == "A") {
                fnReportPrint('EMS_EE', params, '기표지 출력(서류)');
            }
            else {
                fnReportPrint('EMS_EE_B', params, '기표지 출력(서류)');
            }
        }
        else if (emKind == "em") { // 비서류
            if (labelType == "A") {
                fnReportPrint('EMS_EM', params, '기표지 출력(비서류)');
            }
            else {
                fnReportPrint('EMS_EM_B', params, '기표지 출력(비서류)');
            }
        }
        else if (emKind == "re") { // K-Packet
            fnReportPrint('KPACKET', params, '기표지 출력(K-packet)');
        }
        else if (emKind == "rl") { // K-Packet Light
            fnReportPrint('KPACKET_LIGHT', params, '기표지 출력(K-packet Light)');
        }
        else { // Light EMS, SeaExpress
            alert($.comm.getMessage("I00000038")); //서류, 비서류, K-Packet / K-Packet Light만 출력 가능합니다.
        }
    }
    
    function getSafeString(val) {
        return (val === undefined) ? "" : val;
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
                            <label for="EM_EE" class="search_title">물품종류</label> 
                            <select name="EM_EE" id="EM_EE" class="search_input_select">
                                <option value="" selected>전체</option>
                                <option value="ee">서류</option>
                                <option value="em">비서류</option>
                                <option value="re">K-Packet</option>
                                <option value="rl">K-Packet Light</option>
                                <option value="el">Light EMS</option>
<!--                                 <option value="es">SeaExpress</option> -->
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
                <a href="javascript:fn_ExecPrintEmsP();" class="btn white_84">기표지인쇄</a>
            </div><!-- //util_frame -->
            <div id="gridLayer" style="overflow: auto; height: 414px">
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
