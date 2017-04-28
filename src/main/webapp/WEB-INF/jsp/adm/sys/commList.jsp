<%--
    Class Name : commList.jsp
    Description : 공통코드 관리
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
        var gridMaster, gridDetail, headers, headersDetail;
        var globalVar = {
            "CLASS_ID"  : "",
            "refColName": ""
        };
        $(function (){
            globalVar.refColName = ""; // detail 참조 컬럼

            headers = [
                {"HEAD_TEXT": "클래스"  , "WIDTH": "180", "FIELD_NAME": "CLASS_ID", "LINK":"fn_detail"},
                {"HEAD_TEXT": "설명"    , "WIDTH": "260", "FIELD_NAME": "CLASS_NM", "LINK":"fn_write", "ALIGN":"left"},
                {"HEAD_TEXT": "사용여부", "WIDTH": "70" , "FIELD_NAME": "USE_CHK"},
                {"HEAD_TEXT": "수정여부", "WIDTH": "70" , "FIELD_NAME": "UPDATE_YN"},
                {"HEAD_TEXT": "참조1"   , "WIDTH": "90" , "FIELD_NAME": "USER_REF1"},
                {"HEAD_TEXT": "참조2"   , "WIDTH": "90" , "FIELD_NAME": "USER_REF2"},
                {"HEAD_TEXT": "참조3"   , "WIDTH": "90" , "FIELD_NAME": "USER_REF3"},
                {"HEAD_TEXT": "참조4"   , "WIDTH": "90" , "FIELD_NAME": "USER_REF4"},
                {"HEAD_TEXT": "참조5"   , "WIDTH": "90" , "FIELD_NAME": "USER_REF5"},
                {"HEAD_TEXT": "등록자"  , "WIDTH": "80" , "FIELD_NAME": "REG_ID"},
                {"HEAD_TEXT": "등록일자", "WIDTH": "120", "FIELD_NAME": "REG_DTM"},
                {"HEAD_TEXT": "수정자"  , "WIDTH": "80" , "FIELD_NAME": "MOD_ID"},
                {"HEAD_TEXT": "수정일자", "WIDTH": "120", "FIELD_NAME": "MOD_DTM"}
            ];

            headersDetail = [
                {"HEAD_TEXT": "클래스"  , "WIDTH": "180", "FIELD_NAME": "CLASS_ID", "LINK":"fn_writeDetail"},
                {"HEAD_TEXT": "코드"    , "WIDTH": "100", "FIELD_NAME": "CODE"},
                {"HEAD_TEXT": "설명"    , "WIDTH": "260", "FIELD_NAME": "CODE_NM", "ALIGN":"left"},
                {"HEAD_TEXT": "약어"    , "WIDTH": "70" , "FIELD_NAME": "CODE_SHT"},
                {"HEAD_TEXT": "순서"    , "WIDTH": "50" , "FIELD_NAME": "SEQ"},
                {"HEAD_TEXT": "사용여부", "WIDTH": "70" , "FIELD_NAME": "USE_CHK"}
            ];

            gridMaster = new GridWrapper({
                "actNm"        : "마스터코드 조회",
                "targetLayer"  : "gridMasterLayer",
                "qKey"         : "comm.selectCommcodeMasterList",
                "headers"      : headers,
                "paramsFormId" : "searchForm",
                "countId"      : "totCnt",
                "pageRow"      : 50,
                //"gridNaviId"   : "gridPagingLayer",
                "check"        : true,
                "scrollPaging" : true,
                "firstLoad"    : false,
                "postScript"   : function (){fn_detail(0);},
                "controllers"  : [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnDel"  , "type": "D"    , "targetURI":"/comm/deleteMasterCode.do"},
                    {"btnName": "btnExcel", "type": "EXCEL", "qKey":"comm.selectCommcodeMasterListAll"}
                ]
            });

            gridDetail = new GridWrapper({
                "actNm"        : "상세코드 조회",
                "targetLayer"  : "gridDetailLayer",
                "qKey"         : "comm.selectCommcodeDetailList",
                "headers"      : headersDetail,
                "countId"      : "totDetailCnt",
                "pageRow"      : 50,
                "check"        : true,
                "scrollPaging" : true,
                "firstLoad"    : false,
                "controllers"  : [
                    {"btnName": "btnDel2"  , "type": "D"    , "targetURI":"/comm/deleteDetailCode.do"},
                    {"btnName": "btnExcel2", "type": "EXCEL",
                        "qKey":"comm.selectCommcodeDetailListAll", "postScript": "fn_ableExcel"
                    }
                ]
            });

            // 마스터 추가
            $('#btnNew').on("click", function (e) {
                $.comm.forward("adm/sys/commDetail",{"SAVE_MODE":"I"});
            });

            // 디테일 추가
            $('#btnNew2').on("click", function (e) {
                var size = gridMaster.getSize();
                if(size == 0 || $.comm.isNull(globalVar.CLASS_ID)){
                    alert($.comm.getMessage("W00000002")); //선택한 마스터 정보가 없습니다.
                    return;
                }

                var params = {"SAVE_MODE":"I","CLASS_ID":globalVar.CLASS_ID, "REF_COL":globalVar.refColName};
                $.comm.forward("adm/sys/commSubDetail",params);
            });

            $('#btnSearch').click(); // postScript 실행시 gridDetail 객체를 확보하기 위해 GridWrapper 생성후 조회
        });

        function fn_ableExcel(){
            var size = gridDetail.getSize();
            if(size == 0) return false;
            return true;
        }
        /***
         * 마스터 코드 클래스 링크
         * - 디테일 코드 조회
         * @param index
         */
        function fn_detail(index){
            var size = gridMaster.getSize();
            if(size == 0){
                globalVar.CLASS_ID = "";
                gridDetail.setHeaders(headersDetail);
                gridDetail.drawGrid();
                gridDetail.requestToServer();
                return;
            }
            var data = gridMaster.getRowData(index);
            globalVar.CLASS_ID = data["CLASS_ID"];
            globalVar.refColName = "";

            // Detail Header Setting
            var h = [];
            h = $.merge(h , headersDetail);
            for(var i=1; i<=5; i++){
                if(!$.comm.isNull($.trim(data["USER_REF" + i]))){
                    h[h.length] = {"HEAD_TEXT": data["USER_REF" + i]   , "WIDTH": "90" , "FIELD_NAME": "USER_REF"+1};
                    globalVar.refColName += data["USER_REF" + i] +",";
                }
            }
            if(globalVar.refColName.length > 0){
                globalVar.refColName = globalVar.refColName.substring(0, globalVar.refColName.length-1);
            }

            h[h.length]= {"HEAD_TEXT": "등록자"  , "WIDTH": "80" , "FIELD_NAME": "REG_ID"};
            h[h.length]= {"HEAD_TEXT": "등록일자", "WIDTH": "80" , "FIELD_NAME": "REG_DTM"};
            h[h.length]= {"HEAD_TEXT": "수정자"  , "WIDTH": "80" , "FIELD_NAME": "MOD_ID"};
            h[h.length]= {"HEAD_TEXT": "수정일자", "WIDTH": "80" , "FIELD_NAME": "MOD_DTM"};

            gridDetail.setParams(data);
            gridDetail.setHeaders(h);
            gridDetail.drawGrid();
            gridDetail.requestToServer();
        }

        /***
         * 마스트 코드 상세
         * @param index
         */
        function fn_write(index){
            var data = gridMaster.getRowData(index);
            data["SAVE_MODE"] = "U";

            $.comm.forward("adm/sys/commDetail", data);
        }

        /***
         * 디테일 코드 상세
         * @param index
         */
        function fn_writeDetail(index){
            var data = gridDetail.getRowData(index);
            data["SAVE_MODE"] = "U";

            $.comm.forward("adm/sys/commSubDetail", data);
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
                        <label for="CLASS_ID">클래스</label>
                        <input id="CLASS_ID" name="CLASS_ID" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="CLASS_NM">설명</label>
                        <input id="CLASS_NM" name="CLASS_NM" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="CODE">코드</label>
                        <input id="CODE" name="CODE" type="text" style="width:calc(100% - 300px)"/>
                    </li>
                    <li>
                        <label for="USE_CHK">사용여부</label>
                        <select id="USE_CHK" name="USE_CHK">
                            <option value="">선택</option>
                            <option value="Y" selected>사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </li>
                </ul>
                <a href="#조회" id="btnSearch" class="btn_inquiryC" style="float:right;">조회</a>
            </div>
            <a href="" class="search_toggle close">검색접기</a>
        </form>
    </div>

    <%-- Master Code List 영역--%>
    <div class="title_frame">
        <p><a href="#마스터코드" class="btnToggle">마스터코드</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#엑셀다운로드" class="btn white_100" id="btnExcel">엑셀다운로드</a>
                <a href="#삭제" class="btn white_84" id="btnDel">삭제</a>
                <a href="#추가" class="btn white_84" id="btnNew">신규</a>
            </div>
            <div id="gridMasterLayer" style="height: 350px">
            </div>
        </div>
    </div>
    <div class="title_frame">
        <p><a href="#디테일코드" class="btnToggle">디테일코드</a></p>
        <div class="white_frame">
            <div class="util_frame">
                <a href="#엑셀다운로드" class="btn white_100" id="btnExcel2">엑셀다운로드</a>
                <a href="#삭제" class="btn white_84" id="btnDel2">삭제</a>
                <a href="#추가" class="btn white_84" id="btnNew2">신규</a>
            </div>
            <div id="gridDetailLayer" style="height: 350px">
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/include-admin-body.jspf" %>
</body>
</html>
