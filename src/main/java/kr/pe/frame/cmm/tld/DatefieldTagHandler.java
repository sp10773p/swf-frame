package kr.pe.frame.cmm.tld;

import kr.pe.frame.cmm.util.StringUtil;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

/**
 * datefield toDataefield taglib
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see
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
public class DatefieldTagHandler extends SimpleTagSupport {
    private String value = null;
    private String to = null;

    @Override
    public void doTag() throws JspException, IOException {
        String str = " datefield";
        if(StringUtil.isNotEmpty(value)){
            str += "='" + value + "'";
        }

        if(StringUtil.isNotEmpty(to)){
            str += " toDataefield='" + to + "' ";
        }
        str += " ";

        getJspContext().getOut().write(str);
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void setTo(String to) {
        this.to = to;
    }
}
