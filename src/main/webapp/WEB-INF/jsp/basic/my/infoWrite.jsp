<%--
    Class Name : infoWrite.jsp
    Description : 내정보관리
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

        $(function (){
            // 저장
            $('#btnSave').on("click", function (e) {
                fn_save();
            });

            // 비밀번호변경
            $('#btnModPw').on("click", function (e) {
                fn_modPw();
            });

            // 탈퇴요청
            $('#btnWithOutReq').on("click", function (e) {
                fn_withOutReq();
            });

            // 초기화
            $('#btnInit').on("click", function (e) {
                fn_init()
            });

            // 전화번호/휴대폰번호
            $('#TEL_NO').blur(function(){$.comm.phoneFormat(this.id)});
            $('#HP_NO').blur(function(){$.comm.phoneFormat(this.id)});
            $('#FAX_NO').blur(function(){$.comm.phoneFormat(this.id)});

            fn_select();
        });

        var fn_callback = function (data) {
            if(data.code.indexOf('I') == 0){
                fn_select();
            }
        };

        // 저장
        function fn_save() {
            if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                return;
            }

            // 이메일, 전화번호, 휴대폰번호 유효성검사
            var frm = new JForm();
            frm.add(new JEmail("EMAIL"));
            frm.add(new JTel("TEL_NO"));
            frm.add(new JPhone("HP_NO"));

            if(!frm.validate()){
                return;
            }

            $.comm.sendForm("/info/saveUser.do", "detailForm", fn_callback, "내정보관리 저장");
        }

        // 비밀번호 변경
        function fn_modPw(){
            if(!$.comm.mandCheck("modpwForm")){
                return;
            }

            if($('#PW_TO').val() != $('#PW_TO2').val()){
                alert($.comm.getMessage("W00000027"));// 변경할 비밀번호를 확인하십시오.
                return;
            }

            if($('#USER_PW').val() == $('#PW_TO').val()){
                alert($.comm.getMessage("W00000026"));// 변경할 비밀번호는 기존 비밀번호와 다르게 입력하십시오
                return;
            }

            if(!confirm($.comm.getMessage("C00000017"))){ // 비밀번호를 변경 하시겠습니까?
                return;
            }

            $.comm.sendForm("/info/saveModPw.do", "modpwForm", fn_callback, "비밀번호 변경");
        }
        
        // 탈퇴요청
        function fn_withOutReq() {
            if(!confirm($.comm.getMessage("C00000016"))){ // 탈퇴요청 하시겠습니까?
                return;
            }

            $.comm.sendForm("/info/saveWithOutReq.do", "witdrawForm", fn_callback, "탈퇴요청");
        }

        // 초기화
        function fn_init(){
            $('#REP_NM').val('');
            $('#DEPT').val('');
            $('#POS').val('');
            $('#APPLICANT_ID').val('');
            $('#TEL_NO').val('');
            $('#HP_NO').val('');
            $('#FAX_NO').val('');
            $('#EMAIL').val('');
        }

        // 초기 조회
        function fn_select() {
            var param = {
                "qKey"   : "info.selectCmmUser"
            };

            $.comm.send("/usr/selectUsr.do", param,
                function(data, status){
                    $.comm.bindData(data.data);

                    var userStatus = data.data.USER_STATUS;

                    // 가입정보가 가입승인, 사용중지, 직권정지 일때만 탈퇴요청 가능
                    if(userStatus != "1" && userStatus != "2" && userStatus != "3"){
                        $.comm.display("btnWithOutReq", false);
                        $.comm.readonly("WITHDRAW_REASON", true);
                    }else{
                        $.comm.display("btnWithOutReq", true);
                        $.comm.readonly("WITHDRAW_REASON", false);
                    }
                },
                "내정보관리 조회"
            );
        }

    </script>
