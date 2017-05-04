package kr.pe.frame.exp.req.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.DocUtil;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

/**
 * Created by jjkhj on 2017-01-09.
 */
@Service("reqService")
public class ReqServiceImpl implements ReqService {
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonService")
    private CommonService commonService;


    @Override
    public AjaxModel selectDecReqList(AjaxModel model) throws Exception {
        model = commonService.selectGridPagingList(model);

        return model;
    }

}
