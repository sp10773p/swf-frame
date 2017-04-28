<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    $(function() {

        singleFileUtil1 = new FileUtil({
            "id" : "file",
            "addBtnId" : "btnUpload1",
            "extNames" : [ "xls", "xlsx" ],
            "successCallback" : fn_callback,
            "postService" : "emsService.uploadPickExcel"
        });

        singleFileUtil2 = new FileUtil({
            "id" : "file",
            "addBtnId" : "btnUpload2",
            "extNames" : [ "xls", "xlsx" ],
            "successCallback" : fn_callback,
            "postService" : "emsService.uploadPickSeaExcel"
        });

        // 닫기
        $("#btn_close").click(function() {
            self.close();
        });
    });

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
<!--             <a href="javascript:layerPop('')"></a>닫기버튼 -->
        </div>
        <!-- layerTitle -->
        <br/>
        <div class="layer_content" style="overflow-x:hidden; overflow-y:hidden;">
            <div class="title_frame">
                <p>파일등록 <span>(EMS/K-Packet)</span></p>
                <div class="table_typeA lightgray">
                    <table style="table-layout: fixed;">
                        <caption class="blind">엑셀 업로드</caption>
                        <colgroup>
                            <col width="300px" />
                        </colgroup>
                        <tr>
                            <td>
                                <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
                                <input type="hidden" id="FILE_SN" name="FILE_SN" />
<!--                                 <input type="text" id="atch_file" name="atch_file" class="td_input inputHeight" placeholder="파일선택" readonly /> -->
                                <a href="##" class="btn_table" style="margin-left: 0px;" id="btnUpload1">엑셀 업로드</a> 
                                <a href="<c:url value="/form/ems_template.xls" />" style="margin-left: 0px;" class="btn_table">표준 엑셀폼 다운로드</a>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-- //title_frame -->
            
            <div class="title_frame">
                <p>파일등록 <span>(한중해상특송)</span></p>
                <div class="table_typeA lightgray">
                    <table style="table-layout: fixed;">
                        <caption class="blind">엑셀 업로드</caption>
                        <colgroup>
                            <col width="300px" />
                        </colgroup>
                        <tr>
                            <td>
                                <input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" />
                                <input type="hidden" id="FILE_SN" name="FILE_SN" />
<!--                                 <input type="text" id="atch_file" name="atch_file" class="td_input inputHeight" placeholder="파일선택" readonly /> -->
                                <a href="##" class="btn_table" style="margin-left: 0px;" id="btnUpload2">엑셀 업로드</a> 
                                <a href="<c:url value="/form/ems_template_seaExpress.xls" />" style="margin-left: 0px;" class="btn_table">표준 엑셀폼 다운로드</a>
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
