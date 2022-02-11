<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Search User</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/search/searchStyle.css">
    </head>

    <body>
        <div>
            <form method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchUser">
                <h3>Введите фамилию:</h3>
                <label>
                    <input type="text" name="lastName" placeholder="Иванов*" autocomplete="off" required>
                </label>
                <br>
                <button id="js-button"><span>Ввод </span></button>
            </form>
        </div>
    </body>
</html>