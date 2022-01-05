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

<%--<%--%>
<%--    List<String> userList = (List<String>) request.getSession().getAttribute("userList");--%>
<%--%>--%>

<div>
    <form method="post" action="${pageContext.request.contextPath}/servlet/searchUserWEB/addUser">
        <h3>Введите фамилию:</h3>
        <label>
            <input id="inputUser" placeholder="Иванов*">
        </label>
        <br>
        <button><span>Ввод </span></button>
    </form>
</div>

<%--<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/searchUserWEB/js/script.js"></script>--%>

<script>

    let data = [
        <c:forEach var="item" items="${userList}">
            '<c:out value="${item}"/>',
        </c:forEach>
    ];

    class DropDownList {
        constructor({element, data}) {
            this.element = element;
            this.data = data;

            this.listElement = null;

            this._onElementInput = this._onElementInput.bind(this);
            this._onItemListClick = this._onItemListClick.bind(this);

            this._onDocumentKeyDown = this._onDocumentKeyDown.bind(this);

            this.bind();
        }

        _onDocumentKeyDown({keyCode}) {
            console.log(keyCode);
        }

        _onElementInput({target}) {
            this.removeList();

            if (!target.value) {
                return;
            }

            this.createList(this.data.filter(it => it.toLowerCase().indexOf(target.value.toLowerCase()) !== -1));
            this.appendList();
        }

        _onItemListClick({target}) {
            this.element.value = target.textContent;
            this.removeList();
        }

        createList(data) {
            this.listElement = document.createElement(`ul`);
            this.listElement.className = `drop-down__list`;
            this.listElement.innerHTML = data.map(it => `<li tabindex="0" class="drop-down__item">${it}</li>`).join(``);

            [...this.listElement.querySelectorAll(`.drop-down__item`)].forEach(it => {
                it.addEventListener(`click`, this._onItemListClick);
            });

            document.addEventListener(`keydown`, this._onDocumentKeyDown);
        }

        appendList() {
            const {left, width, bottom} = this.element.getBoundingClientRect();
            this.listElement.style.width = width + `px`;
            this.listElement.style.left = left + `px`;
            this.listElement.style.top = bottom + `px`;
            document.body.appendChild(this.listElement);
        }

        removeList() {
            if (this.listElement) {
                this.listElement.remove();
                this.listElement = null;
            }

            document.removeEventListener(`keydown`, this._onDocumentKeyDown);
        }

        bind() {
            this.element.addEventListener(`input`, this._onElementInput);
        }
    }

    new DropDownList({element: document.querySelector(`#inputUser`), data});
</script>

</body>
</html>
