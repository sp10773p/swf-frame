package kr.pe.frame.openapi.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.openapi.model.DataType;
import kr.pe.frame.openapi.model.ErrorDescription;

/**
 * OPEN API 처리 공통 최상위 클래스
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@SuppressWarnings({"unchecked", "rawtypes"})
public abstract class OpenAPIService {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
	public static final String API_HEADER_KEY = "api_consumer_key";
	
	public static final String TOTAL_COUNT = "TotalCount";
	public static final String ERROR_COUNT = "ErrorCount";
	public static final String RESULT_LIST = "ResultList";	
	
	public static final String RESULT_TYPE_CODE = "ResultTypeCode";
	public static final String ERROR_DESCRIPTION = "ErrorDescription";
	public static final String ERROR_DETAIL = "ErrorDetail";
	
    @Value("#{config['openapi.cuncurrent.user.cnt.limit']}")
    private String CONCURRENT_USER_CNT_LIMIT;
    
    private static final int DEFAULT_CONCURRENT_USER_CNT_LIMIT = 10;	
	
    @Resource(name = "commonDAO")
	protected CommonDAO dao;
    
    @Resource(name = "commonService")
    CommonService cService;
    
    @Resource(name = "sqlSessionTemplate")
    SqlSessionTemplate sqlSession;
	
	public String isValidClient(String apiKey, String apiId, Map imParam) throws Exception {
		Map keyInfo = (Map) dao.select("openapi.selectApiKeyInfo", apiKey);
		if(keyInfo == null) {
			throw new BizException(ErrorDescription.UNAUTHORIZED_REQUEST.toString());
		}	
		
		List<Map> docList = (List<Map>)imParam.get("DocList");
		for(Map item : docList) {
			String userId = (String) (item.get("ExpressPartyId") != null ? item.get("ExpressPartyId") : (item.get("MallId") != null ? item.get("MallId") : item.get("SellerPartyId")));
			if(!keyInfo.get("USER_ID").equals(userId)) {
				throw new BizException(ErrorDescription.INVALID_REQUEST_DATA.toString());
			}
		}
			
		String validFromDt = (String)keyInfo.get("VALID_FROM_DT"); 
		String validToDt = (String)keyInfo.get("VALID_TO_DT");
		String currDt = (String)keyInfo.get("CURR_DATE");
		
		if (validFromDt.compareTo(currDt) > 0 || validToDt.compareTo(currDt) < 0) {
			throw new BizException(ErrorDescription.UNAUTHORIZED_REQUEST + "-" + "해당 KEY는 사용기간이 유효하지 않습니다.");
		}
		
		Map param = new HashMap();
		param.put("API_ID", apiId);
		param.put("API_KEY", apiKey);
		param.put("USER_ID", keyInfo.get("USER_ID"));
		
		Map keyDtlInfo = (Map) dao.select("openapi.selectApiKeyDtlInfo", param);
		if(keyDtlInfo == null) {
			throw new BizException(ErrorDescription.UNAUTHORIZED_REQUEST + "-" + "유효하지 않은 KEY입니다.");
		}
		
		String dailyCallCnt = String.valueOf(keyDtlInfo.get("DAILY_CALL_CNT")); 
		Map apiDailyUse = (Map) dao.select("openapi.selectDailyCnt", param);
		if (apiDailyUse == null) {
			insertDailyCnt(param);
		} else {
			String workCnt = String.valueOf(apiDailyUse.get("WORK_CNT"));
			int dailyCnt = Integer.valueOf(dailyCallCnt);
			int curCnt = Integer.valueOf(workCnt);
			
			if (dailyCnt < curCnt) {
				throw new BizException(ErrorDescription.UNAUTHORIZED_REQUEST + "-" + "1일 최대 요청 건수 제한을 초과하였습니다.");
			}
			updateDailyCnt(param);
		}

		int ccuLimit = DEFAULT_CONCURRENT_USER_CNT_LIMIT;
		try{ 
			ccuLimit = Integer.parseInt(CONCURRENT_USER_CNT_LIMIT);
		} catch(Exception e) {
			ccuLimit = DEFAULT_CONCURRENT_USER_CNT_LIMIT;
		}
		
		Map ccuCnt = (Map) dao.select("openapi.selectCCUCnt", param);
		if (ccuCnt == null) {
			insertCCUCnt(param);
		} else {
			int connectCnt = Integer.valueOf(String.valueOf(ccuCnt.get("CONNECT_CNT")));
			if (connectCnt > ccuLimit) {
				throw new BizException(ErrorDescription.UNAUTHORIZED_REQUEST + "-" + "동시 접속 제한을 초과하였습니다.");
			}
			
			param.put("INC_CNT", 1);
			updateCCUCnt(param);
		}
		
		return (String) keyInfo.get("USER_ID");
	}
	
	public void insertDailyCnt(Map param) {
		dao.insert("openapi.insertDailyCnt", param);
	}
	
	public void updateDailyCnt(Map param) {
		dao.update("openapi.updateDailyCnt", param);
	}
	
	public void insertCCUCnt(Map param) {
		dao.insert("openapi.insertCCUCnt", param);
	}
	
	public void updateCCUCnt(Map param) {
		dao.update("openapi.updateCCUCnt", param);
	}
    
	public void checkValidation(String apiId, Map<String,Object> in) throws Exception {
		if(this.getCheckers() != null) {
			this.checkValidation(apiId, in, this.getCheckers(), "");
		}
	}
	
	// 코드와 Legnth만 체크
	private void checkValidation(String apiId, Map<String,Object> in, Map<String,CheckInfo> checkers, String parentItem) throws Exception {
		for(String k : checkers.keySet()) {
			Object v = in.get(k);
			
			v = getStringValueIfPossible(v);
			
			CheckInfo c = checkers.get(k);
			String km = StringUtils.isEmpty(parentItem) ? k : parentItem + "." + k;
			if(c.getDataType() == DataType.CODE && !StringUtils.isEmpty(v)) {
				
				if(!isValideCode(apiId, k, c, (String) v)) {	// 코드가 존재하지 않으면
					throw new BizException(km + " 항목의 값이 유효한 코드가 아닙니다. 입력 DATA [" + v + "]");
				}
			} else if(c.getDataType() == DataType.VARCHAR && !StringUtils.isEmpty(v)) {
				if(((String) v).getBytes("EUC-KR").length > Integer.parseInt(c.getLength())) {	// Length 초과
					throw new BizException(km + " 항목의 길이가 기준을 초과되었습니다. 입력 Data [" + v 
							+ "] 입력된 길이[" + ((String) v).getBytes("EUC-KR").length
							+ "] API 정의된 길이[" + c.getLength() + "]");
				}
			} else if(c.getDataType() == DataType.NUMERIC && !StringUtils.isEmpty(v) && c.getLength().indexOf(",") == -1) {	// 소수점 없는 숫자
				if(((String) v).indexOf(".") != -1 || ((String) v).getBytes("EUC-KR").length > Integer.parseInt(c.getLength())) {
					throw new BizException(km + " 항목의 길이가 기준을 초과되었습니다. 입력 Data [" + v 
							+ "] 입력된 길이[" + ((String) v).getBytes("EUC-KR").length
							+ "] API 정의된 길이[" + c.getLength() + "]");
				}
			} else if(c.getDataType() == DataType.NUMERIC && !StringUtils.isEmpty(v) && c.getLength().indexOf(",") != -1) {	// 소수점 있는 숫자
				int iv = ((String) v).indexOf('.');
				iv = (iv == -1 ? ((String) v).length() : iv);
				int dv = (iv == ((String) v).length() ? 0 : ((String) v).length() - iv - 1);
				
				String cIv = c.getLength().split(",")[0];
				String dDv = c.getLength().split(",")[1];
				
				if(iv > Integer.valueOf(cIv) - Integer.valueOf(dDv) || dv > Integer.valueOf(dDv)) {
					throw new BizException(km + " 항목의 길이가 기준을 초과되었습니다. 입력 Data [" + v 
							+ "] 입력된 길이[" + ((String) v).getBytes("EUC-KR").length
							+ "] API 정의된 길이[" + c.getLength() + "]");
				}
			} else if(c.getDataType() == DataType.LIST  && v != null) {	// List 인 경우
				int idx = 0;
				for(Object item : (List)v) {
					checkValidation(apiId, (Map<String, Object>) item, c.getSubCheckers(), km + "[" + idx +"]");
					idx++;
				}
			}
		}
	}
	
	public List makeDefaultResult(List<Map> docList) throws Exception {
		List<Map> rstList = new ArrayList();
		int idx = 0;
		for(Map item : docList) {
			Map itemRst = new HashMap();
			rstList.add(itemRst);
			
			if(item.get("ExpressPartyId") != null) {
				itemRst.put("ExpressPartyId", item.get("ExpressPartyId"));
			}
			if(item.get("MallId") != null) {
				itemRst.put("MallId", item.get("MallId"));
			}
			if(item.get("SellerPartyId") != null) {
				itemRst.put("SellerPartyId", item.get("SellerPartyId"));
			}	
			itemRst.put("OrgSeq", idx);
			itemRst.put(RESULT_TYPE_CODE, ResultTypeCode.NO_ERROR.toString());
			itemRst.put(ERROR_DESCRIPTION, "");
//			itemRst.put(ERROR_DETAIL, null);
			
			idx++;
		}
		
		return rstList;
	}
	
	public void checkMandi(Map<String,String> eDtl, Map<String,Object> in) throws Exception {
		if(this.getCheckers() != null) {		
			this.checkMandi(eDtl, in, ((CheckInfo)this.getCheckers().get("DocList")).getSubCheckers(), "");
		}
	}
	
	// Mandi만 체크
	protected void checkMandi(Map<String,String> eDtl, Map<String,Object> in, Map<String,CheckInfo> checkers, String parentItem) throws Exception {
		for(String k : checkers.keySet()) {
			Object v = in.get(k);
			
			v = getStringValueIfPossible(v);
			
			CheckInfo c = checkers.get(k);
			String km = StringUtils.isEmpty(parentItem) ? k : parentItem + "." + k;
			if(c.getDataType() == DataType.LIST ) {	// List 인 경우
				if(c.isMan() && (v == null || ((List)v).size() == 0)) {
					eDtl.put(km, ErrorDescription.REQUIRED_FIELD_MSG.toString());
				} else {
					int idx = 0;
					for(Object item : (List)v) {
						checkMandi(eDtl, (Map<String, Object>) item, c.getSubCheckers(), km + "[" + idx +"]");
						idx++;
					}
				}
			} else {
				if(c.isMan()) {
					if(c.getDataType() == DataType.NUMERIC) {
						if(StringUtils.isEmpty(v) || v.equals("NULL") || v.equals("0") || v.equals("0.0")) {
							eDtl.put(km, ErrorDescription.REQUIRED_FIELD_MSG.toString());
						}
					} else {
						if(StringUtils.isEmpty(v) || v.equals("NULL")) {
							eDtl.put(km, ErrorDescription.REQUIRED_FIELD_MSG.toString());
						}
					}
				}
			}
		}
	}
	
	public Map docRecv(String apiId, String useId, List<Map> docList) throws Exception {
		List<Map> docRst = makeDefaultResult(docList);
		
		int idx = 0;
		int errorCount = 0;
		Map logParam = new HashMap();
		ObjectMapper mapper = new ObjectMapper();
		for(Map doc : docList) {
			Map rst = docRst.get(idx);
			Map<String,String> eDtl = new HashMap(); 
			checkMandi(eDtl, doc);
			
			if(!eDtl.isEmpty()) {
				rst.put(RESULT_TYPE_CODE, ResultTypeCode.UNPROCESSABLE_ENTITY.toString());
				rst.put(ERROR_DESCRIPTION, ErrorDescription.INVALID_REQUEST_DATA.toString());
				rst.put(ERROR_DETAIL, eDtl);
			} else {
				try{ 
					this.doProcess(doc, rst);
				} catch(Exception e) {
					logger.error("{}", e);
					rst.put(RESULT_TYPE_CODE, ResultTypeCode.INTERNAL_SERVER_ERROR.toString());
					rst.put(ERROR_DESCRIPTION, e.getMessage());
				}
			}
			
			String rstTypeCode = (String) rst.get(RESULT_TYPE_CODE);
			if(ResultTypeCode.isError(rstTypeCode)) {
				errorCount++;
			}
			
			logParam.clear();
			logParam.put("API_ID", apiId);
			logParam.put("USER_ID", useId);
			logParam.put("ORG_JSON", mapper.writeValueAsString(doc));
			logParam.put("ORG_SEQ", idx);
			logParam.put("RESULT_CD", (String) rst.get(RESULT_TYPE_CODE));
			logParam.put("ERROR_DESC", (String) rst.get(ERROR_DESCRIPTION));
			
			dao.insert("openapi.insertApiLogDetail", logParam);
			
			idx++;
		}
		
		Map rst = new HashMap();
		
		rst.put(TOTAL_COUNT, docRst.size());
		rst.put(ERROR_COUNT, errorCount);
		rst.put(RESULT_LIST, docRst);

		return rst;
	}
	
	private boolean isValideCode(String apiId, String eId, CheckInfo c, String v) {
		if(StringUtils.isEmpty(v)) return true;
		
		if(c.getCodes() != null && c.getCodes().length != 0) {
			for(String code : c.getCodes()) {
				if(code.equals(v)) return true;
			}
		} else {
			if(!StringUtils.isEmpty(c.getCodeQueryId())) {
				if((Integer)dao.select(c.getCodeQueryId(), v) != 0) {
					return true;
				}
			} else if(sqlSession.getConfiguration().hasStatement("openapi.codecheck." + apiId + "_" + eId)) {
				if((Integer)dao.select("openapi.codecheck." + apiId + "_" + eId, v) != 0) {
					return true;
				}
			} else {
				if((Integer)dao.select("openapi.codecheck." + eId, v) != 0) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	abstract public Map<String,CheckInfo> getCheckers();
	
	abstract public void doProcess(Map in, Map out) throws Exception;
	
	protected Object getStringValueIfPossible(Object v) {
		if(v instanceof String) {
			return ((String) v).trim();
		} else if(v instanceof Long) {
			return Long.toString((Long)v);
		} else if(v instanceof Integer) {
			return Integer.toString((Integer)v);
		} else if(v instanceof Double) {
			return Double.toString((Double)v);
		}
		
		return v;
	}
	
	protected String getStringValue(Object v) {
		v = getStringValueIfPossible(v);
		
		return v.toString();
	}
}