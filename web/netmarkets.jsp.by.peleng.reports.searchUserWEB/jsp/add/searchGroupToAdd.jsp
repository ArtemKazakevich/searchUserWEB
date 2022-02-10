<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/searchGroupStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
</head>
<body>

<div id="page-preloader" class="preloader">
    <div class="loader" role="status">
        <span>Загрузка...</span>
    </div>
</div>

<%
    List<String> groupList = (List<String>) request.getSession().getAttribute("groupList");
%>

<form method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/add/searchGroupToAdd">

    <datalist id="emps">
        <%
            for (String s : groupList) {
        %>
        <option value="<%=s%>"><%=s%></option>
        <%
            }
        %>
    </datalist>

    <h3>Введите группу:</h3>
    <label>
        <input type="text" name="add_selectedGroup" placeholder="Инженер*" autocomplete="off" required list="emps">
    </label>
    <br>
    <button><span>Ввод </span></button>

</form>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

</body>
</html>
