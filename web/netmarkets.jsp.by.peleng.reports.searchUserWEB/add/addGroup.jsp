<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

<html>
<head>
    <title>Add Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addGroupStyle.css">
    <script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/jsQuery/jquery-3.6.0.min.js"></script>
</head>
<body>

<%
    WTGroup selectedGroup = getGroup((String) request.getSession().getAttribute("add_selectedGroup"));
%>

<p>Группа, которую Вы хотите добавить: <%=selectedGroup.getName()%>
</p>

<div class="box form">

    <div class="block_input">
        <input type="text" id="inputProduct" placeholder="Поиск изделий">
        <select style="margin-bottom: 20%;" id="selectProduct" multiple="true" class="product_1">
            <c:forEach items="${containersForGroup}" var="container">
                <option value="${container.getName()}">${container.getName()}</option>
            </c:forEach>
        </select>

        <input type="text" id="inputRole" placeholder="Поиск роли">
        <select id="selectRole" multiple="true" class="role_1">
            <c:forEach items="${rolesForGroup}" var="role">
                <option value="${role.getDisplay()}">${role.getDisplay()}</option>
            </c:forEach>
        </select>
    </div>

    <div class="block_input">
        <div style="margin-bottom: 28%;" class="button">
            <button class="addProduct"><span>Добавить </span></button>
            <button class="addAllProduct"><span>Добавить все </span></button>
            <button class="removeProduct"><span>Удалить </span></button>
            <button class="removeAllProduct"><span>Удалить все </span></button>
        </div>
        <div class="button">
            <button class="addRole"><span>Добавить </span></button>
            <button class="addAllRole"><span>Добавить все </span></button>
            <button class="removeRole"><span>Удалить </span></button>
            <button class="removeAllRole"><span>Удалить все </span></button>
        </div>
    </div>

    <form class="block_input">
        <select style="margin-bottom: 30%;" multiple="true" class="product_2"></select>
        <select multiple="true" class="role_2"></select>
    </form>

</div>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button class="button_exit"><span>На главную</span></button>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/add/addGroupScript.js"></script>

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
