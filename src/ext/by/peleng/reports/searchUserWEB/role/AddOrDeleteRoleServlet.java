package ext.by.peleng.reports.searchUserWEB.role;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.inf.container.WTContainer;
import wt.inf.container._WTContainer;
import wt.inf.library.WTLibrary;
import wt.inf.team.ContainerTeam;
import wt.inf.team.ContainerTeamHelper;
import wt.inf.team.ContainerTeamManaged;
import wt.pdmlink.PDMLinkProduct;
import wt.pom.Transaction;
import wt.project.Role;
import wt.query.QuerySpec;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class AddOrDeleteRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Получаем user, список изделий, список ролей из сессии. Списки полученны из jsp
        String[] selectedProductForRole = request.getParameterValues("selectedProductForRole");
        String[] selectedRoleForRole = request.getParameterValues("selectedRoleForRole");
        String button = request.getParameter("typeButton");

        List<WTContainer> containersList = getAllContainersInWindchill();

        System.out.println("**************");
        System.out.println("Start of operations on the Role");

        // Проверка на пустой массив изделий и ролей
        if (selectedProductForRole != null && selectedProductForRole.length > 0) {
            if (selectedRoleForRole != null && selectedRoleForRole.length > 0) {

                for (WTContainer wtContainer : containersList) {

                    for (String container : selectedProductForRole) {

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

                            // Помещаем роли Изделия в List, для удобства работы
                            List<Role> roles = new ArrayList<>();
                            for (Object obj : vector) {

                                if (obj instanceof Role) {
                                    Role role = (Role) obj;
                                    roles.add(role);
                                }
                            }

                            // Проверяем наличие роли(которую планируем добавить) в изделии.
                            for (String stringRole : selectedRoleForRole) {

                                for (Role role : roles) {

                                    if (role.getDisplay(new Locale("ru", "RU")).equals(stringRole)) {

                                        if (button.equals("buttonAdd")) {
                                            System.out.println("**************");
                                            System.out.println("Роль уже есть в изделии");

                                            inStock = true;
                                        }

                                        if (button.equals("buttonDelete")) {
                                            System.out.println("**************");
                                            System.out.println("Start delete Role");

                                            deleteRole(role, localContainerTeam);
                                            inStock = true;
                                        }
                                    }
                                }

                                // если нет роли в изделии, ищем ее из общего списка ролей Windchilla
                                if (!inStock) {
                                    Role[] roleSet = Role.getRoleSet(); // Получпем все роли Windchilla

                                    for (Role r : roleSet) {

                                        if (r.getDisplay(new Locale("ru", "RU")).equals(stringRole)) {

                                            if (button.equals("buttonAdd")) {
                                                System.out.println("**************");
                                                System.out.println("Start add Role");

                                                addRole(r, localContainerTeam);
                                            }

                                            if (button.equals("buttonDelete")) {
                                                System.out.println("**************");
                                                System.out.println("Start delete Role");

                                                deleteRole(r, localContainerTeam);
                                            }
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<WTContainer> containers = getAllContainersInWindchill();
        containers.sort(Comparator.comparing(_WTContainer::getName));

        // получаем все роли Windchilla и сортируем
        Role[] r = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(r));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        request.getSession().setAttribute("containersForRole", containers);
        request.getSession().setAttribute("rolesForRole", roles);

        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/role/addOrDeleteRole.jsp").forward(request, response);
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

    // метод добавления роли в изделие
    private void addRole(Role role, ContainerTeam containerTeam) {
        Transaction localTransaction = new Transaction();

        try {
            localTransaction.start();

            ContainerTeam team = (ContainerTeam) PersistenceHelper.manager.refresh(containerTeam);
            ContainerTeamHelper.service.addMember(team, role, null);

            localTransaction.commit();
            localTransaction = null;

            System.out.println("Good add Role");
            System.out.println("**************");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (localTransaction != null) {
                System.out.println("Error add Role");
                System.out.println("**************");
                localTransaction.rollback();
            }
        }
    }

    // метод удаления роли в изделие
    private void deleteRole(Role role, ContainerTeam containerTeam) {
        Transaction localTransaction = new Transaction();

        try {
            localTransaction.start();

            ContainerTeam team = (ContainerTeam) PersistenceHelper.manager.refresh(containerTeam);
            ContainerTeamHelper.service.removeRole(team, role);

            localTransaction.commit();
            localTransaction = null;

            System.out.println("Good delete Role");
            System.out.println("**************");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (localTransaction != null) {
                System.out.println("Error delete Role");
                System.out.println("**************");
                localTransaction.rollback();
            }
        }
    }
}
