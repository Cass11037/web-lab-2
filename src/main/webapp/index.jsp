<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Walking Skeleton</title>
</head>
<body>
    <h1>Если вы видите это, MVC-цикл работает!</h1>
    <form method="POST" action="${pageContext.request.contextPath}/controller">
        <p>X: <input type="text" name="x" placeholder="-4 ... 4" required></p>
        <p>Y: <input type="text" name="y" placeholder="-5 ... 3" required></p>
        <p>R: <input type="text" name="r" placeholder="1 ... 3" required></p>
        <button type="submit">Проверить</button>
    </form>
    <hr>
<h3>История проверок:</h3>
<table border="1">
    <thead>
        <tr>
            <th>X</th>
            <th>Y</th>
            <th>R</th>
            <th>Результат</th>
            <th>Время проверки</th>
        </tr>
    </thead>
    <tbody>
        <%-- Проверяем, пуста ли история. EL и JSTL работают вместе! --%>
        <c:if test="${empty applicationScope.resultsHistory.history}">
            <tr>
                <td colspan="5">История проверок пока пуста.</td>
            </tr>
        </c:if>

        <%-- Главная магия: JSTL-тег forEach проходит по нашей коллекции --%>
        <%-- applicationScope - это предопределенный объект для доступа к ServletContext --%>
        <%-- resultsHistory - это ключ, под которым мы сохранили наш объект --%>
        <%-- .history - EL автоматически вызовет метод getHistory() у нашего объекта --%>
        <c:forEach items="${applicationScope.resultsHistory.history}" var="check">
            <tr>
                <%-- EL для доступа к свойствам (геттерам) каждого объекта в цикле --%>
                <td><c:out value="${check.x}"/></td>
                <td><c:out value="${check.y}"/></td>
                <td><c:out value="${check.r}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${check.hit}">
                            <span style="color: green;">Попадание</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: red;">Промах</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${check.formattedTimestamp}"/></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</body>
</html>