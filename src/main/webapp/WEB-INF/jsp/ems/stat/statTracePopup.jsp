<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers;
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var REGINO = arguments.REGINO;

        var param = {
            "qKey" : "ems.selectStatTraceInfo",
            "REGINO" : REGINO
        };

        $.comm.send("/common/select.do", param, function(data, status) {
            $.comm.bindData(data.data);
            if ($("#RELATIONNM").text() != "") {
                $("#span_RELATIONNM").show();
            }
        }, "배송현황 정보조회");

        headers = [ 
            {"HEAD_TEXT" : "현재위치",	"FIELD_NAME" : "EVENTREGIPONM",	"WIDTH" : "100"}, 
            {"HEAD_TEXT" : "처리현황",	"FIELD_NAME" : "EVENTNM",		"WIDTH" : "100"}, 
            {"HEAD_TEXT" : "상세설명",	"FIELD_NAME" : "DELIVRSLTNM",	"WIDTH" : "100"}, 
            {"HEAD_TEXT" : "처리일시",	"FIELD_NAME" : "SORTINGDATE",	"WIDTH" : "100"} 
        ];

        gridWrapper = new GridWrapper({
            "actNm" : "배송현황 이력 리스트 조회",
            "targetLayer" : "gridLayer",
            "qKey" : "ems.selectStatTraceInfoHistoryList",
            "requestUrl" : "/ems/stat/selectStatTraceDetail.do",
            "headers" : headers,
            "paramsGetter" : {"REGINO":REGINO},
            "gridNaviId" : "gridPagingLayer",
            "check" : false,
            "firstLoad" : false,
            "defaultSort"  : "ITEMNO DESC",
            "controllers" : [

            ]
        });
        
        $("#btn_req").click(function() {
            var param = {"REGINO":REGINO};
            $.comm.send("/ems/stat/saveRealTimeEmsTraceInfo.do", param, function(data, status) {
                if (status == "success") {
                    gridWrapper.requestToServer();
                }
            }, "배송현황 실시간 조회");
        });

        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
        
        gridWrapper.requestToServer();
    });

    function fn_callback() {
       alert("callback");
    }
</script>
</head>
<body>
    <div class="layerContainer">
        <!-- content 시작 -->
        <div class="layerTitle">
            <h1>${ACTION_MENU_NM}</h1>
        </div>
        <!-- layerTitle -->
        <div class="layer_btn_frame">
            <a href="#" class="btn white_84" id="btn_close">닫기</a>
            <a href="#" class="btn white_84" id="btn_req">실시간 조회</a> 
        </div>
        <!-- layer_btn_frame -->

<!--         <div class="layer_content"> -->
            <div class="title_frame">
                <p>배송 정보</p>
                <div class="table_typeA darkgray">
                    <table style="table-layout: fixed;">
                        <caption class="blind">배송 정보</caption>
                        <colgroup>
                            <col width="20%" />
                            <col width="30%" />
                            <col width="20%" />
                            <col width="30%" />
                        </colgroup>
                        <tr>
                            <td><label for="SENDER">발송인</label></td>
                            <td><span id="SENDER"></span></td>
                            <td><label for="REGINO">운송장번호</label></td>
                            <td><span id="REGINO"></span></td>
                        </tr>
                        <tr>
                            <td><label for="MAILTYPENM">우편물종류</label></td>
                            <td><span id="MAILTYPENM"></span></td>
                            <td><label for="MAILKINDNM">취급구분</label></td>
                            <td><span id="MAILKINDNM"></span></td>
                        </tr>
                        <tr>
                            <td><label for="RECEIVENAME">수취인</label></td>
                            <td><span id="RECEIVENAME"></span></td>
                            <td>
                                <label for="SIGNERNM">수령인 (관계)</label>
                                <label for="RELATIONNM" style="display: none">(관계)</label>
                            </td>
                            <td><span id="SIGNERNM"></span> <span id="span_RELATIONNM" style="display: none;">(<span id="RELATIONNM"></span>)</span></td>
                        </tr>
                        <tr>
                            <td><label for="EVENTNM">배달결과 (상태)</label></td>
                            <td><span id="EVENTNM"></span></td>
                            <td><label for="TRACEDATE">배달결과 (날짜)</label></td>
                            <td><span id="TRACEDATE"></span></td>
                        </tr>
                    </table>
                </div><!-- //table_typeA 3단구조 -->
                
                <div class="list_typeB">
                    <div class="util_frame"></div>
                    <!-- //util_frame -->
                    <div id="gridLayer" style="height: 400px"></div>
                </div>
                <!-- //list_typeB -->
                <div class="bottom_util">
                    <div class="paging" id="gridPagingLayer"></div>
                </div>
            </div>
            <!-- //title_frame -->
<!--         </div> -->
    </div>

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
