package ext.by.peleng.reports.searchUserWEB;

import wt.inf.container.WTContainer;
import wt.inf.team.*;
import wt.org.*;
import wt.project.Role;
import wt.util.WTException;
import wt.pom.Transaction;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class reportForSelectedUserServlet extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
     
          WTUser selectedUser = getUserByName((String) request.getSession().getAttribute("selectedUser"));
          String[] ids = request.getParameterValues("id");
     
          System.out.println("Start testDeleteUserFromRole");
     
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
                         
                         ContainerTeam localContainerTeam = null;
                         localContainerTeam = ContainerTeamHelper.service.getContainerTeam((ContainerTeamManaged) container);
                    
                         Enumeration localEnumeration = ContainerTeamServerHelper.service.findRoles(ContainerTeamReference.newContainerTeamReference(localContainerTeam), selectedUser);
                         System.out.println("roles to be deleted " + localEnumeration);
                    
                         while (localEnumeration.hasMoreElements()) {
                              Role localRole1 = (Role)localEnumeration.nextElement();
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
//          String selectedUser = (String) request.getSession().getAttribute("selectedUser");
//          request.setAttribute("selectedUser", selectedUser);
          
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/reportForSelectedUser.jsp").forward(request, response);
     }
     
     private static WTUser getUserByName(String userName) {
          try {
               return OrganizationServicesHelper.manager.getUser(userName);
          } catch (WTException e) {
               e.printStackTrace();
          }
          return null;
     }
     
}
