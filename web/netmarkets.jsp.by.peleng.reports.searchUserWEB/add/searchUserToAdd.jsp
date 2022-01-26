<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addUserStyle.css">
</head>
<body>

<%
    List<String> userList = (List<String>) request.getSession().getAttribute("userList");
%>

<div>
    <form method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/addUser">

        <datalist id="emps">
            <%
                for (String s : userList) {
            %>

            <option value="<%=s%>"></option>

            <%
                }
            %>
        </datalist>

        <h3>Введите фамилию:</h3>
        <label>
            <input placeholder="Иванов" list="emps">
        </label>
        <br>
        <button><span>Ввод </span></button>
    </form>
</div>

<%--<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/script.js"></script>--%>

<script>

</script>

</body>
</html>
