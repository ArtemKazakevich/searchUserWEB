package ext.by.peleng.reports.searchUserWEB.add;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.inf.container.WTContainer;
import wt.inf.container._WTContainer;
import wt.inf.library.WTLibrary;
import wt.inf.team.ContainerTeam;
import wt.inf.team.ContainerTeamHelper;
import wt.inf.team.ContainerTeamManaged;
import wt.org.WTGroup;
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

public class AddGroupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Получаем группу, список изделий, список ролей из сессии. Списки полученны из jsp
        String[] selectedGroupForGroup = request.getParameterValues("selectedGroupForGroup");
        String[] selectedProductForGroup = request.getParameterValues("selectedProductForGroup");
        String[] selectedRoleForGroup = request.getParameterValues("selectedRoleForGroup");

        List<WTGroup> groupList = findAllGroup();
        List<WTContainer> containersList = getAllContainersInWindchill();

        System.out.println("**************");
        System.out.println("Start add Group");

        // Проверка на пустой массив групп, изделий и ролей
        if (selectedGroupForGroup != null && selectedGroupForGroup.length > 0) {
            if (selectedProductForGroup != null && selectedProductForGroup.length > 0) {
                if (selectedRoleForGroup != null && selectedRoleForGroup.length > 0) {

                    for (WTContainer wtContainer : containersList) {
                        for (String container : selectedProductForGroup) {
                            if (wtContainer.getName().equals(container)) {

                                for (WTGroup wtGroup : groupList) {
                                    for (String group : selectedGroupForGroup) {
                                        if (wtGroup.getName().equals(group)) {

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
                                            for (String stringRole : selectedRoleForGroup) {

                                                for (Role role : roles) {

                                                    // из jsp получаем роль на англ языке.
                                                    if (role.getDisplay().equals(stringRole)) {
                                                        addGroupAndRole(role, wtGroup, localContainerTeam);
                                                        inStock = true;
                                                    }
                                                }

                                                // если нет роли в изделии, ищем ее из общего списка ролей Windchilla
                                                if (!inStock) {
                                                    Role[] roleSet = Role.getRoleSet(); // Получпем все роли Windchilla

                                                    for (Role r : roleSet) {

                                                        if (r.getDisplay().equals(stringRole)) {
                                                            addGroupAndRole(r, wtGroup, localContainerTeam);
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
                }
            }

        }

        String path = request.getContextPath() + "/servlet/searchUserWEB/add/finish";
        response.sendRedirect(path);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // // получаем все группы
        List<WTGroup> groupList = findAllGroup();
        groupList.sort(((o1, o2) -> o1.getName().compareTo(o2.getName())));

        List<WTContainer> containers = getAllContainersInWindchill();
        containers.sort(Comparator.comparing(_WTContainer::getName));

        // получаем все роли Windchilla
        Role[] r = Role.getRoleSet();
        ArrayList<Role> roles = new ArrayList<>(Arrays.asList(r));
        roles.sort(Comparator.comparing((Role o) -> o.getDisplay(new Locale("ru", "RU"))));

        request.getSession().setAttribute("groupsForGroup", groupList);
        request.getSession().setAttribute("containersForGroup", containers);
        request.getSession().setAttribute("rolesForGroup", roles);

        request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/searchUserWEB/jsp/add/addGroup.jsp").forward(request, response);
    }

    // получаем все группы
    private List<WTGroup> findAllGroup() {

        List<WTGroup> groups = new ArrayList<>();

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

                // (group.getDn() != null & group.getContainerName().equals("PELENG"))
                if (group.getDn() != null) {
                    groups.add(group);
                }
            }
        }

        return groups;
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

    // метод добавления группы и роли в изделие
    private void addGroupAndRole(Role role, WTGroup group, ContainerTeam containerTeam) {
        Transaction localTransaction = new Transaction();

        try {
            localTransaction.start();

            ContainerTeam team = (ContainerTeam) PersistenceHelper.manager.refresh(containerTeam);
            ContainerTeamHelper.service.addMember(team, role, group);

            localTransaction.commit();
            localTransaction = null;

            System.out.println("Good add Group");
            System.out.println("**************");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (localTransaction != null) {
                System.out.println("Error add Group");
                System.out.println("**************");
                localTransaction.rollback();
            }
        }
    }
}
