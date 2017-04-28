<%--
    Class Name : admExpStaBizList.jsp
    Description : 업체별 수출현황 조회
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성
    author : 성동훈
    since : 2017.04.21
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script>
    var gridWrapper, headers;
    
    $(function (){
        headers = [
            {"HEAD_TEXT": "사업자등록번호", "WIDTH": "100", "FIELD_NAME": "EXP_SDNO"},
            {"HEAD_TEXT": "업체명"        , "WIDTH": "100", "FIELD_NAME": "USER_NM"},
            {"HEAD_TEXT": "국가코드"      , "WIDTH": "70" , "FIELD_NAME": "TA_ST_ISO"   , "HIDDEN" : "true"},
            {"HEAD_TEXT": "국가명"        , "WIDTH": "150", "FIELD_NAME": "TA_ST_ISO_NM", "HIDDEN" : "true"},
			{"HEAD_TEXT": "총신고건수"    , "WIDTH": "100", "FIELD_NAME": "TOT_CNT", "DATA_TYPE": "NUM"},
			{"HEAD_TEXT": "총신고금액"    , "WIDTH": "130", "FIELD_NAME": "TOT_KRW", "DATA_TYPE": "NUM"}
	    ];

		gridWrapper = new GridWrapper({
			"actNm"        : "국가별수출현황 조회",
			"targetLayer"  : "gridLayer",
			"qKey"         : "sta.expStaBiz1",
            "summaryQkey"  : "sta.expStaBiz1Total",
            "headers"      : headers,
            "paramsFormId" : "searchForm",
            "gridNaviId"   : "gridPagingLayer",
            "check"        : true,
            "firstLoad"    : false,
            "preScript"    : preScript,
            "postScript"   : postScript,
            "defaultSort"  : "TOT_KRW, EXP_SDNO",
			"controllers"  : [
				 {"btnName": "btnSearch", "type": "S"},
				 {"btnName": "btn_excel", "type": "EXCEL"}
			]
		});

        // 사용자 조회 팝업
        $('#btnExpsdno').on("click", function () {
            fn_userPopup();
        })

        // 국가코드 조회 팝업
        $('#btnTastiso').on("click", function () {
            $.comm.commCodePop("CUS0005", function () {
                var ret = $.comm.getModalReturnVal();
                if (ret) {
                    $('#TA_ST_ISO').val(ret.CODE);
                    fn_search();
                }
            })
        })

	});

    function fn_search(){
        gridWrapper.requestToServer();
    }


    // 사용자 조회 팝업
    function fn_userPopup() {
        $.comm.setModalArguments({"FROM":"admExpStaNatList"});

        var spec = "width:700px;height:840px;scroll:auto;status:no;center:yes;resizable:yes;";
        // 모달 호츨
        $.comm.dialog("<c:out value="/jspView.do?jsp=adm/sys/usrPopup" />", spec,
            function () { // 리턴받을 callback 함수
                var ret = $.comm.getModalReturnVal();
                if (ret) {
                    $('#EXP_SDNO').val(ret.BIZ_NO); // 사업자등록번호
                    gridWrapper.requestToServer();
                }
            }
        );
    }

    function preScript() {
        if(this.PAGE_INDEX > 0 || ($.comm.getTarget(event) != null && $.comm.getTarget(event).id.indexOf("excel") > 0)){
            return true;
        }

        var id = $(':radio[name="SEARCH_TYPE"]:checked').attr("id");
        if(id == "BIZ"){
            $('#TA_ST_ISO').val("");

            headers[0]["HIDDEN"] = "false"; // 사업자등록번호
            headers[1]["HIDDEN"] = "false"; // 업체명

            headers[2]["HIDDEN"] = "true"; // 국가코드
            headers[3]["HIDDEN"] = "true"; // 국가명

            gridWrapper.setQKey("sta.expStaBiz1");

        }else{
            $('#EXP_SDNO').val("");

            headers[0]["HIDDEN"] = "true"; // 사업자등록번호
            headers[1]["HIDDEN"] = "true"; // 업체명

            headers[2]["HIDDEN"] = "false"; // 국가코드
            headers[3]["HIDDEN"] = "false"; // 국가명

            gridWrapper.setQKey("sta.expStaBiz2");
        }

        gridWrapper.setHeaders(headers);
        gridWrapper.drawGrid();

        return true;
    }

    function postScript(){

    }
    </script>
</head>
<body>
<div id="content_body">
    <%-- 조회 영역 --%>
    <div class="search_toggle_frame">
        <form id="searchForm">
            <input type="hidden" name="IS_ADMIN" id="IS_ADMIN" value="T">
            <div class="search_frame">
                    <ul class="search_sectionB">
                        <li>
                            <label for="F_EXP_LIS_YEAR">가입신청일</label><label for="T_EXP_LIS_YEAR"
                                                                       style="display: none">가입신청일</label>
                            <div class="dateSearch">
                                <form action="#">
                                    <fieldset>
                                        <legend class="blind">달력</legend>
                                        <input type="text" id="F_EXP_LIS_YEAR" name="F_EXP_LIS_YEAR" <attr:datefield to="T_EXP_LIS_YEAR" value="-1m" />><span>~</span>
                                        <input type="text" id="T_EXP_LIS_YEAR" name="T_EXP_LIS_YEAR" <attr:datefield value="0"/>>
                                    </fieldset>
                                </form>
                            </div>
                        </li>
                        <li>
                            <label for="EXP_SDNO">판매자</label>
                            <input id="EXP_SDNO" name="EXP_SDNO" type="text" style="width:calc(100% - 300px)"/>
                            <a href="#판매자" class="btn_search" id="btnExpsdno"><img src="/images/btn/btn_search_box.png" alt=""></a>
                        </li>
                        <li>
                            <label for="TA_ST_ISO">국가코드</label>
                            <input id="TA_ST_ISO" name="TA_ST_ISO" type="text" style="width:100px"/>
                            <a href="#국가코드" class="btn_search" id="btnTastiso"><img src="/images/btn/btn_search_box.png" alt=""></a>
                        </li>
                        <li>
                            <label for="BIZ">현황구분</label>
                            <label for="NAT" style="display: none">현황구분</label>
                            <div class="radio">
                                <input type="radio" id="BIZ" name="SEARCH_TYPE" checked>
                                <label for="BIZ"><span></span>업체별</label>
                            </div>
                            <div class="radio">
                                <input type="radio" id="NAT" name="SEARCH_TYPE">
                                <label for="NAT"><span></span>국가별</label>
                            </div>
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
        <div id="gridLayer" style="height: 445px">
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