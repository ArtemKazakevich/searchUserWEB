<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="wt.project.Role" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.util.WTException" %>
<%@ page import="java.util.*" %>
<%@ page import="wt.workflow.work.WorkItem" %>
<%@ page import="wt.inf.container.WTContainer" %>
<%@ page import="wt.pdmlink.PDMLinkProduct" %>
<%@ page import="wt.inf.library.WTLibrary" %>
<%@ page import="wt.inf.container._WTContainer" %>
<%@ page import="wt.inf.team.ContainerTeam" %>
<%@ page import="wt.inf.team.ContainerTeamHelper" %>
<%@ page import="wt.inf.team.ContainerTeamManaged" %>
<%@ page import="wt.team.TeamManaged" %>
<%@ page import="wt.org.WTUser" %>
<%@ page import="wt.team.TeamHelper" %>
<%@ page import="wt.team.WTRoleHolder2" %>
<%@ page import="wt.pom.Transaction" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addUserStyle.css">
</head>
<body>

<%
    String container = "Тестовое Изделие";
    String addRole = "Консультант";
    String string = "";
    WTUser selectedUser = getUser("Мисюк Надежда Александровна");

    List<Role> roleList = new ArrayList<>();
    List<WTContainer> containersList = getAllContainersInWindchill();
    containersList.sort(Comparator.comparing(_WTContainer::getName));

    boolean inStock = false;

    System.out.println("**************");
    System.out.println("Start add User");

    for (WTContainer wtContainer : containersList) {
        if (wtContainer.getName().equals(container)) {

            ContainerTeam localContainerTeam = ContainerTeamHelper.service.getContainerTeam((ContainerTeamManaged) wtContainer);
            Vector vector = localContainerTeam.getRoles();

            for (Object obj : vector) {
                if (obj instanceof Role) {
                    Role role = (Role) obj;

                    if (role.getDisplay(new Locale("ru", "RU")).equals(addRole)) {
                        string = role.getDisplay(new Locale("ru", "RU"));
                        inStock = true;

                        addUserAndRole(role, selectedUser, localContainerTeam);
                    }
                }
            }

            if (!inStock) {
                Role[] rs = Role.getRoleSet();

                for (Role r : rs) {

                    if (r.getDisplay(new Locale("ru", "RU")).equals(addRole)) {
                        string = r.getDisplay(new Locale("ru", "RU"));

                        addUserAndRole(r, selectedUser, localContainerTeam);
                    }
                }
            }
        }
    }
%>

<p>*************************</p>
<p><%=selectedUser.getFullName().replace(",", "")%></p>
<p>*************************</p>
<p>Добавили роль <%=string%></p>

<%!
    private static ArrayList<WTContainer> getAllContainersInWindchill() {
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
%>

<%!
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
%>

<%!
    private void addUserAndRole (Role role, WTUser user, ContainerTeam containerTeam) {
        Transaction localTransaction = new Transaction();

        try {
            localTransaction.start();

            //Add role and user
//            TeamHelper.service.addRolePrincipalMap(role, user, container);

            ContainerTeam team = (ContainerTeam) PersistenceHelper.manager.refresh(containerTeam);
            ContainerTeamHelper.service.addMember(team, role, user);

            localTransaction.commit();
            localTransaction = null;

            System.out.println("Good add User");
            System.out.println("**************");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if(localTransaction != null){
                System.out.println("Error add");
                System.out.println("**************");
                localTransaction.rollback();
            }
        }
    }
%>

</body>
</html>
