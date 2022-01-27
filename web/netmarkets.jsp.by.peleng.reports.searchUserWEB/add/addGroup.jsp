<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
<%@ page import="wt.inf.container.OrgContainer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Add Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addGroupStyle.css">
</head>
<body>

<%
    WTGroup selectedGroup = getGroupByName((String) request.getSession().getAttribute("add_selectedGroup"));
    String group = (String) request.getSession().getAttribute("add_selectedGroup");
%>

<p><%=selectedGroup%></p>
<p><%=group%></p>

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
