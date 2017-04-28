<%--
    Class Name : pcrHistoryListPopup.jsp
    Description : 구매확인서 이력 목록
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-02-10  정안균   최초 생성

    author : 정안균
    since : 2017-02-10
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        $(function (){
        	var args = $.comm.getModalArguments();
        	var pcrLicId = args.PCR_LIC_ID;
            var befPcrLicId = args.BEF_PCR_LIC_ID;
            var docId = args.DOC_ID;
            headers = [
                {"HEAD_TEXT": "상태"                      , "WIDTH": "60" , "FIELD_NAME": "DOC_STAT_NM"},
                {"HEAD_TEXT": "신청구분"                  , "WIDTH": "80" , "FIELD_NAME": "REQ_TYPE"},
                {"HEAD_TEXT": "공급자상호"                , "WIDTH": "130", "FIELD_NAME": "SUP_ORG_NM"},
                {"HEAD_TEXT": "공급자사업자번호"          , "WIDTH": "120", "FIELD_NAME": "SUP_ORG_ID"},
                {"HEAD_TEXT": "총수량"                    , "WIDTH": "110" , "FIELD_NAME": "TOT_QTY", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "총금액"                    , "WIDTH": "150", "FIELD_NAME": "TOT_AMT", "DATA_TYPE":"NUM"},
                {"HEAD_TEXT": "문서번호"                  , "WIDTH": "170" , "FIELD_NAME": "DOC_ID"},
                {"HEAD_TEXT": "변경/취소전 구매확인서번호", "WIDTH": "200" , "FIELD_NAME": "BEF_PCR_LIC_ID"},
                {"HEAD_TEXT": "등록일자"                  , "WIDTH": "80" , "FIELD_NAME": "REG_DTM", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "수정일자"                  , "WIDTH": "80" , "FIELD_NAME": "MOD_DTM", "DATA_TYPE":"DAT"},
                {"HEAD_TEXT": "확인기관명"                , "WIDTH": "110", "FIELD_NAME": "CONF_ORG_NM"}
            ];

            gridWrapper = new GridWrapper({
                "actNm"        : "구매확인서 이력 조회",
                "targetLayer"  : "gridLayer",
                "qKey"         : "pcr.selectPcrLicHistList",
                "paramsGetter" : {"DOC_ID":docId, "BEF_PCR_LIC_ID":befPcrLicId, "PCR_LIC_ID":pcrLicId},
                "headers"      : headers,
                "gridNaviId"   : "gridPagingLayer",
                "check"        : false,
                "firstLoad"    : true,
                "defaultSort"  : "DOC_ID DESC"
            });

        });

    </script>
</head>
<body>
	<div class="layerContainer">
		<div class="layerTitle">
			<h1>구매확인서 이력 목록</h1>
		</div><!-- layerTitle -->
		<!-- layer_btn_frame -->
        <div class="layer_btn_frame">
   			<!-- <a href="##" class="btn white_84" id="btnClose">닫기</a>-->  
        </div>

		<div class="title_frame">
			<div id="gridLayer" style="height: 413px;"></div>
			<div class="bottom_util">
            	<div class="paging" id="gridPagingLayer"></div>
       		</div>
		</div><!-- //title_frame -->

	</div>
	<%@ include file="/WEB-INF/include/include-popup-body.jspf"%>
</body>
</html>
