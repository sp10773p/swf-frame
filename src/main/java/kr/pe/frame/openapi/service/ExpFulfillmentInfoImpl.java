package kr.pe.frame.openapi.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.pe.frame.openapi.model.CheckInfo;
import kr.pe.frame.openapi.model.ResultTypeCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service()
@SuppressWarnings({ "rawtypes" })
public class ExpFulfillmentInfoImpl extends OpenAPIService {

    Logger logger = LoggerFactory.getLogger(this.getClass());

    @SuppressWarnings("unchecked")
    @Override
    public Map<String, CheckInfo> getCheckers() {
        Map checkers = new HashMap<String, CheckInfo>();

        checkers.put("DocCount", new CheckInfo().setNUMERIC(null, true));
        CheckInfo docList = new CheckInfo().setLIST(true);
        Map docListChecker = docList.getSubCheckers();
        checkers.put("DocList", docList);

        docListChecker.put("ExpressPartyId",    new CheckInfo().setVARCHAR("35", false)); //	O VARCHAR(35)
        docListChecker.put("OrderNo",           new CheckInfo().setVARCHAR("50", true));  //	M VARCHAR(50) 신청문서     : 주문번호 or 운송장번호를 기재
        docListChecker.put("OrderNoTypeCode",     new CheckInfo().setVARCHAR("1", true)); //	M VARCHAR(1)  신청문서구분 : 주문번호 A, 운송장번호 B

        return checkers;
    }

    /**
     * 수출이행신고용 정보요청
     */
    @SuppressWarnings("unchecked")
    @Override
    public void doProcess(Map in, Map out) {

        int ord = 0;

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("EXPRESS_ID", in.get("ExpressPartyId"));       // 특송사 키
        paramMap.put("ORDERNO", in.get("OrderNo"));                 // 주문번호 or 운송장번호를 기재
        paramMap.put("ORDERNOTYPECODE", in.get("OrderNoTypeCode")); // 주문번호 A, 운송장번호 B
        
        List<Map<String, Object>> fullfillmentList = dao.list("xpr.selectFullfillmentInfoAPI", paramMap);
        if (fullfillmentList.size() <= 0) {
            out.put(RESULT_TYPE_CODE, ResultTypeCode.BUSINESS_ERROR.toString());
            out.put(ERROR_DESCRIPTION, "조회된 수출이행신고용 정보가 없습니다.");
            return;
        }

        List<Map<String, Object>> outItemList = new ArrayList<Map<String, Object>>();
        out.put("OrderList", outItemList);
        
        out.put("WaybillNo", "B".equals(in.get("OrderNoTypeCode")) ? in.get("OrderNo") : "");                   // O VARCHAR(50)    운송장번호
        out.put("OrgSeq", ord);                                                                                 // M VARCHAR(50)    원본에서 해당 건이 차지하는 순번 (0-based)
        for (Map<String, Object> fullfillmentInfo : fullfillmentList) {
            Map outItem = new HashMap();
            outItem.put("OrderNo", fullfillmentInfo.get("ORDER_NO"));                                           // M VARCHAR(50)    주문번호
            outItem.put("ExpDeclNo", fullfillmentInfo.get("EXP_DECL_NO"));                                      // M VARCHAR(15)    수출신고번호
            outItem.put("ConfirmDateTime", fullfillmentInfo.get("CONFIRM_DATE_TIME"));                          // O VARCHAR(12)    수리일자
            outItem.put("TotalPackageWeight", fullfillmentInfo.get("TOTAL_PACKAGE_WEIGHT"));                    // M NUMBER(10)     총중량
            outItem.put("TotalPackageWeightUnitCode", fullfillmentInfo.get("TOTAL_PACKAGE_WEIGHT_UNIT_CODE"));  // M VARCHAR2(3)    총중량단위
            outItem.put("TotalPackageQuantity", fullfillmentInfo.get("TOTAL_PACKAGE_QUANTITY"));                // M NUMBER(6)      총포장수
            outItem.put("TotalPackageUnitCode", fullfillmentInfo.get("TOTAL_PACKAGE_UNIT_CODE"));               // M VARCHAR2(3)    총포장수단위
            outItem.put("Quantity", fullfillmentInfo.get("QUANTITY"));                                          // O NUMBER(10)     수량
            outItem.put("QuantityUnitCode", fullfillmentInfo.get("QUANTITY_UNIT_CODE"));                        // O VARCHAR2(3)    수량단위
            outItem.put("SumPacking", fullfillmentInfo.get("SUM_PACKING"));                                     // M VARCHAR(1)     동시포장 여부
            outItem.put("DivisionPacking", fullfillmentInfo.get("DIVISION_PACKING"));                           // M VARCHAR(1)     분할포장 여부
            outItem.put("InspectionTarget", fullfillmentInfo.get("INSPECTION_TARGET"));                         // M VARCHAR(1)     검사대상 여부
            outItemList.add(outItem);
        }
    }

}
