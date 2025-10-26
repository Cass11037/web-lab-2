<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Client-Server Application | Lab Work 1</title>
    <!--  <link rel="stylesheet" href="style.css" /> -->
    <style>
      body {
        margin: 0;
        background-color: #f0f0f0; /* Оставляем общий фон чуть серым для контраста */
        font-family: Arial, sans-serif;
        font-size: 16px;
      }
      .page-header {
        background-color: rgb(20, 48, 48); /* Новый темно-зеленый */
        color: #ffffff;
        padding: 1.25rem;
        text-align: center;
      }
      .page-header a {
        color: #ffffff;
      }

      .header-title {
        font-family: cursive, sans-serif;
        margin: 0;
      }

      .page-header p {
        margin-top: 0.3125rem;
      }

      .layout-table {
        width: 100%;
        border-spacing: 20px;
        padding: 2rem 4%;
      }

      .container-left,
      .container-right {
        width: 50%;
        background-color: rgb(244, 244, 244); /* Новый светло-серый фон */
        border: 2px dashed rgb(192, 196, 196); /* Новая серая рамка */
        padding: 1.25rem;
        vertical-align: top;
      }

      .container-left h2,
      .container-right h2 {
        color: rgb(20, 48, 48); /* Заголовки в цвет шапки */
        margin-top: 0;
      }
      .container-left h2::before,
      .container-right h2::before {
        content: "► ";
        color: rgb(144, 29, 49); /* ► в бордовом цвете */
      }
      .results-table {
        width: 100%;
        border: none;
        margin-bottom: 1.25rem;
        border-collapse: separate;
        border-spacing: 0;
      }

      .results-table thead th {
        font-weight: bold;
        text-align: left;
        border: none;
        padding: 0.625rem 1rem;
        background: rgb(131, 74, 84);
        color: rgb(20, 48, 48);
        font-size: 0.875rem;
      }

      .results-table tr th:first-child,
      .results-table tr td:first-child {
        border-radius: 0.5rem 0 0 0.5rem;
      }

      .results-table tr th:last-child,
      .results-table tr td:last-child {
        border-radius: 0 0.5rem 0.5rem 0;
      }

      .results-table tbody td {
        text-align: left;
        border: none;
        padding: 0.625rem 1rem;
        font-size: 0.875rem;
        vertical-align: top;
      }

      .results-table tbody tr:nth-child(even) {
        background: #ffffff;
      }

      .results-table tr:hover td {
        background-color: rgb(20, 48, 48);
        opacity: 90%;
        color: #f0f0f0;
      }

      .hit-true td {
        background-color: rgba(60, 150, 90, 0.2);
      }

      .hit-false td {
        background-color: rgba(220, 53, 69, 0.2);
      }

      .page-footer {
        background-color: rgb(20, 48, 48);
        color: white;
        padding: 1.25rem;
        text-align: center;
      }
      .page-footer p {
        margin: 0;
      }

      .form-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100%;
      }
      .form-group {
        margin-bottom: 4%;
        width: 100%;
      }
      .form-group label {
        display: block;
        margin-bottom: 2%;
        font-weight: bold;
        color: #333;
      }
      .form-group input[type="text"],
      .form-group select {
        width: 95%;
        padding: 0.625rem;
        border: 1px solid rgb(192, 196, 196);
        border-radius: 0.3125rem;
        font-size: 1rem;
      }
      .submit-button {
        background-color: rgb(144, 29, 49);
      }
      .submit-button:hover {
        background-color: rgb(174, 39, 59);
      }
      .submit-button,
      .reset-button {
        width: 100%;
        padding: 0.75rem;
        color: white;
        border: none;
        border-radius: 0.3125rem;
        font-size: 1rem;
        cursor: pointer;
      }
      .reset-button {
        background-color: rgb(200, 119, 132);
      }
      .reset-button:hover {
        background-color: rgb(218, 157, 167);
      }

      .button-group {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }

      .x-button {
        padding: 0.5rem 0.75rem;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #f9f9f9;
        cursor: pointer;
        font-size: 0.9rem;
      }

      .x-button.selected {
        background-color: rgb(20, 48, 48);
        color: white;
        border-color: rgb(20, 48, 48);
      }

      .error-message {
        color: #d8000c;
        background-color: #ffbaba;
        border: 1px solid #d8000c;
        padding: 10px;
        margin-bottom: 15px;
        border-radius: 5px;
        text-align: center;
        display: none;
      }

      .graph-container {
        margin-bottom: 20px;
        display: flex;
        justify-content: center;
      }

      #graph .graph-area {
        fill: rgb(194, 255, 219);
        stroke: rgb(255, 142, 161);
        stroke-width: 2;
        fill-opacity: 0.7;
      }

      #graph .axis line,
      #graph .axis polygon {
        stroke: #333;
        stroke-width: 2;
      }

      #graph .axis text {
        fill: #333;
        font-family: sans-serif;
        font-size: 10px;
      }

      #graph .axis-ticks line {
        stroke: #666;
        stroke-width: 1;
      }

      #graph .axis-ticks text {
        fill: #666;
        font-family: sans-serif;
        font-size: 8px;
        text-anchor: middle;
      }
    </style>
  </head>
  <body>
    <header class="page-header">
      <h1 class="header-title">Sludnaya Victoria Evgenievna</h1>
      <p>Group: P3122 | Variant: 476011</p>
    </header>

    <main>
      <table class="layout-table">
        <tbody>
          <tr>
            <td class="container-left">
              <h2>Workspace</h2>
              <div class="graph-container">
                 <canvas id="plot-canvas" width="300" height="300"></canvas>
              </div>
              <div class="form-container">
                <h2>Data Entry</h2>
                <form id="coordinates-form" method="POST" action="${pageContext.request.contextPath}/controller">
                  <div id="error-container" class="error-message"></div>
