<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/usersStyle.css">
</head>

<body>

<c:if test="${flagGroup == true}">
    <div>
        <form method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/groups">
            <label>
                <select name="selectedGroup" size="5" required>

                    <c:forEach items="${groups}" var="g">
                        <option value="${g.getName()}">${g.getName()}</option>
                    </c:forEach>

                </select>
            </label>
            <br>
            <button><span>Ввод </span></button>
        </form>
    </div>
</c:if>

<c:if test="${flagGroup == false}">
    <form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
        <h2>Группы не существует.</h2>
        <button><span>На главную </span></button>
    </form>
</c:if>

</body>
</html>
