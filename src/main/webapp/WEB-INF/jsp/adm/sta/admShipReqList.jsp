<%--
    Class Name : admShipReqList.jsp
    Description : 특송사 배송요청 현황
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.04.03  성동훈   최초 생성
    author : 성동훈
    since : 2017.04.03
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
        var gridWrapper, headers;

        $(function () {
            var year = $('#YEAR');

            $('option', year).remove();
            var maxIndex = 10;
            var fromYear = 2016;
            var toYear = (new Date()).getFullYear();
            for(var i=toYear; i>=fromYear; i--){
                if(maxIndex == 0) break;
                maxIndex--;

                var opt = $('<option>', {
                    value: i,
                    text : i
                })
                year.append(opt);
            }

            headers = [
                {"HEAD_TEXT": "판매업체"  , "WIDTH": "100", "FIELD_NAME": "BIZ_NO", "HIDDEN" : "true"},
                {"HEAD_TEXT": "판매업체명", "WIDTH": "100", "FIELD_NAME": "USER_NM","HIDDEN" : "true"},
                {"HEAD_TEXT": "특송업체"  , "WIDTH": "100", "FIELD_NAME": "EXPRESS_BIZ_NO"},
                {"HEAD_TEXT": "특송업체명", "WIDTH": "100", "FIELD_NAME": "EXPRESS_USER_NM"},
                {"HEAD_TEXT": "총건수"    , "WIDTH": "100", "FIELD_NAME": "TOT_CNT", "DATA_TYPE": "NUM"}
            ];

            for (var i = 1; i <= 12; i++) {
                headers.push({
                    "HEAD_TEXT": i + "월건수",
                    "WIDTH": "80",
                    "FIELD_NAME": "TOT_CNT" + (i < 10 ? "0" + i : String(i)),
                    "DATA_TYPE": "NUM"
                });
            }

            var fn_header = function () {
                if(this.PAGE_INDEX > 0 || ($.comm.getTarget(event) != null && $.comm.getTarget(event).id.indexOf("excel") > 0)){
                    return true;
                }

                var bizNo = $('#BIZ_NO').val();
                var expressBizNo = $('#EXPRESS_BIZ_NO').val();

                /*if($.comm.isNull(bizNo) && $.comm.isNull(expressBizNo)){
                    alert($.comm.getMessage("W00000055")); // 검색조건을 입력하십시오.
                    return false;
                }*/

                if($.comm.isNull(expressBizNo)){
                    headers[2]["HIDDEN"] = "false"; // 특송업체
                    headers[3]["HIDDEN"] = "false"; // 특송업체명
                }else{
                    headers[2]["HIDDEN"] = "true";
                    headers[3]["HIDDEN"] = "true";
                }

                if($.comm.isNull(bizNo)){
                    headers[0]["HIDDEN"] = "false"; // 판매업체
                    headers[1]["HIDDEN"] = "false"; // 판매업체
                }else{
                    headers[0]["HIDDEN"] = "true";
                    headers[1]["HIDDEN"] = "true";
                }

                gridWrapper.setHeaders(headers);
                gridWrapper.drawGrid();

                return true;
            }

            gridWrapper = new GridWrapper({
                "actNm"         : "특송사 배송요청 현황 조회",
                "targetLayer"   : "gridLayer",
                "qKey"          : "sta.selectAdmShipReqList",
                "headers"       : headers,
                "paramsFormId"  : "searchForm",
                "gridNaviId"    : "gridPagingLayer",
                "preScript"     : fn_header,
                "check"         : true,
                "firstLoad"     : false,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btn_excel", "type": "EXCEL"}
                ]
            });

            // 판매업체 조회 팝업
            $('#btnBizNo').on("click", function () {
                fn_userPopup("seller");
            })

            // 특송업체 조회 팝업
            $('#btnExpressBizNo').on("click", function () {
                fn_userPopup("express");
            })

            // 검색기준년도 변경
            year.on("change", function () {
                fn_search();
            })
        });

        function fn_search() {
            //if (!$.comm.isNull($('#BIZ_NO').val()) || !$.comm.isNull($('#EXPRESS_BIZ_NO').val())) {
                gridWrapper.requestToServer();
            //}
        }

        // 사용자 조회 팝업
        function fn_userPopup(type) {
            $.comm.setModalArguments({"FROM": "admExpStaNatList", "SEARCH_TYPE": type});
            var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
            // 모달 호츨
            $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/usrPopup" />", spec,
                function () { // 리턴받을 callback 함수
                    var ret = $.comm.getModalReturnVal();
                    if (ret) {
                        if(type == "seller"){
                            $('#BIZ_NO').val(ret.BIZ_NO); // 사업자등록번호
                        }else{
                            $('#EXPRESS_BIZ_NO').val(ret.BIZ_NO); // 사업자등록번호
                        }
                        gridWrapper.requestToServer();
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
                        <label for="YEAR">검색기준년도</label>
                        <select id="YEAR" name="YEAR" style="width:120px;" <attr:changeNoSearch/>></select>
                    </li>
                    <li>
                        <label for="BIZ_NO">판매업체</label>
                        <input id="BIZ_NO" name="BIZ_NO" type="text" style="width:calc(100% - 300px)"/>
                        <a href="#판매업체" class="btn_search" id="btnBizNo"><img src="/images/btn/btn_search_box.png" alt=""></a>
                    </li>
                    <li>
                        <label for="EXPRESS_BIZ_NO">특송업체</label>
                        <input id="EXPRESS_BIZ_NO" name="EXPRESS_BIZ_NO" type="text" style="width:calc(100% - 300px)"/>
                        <a href="#특송업체" class="btn_search" id="btnExpressBizNo"><img src="/images/btn/btn_search_box.png" alt=""></a>
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
            <a href="#엑셀다운로드" class="btn white_100" id="btn_excel">엑셀다운로드</a>
        </div>
        <div id="gridLayer" style="height: 430px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>