<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="wt.util.WTException" %>
<%@ page import="wt.inf.container.WTContainer" %>
<%@ page import="wt.inf.team.ContainerTeam" %>
<%@ page import="wt.inf.team.ContainerTeamHelper" %>
<%@ page import="wt.inf.team.ContainerTeamManaged" %>
<%@ page import="wt.project.Role" %>
<%@ page import="wt.inf.team.StandardContainerTeamService" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.query.QueryException" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.pdmlink.PDMLinkProduct" %>
<%@ page import="wt.inf.library.WTLibrary" %>
<%@ page import="wt.fc.ReferenceFactory" %>
<%@ page import="java.util.*" %>
<%@ page import="wt.inf.container.OrgContainer" %>
<%@ page import="wt.org.*" %>
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
    WTGroup selectedGroup = getGroup((String) request.getSession().getAttribute("add_selectedGroup"));
%>

<p>Группа, которую Вы хотите добавить:</p>
<p><%=selectedGroup.getName()%></p>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<%!
    private WTGroup getGroup(String searchGroup) {

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
