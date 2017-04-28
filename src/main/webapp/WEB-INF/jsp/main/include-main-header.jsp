<%--
  Created by IntelliJ IDEA.
  User: sdh
  Date: 2017-03-30
  Time: 오후 12:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<s:eval expression="@config.getProperty('main.url')" var="mainUrl"/>
<script>
    function fn_goMain(loadMenu, paramKey, paramVal){
        var url = "<c:url value="${mainUrl}"/>";
        var form = $('<form action="'+ url +'" method="post">');
        if(!$.comm.isNull(loadMenu)){
            form.append('<input type="hidden" name="loadMenu" value="' + loadMenu + '">');
        }

        // 파라미터
        if(!$.comm.isNull(paramKey) && !$.comm.isNull(paramVal)){
            form.append('<input type="hidden" name="' + paramKey + '" value="' + paramVal + '">');
        }

        $('body').append(form);
        form.submit().remove();
    }

    function fn_goSite(name){
        if(name == "help"){
            fn_goMain("help/inf/svcInfo");

        }else if(name == "openapi"){   // OPEN Api
            fn_goMain("apiguide/apiIntro");   

        }else if(name == "modifyMyinfo"){	// 회원정보수정
            fn_goMain("basic/prof/profWrite");

        }else if(name == "decExp"){	// 수출신고
            fn_goMain("exp/dec/decList");

        }else if(name == "pcr"){	// 구매확인
            fn_goMain("pcr/pcrList");

        }else if(name == "ems"){	// 배송요청 (셀러)
            fn_goMain("ems/pick/pickList");
        
        }else if(name == "xpr"){	// 배송요청 (특송사)
            fn_goMain("xpr/ship/shipReqList");

        }else if(name =="expSta"){ // 수출실적 명세
            fn_goMain("exp/sta/expStaResList");

        }else if(name =="ntc"){ // 공지사항
            fn_goMain("help/ntc/ntcList");

        }else if(name =="news"){ // 공지사항
            fn_goMain("help/ntc/newsList");

        }else if(name == "decReq"){	// 수출신고 요청내역
            fn_goMain("exp/req/decReqList");

        }else if(name == "modReq"){	// 수출정정취하 요청내역
            fn_goMain("exp/req/modReqList");

        }else if(name == "impReq"){	// 반품수입신고의뢰
            fn_goMain("exp/imp/impReqList");

        }else if(name == "apiExpFull"){	// 수출이행신고용 정보요청
            fn_goMain("apiguide/apiView&API_ID=expFulfillmentInfo");

        }
    }
</script>
<!-- header -->
<div id="header">
    <div class="gnb clearfix inner_wrap">
        <h1 class="home_logo"><a href="javascript:location.href='<c:out value="/"/>'">goGlobal</a></h1>
        <ul class="clearfix">
            <li><a href="#" onclick="fn_goSite('openapi')">OpenAPI안내</a></li>
            <li><a href="#" onclick="fn_goSite('help')">Help</a></li>
        </ul>
    </div>
</div>