</head>
<body>
<div id="content_body">
    <form id="detailForm" name="detailForm" method="post">
        <div class="title_frame" style="margin-top: 0px">
            <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#목록" class="btn blue_84" id="btnWithOutReq">탈퇴요청</a>
                    <a href="#삭제" class="btn blue_84" id="btnSave">저장</a>
                    <a href="#저장" class="btn blue_84" id="btnInit">초기화</a>
                </div>
                <div class="table_typeA darkgray table_toggle">
                    <table style="table-layout:fixed;" >
                        <caption class="blind">디테일코드 상세정보</caption>
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
                            <td><span id="USER_ID"></span></td>
                            <td><label for="USER_NM">사용자명</label></td>
                            <td><input type="text" name="USER_NM" id="USER_NM" <attr:mandantory/> <attr:length value="50" />></td>
                            <td><label for="REP_NM">대표자</label></td>
                            <td><input type="text" name="REP_NM" id="REP_NM" <attr:length value="26" /> ></td>
                        </tr>
                        <tr>
                            <td><label for="AUTH_CD">권한</label></td>
                            <td><span id="AUTH_CD"></span></td>
                            <td><label for="DEPT">부서</label></td>
                            <td><input type="text" name="DEPT" id="DEPT" <attr:length value="20" /> ></td>
                            <td><label for="POS">직위</label></td>
                            <td><input type="text" name="POS" id="POS" <attr:length value="20" />></td>
                        </tr>
                        <tr>
                            <td><label for="APPLICANT_ID">신고인부호</label></td>
                            <td><input type="text" name="APPLICANT_ID" id="APPLICANT_ID" <attr:length value="5" />></td>
                            <td><label for="TEL_NO">전화번호</label></td>
                            <td><input type="text" name="TEL_NO" id="TEL_NO" <attr:length value="50" />></td>
                            <td><label for="HP_NO">휴대폰번호</label></td>
                            <td><input type="text" name="HP_NO" id="HP_NO" <attr:length value="50" />></td>
                        </tr>
                        <tr>
                            <td><label for="FAX_NO">팩스</label></td>
                            <td><input type="text" name="FAX_NO" id="FAX_NO" <attr:length value="20" />></td>
                            <td><label for="EMAIL">이메일</label></td>
                            <td><input type="text" name="EMAIL" id="EMAIL" <attr:length value="50" />></td>
                            <td><label for="USE_CHK">사용여부</label></td>
                            <td><span id="USE_CHK"></span></td>
                        </tr>
                        <tr>
                            <td><label for="LOGIN_LAST">최종로그인</label></td>
                            <td><span id="LOGIN_LAST"></span></td>
                            <td><label for="LOGIN_ERROR">로그인에러</label></td>
                            <td colspan="3"><span id="LOGIN_ERROR"></span></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div><%-- 상세정보 --%>
    </form>

    <div class="white_frame">
        <form id="witdrawForm" name="witdrawForm">
            <div class="util_frame">
                <p class="util_title">가입정보</p>
            </div>
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="USER_STATUS_NM">가입상태</label></td>
                        <td><span id="USER_STATUS_NM"></span></td>
                        <td><label for="WITHDRAW_REASON">탈퇴사유</label></td>
                        <td colspan="3"><input type="text" name="WITHDRAW_REASON" id="WITHDRAW_REASON" <attr:mandantory/> ></td>
                    </tr>
                </table>
            </div>
        </form>
        <form id="modpwForm" name="modpwForm">
            <div class="util_frame">
                <a href="#저장" class="btn blue_84" id="btnModPw">비밀번호변경</a>
            </div>
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="135px"/>
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                        <col width="135px" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="USER_PW">기존비밀번호</label></td>
                        <td><input type="password" name="USER_PW" id="USER_PW" <attr:mandantory/> ></td>
                        <td><label for="PW_TO">변경비밀번호</label></td>
                        <td><input type="password" name="PW_TO" id="PW_TO" <attr:mandantory/>></td>
                        <td><label for="PW_TO2">변경비밀번호 확인</label></td>
                        <td><input type="password" name="PW_TO2" id="PW_TO2" <attr:mandantory/>></td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
