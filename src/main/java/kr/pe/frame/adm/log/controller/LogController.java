package kr.pe.frame.adm.log.controller;

import kr.pe.frame.adm.log.service.LogService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.adm.log.service.LogServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 관리자 > 로그관리 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see LogServiceImpl
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
public class LogController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "logService")
    private LogService logService;

    /**
     * 로그 상세 내용 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/log/selectParam")
    @ResponseBody
    public AjaxModel selectParam(AjaxModel model) throws Exception{
        return logService.selectParam(model);
    }

    /**
     * 로그제외 추가
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/log/saveLogPass")
    @ResponseBody
    public AjaxModel saveLogPass(AjaxModel model) throws Exception{
        return logService.saveLogPass(model);
    }

    /**
     * 로그필터관리 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/log/saveLogFilter")
    @ResponseBody
    public AjaxModel saveLogFilter(AjaxModel model) throws Exception{
        return logService.saveLogFilter(model);
    }
}
