package kr.pe.frame.adm.api.service;

import com.google.gson.Gson;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.util.StringUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.*;

/**
 * 관리자 > API관리 Service
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see ApiServiceImpl
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
@Service(value = "apiService")
public class ApiServiceImpl implements ApiService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveApiKeyDtl(AjaxModel model) throws Exception {
        List<Map<String, Object>> list = model.getDataList();

        for(Map<String, Object> param : list){
            commonDAO.update("api.updateApiKeyDtl", param);
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
    public AjaxModel saveApiMng(AjaxModel model) {
        Map<String, Object> param = model.getData();

        String saveMode = (String)param.get("SAVE_MODE");

        // 추가
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("api.selectApiMngCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); //중목된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("api.insertCmmApiMng", param);
            model.setCode("I00000003"); //저장되었습니다.


        }else if("U".equals(saveMode)){
            commonDAO.insert("api.updateCmmApiMng", param);
            model.setCode("I00000005"); //수정되었습니다.
        }

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel deleteApiMng(AjaxModel model) {
        Map<String, Object> param = model.getData();

        // 트리 삭제
        commonDAO.delete("api.deleteApiInfo", param);

        // API 목록 삭제
        commonDAO.delete("api.deleteApiMng", param);

        model.setCode("I00000004"); // 삭제 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveApiInfo(AjaxModel model) {
        Map<String, Object> param = model.getData();

        String saveMode = (String)param.get("TREE_SAVE_MODE");

        // 추가
        if("I".equals(saveMode)){
            int cnt = Integer.parseInt(String.valueOf(commonDAO.select("api.selectApiInfoCount", param)));
            if(cnt > 0){
                model.setCode("W00000001"); //중목된 데이터가 존재합니다.
                return model;
            }

            commonDAO.insert("api.insertCmmApiInfo", param);
            model.setCode("I00000003"); //저장되었습니다.


        }else if("U".equals(saveMode)){
            commonDAO.insert("api.updateCmmApiInfo", param);
            model.setCode("I00000005"); //수정되었습니다.
        }

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel selectCmmApiInfoTree(AjaxModel model) {
        Map<String, Object> param = model.getData();

        Map<String, Object> retMap = new HashMap<>();
        List<Map<String, Object>> treeList = getApiTreeList(param);

        retMap.put("treeList", treeList);   // 트리
        retMap.put("treeJson", getApiSampleJson(treeList)); // 샘플 JSON

        model.setData(retMap);

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel selectCmmApiInfoSampleJson(AjaxModel model) {
        Map<String, Object> retMap = new HashMap<>();

        Map<String, Object> param = model.getData();

        //요청 SAMPLE JSON
        param.put("P_JSON_TYPE", "REQ");
        List<Map<String, Object>> treeList = getApiTreeList(param);
        retMap.put("reqSampleJson", getApiSampleJson(treeList)); // 요청 샘플 JSON

        //응답 SAMPLE JSON
        param.put("P_JSON_TYPE", "RES");
        treeList = getApiTreeList(param);
        retMap.put("resSampleJson", getApiSampleJson(treeList)); // 응답 샘플 JSON

        model.setData(retMap);

        return model;
    }

    /**
     * api 목록 tree 조회
     * @param param
     * @return
     */
    public List<Map<String, Object>> getApiTreeList(Map<String, Object> param){
        return commonDAO.list("api.selectCmmApijaonTree", param);
    }

    /**
     * api 목록 list to json string
     * @param treeList
     * @return
     */
    public String getApiSampleJson(List<Map<String, Object>> treeList){
        if(treeList == null || treeList.size() == 0){
            return "";
        }
        Map<String, Object> treeJsonMap = new LinkedHashMap<>();
        traverse(getChildren(treeList, ""), treeList, treeJsonMap);

        return new Gson().toJson(((List)treeJsonMap.get("Root")).get(0));
    }

    /**
     * 계층구조의 리스트를 트리구조의 객체로 변환
     * @param targetList
     * @param allList
     * @param retMap
     */
    private void traverse(List<Map<String, Object>> targetList, List<Map<String, Object>> allList, Map<String, Object> retMap){
        for(Map<String, Object> data : targetList){
            String jsonKey = (String)data.get("JSON_KEY");
            String jsonId  = data.get("JSON_ID")   == null ? "" : (String)data.get("JSON_ID");
            String jsonSamp = data.get("JSON_SAMP") == null ? "" : (String)data.get("JSON_SAMP");
            String dataType = data.get("DATA_TYPE") == null ? "" : (String)data.get("DATA_TYPE");

            Object valueObj;

            if(dataType.startsWith("LIST")){
                valueObj = new LinkedHashMap<String, Object>();

            }else if(dataType.startsWith("NUMERIC")){
                valueObj = (StringUtil.isNotEmpty(jsonSamp) ? Double.parseDouble(jsonSamp) : 0);

            }else if(dataType.startsWith("INTEGER")){
                valueObj = (StringUtil.isNotEmpty(jsonSamp) ? Integer.parseInt(jsonSamp) : 0);

            }else{
                valueObj = jsonSamp;
            }

            if(dataType.startsWith("LIST")){
                traverse(getChildren(allList, jsonId), allList, (Map<String, Object>) valueObj);
                List<Map<String, Object>> list = new ArrayList<>();
                list.add((Map<String, Object>) valueObj);
                retMap.put(jsonKey, list);

            }else{
                retMap.put(jsonKey, valueObj);
            }


        }
    }

    /**
     * 인자의 리스트에서 인자의 id의 하위 노드를 리턴
     * @param list
     * @param parentId
     * @return
     */
    public List<Map<String, Object>> getChildren(List<Map<String, Object>> list, String parentId){
        List<Map<String, Object>> retLIst = new ArrayList<>();
        if(parentId == null) return retLIst;

        for(Map<String, Object> data : list){
            String id = data.get("P_JSON_ID") == null ? "" : (String)data.get("P_JSON_ID");
            if(parentId.equals(id)){
                retLIst.add(data);
            }
        }

        return retLIst;
    }
}
