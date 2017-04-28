<%--
    Class Name : admList.jsp
    Description : 어드민 관리
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
                {"HEAD_TEXT": "권한코드"       , "WIDTH": "100", "FIELD_NAME": "AUTH_CD"},
                {"HEAD_TEXT": "사용자구분"     , "WIDTH": "130", "FIELD_NAME": "USER_DIV_NM"},
                {"HEAD_TEXT": "전화번호"       , "WIDTH": "100", "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "휴대폰번호"     , "WIDTH": "100", "FIELD_NAME": "HP_NO"},
                {"HEAD_TEXT": "이메일"         , "WIDTH": "200", "FIELD_NAME": "EMAIL"},
                {"HEAD_TEXT": "최초로그인"     , "WIDTH": "130", "FIELD_NAME": "LOGIN_START"},
                {"HEAD_TEXT": "최종로그인"     , "WIDTH": "130", "FIELD_NAME": "LOGIN_LAST"},
                {"HEAD_TEXT": "비밀번호변경일" , "WIDTH": "100", "FIELD_NAME": "PW_CHANGE"},
                {"HEAD_TEXT": "사용여부"       , "WIDTH": "60" , "FIELD_NAME": "USE_CHK"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"         : "어드민사용자 조회",
                "targetLayer"   : "gridLayer",
                "qKey"          : "adm.selectAdminUsrList",
                "requestUrl"    : "/usr/selectUsrList.do",
                "headers"       : headers,
                "paramsFormId"  : "searchForm",
                "check"         : true,
                "firstLoad"     : true,
                "scrollPaging"  : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "targetURI" : "/adm/deleteAdminUser.do"}
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

            // 패스워드 초기화
            $('#btnInitPw').on('click', function (e) {
                fn_initPasswd();
            });

            // 사용자구분 Select Box FILTER
            $.comm.bindFilterCombo("USER_DIV", "USER_DIV", false, "A,C");

            // 권한코드 Select Box
            $.comm.bindCustCombo("AUTH_CD", "adm.selectAuthCodeList", false, null, null, "CALL,STAFF,ADMIN,SYSTEM");

            // 전화번호/휴대폰번호
            $('#TEL_NO').blur(function(){$.comm.phoneFormat(this.id)});
            $('#HP_NO').blur(function(){$.comm.phoneFormat(this.id)});
        });


        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_select();
            }
        };

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $.comm.readonly("USER_ID", false);
            $('#detailForm')[0].reset();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            // 이메일, 전화번호, 휴대폰번호 유효성검사
            var frm = new JForm();
            frm.add(new JEmail("EMAIL"));
            frm.add(new JTel("TEL_NO"));
            frm.add(new JPhone("HP_NO"));

            if (!frm.validate()) {
                return;
            }

            $.comm.sendForm("/adm/saveAdmUser.do", "detailForm", fn_callback, "어드민사용자 저장");
        }

        // 조회
        function fn_select() {
            gridWrapper.requestToServer();
            fn_new();
        }

        // 비밀번호 초기화
        function fn_initPasswd() {
            var saveMode = $('#SAVE_MODE').val();
            if(saveMode != "U"){
                alert($.comm.getMessage("W00000003")); // 선택한 데이터가 없습니다.
                return;
            }

            var email  = $('#EMAIL').val();
            var userId = $('#USER_ID').val();

            if($.comm.isNull(email)){
                alert($.comm.getMessage("I00000006")); //임시 비밀번호 안내를 위한 이메일 주소를 입력해주세요
                return;
            }

            if(!confirm($.comm.getMessage("C00000003", "ID " + userId))){ // $ 의 비밀번호를 초기화하시겠습니까?
                return;
            }

            var param  = {"USER_ID":userId, "EMAIL":email};

            $.comm.send("/usr/initPass.do", param);
        }

        // 상세정보 조회
        function fn_detail(index) {
            var data = gridWrapper.getRowData(index);

            $.comm.send("/usr/selectUsr.do", {"qKey": "adm.selectAdminUsr", "USER_ID": data["USER_ID"]},
                function (result) {
                    var data = result["data"];
                    $.comm.bindData(data);
                    $('#SAVE_MODE').val("U");
                    $.comm.readonly("USER_ID", true);
                },
                "어드민사용자 상세정보 조회"
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
                        <label for="SEARCH_COL1">검색조건</label>
                        <label for="SEARCH_TXT1" style="display: none">검색조건 SEARCH_TXT1</label>
                        <select id="SEARCH_COL1" name="SEARCH_COL1" style="width:120px;" <attr:changeNoSearch/>>
                            <option value="USER_ID">사용자ID</option>
                            <option value="USER_NM">사용자명</option>
                        </select>
                        <input id="SEARCH_TXT1" name="SEARCH_TXT1" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="S_AUTH_CD">권한코드</label>
                        <input id="S_AUTH_CD" name="S_AUTH_CD" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="S_USE_CHK">사용여부</label>
                        <select id="S_USE_CHK" name="S_USE_CHK" style="width:120px;">
                            <option value="" selected>선택</option>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <%-- 그리드 영역 --%>
    <div class="white_frame">
        <div class="util_frame">
            <a href="#삭제" class="btn white_100" id="btnDel">삭제</a>
        </div>
        <div id="gridLayer" style="height: 220px">
        </div>
    </div>

    <div class="title_frame">
        <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#패스워드 초기화" class="btn blue_147" id="btnInitPw">패스워드 초기화</a>
                <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
            </div>
            <form name="detailForm" id="detailForm">
                <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                <div class="table_typeA darkgray table_toggle">
                    <table style="table-layout:fixed;" >
                        <caption class="blind">상세정보</caption>
                        <colgroup>
                            <col width="145px"/>
                            <col width="*" />
                            <col width="145px" />
                            <col width="*" />
                            <col width="145px" />
                            <col width="*" />
                        </colgroup>
                        <tr>
                            <td><label for="USER_ID">사용자ID</label></td>
                            <td><input type="text" name="USER_ID" id="USER_ID" <attr:mandantory/> <attr:length value="35" />></td>
                            <td><label for="USER_NM">사용자명</label></td>
                            <td><input type="text" name="USER_NM" id="USER_NM" <attr:mandantory/> <attr:length value="60" />></td>
                            <td><label for="USER_DIV">사용자구분</label></td>
                            <td><select id="USER_DIV" name="USER_DIV"></select></td>
                        </tr>
                        <tr>
                            <td><label for="AUTH_CD">권한코드</label></td>
                            <td><select id="AUTH_CD" name="AUTH_CD"></select></td>
                            <td><label for="USER_PW">비밀번호</label></td>
                            <td>
                                <input type="password" name="USER_PW" id="USER_PW" <attr:mandantory/> <attr:length value="50"/> autocomplete="off">
                            </td>
                            <td><label for="USE_CHK">사용여부</label></td>
                            <td>
                                <select id="USE_CHK" name="USE_CHK">
                                    <option value="Y" selected>사용</option>
                                    <option value="N">미사용</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="TEL_NO">전화번호</label></td>
                            <td><input type="text" name="TEL_NO" id="TEL_NO" <attr:length value="25" />></td>
                            <td><label for="HP_NO">휴대폰번호</label></td>
                            <td><input type="text" name="HP_NO" id="HP_NO" <attr:length value="50" />></td>
                            <td><label for="EMAIL">이메일</label></td>
                            <td><input type="text" name="EMAIL" id="EMAIL" <attr:length value="50"/>></td>
                        </tr>
                        <tr>
                            <td><label for="LOGIN_START">최초로그인일자</label></td>
                            <td><span id="LOGIN_START"></span></td>
                            <td><label for="LOGIN_LAST">최종로그인일자</label></td>
                            <td colspan="3"><span id="LOGIN_LAST"></span></td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
