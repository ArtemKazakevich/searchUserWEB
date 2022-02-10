package ext.by.peleng.reports.searchUserWEB.add;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class FinishServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/add/finish.jsp").forward(request, response);
    }
}
