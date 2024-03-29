<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.*" %>
<%@ page import="wt.util.WTException" %>
<%@ page import="wt.inf.container.WTContainer" %>
<%@ page import="wt.inf.team.ContainerTeam" %>
<%@ page import="wt.inf.team.ContainerTeamHelper" %>
<%@ page import="wt.inf.team.ContainerTeamManaged" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wt.project.Role" %>
<%@ page import="wt.org.WTPrincipalReference" %>
<%@ page import="wt.inf.team.StandardContainerTeamService" %>
<%@ page import="wt.org.WTGroup" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="wt.org.OrganizationServicesHelper" %>
<%@ page import="wt.org.WTPrincipal" %>
<%@ page import="wt.org.WTUser" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.query.QueryException" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.pdmlink.PDMLinkProduct" %>
<%@ page import="wt.inf.library.WTLibrary" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="wt.fc.ReferenceFactory" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Search User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/search/reportForSelectedUserStyle.css?ts=<?=time()?">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">

    <script type="text/javascript">
        var checked = false;
        function checkedAll (frm1) {
            var a = document.getElementById("frm1");

            if (checked == false) {
                checked = true;
            } else {
                checked = false;
            }

            for (var i = 0; i < a.elements.length; i++) {
                a.elements[i].checked = checked;
            }

        }
    </script>

</head>

<body>

<div id="page-preloader" class="preloader">
    <div class="loader">
        <span>Загрузка...</span>
    </div>
</div>

<%
    WTUser selectedUser = getUserByName((String) request.getSession().getAttribute("selectedUser"));
    List<WTContainer> containers = getAllContainersInWindchill();
    LinkedHashMap<WTContainer, HashSet<Role>> containersWithSelectedUser = new LinkedHashMap<>();

    containers.sort((o1, o2) -> o1.getName().compareTo(o2.getName()));

    int number = 0;

    for (WTContainer container : containers) {
        ContainerTeamManaged teamManaged = (ContainerTeamManaged) container;
        Set<Role> roles = getContainerTeamRolesWithSelectedUser(teamManaged, selectedUser);
        if (roles.size() > 0) {
            containersWithSelectedUser.put(container, (HashSet<Role>) roles);
        }
    }

    if (!containersWithSelectedUser.isEmpty()) {
%>
<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<form id="frm1" method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/search/reportForSelectedUserServlet">
    <button id="js-button"><span>Удалить выбранное</span></button>
    <table id="data">
        <caption>Изделия, к которым имеет доступ <%=selectedUser.getFullName().replace(",", "")%></caption>
        <tr>
            <th>№</th>
            <th>Изделия (<span id="num"></span>)</th>
            <th>Роль</th>
            <th>
                Выбрать
                <br>
                <label class="container">
                    <input type="checkbox" onclick="checkedAll();" name="checkAll"/>
                    <span class="checkboxTh"></span>
                </label>
            </th>
        </tr>
        <%
            ReferenceFactory refFact = new ReferenceFactory();
            for (Map.Entry<WTContainer, HashSet<Role>> entries : containersWithSelectedUser.entrySet()) {
                WTContainer container = entries.getKey();
                HashSet<Role> roles = entries.getValue();
                boolean isFirstElement = true;
                String oid = "";

                try {
                    oid = refFact.getReferenceString(container);
                } catch (WTException e) {
                    e.printStackTrace();
                }

                for (Role role : roles) {

                    if (isFirstElement) {
                        number++;
        %>
        <tr>
            <td>
                <%=number%>
            </td>
            <td>
                <a href="https://wch.peleng.jsc.local/Windchill/app/#ptc1/library/listTeam?oid=<%=refFact.getReferenceString(container)%>" target="_blank"><%=container.getName()%></a>
            </td>
                <%
                isFirstElement = false;
                } else {
            %>
        <tr>
            <td></td>
            <td></td>
            <%
                }
            %>
            <td><%=role.getDisplay(new Locale("ru", "RU"))%></td>
            <td>
                <label class="container">
                    <input type="checkbox" name="id" value="<%=oid%>">
                    <span class="checkMark"></span>
                </label>
            </td>
        </tr>
        <%
                }
            }
        %>

    </table>

    <script>
        document.getElementById("num").innerHTML = <%=number%>;
    </script>

    <%

    } else {

    %>

    <h3>Пользователь <b><%=selectedUser.getFullName().replace(",", "")%></b> не имеет доступа к контекстам.</h3>

    <form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
        <button><span>На главную</span></button>
    </form>

    <%
        }
    %>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

<%!
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
%>

<%!
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
%>

<%!
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
%>

<%!
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
%>


<%!
    // метод получения user из БД
    private static WTUser getUserByName(String userName) {
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
                if (userName.equals(user.getFullName().replace(",", ""))) {
                    u = user;
                }
            }
        }

        return u;
    }
%>
</body>
</html>