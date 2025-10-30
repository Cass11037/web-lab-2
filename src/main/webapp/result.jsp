<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Check Result</title>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>
    <header class="page-header">
        <h1 class="header-title">Sludnaya Victoria Evgenievna</h1>
        <p>Group: P3122 | Variant: 476011</p>
    </header>

    <main>
        <div class="container-main">
            <h2>Результаты последней проверки:</h2>
            
            <%-- Используем ТОЧНО ТАКУЮ ЖЕ таблицу и стили, как на главной странице --%>
            <table class="results-table">
                <thead>
                  <tr>
                    <th>X</th>
                    <th>Y</th>
                    <th>R</th>
                    <th>Result</th>
                    <th>Current Time</th>
                    <th>Script Execution Time (ms)</th>
                  </tr>
                </thead>
                <tbody>
                    <%-- ГЛАВНОЕ ИЗМЕНЕНИЕ: Итерируемся по списку 'newResults' из requestScope --%>
                    <c:forEach items="${requestScope.newResults}" var="result">
                        <tr class="${result.hit ? 'hit-true' : 'hit-false'}">
                            <td><c:out value="${result.x}"/></td>
                            <td><c:out value="${result.y}"/></td>
                            <td><c:out value="${result.r}"/></td>
                            <td>${result.hit ? "Hit" : "Miss"}</td>
                            <td><c:out value="${result.formattedTimestamp}"/></td>
                            <td><c:out value="${result.executionTime}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="back-link-container">
                <a class="back-link" href="${pageContext.request.contextPath}/">Back to Main Page</a>
            </div>
        </div>
    </main>

    <footer class="page-footer">
        <p>&copy; 2025, Saint Petersburg</p>
    </footer>
</body>
</html>