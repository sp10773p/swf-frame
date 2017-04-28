<%--
    Class Name : msgList.jsp
    Description : 알리메시지 관리
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
        $(function (){
            headers = [
                {"HEAD_TEXT": "메시지유형"  , "WIDTH": "100", "FIELD_NAME": "TYPE_NM"},
                {"HEAD_TEXT": "메시지코드"  , "WIDTH": "100", "FIELD_NAME": "CODE"   , "LINK":"fn_detail"},
                {"HEAD_TEXT": "메시지내용"  , "WIDTH": "*"  , "FIELD_NAME": "MESSAGE", "ALIGN":"left"},
                {"HEAD_TEXT": "사용여부"    , "WIDTH": "60" , "FIELD_NAME": "USE_YN"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "메시지 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "msg.selectMsgList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "firstLoad"    : true,
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            //신규
            $('#btnNew').on("click", function (e) {
                fn_new();
            });

            //저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });
        });

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $('#detailForm')[0].reset();
            $.comm.readonly("CODE", true);
            $('#CODE').removeAttr("mandantory");
            $.comm.mandantoryExp();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:out value="/msg/saveMessage.do"/>", "detailForm", fn_callback, "메시지 저장");
        }

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                fn_new();
                gridWrapper.requestToServer();
            }
        };

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            $('#SAVE_MODE').val("U");

            $('#ORG_TYPE').val(data.TYPE);
            $('#ORG_CODE').val(data.CODE);

            $('#TYPE').val(data.TYPE);
            $('#CODE').val(data.CODE);
            $('#USE_YN').val(data.USE_YN);
            $('#MESSAGE').val(data.MESSAGE);

            $.comm.readonly("CODE", false);
            $('#CODE').attr("mandantory", "");
            $.comm.mandantoryExp();
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
                        <label for="P_TYPE">메시지유형</label>
                        <select id="P_TYPE" name="P_TYPE">
                            <option value="">선택</option>
                            <option value="I">안내</option>
                            <option value="W">경고</option>
                            <option value="E">에러</option>
                            <option value="C">확인</option>
                        </select>
                    </li>
                    <li>
                        <label for="P_CODE">메시지코드</label>
                        <input id="P_CODE" name="P_CODE" type="text"/>
                    <li>
                        <label for="P_USE_YN">사용여부</label>
                        <select id="P_USE_YN" name="P_USE_YN">
                            <option value="">선택</option>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </li>
                    <li>
                        <label for="P_MESSAGE">메시지</label>
                        <input id="P_MESSAGE" name="P_MESSAGE" type="text"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left73">
            <div class="white_frame">
                <div class="util_frame">
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

        <div class="vertical_frame_right73">
            <div class="white_frame">
                <div class="util_frame">
                    <div class="util_left46">
                        <p class="util_title">상세정보</p>
                    </div>
                    <div class="util_right46">
                        <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                        <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
                    </div>
                </div>
                <form name="detailForm" id="detailForm">
                    <input type="hidden" id="ORG_TYPE" name="ORG_TYPE">
                    <input type="hidden" id="ORG_CODE" name="ORG_CODE">
                    <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
                    <div class="table_typeA darkgray table_toggle">
                        <table style="table-layout:fixed;" >
                            <caption class="blind">상세정보</caption>
                            <colgroup>
                                <col width="145px"/>
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="TYPE">메시지유형</label></td>
                                <td>
                                    <select id="TYPE" name="TYPE">
                                        <option value="I">안내</option>
                                        <option value="W">경고</option>
                                        <option value="E">에러</option>
                                        <option value="C">확인</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="CODE">메시지코드</label></td>
                                <td><input type="text" name="CODE" id="CODE"/></td>
                            </tr>
                            <tr>
                                <td><label for="USE_YN">사용여부</label></td>
                                <td>
                                    <select id="USE_YN" name="USE_YN">
                                        <option value="Y" selected>사용</option>
                                        <option value="N">미사용</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="MESSAGE">메시지</label></td>
                                <td><input type="text" name="MESSAGE" id="MESSAGE" <attr:mandantory/> ></td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
