package kr.pe.frame.basic.cust.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.basic.deft.service.DeftService;

/**
 * 사용자 화면: 기초정보 > 거래처 관리 구현 클래스
 * @author 정안균
 * @since 2017-03-06
 * @version 1.0
 * @see DeftService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.06  정안균  최초 생성
 *
 * </pre>
 */
@Service(value = "custService")
public class CustServiceImpl implements CustService {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "commonDAO")
    private CommonDAO commonDAO;

	@Override
	public AjaxModel saveCust(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		String saveMode = StringUtils.defaultIfEmpty((String)param.get("SAVE_MODE"),"");
		if(StringUtils.isNotEmpty((String)param.get("MANAGER_EMAIL1")) && StringUtils.isNotEmpty((String)param.get("MANAGER_EMAIL2"))){
        	String email = (String)param.get("MANAGER_EMAIL1") + "@" + (String)param.get("MANAGER_EMAIL2");
            param.put("MANAGER_EMAIL", email);
        }
		if(StringUtils.isNotEmpty((String)param.get("TAX_MANAGER_EMAIL1")) && StringUtils.isNotEmpty((String)param.get("TAX_MANAGER_EMAIL2"))){
        	String email = (String)param.get("TAX_MANAGER_EMAIL1") + "@" + (String)param.get("TAX_MANAGER_EMAIL2");
            param.put("TAX_MANAGER_EMAIL", email);
        }
		
		param.put("MOD_ID", model.getUsrSessionModel().getUserId());
	    param.put("REG_ID", model.getUsrSessionModel().getUserId());
	        
        // 추가
        if("I".equals(saveMode)){
        	Map<String, Object> result = (Map<String, Object>)commonDAO.select("cust.selectCust", param);
            if(result != null){
                model.setCode("W00000001"); //중목된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("cust.insertCmmCust", param);
            model.setCode("I00000003"); //저장되었습니다.


        }else if("U".equals(saveMode)){
            commonDAO.insert("cust.updateCmmCust", param);
            model.setCode("I00000005"); //수정되었습니다.
        }
        
        model.setData(param);
        return model;
	}

	@Override
	public AjaxModel deleteCustList(AjaxModel model) throws Exception {
        List<Map<String, Object>> dataList = model.getDataList();
        for(Map<String, Object> param : dataList){
            commonDAO.delete("cust.deleteCustList", param);
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;

	}
}
