package kr.pe.frame.basic.prof.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.Sha256;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.RandomString;

/**
 * 사용자 화면: 기초정보 > 회원 관리 구현 클래스
 * @author 정안균
 * @since 2017-03-07
 * @version 1.0
 * @see ProfService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.03.07  정안균  최초 생성
 *
 * </pre>
 */
@Service(value = "profService")
public class ProfServiceImpl implements ProfService {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "commonDAO")
    private CommonDAO commonDAO;
	
	@Resource(name = "commonService")
    private CommonService commonService;
	
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
            params.put("USER_ID"      , model.getUsrSessionModel().getUserId());
            commonDAO.update("prof.updateCmmUserAttachFile", params);
        }
        return model;
    }

	@Override
	public AjaxModel saveEmailAuth(AjaxModel model) throws Exception {
        String randomEmailCertKey = RandomString.random(10); //10자리 생성한 인증키

        Map<String, Object> mailMap = model.getData();
        String mail = StringUtils.defaultIfEmpty((String) mailMap.get("EMAIL"), ""); 
        mailMap.put("EMAIL_ADDRESS", DocUtil.encrypt(StringUtils.defaultIfEmpty((String) mailMap.get("EMAIL"), "")));
        mailMap.put("AUTHENTICATION_KEY", randomEmailCertKey);

        // 메일삭제
        commonDAO.delete("mem.deleteEmailAuth", mailMap);
        
        // 이메일 인증키 저장
        commonDAO.insert("mem.insertEmailAuth", mailMap);

        String receiver = mail;
        String title    = "GoGlobal 서비스 사용자 이메일인증번호 발송";
        String vmName   = "send_emailauth_mail.html";
        commonService.sendSimpleEMail(receiver, title, vmName, mailMap);
        model.setData(mailMap);
        model.setCode("I00000031"); //인증번호가 발송 되었습니다.\n5분내에 인증번호를 입력해 주세요.

        return model;
	}

	@Override
	public AjaxModel selectEmailAuth(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("EMAIL_ADDRESS", DocUtil.encrypt(StringUtils.defaultIfEmpty((String) param.get("EMAIL"), "")));
        Map<String, Object> result = (Map<String, Object>)commonDAO.select("mem.selectEmailAuth", param);
        model.setData(result);
        return model;
	}

	@Override
	public AjaxModel saveUserInfo(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("USER_ID", model.getUsrSessionModel().getUserId());
		
		// 필드 암호화 처리
        if(StringUtils.isNotEmpty((String)param.get("EMAIL"))){
            param.put("EMAIL", DocUtil.encrypt((String)param.get("EMAIL")));
        }

        if(StringUtils.isNotEmpty((String)param.get("TEL_NO1")) && StringUtils.isNotEmpty((String)param.get("TEL_NO2")) && StringUtils.isNotEmpty((String)param.get("TEL_NO3"))){
            String telNo = (String)param.get("TEL_NO1") + (String)param.get("TEL_NO2") + (String)param.get("TEL_NO3");
        	param.put("TEL_NO", DocUtil.encrypt(telNo));
        }

        if(StringUtils.isNotEmpty((String)param.get("HP_NO1")) && StringUtils.isNotEmpty((String)param.get("HP_NO2")) && StringUtils.isNotEmpty((String)param.get("HP_NO3"))){
        	String hpNo = (String)param.get("HP_NO1") + (String)param.get("HP_NO2") + (String)param.get("HP_NO3");
        	param.put("HP_NO", DocUtil.encrypt(hpNo));
        }
        
        String userPw = StringUtils.defaultIfEmpty((String) param.get("USER_PW"), "");
        param.put("USER_PW", Sha256.encrypt(userPw));
		commonDAO.update("prof.updateUser", param);
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
    public AjaxModel selectUsr(AjaxModel model) throws Exception {
        Map param = model.getData();

        // 필수 쿼리 아이디 체크
        if(StringUtils.isEmpty((String)param.get(Constant.QUERY_KEY.getCode()))){
            model.setStatus(-1);
            model.setMsg(commonService.getMessage("E00000001")); // 조회 쿼리 ID가 존재하지 않습니다.

            return model;
        }

        // 조회쿼리
        String qKey = (String)param.get(Constant.QUERY_KEY.getCode());
        Map<String, Object> map = (Map<String, Object>)commonDAO.select(qKey, param);

        String email =  DocUtil.decrypt(StringUtils.defaultIfEmpty((String) map.get("EMAIL"), ""));
        String hpno  =  DocUtil.decrypt(StringUtils.defaultIfEmpty((String) map.get("HP_NO"), ""));
        String telno =  DocUtil.decrypt(StringUtils.defaultIfEmpty((String) map.get("TEL_NO"), ""));

        map.put("EMAIL" , email.replace("null", ""));
        map.put("HP_NO" , hpno.replace("null", ""));
        map.put("TEL_NO", telno.replace("null", ""));

        model.setData(map);

        return model;
    }

	@Override
	public AjaxModel saveUserWithdraw(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		param.put("USER_ID", model.getUsrSessionModel().getUserId());
		
		commonDAO.update("prof.updateWithdrawStat", param);
        model.setCode("I00000015"); //탈퇴요청 되었습니다.
        return model;
	}




}
