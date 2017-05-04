package kr.pe.frame.home.mem.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.pe.frame.cmm.core.base.Sha256;
import kr.pe.frame.cmm.core.base.AbstractDAO;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.CommonDAOFactory;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.pe.frame.adm.sys.service.UsrService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.FileCommonService;
import kr.pe.frame.cmm.util.RandomString;

/**
 * Created by jak on 2017-02-22.
 */
@Service(value = "memService")
public class MemServiceImpl implements MemService {
	Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;
    
    @Resource(name = "commonService")
    private CommonService commonService;
    
    @Resource(name = "fileCommonService")
    private FileCommonService fileCommonService;  
    
    @Resource(name = "commonDAOFactory")
    private CommonDAOFactory daoFactory;
    
    @Resource(name = "usrService")
    UsrService usrService;

	@Override
	public AjaxModel selectUser(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();

        Map<String, Object> result = (Map<String, Object>)commonDAO.select("mem.selectUser", param);
        model.setData(result);
        return model;
	}

	@Override
	public AjaxModel saveMemberJoin(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String[]> parameterMap = request.getParameterMap();
		Map<String, Object> param = new HashMap<>();
		for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
			String key = String.valueOf(entry.getKey());
			if (entry.getValue() instanceof String[]) {
				String[] valueArray = (String[]) entry.getValue();

				if (valueArray.length == 1) {
					param.put(key, valueArray[0]);
				} else { // 동일 name의 패러미터가 2개 이상일 경우
					param.put(key, valueArray);
				}
			} else {
				param.put(key, entry.getValue());
			}
		}
		AjaxModel uploadResult = fileCommonService.uploadFiles(request);
		Map<String, Object> fileData = uploadResult.getData();
		param.put("ATCH_FILE_ID", (String)fileData.get("ATCH_FILE_ID"));
		String userPw = StringUtils.defaultIfEmpty((String) param.get("USER_PW"), "");
		String telNo1 = (String) param.get("TEL_NO1");
		String telNo2 = (String) param.get("TEL_NO2");
		String telNo3 = (String) param.get("TEL_NO3");
		String hpNo1 = (String) param.get("HP_NO1");
		String hpNo2 = (String) param.get("HP_NO2");
		String hpNo3 = (String) param.get("HP_NO3");
		String email = StringUtils.defaultIfEmpty((String) param.get("EMAIL"), "");
		if(StringUtils.isNotEmpty(telNo1) && StringUtils.isNotEmpty(telNo2) && StringUtils.isNotEmpty(telNo3)){
			String telNo = telNo1 + telNo2 + telNo3;
			param.put("TEL_NO", DocUtil.encrypt(telNo));
		}
		if(StringUtils.isNotEmpty(hpNo1) && StringUtils.isNotEmpty(hpNo2) && StringUtils.isNotEmpty(hpNo3)){
			String hpNo = hpNo1 + hpNo2 + hpNo3;
			param.put("HP_NO", DocUtil.encrypt(hpNo));
		}
		param.put("EMAIL", DocUtil.encrypt(email));
		param.put("USER_PW", Sha256.encrypt(userPw));
		commonDAO.insert("mem.insertMember", param);
		Map<String, Object> result = (Map<String, Object>)commonDAO.select("mem.selectUser", param);
		AjaxModel model = new AjaxModel();
		model.setData(result);
		return model;
	}    
	
    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
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
	public AjaxModel selectUthUsr(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		AbstractDAO dao = daoFactory.getDao("trade");
        Map<String, Object> result = (Map<String, Object>)dao.select("mem.selectUthUser", param);
        model.setData(result);
        return model;
	}
}
