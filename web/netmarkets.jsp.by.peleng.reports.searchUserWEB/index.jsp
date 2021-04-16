<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/indexStyle.css">
</head>
<body>

<div>
    <div>
        <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/search">
            <button><span>Искать пользователя </span></button>
        </a>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/servlet/searchUserWEB/searchGroup">
            <button><span>Искать группу </span></button>
        </a>
    </div>
</div>

</body>
</html>
