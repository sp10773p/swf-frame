<%--
    Class Name : usrList.jsp
    Description : 사용자 관리
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

    <s:eval expression="@config.getProperty('site.name')" var="siteUrl"/>

    <script>
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "사용자ID"       , "WIDTH": "100", "FIELD_NAME": "USER_ID", "LINK": "fn_detail"},
                {"HEAD_TEXT": "사용자구분"     , "WIDTH": "80" , "FIELD_NAME": "USER_DIV_NM"},
                {"HEAD_TEXT": "가입상태"       , "WIDTH": "100", "FIELD_NAME": "USER_STATUS_NM"},
                {"HEAD_TEXT": "사업자등록번호" , "WIDTH": "120", "FIELD_NAME": "BIZ_NO"},
                {"HEAD_TEXT": "사용자명"       , "WIDTH": "150", "FIELD_NAME": "USER_NM", "ALIGN":"left"},
                {"HEAD_TEXT": "전화번호"       , "WIDTH": "90" , "FIELD_NAME": "TEL_NO"},
                {"HEAD_TEXT": "휴대폰번호"     , "WIDTH": "90" , "FIELD_NAME": "HP_NO"},
                {"HEAD_TEXT": "이메일"         , "WIDTH": "150", "FIELD_NAME": "EMAIL"},
                {"HEAD_TEXT": "가입신청일자"   , "WIDTH": "100", "FIELD_NAME": "REG_DTM"},
                {"HEAD_TEXT": "가입승인일자"   , "WIDTH": "100", "FIELD_NAME": "APPROVAL_DTM"},
                {"HEAD_TEXT": "사용여부"       , "WIDTH": "60" , "FIELD_NAME": "USE_CHK"},
                {"HEAD_TEXT": "팩스번호"       , "WIDTH": "90" , "FIELD_NAME": "FAX_NO"},
                {"HEAD_TEXT": "업태"           , "WIDTH": "100", "FIELD_NAME": "BIZ_CONDITION"},
                {"HEAD_TEXT": "종목"           , "WIDTH": "100", "FIELD_NAME": "BIZ_LINE"}
            ];

            var fn_setCheckDisabled = function (gridObj) {
                var data = gridObj.getData();
                $.each(data, function (index, obj) {
                    var status = obj.USER_STATUS;
                    var authCd = obj.AUTH_CD;

                    if(status != "1" || $.comm.isNull(authCd)){
                        gridObj.setCheckDisabled(index, true);
                    }
                })
            };

            gridWrapper = new GridWrapper({
                "actNm"             : "사용자 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "usr.selectUsrList",
                "requestUrl"        : "/usr/selectUsrList.do",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "onlyOneCheck"      : true,
                "firstLoad"         : false,
                "postScript"        : fn_setCheckDisabled,
                "defaultSort"       : "REG_DTM DESC",
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });

            $.comm.bindFilterCombo("USER_DIV", "USER_DIV", true, "G,M,S,E");

            // 사용자 Web접속
            $('#btnPortal').on('click', function (e) {
                fn_userWebSiet();
            });

            // 가입상태 변경
            $('#USER_STATUS').on('change', function () {
                if(!$.comm.isNull($(this).val())){
                    $('#USE_CHK').val("");
                }

                gridWrapper.requestToServer();
            })

            $.comm.initPageParam();
            gridWrapper.requestToServer();
            fn_statusSumm();
        });

        // 가입상태 요약
        function fn_statusSumm(){
            var params = $.comm.getFormData("searchForm");
            params["qKey"] = "usr.selectUsrStatusSumm";
            $.comm.send("/common/select.do", params, function (ret) {
                var data = ret.data;
                var str  = '가입승인요청:' + ($.comm.isNull(data) ? "0" : data["STATUS0"]) + ' 건, ';
                     str += '탈퇴승인요청:' + ($.comm.isNull(data) ? "0" : data["STATUS8"]) + ' 건';

                $('#REQ_USER_STAUTS').html(str);
            },"가입상태 요약 정보");
        }

        // 상세정보 화면
        function fn_detail(index) {
            var data = gridWrapper.getRowData(index);
            data["SAVE_MODE"] = "U";

            $.comm.forward("adm/sys/usrDetail", data);
        }

        // 사용자 web 접속
        function fn_userWebSiet() {
            var size = gridWrapper.getSelectedSize();
            if(size == 0){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없스니다.
                return;
            }

            var rows = gridWrapper.getSelectedRows();
            var userId = rows[0].USER_ID;

            var ret = $.comm.sendSync("<c:out value="/usr/createWebAccessKey.do"/>" + "?userId="+userId);
            if(ret){
                var data = ret.data;
                var params = {
                    "userId" : rows[0].USER_ID,
                    "key"    : data.accessKey
                }

                var url = '<c:out value="${siteUrl}" />/<c:out value="/usr/userWebSite.do"/>';
                $.comm.postOpen(url, "USER_SITE_WEB", params);
            }
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
                        <label for="F_REG_DTM">가입신청일</label><label for="T_REG_DTM"
                                                                                       style="display: none">가입신청일</label>
                        <div class="dateSearch">
                            <form action="#">
                                <fieldset>
                                    <legend class="blind">달력</legend>
                                    <input type="text" id="F_REG_DTM" name="F_REG_DTM" <attr:datefield to="T_REG_DTM"/>><span>~</span>
                                    <input type="text" id="T_REG_DTM" name="T_REG_DTM" <attr:datefield/>>
                                </fieldset>
                            </form>
                        </div>
                    </li>
                    <li>
                        <label for="USER_STATUS">가입상태</label>
                        <select id="USER_STATUS" name="USER_STATUS" <attr:selectfield/> <attr:changeNoSearch/>></select>
                    </li>
                    <li>
                        <label for="USE_CHK">사용여부</label>
                        <select id="USE_CHK" name="USE_CHK">
                            <option value="">선택</option>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </li>
                    <li>
                        <label for="SEARCH_COL">검색조건</label>
                        <label for="SEARCH_TXT" style="display: none">검색조건 TEXT</label>
                        <select id="SEARCH_COL" name="SEARCH_COL" style="width:120px;" <attr:changeNoSearch/> >
                            <option value="BIZ_NO" selected>사업자등록번호</option>
                            <option value="USER_ID">사용자ID</option>
                            <option value="USER_NM">사용자명</option>
                        </select>
                        <input id="SEARCH_TXT" name="SEARCH_TXT" type="text"
                               style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="USER_DIV">사용자구분</label>
                        <select id="USER_DIV" name="USER_DIV"></select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>


    <div class="white_frame">
        <div class="util_frame">
            <div class="util_left64">
                <p class="total">Total <span id="totCnt"></span><span id="REQ_USER_STAUTS" style="background: #008ee1;"></span></p>
            </div>
            <div class="util_right64">
                <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
                <a href="#사용자Web접속" class="btn white_100" id="btnPortal">사용자Web접속</a>
            </div>
        </div>
        <div id="gridLayer" style="height: 430px">
        </div>
        <div class="bottom_util">
            <div class="paging" id="gridPagingLayer">
            </div>
        </div>

    </div>
    <%-- white_frame --%>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
