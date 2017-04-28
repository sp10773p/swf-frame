<%--
    Class Name : usrDetail.jsp
    Description : 사용자 상세
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
        var globalVar = {
            "data" : {}
        };

        var fileUtil, gridIdentify;
        $(function (){
            var headers = [
                {"HEAD_TEXT": "구분"    , "WIDTH": "200", "FIELD_NAME": "TYPE_NM"},
                {"HEAD_TEXT": "식별자"  , "WIDTH": "*"  , "FIELD_NAME": "IDENTIFY_ID"}
            ];

            gridIdentify = new GridWrapper({
                "actNm"        : "식별자 조회",
                "targetLayer"  : "gridIdentify",
                "qKey"         : "usr.selectCmmIdentifier",
                "paramsGetter" : {"USER_ID":"${USER_ID}"},
                "displayNone"  : ["countId"],
                "headers"      : headers,
                "firstLoad"    : true
            });

            //저장
            $('#btnSave').on("click", function (e) {
                fn_save(true);
            });

            //패스워드 초기화
            $('#btnInitPw').on('click', function (e) {
                fn_initPasswd();
            });

            //목록
            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });

            //승인
            $('#btnAppr').on("click", function (e) {
                fn_approve();
            });

            //API 키 생성
            $('#btnMakeApi').on("click", function (e) {
                fn_makeApi();
            });

            //신고값 조회
            $('#btnBaseval').on("click", function (e) {
                fn_baseval();
            });

            //탈퇴승인
            $('#btnDrop').on("click", function (e) {
                fn_drop();
            });

            // 변경내역
            $('#btnHis').on('click', function (e) {
                fn_his();
            });

            // 삭제
            $('#btnDel').on('click', function (e) {
                fn_del();
            });

            // 전화번호/휴대폰번호
            $('#TEL_NO').blur(function(){$.comm.phoneFormat(this.id)});
            $('#HP_NO').blur(function(){$.comm.phoneFormat(this.id)});
            $('#FAX_NO').blur(function(){$.comm.phoneFormat(this.id)});

            // 첨부파일 정의
            fileUtil = new FileUtil({
                "gridDiv"         : "gridWrapLayer",  // 첨부파일 리스트 그리드 DIV ID
                "addBtnId"        : "btnAddFile",     // 파일 업로드 추가 버튼 ID
                "delBtnId"        : "btnDelFile",     // 파일 삭제 버튼 ID
                "downloadFn"      : "fn_download",    // 파일 다운로드 함수명
                "params"          : {"USER_ID":"${USER_ID}"},
                "postService"     : "usrService.saveUserAttachFileId",
                "successCallback" : fn_callback,
                "postDelScript"   : fn_select
            });

            // 조회
            fn_select();

            // 가입상태 변경시
            $('#USER_STATUS').on("change", function () {
                fn_statusChange();
            })
        });

        var fn_statusChange = function(){
            var userStatus    = $('#USER_STATUS').val();
            var orgUserStatus = $('#ORG_USER_STATUS').val();

            // 가입승인이 아닌 다른 상태로 변경시 상태변경사유 입력
            if(userStatus != "1" && userStatus != orgUserStatus && $.comm.isNull($('#USER_STATUS_REASON').val())){
                $.comm.setMandantory("USER_STATUS_REASON", true);
            }else{
                $.comm.setMandantory("USER_STATUS_REASON", false);
            }
        }

        var fn_callback = function (data) {
            if(data.code.indexOf('I') == 0){
                fn_select();
            }
        };

        // 조회
        function fn_select(){
            $.comm.send("/usr/selectUsr.do", {"qKey" : "usr.selectUser", "USER_ID": "${USER_ID}"},
                function(data){
                    var status = data.status;
                    if(status == -1) return;

                    $('#detailForm')[0].reset();
                    $.comm.bindData(data.data);

                    fn_controll(data.data);

                    globalVar.data = data.data;

                    fileUtil.attachId = data.data.ATCH_FILE_ID;
                    fileUtil.selectFileList(data.data); // 첨부파일 목록 조회

                },
                "사용자 상세정보 조회"
            );

            // 식별자 조회
            gridIdentify.requestToServer();
        }

        // 저장
        function fn_save(askSaveYn){
            if(askSaveYn == true && !confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
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

            var userStatus    = $('#USER_STATUS').val();
            var orgUserStatus = $('#ORG_USER_STATUS').val();

            // 가입승인이 아닌 다른 상태로 변경시 상태변경사유 입력
            if(userStatus != "1" && userStatus != orgUserStatus && $.comm.isNull($('#USER_STATUS_REASON').val())){
                alert($.comm.getMessage("W00000033")); // 가입상태 변경시 상태변경사유를 입력하세요.
                return;
            }

            $.comm.sendForm("/usr/saveUser.do", "detailForm", fn_callback, "사용자 저장");
        }
        
        //승인
        function fn_approve() {
            if(!confirm($.comm.getMessage("C00000004"))){ //승인하시겠습니까?
                return;
            }

            $.comm.sendForm("/usr/saveUserApprove.do", "detailForm", fn_callback, "사용자 승인");
        }

        //API 키 생성
        function fn_makeApi() {
            $.comm.sendForm("/usr/makeApiKey.do", "detailForm", fn_callback, "API Key생성");
        }

        //탈퇴승인
        function fn_drop() {
            if(!confirm($.comm.getMessage("C00000005"))){ // 탈퇴처리 하시겠습니까?
                return;
            }

            $.comm.sendForm("/usr/userDrop.do", "detailForm", fn_callback, "탈퇴승인");
        }

        // 비밀번호 초기화
        function fn_initPasswd() {
            var userStatus = globalVar.data.USER_STATUS;
            var email      = globalVar.data.EMAIL;
            var userId     = globalVar.data.USER_ID;

            if(userStatus != '1'){
                alert($.comm.getMessage("W00000007")); //승인된 사용자가 아닙니다.
                return;

            }else if($.comm.isNull(email)){
                alert($.comm.getMessage("I00000006")); //임시 비밀번호 안내를 위한 이메일 주소를 입력해주세요
                return;
            }

            if(!confirm($.comm.getMessage("C00000003", "ID " + userId))){ // $ 의 비밀번호를 초기화하시겠습니까?
                return;
            }

            $.comm.send("/usr/initPass.do", globalVar.data);
        }

        // 삭제
        function fn_del(){
            if(!confirm($.comm.getMessage("C00000001"))){ //삭제 하시겠습니까?
                return;
            }

            $.comm.sendForm("/usr/deleteUser.do", "detailForm", function (data) {
                if(data.code.indexOf('I') == 0){
                    $.comm.pageBack();
                }
            }, "사용자 삭제");
        }

        // 첨부파일 다운로드
        function fn_download(index) {
            fileUtil.fileDownload(index);
        }

        // 화면 컨트롤
        function fn_controll(data){
            $.comm.readonly("USER_ID", true);

            var userDiv      = data["USER_DIV"];       // 사용자구분
            var userStatus   = data["USER_STATUS"];    // 가입상태
            var apiReqStatus = data["API_REQ_STATUS"]; // API KEY 상태 ( 'A' : 승인, 'P' : 사용중지, 'R' : 등록요청 )

            // 몰관리자 이고 api key 상태가 등록요청일 때만 API Key 생성 버튼 활성화
            if(!(userDiv == "M" && apiReqStatus == "R")){
                $.comm.display("btnMakeApi", false);
            }else{
                $.comm.display("btnMakeApi", true);
            }

            // 가입상태가 승인요청(0)이 아니면 승인 버튼 비활성화
            if(userStatus != 0){
                $.comm.display("btnAppr", false);
            }else{
                $.comm.display("btnAppr", true);
            }

            // 가입상태가 탈퇴요청(8)이 아니면 탈퇴승인 버튼 비활성화
            if(userStatus != 8){
                $.comm.display("btnDrop", false);
            }else{
                $.comm.display("btnDrop", true);
            }

            // 사용자구분이 몰관리자나 셀러 일때
            if (userDiv == "M" || userDiv == "S" ) {

                // 가입상태가 승인요청일때 신고값조회 비활성화
                if(userStatus == 0){
                    $.comm.display("btnBaseval", false);
                }else{
                    $.comm.display("btnBaseval", true);
                }
            }else{
                $.comm.display("btnBaseval", false);
            }

            // 가입상태
            var select = $('#USER_STATUS');
            $(select).find("option").remove();

            // 승인요청
            if(userStatus == 0){
                $(select).append("<option value='0' selected>승인요청</option>");
                $(select).append("<option value='1'>가입승인</option>");

            // 가입승인
            }else if(userStatus == 1){
                $(select).append("<option value='1' selected>가입승인</option>");
                $(select).append("<option value='2'>사용중지</option>");
                $(select).append("<option value='3'>직권정지</option>");

            // 사용중지
            }else if(userStatus == 2){
                $(select).append("<option value='1'>가입승인</option>");
                $(select).append("<option value='2' selected>사용중지</option>");
                $(select).append("<option value='3'>직권정지</option>");

            // 직권정지
            }else if(userStatus == 3){
                $(select).append("<option value='1'>가입승인</option>");
                $(select).append("<option value='2'>사용중지</option>");
                $(select).append("<option value='3' selected>직권정지</option>");

            // 탈퇴요청
            }else if(userStatus == 8){
                $(select).append("<option value='8' selected>탈퇴요청</option>");
                $(select).append("<option value='9'>탈퇴승인</option>");

            // 탈퇴승인
            }else if(userStatus == 9){
                $(select).append("<option value='9' selected>탈퇴승인</option>");
                $.comm.display("btnDel", true);
            }

            fn_statusChange();
        }

        // 변경내역 팝업
        function fn_his() {
            $.comm.setModalArguments({"USER_ID":$('#USER_ID').val()});
            var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/usrStatusPopup" />", spec);
        }

        // 신고값 조회
        function fn_baseval() {
            $.comm.setModalArguments({"USER_ID":$('#USER_ID').val()});
            var spec = "width:950px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/usrBsvalPopup" />", spec);
        }
    </script>
