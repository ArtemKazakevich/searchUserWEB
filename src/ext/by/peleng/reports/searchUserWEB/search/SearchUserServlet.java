package ext.by.peleng.reports.searchUserWEB.search;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.query.QuerySpec;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SearchUserServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String selectedUser = request.getParameter("selectedUser");
          request.getSession().setAttribute("selectedUser", selectedUser);

          String path = request.getContextPath() + "/servlet/searchUserWEB/search/reportForSelectedUserServlet";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          List<String> userList = findAllUser();

          request.getSession().setAttribute("userListToSearch", userList);

          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/search/searchUser.jsp").forward(request, response);
     }

     // получаем всех пользователей
     private List<String> findAllUser() {

          List<String> users = new ArrayList<>();

          QuerySpec querySpec;
          QueryResult qr = null;
          try {
               querySpec = new QuerySpec(WTUser.class);
               qr = PersistenceHelper.manager.find(querySpec);
          } catch (WTException e) {
               e.printStackTrace();
          }

          while (qr.hasMoreElements()) {
               WTUser user = (WTUser) qr.nextElement();

               if (!user.isDisabled()) {
                    users.add(user.getFullName().replace(",", ""));
               }
          }

          Collections.sort(users);

          return users;
     }
}
