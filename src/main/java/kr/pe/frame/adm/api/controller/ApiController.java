package kr.pe.frame.adm.api.controller;

import kr.pe.frame.adm.api.service.ApiService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.adm.api.service.ApiServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 관리자 > API관리 Controller
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
@Controller
public class ApiController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "apiService")
    private ApiService apiService;

    /**
     * API키관리 항목 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/saveApiKeyDtl")
    @ResponseBody
    public AjaxModel saveApiKeyDtl(AjaxModel model) throws Exception {
        return apiService.saveApiKeyDtl(model);
    }

    /**
     * API목록 상세 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/saveApiMng")
    @ResponseBody
    public AjaxModel saveApiMng(AjaxModel model) throws Exception {
        return apiService.saveApiMng(model);
    }

    /**
     * API 데이터파라미터 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/saveApiInfo")
    @ResponseBody
    public AjaxModel saveApiInfo(AjaxModel model) throws Exception {
        return apiService.saveApiInfo(model);
    }

    /**
     * API목록 상세 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/deleteApiMng")
    @ResponseBody
    public AjaxModel deleteApiMng(AjaxModel model) throws Exception {
        return apiService.deleteApiMng(model);
    }

    /**
     * API목록 트리조회
     * - treeList, sampleJson
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/selectCmmApiInfoTree")
    @ResponseBody
    public AjaxModel selectCmmApiInfoTree(AjaxModel model) throws Exception {
        return apiService.selectCmmApiInfoTree(model);
    }

    /**
     * API목록 샘플 JSON 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/adm/api/selectCmmApiInfoSampleJson")
    @ResponseBody
    public AjaxModel selectCmmApiInfoSampleJson(AjaxModel model) throws Exception {
        return apiService.selectCmmApiInfoSampleJson(model);
    }

}
