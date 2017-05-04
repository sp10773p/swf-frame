package kr.pe.frame.cmm.core.filter;

import kr.pe.frame.cmm.util.XSSUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

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
public class RequestWrapper extends HttpServletRequestWrapper {
    /**
     * Constructs a request object wrapping the given request.
     *
     * @param request
     * @throws IllegalArgumentException if the request is null
     */
    public RequestWrapper(HttpServletRequest request) {
        super(request);
    }

    /**
     * Request Paramers 반환
     * @param parameter
     * @return
     */
    public String[] getParameterValues(String parameter) {

        String[] values = super.getParameterValues(parameter);
        if (values==null)  {
            return null;
        }
        int count = values.length;
        String[] encodedValues = new String[count];
        for (int i = 0; i < count; i++) {
            encodedValues[i] = XSSUtil.cleanReqParamXSS(values[i]);
        }
        return encodedValues;
    }

    /**
     * Request Parameter XSS 처리
     * @param parameter
     * @return
     */
    public String getParameter(String parameter) {
        String value = super.getParameter(parameter);
        if (value == null) {
            return null;
        }
        return XSSUtil.cleanReqParamXSS(value);
    }

    /**
     * Http Header XSS 처리
     * @param name
     * @return
     */
    public String getHeader(String name) {
        String value = super.getHeader(name);
        if (value == null){
            return null;
        }
        return XSSUtil.cleanReqParamXSS(value);

    }
}
