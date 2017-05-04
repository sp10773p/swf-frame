package kr.pe.frame.cmm.core.service;

import org.springframework.scheduling.annotation.Async;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 비동기 처리 서비스
 * @author 성동훈
 * @version 1.0
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017-03-10  성동훈  최초 생성
 * </pre>
 * @since 2017-03-10
 */
public class AsyncService {

    @Resource(name = "commonService")
    CommonService commonService;

    /**
     * 받는사람이 한명일때 간단하게 비동기로 메일전송
     * @param receiver 받는사람메일 주소
     * @param title 메일 제목
     * @param vmName 메일포멧 Velocity 파일명
     * @param vmParam Velocity 파라미터
     * @throws Exception
     */
    @Async
    public void asyncSendSimpleMail(String receiver, String title, String vmName, Map vmParam) throws Exception{
        commonService.sendSimpleEMail(receiver, title, vmName, vmParam);
    }
}
