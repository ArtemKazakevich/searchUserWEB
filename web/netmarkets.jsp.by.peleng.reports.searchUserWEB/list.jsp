<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Search User</title>
</head>
<body>

<div>
    <ul>
        <c:forEach items="${list}" var="h">
            <li>${h}</li>
        </c:forEach>
    </ul>
</div>

</body>
</html>
