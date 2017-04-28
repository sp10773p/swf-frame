<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2016-12-21
  Time: 오전 11:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
    var commCodeMap = {
            'SND_RCV_DIV' : {'S':'송신', 'R':'수신'}, 
            'DOC_TYPE' : (function() {
                var rtn = {};
                $.each($.comm.getCommCode("DOC_TYPE"), function(){
                    var code  = this.CODE;
                    var value = this.CODE_NM;
                    rtn[this.CODE] = value;
                })
                
                return rtn;
            })(), 
            'DOC_STATUS' : (function() {
                var rtn = {};
                $.each($.comm.getCommCode("DOC_STATUS"), function(){
                    var code  = this.CODE;
                    var value = this.CODE_NM;
                    rtn[this.CODE] = value;
                })
                
                return rtn;
            })()
     };
    
    var gridWrapper, headers;
    $(function () {
        var data = $.comm.sendSync("/edi/selectSendRecv.do", $.comm.getModalArguments()).data;
        
        if(data){
        	$('#SND_RCV_DIV').html(commCodeMap['SND_RCV_DIV'][data['SND_RCV_DIV']]);
        	$('#SND_RCV_DTM').html(data['SND_RCV_DTM']);
        	$('#DOC_TYPE').html(commCodeMap['DOC_TYPE'][data['DOC_TYPE']]);
        	$('#DOC_ID').html(data['DOC_ID']);
        	$('#DOC_STATUS').html(commCodeMap['DOC_STATUS'][data['DOC_STATUS']]);
        	$('#REG_ID').html(data['REG_ID']);
        	$('#ORG_NM').html(data['ORG_NM']);
            $('#REQ_KEY').html(data['REQ_KEY']);        	
            $('#SNDR_ID').html(data['SNDR_ID']);
            $('#SNDR_QUAL').html(data['SNDR_QUAL']);
            $('#RECP_ID').html(data['RECP_ID']);
            $('#RECP_QUAL').html(data['RECP_QUAL']);
            $('#FILE_NM').html(data['FILE_NM']);
            $('#ERR_MSG').html(data['ERR_MSG']);
            
        	$('#XML_CONTENT').val(data['XML_CONTENT']);
            headers = [
                {"HEAD_TEXT" : "생성일", "WIDTH" : "120" , "FIELD_NAME" : "REG_DTM"},                       
	            {"HEAD_TEXT" : "처리회수", "WIDTH" : "70" , "FIELD_NAME" : "RE_CNT"},
	            {"HEAD_TEXT" : "이벤트코드", "WIDTH" : "80", "FIELD_NAME" : "EVT_TYPE"},           
	            {"HEAD_TEXT" : "이벤트", "WIDTH" : "300", "FIELD_NAME" : "EVT_TYPE_NM"}    
            ];

            gridWrapper = new GridWrapper({
                "actNm"  : "사용자 조회",
                "targetLayer" : "gridLayer",
                "qKey"  : "edi.selectSendRecvEvt",
                "requestUrl"  : "/edi/selectSendRecvEvtList.do",
                "headers"  : headers,
                "paramsGetter"  : $.comm.getModalArguments(), 
                "gridNaviId"  : "gridPagingLayer",
                "controllers": [
                ]
            });            
        }
    });
    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>전문상세조회</h1>
    </div><!-- layerTitle -->
    <form id="searchForm">
        <div class="white_frame">
            <div class="table_typeA gray">
                <table style="table-layout:fixed;" >
                    <caption class="blind">판매자정보</caption>
                    <colgroup>
                        <col width="125px"/>
                        <col width="*" />
                        <col width="125px" />
                        <col width="*" />
                        <col width="125px" />
                        <col width="*" />
                        <col width="125px" />
                        <col width="*" />                        
                    </colgroup>
                    <tr>
                        <td>송/수신 구분</td>
                        <td><span id="SND_RCV_DIV"></span></td>
                        <td>송/수신일</td>
                        <td ><span id="SND_RCV_DTM"></span></td>
                        <td>전자문서명</td>
                        <td><span id="DOC_TYPE"></span></td>     
                        <td>메시지 ID</td>
                        <td ><span id="DOC_ID"></span></td>                                           
                    </tr>
                    <tr>
                        <td>상태</td>
                        <td><span id="DOC_STATUS"></span></td>                    
                        <td>사용자ID</td>
                        <td><span id="REG_ID"></span></td>                                              
                        <td>상호</td>
                        <td><span id="ORG_NM"></span></td>  
                        <td>전자문서관리번호</td>
                        <td><span id="REQ_KEY"></span></td>                          
                    </tr>
                    <tr>
                        <td>송신식별자</td>
                        <td><span id="SNDR_ID"></span></td>
                        <td>송신식별자상세</td>
                        <td><span id="SNDR_QUAL"></span></td>                        
                        <td>수신식별자</td>
                        <td><span id="RECP_ID"></span></td>
                        <td>수신식별자상세</td>
                        <td><span id="RECP_QUAL"></span></td>
                    </tr>          
                    <tr>
                        <td>전문파일명</td>
                        <td colspan="7"><span id="FILE_NM"></span></td>
                    </tr>
                    <tr style="height:70px;">
                        <td>에러메세지</td>
                        <td colspan="7" style="padding-top:5px;padding-bottom:5px;"><div id="ERR_MSG" style="height:110px;overflow-y:scroll;"></div></td>
                    </tr>                    
                </table>
            </div>
        </div>
    </form>
	<div class="vertical_frame">
        <div class="vertical_frame_left55">
		    <div class="white_frame">
		        <div class="util_frame">
		            <p class="util_title"><label>전문내용</label></p>
		        </div>
		        <table class="table_typeA darkgray">
		            <tr>
		                <td>
		                    <textarea name="XML_CONTENT" id="XML_CONTENT" style="padding: 5px; width: 100%; height: 360px; " readonly></textarea>
		                </td>
		            </tr>
		        </table>
		    </div>
	    </div> 	   
	    <div class="vertical_frame_right55">
	        <div class="white_frame">
	            <p class="util_title"><label>이벤트 로그</label></p>        
		        <div class="util_frame">
		            <div class="util_left64">
		                <p class="total">Total <span id="totCnt"></span></p>
		            </div>
		            <div class="util_right64">
		            </div>
		        </div>
	            <div id="gridLayer" style="height: 230px"></div>
		        <div class="bottom_util">
		            <div class="paging" id="gridPagingLayer">
		            </div>
		        </div>
	        </div>  	 
	    </div>  
    </div> 
</div>
<%--content_body--%>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
