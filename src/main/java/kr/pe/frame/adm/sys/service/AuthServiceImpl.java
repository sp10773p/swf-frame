package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 시스템관리 > 권한관리 Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AuthServiceImpl
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
@Service(value = "authService")
public class AuthServiceImpl implements AuthService {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveAuth(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        Map<String, Object> authDetail = (Map<String, Object>) param.get("auth");
        List<Map<String, String>> menuAuth = (List<Map<String, String>>)param.get("menuAuth");

        String saveMode = (String)authDetail.get("SAVE_MODE");

        authDetail.put("REG_ID", model.getUsrSessionModel().getUserId());
        authDetail.put("MOD_ID", model.getUsrSessionModel().getUserId());

        if(StringUtil.isEmpty((String)authDetail.get("AUTH_EXPLAIN"))){
            authDetail.put("AUTH_EXPLAIN", authDetail.get("AUTH_NM"));
        }

        // 권한 코드 저장
        if("I".equals(saveMode)){ // 신규저장일경우

            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("auth.selectCmmAuthCount", authDetail)));
            if(cnt > 0){
                model.setCode("W00000001"); // 중복된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("auth.insertCmmAuth", authDetail);

        }else{ // 수정일 경우
            commonDAO.update("auth.updateCmmAuth", authDetail);
        }


        //권한별 메뉴 삭제
        authDetail.put("MENU_DIV", param.get("MENU_DIV"));
        commonDAO.delete("auth.deleteCmmMenuAuthForMenuDiv", authDetail);

        for(Map<String, String> data : menuAuth){
            data.put("AUTH_CD", (String)authDetail.get("AUTH_CD"));

            data.put("REG_ID", model.getUsrSessionModel().getUserId());
            data.put("MOD_ID", model.getUsrSessionModel().getUserId());

            // 메뉴 권한 해제시 버튼 권한 삭제
            String chk = data.get("CHK");
             if("0".equals(chk)){
                commonDAO.delete("auth.deleteCmmMenuBtnAuth", data);
                continue;
            }

            // 권한별 메뉴 저장
            commonDAO.insert("auth.insertCmmMenuAuth", data);
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveBtnAuth(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        List<Map<String, String>> btnAuth  = (List<Map<String, String>>)param.get("btnAuth");
        // 버튼권한 저장
        // 1. 버튼권한 전체 삭제
        commonDAO.delete("auth.deleteCmmMenuBtnAuth", param);

        // 2. 버튼권한 저장
        for(Map<String, String> data : btnAuth){
            data.put("AUTH_CD", (String)param.get("AUTH_CD"));
            data.put("REG_ID", model.getUsrSessionModel().getUserId());
            data.put("MOD_ID", model.getUsrSessionModel().getUserId());

            commonDAO.insert("auth.insertCmmMenuBtnAuth", data);
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
    public AjaxModel deleteAuth(AjaxModel model) {
        List<Map<String, Object>> dataList = model.getDataList();

        if(dataList == null){
            dataList = new ArrayList<>();
        }

        if(model.getDataList() == null && model.getData() != null){
            dataList.add(model.getData());
        }

        for(Map<String, Object> param : dataList){
            commonDAO.delete("auth.deleteCmmAuth", param);

            commonDAO.delete("auth.deleteCmmMenuAuth", param); // 권한별 메뉴 삭제

            commonDAO.delete("auth.deleteCmmMenuBtnAuth", param); // 메뉴별 버튼권한 삭제
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }
}
