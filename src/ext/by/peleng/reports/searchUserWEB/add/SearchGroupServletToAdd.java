package ext.by.peleng.reports.searchUserWEB.add;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTGroup;
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

public class SearchGroupServletToAdd extends HttpServlet {
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");

          String add_selectedGroup = request.getParameter("add_selectedGroup");
          request.getSession().setAttribute("add_selectedGroup", add_selectedGroup);

          String path = request.getContextPath() + "/servlet/searchUserWEB/add/addGroup";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          List<String> groupList = findAllGroup();

          request.getSession().setAttribute("groupList", groupList);

          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/add/searchGroupToAdd.jsp").forward(request, response);
     }

     // получаем все группы
     private List<String> findAllGroup() {

          List<String> groups = new ArrayList<>();

          QuerySpec querySpec;
          QueryResult qr = null;
          try {
               querySpec = new QuerySpec(WTGroup.class);
               qr = PersistenceHelper.manager.find(querySpec);
          } catch (WTException e) {
               e.printStackTrace();
          }

          while (qr.hasMoreElements()) {
               WTGroup group = (WTGroup) qr.nextElement();

               if (!group.isDisabled()) {

                    // (group.getDn() != null & group.getContainerName().equals("PELENG"))
                    if (group.getDn() != null) {
                         groups.add(group.getName());
                    }
               }
          }

          Collections.sort(groups);

          return groups;
     }
}
