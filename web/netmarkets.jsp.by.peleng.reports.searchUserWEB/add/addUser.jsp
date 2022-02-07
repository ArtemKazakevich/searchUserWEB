<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<html>
<head>
    <title>Add User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addUserStyle.css">
    <script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/jsQuery/jquery-3.6.0.min.js"></script>
</head>
<body>

<%
    WTUser selectedUser = getUser((String) request.getSession().getAttribute("add_selectedUser"));
%>

<p>Пользователь, которого Вы хотите добавить: <%=selectedUser.getFullName().replace(",", "")%>
</p>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button class="button_exit"><span>На главную</span></button>
</form>

<div class="box form">

    <div class="block_input">
        <input type="text" id="inputProduct" placeholder="Поиск изделий">
        <select style="margin-bottom: 20%;" id="selectProduct" multiple="true" class="product_1">
            <c:forEach items="${containersForUser}" var="container">
                <option value="${container.getName()}">${container.getName()}</option>
            </c:forEach>
        </select>

        <input type="text" id="inputRole" placeholder="Поиск роли">
        <select id="selectRole" multiple="true" class="role_1">
            <c:forEach items="${rolesForUser}" var="role">
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

    <form class="block_input_form" method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/add/addUser">
        <select id="select_1" style="margin: 10% 0 33%;" multiple="true" class="product_2" name="selectedProductForUser"></select>
        <select id="select_2" multiple="true" class="role_2" name="selectedRoleForUser"></select>
        <br>
        <button id="js-button-add" class="button_add"><span>Добавить пользователя </span></button>
    </form>

</div>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/add/addScript.js"></script>

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

</body>
</html>
