package kr.pe.frame.adm.ntc.controller;

import kr.pe.frame.adm.ntc.service.BoardService;
import kr.pe.frame.adm.ntc.service.NtcService;
import kr.pe.frame.cmm.core.model.AjaxModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * 게시판 Controller
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see NtcService
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
public class BoardController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "boardService")
    BoardService boardService;

    /**
     * 게시판 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/board/save")
    @ResponseBody
    public AjaxModel save(AjaxModel model) throws Exception {
        return boardService.save(model);
    }

    /**
     * 게시판 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/board/delete")
    @ResponseBody
    public AjaxModel delete(AjaxModel model) throws Exception {
        return boardService.delete(model);
    }

}
