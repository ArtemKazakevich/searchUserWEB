<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/reportForSelectedUserStyle.css">
    <style>
        th:last-child {
            border-top-right-radius: 10px;
            border-right: none;
            width: 35%;
        }
    </style>
</head>

<body>
<%
    WTGroup selectedGroup = getGroupByName((String) request.getSession().getAttribute("selectedGroup"));
    List<WTContainer> containers = getAllContainersInWindchill();
    Map<WTContainer, HashSet<Role>> containersWithSelectedGroup = new HashMap<>();

    for (WTContainer container : containers) {
        ContainerTeamManaged teamManaged = (ContainerTeamManaged) container;
        Set<Role> roles = getContainerTeamRolesWithSelectedGroup(teamManaged, selectedGroup);
        if (roles.size() > 0) {
            containersWithSelectedGroup.put(container, (HashSet<Role>) roles);
        }
    }

    if (!containersWithSelectedGroup.isEmpty()) {
%>
<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<table>
    <caption>Изделия, к которым имеет доступ ${selectedGroup}</caption>
    <tr>
        <th>Изделие</th>
        <th>Роль</th>
    </tr>
    <%
        ReferenceFactory refFact = new ReferenceFactory();
        for (Map.Entry<WTContainer, HashSet<Role>> entries : containersWithSelectedGroup.entrySet()) {
            WTContainer container = entries.getKey();
            HashSet<Role> roles = entries.getValue();
            boolean isFirstElement = true;

            for (Role role : roles) {
                if (isFirstElement) {
    %>
    <tr>
        <td>
            <a href="https://wch.peleng.jsc.local/Windchill/app/#ptc1/library/listTeam?oid=<%=refFact.getReferenceString(container)%>" target="_blank"><%=container.getName()%></a>
        </td>
            <%
                isFirstElement = false;
                } else {
            %>
    <tr>
        <td></td>
        <%
            }
        %>
        <td><%=role.getDisplay()%></td>
    </tr>
    <%
            }
        }
    %>

</table>

<%

} else {

%>

<h3>Пользователь <b>${selectedGroup}</b> не имеет доступа к контекстам.</h3>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<%
    }
%>

<%!
    private static HashSet<Role> getContainerTeamRolesWithSelectedGroup(ContainerTeamManaged teamManaged, WTGroup group) {
        HashSet<Role> roles = new HashSet<>();

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
                        if (getContainerGroupsByRole(teamManaged, role).contains(group)) {
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
    private static HashSet<WTGroup> getContainerGroupsByRole(ContainerTeamManaged teamManaged, Role role) {
        HashSet<WTGroup> groups = new HashSet<>();

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
                        if (principal instanceof WTGroup) {
                            groups.add((WTGroup) principal);
                        }
                    }
                }
            }
        } catch (WTException e) {
            e.printStackTrace();
        }

        return groups;
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
    private static WTGroup getGroupByName(String groupName) {
        try {
            return OrganizationServicesHelper.manager.getGroup(groupName);
        } catch (WTException e) {
            e.printStackTrace();
        }
        return null;
    }
%>
</body>
</html>