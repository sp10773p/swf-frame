package kr.pe.frame.basic.deft.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * 사용자 화면: 기본정보 > 신고서 기본값 구현 클래스
 * @author 정안균
 * @since 2017-03-02
 * @version 1.0
 * @see DeftService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.02  정안균  최초 생성
 *
 * </pre>
 */
@Service(value = "deftService")
public class DeftServiceImpl implements DeftService {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "commonDAO")
    private CommonDAO commonDAO;

	@Override
	public AjaxModel selectBaseVal(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();	
		Map<String, Object> result = new HashMap<>();
		param.put("USER_ID", model.getUsrSessionModel().getUserId());
		param.put("BIZ_NO", model.getUsrSessionModel().getBizNo());
		List<Map<String, Object>> userList = commonDAO.list("deft.selectUser", param);
		List<Map<String, Object>> baseValList = commonDAO.list("deft.selectBaseSeller", param);
		result.put("USER_INFO", userList);
		result.put("BASE_SELLER_INFO", baseValList);
		model.setData(result);
		return model;
	}

	@Override
	public AjaxModel saveBaseVal(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("USER_ID", model.getUsrSessionModel().getUserId());
		param.put("BIZ_NO", model.getUsrSessionModel().getBizNo());
		param.put("REG_ID", model.getUsrSessionModel().getUserId());
		param.put("MOD_ID", model.getUsrSessionModel().getUserId());

		commonDAO.update("deft.updateUser", param);
		commonDAO.delete("deft.deleteCmmbasevalSeller", param);
		commonDAO.insert("deft.insertCmmbasevalSeller", param);
		
		model.setCode("I00000003"); //저장되었습니다.
		return model;
	}

}
