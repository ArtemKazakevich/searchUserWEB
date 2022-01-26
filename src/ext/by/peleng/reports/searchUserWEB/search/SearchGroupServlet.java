package ext.by.peleng.reports.searchUserWEB.search;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SearchGroupServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String groupName = request.getParameter("groupName");
          request.getSession().setAttribute("groupName", groupName);
     
          String path = request.getContextPath() + "/servlet/searchUserWEB/search/groups";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/search/searchGroup.jsp").forward(request, response);
     }
}
