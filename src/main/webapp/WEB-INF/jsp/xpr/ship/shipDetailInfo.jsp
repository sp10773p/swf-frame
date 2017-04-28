<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
var data;
    $(function() {
        
        fn_setCombo(); 	//공통콤보  조회
        
        fn_bind();		//데이터 바인드
        
        fn_controll();	//화면 controll
        
        $('#btnUpdate').on("click", function (e) { fn_commSave(); }); //저장
        
        $("input[type=text], select").on("change", function() {
            fn_validate($(this));
        });
        
        // 목록 btn
        $('#btnList').on("click", function(e) {
            $.comm.forward("xpr/ship/shipList", data);
        });

        // 상세 btn
        $('#btnDetail').on("click", function(e) {
//             $.comm.forward("xpr/ship/shipDetail", globalVar);
            $.comm.pageBack();
        });
        
        // toUpperCase
        $('[id=CURRENCY_UNIT],[id^=ITEM_ORIGIN]').on("change", function(e) {
            $(this).val($(this).val().toUpperCase());
        });
        
    });
    
 // 필수값 체크
    function fn_validate(obj) {
        var isOk = true;
        
        // 필수체크
        if (isOk && obj.attr('mandantory') !== undefined) {
            isOk = obj.val().length > 0;
            fn_setBoderHighlight(obj, isOk);
        }
        
        // length 체크 (length, [minlength,maxlength])
        if (isOk && obj.attr('length') !== undefined) {
            var len = obj.attr('length').split(",");
            if (len.length == 0) {
                isOk = false;
                fn_setBoderHighlight(obj, isOk);
            }
            if (len.length == 1) {
                isOk = obj.val().length <= len;
                fn_setBoderHighlight(obj, isOk);
            }
            if (len.length == 2) {
                var minlength = len[0];
                isOk = obj.val().length >= minlength;
                fn_setBoderHighlight(obj, isOk);
                
                if (isOk) {
                    var maxlength = len[1];
                    isOk = obj.val().length <= maxlength;
                    fn_setBoderHighlight(obj, isOk);
                }
            }
        }
    }
    
    function fn_setBoderHighlight(obj, isOk) {
        var bool = (isOk) ? true : false;
        var chosenObj = obj.next("#"+obj.attr("id")+"_chosen").find(".chosen-single");
        if (bool) { // OFF
            obj.css("border-color", "#c5c5c5");
            obj.css("box-shadow", "none");
            obj.addClass("js-mytooltip-ignore");
            obj.myTooltip('update');
            
            chosenObj.css("border-color", "#c5c5c5");
            chosenObj.css("box-shadow", "none");
            chosenObj.addClass("js-mytooltip-ignore");
            chosenObj.myTooltip('update');
        }
        else { // ON
            obj.css("border-color", "#EA2803");
            obj.css("box-shadow", "0 0 10px #EA2803");
            obj.removeClass("js-mytooltip-ignore");
            obj.myTooltip('update');
            
            chosenObj.css("border-color", "#EA2803");
            chosenObj.css("box-shadow", "0 0 10px #EA2803");
            chosenObj.removeClass("js-mytooltip-ignore");
            chosenObj.myTooltip('update');
        }
    }

    function fn_setCombo() {
        $.comm.bindCombos.addComboInfo("RECIPIENT_COUNTRY"	, "CUS0005", true, null, 3, true);	//수취인국가
        $.comm.bindCombos.addComboInfo("WEIGHT_UNIT"		, "CUS0006", true, null, 3, true);	//중량단위
        $.comm.bindCombos.addComboInfo("ITEM_QUANTITY_UNIT"	, "CUS0006", true, null, 3, true);	//수량단위
        $.comm.bindCombos.addComboInfo("CURRENCY_UNIT"		, "CUS0042", true, null, 3, true);	//통화단위
        $.comm.bindCombos.addComboInfo("TOTAL_PACK_UNIT"	, "CUS0043", true, null, 3, true);	//포장단위
        $.comm.bindCombos.draw();
    }
    
    function fn_bind() {
        var param1 = {
            "qKey" : "xpr.selectShipDetailInfo",
            "SN"   : $("#SN").val(),
            "SEQ"  : $("#SEQ").val()
        };

        data = $.comm.sendSync("/common/select.do", param1).data;
        $.comm.bindData(data);
        
        // 화면 오류체크
        var param2 = {
            "qKey" : "xpr.selectShipExcelErrorList",
            "SN"   : $("#SN").val(),
            "SEQ"  : $("#SEQ").val()
        };
        var errList = $.comm.sendSync("/common/selectList.do", param2).dataList;
        for (i in errList) {
            $.comm.tooltip("danger", errList[i].ERROR_COLUMN_NAME, errList[i].ERROR_MESSAGE);
        }
    }
    
    function fn_controll() {
//         $.comm.readonly("RPT_NO", true);
//         $.comm.disabled("RPT_NO", true);

//         $("form#detailForm :input").each(function(){
//             $.comm.disabled($(this).attr("id"), true);
//         });
    }
    
    // 저장
    function fn_commSave(){
        
//         fn_checkXprtNo();
//         var message = "";
//         var EXIST_RPT_NO_YN = $("#EXIST_RPT_NO_YN").val();
//         if (EXIST_RPT_NO_YN == 'N') {
//             message += "등록되지않은 수출신고번호가 존재합니다.\n\n";
//             message += " - 수출신고번호 : " + $("#RPT_NO").val() + "\n";
//             message += "\n그래도 저장 하시겠습니까?";
//         }
//         else {
//             message = $.comm.getMessage("C00000002");
//         }
        
//         if (!confirm(message)){ // 저장 하시겠습니까?
//             return;
//         }
        
        if (!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
            return;
        }
        
        $.comm.sendForm("/xpr/ship/saveShipDetailInfo.do", "detailForm", fn_callback, "배송요청 수정");
    }
    
    function fn_checkXprtNo() {
        var param = {
                "qKey"    : "xpr.selectXprtNoCheck",
                "RPT_NO"  : $("#RPT_NO").val()
            };
        var data = $.comm.sendSync("/common/select.do", param).data;
        $.comm.bindData(data);
    }
    
    function fn_callback() {
        $.comm.pageBack();
    }
    
    function getSafeString(val) {
        return (val === undefined) ? "" : val;
    }
