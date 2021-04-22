package ext.by.peleng.reports.searchUserWEB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class indexServlet extends HttpServlet {
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/index.jsp").forward(request, response);
     }
}
