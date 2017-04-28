<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
var globalVar = {
        "SN" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        globalVar.SN = arguments.SN;
        
        // 출력
        $('#btn_print').on("click", function (e) {
            fn_print();
        });
    });
    
    function fn_print(){
        var rows = opener.gridWrapper.getSelectedRows();
        var params = {};
        var cnt = 0;
        params["pSN"] = globalVar.SN;
        params["pSTART_CELL"] = $(":input:radio[name=START_CELL]:checked").val();
        params["pCO_NM_ENG"] = "${session.getUserNm()}";
        params["pHP_NO"] = "${session.getHpNo()}";
        params["pEMAIL"] = "${session.getEmail()}";
        $.each (rows, function(index, data) {
            cnt = cnt + 1;
            params["pSEQ." + cnt] = data["SEQ"];
        });
        
        opener.fn_print(params);
        self.close();
    }

</script>
</head>
<body style="overflow-x:hidden; overflow-y:hidden;">
    <div class="layerContainer" style="min-width: 400px;">
        <div class="layerTitle">
            <h1>바코드 출력 위치 지정</h1>
<!--             <a href="javascript:layerPop('')"></a>닫기버튼 -->
        </div><!-- layerTitle -->
        <br/>
        <div class="util_frame">
            <a href="##" class="btn white_84" id="btn_print">바코드 출력</a>
        </div>
        <div class="layer_content" style="overflow-x:hidden; overflow-y:hidden;">
<!--             <div class="search_frame on"> -->
                <div class="title_frame">
                    <p>시작 위치를 선택하세요.</p>
                    <div class="table_typeA lightgray">
                        <table style="table-layout: fixed;">
                            <caption class="blind">엑셀 업로드</caption>
                            <colgroup>
                                <col width="50%" />
                                <col width="50%" />
                            </colgroup>
                            <tr style="height:50px;">
                                <td>
                                    <input type="radio" id="START_CELL_1" name="START_CELL" value="1" checked />
                                    <label for="START_CELL_1" class="search_title"><span></span>1</label>
                                </td>
                                <td>
                                    <input type="radio" id="START_CELL_5" name="START_CELL" value="5" />
                                    <label for="START_CELL_5" class="search_title"><span></span>5</label>
                                </td>
                            </tr>
                            <tr style="height:50px;">
                                <td>
                                    <input type="radio" id="START_CELL_2" name="START_CELL" value="2" />
                                    <label for="START_CELL_2" class="search_title"><span></span>2</label>
                                </td>
                                <td>
                                    <input type="radio" id="START_CELL_6" name="START_CELL" value="6" />
                                    <label for="START_CELL_6" class="search_title"><span></span>6</label>
                                </td>
                            </tr>
                            <tr style="height:50px;">
                                <td>
                                    <input type="radio" id="START_CELL_3" name="START_CELL" value="3" />
                                    <label for="START_CELL_3" class="search_title"><span></span>3</label>
                                </td>
                                <td>
                                    <input type="radio" id="START_CELL_7" name="START_CELL" value="7" />
                                    <label for="START_CELL_7" class="search_title"><span></span>7</label>
                                </td>
                            </tr>
                            <tr style="height:50px;">
                                <td>
                                    <input type="radio" id="START_CELL_4" name="START_CELL" value="4" />
                                    <label for="START_CELL_4" class="search_title"><span></span>4</label>
                                </td>
                                <td>
                                    <input type="radio" id="START_CELL_8" name="START_CELL" value="8" />
                                    <label for="START_CELL_8" class="search_title"><span></span>8</label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <!-- //title_frame -->
<!--             </div> -->
        </div>
        
    </div>

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
