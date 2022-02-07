<%@ page import="wt.inf.container.WTContainer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wt.project.Role" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
    <title>Finish</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/add/addUserStyle.css">
</head>
<body>

<%
    List<WTContainer> wtContainerList = (List<WTContainer>) request.getSession().getAttribute("wtContainerList_add");
    List<Role> roleList = (List<Role>) request.getSession().getAttribute("roleList_add");

    for (WTContainer w : wtContainerList) {

%>

<p><%=w.getName()%>
</p>

<%

    }

    for (Role r : roleList) {

%>

<p><%=r.getDisplay(new Locale("ru", "RU"))%>
</p>

<%

    }
%>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button class="button_exit"><span>На главную</span></button>
</form>

</body>
</html>
