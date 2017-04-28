<%--
    Class Name : ntcList.jsp
    Description : 공지사항
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
            "currRow" : 0
        };
        var contents, fileUtil;
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "제목"      , "WIDTH": "*"  , "FIELD_NAME": "TITLE", "LINK": "fn_detail", "ALIGN":"left"},
                {"HEAD_TEXT": "최종작성자", "WIDTH": "80", "FIELD_NAME": "MOD_ID"},
                {"HEAD_TEXT": "최종작성일", "WIDTH": "80", "FIELD_NAME": "MOD_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "공지사항 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "ntc.selectCmmNoticeList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "check"             : true,
                "firstLoad"         : false,
                "postScript"        : function (){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "targetURI":"/ntc/deleteCmmNotice.do"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            // 첨부파일 정의
            fileUtil = new FileUtil({
                "gridDiv"         : "gridWrapLayer",  // 첨부파일 리스트 그리드 DIV ID
                "addBtnId"        : "btnAddFile",     // 파일 업로드 추가 버튼 ID
                "delBtnId"        : "btnDelFile",     // 파일 삭제 버튼 ID
                "downloadFn"      : "fn_download",    // 파일 다운로드 함수명
                "preAddScript"    : fn_preUploadCheck,
                "successCallback" : fn_uploadCallback,
                "postService"     : "ntcService.updateCmmFileAttchId"
            });


            // 신규
            $('#btnNew').on('click', function (e) {
                fn_new();
            });

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 미리보기
            $('#btnPreview').on('click', function (e) {
                fn_preview();
            });

            contents = $.comm.editor("CONTENTS", 400);

            gridWrapper.requestToServer();

        });

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_new();
                gridWrapper.requestToServer();
            }
        };

        // 파일업로드 전 체크
        function fn_preUploadCheck(obj) {
            if($('#SAVE_MODE').val() == "I"){
                alert($.comm.getMessage("W00000035"));// 상세정보를 먼저 저장하세요.
                return false;
            }else{
                fileUtil.addParam("SN", $('#SN').val()); // 상세정보 키
            }

            return true;
        }

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $('#detailForm')[0].reset();

            $.comm.setContents("CONTENTS", "");

            fileUtil.clear(); // 첨부파일 내용 초기화
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.saveContent("CONTENTS");

            $('#qKey').val("ntc.insertCmmNotice");

            var url = "<c:out value="/common/insert.do"/>";
            if($('#SAVE_MODE').val() == "U"){
                url = "<c:out value="/common/update.do"/>";

                $('#qKey').val("ntc.updateCmmNotice");
            }

            $.comm.sendForm(url, "detailForm", fn_callback, "공지사항 저장");
        }

        // 미리보기
        function fn_preview() {
            if($('#SAVE_MODE').val() == "I"){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return;
            }

            var args = {
                "TITLE"   : $('#TITLE').val(),
                "CONTENTS": $.comm.getContents("CONTENTS")
            };
            $.comm.setModalArguments(args);
            var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/ntc/ntcViewPopup" />", spec, null);
        }

        // 업로드 callback
        function fn_uploadCallback(){
            fn_detail(globalVar.currRow);
        }

        // 상세정보 화면
        function fn_detail(index) {
            if($.comm.isNull(index)){
                index = 0;
            }

            var data = gridWrapper.getRowData(index);

            data["qKey"] = "ntc.selectCmmNotice";
            $.comm.send("/common/select.do", data,
                function (ret) {
                    var data = ret.data;

                    fn_new();

                    $('#SAVE_MODE').val("U");

                    $.comm.bindData(data);
                    $.comm.setContents("CONTENTS", data.CONTENTS);

                    fileUtil.setAtchFileId(data.ATCH_FILE_ID);
                    fileUtil.selectFileList({"ATCH_FILE_ID" : data.ATCH_FILE_ID}); // 첨부파일 목록 조회
                }, "상세정보 조회"
            );

            globalVar.currRow = index;
        }

        // 첨부파일 다운로드
        function fn_download(index) {
            fileUtil.fileDownload(index);
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
                        <label for="F_MOD_DTM">최종작성일자</label><label for="T_MOD_DTM"
                                                                                       style="display: none">최종작성일자</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_MOD_DTM" name="F_MOD_DTM" <attr:datefield to="T_MOD_DTM" value="-6m"/>><span>~</span>
                                    <input type="text" id="T_MOD_DTM" name="T_MOD_DTM" <attr:datefield  value="0"/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="P_TITLE">제목</label>
                        <input id="P_TITLE" name="P_TITLE" type="text"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>


    <div class="vertical_frame">
        <div class="vertical_frame_left46">
            <div class="title_frame">
                <p><a href="#공지사항" class="btnToggle">공지사항 목록</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#삭제"          class="btn white_84" id="btnDel">삭제</a>
                        <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                    </div>
                    <div id="gridLayer" style="height: 430px">
                    </div>
                    <div class="bottom_util">
                        <div class="paging" id="gridPagingLayer">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="vertical_frame_right46">
            <div class="title_frame">
                <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
                        <a href="#미리보기" class="btn blue_100" id="btnPreview">미리보기</a>
                    </div>
                    <form id="detailForm" name="detailForm">
                        <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                        <input type="hidden" id="SN" name="SN">
                        <input type="hidden" id="qKey" name="qKey">
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">상세정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                    <col width="145px"/>
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="IS_POPUP">팝업공지</label></td>
                                    <td>
                                        <select id="IS_POPUP" name="IS_POPUP" style="width: 100px">
                                            <option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
                                    </td>
                                    <td><label for="POPUP_LAST_DT">팝업공지 일자</label></td>
                                    <td>
                                        <input type="text" id="POPUP_LAST_DT" name="POPUP_LAST_DT" <attr:datefield/>>
                                    </td>
                                </tr>
                                <tr>
                                    <td><label for="TITLE">제목</label></td>
                                    <td colspan="3"><input type="text" name="TITLE" id="TITLE" <attr:length value="100" /> <attr:mandantory/> ></td>
                                </tr>
                                <tr>
                                    <td><label for="CONTENTS">내용</label></td>
                                    <td  colspan="3" style="padding-top:5px; padding-bottom: 5px;"><textarea type="text" name="CONTENTS" id="CONTENTS" style="height: 400px;" <attr:length value="4000" />></textarea></td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
            <div class="title_frame">
                <p><a href="#첨부파일" class="btnToggle">첨부파일</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#삭제" class="btn blue_84" id="btnDelFile">삭제</a>
                        <a href="#추가" class="btn blue_84" id="btnAddFile">추가</a>
                    </div>
                    <div id="gridWrapLayer" style="height: 100px">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
