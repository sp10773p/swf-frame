package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.service.AccService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 접속 로그 정보(Access Log) Controller
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
@Controller
public class AccController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "accService")
    private AccService accService;

    /**
     * 접속 로그 정보 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/acc/saveIpAccess")
    @ResponseBody
    public AjaxModel saveIpAccess(AjaxModel model) throws Exception {
        return accService.saveIpAccess(model);
    }

}
