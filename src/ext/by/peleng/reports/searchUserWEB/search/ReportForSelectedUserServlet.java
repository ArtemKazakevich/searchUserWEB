package ext.by.peleng.reports.searchUserWEB.search;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.inf.container.WTContainer;
import wt.inf.team.*;
import wt.org.*;
import wt.project.Role;
import wt.query.QuerySpec;
import wt.util.WTException;
import wt.pom.Transaction;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class ReportForSelectedUserServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
     
          WTUser selectedUser = getUserByName((String) request.getSession().getAttribute("selectedUser"));
          String[] ids = request.getParameterValues("id");
     
          System.out.println("Start testDeleteUserFromRole");
          System.out.println("Name user - " + selectedUser.getFullName());
     
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
                    
                         Enumeration localEnumeration = ContainerTeamServerHelper.service.findRoles(ContainerTeamReference.newContainerTeamReference(localContainerTeam), selectedUser);
                         System.out.println("roles to be deleted " + localEnumeration);
                    
                         while (localEnumeration.hasMoreElements()) {
                              Role localRole1 = (Role)localEnumeration.nextElement();
                              System.out.println("Name role - " + localRole1.getDisplay(new Locale("ru", "RU")));
                              localContainerTeam.deletePrincipalTarget(localRole1, selectedUser);
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
     
          System.out.println("Finish testDeleteUserFromRole");
     
          doGet(request, response);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/search/reportForSelectedUser.jsp").forward(request, response);
     }

     // метод получения user из БД
     private static WTUser getUserByName(String userName) {
          WTUser u = null;
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
                    if (userName.equals(user.getFullName().replace(",", ""))) {
                         u = user;
                    }
               }
          }

          return u;
     }
     
}
