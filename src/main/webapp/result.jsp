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
            <h2>Your Check Result</h2>

            <table class="param-table">
                <tbody>
                    <tr>
                        <td>X:</td>
                        <td><c:out value="${requestScope.currentResult.x}"/></td>
                    </tr>
                    <tr>
                        <td>Y:</td>
                        <td><c:out value="${requestScope.currentResult.y}"/></td>
                    </tr>
                    <tr>
                        <td>R:</td>
                        <td><c:out value="${requestScope.currentResult.r}"/></td>
                    </tr>
                </tbody>
            </table>
            <div class="result-message ${requestScope.currentResult.hit ? 'result-hit' : 'result-miss'}">
                <c:choose>
                    <c:when test="${requestScope.currentResult.hit}">
                        Hit!
                    </c:when>
                    <c:otherwise>
                        Miss!
                    </c:otherwise>
                </c:choose>
            </div>

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