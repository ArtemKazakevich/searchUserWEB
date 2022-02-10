package ext.by.peleng.reports.searchUserWEB.search;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTGroup;
import wt.pds.StatementSpec;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class GroupsServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String selectedGroup = request.getParameter("selectedGroup");
          request.getSession().setAttribute("selectedGroup", selectedGroup);
     
          String path = request.getContextPath() + "/servlet/searchUserWEB/search/reportForSelectedGroupServlet";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          String groupName = (String) request.getSession().getAttribute("groupName");
          List<WTGroup> groups = findGroupByLastName(groupName);
          
          if (!groups.isEmpty()) {
               request.getSession().setAttribute("groups", groups);
               request.getSession().setAttribute("flagGroup", true);
          } else {
               request.getSession().setAttribute("flagGroup", false);
          }
          
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/search/groups.jsp").forward(request, response);
     }
     
     private static ArrayList<WTGroup> findGroupByLastName(String groupName) {
          ArrayList<WTGroup> groups = new ArrayList<>();
          
          try {
               QuerySpec querySpec = new QuerySpec(WTGroup.class);
               SearchCondition searchCondition = new SearchCondition(WTGroup.class, WTGroup.NAME, SearchCondition.LIKE, groupName.replace("*","%"), false);
               querySpec.appendWhere(searchCondition, null);
               QueryResult queryResult = PersistenceHelper.manager.find((StatementSpec) querySpec);
               
               while (queryResult.hasMoreElements()) {
                    WTGroup group = (WTGroup) queryResult.nextElement();
          
                    if (!group.isDisabled()) {
                         groups.add(group);
                    }
               }
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return groups;
     }
}
