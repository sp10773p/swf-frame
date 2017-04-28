<%--
    Class Name : commSubDetail.jsp
    Description : 공통코드 디테일 상세
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

        $(function (){
            var fn_callback = function (data) {
                if(data.code.indexOf('I') == 0){
                    $('#btnList').click();
                }
            };

            $('#btnSave').on("click", function (e) {
                if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                    return;
                }

                $.comm.sendForm("/comm/saveDetailCode.do", "detailForm", fn_callback, "상세코드 저장");
            });

            $('#btnDel').on("click", function (e) {
                if(!confirm($.comm.getMessage("C00000001"))){ // 삭제 하시겠습니까?
                    return;
                }
                $.comm.sendForm("/comm/deleteDetailCode.do", "detailForm", fn_callback, "상세코드 삭제");
            });

            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });

            var refColName = '${REF_COL}';
            if(!$.comm.isNull(refColName)){
                var colArr = refColName.split(",");
                for(var i=0; i<colArr.length; i++){
                    $("label[for='USER_REF"+(i+1)+"']").html(colArr[i]);
                }
            }

            //수정모드일때
            if($('#SAVE_MODE').val() == "U"){
                $.comm.disabled(["CLASS_ID", "CODE"], true);// 클래스, 코드 비활성화
                $.comm.display("btnDel", true); // 삭제버튼, 안보이게

                var param = {
                    "qKey"    : "comm.getCommcodeDetail",
                    "CLASS_ID": "${CLASS_ID}",
                    "CODE"    : "${CODE}"
                };

                $.comm.send("/common/select.do", param,
                    function(data, status){
                        $.comm.bindData(data.data);
                    },
                    "상세코드 상세조회"
                );

            }else if($('#SAVE_MODE').val() == "I"){
                $.comm.disabled("CLASS_ID", true);// 클래스비활성화
                $.comm.display("btnDel", false); // 삭제버튼, 안보이게

                $('#CLASS_ID').val("${CLASS_ID}");
            }
        });

    </script>
</head>
<body>
<div id="content_body">
    <form id="detailForm" name="detailForm" method="post">
        <input type="hidden" name="SAVE_MODE" id="SAVE_MODE" value="${SAVE_MODE}">
        <div class="white_frame">
            <div class="util_frame">
                <a href="#목록" class="btn blue_84" id="btnList">목록</a>
                <a href="#삭제" class="btn blue_84" id="btnDel">삭제</a>
                <a href="#저장" class="btn blue_84" id="btnSave">저장</a>
            </div>
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <caption class="blind">디테일코드 상세정보</caption>
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                        <col width="145px" />
                        <col width="*" />
                        <col width="145px" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="CLASS_ID">클래스</label></td>
                        <td><input type="text" name="CLASS_ID" id="CLASS_ID" <attr:mandantory/> <attr:length value="50"/>></td>
                        <td><label for="CODE">코드</label></td>
                        <td><input type="text" name="CODE" id="CODE" <attr:mandantory/> <attr:length value="30" />></td>
                        <td><label for="CODE_NM">설명</label></td>
                        <td><input type="text" name="CODE_NM" id="CODE_NM" <attr:length value="300" />></td>
                    </tr>
                    <tr>
                        <td><label for="CODE_SHT">약어</label></td>
                        <td><input type="text" name="CODE_SHT" id="CODE_SHT" <attr:length value="50" />></td>
                        <td><label for="SEQ">순서</label></td>
                        <td><input type="text" name="SEQ" id="SEQ" <attr:length value="4" />></td>
                        <td><label for="USE_CHK">사용여부</label></td>
                        <td>
                            <select id="USE_CHK" name="USE_CHK" class="select">
                                <option value="Y" selected>사용</option>
                                <option value="N">미사용</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label for="USER_REF1">참조1</label></td>
                        <td><input type="text" name="USER_REF1" id="USER_REF1" <attr:length value="100" />></td>
                        <td><label for="USER_REF2">참조2</label></td>
                        <td><input type="text" name="USER_REF2" id="USER_REF2" <attr:length value="100" />></td>
                        <td><label for="USER_REF3">참조3</label></td>
                        <td><input type="text" name="USER_REF3" id="USER_REF3" <attr:length value="100" />></td>
                    </tr>
                    <tr>
                        <td><label for="USER_REF4">참조4</label></td>
                        <td><input type="text" name="USER_REF4" id="USER_REF4" <attr:length value="100" />></td>
                        <td><label for="USER_REF5">참조5</label></td>
                        <td><input type="text" name="USER_REF5" id="USER_REF5" <attr:length value="100" />></td>
                        <td><label for="USER_REF6">참조6</label></td>
                        <td><input type="text" name="USER_REF6" id="USER_REF6" <attr:length value="100" />></td>
                    </tr>
                    <tr>
                        <td><label for="USER_REF7">참조7</label></td>
                        <td><input type="text" name="USER_REF7" id="USER_REF7" <attr:length value="100" />></td>
                        <td><label for="USER_REF8">참조8</label></td>
                        <td><input type="text" name="USER_REF8" id="USER_REF8" <attr:length value="100" />></td>
                        <td><label for="USER_REF9">참조9</label></td>
                        <td><input type="text" name="USER_REF9" id="USER_REF9" <attr:length value="100" />></td>
                    </tr>
                    <tr>
                        <td><label for="USER_REF10">참조10</label></td>
                        <td><input type="text" name="USER_REF10" id="USER_REF10" <attr:length value="100" />></td>
                        <td><label for="REG_ID">등록자</label></td>
                        <td><input type="text" name="REG_ID" id="REG_ID" readonly></td>
                        <td><label for="REG_DTM">등록일자</label></td>
                        <td><input type="text" name="REG_DTM" id="REG_DTM" readonly></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td><label for="MOD_ID">수정자</label></td>
                        <td><input type="text" name="MOD_ID" id="MOD_ID" readonly></td>
                        <td><label for="MOD_DTM">수정일자</label></td>
                        <td><input type="text" name="MOD_DTM" id="MOD_DTM" readonly></td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
