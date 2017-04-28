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
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "제목"    , "WIDTH": "*" , "FIELD_NAME": "SUBJECT", "LINK": "fn_detail", "ALIGN":"left"},
                {"HEAD_TEXT": "게시여부", "WIDTH": "80", "FIELD_NAME": "IS_OPEN"},
                {"HEAD_TEXT": "수신일"  , "WIDTH": "80", "FIELD_NAME": "REG_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "뉴스레터 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "ntc.selectCmmNewsList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "check"             : true,
                "firstLoad"         : true,
                "postScript"        : function(){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "qKey":"deleteCmmNews"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            // 저장
            $('#btnSave').on('click', function (e) {
                fn_save();
            });

            // 미리보기
            $('#btnPreview').on('click', function (e) {
                fn_preview();
            });

        });

        var fn_callback = function (data) {
            if (data.code.indexOf('I') == 0) {
                gridWrapper.requestToServer();
            }
        };

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:out value="/common/update.do"/>", "detailForm", fn_callback, "뉴스레터 저장");
        }

        // 미리보기
        function fn_preview() {
            if($('#CONTENTS').val().length == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return;
            }

            var args = {
                "CONTENTS": $("#CONTENTS").val()
            };
            $.comm.setModalArguments(args);
            $.comm.open("news_letter", "<c:out value="/jspView.do?jsp=adm/ntc/newsViewPopup" />", 700, 840);
        }

        // 상세정보 화면
        function fn_detail(index) {
            if($.comm.isNull(index)){
                index = 0;
            }

            var data = gridWrapper.getRowData(index);
            $.comm.bindData(data);
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
                        <label for="F_REG_DTM">수신일</label><label for="T_REG_DTM" style="display: none">수신일</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" <attr:datefield to="T_REG_DTM" value="-6m"/>><span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" <attr:datefield  value="0"/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="P_SUBJECT">제목</label>
                        <input id="P_SUBJECT" name="P_SUBJECT" type="text"/>
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
                <p><a href="#뉴스레터" class="btnToggle">뉴스레터 목록</a></p>
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
                        <a href="#미리보기" class="btn blue_100" id="btnPreview">미리보기</a>
                    </div>
                    <form id="detailForm" name="detailForm">
                        <input type="hidden" id="SN" name="SN">
                        <input type="hidden" id="qKey" name="qKey" value="ntc.updateCmmNews">
                        <div class="table_typeA darkgray table_toggle">
                            <table style="table-layout:fixed;" >
                                <caption class="blind">상세정보</caption>
                                <colgroup>
                                    <col width="145px"/>
                                    <col width="*" />
                                </colgroup>
                                <tr>
                                    <td><label for="IS_OPEN">게시여부</label></td>
                                    <td>
                                        <select id="IS_OPEN" name="IS_OPEN" style="width: 100px">
                                            <option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><label for="SUBJECT">제목</label></td>
                                    <td><input type="text" name="SUBJECT" id="SUBJECT" <attr:length value="100" /> <attr:mandantory/> ></td>
                                </tr>
                                <tr>
                                    <td><label for="CONTENTS">내용</label></td>
                                    <td style="padding-top:5px; padding-bottom: 5px;"><textarea type="text" name="CONTENTS" id="CONTENTS" style="height: 439px;"></textarea></td>
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
