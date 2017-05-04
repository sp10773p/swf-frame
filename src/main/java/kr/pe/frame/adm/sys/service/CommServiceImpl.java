package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 시스템관리 > 공통코드관리 Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see CommService
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
@Service(value = "commService")
public class CommServiceImpl implements CommService {
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveMasterCode(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        param.put("USER_ID", model.getUsrSessionModel().getUserId());

        String saveMode = (String)param.get("SAVE_MODE");

        // 추가
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("comm.selectBtStdClassCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); //중목된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("comm.insertBtStdClass", param);
            model.setCode("I00000003"); //저장되었습니다.


        }else if("U".equals(saveMode)){
            commonDAO.insert("comm.updateBtStdClass", param);
            model.setCode("I00000005"); //수정되었습니다.
        }

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel deleteMasterCode(AjaxModel model) throws Exception {
        List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }

        for(Map<String, Object> param : dataList){
            // DETAIL 삭제
            commonDAO.delete("comm.deleteBtStdCode", param);

            //MASTER 삭제
            commonDAO.delete("comm.deleteBtStdClass", param);
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveDetailCode(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        param.put("USER_ID", model.getUsrSessionModel().getUserId());

        String saveMode = (String)param.get("SAVE_MODE");

        // 추가
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("comm.selectBtStdCodeCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); //중목된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("comm.insertBtStdCode", param);
            model.setCode("I00000003"); //저장되었습니다.


        }else if("U".equals(saveMode)){
            commonDAO.insert("comm.updateBtStdCode", param);
            model.setCode("I00000005"); //수정되었습니다.
        }

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel deleteDetailCode(AjaxModel model) throws Exception {
        List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }

        for(Map<String, Object> param : dataList){
            // DETAIL 삭제
            commonDAO.delete("comm.deleteBtStdCode", param);
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }
}
