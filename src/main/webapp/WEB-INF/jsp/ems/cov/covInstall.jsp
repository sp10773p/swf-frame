<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<OBJECT id="TGIPYO" classid="CLSID:A33E8A6D-B147-49F0-A731-F3AE1973D011" CODEBASE="/install/xpostgipyoCtrl.cab#version=99,99,99,99" width=0 height=0 hspace=0 vspace=0></OBJECT>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script>
    var ActiveXDetector;
    $(function() {
        ActiveXDetector = {
            ACTIVEX_OBJECT_NAME: "xpostgipyoCtrl.xpostgipyoCtrlX", getActiveX: function() {
                try{
                    var obj = new ActiveXObject(this.ACTIVEX_OBJECT_NAME);
                    if (obj) return obj;
                    else ret = null;
                }catch(e){
                    ret = null;
                }
                return ret;
            }
        }
        
        setTimeout(verifyActiveXInstall(), 1000);
    });
    
    function verifyActiveXInstall() {
        if (ActiveXDetector.getActiveX()) {
            alert("기표지출력 프로그램 설치가 완료되었습니다.");
            $.comm.forward("ems/cov/covList", "");
        }
        else {
            alert("기표지출력 프로그램 설치가 취소되었습니다.");
            $.comm.forward("ems/cov/covList", "");
        }
    }
    
</script>
</head>
<body>
    <div id="main_wrap">
        <!-- content 시작 -->
        <div id="content">
            <div class="con_box">
                <h2>${ACTION_MENU_NM}</h2>
                
                   기표지 프로그램 설치
                
                <!-- 버튼 시작 -->
                <div class="btnBlock">
                     
                </div>
                <!--// 버튼 끝 -->

            </div>
            <%-- // con_box --%>
        </div>
        <%-- // content--%>

    </div>
    <%@ include file="/WEB-INF/include/include-body.jspf"%>
</body>
</html>
