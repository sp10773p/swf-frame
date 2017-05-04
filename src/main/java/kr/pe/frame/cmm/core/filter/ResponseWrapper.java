package kr.pe.frame.cmm.core.filter;

import kr.pe.frame.cmm.util.XSSUtil;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

/**
 * HttpServletRequest의 파라미터 XSS 처리
 * @author 성동훈
 * @since 2017-01-03
 * @version 1.0
 * @see CrossScriptingFilter
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.03  성동훈  최초 생성
 *
 * </pre>
 */
public class ResponseWrapper extends HttpServletResponseWrapper {

    public ResponseWrapper(HttpServletResponse response) {
        super(response);
    }

    @Override
    public void addHeader(String name, String value) {
        super.addHeader(name, XSSUtil.cleanResParamXSS(value));
    }
}
