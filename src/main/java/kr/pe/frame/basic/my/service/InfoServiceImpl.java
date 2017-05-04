package kr.pe.frame.basic.my.service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 기본정보 > 내정보관리 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see InfoService
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
@Service(value = "infoService")
public class InfoServiceImpl implements InfoService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Value("#{config['login.password.complex.pattern']}")
    private String PASSWORD_PATTERN;

    @Value("#{config['login.password.complex.pattern.max']}")
    private String PASSWORD_PATTERN_MAX;

    @Value("#{config['login.password.complex.pattern.min']}")
    private String PASSWORD_PATTERN_MIN;

    @Value("#{config['login.password.change.period']}")
    private int PASSWORD_CHANGE_PERIOD;

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveUser(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
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

        commonDAO.update("info.updateCmmUser", param);

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveWithOutReq(AjaxModel model) {
        Map<String, Object> param = model.getData();

        commonDAO.update("info.updateWithDrawReason", param);

        model.setCode("I00000015"); //탈퇴요청 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveModPw(AjaxModel model) throws Exception {
        Map<String, Object> params = model.getData();

        UsrSessionModel usrSessionModel = model.getUsrSessionModel();
        // 현재 비밀번호 확인
        String passWd = (String)params.get("USER_PW");
        passWd = Sha256.encrypt(passWd);

        if(!passWd.equals(model.getUsrSessionModel().getUserPw())){
            model.setCode("W00000028"); // 현재 패스워드 정보와 일치하지 않습니다.
            return model;
        }

        // 새패스워드와 패스워드 동일 여부 확인
        String toPw  = (String)params.get("PW_TO");
        String toPw2 = (String)params.get("PW_TO2");
        if(!toPw.equals(toPw2)){
            model.setCode("W00000029"); // 새로운 패스워드와 확인 패스워드의 값이 일치하지 않습니다.
            return model;
        }

        // 새로운 패스워드에 유저ID 정보가 포함되어 있을때
        if(toPw.toLowerCase().contains(usrSessionModel.getUserId().toLowerCase())){
            model.setCode("W00000030"); //패스워드는 아이디를 포함할 수 없습니다.
            return model;
        }

        // 새로운 패스워드에 이전 패스워드 정보가 포함되어 있을때
        if(!StringUtil.isEmpty(usrSessionModel.getPwPrior()) &&
                toPw.toLowerCase().contains(usrSessionModel.getPwPrior().toLowerCase())){
            model.setCode("W00000031"); //이전패스워드와 동일한 패스워드는 사용할 수 없습니다.
            return model;
        }

        if(!isComplexPassword(toPw)){
            model.setCode("W00000032"); //패스워드가 규정된 정책을 만족하지 않습니다.\n(영문대문자, 영문소문자, 숫자또는 특수문자<!@#$%^*+=->) 를 \n하나이상씩 포함하여 10~20자리로 입력하십시오
            return model;
        }

        if (!"N".equals(usrSessionModel.getUseChk())) {
            params.put("PW_PRIOR", passWd);
        }

        params.put("USER_PW"    , Sha256.encrypt(toPw));
        params.put("LOGIN_ERROR", 0);
        params.put("USE_CHK"    , "Y");
        params.put("PW_UPDATE"  , PASSWORD_CHANGE_PERIOD);

        params.put("BEF_PW_PERIOD", PASSWORD_CHANGE_PERIOD - 7);
        params.put("AFT_PW_PERIOD", PASSWORD_CHANGE_PERIOD);

        commonDAO.update("info.updateUserPw", params);

        model.setCode("I00000016"); // 비밀번호가 변경되었습니다.

        return model;
    }

    /**
     * 비밀번호 패턴 유효성 검사
     * @param pwd
     * @return
     */
    private Boolean isComplexPassword(String pwd) {
        String pattern = PASSWORD_PATTERN + ".{" + PASSWORD_PATTERN_MIN + ","  + PASSWORD_PATTERN_MAX + "}$";
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(pwd);
        return m.matches();
    }
}
