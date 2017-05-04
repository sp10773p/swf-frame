package kr.pe.frame.xpr.controller;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.xpr.service.XprService;

/**
 * Created by kdh on 2017. 1. 10.
 */
@Controller
public class XprController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "xprService")
    XprService xprService;

    // ========================================================================================================= //
    // =================================================배송요청================================================= //
    // ========================================================================================================= //

    /**
     * 주거래특송사 코드 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/getMainExpressCode")
    @ResponseBody
    public AjaxModel getMainExpressCode(AjaxModel model) throws Exception {
        return xprService.getMainExpressCode(model);
    }
    
    /**
     * 특송 배송요청 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipList")
    @ResponseBody
    public AjaxModel selectShipList(AjaxModel model) throws Exception {
        return xprService.selectShipList(model);
    }
    
    /**
     * 특송 배송요청 엑셀 업로드내역 상세 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipExcelList")
    @ResponseBody
    public AjaxModel selectShipExcelList(AjaxModel model) throws Exception {
        return xprService.selectShipExcelList(model);
    }
    
    /**
     * 특송 배송요청 저장 (상태)
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/saveShipReq")
    @ResponseBody
    public AjaxModel savePickReq(AjaxModel model) throws Exception {
        return xprService.saveShipReq(model);
    }
    
    // ========================================================================================================= //
    // =============================================배송요청 상세목록============================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 상세 리스트
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipDetail")
    @ResponseBody
    public AjaxModel selectShipDetail(AjaxModel model) throws Exception {
        return xprService.selectShipDetail(model);
    }
    
    // ========================================================================================================= //
    // =============================================배송요청 상세정보============================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송요청 상세 정보
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipDetailInfo")
    @ResponseBody
    public AjaxModel selectShipDetailInfo(AjaxModel model) throws Exception {
        return xprService.selectShipDetailInfo(model);
    }
    
    /**
     * 특송 배송요청 상세정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/saveShipDetailInfo")
    @ResponseBody
    public AjaxModel saveShipDetailInfo(AjaxModel model) throws Exception {
        return xprService.saveShipDetailInfo(model);
    }
    
    // ========================================================================================================= //
    // =============================================배송요청 다운로드============================================= //
    // ========================================================================================================= //

    /**
     * 특송 배송요청 다운로드 리스트 (셀러/특송사)
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipReqFieldsList")
    @ResponseBody
    public AjaxModel selectShipReqFieldsList(AjaxModel model) throws Exception {
        return xprService.selectShipReqFieldsList(model);
    }

    // ========================================================================================================= //
    // =================================================특송사용================================================= //
    // ========================================================================================================= //
    
    /**
     * 특송 배송현황 리스트 (특송사)
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipReqList")
    @ResponseBody
    public AjaxModel selectShipReqList(AjaxModel model) throws Exception {
        return xprService.selectShipReqList(model);
    }
    
    /**
     * 특송 배송현황 상세 조회 (특송사)
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/selectShipReqDetailInfo")
    @ResponseBody
    public AjaxModel selectShipReqDetailInfo(AjaxModel model) throws Exception {
        return xprService.selectShipReqDetailInfo(model);
    }
    
    /**
     * 특송 배송요청 접수확인 (상태)
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/xpr/ship/saveShipReqStatus")
    @ResponseBody
    public AjaxModel saveShipReqStatus(AjaxModel model) throws Exception {
        return xprService.saveShipReqStatus(model);
    }
}
