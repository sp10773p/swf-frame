<%--
    Class Name : custDetail.jsp
    Description : 거래처 상세
    Modification Information
    수정일 수정자 수정내용
    ----------- -------- ---------------------------
    2017.03.06  정안균   최초 생성

    author : 정안균
    since : 2017.03.06
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/include/include-header.jspf" %>
    <script>
        $(function (){
            $('#btnSave').on("click", function (e) {
            	if(!confirm($.comm.getMessage("C00000002"))){ // 저장 하시겠습니까?
                    return;
                }
            	var frm = new JForm();
            	frm.add(new JCustom(function() {
            		if(!$.comm.isNull($('#MANAGER_EMAIL1').val()) && $.comm.isNull($('#MANAGER_EMAIL2').val())) {
                    	alert("담당자 이메일 도메인을 입력하세요.");
                    	$('#MANAGER_EMAIL2').focus();
                    	return false;
                    }
                    if(!$.comm.isNull($('#MANAGER_EMAIL1').val()) && $.comm.isNull($('#MANAGER_EMAIL2').val())) {
                    	alert("담당자 이메일 ID를 입력하세요.");
                    	$('#MANAGER_EMAIL1').focus();
                    	return false;
                    }
                    
                    if(!$.comm.isNull($('#TAX_MANAGER_EMAIL1').val()) && $.comm.isNull($('#TAX_MANAGER_EMAIL2').val())) {
                    	alert("세금계산서 담당자 이메일 도메인을 입력하세요.");
                    	$('#TAX_MANAGER_EMAIL2').focus();
                    	return false;
                    }
                    if(!$.comm.isNull($('#TAX_MANAGER_EMAIL1').val()) && $.comm.isNull($('#TAX_MANAGER_EMAIL2').val())) {
                    	alert("세금계산서 담당자 이메일 ID를 입력하세요.");
                    	$('#TAX_MANAGER_EMAIL1').focus();
                    	return false;
                    }
                    
                    if($.trim($('#ORG_ID').val()).length != 10) {
           				alert("사업자등록번호가 잘못 되었습니다."); 
           				$('#ORG_ID').focus();
           				return false;
           			}
                    return true;
            	}));
            	
            	if(!frm.validate()){
                	return;
                }
            	
            	$.comm.sendForm("/cust/saveCust.do", "detailForm", fn_callback, "거래처 상세 저장");
            	
            });
            
            $('#btnList').on("click", function (e) {
                $.comm.pageBack();
            });
            var custCd = '${CUST_CD}' ;
            if(custCd && custCd.length > 0) {
            	$('#CUST_CD').val("${CUST_CD}");
            	fn_select(); //상세 조회
            }
            
            $('select[name="MANAGER_EMAIL_SELECT"]').change(function(){
            	if($(this).val()) {
            		$('#MANAGER_EMAIL2').val($(this).val());
            	} else {
            		$('#MANAGER_EMAIL2').val('');
            	}
            });
            
            $('select[name="TAX_MANAGER_EMAIL_SELECT"]').change(function(){
            	if($(this).val()) {
            		$('#TAX_MANAGER_EMAIL2').val($(this).val());
            	} else {
            		$('#TAX_MANAGER_EMAIL2').val('');
            	}
            });
            
            $('#btnNew').on("click", function (e) {
            	  $('#SAVE_MODE').val("I");
                  $('#detailForm')[0].reset();
            });

        });
        
        function fn_select(){
            $.comm.send("/common/select.do", {"qKey" : "cust.selectCust","CUST_CD": $('#CUST_CD').val()},
                function(data, status){
            		var resultData = data.data;
            		$.comm.bindData(resultData);
            		if(resultData) {
            			if(resultData["MANAGER_EMAIL"]) {
            				var managerEmail = resultData["MANAGER_EMAIL"];
                			var idx = managerEmail.indexOf("@");
                			if(idx > -1) {
                				$('#MANAGER_EMAIL1').val(managerEmail.substring(0, idx));
                				$('#MANAGER_EMAIL2').val(managerEmail.substring(idx+1));
                			}
            			}
            			if(resultData["TAX_MANAGER_EMAIL"]) {
            				var taxManagerEmail = resultData["TAX_MANAGER_EMAIL"];
                			var idx = taxManagerEmail.indexOf("@");
                			if(idx > -1) {
                				$('#TAX_MANAGER_EMAIL1').val(taxManagerEmail.substring(0, idx));
                				$('#TAX_MANAGER_EMAIL2').val(taxManagerEmail.substring(idx+1));
                			}
            			}
            			$('#SAVE_MODE').val("U");
            		}
            		
                },
                "거래처 상세 조회"
            );
        }
     	
        var fn_callback = function (data) {
        	if(data) {
            	var data = data.data;
            	$('#CUST_CD').val(data.CUST_CD);
                fn_select();
        	}
        }

    </script>
