package kr.pe.frame.exp.sta.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.service.CommonService;

/**
 * 수출실적 & 현황 조회 Service
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
@Service("staService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class StaServiceImpl implements StaService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonService")
    private CommonService commonService;
    
	@Override
	public AjaxModel selectExpStaReqList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	public AjaxModel selectExpStaReq(AjaxModel model) {
		return commonService.select(model);
	}

	@Override
	public AjaxModel saveExpStaReq(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		
		AjaxModel itemModel = new AjaxModel();
		if(!StringUtils.isEmpty((String) param.get("REQ_NO"))) {	// 수정불가 체크
			param.put("qKey", "imp.selectImpReq");
			param.put("STATUS", "RR");
			
			itemModel.setData(param);
			
			AjaxModel rst  = commonService.select(itemModel);
			
			if(rst.getData() != null) {
				model.setMsg((String) param.get("ERR_MSG"));
				throw new BizException(model);
			}
			
			param.put("qKey", "imp.updateImpReq");
			itemModel.setData(param);

			commonService.update(model);
		} else {
			param.put("qKey", "imp.insertImpReq");
			itemModel.setData(param);

			commonService.insert(model);
		}
		
		List modelItems = (List) param.get("MODEL_ITEMS");
		for(int i = 0; modelItems != null && i < modelItems.size(); i++) {
			Map item = (Map) modelItems.get(i);
			item.put("qKey", "imp.updateImpReqItem");
			itemModel.setData(item);
			
			commonService.insert(itemModel);
		}
		
        return model;
	}
}
