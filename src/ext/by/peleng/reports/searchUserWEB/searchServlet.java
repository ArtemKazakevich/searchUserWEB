package ext.by.peleng.reports.searchUserWEB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class searchServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String lastName = request.getParameter("lastName");
          request.getSession().setAttribute("lastName", lastName);
     
          String path = request.getContextPath() + "/servlet/searchUserWEB/users";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/search.jsp").forward(request, response);
     }
}