</head>
<body>
<div id="content_body">
    <form id="detailForm" name="detailForm" method="post">
        <input type="hidden" id="ORG_USER_STATUS" name="ORG_USER_STATUS">
        <div class="title_frame" style="margin-top: 0px">
            <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
            <div class="white_frame">
                <div class="util_frame">
                    <a href="#목록"            class="btn blue_84" id="btnList">목록</a>
                    <a href="#삭제"            class="btn blue_84" id="btnDel" style="display: none">삭제</a>
                    <a href="#패스워드 초기화" class="btn blue_147" id="btnInitPw">패스워드 초기화</a>
                    <a href="#신고값조회"      class="btn blue_100" id="btnBaseval" style="display: none">신고값조회</a>
                    <a href="#API Key 생성"    class="btn blue_100" id="btnMakeApi" style="display: none">API Key 생성</a>
                    <a href="#승인"            class="btn blue_84" id="btnAppr" style="display: none">승인</a>
                    <a href="#저장"            class="btn blue_84" id="btnSave">저장</a>
                </div>
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
                            <td><input type="text" name="USER_ID" id="USER_ID"></td>
                            <td><label for="USER_NM">사용자명</label></td>
                            <td><input type="text" name="USER_NM" id="USER_NM" <attr:mandantory/> <attr:length value="60" />></td>
                            <td><label for="USER_DIV_NM">사용자구분</label></td>
                            <td><span id="USER_DIV_NM"/></td>
                        </tr>
                        <tr>
                            <td><label for="USE_CHK">사용여부</label></td>
                            <td><span id="USE_CHK"/></td>
                            <td><label for="AUTH_CD">권한코드</label></td>
                            <td><span id="AUTH_CD"/></td>
                            <td><label for="BIZ_NO">사업자등록번호</label></td>
                            <td><input type="text" name="BIZ_NO" id="BIZ_NO" <attr:mandantory/> <attr:length value="13" />></td>
                        </tr>
                        <tr>
                            <td><label for="USER_STATUS">가입상태</label></td>
                            <td class="td_input_recheck">
                                <select id="USER_STATUS" name="USER_STATUS" style="width: calc(100% - 96px)"></select>
                                <a href="#변경내역" class="btn" id="btnHis">변경내역</a>
                            </td>
                            <td><label for="REP_NM">대표자명</label></td>
                            <td><input type="text" name="REP_NM" id="REP_NM" <attr:mandantory/> <attr:length value="26" />></td>
                            <td><label for="REP_NM_ENG">대표자영문명</label></td>
                            <td><input type="text" name="REP_NM_ENG" id="REP_NM_ENG" <attr:length value="50" />></td>
                        </tr>
                        <tr>
                            <td><label for="USER_STATUS_REASON">상태변경사유</label></td>
                            <td><input type="text" name="USER_STATUS_REASON" id="USER_STATUS_REASON" <attr:length value="4000" />></td>
                            <td><label for="BIZ_CONDITION">업태</label></td>
                            <td><input type="text" name="BIZ_CONDITION" id="BIZ_CONDITION" <attr:length value="20" />></td>
                            <td><label for="BIZ_LINE">종목</label></td>
                            <td><input type="text" name="BIZ_LINE" id="BIZ_LINE" <attr:length value="20" />></td>
                        </tr>
                        <tr>
                            <td><label for="TEL_NO">전화번호</label></td>
                            <td><input type="text" name="TEL_NO" id="TEL_NO" <attr:length value="25" />></td>
                            <td><label for="HP_NO">휴대폰번호</label></td>
                            <td><input type="text" name="HP_NO" id="HP_NO" <attr:length value="50" />></td>
                            <td><label for="FAX_NO">팩스번호</label></td>
                            <td><input type="text" name="FAX_NO" id="FAX_NO" <attr:length value="20" />></td>
                        </tr>
                        <tr>
                            <td><label for="ZIP_CD">우편번호</label></td>
                            <td><input type="text" name="ZIP_CD" id="ZIP_CD" <attr:length value="5" />></td>
                            <td><label for="TG_NO">통관고유부호</label></td>
                            <td><input type="text" name="TG_NO" id="TG_NO" <attr:length value="15" />></td>
                            <td><label for="EMAIL">이메일</label></td>
                            <td><input type="text" name="EMAIL" id="EMAIL" <attr:length value="50" />></td>
                        </tr>
                        <tr>
                            <td><label for="ADDRESS">주소</label></td>
                            <td colspan="5"><input type="text" name="ADDRESS" id="ADDRESS" <attr:length value="100" />></td>
                        </tr>
                        <tr>
                            <td><label for="ADDRESS2">상세주소</label></td>
                            <td colspan="5"><input type="text" name="ADDRESS2" id="ADDRESS2" <attr:length value="100" />></td>
                        </tr>
                        <tr>
                            <td><label for="ADDRESS_EN">영문주소</label></td>
                            <td colspan="5"><input type="text" name="ADDRESS_EN" id="ADDRESS_EN" <attr:length value="100" />></td>
                        </tr>
                        <tr>
                            <td><label for="CO_NM_ENG">업체영문명</label></td>
                            <td><input type="text" name="CO_NM_ENG" id="CO_NM_ENG" <attr:length value="50" />></td>
                            <td><label for="CHARGE_NM">담당자명</label></td>
                            <td><input type="text" name="CHARGE_NM" id="CHARGE_NM" <attr:length value="20" />></td>
                            <td><label for="APPLICANT_ID">신고인부호</label></td>
                            <td><input type="text" name="APPLICANT_ID" id="APPLICANT_ID" <attr:length value="5" />></td>
                        </tr>
                        <tr>
                            <td><label for="AUTO_SEND_YN">자동신고여부</label></td>
                            <td>
                                <select id="AUTO_SEND_YN" name="AUTO_SEND_YN">
                                    <option value="Y">Y</option>
                                    <option value="N">N</option>
                                </select>
                            </td>
                            <td><label for="ITEM_SEND_YN">품목별신고여부</label></td>
                            <td>
                                <select id="ITEM_SEND_YN" name="ITEM_SEND_YN">
                                    <option value="Y">Y</option>
                                    <option value="N">N</option>
                                </select>
                            </td>
                            <td><label for="REG_MALL_ID">등록몰ID</label></td>
                            <td><input type="text" name="REG_MALL_ID" id="REG_MALL_ID" <attr:length value="35" />></td>
                        </tr>
                        <tr>
                            <td><label for="UTH_USER_ID">UTH사용자ID</label></td>
                            <td><input type="text" name="UTH_USER_ID" id="UTH_USER_ID" <attr:length value="20" />></td>
                            <td><label for="DEPT">부서</label></td>
                            <td><input type="text" name="DEPT" id="DEPT" <attr:length value="20" />></td>
                            <td><label for="POS">직위</label></td>
                            <td><input type="text" name="POS" id="POS" <attr:length value="20" />></td>
                        </tr>
                        <tr>
                            <td><label for="LOGIN_TIME">최초/최종 로그인시간</label></td>
                            <td><span id="LOGIN_TIME"/></td>
                            <td><label for="REG_DTM">가입신청일자</label></td>
                            <td><span id="REG_DTM"/></td>
                            <td><label for="APPROVAL_DTM">가입승인일자</label></td>
                            <td><span id="APPROVAL_DTM"/></td>
                        </tr>
                    </table>
                </div>
            </div><!-- //상세정보 -->
        </div>

        <div class="vertical_frame">
            <div class="vertical_frame_left64">
                <div class="title_frame">
                    <p><a href="#상세정보" class="btnToggle">탈퇴정보</a></p>
                    <div class="white_frame">
                        <div class="util_frame">
                            <a href="#탈퇴승인" class="btn blue_100" id="btnDrop" style="display: none">탈퇴승인</a>
                        </div>
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">상세정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                    <col width="145px" />
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="WITHDRAW_DT">탈퇴일자</label></td>
                                    <td><span id="WITHDRAW_DT"/></td>
                                    <td><label for="WITHDRAW_PROC_DTM">탈퇴처리일시</label></td>
                                    <td><span id="WITHDRAW_PROC_DTM" /></td>
                                </tr>
                                <tr>
                                    <td><label for="WITHDRAW_REASON">탈퇴사유</label></td>
                                    <td colspan="3"><span id="WITHDRAW_REASON"/></td>
                                </tr>
                            </table>
                        </div> <%-- 탈퇴정보--%>
                    </div>
                </div>
                <div class="title_frame">
                    <p><a href="#API KEY 정보" class="btnToggle">API KEY 정보</a></p>
                    <div class="white_frame">
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">API KEY 정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                    <col width="145px" />
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="API_REQ_STATUS_NM">API Key 상태</label></td>
                                    <td><span id="API_REQ_STATUS_NM"/></td>
                                    <td><label for="API_APPORVE_DT">API 승일일시</label></td>
                                    <td><span id="API_APPORVE_DT"/></td>
                                </tr>
                                <tr>
                                    <td><label for="API_KEY">API Key</label></td>
                                    <td colspan="3"><span id="API_KEY"/></td>
                                </tr>
                            </table>
                        </div> <%-- API KEY 정보--%>
                    </div>
                </div>
            </div>

            <div class="vertical_frame_right64">
                <div class="title_frame">
                    <p><a href="#첨부파일" class="btnToggle">첨부파일</a></p>
                    <div class="white_frame">
                        <div class="util_frame">
                            <a href="#삭제" class="btn blue_84" id="btnDelFile">삭제</a>
                            <a href="#추가" class="btn blue_84" id="btnAddFile">추가</a>
                        </div>
                        <div id="gridWrapLayer" style="height: 120px">
                        </div>
                    </div>
                </div>
                <div class="title_frame">
                    <p><a href="#식별자" class="btnToggle">식별자</a></p>
                    <div class="white_frame">
                        <div id="gridIdentify" style="height: 120px">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div> <%-- content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
