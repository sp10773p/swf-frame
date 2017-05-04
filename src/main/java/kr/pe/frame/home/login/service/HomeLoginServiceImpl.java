package kr.pe.frame.home.login.service;

import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Created by jak on 2017-02-21.
 */
@Service(value = "homeLoginService")
public class HomeLoginServiceImpl implements HomeLoginService {
	Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;
   
	@Override
	public AjaxModel selectUser(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        // 필드 암호화 처리
        if(StringUtils.isNotEmpty((String)param.get("EMAIL"))){
            param.put("EMAIL", DocUtil.encrypt((String)param.get("EMAIL")));
        }
        Map<String, Object> result = (Map<String, Object>)commonDAO.select("homeLogin.selectUser", param);
        model.setData(result);
        return model;
	}


}
