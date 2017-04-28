package kr.pe.frame.apiguide.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.api.service.ApiService;
import kr.pe.frame.cmm.core.model.AjaxModel;

/**
 * 포털 > API관리 Service
 * @author 정안균
 * @since 2017-03-30
 * @version 1.0
 * @see ApiguideServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.30  정안균  최초 생성
 *
 * </pre>
 */
@Service(value = "apiguideService")
public class ApiguideServiceImpl implements ApiguideService {
	Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;
    
    @Resource(name = "apiService")
    private ApiService apiService;
    
	@Override
	public AjaxModel selectCmmApiKeyMng(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		if(model.getUsrSessionModel() != null) {
			param.put("USER_ID", model.getUsrSessionModel().getUserId());
			Map<String, Object> result = (Map<String, Object>)commonDAO.select("apiguide.selectCmmApiKeyMng", param);
			List<Map<String, Object>> detailList = commonDAO.list("apiguide.selectCmmApiKeyDetailList", result);
				
			model.setData(result);
			model.setDataList(detailList);
		}
       
		return model;
	}

	@Override
	public AjaxModel saveCmmApiKeyMng(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("USER_ID", model.getUsrSessionModel().getUserId());
		commonDAO.insert("apiguide.insertCmmApiKeyMng", param);
		model.setCode("I00000036"); //KEY 발급 요청을 완료 하였습니다.
		return model;
	}

	@Override
	public AjaxModel selectApiInfo(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		Map<String, Object> result = (Map<String, Object>)commonDAO.select("api.selectCmmApiMng", param);
		Map<String, Object> retMap = new HashMap<>();
		retMap.put("apiInfo", result);
		model.setData(retMap);
		
		param.put("P_JSON_TYPE", "REQ");
        List<Map<String, Object>> reqTreeList = apiService.getApiTreeList(param);
	    retMap.put("reqTreeList", reqTreeList);   // 트리
	    retMap.put("REQ_MAX_LVL", reqTreeList.size() > 0 ? reqTreeList.get(reqTreeList.size()-1).get("LVL") : 0);
	    retMap.put("reqTreeJson", apiService.getApiSampleJson(reqTreeList)); // 샘플 JSON
		
		param.put("P_JSON_TYPE", "RES");
		List<Map<String, Object>> resTreeList = apiService.getApiTreeList(param);
	    retMap.put("resTreeList", resTreeList);   // 트리
	    retMap.put("RES_MAX_LVL", resTreeList.size() > 0 ? resTreeList.get(resTreeList.size()-1).get("LVL") : 0);   // 트리
	    retMap.put("resTreeJson", apiService.getApiSampleJson(resTreeList)); // 샘플 JSON

		return model;
	}

}