<div class="form-group">
    <label>Enter the X value:</label>
    <div class="button-group">
        <button type="button" class="x-button" value="-4">-4</button>
        <button type="button" class="x-button" value="-3">-3</button>
        <button type="button" class="x-button" value="-2">-2</button>
        <button type="button" class="x-button" value="-1">-1</button>
        <button type="button" class="x-button" value="0">0</button>
        <button type="button" class="x-button" value="1">1</button>
        <button type="button" class="x-button" value="2">2</button>
        <button type="button" class="x-button" value="3">3</button>
        <button type="button" class="x-button" value="4">4</button>
    </div>

    <input type="hidden" id="x-value" name="x" />
</div>
                  <div class="form-group">
                    <label>Enter the Y value:</label>
                    <input
                      type="text"
                      id="y-value"
                      name="y"
                      placeholder="in range -5 to 5"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label>Select the R value:</label>
                    <select id="r-value" name="r" required>
                      <option value="" disabled selected>-- Select R --</option>
                      <option value="1">1</option>
                      <option value="2">2</option>
                      <option value="3">3</option>
                      <option value="4">4</option>
                      <option value="5">5</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <button type="submit" class="submit-button">Check</button>
                  </div>
                  <div class="form-group">
                    <button type="reset" class="reset-button">
                      Reset Fields
                    </button>
                  </div>

                </form>
              </div>
            </td>
            <td class="container-right">
              <h2>Check History</h2>
              <table class="results-table">
                <thead>
                  <tr>
                    <th>X</th>
                    <th>Y</th>
                    <th>R</th>
                    <th>Result</th>
                    <th>Current Time</th>
                  </tr>
                </thead>
                <tbody>
                <c:forEach items="${applicationScope.resultsHistory.history}" var="result">
                        <tr class="${result.hit ? 'hit-true' : 'hit-false'}">
                            <td><c:out value="${result.x}"/></td>
                            <td><c:out value="${result.y}"/></td>
                            <td><c:out value="${result.r}"/></td>
                            <td>${result.hit ? "Попадание" : "Промах"}</td>
                            <td><c:out value="${result.formattedTimestamp}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
              </table>
            </td>
          </tr>
        </tbody>
      </table>
    </main>
    <footer class="page-footer">
      <p>&copy; 2025, Saint Petersburg</p>
    </footer>
    <script>
        const historyPoints = [
            <c:forEach items="${applicationScope.resultsHistory.history}" var="p">
                {x: ${p.x}, y: ${p.y}, r: ${p.r}, hit: ${p.hit}},
            </c:forEach>
        ];
    </script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
  </body>
</html>
