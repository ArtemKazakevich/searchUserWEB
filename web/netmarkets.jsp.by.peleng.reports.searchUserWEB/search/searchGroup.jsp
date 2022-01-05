<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/searchStyle.css">
</head>

<body>
<div>
    <form method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/searchGroup">
        <h3>Введите группу:</h3>
        <label>
            <input type="text" name="groupName" placeholder="Инженер*" autocomplete="off" required>
        </label>
        <br>
        <button><span>Ввод </span></button>
    </form>
</div>
</body>
</html>
