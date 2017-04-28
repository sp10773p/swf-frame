package kr.pe.frame.adm.sys.service;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 접속 로그 정보(Access Log) Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see AccService
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
@Service(value = "accService")
public class AccServiceImpl implements AccService {
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
    public AjaxModel saveIpAccess(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        String saveMode = (String)param.get("SAVE_MODE");

        // 신규저장일경우
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("acc.selectCmmIpAccessCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); // 중복된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("acc.insertCmmIpAccess", param);

        // 수정일 경우
        }else{
            commonDAO.update("acc.updateCmmIpAccess", param);
        }


        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

}
