<%--
    Class Name : admExpStaMap.jsp
    Description : 수출신고 현황 (지도)
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.01.15  성동훈   최초 생성
    author : 성동훈
    since : 2017.03.10
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-header.jspf" %>
    <script src="<c:url value='/js/ammap.js'/>"></script>
    <script src="<c:url value='/js/worldLow.js'/>"></script>
    <script src="<c:url value='/js/worldMapCoordinate.js'/>"></script>

    <style>
        #chartdiv {
            width: 100%;
            height: 1000px;
        }
    </style>
    <script>

    $(function (){
        var obj = $('#EXP_LIS_YEAR');

        $('option', obj).remove();
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
            obj.append(opt);
        }

        // 사용자 조회 팝업
        $('#btnExpsdno').on("click", function () {
            fn_userPopup();
        })

        // 조회
        $('#btnSearch').on("click", function () {
            fn_search();
        })

        $('#SEARCH_TYPE, #EXP_LIS_YEAR').on("change", function () {
            fn_search();
        })

        fn_search();

	});

    function fn_search(){
        var params = {
            "qKey"         : "sta.expStaNatMap",
            "EXP_LIS_YEAR" : $('#EXP_LIS_YEAR').val(),
            "EXP_SDNO"     : $('#EXP_SDNO').val()
        }
        $.comm.send("<c:out value="/common/selectList.do" />", params, function (ret) {
            var data = ret.dataList;

            var valueKeyId = $('#SEARCH_TYPE').val();
            var nameKeyId = (valueKeyId == "TOT_CNT" ? "TA_ST_ISO_NM_CNT" : "TA_ST_ISO_NM_AMT");

            $.latlong.drawWorldMap("chartdiv", data, "TA_ST_ISO", nameKeyId, valueKeyId);
        }, "국가별 수출현황 지도 조회")
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
            <input type="hidden" name="IS_ADMIN" id="IS_ADMIN" value="T">
            <div class="search_frame">
                <ul class="search_sectionB">
                    <li>
                        <label for="EXP_LIS_YEAR">검색기준년도</label>
                        <select id="EXP_LIS_YEAR" name="EXP_LIS_YEAR" style="width:120px;" ></select>
                    </li>
                    <li>
                        <label for="EXP_SDNO">사업자등록번호</label>
                        <input id="EXP_SDNO" name="EXP_SDNO" type="text" style="width:calc(100% - 300px)"/>
                        <a href="#사업자등록번호" class="btn_search" id="btnExpsdno"><img src="/images/btn/btn_search_box.png" alt=""></a>
                    </li>
                    <li>
                        <label for="SEARCH_TYPE">검색기준값</label>
                        <select id="SEARCH_TYPE" name="SEARCH_TYPE" style="width:120px;">
                            <option value="TOT_CNT">건별</option>
                            <option value="TOT_KRW">금액별</option>
                        </select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
        </form>
    </div>
    <div id="chartdiv"></div>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>