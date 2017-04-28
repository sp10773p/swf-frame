<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var globalVar = {
        "EXPRESS_BIZ_NO" : "",
        "TEMP_EXPRESS_BIZ_NO" : ""
    }
    $(function() {
        
        fn_setCombo();
        
        singleFileUtil = new FileUtil({
            "id" : "file",
            "addBtnId" : "btnUpload",
            "extNames" : [ "xls", "xlsx" ],
            "successCallback" : fn_callback,
            "postService" : "xprService.uploadShipExcel"
        });

        // 특송사 임시변경 click
        $("#btnTemp").on("click", function() {
            $("#spanTempExpressBizNo").hide();
            $("#TEMP_EXPRESS_BIZ_NO").show().focus().trigger("click");
        });
        
        // 특송사 변경
        $("#TEMP_EXPRESS_BIZ_NO").on("change focusout", function() {
            $("#TEMP_EXPRESS_BIZ_NO").hide();
            
            var TEMP_EXPRESS_BIZ_NO = $("#TEMP_EXPRESS_BIZ_NO option:selected");
            globalVar.TEMP_EXPRESS_BIZ_NO = TEMP_EXPRESS_BIZ_NO.val();
            $("#spanTempExpressBizNo").text($.comm.isNull(globalVar.TEMP_EXPRESS_BIZ_NO) ? fn_setComboDefault() : TEMP_EXPRESS_BIZ_NO.text());
            $("#spanTempExpressBizNo").show();
        });
        
        // 엑셀업로드
        $('#btnCheck').on("click", function(e) {
            if ($.comm.isNull(globalVar.EXPRESS_BIZ_NO) && $.comm.isNull(globalVar.TEMP_EXPRESS_BIZ_NO)) {
                alert($.comm.getMessage("W00000082")); //특송사를 지정해 주세요.
                return;
            }
            else {
                singleFileUtil.params = {"TEMP_EXPRESS_BIZ_NO":globalVar.TEMP_EXPRESS_BIZ_NO};
                $("#btnUpload").trigger("click");
            }
        });

        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
    });
    
    function fn_setCombo() {
        $.comm.bindCustCombo('TEMP_EXPRESS_BIZ_NO', "xpr.selectExpressUsers", true); // 특송사 리스트
        
        var param = { "qKey" : "xpr.getMainExpressCode" };
        var data = $.comm.sendSync("/xpr/ship/getMainExpressCode.do", param).data;
        globalVar.EXPRESS_BIZ_NO = data.baseVal;
        
        fn_setComboDefault();
    }
    
    function fn_setComboDefault() {
        if ($.comm.isNull(globalVar.EXPRESS_BIZ_NO)) {
            $("#spanTempExpressBizNo").text("특송사가 지정되지 않았습니다.");
        }
        else {
            $("#TEMP_EXPRESS_BIZ_NO").val(globalVar.EXPRESS_BIZ_NO);
            $("#spanTempExpressBizNo").text($("#TEMP_EXPRESS_BIZ_NO option:selected").text());
        }
    }

    function fn_callback() {
        opener.gridWrapper.requestToServer();
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
        <div class="layer_content" style="overflow-x:hidden; overflow-y:hidden;">
            <div class="search_frame on">
                <p><span>ㆍ기초정보 > 신고서 기본값 설정에서 <b>주거래 특송사</b>를 지정할 수 있습니다.</span></p><br/>
                <p><span>ㆍ[특송사 임시변경]을 통해 배송요청할 특송사를 임시로 변경할 수 있습니다.</span></p>
            </div>
            
            <div class="title_frame">
                <p>파일등록</p>
                <div class="table_typeA lightgray">
                    <table style="table-layout: fixed;">
                        <caption class="blind">엑셀 업로드</caption>
                        <colgroup>
                            <col width="300px" />
                        </colgroup>
                        <tr>
                            <td>
                                <span style="color:#666;">배송요청할 특송사 : </span><span id="spanTempExpressBizNo" style="font-weight:bold;"></span>
                                <select id="TEMP_EXPRESS_BIZ_NO" class="input_select" style="width:300px; display:none;"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
                                <input type="hidden" id="FILE_SN" name="FILE_SN" />
                                <a href="#" class="btn_table" style="margin-left: 0px;" id="btnCheck">엑셀 업로드</a>
                                <a href="#" id="btnUpload" style="display:none"></a>
                                <a href="#" style="margin-left: 0px;" class="btn_table" id="btnTemp" >특송사 임시변경</a> 
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-- //title_frame -->
        </div>
    </div>

    <%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
