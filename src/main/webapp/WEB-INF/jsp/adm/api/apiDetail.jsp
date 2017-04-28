<%--
    Class Name : apiDetail.jsp
    Description : API목록 상세
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
    <style>
        .title_frame{height: auto; margin-top: 0px}
    </style>
    <script>
        var globalVar = {
            jsonTreeList : []
        };

        $(function (){
            // 저장
            $('#btnSave').on("click", function (e) {
                fn_save();
            });

            // 삭제
            $('#btnDel').on("click", function (e) {
                fn_del();
            });

            // 연계테스트
            $('#btnTest').on("click", function (e) {
                $.comm.setModalArguments($.comm.getFormData('detailForm'));
                
                var spec = "dialogWidth:1220px;dialogHeight:900px;scroll:auto;status:no;center:yes;resizable:yes;";
                $.comm.dialog("/jspView.do?jsp=adm/api/apiTestPopup", spec);
            });

            // 목록
            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });

            // 트리신규
            $('#btnTreeNew').on("click", function (e) {
                fn_treeNew();
            });

            // 트리삭제
            $('#btnTreeDel').on("click", function (e) {
                fn_treeDel();
            });

            // 트리저장
            $('#btnTreeSave').on("click", function (e) {
                fn_treeSave();
            });

            $.comm.readonly('JSON_ID', true);

            //수정모드일때
            if($('#SAVE_MODE').val() == "U"){
                var param = {
                    "qKey"   : "api.selectCmmApiMng",
                    "API_ID" : "${API_ID}"
                };

                $.comm.send("/common/select.do", param,
                    function(data, status){
                        $.comm.bindData(data.data);
                        fn_drawJsonTree();
                    },
                    "API목록 상세조회"
                );

                // 메뉴구분
                $('#P_JSON_TYPE').on('change', function (e) {
                    fn_drawJsonTree();
                });

            }else if($('#SAVE_MODE').val() == "I"){
                $.comm.display(["btnDel", "btnTreeNew", "btnTreeDel", "btnTreeSave"], false); // 삭제버튼, 안보이게
            }
        })

        // 저장
        function fn_save() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            $.comm.sendForm("/adm/api/saveApiMng.do", "detailForm",
                function (data) {
                    $.comm.display(["btnDel", "btnTreeNew", "btnTreeDel", "btnTreeSave"], true);
                    fn_treeNew();
                }, "API목록 상세 저장"
            );
        }

        // 삭제
        function fn_del() {
            if(!confirm($.comm.getMessage("C00000001"))){ // 삭제 하시겠습니까?
                return;
            }

            $.comm.sendForm("/adm/api/deleteApiMng.do", "detailForm",
                function (data) {
                    if(data.code.indexOf('I') == 0){
                        $('#btnList').click();
                    }
                }, "API목록 상세 삭제");
        }

        // 메뉴 트리 생성
        function fn_drawJsonTree() {
            var param = {
                "API_ID"      : $('#API_ID').val(),
                "P_JSON_TYPE" : $('#P_JSON_TYPE').val()
            };
            $.comm.send("/adm/api/selectCmmApiInfoTree.do", param, function (ret) {
                var data = ret["data"];

                var treeList = data["treeList"];
                // 데이터파라미터 트리 생성
                $.comm.drawTree("jsonTree", treeList, "LVL", "TREE_NM", "fn_treeClick", "JSON_ID", treeList, null, null, null, {closeSameLevel: false} );
                globalVar.jsonTreeList = treeList;

                // 데이터 파라미터 정의 리셋
                fn_treeNew();

                // SAMPLE JSON
                $('#SAMPLE_JSON').val("");
                if(!$.comm.isNull(data["treeJson"])){
                    var jsonObj = JSON.parse(data["treeJson"]);
                    $('#SAMPLE_JSON').val(JSON.stringify(jsonObj, null, '\t'));

                }


            }, "API 데이터파라미터 조회")

        }

        // 트리신규
        function fn_treeNew() {
            $('#TREE_SAVE_MODE').val("I");
            $('#treeForm')[0].reset();

            if(globalVar.jsonTreeList.length == 0){
                $.comm.readonly("P_JSON_ID", true);
            }else{
                $.comm.readonly("P_JSON_ID", false);
            }
        }
        
        // 트리삭제
        function fn_treeDel() {
            if($('#TREE_SAVE_MODE').val() == "I"){
                alert($.comm.getMessage("W00000003")); //선택한 데이터가 없습니다.
                return;
            }

            if(!confirm($.comm.getMessage("C00000001"))){ // 삭제 하시겠습니까?
                return;
            }

            var params = {
                "qKey"    : "api.deleteApiInfoTree",
                "JSON_ID" : $('#JSON_ID').val()
            }
            $.comm.send("/common/deleteList.do", params, fn_drawJsonTree, "API목록 데이터파라미터 삭제");
        }
        
        // 트리저장
        function fn_treeSave() {
            if (!confirm($.comm.getMessage("C00000002"))) { // 저장 하시겠습니까?
                return;
            }

            if(globalVar.jsonTreeList.length > 0 && !$.comm.isNull($('#P_JSON_ID').val())){
                // 상위JSON KEY 존재여부
                var bool = false;
                for(var i=0; i<globalVar.jsonTreeList.length; i++){
                    var detailData = globalVar.jsonTreeList[i];
                    if(parseInt($('#P_JSON_ID').val()) == parseInt(detailData["JSON_ID"])) {
                        bool = true;
                    }
                }

                if(bool == false){
                    alert($.comm.getMessage("W00000066")); // 존재하지 않는 상위 JSON ID 입니다.
                    $('#P_JSON_ID').focus();
                    return;
                }
            }

            if($.comm.validation("treeForm") == false){
                return;
            }

            var paramObj = $.comm.getFormData("treeForm");

            paramObj["API_ID"]    = $('#API_ID').val();
            paramObj["JSON_TYPE"] = $('#P_JSON_TYPE').val();

            $.comm.send("/adm/api/saveApiInfo.do", paramObj, fn_drawJsonTree, "API 데이터파라미터 저장");
        }

        // 트리선택시
        function fn_treeClick(jsonId){
            if(parseInt(jsonId) == 0){
                return;
            }

            for(var i=0; i<globalVar.jsonTreeList.length; i++){
                var detailData = globalVar.jsonTreeList[i];
                if(jsonId == detailData["JSON_ID"]){
                    $("#treeForm")[0].reset();
                    $.comm.bindData(detailData);
                    $('#TREE_SAVE_MODE').val("U");
                    break;
                }
            }
        }
    </script>
