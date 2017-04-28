package kr.pe.frame.adm.mig.controller;

import kr.pe.frame.adm.mig.service.MigService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 이관관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MigService
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
public class MigController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "migService")
    private MigService migService;

    /**
     * 테이블변경 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/selectTabModList")
    @ResponseBody
    public AjaxModel selectTabModList(AjaxModel model) throws Exception {
        return migService.selectTabModList(model);
    }

    /**
     * 변경컬럼 정보 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/selectTabColModList")
    @ResponseBody
    public AjaxModel selectTabColModList(AjaxModel model) throws Exception {
        return migService.selectTabColModList(model);
    }

    /**
     * AS-IS/TO-BE INDEX 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/selectTabIndexList")
    @ResponseBody
    public AjaxModel selectTabIndexList(AjaxModel model) throws Exception {
        return migService.selectTabIndexList(model);
    }

    /**
     * 변경테이블이관 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/saveMigTableMng")
    @ResponseBody
    public AjaxModel saveMigTableMng(AjaxModel model) throws Exception {
        return migService.saveMigTableMng(model);
    }

    /**
     * 엑셀 업로드 처리
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/saveDataMig")
    @ResponseBody
    public AjaxModel saveDataMig(HttpServletRequest request) throws Exception {
        return migService.saveDataMig(request);
    }

    /**
     * 인터페이스매핑 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/updateDataMig")
    @ResponseBody
    public AjaxModel updateDataMig(AjaxModel model) throws Exception {
        return migService.updateDataMig(model);
    }

    /**
     * SCRIPT 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/mig/selectScript")
    @ResponseBody
    public AjaxModel selectScript(AjaxModel model) throws Exception {
        return migService.selectScript(model);
    }

    /**
     * 매핑정의서 엑셀 다운로드
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/mig/printReport")
    @ResponseBody
    public void printReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        migService.printReport(request, response);
    }

    /**
     * 이관스크립트 다운로드
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/mig/scriptDownload")
    public void scriptDownload(HttpServletRequest request,  HttpServletResponse response) throws Exception {
        migService.scriptDownload(request, response);
    }

    /**
     * 이관 DATA Script 다운로드
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/mig/printScript")
    public void printScript(HttpServletRequest request,  HttpServletResponse response) throws Exception {
        migService.printScript(request, response);
    }


}
