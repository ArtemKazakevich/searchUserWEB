<%@ page import="wt.org.WTUser" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.query.SearchCondition" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.pds.StatementSpec" %>
<%@ page import="wt.util.WTException" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Search User</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/usersStyle.css">
    </head>

    <body>

    <c:if test="${flag == true}">
        <div>
            <form method = "post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/users">
                <label>
                    <select name="selectedUser" size="5" required>

                        <c:forEach items="${users}" var="u">
                            <option value="${u.getName()}">${u.getFullName().replace(",", "")}</option>
                        </c:forEach>

                    </select>
                </label>
                <br>
                <button><span>Ввод </span></button>
            </form>
        </div>
    </c:if>

    <c:if test="${flag == false}">
        <form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/search">
            <h2>Пользователя не существует.</h2>
            <button><span>На главную </span></button>
        </form>
    </c:if>

    </body>

</html>