<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2017-04-21
  Time: 오전 11:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
        var gridWrapper, headers;

        $(function () {
            headers = [
                {"HEAD_TEXT": "제목"      , "WIDTH": "*"  , "FIELD_NAME": "TITLE", "ALIGN":"left", "POSIT":true, "HTML_FNC":fn_html},
                {"HEAD_TEXT": "작성자"    , "WIDTH": "120", "FIELD_NAME": "REG_NM"},
                {"HEAD_TEXT": "최종작성일", "WIDTH": "120", "FIELD_NAME": "MOD_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "게시판 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "board.selectCmmBoardList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : true,
                "postScript"        : function(){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"}
                ]
            });
            var writeReady = function(){
                $.comm.display(["btnSave"], true);
                $.comm.display(["btnWrite", "btnReply", "btnDel"], false);

                fn_clear();

                $('#SAVE_MODE').val("I");

            }

            // 새 글쓰기
            $('#btnWrite').on('click', writeReady);

            // 답글 쓰기
            $('#btnReply').on('click', function () {
                var boardId = $('#BOARD_ID').val();
                writeReady();
                $('#PBOARD_ID').val(boardId);
            })

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 삭제
            $('#btnDel').on('click', function (e) {
                fn_del();
            });


        })

        // 상세정보 RESET
        function fn_clear(){
            $('#detailForm')[0].reset();
            $('#detailForm').find("input:hidden").val("");
        }

        // 상세정보 화면
        function fn_detail(index) {
            $.comm.display(["btnSave", "btnDel", "btnReply", "btnWrite"], true);

            if($.comm.isNull(index)){
                index = 0;
            }

            var linkData = gridWrapper.getRowData(index);
            if ($.comm.isNull(linkData) || linkData.length == 0 || linkData["DEL_YN"] == 'Y') {
                $.comm.display("btnDel", false);
                return;
            }

            if (linkData["MOD_ID"] == "${session.getUserId()}"){
                $.comm.display(["btnSave","btnDel"], true);

                if(linkData["BOARD_LEVEL"] == "1" && linkData["IS_LEAF"] == "N"){
                    $.comm.display("btnDel", false);
                }
            }else{
                $.comm.display(["btnSave","btnDel"], false);

            }

            fn_clear();
            $.comm.bindData(linkData);
            $('#SAVE_MODE').val("U");
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:url value="/board/save.do"/>", "detailForm", fn_callback, "게시판 저장");
        }

        // 삭제
        function fn_del() {
            if (!confirm($.comm.getMessage("C00000001"))) { // 삭제 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:url value="/board/delete.do"/>", "detailForm", fn_callback, "게시판 삭제");
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                gridWrapper.requestToServer();
            }
        };

        function fn_html(index) {
            var data = gridWrapper.getRowData(index);
            var title = "";
            var lvl = 5 * (parseInt(data["LVL"])-1);
            for(var i=0; i < lvl; i++) {
                title += "&nbsp;";
            }
            if(lvl > 0) {
                title += "<img src='/images/bg/bg_bbs_reply.png'><span style='margin-left:4px;'>Re</span><strong style='margin:0 4px;'>:</strong>";
            }

            title += (data["DEL_YN"] == "Y"  ? $.comm.getMessage("I00000044") : data["TITLE"]); // 삭제된 글입니다.

            var anchor = $("<a><span>" + title + "</span>");

            if(data["DEL_YN"] == "N"){
                anchor.attr("style"  , "color:#0000ff");
                anchor.attr("onclick", 'gfn_gridLink("fn_detail", "' + (index) + '")');

                //onclick시 배경색 지정
                gfn_addHilightEvent(anchor);
            }

            return anchor;
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
        <div class="vertical_frame_left55">
            <div class="title_frame">
                <p><a href="#게시판" class="btnToggle">게시판 목록</a></p>
                <div class="white_frame">
                    <div id="gridLayer" style="height: 430px">
                    </div>
                    <div class="bottom_util">
                        <div class="paging" id="gridPagingLayer">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="vertical_frame_right55">
            <div class="title_frame">
                <p><a href="#상세정보" class="btnToggle">상세정보</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#글쓰기"      class="btn blue_84" id="btnWrite">새 글쓰기</a>
                        <a href="#답글 등록"   class="btn blue_84" id="btnReply">답글 쓰기</a>
                        <a href="#삭제"        class="btn blue_84" id="btnDel" style="display: none">삭제</a>
                        <a href="#저장"        class="btn blue_84" id="btnSave" style="display: none">저장</a>
                    </div>
                    <form id="detailForm" name="detailForm">
                        <input type="hidden" name="PBOARD_ID" id="PBOARD_ID">
                        <input type="hidden" name="BOARD_ID" id="BOARD_ID">
                        <input type="hidden" name="MOD_ID" id="MOD_ID">
                        <input type="hidden" name="SAVE_MODE" id="SAVE_MODE" value="I">
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">상세정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="TITLE">제목</label></td>
                                    <td colspan="3"><input type="text" name="TITLE" id="TITLE" <attr:length value="100" /> <attr:mandantory/> ></td>
                                </tr>
                                <tr>
                                    <td><label for="CONTENTS">내용</label></td>
                                    <td  colspan="3" style="padding-top:5px; padding-bottom: 5px;"><textarea type="text" name="CONTENTS" id="CONTENTS" style="padding:10px; height: 437px;" <attr:length value="4000" />></textarea></td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>

</body>
</html>
