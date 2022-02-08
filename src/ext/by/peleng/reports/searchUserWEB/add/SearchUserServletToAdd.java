package ext.by.peleng.reports.searchUserWEB.add;

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

public class SearchUserServletToAdd extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String add_selectedUser = request.getParameter("add_selectedUser");
          request.getSession().setAttribute("add_selectedUser", add_selectedUser);
          
          String path = request.getContextPath() + "/servlet/searchUserWEB/add/addUser";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          List<String> userList = findAllUser();

          request.getSession().setAttribute("userList", userList);

          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/add/searchUserToAdd.jsp").forward(request, response);
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
