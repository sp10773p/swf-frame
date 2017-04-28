package kr.pe.frame.basic.info.service;

import kr.pe.frame.basic.info.controller.SelController;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 기본정보 > 상품정보조회 추상 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see SelController , SelServiceImpl
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.05  성동훈  최초 생성
 *
 * </pre>
 */
@Service(value = "selService")
public class SelServiceImpl implements SelService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveSellItem(AjaxModel model) throws Exception {
        List<Map<String, Object>> list = model.getDataList();

        for(Map<String, Object> param : list){
            param.put("USER_ID", model.getUsrSessionModel().getUserId());
            commonDAO.update("sel.updateSellItem", param);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveBaseval(AjaxModel model) {
        List<Map<String, Object>> list = model.getDataList();

        for(Map<String, Object> param : list){
            param.put("USER_ID", model.getUsrSessionModel().getUserId());
            commonDAO.update("sel.updateBaseval", param);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveDecBaseval(AjaxModel model) {
        String decGubun = (String)model.getData().get("DEC_GUBUN");
        List<Map<String, Object>> list = (List)model.getData().get("dataList");

        for(Map<String, Object> param : list){
            String qKey = "sel.updateSellerBaseval";
            if("MALL".equals(decGubun)){
                qKey = "sel.updateMallBaseval";
            }
            param.put("USER_ID", model.getUsrSessionModel().getUserId());

            commonDAO.update(qKey, param);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveHsCode(AjaxModel model) {
        Map<String, Object> params = model.getData();

        String saveMode = (String)params.get("SAVE_MODE");

        // 신규저장일경우
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("sel.selectHsCount", params)));
            if(cnt > 0){
                model.setCode("W00000001"); // 중복된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("sel.insertHsCode", params);

        // 수정일경우
        }else{
            commonDAO.update("sel.updateHsCode", params);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

}
