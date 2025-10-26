<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Results</title>
    </head>
    <body>
        <h1> Result of yout checking</h1>
        <table>
        <tr><td>X:</td><td>${requestScope.currentResult.x}</td></tr>
        <tr><td>Y:</td><td>${requestScope.currentResult.y}</td></tr>
        <tr><td>R:</td><td>${requestScope.currentResult.r}</td></tr>
        </table>
        <h2>
            <c:choose>
            <c:when test="${requestScope.currentResult.hit}">
                Попадание!
            </c:when>
            <c:otherwise>
                Промах!
            </c:otherwise>
        </c:choose>
        </h2>
        <a href="${pageContext.request.contextPath}/">Вернуться на главную</a>
    </body>
</html>