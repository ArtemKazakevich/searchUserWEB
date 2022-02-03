package ext.by.peleng.reports.searchUserWEB.add;

import wt.inf.container.WTContainer;
import wt.inf.container._WTContainer;
import wt.inf.library.WTLibrary;
import wt.inf.team.*;
import wt.org.*;
import wt.pdmlink.PDMLinkProduct;
import wt.project.Role;
import wt.query.QueryException;
import wt.util.WTException;
import wt.pom.Transaction;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.pds.StatementSpec;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.util.WTException;
import wt.workflow.work.WorkItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        List<WTContainer> wtContainerList = new ArrayList<>();
        List<Role> roleList = new ArrayList<>();

        String[] selectedProductForUser = request.getParameterValues("selectedProductForUser");
        String[] selectedRoleForUser = request.getParameterValues("selectedRoleForUser");

        List<WTContainer> containersList = getAllContainersInWindchill();
        containersList.sort(Comparator.comparing(_WTContainer::getName));

        Role[] rs = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(rs));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        if (selectedProductForUser != null && selectedProductForUser.length > 0) {

            for (WTContainer wtContainer : containersList) {
                for (String container : selectedProductForUser) {
                    if (wtContainer.getName().equals(container)) {
                        wtContainerList.add(wtContainer);
                    }
                }
            }
        }

        if (selectedRoleForUser != null && selectedRoleForUser.length > 0) {

            for (Role role : roles) {
                for (String r : selectedRoleForUser) {
                    if (role.getDisplay(new Locale("ru", "RU")).equals(r)) {
                        roleList.add(role);
                    }
                }
            }
        }

        request.getSession().setAttribute("wtContainerList_add", wtContainerList);
        request.getSession().setAttribute("roleList_add", roleList);

        String path = request.getContextPath() + "/servlet/searchUserWEB/add/finish";
        response.sendRedirect(path);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<WTContainer> containers = getAllContainersInWindchill();
        containers.sort(Comparator.comparing(_WTContainer::getName));

        // получаем все роли Windchilla
        Role[] r = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(r));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        request.getSession().setAttribute("containersForUser", containers);
        request.getSession().setAttribute("rolesForUser", roles);

        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/add/addUser.jsp").forward(request, response);
    }

    private ArrayList<WTContainer> getAllContainersInWindchill() {
        ArrayList<WTContainer> containers = new ArrayList<>();
        try {
            QuerySpec querySpec = new QuerySpec(WTContainer.class);
            QueryResult qr = PersistenceHelper.manager.find(querySpec);
            while (qr.hasMoreElements()) {
                Object object = qr.nextElement();
                if (object instanceof PDMLinkProduct || object instanceof WTLibrary) {
                    containers.add((WTContainer) object);
                }
            }
        } catch (WTException e) {
            e.printStackTrace();
        }

        return containers;
    }
}
