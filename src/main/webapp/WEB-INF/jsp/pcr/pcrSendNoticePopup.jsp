<%--
    Class Name : pcrSendNoticePopup.jsp
    Description : 전송오류/취소 통보
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017-04-05  정안균   최초 생성

    author : 정안균
    since : 2017-04-05
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-popup-header.jspf"%>
    <script>
        var gridWrapper, headers;
        var arguments = $.comm.getModalArguments(); // 부모창에서 넘긴 인자
        var docId = arguments.DOC_ID;
        var docStat = arguments.DOC_STAT;
        $(function (){
        	var actionNm = "";
        	if(docStat == "95") {
        		$(".layerTitle h1").html("취소통보");
        		actionNm = "취소통보 조회";
        		$.comm.display(["pcrLicId_tr"], true);
        	} else if(docStat == "E2") {
        		$(".layerTitle h1").html("오류통보");
        		actionNm = "오류통보 조회";
        		$.comm.display(["pcrLicId_tr"], false);
        	}
        	var data = {"qKey": "pcr.selectSendNoticeInfo", "DOC_ID": docId};
        	$.comm.send("/common/select.do", data,
                     function(data, status){
        				var resultData = data.data;
                 		$.comm.bindData(resultData);
                     }, actionNm
            );

        });
        
     	
    </script>
</head>
<body>
<div class="layerContainer">
    <div class="layerTitle">
        <h1>오류통보</h1>
    </div><!-- layerTitle -->
    <div class="layer_btn_frame">
	</div>
     <div class="layer_content">
	    <div class="title_frame">	
	    	<div class="table_typeA gray table_toggle">
	    		<table style="table-layout:fixed;" >
	    			<caption class="blind">오류통보</caption>
	    			<colgroup>
                    	<col width="15%" />
                    	<col width="35%" />
                    	<col width="15%" />
                    	<col width="35%" />
                	</colgroup>
                    <tr>
                        <td><label for="DOC_ID">문서번호</label></td>
                        <td><span id="DOC_ID"></span></td>
                        <td><label for="DOC_RES_TYPE_NM">전자문서응답유형</label></td>
                        <td><span id="DOC_RES_TYPE_NM"></span></td>
                    </tr>
                    <tr>
                        <td><label for="DOC_SEND_ID">발신자번호</label></td>
                        <td><span id="DOC_SEND_ID"></span></td>
                        <td><label for="DOC_RECP_ID">수신자번호</label></td>
                        <td><span id="DOC_RECP_ID"></span></td>
                    </tr>
                    <tr>
                        <td><label for="MESSAGE">전달내용</label></td>
                        <td colspan="3"><div style="padding: 5px 0 5px 0;line-height:1.3em;overflow: auto;height: 250px;"><span id="MESSAGE"></span></div></td>
                    </tr>
                    <tr id="pcrLicId_tr">
                        <td><label for="BEF_PCR_LIC_ID">구매확인서번호</label></td>
                        <td colspan="3"><span id="BEF_PCR_LIC_ID"></span></td>
                    </tr>
                    <tr>
                        <td><label for="NOTICE_RECP_DTM">수신일시</label></td>
                        <td><span id="NOTICE_RECP_DTM"></span></td>
                        <td><label for="REF_DOC_NAME">관련서류명</label></td>
                        <td><span id="REF_DOC_NAME"></span></td>
                    </tr>
				</table>
			</div>
		</div>
    </div>
</div>
<%@ include file="/WEB-INF/include/include-popup-body.jspf" %>

</body>
</html>
