package kr.pe.frame.exp.dec.service;

import kr.pe.frame.adm.edi.service.EdiService;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.cmm.util.StringUtil;

import org.apache.commons.collections.MapUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jjkhj on 2017-03-03.
 */
@Service("modService")
public class ModServiceImpl implements ModService {
    @Resource(name = "decService")
    private DecService decService;
    
    @Resource(name = "ediService")
    private EdiService ediService;
    
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
	 * 수출정정신고 생성처리
	 * 수출정정요청정보에서 주문번호 등으로 수출신고정보를 조회하여 취하/정정신청서를 생성
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public void createExpModiDoc(Map<String, Object> inVar, Map<String, Object> outVar) throws Exception {
		
		Map<String, Object> modiDec = new HashMap<String, Object>();	//신고서 메인 결과셋
		Map<String, Object> modiDecItem = new HashMap<String, Object>(); //신고서 항목 결과셋
		String errMsg = "";
		String errJSON = "";
		String status = "";
		
		String reqNo = "";
		String rptNo = "";
		String modi_seq = "";
		
		Map modiReq = null;  //정정요청신고서 정보
		Map expDec  = null;  //수출신고정보
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> records = null;
		Map<String, Object> recordsMap = null;
		String sendCheck = "";
		try {
			//수출신고정정정보 조회
			reqNo = StringUtil.null2Str(inVar.get("REQ_NO"));
			sendCheck = StringUtil.null2Str(inVar.get("SEND_CHECK"));
			rptNo = StringUtil.null2Str(inVar.get("RPT_NO"));
			paramMap = new HashMap<String, Object>();
			paramMap.put("REQ_NO", reqNo);
			modiReq = ( Map<String, Object>) commonDAO.select("mod.selectExpModInfo" , paramMap); //REQ_NO로 TB_EXPMOD_REQ를 Select
			
			if (MapUtils.isEmpty(modiReq)) {
				throw new BizException("정정요청이 없음.");
			}

			String requestType = (String) modiReq.get("REQUEST_DIV");  	//요청구분 S이면 전체신고서 정보로 판단
			String applicationType = (String) modiReq.get("TYPECODE"); 	//A:정정, B:취하, C:적재기한연장
			//String rptNo = (String) modiReq.get("REFERENCEID"); 	//수출신고번호
			
			//신고서정보전체를 API로 호출한 경우에는 입력된 정보 그대로 신고서 생성
			if( "S".equals(requestType) ) { 
				//신고인정보에서 통관고유부호, 신고인명등을 가져와서 값이없는 경우 기본값으로 사용한다.
				Map<String, Object> sellerInfo = null;
				paramMap = new HashMap<String, Object>();
				paramMap.put("BIZ_NO", modiReq.get("BIZ_NO"));
				sellerInfo = (Map<String, Object>) commonDAO.select("usr.selectUser", paramMap);
				
				modiDec.put("CUSTOMORGANIZATIONID"		, modiReq.get("OFFICECODE"));
				modiDec.put("CUSTOMDEPARTMENTID"		, modiReq.get("DEPARTMENTCODE"));
				modiDec.put("REFERENCEID"				, modiReq.get("REFERENCEID"));
				modiDec.put("ISSUEDATETIME"				, modiReq.get("ISSUEDATETIME"));
				modiDec.put("AGENTREPNAME"				, DocUtil.isEmptyReplace((String) modiReq.get("AGENTREPNAME"), (String) sellerInfo.get("BOSS_NM")));
				modiDec.put("AGENTNAME"					, DocUtil.isEmptyReplace((String) modiReq.get("AGENTNAME"),    (String) sellerInfo.get("SELLER_NM")));
				modiDec.put("EXPORTERNAME"				, DocUtil.isEmptyReplace((String) modiReq.get("EXPORTERNAME"), (String) sellerInfo.get("SELLER_NM")));
				modiDec.put("EXPORTERTGNO"				, DocUtil.isEmptyReplace((String) modiReq.get("EXPORTERTGNO"), (String) sellerInfo.get("TG_NO")));
				modiDec.put("EXPORTPARTYDECLARATIONID"	, DocUtil.isEmptyReplace((String) modiReq.get("APPLICANTPARTYORGID"), (String) sellerInfo.get("APPLICANT_ID")));

				modiDec.put("TYPECODE"					, modiReq.get("TYPECODE"));
				modiDec.put("AMENDTYPECD"				, modiReq.get("AMENDTYPECD"));
				modiDec.put("AMENDREASON"				, modiReq.get("AMENDREASON"));
				modiDec.put("OBLIGATIONREASONCD"		, modiReq.get("OBLIGATIONREASONCD"));
			
			//기존 신고서정보에서 생성
			}else{ 
				//MallID, SellerId, OrderId로 EXP_expdec_req를 조회해서 해당 req_no로 컬럼 맞춰서 insert
				paramMap = new HashMap<String, Object>();
				paramMap.put("MALL_ID", modiReq.get("MALL_ID"));
				paramMap.put("SELLER_ID", modiReq.get("SELLER_ID"));
				paramMap.put("ORDER_ID", modiReq.get("ORDER_ID"));

				records = commonDAO.list("openapi.dec.selectExpDecInfo", paramMap); //MALL_ID, SELLER_ID, ORDER_ID로 EXP_EXPDEC_REQ를 Select
				
				if ( records != null && records.size() > 0 ) {
					expDec = (HashMap<String, Object>)records.get(0);
				}else{
					throw new BizException("수출신고정보가 없음");
				}

				modiDec.put("REFERENCEID"				, expDec.get("RPT_NO"));
				modiDec.put("RPT_SEQ"				    , expDec.get("RPT_SEQ"));
				modiDec.put("CUSTOMORGANIZATIONID"		, expDec.get("RPT_CUS"));
				modiDec.put("CUSTOMDEPARTMENTID"		, expDec.get("RPT_SEC"));
				modiDec.put("ISSUEDATETIME"				, expDec.get("RPT_DAY"));
				modiDec.put("AGENTREPNAME"				, expDec.get("RPT_BOSS_NM"));
				modiDec.put("AGENTNAME"					, expDec.get("RPT_FIRM"));
				modiDec.put("EXPORTERNAME"				, expDec.get("COMM_FIRM"));
				modiDec.put("EXPORTERTGNO"				, expDec.get("EXP_TGNO"));
				modiDec.put("EXPORTPARTYDECLARATIONID" 	, expDec.get("RPT_MARK"));
				modiDec.put("EXP_ADDR1"					, expDec.get("EXP_ADDR1"));
				modiDec.put("EXP_ADDR2" 				, expDec.get("EXP_ADDR2"));

				modiDec.put("TYPECODE"					, modiReq.get("TYPECODE"));
				modiDec.put("AMENDTYPECD"				, modiReq.get("AMENDTYPECD"));
				modiDec.put("AMENDREASON"				, modiReq.get("AMENDREASON"));
				modiDec.put("OBLIGATIONREASONCD"		, modiReq.get("OBLIGATIONREASONCD"));
				modiDec.put("EXP_PRE_NO"				, modiReq.get("RPT_NO"));	//modiReq.get("RPT_NO") 없음
			}
			
			modiDec.put("RPT_NO" , rptNo);
			modiDec.put("SEND"   , "02");
			modiDec.put("REQ_NO" , reqNo);
			modiDec.put("USER_ID", modiReq.get("MALL_ID"));
			//수출정정저장
			Map<String, Object>  mainMap = makeMain(modiDec);
			paramMap = new HashMap<String, Object>();
			paramMap.put("RPT_NO" , rptNo);
			modi_seq = (String) commonDAO.select("dec.selectExpDmrModiSeq", paramMap);
			mainMap.put("MODI_SEQ" , modi_seq);
			commonDAO.insert("dec.insertExpDmr5as", mainMap);
			
			if (!"B".equals(applicationType)) {	//취하가 아닐때 상세항목 생성
				//정정신고 항목생성
				paramMap = new HashMap<String, Object>();
				paramMap.put("REQ_NO", reqNo);
				records = commonDAO.list("mod.selectExpModItemInfo", paramMap);
				
				if ( records != null && records.size() > 0 ){
					String itemNo = "";
					String modItemNm = "";
					for (int i=0;i<records.size();i++){
						itemNo = DocUtil.lpadbyte("" + (i+1), 2, "0");
						recordsMap =  records.get(i);
						
						modiDecItem = new HashMap<String, Object>();
						modiDecItem.put("RPT_NO", rptNo);
						modiDecItem.put("SEQ_NO", itemNo);
						modiDecItem.put("LINEITEMNO", recordsMap.get("LINENUMBERID"));
						modiDecItem.put("SPECIFICATIONNO", recordsMap.get("GOODSIDENTIFICATIONID"));
						modiDecItem.put("AMENDITEMNO", recordsMap.get("AMENDITEMNO"));

						paramMap.put("MOD_ITEM_NO", recordsMap.get("AMENDITEMNO"));
						modItemNm = (String) commonDAO.select("mod.selectModItemNm", paramMap);
						modiDecItem.put("ITEM_NM", modItemNm);
						
						modiDecItem.put("BEFOREDESCRIPTION", recordsMap.get("BEFOREDESCRIPTION"));
						modiDecItem.put("AFTERDESCRIPTION", recordsMap.get("AFTERDESCRIPTION"));
						
						Map<String, Object>  itemMap  = makeItem(modiDecItem);
						
						commonDAO.insert("dec.insertExpDmr5asItem", itemMap);
					}
				}
			}
			status = "01";
		} catch (BizException be){
			be.printStackTrace();
			status = "02";
		}

		//요청정보에 status 업데이트
		paramMap = new HashMap<String, Object>();
		paramMap.put("REQ_NO", reqNo);
		paramMap.put("STATUS", status);
		paramMap.put("ERROR_DESC", errMsg);
		commonDAO.update("mod.updateExpModiReqStatus", paramMap);
		
		//자동전송여부가 'Y' 이면 자동으로 수출신고서를 전송한다.
		if("Y".equals(sendCheck)){
			Map<String, Object> in = new HashMap<String, Object>();
			List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>(); 
			AjaxModel model = new AjaxModel();
			in.put("USER_ID"  , modiReq.get("MALL_ID"));
			in.put("TYPE"     , "ECC");
			Map<String, Object> IdenInfo = (Map<String, Object>) commonDAO.select("dec.selectCmmIdentifier", in);
			
			if (MapUtils.isEmpty(IdenInfo)) {
				
				throw new BizException(modiReq.get("MALL_ID")+"에 해당하는 식별자 정보가 없습니다.");
			}
			
			in.put("REQ_KEY", rptNo+"_"+modi_seq);
			in.put("SNDR_ID", IdenInfo.get("IDENTIFY_ID"));
			in.put("RECP_ID", "KCS4G001");
			in.put("DOC_TYPE", "GOVCBR5AS");
			in.put("USER_ID", modiReq.get("MALL_ID"));
			in.put("RPT_NO", rptNo);
			in.put("MODI_SEQ", modi_seq);
			paramList.add(in);
			model.setDataList(paramList);
			try {
				saveExpDmrSend(model);
			} catch (BizException e) {
				in = new HashMap<String, Object>();
				in.put("USER_ID", modiReq.get("MALL_ID"));
				in.put("SEND", "90");
				commonDAO.update("mod.updateExpDmrSend", in);
				throw e;
			}
		}

		outVar.put("STATUS", status);
		outVar.put("ERROR_DESCRIPTION", errMsg);
		
		return;
	}
	
