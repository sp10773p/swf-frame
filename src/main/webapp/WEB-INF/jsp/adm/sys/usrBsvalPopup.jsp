<%--
    Class Name : usrBsvalPopup.jsp
    Description : 판매자 신고서정보 팝업
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
    <%@ include file="/WEB-INF/include/include-admin-popup-header.jspf" %>
    <script>
        var args = $.comm.getModalArguments();
        $(function () {
            fn_select();

        });

        function fn_select(){
            var params = {
                "qKey"    : "sel.selectUserInfo",
                "USER_ID" : args.USER_ID
            };
            $.comm.send("/common/select.do", params,
                function (ret){
                    var data = ret.data;
                    $.comm.bindData(data);
                },
                "판매자 신고서정보 조회"
            );
        }

    </script>
</head>
<body>
<div class="layerContent">
    <div class="layerTitle">
        <h1>${ACTION_MENU_NM}</h1>
    </div><!-- layerTitle -->
    <div class="title_frame" style="margin-top: 0px">
        <p><a href="#판매자 신고정보" class="btnToggle">판매자 신고정보</a></p>
        <div class="white_frame">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                        <col width="145px" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="AUTO_SEND_YN">자동신고여부</label></td>
                        <td><span id="AUTO_SEND_YN"/></td>
                        <td><label for="BIZ_NO">사업자등록번호</label></td>
                        <td><span id="BIZ_NO"/></td>
                    </tr>
                    <tr>
                        <td><label for="USER_NM">판매자명</label></td>
                        <td><span id="USER_NM"/></td>
                        <td><label for="REP_NM">대표자명</label></td>
                        <td><span id="REP_NM"/></td>
                    </tr>
                    <tr>
                        <td><label for="TG_NO">통관고유부호</label></td>
                        <td><span id="TG_NO"/></td>
                        <td><label for="APPLICANT_ID">신고인부호</label></td>
                        <td><span id="APPLICANT_ID"/></td>
                    </tr>
                    <tr>
                        <td><label for="ZIP_CD">우편번호</label></td>
                        <td><span id="ZIP_CD"/></td>
                        <td><label for="REG_MALL_ID">몰ID</label></td>
                        <td><span id="REG_MALL_ID"/></td>
                    </tr>
                    <tr>
                        <td><label for="ADDRESS">주소</label></td>
                        <td colspan="3"><span id="ADDRESS"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="title_frame" style="margin-top: 0px">
        <p><a href="#신고서 기본값 정보" class="btnToggle">신고서 기본값 정보</a></p>
        <div class="white_frame">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                        <col width="145px" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="CUSTOMORGANIZATIONID">세관코드</label></td>
                        <td><span id="CUSTOMORGANIZATIONID"/></td>
                        <td><label for="CUSTOMDEPARTMENTID">과코드</label></td>
                        <td><span id="CUSTOMDEPARTMENTID"/></td>
                    </tr>
                    <tr>
                        <td><label for="LODINGLOCATIONID">적재항</label></td>
                        <td><span id="LODINGLOCATIONID"/></td>
                        <td><label for="GOODSLOCATIONID1">물품소재지 우편번호</label></td>
                        <td><span id="GOODSLOCATIONID1"/></td>
                    </tr>
                    <tr>
                        <td><label for="DELIVERYTERMSCODE">인도조건</label></td>
                        <td><span id="DELIVERYTERMSCODE"/></td>
                        <td><label for="PAYMENTTERMSTYPECODE">결제방법코드</label></td>
                        <td><span id="PAYMENTTERMSTYPECODE"/></td>
                    </tr>
                    <tr>
                        <td><label for="EXPORTERCLASSCODE">수출자구분</label></td>
                        <td><span id="EXPORTERCLASSCODE"/></td>
                        <td><label for="DRAWBACKROLE">환급신청인</label></td>
                        <td><span id="DRAWBACKROLE"/></td>
                    </tr>
                    <tr>
                        <td><label for="INSPECTIONCODE">검사방법선택</label></td>
                        <td><span id="INSPECTIONCODE"/></td>
                        <td><label for="TRANSPORTMEANSCODE">주운송수단</label></td>
                        <td><span id="TRANSPORTMEANSCODE"/></td>
                    </tr>
                    <tr>
                        <td><label for="GOODSLOCATIONNAME">물품소재지</label></td>
                        <td colspan="3"><span id="GOODSLOCATIONNAME"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="title_frame" style="margin-top: 0px">
        <p><a href="#EMS 정보 관리" class="btnToggle">EMS 정보 관리</a></p>
        <div class="white_frame">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="CUSTNO">고객번호</label></td>
                        <td><span id="CUSTNO"/></td>
                    </tr>
                    <tr>
                        <td><label for="APPRNO1">계약승인번호</label></td>
                        <td>
                            <span>EMS : </span><span id="APPRNO1"></span>&nbsp;&nbsp;&nbsp;&nbsp;
                            <span>K-Packet : </span><span id="APPRNO2"></span>&nbsp;&nbsp;&nbsp;&nbsp;
                            <%--<span>한중해상특송 : </span><span id="APPRNO3"></span>--%>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div class="title_frame" style="margin-top: 0px">
        <p><a href="#특송사 정보 관리" class="btnToggle">특송사 정보 관리</a></p>
        <div class="white_frame">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="MAINEXPRESSNAME">주거래 특송사</label></td>
                        <td><span id="MAINEXPRESSNAME"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div class="title_frame" style="margin-top: 0px">
        <p><a href="#관세사 정보 관리" class="btnToggle">관세사 정보 관리</a></p>
        <div class="white_frame">
            <div class="table_typeA darkgray table_toggle">
                <table style="table-layout:fixed;" >
                    <colgroup>
                        <col width="145px"/>
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <td><label for="MAINCUSUSERNAME">주거래 관세사</label></td>
                        <td><span id="MAINCUSUSERNAME"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/include/include-admin-popup-body.jspf" %>
</body>
</html>
