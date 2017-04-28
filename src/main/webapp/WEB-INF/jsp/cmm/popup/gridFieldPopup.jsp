<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
<script>
    var gridWrapper, headers;
    var globalVar = {
        "orgCheck" : ""
    }
    $(function() {
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var dataList = arguments;
        headers = [
            {"HEAD_TEXT" : "필드명", "FIELD_NAME" : "HEAD_TEXT", "WIDTH" : "*"}
        ];

        gridWrapper = new GridWrapper({
            "targetLayer" : "gridLayer",
            "headers"     : headers,
            "check"       : true,
            "firstLoad"   : false
        });

        gridWrapper.setData(dataList);
        gridWrapper.drawBody(0, dataList);

        $.each(dataList, function (idx, data) {
            var hidden = ($.comm.isNull(data["HIDDEN"]) ? "false" : data["HIDDEN"]);
            if(hidden == "true"){
                gridWrapper.setCheck(idx, false);
            }else{
                gridWrapper.setCheck(idx, true);
            }

            globalVar["orgCheck"] = globalVar["orgCheck"] + hidden;
        })

        $('#btnApply').on("click", function () {
            var h = gridWrapper.getSelectedRows();
            var hiddenStr = "";
            var ret = [];
            $.each(h, function (idx, data) {
                hiddenStr += "false";
                ret[ret.length] = data["FIELD_NAME"];
            })

            if(globalVar["orgCheck"] != hiddenStr){
                $.comm.setModalReturnVal(ret);
            }

            self.close();
        })

    });

    
</script>
</head>
<body>
    <div class="layerContainer autoHeight" style="min-width:100px">
        <div class="layerTitle">
            <h1>필드 선택</h1>
        </div><!-- layerTitle -->
        <div class="layer_content">
            <div class="white_frame">
                <div class="util_frame">
                    <a href="##" class="btn white_84" id="btnApply">변경</a>
                </div>
                <div id="gridLayer" style="height: 450px">
                </div>
            </div>
        </div><!-- //layer_content -->
    
    </div>
    
    <%@ include file="/WEB-INF/include/include-popup-body.jspf" %>
</body>
</html>
