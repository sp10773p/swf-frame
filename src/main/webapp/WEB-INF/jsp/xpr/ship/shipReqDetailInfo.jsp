<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    $(function() {
        
        fn_setCombo(); 	//공통콤보  조회
        
        fn_bind();		//데이터 바인드
        
        fn_controll();	//화면 controll
        
        // 목록 btn
        $('#btnList').on("click", function(e) {
//             $.comm.forward("xpr/ship/shipReqList", {});
            $.comm.pageBack();
        });

    });

    function fn_setCombo() {
//         $.comm.bindCombos.addComboInfo("RECIPIENT_COUNTRY"   		, "CUS0005", true, null, null, null, 1);	//수취인국가
//         $.comm.bindCombos.draw();
    }
    
    function fn_bind() {
        var param = {
            "qKey"    : "xpr.selectShipReqDetailInfo",
            "REGNO"  : $("#REGNO").val()
        };

        $.comm.send("/xpr/ship/selectShipReqDetailInfo.do", param,
            function(data, status) {
                $.comm.bindData(data.data);
            },
            "배송요청 상세 정보 조회"
        );
    }
    
    function fn_controll() {
        
    }
</script>
</head>
<body>
    <div class="inner-box">
        <form id="detailForm" name="detailForm" method="post">
            <input type="hidden" id="REGNO" name="REGNO" value="${REGNO}" />
            
            <div class="padding_box">
                <div class="title_frame">
                    <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
                        <div class="title_btn_inner">
                            <a href="##" class="title_frame_btn" id="btnList">목록</a>
                            <c:if test="${empty SHIP_STATUS}">
                            </c:if>
                        </div>
                    </div>
                    <p>추가 정보</p>
                    <div class="table_typeA gray">
                        <table style="table-layout: fixed;">
                            <caption class="blind">운송장 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="REGINO">운송장번호</label></td>
                                <td><span id="REGINO"></span></td>
                                <td><label for="RPT_NO">수출신고번호</label></td>
                                <td><span id="RPT_NO"></span></td>
                                <td><label for="EXPRESS_NM">특송사</label></td>
                                <td><span id="EXPRESS_NM"></span>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">주문 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">주문 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="STORE_NAME">판매 쇼핑몰</label></td>
                                <td><span id="STORE_NAME"></span></td>
                                <td><label for="STORE_ORDER_NO">주문번호</label></td>
                                <td><span id="STORE_ORDER_NO"></span></td>
                                <td><label for="ORDER_DATE">주문일자</label></td>
                                <td><span id="ORDER_DATE"></span></td>
                            </tr>
                            <tr>
                                <td><label for="PROD_DESC">상품구분</label></td>
                                <td><span id="PROD_DESC"></span></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">발송인 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">발송인 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="SENDER">발송인 이름</label></td>
                                <td><span id="SENDER"></span></td>
                                <td><label for="SENDERTELNO">발송인 전화</label></td>
                                <td><span id="SENDERTELNO"></span></td>
                                <td><label for="SENDERZIPCODE">발송인 우편번호</label></td>
                                <td><span id="SENDERZIPCODE"></span></td>
                            </tr>
                            <tr>
                                <td><label for="SENDERADDR2">발송인 주소(기본)</label></td>
                                <td colspan="5"><span id="SENDERADDR2"></span></td>
                            </tr>
                            <tr>
                                <td><label for="SENDERADDR1">발송인 주소(상세)</label></td>
                                <td colspan="5"><span id="SENDERADDR1"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">수취인 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">수취인 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="RECIPIENT_NAME">수취인 이름</label></td>
                                <td><span id="RECIPIENT_NAME"></span></td>
                                <td><label for="RECIPIENT_PHONE">수취인 전화</label></td>
                                <td><span id="RECIPIENT_PHONE"></span></td>
                                <td><label for="RECIPIENT_EMAIL">수취인 이메일</label></td>
                                <td><span id="RECIPIENT_EMAIL"></span></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ZIPCD">수취인 우편번호</label></td>
                                <td><span id="RECIPIENT_ZIPCD"></span></td>
                                <td><label for="RECIPIENT_CITY">수취인 도시</label></td>
                                <td><span id="RECIPIENT_CITY"></span></td>
                                <td><label for="RECIPIENT_STATE">수취인 주</label></td>
                                <td><span id="RECIPIENT_STATE"></span></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ADDRESS1">수취인 주소1</label></td>
                                <td colspan="5"><span id="RECIPIENT_ADDRESS1"></span></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ADDRESS2">수취인 주소2</label></td>
                                <td colspan="3"><span id="RECIPIENT_ADDRESS2"></span></td>
                                <td><label for="RECIPIENT_COUNTRY_DESC">수취인 국가</label></td>
                                <td><span id="RECIPIENT_COUNTRY_DESC"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">배송 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">배송 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="DELIVERY_OPTION">배송 서비스</label></td>
                                <td><span id="DELIVERY_OPTION"></span></td>
                                <td><label for="TOTAL_WEIGHT">총무게</label></td>
                                <td><span id="TOTAL_WEIGHT"></span></td>
                                <td><label for="WEIGHT_UNIT_DESC">무게 단위</label></td>
                                <td><span id="WEIGHT_UNIT_DESC"></span></td>
                            </tr>
                            <tr>
                                <td><label for="TOTAL_PACK_CNT">총포장수</label></td>
                                <td><span id="TOTAL_PACK_CNT"></span></td>
                                <td><label for="TOTAL_PACK_UNIT_DESC">총포장 단위</label></td>
                                <td><span id="TOTAL_PACK_UNIT_DESC"></span></td>
                                <td><label for="ITEM_QUANTITY_UNIT_DESC">수량 단위</label></td>
                                <td><span id="ITEM_QUANTITY_UNIT_DESC"></span></td>
                            </tr>
                            <tr>
                                <td><label for="BOX_WIDTH">가로</label> / <label for="BOX_LENGTH">세로</label> / <label for="BOX_HEIGHT">높이</label></td>
                                <td><span id="BOX_WIDTH"></span> / <span id="BOX_LENGTH"></span> / <span id="BOX_HEIGHT"></span></td>
                                <td><label for="BOX_DIMENSION_UNIT">크기 단위</label></td>
                                <td><span id="BOX_DIMENSION_UNIT"></span></td>
                                <td><label for="CURRENCY_UNIT_DESC">통화 단위</label></td>
                                <td><span id="CURRENCY_UNIT_DESC"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">상품 정보1</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">상품 정보1</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ITEM_ORIGIN1">원산지1</label></td>
                                <td><span id="ITEM_ORIGIN1"></span></td>
                                <td><label for="ITEM_CATEGORY1">상품 분류1</label></td>
                                <td><span id="ITEM_CATEGORY1"></span></td>
                                <td><label for="ITEM_TITLE1">상품명1</label></td>
                                <td><span id="ITEM_TITLE1"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT1">상품 무게1</label></td>
                                <td><span id="ITEM_WEIGHT1"></span></td>
                                <td><label for="ITEM_QUANTITY1">상품 수량1</label></td>
                                <td><span id="ITEM_QUANTITY1"></span></td>
                                <td><label for="ITEM_SALE_PRICE1">상품 가격1</label></td>
                                <td><span id="ITEM_SALE_PRICE1"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE1">HSCODE1</label></td>
                                <td><span id="ITEM_HSCODE1"></span></td>
                                <td><label for="ITEM_COMPOSITION1">소재1</label></td>
                                <td><span id="ITEM_COMPOSITION1"></span></td>
                                <td><label for="ITEM_SKU1">SKU1</label></td>
                                <td><span id="ITEM_SKU1"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">상품 정보2</a> <span>(내용 입력시 상품 분류2/상품명2/상품 수량2/ 상품 가격2 필수)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">상품 정보2</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ITEM_ORIGIN2">원산지2</label></td>
                                <td><span id="ITEM_ORIGIN2"></span></td>
                                <td><label for="ITEM_CATEGORY2">상품 분류2</label></td>
                                <td><span id="ITEM_CATEGORY2"></span></td>
                                <td><label for="ITEM_TITLE2">상품명2</label></td>
                                <td><span id="ITEM_TITLE2"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT2">상품 무게2</label></td>
                                <td><span id="ITEM_WEIGHT2"></span></td>
                                <td><label for="ITEM_QUANTITY2">상품 수량2</label></td>
                                <td><span id="ITEM_QUANTITY2"></span></td>
                                <td><label for="ITEM_SALE_PRICE2">상품 가격2</label></td>
                                <td><span id="ITEM_SALE_PRICE2"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE2">HSCODE2</label></td>
                                <td><span id="ITEM_HSCODE2"></span></td>
                                <td><label for="ITEM_COMPOSITION2">소재2</label></td>
                                <td><span id="ITEM_COMPOSITION2"></span></td>
                                <td><label for="ITEM_SKU2">SKU2</label></td>
                                <td><span id="ITEM_SKU2"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">상품 정보3</a> <span>(내용 입력시 상품 분류3/상품명3/상품 수량3/ 상품 가격3 필수)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">상품 정보3</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ITEM_ORIGIN3">원산지3</label></td>
                                <td><span id="ITEM_ORIGIN3"></span></td>
                                <td><label for="ITEM_CATEGORY3">상품 분류3</label></td>
                                <td><span id="ITEM_CATEGORY3"></span></td>
                                <td><label for="ITEM_TITLE3">상품명3</label></td>
                                <td><span id="ITEM_TITLE3"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT3">상품 무게3</label></td>
                                <td><span id="ITEM_WEIGHT3"></span></td>
                                <td><label for="ITEM_QUANTITY3">상품 수량3</label></td>
                                <td><span id="ITEM_QUANTITY3"></span></td>
                                <td><label for="ITEM_SALE_PRICE3">상품 가격3</label></td>
                                <td><span id="ITEM_SALE_PRICE3"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE3">HSCODE3</label></td>
                                <td><span id="ITEM_HSCODE3"></span></td>
                                <td><label for="ITEM_COMPOSITION3">소재3</label></td>
                                <td><span id="ITEM_COMPOSITION3"></span></td>
                                <td><label for="ITEM_SKU3">SKU3</label></td>
                                <td><span id="ITEM_SKU3"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">상품 정보4</a> <span>(내용 입력시 상품 분류4/상품명4/상품 수량4/ 상품 가격4 필수)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">상품 정보4</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ITEM_ORIGIN4">원산지4</label></td>
                                <td><span id="ITEM_ORIGIN4"></span></td>
                                <td><label for="ITEM_CATEGORY4">상품 분류4</label></td>
                                <td><span id="ITEM_CATEGORY4"></span></td>
                                <td><label for="ITEM_TITLE4">상품명4</label></td>
                                <td><span id="ITEM_TITLE4"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT4">상품 무게4</label></td>
                                <td><span id="ITEM_WEIGHT4"></span></td>
                                <td><label for="ITEM_QUANTITY4">상품 수량4</label></td>
                                <td><span id="ITEM_QUANTITY4"></span></td>
                                <td><label for="ITEM_SALE_PRICE4">상품 가격4</label></td>
                                <td><span id="ITEM_SALE_PRICE4"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE4">HSCODE4</label></td>
                                <td><span id="ITEM_HSCODE4"></span></td>
                                <td><label for="ITEM_COMPOSITION4">소재4</label></td>
                                <td><span id="ITEM_COMPOSITION4"></span></td>
                                <td><label for="ITEM_SKU4">SKU4</label></td>
                                <td><span id="ITEM_SKU4"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">상품 정보5</a> <span>(내용 입력시 상품 분류5/상품명5/상품 수량5/ 상품 가격5 필수)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">상품 정보5</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ITEM_ORIGIN5">원산지5</label></td>
                                <td><span id="ITEM_ORIGIN5"></span></td>
                                <td><label for="ITEM_CATEGORY5">상품 분류5</label></td>
                                <td><span id="ITEM_CATEGORY5"></span></td>
                                <td><label for="ITEM_TITLE5">상품명5</label></td>
                                <td><span id="ITEM_TITLE5"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT5">상품 무게5</label></td>
                                <td><span id="ITEM_WEIGHT5"></span></td>
                                <td><label for="ITEM_QUANTITY5">상품 수량5</label></td>
                                <td><span id="ITEM_QUANTITY5"></span></td>
                                <td><label for="ITEM_SALE_PRICE5">상품 가격5</label></td>
                                <td><span id="ITEM_SALE_PRICE5"></span></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE5">HSCODE5</label></td>
                                <td><span id="ITEM_HSCODE5"></span></td>
                                <td><label for="ITEM_COMPOSITION5">소재5</label></td>
                                <td><span id="ITEM_COMPOSITION5"></span></td>
                                <td><label for="ITEM_SKU5">SKU5</label></td>
                                <td><span id="ITEM_SKU5"></span></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
            </div>
            <!-- //padding_box -->
        </form>
    </div>
    <!-- //inner-box -->
    <%@ include file="/WEB-INF/include/include-body.jspf"%>
</body>
</html>
