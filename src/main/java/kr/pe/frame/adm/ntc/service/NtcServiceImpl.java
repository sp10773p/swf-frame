package kr.pe.frame.adm.ntc.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 공지사항 Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see NtcServiceImpl
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
@Service(value = "ntcService")
public class NtcServiceImpl implements NtcService {
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
    public AjaxModel updateCmmFileAttchId(AjaxModel model) throws Exception {
        Map<String, Object> params = model.getData();

        List<Map<String, Object>> list = model.getDataList();
        for(Map<String, Object> data : list) {
            params.put("ATCH_FILE_ID", data.get("ATCH_FILE_ID"));
            params.put("MOD_ID"      , model.getUsrSessionModel().getUserId());
            commonDAO.update("ntc.updateCmmFileAttchId", params);
        }
        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel deleteCmmNotice(AjaxModel model) {
        List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }

        for(Map<String, Object> param : dataList){
            commonDAO.delete("ntc.deleteCmmFileDtl", param); // 파일 상세 삭제
            commonDAO.delete("ntc.deleteCmmFileMst", param); // 파일 마스터 삭제
            commonDAO.delete("ntc.deleteCmmNotice", param);  // 공지사항 삭제
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }
}
