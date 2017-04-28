<%--
    Class Name : logPopup.jsp
    Description : 로그상세내역
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
        $(function () {
            var args = $.comm.getModalArguments();
            var sid = args.SID;

            var param = {
                "qKey":"log.selectParam",
                "SID":sid
            };
            var data = $.comm.sendSync("/log/selectParam.do", param).data;

            if(data){
                var idx = 1;
                var html = "<tr>";
                for(var key in data){
                    var title = data[key][0];
                    var value = data[key][1];

                    html += "<td>" + title + "</td>";
                    html += "<td>" + value + "</td>";
                    if((idx%2) == 0){
                        html += "</tr>";
                    }
                    idx++;
                }

                if((idx%2) == 0){
                    html += "<td></td><td>&nbsp;</td></tr>";
                }

                $('#tarBody').html(html);
            }
        });
    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <div class="white_frame">
        <div class="table_typeA ">
            <table style="table-layout:fixed;">
                <colgroup>
                    <col width="132px">
                    <col width="*">
                    <col width="132px">
                    <col width="*">
                </colgroup>
                <tbody id="tarBody">
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
