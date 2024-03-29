<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/searchStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
</head>
<body>

<div id="page-preloader" class="preloader">
    <div class="loader">
        <span>Загрузка...</span>
    </div>
</div>

<%
    List<String> userList = (List<String>) request.getSession().getAttribute("userList");
%>

<form method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchUserToAdd">

    <datalist id="emps">
        <%
            for (String s : userList) {
        %>
        <option value="<%=s%>"><%=s%></option>
        <%
            }
        %>
    </datalist>

    <h3>Введите фамилию:</h3>
    <label>
        <input type="text" name="add_selectedUser" placeholder="Иванов*" autocomplete="off" required list="emps">
    </label>
    <br>
    <button id="js-button"><span>Ввод </span></button>
</form>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

</body>
</html>
