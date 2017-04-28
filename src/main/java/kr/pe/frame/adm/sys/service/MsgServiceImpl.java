package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 시스템관리 > 알림메시지관리 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MsgService
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
@Service(value = "msgService")
public class MsgServiceImpl implements MsgService {
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
    public AjaxModel saveMessage(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        String saveMode = (String)param.get("SAVE_MODE");

        // 신규저장일경우
        if("I".equals(saveMode)){

            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("msg.selectCmmMessageCount", param)));
            if(cnt > 0){
                model.setCode("W00000012"); // 이미 존재하는 아이디 입니다.
                return model;
            }

            commonDAO.insert("msg.insertCmmMessage", param);

            // 수정일 경우
        }else{
            String orgType = (String)param.get("ORG_TYPE");
            String orgCode = (String)param.get("ORG_CODE");

            String type = (String)param.get("TYPE");
            String code = (String)param.get("CODE");
            if(!orgCode.equals(code) || !orgType.equals(type)){
                int cnt = Integer.parseInt(String.valueOf(commonDAO.select("msg.selectCmmMessageCount", param)));
                if(cnt > 0){
                    model.setCode("W00000012"); // 이미 존재하는 아이디 입니다.
                    return model;
                }
            }

            commonDAO.update("msg.updateCmmMessage", param);
        }

        // message storage reload
        commonService.loadMessage(null);

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }
}
