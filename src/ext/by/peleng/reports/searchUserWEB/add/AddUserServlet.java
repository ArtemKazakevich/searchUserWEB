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
