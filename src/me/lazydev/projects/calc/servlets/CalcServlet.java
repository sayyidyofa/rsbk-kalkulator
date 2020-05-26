package me.lazydev.projects.calc.servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;
import me.lazydev.projects.calc.beans.CalcBean;

@WebServlet(name = "CalcServlet", urlPatterns = "/CalcServlet")
public class CalcServlet extends HttpServlet {

    private final CalcBean calcBean = new CalcBean();
    private final Logger log = Logger.getLogger(CalcServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!request.getParameter("expression").isEmpty()) {
            String answer = calcBean.calculate(request.getParameter("expression"));
            request.getSession().setAttribute("answer", answer);
            response.setContentType("text/html;charset=UTF-8");
            try {
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/index.jsp");
                rd.include(request, response);
            } catch (ServletException | IOException exception) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server Error occurred: " + exception.getLocalizedMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Malformed /POST request!");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //request.getSession().setAttribute("cobaSession", "hello there, address " + request.getRemoteAddr());
        //String x = (String) request.getSession().getAttribute("cobaSession");
        log.info("Got a /GET request!");
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "/GET is not supported! Supported methods are: [/POST]");
        //System.out.println("Got session: " + request.getSession().getAttribute("cobaSession"));
    }
}
