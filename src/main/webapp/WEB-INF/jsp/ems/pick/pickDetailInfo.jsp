<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var globalVar = {
        "SN" : "${SN}",
        "SEQ" : "${SEQ}"
    }
    $(function() {
        
        fn_setCombo(); 	//공통콤보  조회
        
        fn_bind();		//데이터 바인드
        
        fn_controll();	//화면 controll
        
        $('#btnUpdate').on("click", function (e) { fn_commSave(); });		//저장
        
        $('#btnSearch1,#btnSearch2,#btnSearch3,#btnSearch4').on("click", function (e) { fn_searchPopup(); });	//수출이행내역(건별) 조회 팝업
        
        $("input[type=text], select").on("change", function() {
            fn_validate($(this));
        });
        
        // 물품종류
        $('#EM_EE').on("change, blur", function(e) {
            fn_controll();
        });

        // 목록 btn
        $('#btnList').on("click", function(e) {
            $.comm.forward("ems/pick/pickList", {});
//             $.comm.pageBack();
        });

        // 상세 btn
        $('#btnDetail').on("click", function(e) {
//             $.comm.forward("ems/pick/pickDetail", globalVar);
            $.comm.pageBack();
        });
        
        // toUpperCase
        $('[id^=ORIGIN]').on("keyup", function(e) {
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
        $.comm.bindCombos.addComboInfo("COUNTRYCD", "CUS0005", true, null, 3, true);	//수취인국가
        $.comm.bindCombos.draw();
    }
    
    function fn_bind() {
        var param1 = {
            "qKey"    : "ems.selectPickDetailInfo",
            "SN"  : globalVar.SN,
            "SEQ" : globalVar.SEQ
        };

        var data = $.comm.sendSync("/common/select.do", param1).data;
        $.comm.bindData(data);
        
        // 화면 오류체크
        var param2 = {
            "qKey"    : "ems.selectPickExcelErrorList",
            "SN"  : globalVar.SN,
            "SEQ" : globalVar.SEQ
        };
        var errList = $.comm.sendSync("/common/selectList.do", param2).dataList;
        for (i in errList) {
            $.comm.tooltip("danger", errList[i].ERROR_COLUMN_NAME, errList[i].ERROR_MESSAGE);
        }
    }
    
    function fn_controll() {
        if ($("#EM_EE").val() == "es") {
            $("#emsOnly").hide();
            $("#seaExpressOnly").show();
            
            $("#PREMIUMCD").val("K");
            $.comm.disabled("PREMIUMCD", true); //우편물구분
            
            $("#COUNTRYCD").val("CN");
            $.comm.disabled("COUNTRYCD", true); //수취인국가
        }
        else {
            $("#emsOnly").show();
            $("#seaExpressOnly").hide();
            $.comm.disabled("PREMIUMCD", false); //우편물구분
            $.comm.disabled("COUNTRYCD", false); //수취인국가
        }
    }
    
    // 저장
    function fn_commSave(){
        var REG_TYPE = $("#REG_TYPE").val();
        var EM_EE = $("#EM_EE").val();
        if ((REG_TYPE == "A" && EM_EE == "es") || (REG_TYPE == "B" && EM_EE != "es")) {
            alert($.comm.getMessage("W00000072")); //물품종류가 올바르지 않습니다.
            $("#EM_EE").focus();
            return;
        }
        
        fn_checkXprtNo();
        var message = "";
        var EXIST_XPRTNO1_YN = $("#EXIST_XPRTNO1_YN").val();
        var EXIST_XPRTNO2_YN = $("#EXIST_XPRTNO2_YN").val();
        var EXIST_XPRTNO3_YN = $("#EXIST_XPRTNO3_YN").val();
        var EXIST_XPRTNO4_YN = $("#EXIST_XPRTNO4_YN").val();
        if (EXIST_XPRTNO1_YN == 'N' || EXIST_XPRTNO2_YN == 'N' || EXIST_XPRTNO3_YN == 'N' || EXIST_XPRTNO4_YN == 'N') {
            message += "등록되지않은 수출신고번호가 존재합니다.\n\n";
            if (EXIST_XPRTNO1_YN == 'N') {
                message += " - 수출신고번호1 : " + $("#XPRTNO1").val() + "\n";
            }
            if (EXIST_XPRTNO2_YN == 'N') {
                message += " - 수출신고번호2 : " + $("#XPRTNO2").val() + "\n";
            }
            if (EXIST_XPRTNO3_YN == 'N') {
                message += " - 수출신고번호3 : " + $("#XPRTNO3").val() + "\n";
            }
            if (EXIST_XPRTNO4_YN == 'N') {
                message += " - 수출신고번호4 : " + $("#XPRTNO4").val() + "\n";
            }
            message += "\n그래도 저장 하시겠습니까?";
        }
        else {
            message = $.comm.getMessage("C00000002");
        }
        
        if (!confirm(message)){ // 저장 하시겠습니까?
            return;
        }
        
        $.comm.sendForm("/ems/pick/savePickDetailInfo.do", "detailForm", fn_callback, "픽업요청 수정");
    }
    
    function fn_checkXprtNo() {
        var param = {
                "qKey"    : "ems.selectXprtNoCheck",
                "XPRTNO1" : $("#XPRTNO1").val(),
                "XPRTNO2" : $("#XPRTNO2").val(),
                "XPRTNO3" : $("#XPRTNO3").val(),
                "XPRTNO4" : $("#XPRTNO4").val()
            };
        var data = $.comm.sendSync("/common/select.do", param).data;
        $.comm.bindData(data);
    }
    
    function fn_searchPopup(){
        $.comm.open("unipass", "<c:out value='https://unipass.customs.go.kr/csp/index.do' />" + "?selectedId=MYC_MNU_00000393", 1270, 900);
//         $.comm.open("unipass", "<c:out value='https://unipass.customs.go.kr/csp/myc/mainmt/MainMtCtr/menuExec.do' />" + "?selectedId=MYC_MNU_00000393", 1270, 900);
//         $.comm.open("unipass", "<c:out value='/jspView.do?jsp=ems/pick/pickFulfillmentPopup' />", 1270, 900);
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
            <input type="hidden" id="SN" name="SN" />
            <input type="hidden" id="SEQ" name="SEQ" />
            <input type="hidden" id="REG_TYPE" name="REG_TYPE" />
            
            <input type="hidden" id="EXIST_XPRTNO1_YN" /> <!-- 수출신고번호1 존재여부 -->
            <input type="hidden" id="EXIST_XPRTNO2_YN" /> <!-- 수출신고번호2 존재여부 -->
            <input type="hidden" id="EXIST_XPRTNO3_YN" /> <!-- 수출신고번호3 존재여부 -->
            <input type="hidden" id="EXIST_XPRTNO4_YN" /> <!-- 수출신고번호4 존재여부 -->
            
            <div class="padding_box">
                <div class="title_frame">
                    <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
                        <div class="title_btn_inner">
                            <a href="##" class="title_frame_btn" id="btnList">목록</a>
                            <a href="##" class="title_frame_btn" id="btnDetail">상세내역</a>
                            <c:if test="${empty PICK_STATUS || PICK_STATUS eq 'X'}">
                                <a href="##" class="title_frame_btn" id="btnUpdate">수정</a>
                            </c:if>
                        </div>
                    </div>
                    <p>배송 정보</p>
                    <div class="table_typeA gray">
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
                                <td><label for="EM_GUBUN">배송물구분</label></td>
                                <td>
                                    <select name="EM_GUBUN" id="EM_GUBUN" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="Sample">Sample</option>
                                        <option value="Gift">Gift</option>
                                        <option value="Merchandise">Merchandise</option>
                                        <option value="Document">Document</option>
                                    </select>
                                </td>
                                <td><label for="PREMIUMCD">우편물구분</label></td>
                                <td>
                                    <select name="PREMIUMCD" id="PREMIUMCD" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="E">[E] EMS</option>
                                        <option value="P">[P] EMS 프리미엄</option>
                                        <option value="K">[K] K-Packet</option>
                                    </select>
                                </td>
                                <td><label for="EM_EE">물품종류</label></td>
                                <td>
                                    <select name="EM_EE" id="EM_EE" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="em">[em] EMS 비서류</option>
                                        <option value="ee">[ee] EMS 서류</option>
                                        <option value="el">[el] Light EMS</option>
                                        <option value="re">[re] K-Packet</option>
                                        <option value="rl">[rl] K-Packek Light</option>
<!--                                         <option value="es">[es] SeaExpress</option> -->
                                    </select>
                                </td>
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
                                <td><label for="RECEIVENAME">수취인명</label></td>
                                <td><input type="text" name="RECEIVENAME" id="RECEIVENAME" <attr:length value="35" /> <attr:mandantory />></td>
                                <td>
                                    <label for="RECEIVETELNO1">수취인 전화번호1~4</label>
                                    <label for="RECEIVETELNO2" style="display:none;">수취인 전화번호2</label>
                                    <label for="RECEIVETELNO3" style="display:none;">수취인 전화번호3</label>
                                    <label for="RECEIVETELNO4" style="display:none;">수취인 전화번호4</label>
                                </td>
                                <td>
                                    <input type="text" name="RECEIVETELNO1" id="RECEIVETELNO1" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="RECEIVETELNO2" id="RECEIVETELNO2" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="RECEIVETELNO3" id="RECEIVETELNO3" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="RECEIVETELNO4" id="RECEIVETELNO4" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>
                                </td>
                                <td><label for="RECEIVETELNO">수취인 전체 전화번호</label></td>
                                <td><input type="text" name="RECEIVETELNO" id="RECEIVETELNO" <attr:length value="40" />></td>
                            </tr>
                            <tr>
                                <td><label for="RECEIVEZIPCODE">수취인 우편번호</label></td>
                                <td><input type="text" name="RECEIVEZIPCODE" id="RECEIVEZIPCODE" <attr:length value="20" /> <attr:alphaNumber /> <attr:mandantory />></td>
                                <td><label for="RECEIVEMAIL">수취인 이메일</label></td>
                                <td><input type="text" name="RECEIVEMAIL" id="RECEIVEMAIL" <attr:length value="40" /> <attr:mandantory />></td>
                                <td><label for="COUNTRYCD">수취인 국가</label></td>
                                <td><select name="COUNTRYCD" id="COUNTRYCD" class="td_input" <attr:mandantory />></select></td>
                            </tr>
                            <tr>
                                <td><label for="RECEIVEADDR3">수취인 전체주소</label></td>
                                <td colspan="5"><input type="text" name="RECEIVEADDR3" id="RECEIVEADDR3" <attr:length value="300" /> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="RECEIVEADDR2">수취인 시/군 주소</label></td>
                                <td colspan="5"><input type="text" name="RECEIVEADDR2" id="RECEIVEADDR2" <attr:length value="200" />></td>
                            </tr>
                            <tr>
                                <td><label for="RECEIVEADDR1">수취인 주/도 주소</label></td>
                                <td colspan="5"><input type="text" name="RECEIVEADDR1" id="RECEIVEADDR1" <attr:length value="140" />></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">박스포장 총중량 정보</a> <span>(실제 요금이 적용되는 무게)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">박스포장 총중량 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="TOTWEIGHT">총중량</label></td>
                                <td><input type="text" name="TOTWEIGHT" id="TOTWEIGHT" <attr:length value="7" /> <attr:numberOnly/> <attr:mandantory />></td>
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
                        <a href="#" class="btnToggle_table">세관신고서 정보</a> <span>(도착국 관세부여 자료로 활용되며, 부정확한 자료 입력시 통관지연 및 반송사유가 됨)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">세관신고서 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="CONTENTS">내용품명</label></td>
                                <td colspan="3"><input type="text" name="CONTENTS" id="CONTENTS" <attr:length value="765" /> <attr:mandantory />></td>
                                <td><label for="ITEM_NUMBER">개수</label></td>
                                <td><input type="text" name="ITEM_NUMBER" id="ITEM_NUMBER" <attr:length value="120" /> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="HS_CODE">HS CODE</label></td>
                                <td colspan="3"><input type="text" name="HS_CODE" id="HS_CODE" <attr:length value="165" />></td>
                                <td><label for="ITEM_WEIGHT">순중량</label></td>
                                <td><input type="text" name="ITEM_WEIGHT" id="ITEM_WEIGHT" <attr:length value="165" /> <attr:mandantory />></td>
                            </tr>
                            <tr>
                                <td><label for="ORIGIN">생산지</label></td>
                                <td><input type="text" name="ORIGIN" id="ORIGIN" <attr:length value="45" /> <attr:mandantory /> ></td>
                                <td><label for="MODELNO">모델명</label></td>
                                <td><input type="text" name="MODELNO" id="MODELNO" <attr:length value="1515" />></td>
                                <td><label for="ITEM_VALUE">가격</label></td>
                                <td><input type="text" name="ITEM_VALUE" id="ITEM_VALUE" <attr:length value="240" /> <attr:mandantory />></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">보험가입여부/고객주문번호 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">보험가입여부/고객주문번호 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="BOYN">보험가입여부</label></td>
                                <td>
                                    <select name="BOYN" id="BOYN" class="td_input" <attr:mandantory />>
                                        <option value=""></option>
                                        <option value="Y">[Y] 가입</option>
                                        <option value="N">[N] 미가입</option>
                                    </select>
                                </td>
                                <td><label for="BOPRC">보험금</label></td>
                                <td><input type="text" name="BOPRC" id="BOPRC" <attr:length value="15" /> <attr:numberOnly/>></td>
                                <td><label for="ORDERNO">주문번호</label></td>
                                <td><input type="text" name="ORDERNO" id="ORDERNO" <attr:length value="50" /> <attr:mandantory />></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">주문인 정보(참고용)</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">주문인 정보(참고용)</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="ORDERPRSNNM">주문인명</label></td>
                                <td><input type="text" name="ORDERPRSNNM" id="ORDERPRSNNM" <attr:length value="40" />></td>
                                <td>
                                    <label for="ORDERPRSNTELNNO">주문인 전화번호1~4</label>
                                    <label for="ORDERPRSNTELFNO" style="display:none;">주문인 전화번호2</label>
                                    <label for="ORDERPRSNTELMNO" style="display:none;">주문인 전화번호3</label>
                                    <label for="ORDERPRSNTELLNO" style="display:none;">주문인 전화번호4</label>
                                </td>
                                <td>
                                    <input type="text" name="ORDERPRSNTELNNO" id="ORDERPRSNTELNNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="ORDERPRSNTELFNO" id="ORDERPRSNTELFNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="ORDERPRSNTELMNO" id="ORDERPRSNTELMNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="ORDERPRSNTELLNO" id="ORDERPRSNTELLNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>
                                </td>
                                <td><label for="ORDERPRSNTELNO">주문인 전체 전화번호</label></td>
                                <td><input type="text" name="ORDERPRSNTELNO" id="ORDERPRSNTELNO" <attr:length value="40" />></td>
                            </tr>
                            <tr>
                                <td><label for="ORDERPRSNEMAILID">주문인 이메일</label></td>
                                <td><input type="text" name="ORDERPRSNEMAILID" id="ORDERPRSNEMAILID" <attr:length value="40" />></td>
                                <td>
                                    <label for="ORDERPRSNHTELFNO">주문인 이동통신1~3</label>
                                    <label for="ORDERPRSNHTELMNO" style="display:none;">주문인 이동통신2</label>
                                    <label for="ORDERPRSNHTELLNO" style="display:none;">주문인 이동통신3</label>
                                </td>
                                <td>
                                    <input type="text" name="ORDERPRSNHTELFNO" id="ORDERPRSNHTELFNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="ORDERPRSNHTELMNO" id="ORDERPRSNHTELMNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>-
                                    <input type="text" name="ORDERPRSNHTELLNO" id="ORDERPRSNHTELLNO" style="width: 20% !important" <attr:length value="4" /> <attr:numberOnly/>>
                                </td>
                                <td><label for="ORDERPRSNHTELNO">주문인 전체 이동통신</label></td>
                                <td><input type="text" name="ORDERPRSNHTELNO" id="ORDERPRSNHTELNO" <attr:length value="40" />></td>
                            </tr>
                            <tr>
                                <td><label for="ORDERPRSNZIPCD">주문인 우편번호</label></td>
                                <td><input type="text" name="ORDERPRSNZIPCD" id="ORDERPRSNZIPCD" <attr:length value="6" /> <attr:numberOnly/>></td>
                                <td><label for="ORDERPRSNADDR2">주문인 주소</label></td>
                                <td colspan="3"><input type="text" name="ORDERPRSNADDR2" id="ORDERPRSNADDR2" <attr:length value="140" />></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">수출우편물정보 관세청 제공 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">수출우편물정보 관세청 제공 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="EXPORTSENDPRSNNM">수출화주 성명/상호</label></td>
                                <td><input type="text" name="EXPORTSENDPRSNNM" id="EXPORTSENDPRSNNM" <attr:length value="35" />></td>
                                <td><label for="BIZREGNO">사업자번호</label></td>
                                <td><input type="text" name="BIZREGNO" id="BIZREGNO" <attr:length value="10" /> <attr:numberOnly/>></td>
                                <td><label for="ECOMMERCEYN">관세청제공여부</label></td>
                                <td>
                                    <select name="ECOMMERCEYN" id="ECOMMERCEYN" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 제공</option>
                                        <option value="N">[N] 미제공</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="EXPORTSENDPRSNADDR">수출화주 주소</label></td>
                                <td colspan="5"><input type="text" name="EXPORTSENDPRSNADDR" id="EXPORTSENDPRSNADDR" <attr:length value="105" />></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
    
                <div class="title_frame">
                    <p>
                        <a href="#" class="btnToggle_table">수출이행등록 정보</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">수출이행등록 정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="XPRTNOYN">수출이행등록여부</label></td>
                                <td>
                                    <select name="XPRTNOYN" id="XPRTNOYN" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 등록</option>
                                        <option value="N">[N] 미등록</option>
                                    </select>
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><label for="XPRTNO1">수출신고번호1</label></td>
                                <td>
                                    <input type="text" name="XPRTNO1" id="XPRTNO1" <attr:length value="14" /> style="width: 130px !important" />
                                    <a href="#" class="btn_table" style="margin-left: 0px;" id="btnSearch1">수출이행내역조회</a>
                                </td>
                                <td><label for="TOTDIVSENDYN1">전량분할발송여부1</label></td>
                                <td>
                                    <select name="TOTDIVSENDYN1" id="TOTDIVSENDYN1" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 전량</option>
                                        <option value="N">[N] 분할</option>
                                    </select>
                                </td>
                                <td><label for="WRAPCNT1">선기적 포장개수1</label></td>
                                <td><input type="text" name="WRAPCNT1" id="WRAPCNT1" <attr:length value="5" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="XPRTNO2">수출신고번호2</label></td>
                                <td>
                                    <input type="text" name="XPRTNO2" id="XPRTNO2" <attr:length value="14" /> style="width: 130px !important" />
                                    <a href="#" class="btn_table" style="margin-left: 0px;" id="btnSearch2">수출이행내역조회</a>
                                </td>
                                <td><label for="TOTDIVSENDYN2">전량분할발송여부2</label></td>
                                <td>
                                    <select name="TOTDIVSENDYN2" id="TOTDIVSENDYN2" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 전량</option>
                                        <option value="N">[N] 분할</option>
                                    </select>
                                </td>
                                <td><label for="WRAPCNT2">선기적 포장개수2</label></td>
                                <td><input type="text" name="WRAPCNT2" id="WRAPCNT2" <attr:length value="5" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="XPRTNO3">수출신고번호3</label></td>
                                <td>
                                    <input type="text" name="XPRTNO3" id="XPRTNO3" <attr:length value="14" /> style="width: 130px !important" />
                                    <a href="#" class="btn_table" style="margin-left: 0px;" id="btnSearch3">수출이행내역조회</a>
                                </td>
                                <td><label for="TOTDIVSENDYN3">전량분할발송여부3</label></td>
                                <td>
                                    <select name="TOTDIVSENDYN3" id="TOTDIVSENDYN3" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 전량</option>
                                        <option value="N">[N] 분할</option>
                                    </select>
                                </td>
                                <td><label for="WRAPCNT3">선기적 포장개수3</label></td>
                                <td><input type="text" name="WRAPCNT3" id="WRAPCNT3" <attr:length value="5" /> <attr:numberOnly/>></td>
                            </tr>
                            <tr>
                                <td><label for="XPRTNO4">수출신고번호4</label></td>
                                <td>
                                    <input type="text" name="XPRTNO4" id="XPRTNO4" <attr:length value="14" /> style="width: 130px !important" />
                                    <a href="#" class="btn_table" style="margin-left: 0px;" id="btnSearch4">수출이행내역조회</a>
                                </td>
                                <td><label for="TOTDIVSENDYN4">전량분할발송여부4</label></td>
                                <td>
                                    <select name="TOTDIVSENDYN4" id="TOTDIVSENDYN4" class="td_input">
                                        <option value=""></option>
                                        <option value="Y">[Y] 전량</option>
                                        <option value="N">[N], 분할</option>
                                    </select>
                                </td>
                                <td><label for="WRAPCNT4">선기적 포장개수4</label></td>
                                <td><input type="text" name="WRAPCNT4" id="WRAPCNT4" <attr:length value="5" /> <attr:numberOnly/>></td>
                            </tr>
                        </table>
                    </div>
                    <!-- //table_typeA 3단구조 -->
                </div>
                <!-- //title_frame -->
                
                <div class="title_frame" id="emsOnly" style="display:none;">
                    <p>
                        <a href="#" class="btnToggle_table">추천우체국코드</a>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">추천우체국코드</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="RECOMPOREGIPOCD">추천우체국기호</label></td>
                                <td><input type="text" name="RECOMPOREGIPOCD" id="RECOMPOREGIPOCD" <attr:length value="5" />></td>
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
                
                <div class="title_frame" id="seaExpressOnly" style="display:none;">
                    <p>
                        <a href="#" class="btnToggle_table">세부통관정보</a> <span>(중국세관 통관을 위한 추가입력사항입니다. 입력시 통관절차가 용이합니다.)</span>
                    </p>
                    <div class="table_typeA gray table_toggle">
                        <table style="table-layout: fixed;">
                            <caption class="blind">세부통관정보</caption>
                            <colgroup>
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                                <col width="132px" />
                                <col width="*" />
                            </colgroup>
                            <tr>
                                <td><label for="SKUSTOCKMGMTNO">SKU재고관리번호</label></td>
                                <td><input type="text" name="SKUSTOCKMGMTNO" id="SKUSTOCKMGMTNO" <attr:length value="50" />></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><label for="PAYTYPECD">결제수단</label></td>
                                <td>
                                    <select name="PAYTYPECD" id="PAYTYPECD" class="td_input">
                                        <option value=""></option>
                                        <option value="01">[01] Alipay</option>
                                        <option value="02">[02] Tenpay</option>
                                        <option value="03">[03] AMEX</option>
                                        <option value="04">[04] DSC</option>
                                        <option value="05">[05] MC</option>
                                        <option value="06">[06] VISA</option>
                                        <option value="07">[07] Paypal</option>
                                        <option value="08">[08] UnionPay</option>
                                        <option value="09">[09] WechatPay</option>
                                        <option value="10">[10] JCB</option>
                                        <option value="11">[11] DinersClub</option>
                                        <option value="12">[12] Cash</option>
                                    </select>
                                </td>
                                <td><label for="CURRUNIT">결제통화</label></td>
                                <td>
                                    <select name="CURRUNIT" id="CURRUNIT" class="td_input">
                                        <option value=""></option>
                                        <option value="KRW">KRW</option>
                                        <option value="RMB">RMB</option>
                                        <option value="USD">USD</option>
                                        <option value="EUR">EUR</option>
                                    </select>
                                </td>
                                <td><label for="PAYAPPRNO">SKU결제승인번호</label></td>
                                <td><input type="text" name="PAYAPPRNO" id="PAYAPPRNO" <attr:length value="50" />></td>
                            </tr>
                            <tr>
                                <td><label for="DUTYPAYPRSNCD">관세납부자</label></td>
                                <td><input type="text" name="DUTYPAYPRSNCD" id="DUTYPAYPRSNCD" <attr:length value="1" />></td>
                                <td><label for="DUTYPAYAMT">납부관세액</label></td>
                                <td><input type="text" name="DUTYPAYAMT" id="DUTYPAYAMT" <attr:length value="11" />></td>
                                <td><label for="DUTYPAYCURR">관세납부통화</label></td>
                                <td>
                                    <select name="DUTYPAYCURR" id="DUTYPAYCURR" class="td_input">
                                        <option value=""></option>
                                        <option value="KRW">KRW</option>
                                        <option value="RMB">RMB</option>
                                        <option value="USD">USD</option>
                                        <option value="EUR">EUR</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><label for="BOXLENGTH">우편물가로길이</label></td>
                                <td><input type="text" name="BOXLENGTH" id="BOXLENGTH" <attr:length value="7" />></td>
                                <td><label for="BOXWIDTH">우편물세로길이</label></td>
                                <td><input type="text" name="BOXWIDTH" id="BOXWIDTH" <attr:length value="7" />></td>
                                <td><label for="BOXHEIGHT">우편물높이</label></td>
                                <td><input type="text" name="BOXHEIGHT" id="BOXHEIGHT" <attr:length value="7" />></td>
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
