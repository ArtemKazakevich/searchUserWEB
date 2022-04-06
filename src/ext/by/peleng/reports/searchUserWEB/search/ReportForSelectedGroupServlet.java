package ext.by.peleng.reports.searchUserWEB.search;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.inf.container.WTContainer;
import wt.inf.team.*;
import wt.org.WTGroup;
import wt.pom.Transaction;
import wt.project.Role;
import wt.query.QuerySpec;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Locale;

public class ReportForSelectedGroupServlet extends HttpServlet {

     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

          WTGroup selectedGroup = getGroupByName((String) request.getSession().getAttribute("selectedGroup"));
          String[] ids = request.getParameterValues("id_group");

          System.out.println("Start testDeleteGroupFromRole");
          System.out.println("Name group - " + selectedGroup.getName());

          if (ids != null && ids.length > 0) {

               for (String oid : ids) {

                    wt.fc.ReferenceFactory rf = new wt.fc.ReferenceFactory();
                    Object objContainer = null;

                    try {
                         objContainer = rf.getReference(oid).getObject();
                    } catch (WTException e) {
                         e.printStackTrace();
                    }

                    WTContainer container = (WTContainer) objContainer;

                    Transaction localTransaction = new Transaction();

                    try {
                         localTransaction.start();

                         ContainerTeam localContainerTeam = ContainerTeamHelper.service.getContainerTeam((ContainerTeamManaged) container);

                         Enumeration localEnumeration = ContainerTeamServerHelper.service.findRoles(ContainerTeamReference.newContainerTeamReference(localContainerTeam), selectedGroup);
                         System.out.println("roles to be deleted " + localEnumeration);

                         while (localEnumeration.hasMoreElements()) {
                              Role localRole1 = (Role)localEnumeration.nextElement();
                              System.out.println("Name role - " + localRole1.getDisplay(new Locale("ru", "RU")));
                              localContainerTeam.deletePrincipalTarget(localRole1, selectedGroup);
                         }

                         localTransaction.commit();
                         localTransaction = null;

                         System.out.println("Good delete");
                    } catch (Exception e) {
                         e.printStackTrace();
                    } finally {

                         if(localTransaction!=null){
                              System.out.println("Error delete");
                              localTransaction.rollback();
                         }
                    }
               }

          }

          System.out.println("Finish testDeleteGroupFromRole");

          doGet(request, response);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/search/reportForSelectedGroup.jsp").forward(request, response);
     }

     // метод получения группы из БД
     private WTGroup getGroupByName(String searchGroup) {

          WTGroup g = null;
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
                    if (searchGroup.equals(group.getName())) {
                         g = group;
                    }
               }
          }

          return g;
     }
}
