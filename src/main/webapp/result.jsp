<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Check Result</title>
    <style>
      body {
        margin: 0;
        background-color: #f0f0f0;
        font-family: Arial, sans-serif;
        font-size: 16px;
      }
      .page-header {
        background-color: rgb(20, 48, 48);
        color: #ffffff;
        padding: 1.25rem;
        text-align: center;
      }
      .header-title {
        font-family: cursive, sans-serif;
        margin: 0;
      }
      .page-header p {
        margin-top: 0.3125rem;
      }
      .page-footer {
        background-color: rgb(20, 48, 48);
        color: white;
        padding: 1.25rem;
        text-align: center;
        position: fixed;
        bottom: 0;
        width: 100%;
      }
      .page-footer p {
        margin: 0;
      }

      .container-main {
        width: 60%;
        margin: 2rem auto;
        background-color: rgb(244, 244, 244);
        border: 2px dashed rgb(192, 196, 196);
        padding: 1.25rem 2rem;
        vertical-align: top;
      }
      .container-main h2 {
        color: rgb(20, 48, 48);
        margin-top: 0;
      }
      .container-main h2::before {
        content: "► ";
        color: rgb(144, 29, 49);
      }
      .param-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
      }
      .param-table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
      }
      .param-table td:first-child {
        font-weight: bold;
        color: #333;
        width: 100px;
      }
      .result-message {
        text-align: center;
        font-size: 1.5rem;
        font-weight: bold;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .result-hit {
        color: #155724;
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
      }
      .result-miss {
        color: #721c24;
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
      }
      .back-link-container {
        text-align: center;
        margin-top: 20px;
      }
      .back-link {
        display: inline-block;
        padding: 10px 20px;
        background-color: rgb(144, 29, 49);
        color: white;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.3s;
      }
      .back-link:hover {
        background-color: rgb(174, 39, 59);
      }
    </style>
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

            <%-- Dynamically set the class for the background color --%>
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