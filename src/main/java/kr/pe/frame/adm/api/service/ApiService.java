package kr.pe.frame.adm.api.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

import java.util.List;
import java.util.Map;

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
public interface ApiService {

    /**
     * API키관리 항목 저장
     * @param model
     * @return
     * @throws Exception
     */
	AjaxModel saveApiKeyDtl(AjaxModel model) throws Exception;

    /**
     * API목록 상세 저장
     * @param model
     * @return
     */
    AjaxModel saveApiMng(AjaxModel model);

    /**
     * API목록 상세 삭제
     * @param model
     * @return
     */
    AjaxModel deleteApiMng(AjaxModel model);

    /**
     * API 데이터파라미터 저장
     * @param model
     * @return
     */
    AjaxModel saveApiInfo(AjaxModel model);

    /**
     * API목록 트리조회
     * - treeList, sampleJson
     * @param model
     * @return
     * @throws Exception
     */
    AjaxModel selectCmmApiInfoTree(AjaxModel model);

    /**
     * API목록 샘플 JSON 조회
     * - 요청, 응답 샘플 json
     * @param model
     * @return
     */
    AjaxModel selectCmmApiInfoSampleJson(AjaxModel model);

    /**
     * api 목록 tree 조회
     * @param param
     * @return
     */
    List<Map<String, Object>> getApiTreeList(Map<String, Object> param);

    /**
     * api 목록 list to json string
     * @param treeList
     * @return
     */
    String getApiSampleJson(List<Map<String, Object>> treeList);
}