	private Map<String, Object> makeMain(Map<String, Object> outMap) throws Exception {
		
		Map<String, Object> mainMap = new HashMap<String, Object>();

		mainMap.put("RPT_NO",              outMap.get("REFERENCEID"));     			//수출신고번호
		mainMap.put("MODI_SEQ",            outMap.get("MODI_SEQ"));     			//정정차수
		mainMap.put("RPT_SEQ",             outMap.get("RPT_SEQ"));     				//수출신고차수
		mainMap.put("SEND",                outMap.get("SEND"));     				//전송결과
		mainMap.put("RECE",                "");     								//수신결과
		mainMap.put("RPT_CUS",             outMap.get("CUSTOMORGANIZATIONID"));    	//신청세관
		mainMap.put("RPT_SEC",             outMap.get("CUSTOMDEPARTMENTID"));     	//신청과
		mainMap.put("SEND_DIVI",           outMap.get("TYPECODE"));     			//송신구분
		mainMap.put("MODI_DAY",            outMap.get("ISSUEDATE"));     			//정정일자
		mainMap.put("RPT_DAY",             outMap.get("ISSUEDATETIME"));     		//신고일자
		mainMap.put("RPT_BOSS_NM",         outMap.get("AGENTREPNAME"));     		//신고자대표자명
		mainMap.put("RPT_FIRM",            outMap.get("AGENTNAME"));     			//신고자상호
		mainMap.put("MODI_DIVI",           outMap.get("AMENDTYPECD"));     			//정정사유코드
		mainMap.put("MODI_COT",           DocUtil.strCutArray((String) outMap.get("AMENDREASON"), 200, 1,1));     //정정사유1
		mainMap.put("DUTY_CODE",           outMap.get("OBLIGATIONREASONCD"));     	//귀책사유코드
		mainMap.put("EXP_FIRM",            outMap.get("EXPORTERNAME"));     		//수출자성명
		mainMap.put("EXP_TGNO",            outMap.get("EXPORTERTGNO"));     		//통관고유부호
		mainMap.put("RPT_MARK",            outMap.get("EXPORTPARTYDECLARATIONID"));//신고인부호
		mainMap.put("REQ_NO",              outMap.get("REQ_NO"));     				//정정요청관리번호
		mainMap.put("EXP_ADDR1",           outMap.get("EXP_ADDR1"));     			//주소1
		mainMap.put("EXP_ADDR2",           outMap.get("EXP_ADDR2"));     			//주소2
		mainMap.put("USER_ID",             outMap.get("USER_ID"));     				//등록자ID
		mainMap.put("USER_ID",             outMap.get("USER_ID"));     				//수정자ID

		return mainMap;
	}
	
