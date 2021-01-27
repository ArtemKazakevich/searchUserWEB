package ext.by.peleng.reports.searchUserWEB;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
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

public class test extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

//          String[] ids = request.getParameterValues("id");
//          ArrayList<String> list = new ArrayList<>(Arrays.asList(ids));
//
//          request.getSession().setAttribute("list", list);
//
//          String path = request.getContextPath() + "/netmarkets/jsp/by/peleng/reports/searchUserWEB/list.jsp";
//          response.sendRedirect(path);
          
          WTUser selectedUser = getUserByName((String) request.getSession().getAttribute("selectedUser"));
          List<WTContainer> containers = getAllContainersInWindchill();
          Map<WTContainer, HashSet<Role>> containersWithSelectedUser = new HashMap<WTContainer, HashSet<Role>>();
          
          for (WTContainer container : containers) {
               ContainerTeamManaged teamManaged = (ContainerTeamManaged) container;
               Set<Role> roles = getContainerTeamRolesWithSelectedUser(teamManaged, selectedUser);
               if (roles.size() > 0) {
                    containersWithSelectedUser.put(container, (HashSet<Role>) roles);
               }
          }
          
          String[] ids = request.getParameterValues("id");
          
          if (ids != null && ids.length > 0) {
               
               for (Map.Entry<WTContainer, HashSet<Role>> entries : containersWithSelectedUser.entrySet()) {
                    WTContainer container = entries.getKey();
                    HashSet<Role> roles = entries.getValue();
                    
                    for (String str : ids) {
                         
                         if (container.getName().contains(str)) {
                              
                              try {
                                   PDMLinkProduct prod = (PDMLinkProduct) PersistenceHelper.manager.refresh(container);
                                   ContainerTeam team = ContainerTeamHelper.service.getContainerTeam(prod);
                                   
                                   for (Role role : roles) {
                                        ContainerTeamHelper.service.removeMember(team, role, selectedUser);
                                   }
                                   
                              } catch (WTException e) {
                                   e.printStackTrace();
                              }
                         }
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
     
     private static HashSet<Role> getContainerTeamRolesWithSelectedUser(ContainerTeamManaged teamManaged, WTUser user) {
          HashSet<Role> roles = new HashSet<Role>();
          
          try {
               if (teamManaged != null) {
                    ContainerTeam team = ContainerTeamHelper.service.getContainerTeam(teamManaged);
                    Vector<?> vector = team.getRoles();
                    if (vector == null) {
                         return roles;
                    }
                    
                    for (Object obj : vector) {
                         if (obj instanceof Role) {
                              Role role = (Role) obj;
                              if (getContainerUsersByRole(teamManaged, role).contains(user)) {
                                   roles.add(role);
                              }
                         }
                    }
               }
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return roles;
     }
     
     private static HashSet<WTUser> getContainerUsersByRole(ContainerTeamManaged teamManaged, Role role) {
          HashSet<WTUser> users = new HashSet<WTUser>();
          
          try {
               if (teamManaged != null) {
                    ContainerTeam team = ContainerTeamHelper.service.getContainerTeam(teamManaged);
                    StandardContainerTeamService standardContainer = StandardContainerTeamService.newStandardContainerTeamService();
                    WTGroup group = standardContainer.findContainerTeamGroup(team, ContainerTeamHelper.ROLE_GROUPS, role.toString());
                    if (group != null) {
                         Enumeration<?> enumeration = OrganizationServicesHelper.manager.members(group, false, true);
                         while (enumeration.hasMoreElements()) {
                              WTPrincipalReference principalReference = WTPrincipalReference.newWTPrincipalReference((WTPrincipal) enumeration.nextElement());
                              WTPrincipal principal = principalReference.getPrincipal();
                              if (principal instanceof WTUser) {
                                   users.add((WTUser) principal);
                              } else if (principal instanceof WTGroup) {
                                   users.addAll(getGroupMembersOfUser((WTGroup) principal));
                              }
                         }
                    }
               }
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return users;
     }
     
     private static HashSet<WTUser> getGroupMembersOfUser(WTGroup group) {
          HashSet<WTUser> members = new HashSet<WTUser>();
          
          try {
               Enumeration<?> member = group.members();
               while (member.hasMoreElements()) {
                    WTPrincipal principal = (WTPrincipal) member.nextElement();
                    if (principal instanceof WTUser) {
                         members.add((WTUser) principal);
                    } else if (principal instanceof WTGroup) {
                         members.addAll(getGroupMembersOfUser((WTGroup) principal));
                    }
               }
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return members;
     }
     
     private static ArrayList<WTContainer> getAllContainersInWindchill() {
          List<WTContainer> containers = new ArrayList<WTContainer>();
          try {
               QuerySpec querySpec = new QuerySpec(WTContainer.class);
               QueryResult qr = PersistenceHelper.manager.find(querySpec);
               while (qr.hasMoreElements()) {
                    Object object = qr.nextElement();
                    if (object instanceof PDMLinkProduct || object instanceof WTLibrary) {
                         containers.add((WTContainer) object);
                    }
               }
          } catch (QueryException e) {
               e.printStackTrace();
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return (ArrayList<WTContainer>) containers;
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
