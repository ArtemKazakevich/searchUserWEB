<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/indexStyle.css">
</head>
<body>

<div class="form">
    <div class="box">
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchUser">
                <button><span>Искать пользователя </span></button>
            </a>
        </div>
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchGroup">
                <button><span>Искать группу </span></button>
            </a>
        </div>
    </div>

    <div class="box">
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchUserToAdd">
                <button><span>Добавить пользователя </span></button>
            </a>
        </div>
        <div class="but">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchGroupToAdd">
                <button><span>Добавить группу </span></button>
            </a>
        </div>
    </div>

    <div class="box">
        <div class="delete">
            <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/role/addOrDeleteRoleServlet">
                <button class="button_delete"><span>Добавить/Удалить роль </span></button>
            </a>
        </div>
    </div>
</div>

</body>
</html>
