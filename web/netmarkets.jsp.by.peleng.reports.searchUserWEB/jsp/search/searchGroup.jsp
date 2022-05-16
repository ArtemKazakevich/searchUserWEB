<%@ page import="java.util.List" %>
<%@ page import="wt.org.WTGroup" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.fc.QueryResult" %>
<%@ page import="wt.fc.PersistenceHelper" %>
<%@ page import="wt.util.WTException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Group</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/search/searchStyle.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/css/spinner.css">
</head>

<body>

<div id="page-preloader" class="preloader">
    <div class="loader">
        <span>Загрузка...</span>
    </div>
</div>

<%
//    List<String> groupList = (List<String>) request.getSession().getAttribute("groupListToSearch");
    List<WTGroup> groupList = findAllGroup();
%>

<form method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/search/searchGroup">

    <datalist id="listGroups">
        <%
            for (WTGroup s : groupList) {
        %>
        <option value="<%=s.getName()%>"><%=s.getName()%>
        </option>
        <%
            }
        %>
    </datalist>

    <h3>Введите группу:</h3>
    <label>
        <input type="text" name="selectedGroup" placeholder="Инженер*" autocomplete="off" required list="listGroups">
    </label>
    <br>
    <button id="js-button"><span>Ввод </span></button>
</form>

<form method="get" action="${pageContext.request.contextPath}/servlet/searchUserWEB/index">
    <button><span>На главную</span></button>
</form>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/spinner.js"></script>

<%!
    private List<WTGroup> findAllGroup() {

        List<WTGroup> groups = new ArrayList<>();

        QuerySpec querySpec;
        QueryResult qr = null;
        try {
            querySpec = new QuerySpec(WTGroup.class);
            qr = PersistenceHelper.manager.find(querySpec);
        } catch (WTException e) {
            e.printStackTrace();
        }

        while (qr.hasMoreElements()) {
            WTGroup group = (WTGroup) qr.nextElement();

            if (!group.isDisabled()) {

                // (group.getDn() != null & group.getContainerName().equals("PELENG"))
                if (group.getDn() != null) {
                    groups.add(group);
                }
            }
        }

        return groups;
    }
%>

</body>
</html>
