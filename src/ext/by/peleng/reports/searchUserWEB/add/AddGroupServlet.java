package ext.by.peleng.reports.searchUserWEB.add;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.inf.container.WTContainer;
import wt.inf.container._WTContainer;
import wt.inf.library.WTLibrary;
import wt.pdmlink.PDMLinkProduct;
import wt.project.Role;
import wt.query.QuerySpec;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class AddGroupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        List<WTContainer> wtContainerList = new ArrayList<>();
        List<Role> roleList = new ArrayList<>();

        String[] selectedProductForGroup = request.getParameterValues("selectedProductForGroup");
        String[] selectedRoleForGroup = request.getParameterValues("selectedRoleForGroup");

        List<WTContainer> containersList = getAllContainersInWindchill();
        containersList.sort(Comparator.comparing(_WTContainer::getName));

        Role[] rs = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(rs));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        if (selectedProductForGroup != null && selectedProductForGroup.length > 0) {

            for (WTContainer wtContainer : containersList) {
                for (String container : selectedProductForGroup) {
                    if (wtContainer.getName().equals(container)) {
                        wtContainerList.add(wtContainer);
                    }
                }
            }
        }

        if (selectedRoleForGroup != null && selectedRoleForGroup.length > 0) {

            for (Role role : roles) {
                for (String r : selectedRoleForGroup) {
                    if (role.getDisplay(new Locale("ru", "RU")).equals(r)) {
                        roleList.add(role);
                    }
                }
            }
        }

        request.getSession().setAttribute("wtContainerList_addGroup", wtContainerList);
        request.getSession().setAttribute("roleList_addGroup", roleList);

        String path = request.getContextPath() + "/servlet/searchUserWEB/add/finishGroup";
        response.sendRedirect(path);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<WTContainer> containers = getAllContainersInWindchill();
        containers.sort(Comparator.comparing(_WTContainer::getName));

        // получаем все роли Windchilla
        Role[] r = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(r));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        request.getSession().setAttribute("containersForGroup", containers);
        request.getSession().setAttribute("rolesForGroup", roles);

        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/add/addGroup.jsp").forward(request, response);
    }

    private ArrayList<WTContainer> getAllContainersInWindchill() {
        ArrayList<WTContainer> containers = new ArrayList<WTContainer>();
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