</head>
<body>
<div class="inner-box">
	<form id="detailForm" name="detailForm" method="post">
	<input type="hidden" id="SAVE_MODE" name="SAVE_MODE" value="I">
    <div class="padding_box">
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
	                <a href="#" class="title_frame_btn" id="btnList">목록</a>
	                <a href="#" class="title_frame_btn" id="btnSave">저장</a>
	                <a href="#" class="title_frame_btn" id="btnNew">신규</a>
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">기본정보</a></p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;">
                <caption class="blind">기본정보</caption>
                <colgroup>
                    <col width="13%" />
                    <col width="37%" />
                    <col width="13%" />
                    <col width="37%" />
                </colgroup>
                <tr>
                    <td><label for="CUST_CD">거래처코드</label></td>
                    <td><input type="text" name="CUST_CD" id="CUST_CD" <attr:length value='10'/> class="td_input readonly" readonly></td>
                    <td><label for="ORG_ID">사업자등록번호</label></td>
                    <td><input type="text" name="ORG_ID" id="ORG_ID" <attr:length value='10,10'/> <attr:mandantory/> class="td_input" ></td>
                </tr>
                <tr>
                    <td><label for="ORG_NM">상호</label></td>
                    <td><input type="text" name="ORG_NM" id="ORG_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input"></td>
                    <td><label for="ORG_EN_NM">상호(영문명)</label></td>
                    <td><input type="text" name="ORG_EN_NM" id="ORG_EN_NM" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="ORG_CEO_NM">대표자명</label></td>
                    <td><input type="text" name="ORG_CEO_NM" id="ORG_CEO_NM" <attr:length value='35'/> <attr:mandantory/> class="td_input"></td>
                    <td><label for="ORG_EN_CEO_NM">대표자명(영문명)</label></td>
                    <td><input type="text" name="ORG_EN_CEO_NM" id="ORG_EN_CEO_NM" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td rowspan="3"><label for="ADDR1">주소</label></td>
                    <td><input type="text" name="ADDR1" id="ADDR1" <attr:length value='35'/> class="td_input" <attr:mandantory/>></td>
                    <td rowspan="3"><label for="EN_ADDR1">주소(영문명)</label></td>
                    <td><input type="text" name="EN_ADDR1" id="EN_ADDR1" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td style="background:none;"><input type="text" name=ADDR2 id="ADDR2" <attr:length value='35'/> class="td_input"></td>
                    <td><input type="text" name="EN_ADDR2" id="EN_ADDR2" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td style="background:none;"><input type="text" name="ADDR3" id="ADDR3" <attr:length value='35'/> class="td_input"></td>
                    <td><input type="text" name="EN_ADDR3" id="EN_ADDR3" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="BIZ_TYPE">업태</label></td>
                    <td><textarea name="BIZ_TYPE" id="BIZ_TYPE" <attr:length value='105'/> rows="5"></textarea></td>
                    <td><label for="BIZ_ITEM">종목</label></td>
                    <td><textarea name="BIZ_ITEM" id="BIZ_ITEM" <attr:length value='105'/> rows="5"></textarea></td>
                </tr>
                <tr>
                    <td><label for="TRADE_ORG_NO">무역업체번호</label></td>
                    <td><input type="text" name="TRADE_ORG_NO" id="TRADE_ORG_NO" <attr:length value='8'/> class="td_input"></td>
                    <td><label for="CUSTOMS_SERIAL_NO">통관고유번호</label></td>
                    <td><input type="text" name="CUSTOMS_SERIAL_NO" id="CUSTOMS_SERIAL_NO" <attr:length value='15'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="TEL_NO">전화번호</label></td>
                    <td><input type="text" name="TEL_NO" id="TEL_NO" <attr:length value='25'/> class="td_input"></td>
                    <td><label for="FAX_NO">FAX</label></td>
                    <td><input type="text" name="FAX_NO" id="FAX_NO" <attr:length value='25'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="HOMEPAGE_URL">홈페이지 URL</label></td>
                    <td colspan="3"><input type="text" name="HOMEPAGE_URL" id="HOMEPAGE_URL" <attr:length value='100'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="REMARK">특이사항</label></td>
                    <td colspan="3"><input type="text" name="REMARK" id="REMARK" <attr:length value='70'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="USE_YN1">사용여부</label><label for="USE_YN2" style="display: none;">사용여부</label></td>
                    <td>
                    	<div class="radio"> 
							<input name="USE_YN" type="radio" id="USE_YN1" value="Y" checked="checked"/>
				        	<label for="USE_YN1"><span></span>사용</label>
						</div>
						<div class="radio"> 
							<input name="USE_YN" type="radio" id="USE_YN2" value="N" />
				        	<label for="USE_YN2"><span></span>미사용</label>
						</div>   
                    </td>
                    <td><label for="ALLY_BIZ_PLACE_ID">종사업장번호</label></td>
                    <td><input type="text" name="ALLY_BIZ_PLACE_ID" id="ALLY_BIZ_PLACE_ID" <attr:length value='4'/> class="td_input"></td>
                </tr>

            </table>
            </div>
        </div><!-- //title_frame -->
        <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">담당자 정보</a></p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;">
                <caption class="blind">Header</caption>
                <colgroup>
                    <col width="13%" />
                    <col width="37%" />
                    <col width="13%" />
                    <col width="37%" />
                </colgroup>
                <tr>
                    <td><label for="MANAGER_NM">담당자명</label></td>
                    <td><input type="text" name="MANAGER_NM" id="MANAGER_NM" <attr:length value='35'/> class="td_input"></td>
                    <td><label for="MANAGE_DEPT">담당부서</label></td>
                    <td><input type="text" name="MANAGE_DEPT" id="MANAGE_DEPT" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="MANAGER_EMAIL1">담당자 이메일</label><label for="MANAGER_EMAIL2" style="display: none;">담당자 이메일 도메인</label>
                    	<label for="MANAGER_EMAIL_SELECT" style="display: none;">담당자 이메일 도메인 선택</label>
                    </td>
                    <td colspan="3">
                    	<div class="email">
							<input type="text" class="td_input" name="MANAGER_EMAIL1" id="MANAGER_EMAIL1" <attr:length value='30'/> style="ime-mode:disabled;"/>
							<span>@</span>
							<input type="text" class="td_input" name="MANAGER_EMAIL2" id="MANAGER_EMAIL2" <attr:length value='30'/> style="ime-mode:disabled;width:130px;"/>
							<select name="MANAGER_EMAIL_SELECT" id="MANAGER_EMAIL_SELECT" class="td_input">
	                            <option value=""            >직접입력       </option>
	                            <option value="chollian.net">chollian.net   </option>
	                            <option value="dreamwiz.com">dreamwiz.com   </option>
	                            <option value="empal.com"   >empal.com      </option>
	                            <option value="freechal.com">freechal.com   </option>
	                            <option value="gmail.com"   >gmail.com      </option>
	                            <option value="hanafos.com" >hanafos.com    </option>
	                            <option value="hanmail.net" >hanmail.net    </option>
	                            <option value="hotmail.com" >hotmail.com    </option>
	                            <option value="korea.com"   >korea.com      </option>
	                            <option value="nate.com"    >nate.com       </option>
	                            <option value="naver.com"   >naver.com      </option>
	                            <option value="paran.com"   >paran.com      </option>
	                            <option value="yahoo.co.kr" >yahoo.co.kr    </option>
	                        </select>
						</div>
                    </td>
                </tr>
            </table>
            </div>
         </div><!-- //title_frame -->
         <div class="title_frame">
            <div class="title_btn_frame clearfix" style="padding-bottom: 10px;">
            	<div class="title_btn_inner">
                </div>
            </div>
            <p><a href="#" class="btnToggle_table">세금계산서 담당자 정보</a></p>
            <div class="table_typeA gray">
            <table style="table-layout:fixed;">
                <caption class="blind">Header</caption>
                <colgroup>
                    <col width="13%" />
                    <col width="37%" />
                    <col width="13%" />
                    <col width="37%" />
                </colgroup>
                <tr>
                    <td><label for="TAX_MANAGER_NM">담당자명</label></td>
                    <td><input type="text" name="TAX_MANAGER_NM" id="TAX_MANAGER_NM" <attr:length value='30'/> class="td_input"></td>
                    <td><label for="TAX_MANAGE_DEPT">담당부서</label></td>
                    <td><input type="text" name="TAX_MANAGE_DEPT" id="TAX_MANAGE_DEPT" <attr:length value='35'/> class="td_input"></td>
                </tr>
                <tr>
                    <td><label for="TAX_MANAGER_EMAIL1">담당자 이메일</label><label for="TAX_MANAGER_EMAIL2" style="display: none;">세금계산서 담당자 이메일 도메인</label>
                    	<label for="TAX_MANAGER_EMAIL_SELECT" style="display: none;">세금계산서 담당자 이메일 도메인 선택</label>
                    </td>
                    <td colspan="3">
                    	<div class="email">
							<input type="text" class="td_input" name="TAX_MANAGER_EMAIL1" id="TAX_MANAGER_EMAIL1" <attr:length value='25'/> style="ime-mode:disabled;"/>
							<span>@</span>
							<input type="text" class="td_input" name="TAX_MANAGER_EMAIL2" id="TAX_MANAGER_EMAIL2" <attr:length value='25'/> style="ime-mode:disabled;width:130px;"/>
							<select name="TAX_MANAGER_EMAIL_SELECT" id="TAX_MANAGER_EMAIL_SELECT" class="td_input">
	                            <option value=""            >직접입력       </option>
	                            <option value="chollian.net">chollian.net   </option>
	                            <option value="dreamwiz.com">dreamwiz.com   </option>
	                            <option value="empal.com"   >empal.com      </option>
	                            <option value="freechal.com">freechal.com   </option>
	                            <option value="gmail.com"   >gmail.com      </option>
	                            <option value="hanafos.com" >hanafos.com    </option>
	                            <option value="hanmail.net" >hanmail.net    </option>
	                            <option value="hotmail.com" >hotmail.com    </option>
	                            <option value="korea.com"   >korea.com      </option>
	                            <option value="nate.com"    >nate.com       </option>
	                            <option value="naver.com"   >naver.com      </option>
	                            <option value="paran.com"   >paran.com      </option>
	                            <option value="yahoo.co.kr" >yahoo.co.kr    </option>
	                        </select>
						</div>
                    </td>
                </tr>
            </table>
            </div>
         </div><!-- //title_frame -->
       </div>
    </form>
    
</div>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>
