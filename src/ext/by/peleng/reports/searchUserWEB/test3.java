package ext.by.peleng.reports.searchUserWEB;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.fc.ReferenceFactory;
import wt.inf.container.WTContainer;
import wt.inf.library.WTLibrary;
import wt.inf.team.ContainerTeam;
import wt.inf.team.ContainerTeamHelper;
import wt.inf.team.ContainerTeamManaged;
import wt.inf.team.StandardContainerTeamService;
import wt.org.*;
import wt.pdmlink.PDMLinkProduct;
import wt.project.Role;
import wt.query.QueryException;
import wt.query.QuerySpec;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class test3 extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

//          String[] ids = request.getParameterValues("id");
//          ArrayList<String> list = new ArrayList<>(Arrays.asList(ids));
//
//          request.getSession().setAttribute("list", list);
//
//          String path = request.getContextPath() + "/netmarkets/jsp/by/peleng/reports/searchUserWEB/list.jsp";
//          response.sendRedirect(path);
          
          WTUser selectedUser = getUserByName((String) request.getSession().getAttribute("selectedUser"));
          
          String[] ids = request.getParameterValues("id");
          
          if (ids != null && ids.length > 0) {
               
               for (String oid : ids) {
                    
                    ReferenceFactory refFact = new ReferenceFactory();
                    WTContainer container = null;
                    try {
                         container = (WTContainer) refFact.getReference(oid).getObject();
                    } catch (WTException e) {
                         e.printStackTrace();
                    }
                    
                    try {
                         ContainerTeam team = ContainerTeamHelper.service.getContainerTeam((ContainerTeamManaged) container);
                         
                         Enumeration enum1 = ContainerTeamHelper.service.findContainerTeamGroups(team, ContainerTeamHelper.ROLE_GROUPS);
                         
                         while(enum1.hasMoreElements()){
                              WTGroup group = (WTGroup) enum1.nextElement();
     
                              if (group.isMember(selectedUser)) {
                                   System.out.println("Hello!!!");
                                   System.out.println(enum1);
                                   System.out.println(group);
                                   System.out.println(selectedUser);
                                   System.out.println("Hello!!!");
                                   
                                   wt.org.OrganizationServicesHelper.manager.removeMember(group, selectedUser);
                                   wt.fc.PersistenceHelper.manager.save(selectedUser);
                              }
                         }
                         
                    } catch (WTException e) {
                         e.printStackTrace();
                    }
                    
               }
               
          }
          
          doGet(request, response);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//          String selectedUser = (String) request.getSession().getAttribute("selectedUser");
//          request.setAttribute("selectedUser", selectedUser);
          
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/reportForSelectedUser.jsp").forward(request, response);
     }
     
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
     private static WTUser getUserByName(String userName) {
          try {
               return OrganizationServicesHelper.manager.getUser(userName);
          } catch (WTException e) {
               e.printStackTrace();
          }
          return null;
     }
     
     public List<Role> getTeamRoles(ContainerTeam team, WTUser user) throws WTException {
          Vector<Role> roles = new Vector<Role>();
          Enumeration enum1 = ContainerTeamHelper.service.findContainerTeamGroups(team, ContainerTeamHelper.ROLE_GROUPS);
          while (enum1.hasMoreElements()) {
               WTGroup group = (WTGroup) enum1.nextElement();
               if (group.isMember(user)) {
                    Role role = Role.toRole(group.getName());
                    if (!roles.contains(role)) {
                         roles.addElement(role);
                    }
               }
          }
          return roles;
     }
}
