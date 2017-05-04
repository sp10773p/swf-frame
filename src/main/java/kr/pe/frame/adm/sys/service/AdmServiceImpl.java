package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Sha256;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.cmm.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 시스템관리 > 어드민관리 Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AdmService
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
@Service(value = "admService")
public class AdmServiceImpl implements AdmService {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Value("#{config['login.password.change.period']}")
    String pwUpdate;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveAdmUser(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        String saveMode = (String)param.get("SAVE_MODE");

        // 필드 암호화 처리
        if(StringUtil.isNotEmpty((String)param.get("EMAIL"))){
            param.put("EMAIL", DocUtil.encrypt((String)param.get("EMAIL")));
        }

        if(StringUtil.isNotEmpty((String)param.get("TEL_NO"))){
            param.put("TEL_NO", DocUtil.encrypt((String)param.get("TEL_NO")));
        }

        if(StringUtil.isNotEmpty((String)param.get("HP_NO"))){
            param.put("HP_NO", DocUtil.encrypt((String)param.get("HP_NO")));
        }

        String userPw    = (String)param.get("USER_PW");

        // 신규저장일경우
        if("I".equals(saveMode)){
            param.put("USER_PW", Sha256.encrypt(userPw));

            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("adm.selectCmmUserCount", param)));
            if(cnt > 0){
                model.setCode("W00000012"); // 이미 존재하는 아이디 입니다.
                return model;
            }

            param.put("PW_UPDATE", pwUpdate); //비밀번호변경주기

            commonDAO.insert("adm.insertAdmUser", param);

        // 수정일 경우
        }else{
            // 비밀번호를 변경하였을 경우 비밀번호 암호화
            String orgUserPw = (String)commonDAO.select("adm.selectUserPw", param);
             if(userPw.startsWith("*")){
                 param.put("USER_PW", orgUserPw);

             }else{
                 param.put("USER_PW", Sha256.encrypt(userPw));

             }

            commonDAO.update("adm.updateAdmUser", param);
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
    public AjaxModel deleteAdminUser(AjaxModel model) {
        for(Map<String, Object> params : model.getDataList()){
            // 어드민 사용자 관련 테이블에 데이터 삭제
            // ip 관리
            commonDAO.delete("adm.deleteCmmIpAccess", params);

            // 어드민 사용자 삭제
            commonDAO.delete("adm.deleteAdminUser", params);
        }

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }

}
