<%--
    Class Name : unitTestDetailPopup.jsp
    Description : 단위테스트 요청 데이터 상세
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
        var globalVar = {
            "TEXT" : ""
        }
        $(function () {
            var arguments = $.comm.getModalArguments();
            var text = arguments["JSON_TEXT"];
            globalVar["TEXT"] = text;
            $('#TEXT').val(text);
        });

        function fn_beforeunload() {
            if(globalVar["TEXT"] != $('#TEXT').val())
                $.comm.setModalReturnVal({"RETURN_VAL":$('#TEXT').val()});
        }
    </script>
</head>
<body onbeforeunload="fn_beforeunload()">
<div>
    <div class="white_frame">
        <table class="table_typeA darkgray">
            <tr>
                <td>
                    <textarea name="TEXT" id="TEXT" rows="200" cols="200" style="padding: 5px; width: 100%; height: 500px"></textarea>
                </td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
