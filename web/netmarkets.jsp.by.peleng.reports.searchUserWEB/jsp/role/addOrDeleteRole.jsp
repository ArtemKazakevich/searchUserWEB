<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Delete role</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/role/addOrDeleteRoleStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
    <script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/jsQuery/jquery-3.6.0.min.js"></script>
</head>
<body>

<div id="page-preloader" class="preloader">
    <div class="loader" role="status">
        <span>Загрузка...</span>
    </div>
</div>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button class="button_exit"><span>На главную</span></button>
</form>

<div class="box form">

    <div class="block_input">
        <input type="text" id="inputProduct" placeholder="Поиск изделий">
        <select style="margin-bottom: 18%;" id="selectProduct" multiple="true" class="product_1">
            <c:forEach items="${containersForRole}" var="container">
                <option value="${container.getName()}">${container.getName()}</option>
            </c:forEach>
        </select>

        <input type="text" id="inputRole" placeholder="Поиск роли">
        <select id="selectRole" multiple="true" class="role_1">
            <c:forEach items="${rolesForRole}" var="role">
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

    <form id="formBlock" class="block_input_form" method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/role/addOrDeleteRoleServlet">
        <select id="select_1" style="margin: 3% 0 30%;" multiple="true" class="product_2" name="selectedProductForRole" required></select>
        <select id="select_2" multiple="true" class="role_2" name="selectedRoleForRole" required></select>
        <div style="margin-top: 5%;">
            <button id="js-button-add_1" class="button_add js-button"><span>Удалить роль </span></button>
            <button id="js-button-add_2" class="button_add js-button"><span>Добавить роль </span></button>
        </div>
    </form>

</div>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/add/addScript.js"></script>
<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/role/addOrDeleteRoleServlet.js"></script>
<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

</body>
</html>
