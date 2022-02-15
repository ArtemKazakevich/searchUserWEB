package ext.by.peleng.reports.searchUserWEB.add;

import wt.inf.container.WTContainer;
import wt.inf.container._WTContainer;
import wt.inf.library.WTLibrary;
import wt.inf.team.*;
import wt.pdmlink.PDMLinkProduct;
import wt.project.Role;
import wt.util.WTException;
import wt.pom.Transaction;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.query.QuerySpec;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Получаем user, список изделий, список ролей из сессии. Списки полученны из jsp
        WTUser selectedUser = getUser((String) request.getSession().getAttribute("add_selectedUser"));
        String[] selectedProductForUser = request.getParameterValues("selectedProductForUser");
        String[] selectedRoleForUser = request.getParameterValues("selectedRoleForUser");

        List<WTContainer> containersList = getAllContainersInWindchill();

        System.out.println("**************");
        System.out.println("Start add User");

        // Проверка на пустой массив изделий и ролей
        if (selectedProductForUser != null && selectedProductForUser.length > 0) {
            if (selectedRoleForUser != null && selectedRoleForUser.length > 0) {

                for (WTContainer wtContainer : containersList) {

                    for (String container : selectedProductForUser) {

                        if (wtContainer.getName().equals(container)) {
                            boolean inStock = false;

                            ContainerTeam localContainerTeam = null;
                            Vector<?> vector = null;
                            try {
                                localContainerTeam = ContainerTeamHelper.service.getContainerTeam((ContainerTeamManaged) wtContainer);
                                vector = localContainerTeam.getRoles(); // Получаем список ролей в изделии
                            } catch (WTException e) {
                                e.printStackTrace();
                            }

                            List<Role> roles = new ArrayList<>();
                            for (Object obj : vector) {

                                if (obj instanceof Role) {
                                    Role role = (Role) obj;
                                    roles.add(role);
                                }
                            }

                            // Проверяем наличие роли(которую планируем добавить) в изделии.
                            for (String stringRole : selectedRoleForUser) {

                                for (Role role : roles) {

                                    // из jsp получаем роль на англ языке.
                                    if (role.getDisplay().equals(stringRole)) {
                                        addUserAndRole(role, selectedUser, localContainerTeam);
                                        inStock = true;
                                    }
                                }

                                // если нет роли в изделии, ищем ее из общего списка ролей Windchilla
                                if (!inStock) {
                                    Role[] roleSet = Role.getRoleSet(); // Получпем все роли Windchilla

                                    for (Role r : roleSet) {

                                        if (r.getDisplay().equals(stringRole)) {
                                            addUserAndRole(r, selectedUser, localContainerTeam);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        String path = request.getContextPath() + "/servlet/searchUserWEB/add/finish";
        response.sendRedirect(path);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        List<WTContainer> containers = getAllContainersInWindchill();
        containers.sort(Comparator.comparing(_WTContainer::getName));

        // получаем все роли Windchilla и сортируем
        Role[] r = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(r));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        request.getSession().setAttribute("containersForUser", containers);
        request.getSession().setAttribute("rolesForUser", roles);

        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/add/addUser.jsp").forward(request, response);
    }

    // метод получения всех изделий Windchilla
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

    // метод получения user из БД
    private WTUser getUser(String searchUser) {
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
                if (searchUser.equals(user.getFullName().replace(",", ""))) {
                    u = user;
                }
            }
        }

        return u;
    }

    // метод добавления user и роли в изделие
    private void addUserAndRole(Role role, WTUser user, ContainerTeam containerTeam) {
        Transaction localTransaction = new Transaction();

        try {
            localTransaction.start();

            ContainerTeam team = (ContainerTeam) PersistenceHelper.manager.refresh(containerTeam);
            ContainerTeamHelper.service.addMember(team, role, user);

            localTransaction.commit();
            localTransaction = null;

            System.out.println("Good add User");
            System.out.println("**************");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (localTransaction != null) {
                System.out.println("Error add User");
                System.out.println("**************");
                localTransaction.rollback();
            }
        }
    }
}
