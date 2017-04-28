<%--
    Class Name : commDetail.jsp
    Description : 공통코드 상세
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

        var gridDetail, headersDetail;
        $(function (){
            headersDetail = [
                {"HEAD_TEXT": "클래스"  , "WIDTH": "180", "FIELD_NAME": "CLASS_ID"},
                {"HEAD_TEXT": "코드"    , "WIDTH": "100", "FIELD_NAME": "CODE"},
                {"HEAD_TEXT": "설명"    , "WIDTH": "260", "FIELD_NAME": "CODE_NM"},
                {"HEAD_TEXT": "약어"    , "WIDTH": "70" , "FIELD_NAME": "CODE_SHT"},
                {"HEAD_TEXT": "순서"    , "WIDTH": "50" , "FIELD_NAME": "SEQ"},
                {"HEAD_TEXT": "사용여부", "WIDTH": "70" , "FIELD_NAME": "USE_CHK"}
            ];

            gridDetail = new GridWrapper({
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "code.getCommcodeDetailList",
                "headers"      : headersDetail,
                "countId"      : "totDetailCnt",
                "check"        : true,
                "scrollPaging" : true,
                "firstLoad"    : false
            });

            var fn_callback = function (data) {
                if(data.code.indexOf('I') == 0){
                    $('#btnList').click();
                }
            };

            $('#btnSave').on("click", function (e) {
                if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                    return;
                }

                $.comm.sendForm("/comm/saveMasterCode.do", "detailForm", fn_callback, "코드저장");
            });

            $('#btnDel').on("click", function (e) {
                if(!confirm($.comm.getMessage("C00000001"))){ // 삭제 하시겠습니까?
                    return;
                }
                $.comm.sendForm("/comm/deleteMasterCode.do", "detailForm", fn_callback, "코드삭제");
            });

            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });

            // 수정모드일때
            if($('#SAVE_MODE').val() == "U"){
                $.comm.disabled("CLASS_ID", true); // 클래스 비활성화
                //$.comm.display(["btnDel", "div_detail"], true); // 삭제버튼 활성화
                $.comm.display("btnDel", true); // 삭제버튼 활성화

                var param = {
                    "qKey"    : "comm.getCommcodeMaster",
                    "CLASS_ID": "${CLASS_ID}"
                };

                var selectCallback = function(data, status){
                    $.comm.bindData(data.data);

                    // 디테일 조회
                    /*var h = new Array();
                    h = $.merge(h , headersDetail);
                    // Detail Header Setting
                    for(var i=1; i<=10; i++){
                        if(!$.comm.isNull($("#USER_REF" + i).val())){
                            console.log(">>"+$("#USER_REF" + i).val());
                            h[h.length] = {"HEAD_TEXT": $("#USER_REF" + i).val(), "WIDTH": "90" , "FIELD_NAME": "USER_REF"+1};
                        }
                    }

                    h[h.length]= {"HEAD_TEXT": "등록자"  , "WIDTH": "80" , "FIELD_NAME": "REG_ID"};
                    h[h.length]= {"HEAD_TEXT": "등록일자", "WIDTH": "80" , "FIELD_NAME": "REG_DTM"};
                    h[h.length]= {"HEAD_TEXT": "수정자"  , "WIDTH": "80" , "FIELD_NAME": "MOD_ID"};
                    h[h.length]= {"HEAD_TEXT": "수정일자", "WIDTH": "80" , "FIELD_NAME": "MOD_DTM"};

                    gridDetail.setParams({"CLASS_ID":"<%--${CLASS_ID}--%>"});
                    gridDetail.setHeaders(h);
                    gridDetail.drawGrid();
                    gridDetail.requestToServer();*/
                };

                $.comm.send("/common/select.do", param, selectCallback, "마스터코드 상세조회");

            }else if($('#SAVE_MODE').val() == "I"){
                $.comm.display(["btnDel", "div_detail"], false); // 삭제버튼, 디테일리스트 안보이게
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
                <caption class="blind">마스터코드 상세정보</caption>
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
                    <td><label for="CLASS_NM">설명</label></td>
                    <td><input type="text" name="CLASS_NM" id="CLASS_NM" <attr:length value="50"/>></td>
                    <td><label for="USE_CHK">사용여부</label></td>
                    <td>
                        <select id="USE_CHK" name="USE_CHK">
                            <option value="Y" selected>사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><label for="USER_REF1">참조1</label></td>
                    <td><input type="text" name="USER_REF1" id="USER_REF1" <attr:length value="100"/>></td>
                    <td><label for="USER_REF2">참조2</label></td>
                    <td><input type="text" name="USER_REF2" id="USER_REF2" <attr:length value="100"/>></td>
                    <td><label for="USER_REF3">참조3</label></td>
                    <td><input type="text" name="USER_REF3" id="USER_REF3" <attr:length value="100"/>></td>
                </tr>
                <tr>
                    <td><label for="USER_REF4">참조4</label></td>
                    <td><input type="text" name="USER_REF4" id="USER_REF4" <attr:length value="100"/>></td>
                    <td><label for="USER_REF5">참조5</label></td>
                    <td colspan="3"><input type="text" name="USER_REF5" id="USER_REF5" <attr:length value="100"/>></td>
                </tr>
                <tr>
                    <td><label for="REG_ID">등록자</label></td>
                    <td><input type="text" name="REG_ID" id="REG_ID" readonly></td>
                    <td><label for="REG_DTM">등록일자</label></td>
                    <td colspan="3"><input type="text" name="REG_DTM" id="REG_DTM" readonly></td>
                </tr>
                <tr>
                    <td><label for="UPDATE_YN">수정여부</label></td>
                    <td>
                        <select id="UPDATE_YN" name="UPDATE_YN" class="select">
                            <option value="" selected>선택</option>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </td>
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
