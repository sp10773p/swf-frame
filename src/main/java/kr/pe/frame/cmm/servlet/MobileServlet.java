package kr.pe.frame.cmm.servlet;

import kr.pe.frame.cmm.core.base.Constant;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @author 성동훈
 * @version 1.0
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017-03-27  성동훈  최초 생성
 * </pre>
 * @since 2017-03-27
 */
public class MobileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        String url;
        if(session.getAttribute(Constant.SESSION_KEY_MBL.getCode()) == null){
            url = "/mobileLogin.do";
        }else{
            req.setAttribute("sessionDiv", Constant.MBL_SESSION_DIV.getCode());
            url = "/mobileMain.do";

        }

        RequestDispatcher dispatcher = req.getRequestDispatcher(url);
        dispatcher.forward(req, resp);
    }
}
