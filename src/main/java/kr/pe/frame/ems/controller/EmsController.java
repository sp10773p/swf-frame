package kr.pe.frame.ems.controller;

//import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.ems.service.EmsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by kdh on 2017. 1. 10.
 */
@Controller
public class EmsController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "emsService")
    EmsService emsService;

    // ========================================================================================================= //
    // =================================================픽업요청================================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickList")
    @ResponseBody
    public AjaxModel selectPickList(AjaxModel model) throws Exception {
        return emsService.selectPickList(model);
    }

    /**
     * EMS 픽업요청 엑셀 업로드내역 상세 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickExcelList")
    @ResponseBody
    public AjaxModel selectPickExcelList(AjaxModel model) throws Exception {
        return emsService.selectPickExcelList(model);
    }

    /**
     * EMS 픽업요청 처리내역 상세 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickReqList")
    @ResponseBody
    public AjaxModel selectPickReqList(AjaxModel model) throws Exception {
        return emsService.selectPickReqList(model);
    }
    
    /**
     * EMS 픽업요청 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/savePickReq")
    @ResponseBody
    public AjaxModel savePickReq(AjaxModel model) throws Exception {
        return emsService.savePickReq(model);
    }
    
    // ========================================================================================================= //
    // =============================================픽업요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickDetail")
    @ResponseBody
    public AjaxModel selectPickDetail(AjaxModel model) throws Exception {
        return emsService.selectPickDetail(model);
    }
    
    // ========================================================================================================= //
    // =============================================픽업요청 상세정보============================================= //
    // ========================================================================================================= //
    
    /**
     * EMS 픽업요청 상세 정보
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickDetailInfo")
    @ResponseBody
    public AjaxModel selectPickDetailInfo(AjaxModel model) throws Exception {
        return emsService.selectPickDetailInfo(model);
    }
    
    /**
     * EMS 픽업요청 상세정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/savePickDetailInfo")
    @ResponseBody
    public AjaxModel saveShipDetailInfo(AjaxModel model) throws Exception {
        return emsService.savePickDetailInfo(model);
    }
    
    // ========================================================================================================= //
    // ==================================================합배송================================================== //
    // ========================================================================================================= //

    /**
     * 합배송관리 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickMergeMasterList")
    @ResponseBody
    public AjaxModel selectPickMergeMasterList(AjaxModel model) throws Exception {
        return emsService.selectPickMergeMasterList(model);
    }

    /**
     * 합배송관리 Sub 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickMergeDetailList")
    @ResponseBody
    public AjaxModel selectPickMergeDetailList(AjaxModel model) throws Exception {
        return emsService.selectPickMergeDetailList(model);
    }

    /**
     * 합배송추가 - 수출신고수리내역 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/selectPickMergeList")
    @ResponseBody
    public AjaxModel selectPickMergeList(AjaxModel model) throws Exception {
        return emsService.selectPickMergeList(model);
    }

    /**
     * 합배송추가 - 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/pick/savePickMerge")
    @ResponseBody
    public AjaxModel savePickMerge(AjaxModel model) throws Exception {
        return emsService.savePickMerge(model);
    }
    
    // ========================================================================================================= //
    // ==================================================기표지================================================== //
    // ========================================================================================================= //

    /**
     * EMS 기표지 출력대상 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/cov/selectCovList")
    @ResponseBody
    public AjaxModel selectCovList(AjaxModel model) throws Exception {
        return emsService.selectCovList(model);
    }
    
    /**
     * EMS 기표지 출력대상 Data 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/cov/selectCovDataList")
    @ResponseBody
    public AjaxModel selectCovDataList(AjaxModel model) throws Exception {
        return emsService.selectCovDataList(model);
    }
    
    // ========================================================================================================= //
    // =================================================배송현황================================================= //
    // ========================================================================================================= //

    /**
     * EMS 배송현황 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/stat/selectStatList")
    @ResponseBody
    public AjaxModel selectStatList(AjaxModel model) throws Exception {
        return emsService.selectStatList(model);
    }

    /**
     * EMS 배송현황 상세 정보
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/stat/selectStatTraceDetail")
    @ResponseBody
    public AjaxModel selectStatTraceDetail(AjaxModel model) throws Exception {
        return emsService.selectStatTraceDetail(model);
    }
    
    /**
     * EMS 배송현황 실시간 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/ems/stat/saveRealTimeEmsTraceInfo")
    @ResponseBody
    public AjaxModel saveRealTimeEmsTraceInfo(AjaxModel model) throws Exception {
        return emsService.saveRealTimeEmsTraceInfo(model);
    }
}