</script>
</head>
<body>
    <div class="inner-box">
        <form id="detailForm" name="detailForm" method="post">
            <input type="hidden" id="SN" name="SN" value="${SN}" />
            <input type="hidden" id="SEQ" name="SEQ" value="${SEQ}" />
            
            <input type="hidden" id="EXIST_RPT_NO_YN" /> <!-- 수출신고번호 존재여부 -->
            
            <div class="padding_box">
                <div class="title_frame">
                    <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
                        <div class="title_btn_inner">
                            <a href="##" class="title_frame_btn" id="btnList">목록</a>
                            <a href="##" class="title_frame_btn" id="btnDetail">상세내역</a>
                            <c:if test="${empty SHIP_STATUS}">
                                <a href="##" class="title_frame_btn" id="btnUpdate">수정</a>
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
                                <td><input type="text" name="REGINO" id="REGINO" <attr:length value="13" /> <attr:mandantory />></td>
                                <td><label for="RPT_NO">수출신고번호</label></td>
                                <td><input type="text" name="RPT_NO" id="RPT_NO" <attr:length value="14" />></td>
                                <td><label for="EXPRESS_NM">특송사</label></td>
                                <td><span id="EXPRESS_NM"></span>
<!--                                 <td><label for="BLNO">B/L No.</label></td> -->
<!--                                 <td><input type="text" name="BLNO" id="BLNO" <attr:length value="20" />></td> -->
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
                                <td>
                                    <select name="STORE_NAME" id="STORE_NAME" class="td_input">
                                        <option value=""></option>
                                        <option value="Other">Other</option>
                                        <option value="eBay">eBay</option>
                                        <option value="Amazon">Amazon</option>
                                        <option value="Taobao">Taobao</option>
                                        <option value="Lazada">Lazada</option>
                                        <option value="QOO10">QOO10</option>
                                        <option value="Rakuten">Rakuten</option>
                                        <option value="Etsy">Etsy</option>
                                    </select>
                                </td>
                                <td><label for="STORE_ORDER_NO">주문번호</label></td>
                                <td><input type="text" name="STORE_ORDER_NO" id="STORE_ORDER_NO" <attr:length value="50" />></td>
                                <td><label for="ORDER_DATE">주문일자</label></td>
                                <td><!--<input type="text" name="ORDER_DATE" id="ORDER_DATE" <attr:length value="8" /> <attr:numberOnly/>>-->
                                    <div class="search_date">
                                        <input type="text" id="ORDER_DATE" name="ORDER_DATE" <attr:datefield /> >
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="PROD_DESC">상품구분</label></td>
                                <td>
                                    <select name="PROD_DESC" id="PROD_DESC" class="td_input">
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
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
                                <td><input type="text" name="RECIPIENT_NAME" id="RECIPIENT_NAME" <attr:length value="35" /> <attr:mandantory />></td>
                                <td><label for="RECIPIENT_PHONE">수취인 전화</label></td>
                                <td><input type="text" name="RECIPIENT_PHONE" id="RECIPIENT_PHONE" <attr:length value="20" /> <attr:numberOnly/>></td>
                                <td><label for="RECIPIENT_EMAIL">수취인 이메일</label></td>
                                <td><input type="text" name="RECIPIENT_EMAIL" id="RECIPIENT_EMAIL" <attr:length value="40" />></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ZIPCD">수취인 우편번호</label></td>
                                <td><input type="text" name="RECIPIENT_ZIPCD" id="RECIPIENT_ZIPCD" <attr:length value="10" /> <attr:numberOnly/> <attr:mandantory />></td>
                                <td><label for="RECIPIENT_CITY">수취인 도시</label></td>
                                <td><input type="text" name="RECIPIENT_CITY" id="RECIPIENT_CITY" <attr:length value="35" /> <attr:mandantory />></td>
                                <td><label for="RECIPIENT_STATE">수취인 주</label></td>
                                <td><input type="text" name="RECIPIENT_STATE" id="RECIPIENT_STATE" <attr:length value="35" />></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ADDRESS1">수취인 전체주소</label></td>
                                <td colspan="5"><input type="text" name="RECIPIENT_ADDRESS1" id="RECIPIENT_ADDRESS1" <attr:length value="98" /> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="RECIPIENT_ADDRESS2">수취인 상세주소</label></td>
                                <td colspan="3"><input type="text" name="RECIPIENT_ADDRESS2" id="RECIPIENT_ADDRESS2" <attr:length value="98" />></td>
                                <td><label for="RECIPIENT_COUNTRY">수취인 국가</label></td>
                                <td>
                                    <select name="RECIPIENT_COUNTRY" id="RECIPIENT_COUNTRY" class="td_input" <attr:mandantory />></select>
                                </td>
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
                                <td>
                                    <select name="DELIVERY_OPTION" id="DELIVERY_OPTION" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="Gift">Gift</option>
                                        <option value="Documents">Documents</option>
                                        <option value="Commercial Sample">Commercial Sample</option>
                                        <option value="Returned Goods">Returned Goods</option>
                                        <option value="Merchandise">Merchandise</option>
                                    </select>
                                </td>
                                <td><label for="TOTAL_WEIGHT">총무게</label></td>
                                <td><input type="text" name="TOTAL_WEIGHT" id="TOTAL_WEIGHT" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/> <attr:mandantory />></td>
                                <td><label for="WEIGHT_UNIT">무게 단위</label></td>
                                <td><select name="WEIGHT_UNIT" id="WEIGHT_UNIT" class="td_input" <attr:mandantory />></select></td>
                            </tr>
                            <tr>
                                <td><label for="TOTAL_PACK_CNT">총포장수</label></td>
                                <td><input type="text" name="TOTAL_PACK_CNT" id="TOTAL_PACK_CNT" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/> <attr:mandantory />></td>
                                <td><label for="TOTAL_PACK_UNIT">총포장 단위</label></td>
                                <td><select name="TOTAL_PACK_UNIT" id="TOTAL_PACK_UNIT" class="td_input" <attr:mandantory />></select></td>
                                <td><label for="ITEM_QUANTITY_UNIT">수량 단위</label></td>
                                <td><select name="ITEM_QUANTITY_UNIT" id="ITEM_QUANTITY_UNIT" class="td_input" <attr:mandantory />></select></td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="BOX_WIDTH">가로</label> / <label for="BOX_LENGTH">세로</label> / <label for="BOX_HEIGHT">높이</label>
                                </td>
                                <td>
                                    <input type="text" name="BOX_WIDTH" id="BOX_WIDTH" style="text-align:right; width:50px;" <attr:length value="7" /> <attr:numberOnly/> <attr:decimalFormat value="6,2" /> <attr:mandantory />>
                                    <input type="text" name="BOX_LENGTH" id="BOX_LENGTH" style="text-align:right; width:50px;" <attr:length value="7" /> <attr:numberOnly/> <attr:decimalFormat value="6,2" /> <attr:mandantory />>
                                    <input type="text" name="BOX_HEIGHT" id="BOX_HEIGHT" class="td_input inputHeight" style="text-align:right; width:50px;" <attr:length value="7" /> <attr:numberOnly/> <attr:decimalFormat value="6,2" /> <attr:mandantory />>
                                </td>
                                <td><label for="BOX_DIMENSION_UNIT">크기 단위</label></td>
                                <td>
                                    <select name="BOX_DIMENSION_UNIT" id="BOX_DIMENSION_UNIT" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="cm">cm</option>
                                        <option value="inch">inch</option>
                                    </select>
                                </td>
                                <td><label for="CURRENCY_UNIT">통화 단위</label></td>
                                <td><select name="CURRENCY_UNIT" id="CURRENCY_UNIT" class="td_input" <attr:mandantory />></select></td>
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
                                <td><input type="text" name="ITEM_ORIGIN1" id="ITEM_ORIGIN1" <attr:length value="2" /> <attr:alphaOnly/>></td>
                                <td><label for="ITEM_CATEGORY1">상품 분류1</label></td>
                                <td>
                                    <select name="ITEM_CATEGORY1" id="ITEM_CATEGORY1" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td><label for="ITEM_TITLE1">상품명1</label></td>
                                <td><input type="text" name="ITEM_TITLE1" id="ITEM_TITLE1" <attr:length value="50" /> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT1">상품 무게1</label></td>
                                <td><input type="text" name="ITEM_WEIGHT1" id="ITEM_WEIGHT1" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_QUANTITY1">상품 수량1</label></td>
                                <td><input type="text" name="ITEM_QUANTITY1" id="ITEM_QUANTITY1" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/> <attr:mandantory />></td>
                                <td><label for="ITEM_SALE_PRICE1">상품 가격1</label></td>
                                <td><input type="text" name="ITEM_SALE_PRICE1" id="ITEM_SALE_PRICE1" style="text-align:right;" <attr:length value="12" /> <attr:numberOnly/> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE1">HSCODE1</label></td>
                                <td><input type="text" name="ITEM_HSCODE1" id="ITEM_HSCODE1" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_COMPOSITION1">소재1</label></td>
                                <td><input type="text" name="ITEM_COMPOSITION1" id="ITEM_COMPOSITION1" <attr:length value="100" />></td>
                                <td><label for="ITEM_SKU1">SKU1</label></td>
                                <td><input type="text" name="ITEM_SKU1" id="ITEM_SKU1" <attr:length value="50" />></td>
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
                                <td><input type="text" name="ITEM_ORIGIN2" id="ITEM_ORIGIN2" <attr:length value="2" /> <attr:alphaOnly/>></td>
                                <td><label for="ITEM_CATEGORY2">상품 분류2</label></td>
                                <td>
                                    <select name="ITEM_CATEGORY2" id="ITEM_CATEGORY2" class="td_input">
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td><label for="ITEM_TITLE2">상품명2</label></td>
                                <td><input type="text" name="ITEM_TITLE2" id="ITEM_TITLE2" <attr:length value="50" />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT2">상품 무게2</label></td>
                                <td><input type="text" name="ITEM_WEIGHT2" id="ITEM_WEIGHT2" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_QUANTITY2">상품 수량2</label></td>
                                <td><input type="text" name="ITEM_QUANTITY2" id="ITEM_QUANTITY2" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_SALE_PRICE2">상품 가격2</label></td>
                                <td><input type="text" name="ITEM_SALE_PRICE2" id="ITEM_SALE_PRICE2" style="text-align:right;" <attr:length value="12" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE2">HSCODE2</label></td>
                                <td><input type="text" name="ITEM_HSCODE2" id="ITEM_HSCODE2" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_COMPOSITION2">소재2</label></td>
                                <td><input type="text" name="ITEM_COMPOSITION2" id="ITEM_COMPOSITION2" <attr:length value="100" />></td>
                                <td><label for="ITEM_SKU2">SKU2</label></td>
                                <td><input type="text" name="ITEM_SKU2" id="ITEM_SKU2" <attr:length value="50" />></td>
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
                                <td><input type="text" name="ITEM_ORIGIN3" id="ITEM_ORIGIN3" <attr:length value="2" /> <attr:alphaOnly/>></td>
                                <td><label for="ITEM_CATEGORY3">상품 분류3</label></td>
                                <td>
                                    <select name="ITEM_CATEGORY3" id="ITEM_CATEGORY3" class="td_input">
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td><label for="ITEM_TITLE3">상품명3</label></td>
                                <td><input type="text" name="ITEM_TITLE3" id="ITEM_TITLE3" <attr:length value="50" />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT3">상품 무게3</label></td>
                                <td><input type="text" name="ITEM_WEIGHT3" id="ITEM_WEIGHT3" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_QUANTITY3">상품 수량3</label></td>
                                <td><input type="text" name="ITEM_QUANTITY3" id="ITEM_QUANTITY3" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_SALE_PRICE3">상품 가격3</label></td>
                                <td><input type="text" name="ITEM_SALE_PRICE3" id="ITEM_SALE_PRICE3" style="text-align:right;" <attr:length value="12" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE3">HSCODE3</label></td>
                                <td><input type="text" name="ITEM_HSCODE3" id="ITEM_HSCODE3" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_COMPOSITION3">소재3</label></td>
                                <td><input type="text" name="ITEM_COMPOSITION3" id="ITEM_COMPOSITION3" <attr:length value="100" />></td>
                                <td><label for="ITEM_SKU3">SKU3</label></td>
                                <td><input type="text" name="ITEM_SKU3" id="ITEM_SKU3" <attr:length value="50" />></td>
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
                                <td><input type="text" name="ITEM_ORIGIN4" id="ITEM_ORIGIN4" <attr:length value="2" /> <attr:alphaOnly/>></td>
                                <td><label for="ITEM_CATEGORY4">상품 분류4</label></td>
                                <td>
                                    <select name="ITEM_CATEGORY4" id="ITEM_CATEGORY4" class="td_input">
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td><label for="ITEM_TITLE4">상품명4</label></td>
                                <td><input type="text" name="ITEM_TITLE4" id="ITEM_TITLE4" <attr:length value="50" />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT4">상품 무게4</label></td>
                                <td><input type="text" name="ITEM_WEIGHT4" id="ITEM_WEIGHT4" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_QUANTITY4">상품 수량4</label></td>
                                <td><input type="text" name="ITEM_QUANTITY4" id="ITEM_QUANTITY4" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_SALE_PRICE4">상품 가격4</label></td>
                                <td><input type="text" name="ITEM_SALE_PRICE4" id="ITEM_SALE_PRICE4" style="text-align:right;" <attr:length value="12" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE4">HSCODE4</label></td>
                                <td><input type="text" name="ITEM_HSCODE4" id="ITEM_HSCODE4" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_COMPOSITION4">소재4</label></td>
                                <td><input type="text" name="ITEM_COMPOSITION4" id="ITEM_COMPOSITION4" <attr:length value="100" />></td>
                                <td><label for="ITEM_SKU4">SKU4</label></td>
                                <td><input type="text" name="ITEM_SKU4" id="ITEM_SKU4" <attr:length value="50" />></td>
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
                                <td><input type="text" name="ITEM_ORIGIN5" id="ITEM_ORIGIN5" <attr:length value="2" /> <attr:alphaOnly/>></td>
                                <td><label for="ITEM_CATEGORY5">상품 분류5</label></td>
                                <td>
                                    <select name="ITEM_CATEGORY5" id="ITEM_CATEGORY5" class="td_input">
                                        <option value=""></option>
                                        <option value="Cosmetics">Cosmetics</option>
                                        <option value="Perfume">Perfume</option>
                                        <option value="Clothing (Woven)">Clothing (Woven)</option>
                                        <option value="Clothing (Knit)">Clothing (Knit)</option>
                                        <option value="Accessories">Accessories</option>
                                        <option value="Bags">Bags</option>
                                        <option value="Shoes">Shoes</option>
                                        <option value="Watches">Watches</option>
                                        <option value="Jewelry">Jewelry</option>
                                        <option value="Cell phones">Cell phones</option>
                                        <option value="Cameras">Cameras</option>
                                        <option value="Small Electronics">Small Electronics</option>
                                        <option value="Foods">Foods</option>
                                        <option value="Medical Supplies">Medical Supplies</option>
                                        <option value="Toys">Toys</option>
                                        <option value="Media (CD/DVD)">Media (CD/DVD)</option>
                                        <option value="Books">Books</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td><label for="ITEM_TITLE5">상품명5</label></td>
                                <td><input type="text" name="ITEM_TITLE5" id="ITEM_TITLE5" <attr:length value="50" />></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_WEIGHT5">상품 무게5</label></td>
                                <td><input type="text" name="ITEM_WEIGHT5" id="ITEM_WEIGHT5" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_QUANTITY5">상품 수량5</label></td>
                                <td><input type="text" name="ITEM_QUANTITY5" id="ITEM_QUANTITY5" style="text-align:right;" <attr:length value="7" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_SALE_PRICE5">상품 가격5</label></td>
                                <td><input type="text" name="ITEM_SALE_PRICE5" id="ITEM_SALE_PRICE5" style="text-align:right;" <attr:length value="12" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="ITEM_HSCODE5">HSCODE5</label></td>
                                <td><input type="text" name="ITEM_HSCODE5" id="ITEM_HSCODE5" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ITEM_COMPOSITION5">소재5</label></td>
                                <td><input type="text" name="ITEM_COMPOSITION5" id="ITEM_COMPOSITION5" <attr:length value="100" />></td>
                                <td><label for="ITEM_SKU5">SKU5</label></td>
                                <td><input type="text" name="ITEM_SKU5" id="ITEM_SKU5" <attr:length value="50" />></td>
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
