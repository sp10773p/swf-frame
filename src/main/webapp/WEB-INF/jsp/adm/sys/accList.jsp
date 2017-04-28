<%--
    Class Name : accList.jsp
    Description : IP접속관리
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
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "사용자ID"       , "WIDTH": "100", "FIELD_NAME": "USER_ID", "LINK": "fn_detail"},
                {"HEAD_TEXT": "사용자명"       , "WIDTH": "100", "FIELD_NAME": "USER_NM"},
                {"HEAD_TEXT": "IP"             , "WIDTH": "150", "FIELD_NAME": "IP"},
                {"HEAD_TEXT": "접속허용여부"   , "WIDTH": "100", "FIELD_NAME": "AUTH_YN"},
                {"HEAD_TEXT": "최종수정자"     , "WIDTH": "80" , "FIELD_NAME": "MOD_ID"},
                {"HEAD_TEXT": "최종수정일"     , "WIDTH": "80" , "FIELD_NAME": "MOD_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"         : "IP접속관리 조회",
                "targetLayer"   : "gridLayer",
                "qKey"          : "acc.selectCmmIpAccessList",
                "headers"       : headers,
                "paramsFormId"  : "searchForm",
                "check"         : true,
                "firstLoad"     : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "qKey":"acc.deleteCmmIpAccess"}
                ]
            });

            // 신규
            $('#btnNew').on('click', function (e) {
                fn_new();
            });

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 사용자 선택 팝업
            $('#btnUser').on('click', function (e) {
                fn_userPopup();
            });

            $.comm.readonly(["USER_ID", "USER_NM"], true);

            $("#IP1,#IP1,#IP1").on("keyup", function() {
                $(this).val( $(this).val().replace(/[^0-9\*]/gi,"") );
            });

        });


        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_select();
            }
        };

        // 신규
        function fn_new() {
            $('#detailForm')[0].reset();

            $('#SAVE_MODE').val("I");
            $('#ORG_IP').val("");

            $('#MOD_ID').html("");
            $('#MOD_DTM').html("");

        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var ip4 = $('#IP4').val();
            var ip5 = $('#IP5').val();

            var bool = true;
            if(!$.comm.isNull(ip4) && !$.comm.isNull(ip5)){
                if(ip4 == "*" || ip5 == "*"){
                    bool = false;
                }
                if(parseInt(ip4) > parseInt(ip5)){
                    bool = false;
                }
            }

            if(bool == true){
                var preIp = "";
                for(var i=5; i >= 1 ; i--){
                    var ip = $("#IP"+i).val();

                    if(ip.indexOf("*") > -1 && ip.length > 1){
                        bool = false;
                        break;
                    }

                    if(!$.comm.isNull(preIp) && $.comm.isNull(ip)){
                        bool = false;
                        break;
                    }

                    preIp = ip;
                }
            }

            if(bool == false){
                alert($.comm.getMessage("W00000036")); // IP를 확인하세요.
                return;
            }

            $.comm.sendForm("/acc/saveIpAccess.do", "detailForm", fn_callback, "IP접속허용 저장");
        }

        // 조회
        function fn_select() {
            gridWrapper.requestToServer();
            fn_new();
        }

        // 상세정보 조회
        function fn_detail(index) {
            var data = gridWrapper.getRowData(index);

            $('#SAVE_MODE').val("U");

            $.comm.bindData(data);

            $('#ORG_IP').val(data["IP"]);

            var arr = data["IP"].split(".");
            var ip1  = arr[0];
            var ip2 = (arr.length > 1 ? arr[1] : "");
            var ip3 = (arr.length > 2 ? arr[2] : "");
            var ip4 = (arr.length > 3 ? arr[3] : "");
            var ip5 = (arr.length > 4 ? arr[4] : "");

            $('#IP1').val(ip1);
            $('#IP2').val(ip2);
            $('#IP3').val(ip3);
            $('#IP4').val(ip4);
            $('#IP5').val(ip5);
        }


        // 사용자 조회 팝업
        function fn_userPopup() {
            var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/usrPopup" />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                        $('#USER_ID').val(ret.USER_ID); // 사용자id 지정
                        $('#USER_NM').val(ret.USER_NM); // 사용자명 지정
                    }
                }
            );
        }

    </script>
</head>
<body>
<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <div class="search_frame">
                <ul class="search_sectionB">
                    <li>
                        <label for="P_USER_ID">사용자ID</label>
                        <input id="P_USER_ID" name="P_USER_ID" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="P_USER_NM">사용자명</label>
                        <input id="P_USER_NM" name="P_USER_NM" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="P_AUTH_YN">접속허용여부</label>
                        <select id="P_AUTH_YN" name="P_AUTH_YN" style="width:120px;">
                            <option value="" selected>선택</option>
                            <option value="Y">Y</option>
                            <option value="N">N</option>
                        </select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left64">
            <%-- 그리드 영역 --%>
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#삭제" class="btn white_100" id="btnDel">삭제</a>
                </div>
                <div id="gridLayer" style="height: 220px">
                </div>
            </div>
        </div>

        <div class="vertical_frame_right64">
            <div class="title_frame">
                <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
                    </div>
                    <form name="detailForm" id="detailForm">
                        <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                        <input type="hidden" id="ORG_IP" name="ORG_IP">
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">상세정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="USER_ID">사용자ID</label></td>
                                    <td class="table_search">
                                        <input type="text" class="table_search" name="USER_ID" id="USER_ID" style="width: 120px" <attr:mandantory/>>
                                        <a href="#사용자ID" class="inputHeight" id="btnUser"></a>
                                        <input type="text" class="table_search" name="USER_NM" id="USER_NM" style="margin-left:10px; width: 150px">
                                    </td>
                                </tr>
                                <tr>
                                    <td><label for="IP1">IP</label></td>
                                    <td>
                                        <input type="text" name="IP1" id="IP1" <attr:mandantory/> <attr:length value="3" /> style="width: 50px"><span>.</span>
                                        <input type="text" name="IP2" id="IP2" <attr:length value="3" /> style="width: 50px"><span>.</span>
                                        <input type="text" name="IP3" id="IP3" <attr:length value="3" /> style="width: 50px"><span>.</span>
                                        <input type="text" name="IP4" id="IP4" <attr:length value="3" /> style="width: 50px"><span>-</span>
                                        <input type="text" name="IP5" id="IP5" <attr:length value="3" /> style="width: 50px">
                                    </td>
                                </tr>
                                <tr>
                                    <td><label for="AUTH_YN">접속허용여부</label></td>
                                    <td>
                                        <select id="AUTH_YN" name="AUTH_YN" style="width:120px;">
                                            <option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><label for="MOD_ID">최종수정자</label></td>
                                    <td><span id="MOD_ID"></span></td>
                                </tr>
                                <tr>
                                    <td><label for="MOD_DTM">최종수정일</label></td>
                                    <td><span id="MOD_DTM"></span></td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div><%-- vertical_frame --%>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
