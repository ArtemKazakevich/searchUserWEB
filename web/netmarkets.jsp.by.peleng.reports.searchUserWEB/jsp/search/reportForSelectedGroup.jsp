<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="wt.util.WTException" %>
<%@ page import="wt.inf.container.WTContainer" %>
<%@ page import="wt.inf.team.ContainerTeam" %>
<%@ page import="wt.inf.team.ContainerTeamHelper" %>
<%@ page import="wt.inf.team.ContainerTeamManaged" %>
<%@ page import="wt.project.Role" %>
<%@ page import="wt.org.WTPrincipalReference" %>
<%@ page import="wt.inf.team.StandardContainerTeamService" %>
<%@ page import="wt.org.WTGroup" %>
<%@ page import="wt.org.OrganizationServicesHelper" %>
<%@ page import="wt.org.WTPrincipal" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.query.QueryException" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.pdmlink.PDMLinkProduct" %>
<%@ page import="wt.inf.library.WTLibrary" %>
<%@ page import="wt.fc.ReferenceFactory" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/search/reportForSelectedUserStyle.css?ts=<?=time()?">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">

    <script type="text/javascript">
        var checked = false;

        function checkedAll(frm_group) {
            var a = document.getElementById("frm_group");

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
    <div class="loader" role="status">
        <span>Загрузка...</span>
    </div>
</div>

<%
    WTGroup selectedGroup = getGroupByName((String) request.getSession().getAttribute("selectedGroup"));
    List<WTContainer> containers = getAllContainersInWindchill();
    LinkedHashMap<WTContainer, HashSet<Role>> containersWithSelectedGroup = new LinkedHashMap<>();

    containers.sort((o1, o2) -> o1.getName().compareTo(o2.getName()));

    int number = 0;

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

<form id="frm_group" method="post"
      action="${pageContext.request.contextPath}/servlet/searchUserWEB/search/reportForSelectedGroupServlet">
    <button id="js-button"><span>Удалить выбранное</span></button>
    <table id="data_group">
        <caption>Изделия, к которым имеет доступ ${selectedGroup}</caption>
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
            for (Map.Entry<WTContainer, HashSet<Role>> entries : containersWithSelectedGroup.entrySet()) {
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
                <a href="https://wch.peleng.jsc.local/Windchill/app/#ptc1/library/listTeam?oid=<%=refFact.getReferenceString(container)%>"
                   target="_blank"><%=container.getName()%>
                </a>
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
            <td><%=role.getDisplay(new Locale("ru", "RU"))%>
            </td>
            <td>
                <label class="container">
                    <input type="checkbox" name="id_group" value="<%=oid%>">
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

    <h3>Группа <b>${selectedGroup}</b> не имеет доступа к контекстам.</h3>

    <form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
        <button><span>На главную</span></button>
    </form>

    <%
        }
    %>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

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
    // метод получения группы из БД
    private WTGroup getGroupByName(String searchGroup) {

        WTGroup g = null;
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
                if (searchGroup.equals(group.getName())) {
                    g = group;
                }
            }
        }

        return g;
    }
%>
</body>
</html>