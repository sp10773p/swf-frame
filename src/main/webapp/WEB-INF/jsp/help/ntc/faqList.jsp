<%--
    Class Name : faqList.jsp
    Description : FAQ 관리
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.02  정안균   최초 생성
    author : 정안균
    since : 2017.03.02
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        var globalVar = {
            "currRow" : 0
        };
        var fileUtil;
        var gridWrapper, headers;
        $(function () {
            headers = [
                {"HEAD_TEXT": "제목"      , "WIDTH": "*"  , "FIELD_NAME": "TITLE", "LINK": "fn_detail", "ALIGN":"left"},
                {"HEAD_TEXT": "최종작성자", "WIDTH": "80", "FIELD_NAME": "MOD_ID"},
                {"HEAD_TEXT": "최종작성일", "WIDTH": "80", "FIELD_NAME": "MOD_DTM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"             : "FAQ 조회",
                "targetLayer"       : "gridLayer",
                "qKey"              : "faq.selectCmmFaqList",
                "headers"           : headers,
                "paramsFormId"      : "searchForm",
                "gridNaviId"        : "gridPagingLayer",
                "firstLoad"         : false,
                "postScript"        : function (){fn_detail(0);},
                "controllers": [
                    {"btnName": "btnSearch", "type": "S"},
                    {"btnName": "btnExcel" , "type": "EXCEL"}
                ]
            });

            // 첨부파일 정의
            fileUtil = new FileUtil({
                "gridDiv"         : "gridWrapLayer",  // 첨부파일 리스트 그리드 DIV ID
                "downloadFn"      : "fn_download",     // 파일 다운로드 함수명
                "postDelScript" : function() {
        			fn_loadFileData('');
                }
            });

            gridWrapper.requestToServer();
        });

        // 상세정보 화면
        function fn_detail(index) {
            if($.comm.isNull(index)){
                index = 0;
            }

            var data = gridWrapper.getRowData(index);
            if(data) {
            	 data["qKey"] = "faq.selectCmmFaq";
                 $.comm.send("/common/select.do", data,
                     function (ret) {
                         var data = ret.data;
                         $.comm.bindData(data);
                         $('#CONTENTS').html(data.CONTENTS);
                         fn_loadFileData(data.ATCH_FILE_ID);// 첨부파일 목록 조회	
                     }, "상세정보 조회"
                 );
            } else {
            	$("#TITLE").html("");
            	$("#CONTENTS").html("");
            	fileUtil.clear(); 
            }  

            globalVar.currRow = index;
        }

        // 첨부파일 다운로드
        function fn_download(index) {
            fileUtil.fileDownload(index);
        }
        
        function fn_loadFileData(atchFileId) {
        	fileUtil.setAtchFileId(atchFileId);
            fileUtil.selectFileList({"ATCH_FILE_ID" : atchFileId}); 
        }
    </script>
</head>
<body>
<div class="inner-box">
	<div class="padding_box">
	    <%-- 조회 영역 --%>
	    <div class="search_toggle_frame">
	    	<div class="search_frame on">
		        <form name="searchForm" id="searchForm">
		            <ul class="search_sectionC">
		                <li>
		                    <label for="F_MOD_DTM" class="search_title">최종작성일자</label><label for="T_MOD_DTM" style="display: none">최종작성일자</label>
		                    <div class="search_date">
		                        <form action="#">
		                            <fieldset>
		                                <legend class="blind">달력</legend>
		                                <input type="text" id="F_MOD_DTM" name="F_MOD_DTM" <attr:datefield to="T_MOD_DTM"/>><span>~</span>
		                                <input type="text" id="T_MOD_DTM" name="T_MOD_DTM" <attr:datefield/>>
		                            </fieldset>
		                        </form>
		                    </div>
		                </li>
		                <li>
		                    <label for="P_TITLE" class="search_title">제목</label>
		                    <input id="P_TITLE" name="P_TITLE" type="text" class="search_input inputHeight"/>
		                </li>
		            </ul>
		            <a href="#조회" id="btnSearch" class="btn_inquiryB" style="float:right;">조회</a>
		        </form>
	        </div>
	        <a href="" class="search_toggle close">검색접기</a>
	    </div>

	    <div class="vertical_frame">
			<div class="vertical_frame_left46">
				<div class="title_frame">
					<p><a href="#FAQ" class="btnToggle">FAQ 목록</a></p>
					<div class="white_frame">
						<div class="util_frame">
							<a href="#엑셀 다운로드" class="btn white_100" id="btnExcel">엑셀 다운로드</a>
						</div>
						<div id="gridLayer" style="height: 430px">
						</div>
						<div class="bottom_util">
							<div class="paging" id="gridPagingLayer">
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="vertical_frame_right46">
				<div class="title_frame">
					<p><a href="#상세정보" class="btnToggle">상세정보</a></p>
					<div class="white_frame">
						<div class="util_frame">
						</div>
						<form id="detailForm" name="detailForm">
							<div class="table_typeA darkgray train">
								<table style="table-layout:fixed;" >
									<caption class="blind">상세정보</caption>
									<colgroup>
										<col width="145px"/>
										<col width="*" />
									</colgroup>
									<tr>
										<td><label for="TITLE">제목</label></td>
										<td><span id="TITLE"></span></td>
									</tr>
									<tr>
										<td><label for="CONTENTS">내용</label></td>
										<td><div id="CONTENTS" style="overflow: auto;height: 400px;padding: 10px 10px 1px 0;"></div></td>
									</tr>
								</table>
							</div>
						</form>
					</div>
				</div>
				<div class="title_frame">
					<p><a href="#첨부파일" class="btnToggle">첨부파일</a></p>
					<div class="white_frame">
						<div class="util_frame">
						</div>
						<div id="gridWrapLayer" style="height: 100px">
						</div>
					</div>
				</div>
			</div>
	    </div>
    </div>
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
