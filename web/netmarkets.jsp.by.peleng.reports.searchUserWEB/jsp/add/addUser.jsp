<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="wt.util.WTException" %>
<%@ page import="wt.org.WTUser" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="java.util.Locale" %>

<html>
<head>
    <title>Add User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addUserStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
    <script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/jsQuery/jquery-3.6.0.min.js"></script>
</head>
<body>

<div id="page-preloader" class="preloader">
    <div class="loader">
        <span>Загрузка...</span>
    </div>
</div>

<%
    Locale myLocale = new Locale("ru", "RU");
    pageContext.setAttribute("myLocale", myLocale);
%>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button class="button_exit"><span>На главную</span></button>
</form>

<div class="box form">

    <div class="block_input">
        <div class="block">
            <input type="text" id="inputUser" placeholder="Поиск пользователей">
            <select id="selectUser" multiple="true" class="user_1 select">
                <c:forEach items="${usersForUser}" var="user">
                    <option value="${user.getFullName()}">${user.getFullName()}</option>
                </c:forEach>
            </select>
        </div>

        <div class="block">
            <input type="text" id="inputProduct" placeholder="Поиск изделий">
            <select id="selectProduct" multiple="true" class="product_1 select">
                <c:forEach items="${containersForUser}" var="container">
                    <option value="${container.getName()}">${container.getName()}</option>
                </c:forEach>
            </select>
        </div>

        <div class="block">
            <input type="text" id="inputRole" placeholder="Поиск роли">
            <select id="selectRole" multiple="true" class="role_1 select">
                <c:forEach items="${rolesForUser}" var="role">
                    <option value="${role.getDisplay()}">${role.getDisplay(myLocale)}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="block_input">
        <div class="button">
            <button class="addUser"><span>Добавить </span></button>
            <button class="removeUser"><span>Удалить </span></button>
            <button class="removeAllUser"><span>Удалить все </span></button>
        </div>
        <div class="button">
            <button class="addProduct"><span>Добавить </span></button>
            <button class="removeProduct"><span>Удалить </span></button>
            <button class="removeAllProduct"><span>Удалить все </span></button>
        </div>
        <div class="button">
            <button class="addRole"><span>Добавить </span></button>
            <button class="removeRole"><span>Удалить </span></button>
            <button class="removeAllRole"><span>Удалить все </span></button>
        </div>
    </div>

    <form class="block_input_form" method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/add/addUser">
        <select id="select_1" multiple="true" class="user_2 select_form" name="selectedUserForUser" required></select>
        <select id="select_2" multiple="true" class="product_2 select_form" name="selectedProductForUser" required></select>
        <select id="select_3" multiple="true" class="role_2 select_form" name="selectedRoleForUser" required></select>
        <button id="js-button-add" class="button_add">
            <div id="push" style="display: none;" class="spinner"></div>
            <span id="span">Добавить пользователей </span>
        </button>
    </form>

</div>

<script>
    const but = document.getElementById('js-button-add')
    const push = document.getElementById('push');
    const sp = document.getElementById('span');

    function trigger() {

        if (push.style.display == 'none') {
            sp.style.display = 'none';
            push.style.display = 'block';
        } else {
            sp.style.display = 'block';
            push.style.display = 'none';
        }
    }

    but.addEventListener('click', trigger);
</script>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/add/addScript.js"></script>
<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

</body>
</html>