	private Map<String, Object> makeItem(Map<String, Object> outMap) throws Exception {

		Map<String, Object> itemMap = new HashMap<String, Object>();

		itemMap.put("RPT_NO",              outMap.get("RPT_NO")              );   //신청번호
		itemMap.put("SEQ_NO",              outMap.get("SEQ_NO")              );   //순번
		itemMap.put("RAN_NO",              outMap.get("LINEITEMNO")          );   //란번호
		itemMap.put("SIZE_NO",             outMap.get("SPECIFICATIONNO")     );   //규격번호
		itemMap.put("ITEM_NO",             outMap.get("AMENDITEMNO")         );   //항목번호
		itemMap.put("ITEM_NM",             outMap.get("ITEM_NM")             );   //항목명
		itemMap.put("MODIFRONT",           outMap.get("BEFOREDESCRIPTION")   );   //정정전내역
		itemMap.put("MODIAFTER",           outMap.get("AFTERDESCRIPTION")    );   //정정후내역
		itemMap.put("USER_ID",             outMap.get("USER_ID")             );   //등록자ID
		itemMap.put("USER_ID",             outMap.get("USER_ID")             );   //수정자ID

		return itemMap;
	}
	
	/**
	 * 수출정정 전송
	 */
	@Override
	public AjaxModel saveExpDmrSend(AjaxModel model) throws Exception {
		List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }
        
        model = ediService.sendDoc(model);
        
        for(Map<String, Object> param : dataList){
        	param.put("SEND", "02");
            commonDAO.update("mod.updateExpDmrSend", param);
        }

        return model;
	}
	

}
