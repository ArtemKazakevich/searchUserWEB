<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/indexStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
</head>
<body>

<div id="page-preloader" class="preloader">
    <div class="loader">
        <span>Загрузка...</span>
    </div>
</div>

<div class="form">
    <div class="box">
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchUser">
                <button id="js-button"><span>Искать пользователя </span></button>
            </a>
        </div>
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchGroup">
                <button id="js-button-1"><span>Искать группу </span></button>
            </a>
        </div>
    </div>

    <div class="box">
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchUserToAdd">
                <button id="js-button-2"><span>Добавить пользователя </span></button>
            </a>
        </div>
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchGroupToAdd">
                <button id="js-button-3"><span>Добавить группу </span></button>
            </a>
        </div>
    </div>

    <div class="box">
        <div class="delete">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/role/addOrDeleteRoleServlet">
                <button id="js-button-4" class="button_delete"><span>Добавить/Удалить роль </span></button>
            </a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

</body>
</html>
