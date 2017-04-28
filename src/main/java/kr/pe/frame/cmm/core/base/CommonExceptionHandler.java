package kr.pe.frame.cmm.core.base;

import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Exception 을 AjaxModel로 처리
 * @author 성동훈
 * @since 2017-01-09
 * @version 1.0
 * @see BizException
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.09  성동훈  최초 생성
 *
 * </pre>
 */
@ControllerAdvice
public class CommonExceptionHandler {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonService")
    private CommonService commonService;

    @ExceptionHandler(Exception.class)
    @ResponseBody
    private AjaxModel errorException(Exception e) throws  Exception{
    	AjaxModel model;
    	if(e instanceof BizException) {
            //logger.error("BizException : {} ", e);
    		model = ((BizException) e).getModel();
    		if(model == null){
                model = new AjaxModel();
                model.setMsg(this.getExceptionMessage(e));
            }
    	} else {
    		logger.error("Exception : {} ", e);
    		model = new AjaxModel();
    		model.setCode("E00000003");
    		model.setMsg(commonService.getMessage("E00000003"));
    	}

        return model;
    }

    private String getExceptionMessage(Throwable e) {
        StringBuilder message = new StringBuilder();
        while( e != null ) {
            message.append(e.getMessage()).append("\n");
            e = e.getCause();
        }
        return message.toString();
    }
}
