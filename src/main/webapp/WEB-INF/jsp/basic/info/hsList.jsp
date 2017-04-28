<%--
    Class Name : hsList.jsp
    Description : HS 코드
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
                {"HEAD_TEXT": "HS부호"  , "WIDTH": "100", "FIELD_NAME": "HS_CD"    , "LINK":"fn_detail"},
                {"HEAD_TEXT": "한글명"  , "WIDTH": "350", "FIELD_NAME": "STD_NM_HN", "ALIGN":"left"},
                {"HEAD_TEXT": "영문명"  , "WIDTH": "350", "FIELD_NAME": "STD_NM_EN", "ALIGN":"left"},
                {"HEAD_TEXT": "수량단위", "WIDTH": "80" , "FIELD_NAME": "PKG_UNIT" },
                {"HEAD_TEXT": "중량단위", "WIDTH": "80" , "FIELD_NAME": "WT_UNIT"  }
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "신고서기본값 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectHsList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : false,
                "check"             : true,
                "preScript"         : fn_searchValid,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"   , "type": "D", "qKey":"sel.deleteHsCode"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
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

        // 조회조건 필수 체크
        function fn_searchValid() {
            if($.comm.isNull($('#P_HS_CD').val()) && $.comm.isNull($('#P_STD_NM_HN').val())
                        && $.comm.isNull($('#P_STD_NM_EN').val())){
                alert($.comm.getMessage("W00000004", "검색조건")); // 검색조건을 입력하세요.
                return false;
            }

            return true;
        }
        
        var fn_callback = function () {
            if(!($.comm.isNull($('#P_HS_CD').val()) && $.comm.isNull($('#P_STD_NM_HN').val())
                && $.comm.isNull($('#P_STD_NM_EN').val()))){
                gridWrapper.requestToServer();
            }

            fn_new();
        };

        // 신규
        function fn_new() {
            $('#SAVE_MODE').val("I");
            $('#detailForm')[0].reset();
        }

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("<c:out value="/sel/saveHsCode.do"/>", "detailForm", fn_callback, "HS코드 저장");
        }

        // 상세정보 화면
        function fn_detail(index){
            var data = gridWrapper.getRowData(index);
            $('#SAVE_MODE').val("U");

            $('#SN').val(data.SN);
            $('#HS_CD').val(data.HS_CD);
            $('#STD_NM_HN').val(data.STD_NM_HN);
            $('#STD_NM_EN').val(data.STD_NM_EN);
            $('#PKG_UNIT').val(data.PKG_UNIT);
            $('#WT_UNIT').val(data.WT_UNIT);

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
                        <label for="P_HS_CD">HS부호</label>
                        <input id="P_HS_CD" name="P_HS_CD" style="width:calc(100% - 150px)"/>
                    </li>
                    <li>
                        <label for="P_STD_NM_HN">한글명</label>
                        <input id="P_STD_NM_HN" name="P_STD_NM_HN" style="width:calc(100% - 150px)"/>
                    </li>
                    <li>
                        <label for="P_STD_NM_EN">영문명</label>
                        <input id="P_STD_NM_EN" name="P_STD_NM_EN" style="width:calc(100% - 150px)"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <div class="title_frame">
        <p><a href="#HS목록" class="btnToggle">HS 목록</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                <a href="#삭제" class="btn white_84"  id="btnDel">삭제</a>
            </div>
            <div id="gridLayer" style="overflow: auto; height: 410px">
            </div>
            <div class="bottom_util">
                <div class="paging" id="gridPagingLayer">
                </div>
            </div>
        </div><%-- white_frame --%>
    </div>

    <div class="white_frame">
        <div class="util_frame">
            <div class="util_left46">
                <p class="util_title">HS정보</p>
            </div>
            <div class="util_right46">
                <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
                <a href="#신규" class="btn blue_84" id="btnNew">신규</a>
            </div>
        </div>
        <form name="detailForm" id="detailForm">
            <input type="hidden" id="SN" name="SN">
            <input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <caption class="blind">상세정보</caption>
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                        <col width="145px"/>
                        <col width="*" />
                        <col width="145px"/>
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="HS_CD">HS부호</label></td>
                        <td><input type="text" name="HS_CD" id="HS_CD" <attr:length value="10"/> <attr:mandantory/> /></td>
                        <td><label for="PKG_UNIT">수량단위</label></td>
                        <td><input type="text" name="PKG_UNIT" id="PKG_UNIT" <attr:length value="2"/> /></td>
                        <td><label for="WT_UNIT">중량단위</label></td>
                        <td><input type="text" name="WT_UNIT" id="WT_UNIT" <attr:length value="2"/> /></td>
                    </tr>
                    <tr>
                        <td><label for="STD_NM_HN">한글명</label></td>
                        <td colspan="5"><input type="text" name="STD_NM_HN" id="STD_NM_HN" <attr:length value="1000"/>  <attr:mandantory/> /></td>
                    </tr>
                    <tr>
                        <td><label for="STD_NM_EN">영문명</label></td>
                        <td colspan="5"><input type="text" name="STD_NM_EN" id="STD_NM_EN" <attr:length value="1000"/> /></td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>