</head>
<body>
<div id="content_body">
    <div class="title_frame">
        <p><a href="#API 상세정보" class="btnToggle">API 상세정보</a></p>
        <div class="white_frame">
            <form id="detailForm" name="detailForm" method="post">
                <input type="hidden" name="SAVE_MODE" id="SAVE_MODE" value="${SAVE_MODE}">
                <div class="util_frame">
                    <a href="#목록" class="btn blue_84" id="btnList">목록</a>
                    <a href="#연계테스트" class="btn blue_84" id="btnTest">연계테스트</a>
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
                            <td><label for="API_ID">APIID</label></td>
                            <td><input type="text" name="API_ID" id="API_ID" <attr:mandantory/> <attr:length value="35"/>></td>
                            <td><label for="API_NM">설명</label></td>
                            <td><input type="text" name="API_NM" id="API_NM" <attr:mandantory/> <attr:length value="50" />></td>
                            <td><label for="LIMIT_DETAIL_CNT">월최대처리건</label></td>
                            <td><input type="text" name="LIMIT_DETAIL_CNT" id="LIMIT_DETAIL_CNT" <attr:mandantory/> <attr:length value="38" /> <attr:numberOnly/> ></td>
                        </tr>
                        <tr>
                            <td><label for="DAILY_CALL_CNT">일최대호출건</label></td>
                            <td><input type="text" name="DAILY_CALL_CNT" id="DAILY_CALL_CNT" <attr:mandantory/> <attr:length value="38" /> <attr:numberOnly/> ></td>
                            <td><label for="PER_CALL_CNT">회당처리건</label></td>
                            <td><input type="text" name="PER_CALL_CNT" id="PER_CALL_CNT" <attr:mandantory/> <attr:length value="38" /> <attr:numberOnly/> ></td>
                            <td><label for="API_URL">URL</label></td>
                            <td><input type="text" name="API_URL" id="API_URL" <attr:mandantory/> <attr:length value="100" />></td>
                        </tr>
                        <tr>
                            <td><label for="API_VERSION">버전</label></td>
                            <td><input type="text" name="API_VERSION" id="API_VERSION" <attr:length value="10" />></td>
                            <td><label for="CLASS_ID">사용클래스</label></td>
                            <td colspan="3"><input type="text" name="CLASS_ID" id="CLASS_ID" <attr:mandantory/> <attr:length value="100" />></td>
                        </tr>
                        <tr>
                            <td><label for="API_DESC">API설명</label></td>
                            <td colspan="5"><textarea name="API_DESC" id="API_DESC" rows="400" cols="200" style="margin-top:5px; margin-bottom:5px;padding: 5px; width: 100%; height: 100px" ></textarea></td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
    </div>

    <div class="vertical_frame">
        <div class="vertical_frame_left46">
            <div class="title_frame">
                <p><a href="#데이터 파라미터" class="btnToggle">데이터 파라미터</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <label for="P_JSON_TYPE" hidden>메뉴구분</label>
                        <select id="P_JSON_TYPE" class="select" style="width: 100px">
                            <option value="REQ">요청 JSON</option>
                            <option value="RES">응답 JSON</option>
                        </select>
                    </div>
                    <div class="inner_scroll_line" style="height:750px;">
                        <div id="jsonTree"></div><!-- dTree -->
                    </div><!-- inner_scroll_line -->
                </div><!-- //white_frame -->
            </div>
        </div><!-- vertical_frame_left -->

        <div class="vertical_frame_right46">
            <div class="title_frame">
                <p><a href="#데이터 파라미터 정의" class="btnToggle">데이터 파라미터 정의</a></p>
                <div class="white_frame">
                    <div class="util_frame">
                        <a href="#트리삭제" class="btn blue_84" id="btnTreeDel">삭제</a>
                        <a href="#트리저장" class="btn blue_84" id="btnTreeSave">저장</a>
                        <a href="#트리신규" class="btn blue_84" id="btnTreeNew">신규</a>
                    </div>

                    <form name="treeForm" id="treeForm">
                        <input type="hidden" id="TREE_SAVE_MODE" name="TREE_SAVE_MODE" value="I">
                        <input type="hidden" id="JSON_TYPE" name="JSON_TYPE">
                        <div>
                            <div class="table_typeA darkgray">
                                <table style="table-layout:fixed;">
                                    <caption class="blind">데이터 파라미터 정의</caption>
                                    <colgroup>
                                        <col width="120px"/>
                                        <col width="*"/>
                                        <col width="120px"/>
                                        <col width="*"/>
                                    </colgroup>
                                    <tr>
                                        <td><label for="JSON_ID">JSON ID</label></td>
                                        <td>
                                            <input type="text" name="JSON_ID" id="JSON_ID">
                                        </td>
                                        <td><label for="P_JSON_ID">상위 JSON ID</label></td>
                                        <td>
                                            <input type="text" name="P_JSON_ID" id="P_JSON_ID" <attr:length value="6"/> onkeyup="$(this).val( $(this).val().replace(/[^0-9]/gi,'') )">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="JSON_KEY">JSON Key</label></td>
                                        <td>
                                            <input type="text" name="JSON_KEY" id="JSON_KEY" <attr:mandantory/> <attr:length value="50"/>/>
                                        </td>
                                        <td><label for="JSON_SAMP">샘플</label></td>
                                        <td>
                                            <input type="text" name="JSON_SAMP" id="JSON_SAMP" <attr:length value="300"/>>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="LOOP_YN">반복</label></td>
                                        <td>
                                            <select id="LOOP_YN" name="LOOP_YN">
                                                <option value="">선택</option>
                                                <option value="Y">Y</option>
                                                <option value="N">N</option>
                                            </select>
                                        </td>
                                        <td><label for="MANDI_TYPE">필수</label></td>
                                        <td>
                                            <select id="MANDI_TYPE" name="MANDI_TYPE">
                                                <option value="M">M</option>
                                                <option value="O">O</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="ORDR">순서</label></td>
                                        <td>
                                            <input type="text" name="ORDR" id="ORDR" <attr:numberOnly value="true"/> <attr:length value="10"/> />
                                        </td>
                                        <td><label for="DATA_TYPE">데이터타입</label></td>
                                        <td>
                                            <input type="text" name="DATA_TYPE" id="DATA_TYPE" <attr:mandantory/> <attr:length value="15"/>>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="JSON_NM">설명</label></td>
                                        <td colspan="3">
                                            <input type="text" name="JSON_NM" id="JSON_NM" <attr:length value="300"/>>
                                        </td>
                                    </tr>
                                </table>
                            </div><!-- //table_typeA -->
                        </div>
                    </form>
                </div>
            </div>
            <div class="title_frame">
                <p><a href="#SAMPLE JSON" class="btnToggle">샘플 JSON</a></p>
                <div class="white_frame">
                    <div class="table_typeA darkgray">
                        <table style="table-layout:fixed;">
                            <caption class="blind">데이터 파라미터 정의</caption>
                            <colgroup>
                                <col width="*"/>
                            </colgroup>
                            <tr>
                                <td style="padding-left: 0px">
                                    <textarea name="SAMPLE_JSON" id="SAMPLE_JSON" rows="200" cols="200" style="padding: 5px; width: 100%; height: 450px"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div><!-- //vertical_frame_right -->
    </div><!-- //vertical_frame -->
</div>
<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
