<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers;
    var globalVar = {
        "SN" : "",
        "SEQ" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        globalVar.SN = arguments.SN;
        globalVar.SEQ = arguments.SEQ;
        headers = [ 
            {"HEAD_TEXT" : "몰명",			"FIELD_NAME" : "MALL_ID",					"WIDTH" : "110",	"ALIGN" : "left"}, 
            {"HEAD_TEXT" : "주문번호",		"FIELD_NAME" : "ORDER_ID",					"WIDTH" : "110",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "결제금액",		"FIELD_NAME" : "PAYMENTAMOUNT",				"WIDTH" : "65",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "중량",			"FIELD_NAME" : "SUMMARY_TOTALWEIGHT",		"WIDTH" : "50",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "수량",			"FIELD_NAME" : "SUMMARY_TOTALQUANTITY",		"WIDTH" : "40",		"ALIGN" : "right",	"DATA_TYPE" : "NUM"},
            {"HEAD_TEXT" : "목적지",			"FIELD_NAME" : "DESTINATIONCOUNTRYCODE",	"WIDTH" : "40",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "상태",			"FIELD_NAME" : "RECE_NM",					"WIDTH" : "70",		"ALIGN" : "center"},
            {"HEAD_TEXT" : "수출신고번호",	"FIELD_NAME" : "RPT_NO",					"WIDTH" : "120",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "등록일시",		"FIELD_NAME" : "MOD_DTM",					"WIDTH" : "135",	"ALIGN" : "center"},
            {"HEAD_TEXT" : "전량분할",		"FIELD_NAME" : "TOTDIVSENDYN",				"WIDTH" : "65",		"ALIGN" : "center",	"HTML_FNC" : "fn_html1"},
            {"HEAD_TEXT" : "포장개수",		"FIELD_NAME" : "WRAPCNT",					"WIDTH" : "65",		"ALIGN" : "center",	"HTML_FNC" : "fn_html2"}
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "합배송 추가대상 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectPickMergeList",
            "requestUrl" : "/ems/pick/selectPickMergeList.do",
            "headers" : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId" : "gridPagingLayer",
            "check" : true,
            "firstLoad" : true,
            "defaultSort"  : "REQ_NO",
            "pageRow" : 10,
            "controllers" : [ 
                {"btnName" : "btnSearch", "type" : "S"}
            ]
        });
        
        // 합배송 추가
        $('#btn_add').on("click", function(e) {
            if (opener == null) {
                return;
            }
            
            // 수출신고수리내역
            var gridWrapperSelectedSize = gridWrapper.getSelectedSize();
            var gridWrapperSelectedRows = gridWrapper.getSelectedRows();
            
            // 합배송 목록
            var openerGridMasterSelectedSize = opener.gridMaster.getSelectedSize();
            var openerGridMasterSelectedRows = opener.gridMaster.getSelectedRows();
            
            // 합배송 상세 목록
            var openerGridDetailSize = opener.gridDetail.getSize();
            var openerGridDetailData = opener.gridDetail.getData();
            
            if (!gridWrapperSelectedSize > 0) {
                alert($.comm.getMessage("W00000013")); //합배송할 항목을 선택해 주세요.
                return;
            }

            if (openerGridMasterSelectedSize != 1) {
                alert($.comm.getMessage("W00000014")); //합배송 관리에서 합배송할 항목을 선택해 주세요
                return;
            }

            if (opener.fnCheckPickReqComplete()) {
                alert($.comm.getMessage("W00000021")); //이미 EMS픽업요청이 완료된 건입니다.
                return;
            }

            if ((openerGridDetailSize + gridWrapperSelectedSize) > 4) {
                alert($.comm.getMessage("W00000017")); //EMS 합배송은추가는 최대 4건 까지만 가능합니다.
                return;
            }
            
            var dupeCnt = 0;
            var differentCountryCnt = 0;
            $.each (gridWrapperSelectedRows, function(index, value) {
                var XPRTNO = value["RPT_NO"]; //수리번호
                var COUNTRYCD = value["DESTINATIONCOUNTRYCODE"]; //목적지
                if (opener.dupeCheck(XPRTNO)) { //수출신고번호 중복체크
                    dupeCnt++;
                }
                if (!opener.existCountryCd(COUNTRYCD)) { //목적지 체크
                    differentCountryCnt++;
                }
            });
            
            if (differentCountryCnt > 0) {
                alert($.comm.getMessage("W00000018")); //목적지가 다르면 추가할 수 없습니다.
                return;
            }
            
            if (dupeCnt > 0 && gridWrapperSelectedSize == dupeCnt) {
                alert($.comm.getMessage("W00000019")); //이미 추가된 수출신고번호입니다.
                return;
            } else if (dupeCnt > 0 && gridWrapperSelectedSize > dupeCnt) {
                alert($.comm.getMessage("W00000020")); //이미 추가된 수출신고번호가 존재합니다.
                return;
            }

            var isValid = true;
            $.each (gridWrapperSelectedRows, function(index, value) {
                var chk = value['CHK'];
                if (chk == '1'){
                    var idx = value['RIDX'];
                    
                    var TOTDIVSENDYN = $('#TOTDIVSENDYN_'+idx); // 전량분할
                    var WRAPCNT = $('#WRAPCNT_'+idx); //포장개수
                    if (TOTDIVSENDYN.val() == "") {
                        alert($.comm.getMessage("W00000015")); //전량분할여부를 선택해 주세요
                        TOTDIVSENDYN.focus();
                        return isValid = false;
                    } else if (WRAPCNT.val() == "") {
                        alert($.comm.getMessage("W00000016")); //포장개수를 입력해 주세요
                        WRAPCNT.focus();
                        return isValid = false;
                    }
                }
            });

            if (!isValid)
                return;

            if (!confirm($.comm.getMessage("C00000006"))) { //추가하시겠습니까?
                return;
            }

            var paramArray = new Array();

            // 추가된 목록
            $.each (openerGridDetailData, function(index, value) {
                var param = new Object();
                param.XPRTNO = value["XPRTNO"]; //수출신고번호
                param.TOTDIVSENDYN = value["TOTDIVSENDYN"]; // 전량분할
                param.WRAPCNT = value["WRAPCNT"]; //포장개수
                paramArray.push(param);
            });

            // 추가할 목록
            $.each (gridWrapperSelectedRows, function(index, value) {
                var chk = value['CHK'];
                if (chk == '1'){
                    var idx = value['RIDX'];
                    var param = new Object();
                    param.XPRTNO = value["RPT_NO"]; //수출신고번호
                    param.TOTDIVSENDYN = $('#TOTDIVSENDYN_'+idx).val(); // 전량분할
                    param.WRAPCNT = $('#WRAPCNT_'+idx).val(); //포장개수
                    paramArray.push(param);
                }
            });
           
            var param = {
                "SN":opener.getSn(),
                "SEQ":opener.getSeq(),
                "PARAMS":JSON.stringify(paramArray),
                "CRUD":"I"
            };
            
            $.comm.send("/ems/pick/savePickMerge.do", param, fn_callback, "합배송리스트 저장");
        });
    });
    
    var fn_callback = function (data) {
        if (data.code.indexOf('I') == 0) {
//             fn_select();
            opener.fn_select();
            self.close();
        }
    }
    
    // 조회
    function fn_select() {
        gridWrapper.requestToServer();
    }

    function fn_html1(index, val) {
        var html = '';
        html += '<select id="TOTDIVSENDYN_' + index + '" name="TOTDIVSENDYN" class="td_select inputHeight" style="width: 55px; margin-left: -5px;">';
        html += '    <option value="">선택</option>';
        html += '    <option value="Y">Y: 전량</option>';
        html += '    <option value="N">N: 분할</option>';
        html += '</select>';
        return html
    }

    function fn_html2(index, val) {
//         var html = '<input type="text" id="WRAPCNT_' + index + '" name="WRAPCNT" class="td_input_list inputHeight" maxlength="5" style="width: 60px" numberonly="true" />';
        var html = '<input type="text" id="WRAPCNT_' + index + '" name="WRAPCNT" class="td_input_list inputHeight" maxlength="5" style="width: 55px; margin-left: -5px;" numberOnly="true" />';
        return html
    }
    
