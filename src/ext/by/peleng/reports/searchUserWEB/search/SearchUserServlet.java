package ext.by.peleng.reports.searchUserWEB.search;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SearchUserServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String lastName = request.getParameter("lastName");
          request.getSession().setAttribute("lastName", lastName);
     
          String path = request.getContextPath() + "/servlet/searchUserWEB/search/users";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/search/searchUser.jsp").forward(request, response);
     }
}
