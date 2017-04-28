package kr.pe.frame.openapi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.openapi.model.CheckInfo;

/**
 * 반품수입 처리결과 OPEN API Service
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
@Service
@SuppressWarnings({"rawtypes", "unchecked"})
public class ImpResultImpl extends OpenAPIService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public Map<String, CheckInfo> getCheckers() {
		Map checkers = new HashMap<String, CheckInfo>();
		
		checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
		CheckInfo docList = new CheckInfo().setLIST(true);
		Map docListChecker = docList.getSubCheckers();
		checkers.put("DocList", docList);
		
		docListChecker.put("SellerPartyId", new CheckInfo().setVARCHAR("35", true));
		docListChecker.put("OrderNo", new CheckInfo().setVARCHAR("50", true));
		docListChecker.put("DocumentTypeCode", new CheckInfo().setVARCHAR("3", true));
		
		return checkers;
	}

	@Override
	public void doProcess(Map in, Map out) {
		out.put("OrderNo", in.get("OrderNo"));
		out.put("DocumentTypeCode", in.get("DocumentTypeCode"));
		
		String[] mstMapping = new String[]{
				"ImpDeclNo#RPT_NO", "Status#STATUS", "ConfirmDateTime#LIS_DAY", "TotalDeclAmount#TOT_TAX_KRW", "TotalCustomsTax#TOT_GS", "TotalValueAddedTax#TOT_VAT", "TotalTax#TOT_TAX_SUM"
		};
		Map param = new HashMap();
		param.put("SELLER_ID", in.get("SellerPartyId"));
		param.put("ORDER_ID", in.get("OrderNo"));
		
		List<Map> mst = dao.list("imp.selectImpResult_Api", param);
		
		if(mst == null || mst.size() == 0) {
			out.put(RESULT_TYPE_CODE, ResultTypeCode.BUSINESS_ERROR.toString());
			out.put(ERROR_DESCRIPTION, "주문번호(OrderNo)[" + in.get("OrderNo") + "]의 반품수입신고 정보가 존재하지 않습니다.");
			
			return;
		}
		
		for(String item : mstMapping) {
			String[] mItem = item.split("#");
			
			out.put(mItem[0], mst.get(0).get(mItem[1]));
		}
	}
}
