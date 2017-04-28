<%--
    Class Name : itemList.jsp
    Description : 상품정보
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
                {"HEAD_TEXT": "판매자ID"       , "WIDTH": "100", "FIELD_NAME": "MALL_ID"},
                {"HEAD_TEXT": "몰판매자ID"     , "WIDTH": "100", "FIELD_NAME": "MALL_SELLER_ID"},
                {"HEAD_TEXT": "사업자등록번호" , "WIDTH": "100", "FIELD_NAME": "BIZ_NO"},
                /*{"HEAD_TEXT": "HS"             , "WIDTH": "110", "FIELD_NAME": "MALL_ITEM_NO","ALIGN":"left"},*/
                {"HEAD_TEXT": "품명"           , "WIDTH": "220", "FIELD_NAME": "ITEM_NM",     "ALIGN":"left"},
                {"HEAD_TEXT": "HS부호"         , "WIDTH": "110", "FIELD_NAME": "HS_CD"/*,       "FIELD_TYPE":"TXT"*/},
                {"HEAD_TEXT": "상표명"         , "WIDTH": "200", "FIELD_NAME": "BRAND_NM",    "ALIGN":"left"},
                {"HEAD_TEXT": "원산지"         , "WIDTH": "50" , "FIELD_NAME": "ORG_NAT_CD"},
                {"HEAD_TEXT": "중량"           , "WIDTH": "40" , "FIELD_NAME": "WEIGHT"},
                {"HEAD_TEXT": "중량단위"       , "WIDTH": "70" , "FIELD_NAME": "WEIGHT_UT"},
                {"HEAD_TEXT": "수량단위"       , "WIDTH": "70" , "FIELD_NAME": "QUANTY_UT"}
                /*{"HEAD_TEXT": "제조자"         , "WIDTH": "170", "FIELD_NAME": "MAKER_NM",    "ALIGN":"left"},
                {"HEAD_TEXT": "카테고리1"      , "WIDTH": "70" , "FIELD_NAME": "CATEGORY1"},
                {"HEAD_TEXT": "카테고리2"      , "WIDTH": "70" , "FIELD_NAME": "CATEGORY2"},
                {"HEAD_TEXT": "카테고리3"      , "WIDTH": "70" , "FIELD_NAME": "CATEGORY3"},
                {"HEAD_TEXT": "상세스펙"       , "WIDTH": "200", "FIELD_NAME": "SPEC_DETAIL"},
                {"HEAD_TEXT": "상품조회URL"    , "WIDTH": "200", "FIELD_NAME": "ITEM_VIEW_URL", "LINK":"fn_siteOpen"}*/
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "상품정보 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "sel.selectSellerItemList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : true,
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel", "type": "EXCEL"}
                ]
            });

            /*$('#btnSave').on('click', function () {
                fn_save();
            })*/
        });

        var fn_callback = function () {
            gridWrapper.requestToServer();
        };

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            var modDataList = gridWrapper.getUpdateData();
            if(modDataList.length == 0){
                alert($.comm.getMessage("I00000013"));// 변경된 내용이 없습니다.
                return;
            }

            $.comm.send("/sel/saveSellItem.do", modDataList, fn_callback, "상품정보 저장");
        }

        function fn_siteOpen(index){
            var data = gridWrapper.getRowData(index);

            if(!$.comm.isNull(data.ITEM_VIEW_URL)){
                window.open(data.ITEM_VIEW_URL, '_new');
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
                        <label for="MALL_ID">판매자ID</label>
                        <input id="MALL_ID" name="MALL_ID" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="MALL_SELLER_ID">몰판매자ID</label>
                        <input id="MALL_SELLER_ID" name="MALL_SELLER_ID" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="BIZ_NO">사업자등록번호</label>
                        <input id="BIZ_NO" name="BIZ_NO" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="ITEM_NM">품명</label>
                        <input id="ITEM_NM" name="ITEM_NM" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="BRAND_NM">상표명</label>
                        <input id="BRAND_NM" name="BRAND_NM" style="width:calc(100% - 300px)"/>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>


    <div class="white_frame">
        <div class="util_frame">
            <a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
            <%--<a href="#저장" class="btn white_84"  id="btnSave">저장</a>--%>
        </div>
        <div id="gridLayer" style="overflow: auto; height: 430px">
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
