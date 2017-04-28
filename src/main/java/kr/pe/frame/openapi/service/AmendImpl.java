package kr.pe.frame.openapi.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.service.AsyncService;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.exp.dec.service.ModService;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.util.StringUtil;

@Service("amendService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class AmendImpl extends OpenAPIService {
	@Resource(name = "modService")
    private ModService modService;
	
	@Resource(name = "commonService")
    private CommonService commonService;
	
	@Autowired
    AsyncService asyncService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		//docListChecker.put("MallId"       				, new CheckInfo().setVARCHAR("35" 	, true));  //  M	VARCHAR(35)	몰ID
		docListChecker.put("SellerPartyId"       		, new CheckInfo().setVARCHAR("35" 	, false)); 	//  O	VARCHAR(35)	판매자ID(몰)
		docListChecker.put("SellerPartyRegistNo"       	, new CheckInfo().setVARCHAR("10" 	, true));  	//  M	VARCHAR(10)	판매자 사업자등록번호
		docListChecker.put("OrderNo"       				, new CheckInfo().setVARCHAR("50" 	, true));  	//  M	VARCHAR(50)	주문번호
		docListChecker.put("RequestType"       			, new CheckInfo().setVARCHAR("1" 	, true));  	//  M	VARCHAR(1)	요청구분구분
		docListChecker.put("ApplicationType"       		, new CheckInfo().setCODE(true));  				//  M	VARCHAR(1)	신청구분=고정
		docListChecker.put("AmendReasonCode"       		, new CheckInfo().setCODE(true, "openapi.codecheck.AmendReasonCode29"));  				//  M	VARCHAR(2)	취하사유코드
		docListChecker.put("ReasonsAttributableCode"    , new CheckInfo().setCODE(true));  				//  M	VARCHAR(1)	귀책사유코드
		docListChecker.put("AmendReason"       			, new CheckInfo().setVARCHAR("200"  , true));  	//  M	VARCHAR(200)정정사유
		docListChecker.put("ExportDeclarationNo"       	, new CheckInfo().setVARCHAR("15" 	, true));  	//  M	VARCHAR(15)	수출신고번호
		//docListChecker.put("AmendItemNo"       			, new CheckInfo().setVARCHAR("18"   , false)); //  O	INTEGER		정정항목수
		docListChecker.put("CustomsCode"       			, new CheckInfo().setCODE(false)); 				//  O	VARCHAR(3)	세관
		docListChecker.put("CustomsDeptCode"       		, new CheckInfo().setCODE(false)); 				//  O	VARCHAR(2)	과
		docListChecker.put("ApplicationDate"       		, new CheckInfo().setVARCHAR("8" 	, false)); 	//  O	VARCHAR(8)	신고일자
		docListChecker.put("ApplicationPartyCeoName"    , new CheckInfo().setVARCHAR("12" 	, false)); 	//  O	VARCHAR(12)	신고자대표자명
		docListChecker.put("ApplicationCompanyName"     , new CheckInfo().setVARCHAR("28" 	, false)); 	//  O	VARCHAR(28)	신고자상호
		docListChecker.put("ExportPartyName"       		, new CheckInfo().setVARCHAR("28" 	, false)); 	//  O	VARCHAR(28)	수출자성명
		docListChecker.put("ExportPartyCustomsId"       , new CheckInfo().setVARCHAR("15" 	, false)); 	//  O	VARCHAR(15)	수출자통관고유부호
		docListChecker.put("ExportPartyDeclarationId"   , new CheckInfo().setCODE(false, "openapi.codecheck.CustomsUseApplicantID")); //  O	VARCHAR(5)	판매자신고인부호
		docListChecker.put("AmendRequestTerms"   		, new CheckInfo().setVARCHAR("500" 	, false)); 	//  O	VARCHAR(500)정정요청내용
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
		
		String reqNo = "";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> records = null;
		Map<String, Object> recordsMap = null;
		
		try {
			paramMap = new HashMap<String, Object>();
			
			/**
			 * 정보를 INSERT , reqId를 생성
			 */
			Map mainMap = null;
			
			String mallId = (String) in.get("MallId");
			String orderNo = (String) in.get("OrderNo");
			String exportDeclarationNo = (String) in.get("ExportDeclarationNo");
			String typeCode = (String) in.get("ApplicationType"); //A정정B취하C적재기한연장

			//취하요청인 경우 order no에 해당되는 수출신고(취하)요청을 체크한다.
			if ("B".equals(typeCode)){
				paramMap = new HashMap<String, Object>();
				paramMap.put("MALL_ID", mallId);
				paramMap.put("ORDER_ID", orderNo);
				paramMap.put("REFERENCEID", exportDeclarationNo);
				records = dao.list("openapi.dec.selectExpModInfoByOrderNo", paramMap);
				if (records != null && records.size() > 0){
					recordsMap = (HashMap<String, Object>) records.get(0);
					String modiReqStatus = (String) recordsMap.get("STATUS");
					if ( "02".equals(modiReqStatus)){	//정정생성오류('AAA1006')
						//이전 취하신고가 오류나 오류통보인 경우가 아니면 재수신으로 처리
					}else{
						throw new BizException("먼저 수신된 취하요청정보가 있습니다.");
					}
				}
			}
			
			//수출신고서의 최종 상태를 확인하여 수리상태일때만 처리한다.
			paramMap = new HashMap<String, Object>();
			paramMap.put("MALL_ID", mallId);
			paramMap.put("ORDER_ID", orderNo);
			paramMap.put("REFERENCEID", exportDeclarationNo);
			records = dao.list("openapi.dec.selectExpDecInfo", paramMap);
			if (records!=null && records.size()>0){
				recordsMap = (HashMap<String, Object>) records.get(0);
				// EXP_EXPDEC_REQ의 STATUS 상태를 확인
				String decRece = (String) recordsMap.get("STATUS");
				if (!"03".equals(decRece) ){	//'AAA1002'
					//조회된 수출신고서의 상태가 수리상태가 아니면 취하할 수 없음.
					throw new BizException("수출신고서가 수리 상태가 아니므로 정정/취하 할 수 없습니다.");
				}
			}else{
				throw new BizException("주문번호와  수출신고번호를 다시 확인해 주십시요.");
			}
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			reqNo = formatter.format(new Date())+"_"+in.get("OrderNo");
			//reqNo = DateUtil.getDateTime()+"_"+orderNo;
			
			String status = "";
			String autoDeclaration =  "";
			String applicationType = (String) in.get("ApplicationType");
			
			//정정은 관세사에게 요청메일
			if ("A".equals(applicationType)){
				status = "03";	//관세사의뢰('AAA1006')
				
				//판매자신고인부호로 관세사 메일주소 찾기
				paramMap = new HashMap<String, Object>();
				paramMap.put("APPLICANT_ID", (String) in.get("ExportPartyDeclarationId"));
				String receiver = (String) dao.select("mod.selectApplicantMail", paramMap);
				if(StringUtil.isEmpty(receiver)){
					out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
					out.put(ERROR_DESCRIPTION	, "판매자신고인부호가 정확하지 않습니다.");
					return;
				}
				
				Map<String, Object> mailParam = new HashMap<String, Object>();
				String title    = "goGlobal 요청관리번호[" + reqNo + "]의 수출신고정정 의뢰합니다.";
		        String vmName   = "decmod_req_mail.html";
		        mailParam.put("REQ_NO", reqNo);
		        try {
					//commonService.sendSimpleEMail(receiver, title, vmName, mailParam);
		        	asyncService.asyncSendSimpleMail(DocUtil.decrypt(StringUtils.defaultIfEmpty(receiver, "")), title, vmName, mailParam);
					out.put("OrderNo"	, in.get("OrderNo"));
					out.put("RequestNo"	, reqNo);
				} catch (Exception e) {
					out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
					out.put(ERROR_DESCRIPTION	, e.getMessage());
				}	
			}
			
			//취하는 자동신고처리
			if ("B".equals(applicationType)){
				status = "01";		//수출정정생성('AAA1006')
				autoDeclaration = "Y";
			}
			
			in.put("STATUS", status);
			
			mainMap = makeMain(in);
			mainMap.put("REQ_NO"		, reqNo);						//요청관리번호
			mainMap.put("REG_ID"		, (String) in.get("MallId"));	//등록자ID
			mainMap.put("MOD_ID"		, (String) in.get("MallId"));	//수정자ID
			mainMap.put("REGIST_METHOD"	, "API");						//등록구분
			
			dao.insert("openapi.dec.insertExpModReq", mainMap);

			if ("Y".equals(autoDeclaration)){
				try {
					//정정신고 생성
					paramMap = new HashMap<String, Object>();
					paramMap.put("REQ_NO", reqNo);
					paramMap.put("SEND_CHECK", autoDeclaration);
					paramMap.put("RPT_NO", exportDeclarationNo);
					modService.createExpModiDoc(paramMap, out);
					
				} catch (Exception e){
					out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
					out.put(ERROR_DESCRIPTION	, e.getMessage());
					return;
					
				}
			}
		} catch (BizException be){
			out.put(RESULT_TYPE_CODE	, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION	, be.getMessage());
			return;
		}
	}
	
	private Map<String, Object> makeMain(Map<String, Object> in){

		// 입력필드 확인설정 MAP
		Map<String, Object> mainMap = new HashMap<String, Object>();
		
		mainMap.put("STATUS",              (String) in.get("STATUS")                  );     //상태
		mainMap.put("MALL_ID",             (String) in.get("MallId")                  );     //몰ID
		mainMap.put("SELLER_ID",           (String) in.get("SellerPartyId")           );     //판매자ID
		mainMap.put("ORDER_ID",            (String) in.get("OrderNo")                 );     //주문번호
		mainMap.put("REQUEST_DIV",         (String) in.get("RequestType")             );     //요청구분 : 신규/수정, 신고서전송S
		mainMap.put("TYPECODE",            (String) in.get("ApplicationType")         );     //송신구분 : A정정, B취하, C적재기한연장
		mainMap.put("AMENDTYPECD",         (String) in.get("AmendReasonCode")         );     //정정사유코드
		mainMap.put("OBLIGATIONREASONCD",  (String) in.get("ReasonsAttributableCode") );     //귀책사유
		mainMap.put("AMENDREASON",         (String) in.get("AmendReason")             );     //정정사유
		mainMap.put("REFERENCEID",         (String) in.get("ExportDeclarationNo")     );     //수출신고번호
		mainMap.put("OFFICECODE",          (String) in.get("CustomsCode")             );     //세관
		mainMap.put("DEPARTMENTCODE",      (String) in.get("CustomsDeptCode")         );     //과
		mainMap.put("ISSUEDATETIME",       (String) in.get("ApplicationDate")         );     //신고일자
		mainMap.put("AGENTREPNAME",        (String) in.get("ApplicationPartyCeoName") );     //신고자대표자명
		mainMap.put("AGENTNAME",           (String) in.get("ApplicationCompanyName")  );     //신고자상호
		mainMap.put("EXPORTERNAME",        (String) in.get("ExportPartyName")         );     //수출자성명
		mainMap.put("EXPORTERTGNO",        (String) in.get("ExportPartyCustomsId")    );     //수출자통관고유부호
		mainMap.put("APPLICANTPARTYORGID", (String) in.get("ExportPartyDeclarationId"));     //신고인부호
		mainMap.put("MODI_CONTENTS",       (String) in.get("AmendRequestTerms")       );     //정정요청내역
		mainMap.put("BIZ_NO",              (String) in.get("SellerPartyRegistNo")     );     //사업자등록번호

		// 입력필드 확인설정 MAP 반환
		return mainMap;
	}

	
}
