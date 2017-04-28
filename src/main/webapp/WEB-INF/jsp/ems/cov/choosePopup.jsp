<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var globalVar = {
        "EM_KIND" : "",
        "PARAMS" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        globalVar.EM_KIND = arguments.EM_KIND;
        globalVar.PARAMS = arguments.PARAMS;
        
        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
    });

    function fn_select() {
        var LABEL_TYPE = $("input[name=LABEL_TYPE]:checked").val();
        opener.reportPrint(globalVar.EM_KIND, LABEL_TYPE, globalVar.PARAMS);
        self.close();
    }
</script>
</head>
<body style="overflow-x:hidden; overflow-y:hidden;">
    <div class="layerContainer" style="min-width: 300px;">
        <div class="layerTitle">
            <h1>${ACTION_MENU_NM}</h1>
        </div>
        <!-- layerTitle -->
        
        <br/>
        <div class="title_frame">
            <p>라벨지 종류</p>
            <div class="table_typeA lightgray">
                <table style="table-layout: fixed;">
                    <caption class="blind">라벨지 종류</caption>
                    <colgroup>
                        <col width="100px" />
                        <col width="100px" />
                    </colgroup>
                    <tr>
                        <td>
                            <input name="LABEL_TYPE" type="radio" id="LABEL_TYPE_A" value="A" checked="checked"/>
                            <label for="LABEL_TYPE_A"><span></span>전용소형</label>
                        </td>
                        <td>
                            <input name="LABEL_TYPE" type="radio" id="LABEL_TYPE_B" value="B"/>
                            <label for="LABEL_TYPE_B"><span></span>전용A4</label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <!-- //title_frame -->
        
        <div class="util_frame">
            <a href="javascript:fn_select();" class="btn white_84">선택</a>
        </div><!-- //util_frame -->
    </div>

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