</script>
</head>
<body>
    <div class="layerContainer autoHeight">
        <div class="layerTitle">
            <h1>${ACTION_MENU_NM}</h1>
        </div><!-- layerTitle -->
        
        <div class="layer_content">
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
                            <label for="EXCEPT_Y" class="search_title">이행상태</label> 
                            <label for="EXCEPT_N" class="search_title" style="display: none">이행상태</label> 
                            <div class="radio"> 
                                <input type="radio" id="EXCEPT_Y" name="EXCEPT_YN" value="Y" checked />
                                <label for="EXCEPT_Y" class="search_title"><span></span>제외</label>
                            </div>
                            <div class="radio"> 
                                <input type="radio" id="EXCEPT_N" name="EXCEPT_YN" value="N" />
                                <label for="EXCEPT_N" class="search_title"><span></span>포함</label>
                            </div>
                        </li>
                        
                        <li>
                            <label for="REGIST_METHOD" class="search_title">등록구분</label> 
                            <select name="REGIST_METHOD" id="REGIST_METHOD" class="search_input_select">
                                <option value="" selected>전체</option>
                                <option value="API">표준API</option>
                                <option value="FAPI">해외API</option>
                                <option value="EXCEL">엑셀</option>
                            </select>
                        </li>
                        
                        <li>
                            <label for="SEARCH_COL" class="search_title">검색조건</label> 
                            <label for="SEARCH_TXT" class="search_title" style="display: none">검색조건 TEXT</label>
                            <select name="SEARCH_COL" id="SEARCH_COL" class="search_input_select">
                                <option value="ORDER_ID" selected>주문번호</option>
                                <option value="RPT_NO">수출신고번호</option>
                                <option value="DESTINATIONCOUNTRYCODE">목적지(국가코드)</option>
                                <option value="MALL_ID">몰명</option>
                                <option value="RECEIVE_NAME">수취인</option>
                            </select>
                            <input type="text" class="search_input" placeholder="" id="SEARCH_TXT" name="SEARCH_TXT" />
                        </li>
                    </ul><!-- search_sectionC -->
                    <a href="#" id="btnSearch" class="btn_inquiryB">조회</a>
                </form>
            </div><!-- search_frame -->
            <div class="white_frame">
                <div class="util_frame">
                    <a href="##" class="btn white_84" id="btn_add">합배송 추가</a>
                </div>
                <div id="gridLayer" style="height: 400px">
                </div>
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer">
                    </div>
                </div>
            </div>
        </div><!-- //layer_content -->
    
    </div>
    
    <%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
