package kr.pe.frame.adm.ntc.service;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 공지사항 Service 구현 클래스
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see BoardServiceImpl
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
@Service(value = "boardService")
public class BoardServiceImpl implements BoardService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonService")
    private CommonService commonService;


    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel save(AjaxModel model) throws BizException {
        Map<String, Object> params = model.getData();

        String saveMode = (String)params.get("SAVE_MODE");

         if("I".equals(saveMode)){
            commonDAO.insert("board.insertCmmBoard", params);

        }else{
            int existsCnt = Integer.parseInt(String.valueOf(commonDAO.select("board.selectBoardAuthCnt", params)));
            if(existsCnt == 0){
                throw new BizException(commonService.getMessage("W00000078", "수정")); // 수정 권한이 없습니다.
            }

            commonDAO.update("board.updateCmmBoard", params);
        }

        model.setCode("I00000003"); // 저장 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     * @param model
     * @return
     */
    @Override
    public AjaxModel delete(AjaxModel model) throws BizException {
        Map<String, Object> params = model.getData();

        int existsCnt = Integer.parseInt(String.valueOf(commonDAO.select("board.selectBoardAuthCnt", params)));
        if(existsCnt == 0){
            throw new BizException(commonService.getMessage("W00000078", "삭제")); // 권한이 없습니다.
        }

        existsCnt = Integer.parseInt(String.valueOf(commonDAO.select("board.selectBoardDelAuthCnt", params)));
        if(existsCnt == 0){
            throw new BizException(commonService.getMessage("W00000045")); // 답글이 있는 게시글은 삭제 할 수 없습니다.
        }


        commonDAO.update("board.updateDelYn", params);

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }
}
