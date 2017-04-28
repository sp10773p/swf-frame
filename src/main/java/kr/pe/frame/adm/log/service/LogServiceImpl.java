package kr.pe.frame.adm.log.service;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.StringReader;
import java.util.*;


/**
 * 관리자 > 로그관리 Service
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see LogService
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
@Service(value = "logService")
public class LogServiceImpl implements LogService {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel selectParam(AjaxModel model) throws Exception {
        Map param = model.getData();

        // 필수 쿼리 아이디 체크
        if(StringUtil.isEmpty((String)param.get(Constant.QUERY_KEY.getCode()))){
            model.setStatus(-1);
            model.setMsg(commonService.getMessage("E00000001")); // 조회 쿼리 ID가 존재하지 않습니다.

            return model;
        }

        // 조회쿼리
        String qKey = (String)param.get(Constant.QUERY_KEY.getCode());
        String parameters = (String)commonDAO.select(qKey, param);

        Map logParams = new HashMap();
        if(parameters != null){

            Gson gson = new Gson();
            JsonReader reader = new JsonReader(new StringReader(parameters));
            reader.setLenient(true);
            Map map = gson.fromJson(reader, Map.class);

            Map< String, Object > titleParam = (Map)map.get("titleParameter");

            if(titleParam != null){

                for ( Map.Entry< String, Object > entry : titleParam.entrySet() ) {
                    String title = (String)entry.getValue();

                    String value;
                    if(map.get(entry.getKey()) instanceof ArrayList){
                        value = Arrays.toString(((List)map.get(entry.getKey())).toArray());
                    }else{
                        value = (String)map.get(entry.getKey());
                    }
                    if(StringUtil.isNotEmpty(title)){
                        String[] arr = new String[2];
                        arr[0] = title+"["+entry.getKey()+"]";
                        arr[1] = value;
                        logParams.put(entry.getKey(), arr);
                    }
                }

            }
        }
        model.setData(logParams);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveLogPass(AjaxModel model) {
        List<Map<String, Object>> dataList = model.getDataList();

        String userId = model.getUsrSessionModel().getUserId();

        for(Map<String, Object> data : dataList){
            data.put("REG_ID", userId);
            commonDAO.insert("log.updateLogPass", data);
        }

        commonService.loadLogMngModel();

        model.setCode("I00000032"); //로그제외 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveLogFilter(AjaxModel model) {
        Map<String, Object> param = model.getData();

        String saveMode = (String)param.get("SAVE_MODE");

        // 신규저장일경우
        if("I".equals(saveMode)){

            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("log.selectCmmLogMngCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); // 중복된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("log.insertCmmLogMng", param);

            // 수정일 경우
        }else{
            commonDAO.update("log.updateCmmLogMng", param);
        }


        commonService.loadLogMngModel();

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

}
