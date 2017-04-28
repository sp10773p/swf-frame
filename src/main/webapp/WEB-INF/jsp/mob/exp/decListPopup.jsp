<%--
    Class Name : decListPopup.jsp
    Description : 모바일 검색팝업
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.27  성동훈   최초 생성

    author : 성동훈
    since : 2017.03.27
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-mobile-header.jspf" %>
    <script>
        $(function() {
            $('#F_REG_DTM').val(globalVar["fromRptDate"].toDate("YYYYMMDD").format("YYYY-MM-DD"));
            $('#T_REG_DTM').val(globalVar["toRptDate"].toDate("YYYYMMDD").format("YYYY-MM-DD"));

            $('.close_layer').on('click', function () {
                layerPop('');
            })

            $('#btnSearch').on('click', function () {
                var params = {
                    "F_REG_DTM" : $('#F_REG_DTM').val().replace(/\/|-/g, ''),
                    "T_REG_DTM" : $('#T_REG_DTM').val().replace(/\/|-/g, ''),
                    "SEND"      : $('#AAA1001').val(),
                    "RECE"      : $('#AAA1002').val(),
                    "SEARCH_COL" : $('#SEARCH_COL').val(),
                    "SEARCH_TXT" : $('#SEARCH_TXT').val()
                }
                fn_search(params);
                layerPop('');
            })
        })
    </script>
</head>
<body>
<div class="layer_wrap" style="height: 500px;">
    <div class="layer_container">
        <div class="layer_title">
            <h1>조회</h1>
            <a href="#0" class="close_layer">닫기</a>
        </div>
        <div class="layer_contents">
            <ul class="search_frame">
                <li>
                    <h2>신고일자</h2>
                    <div class="date_search">
                        <form action="">
                            <fieldset>
                                <legend class="blind">달력</legend>
                                <input type="date" id="F_REG_DTM" name="F_REG_DTM">
                                <span>~</span>
                                <input type="date" id="T_REG_DTM" name="T_REG_DTM">
                            </fieldset>
                        </form>
                    </div>
                </li>
                <li>
                    <h2>전송상태</h2>
                    <select id="AAA1001" name="AAA1001" <attr:selectfield/> ></select>
                </li>
                <li>
                    <h2>수신상태</h2>
                    <select id="AAA1002" name="AAA1002" <attr:selectfield/> ></select>
                </li>
                <li>
                    <h2><label for="SEARCH_COL" class="search_title">검색조건</label></h2>
                    <select id="SEARCH_COL" name="SEARCH_COL">
                        <option value="A.RPT_NO">수출신고번호</option>
                        <option value="A.ORDER_ID">주문번호</option>
                    </select>
                    <input type="text" name="SEARCH_TXT" id="SEARCH_TXT" class="search_input inputHeight"/>
                </li>
            </ul>
            <!-- //search_frame -->
            <div class="btn_frame justify_frame">
                <a href="#닫기" class="btn lightgray_btn close_layer">닫기</a>
                <a href="#조회" class="btn inquiry_btn" id="btnSearch" >조회</a>
            </div>
        </div>
    </div>
</div>
<!-- //layerContainer -->
</body>
</html>
