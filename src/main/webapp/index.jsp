<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Client-Server Application | Lab Work 1</title>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  </head>
  <body>
    <header class="page-header">
      <h1 class="header-title">Sludnaya Victoria Evgenievna</h1>
      <p>Group: P3222 | Variant: 57999</p>
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
    <label>Select X value(s):</label>
    <div class="checkbox-group">
        <label><input type="checkbox" name="x" value="-4"><span>-4</span></label>
        <label><input type="checkbox" name="x" value="-3"><span>-3</span></label>
        <label><input type="checkbox" name="x" value="-2"><span>-2</span></label>
        <label><input type="checkbox" name="x" value="-1"><span>-1</span></label>
        <label><input type="checkbox" name="x" value="0"><span>0</span></label>
        <label><input type="checkbox" name="x" value="1"><span>1</span></label>
        <label><input type="checkbox" name="x" value="2"><span>2</span></label>
        <label><input type="checkbox" name="x" value="3"><span>3</span></label>
        <label><input type="checkbox" name="x" value="4"><span>4</span></label>
    </div>
</div>
                  <div class="form-group">
                    <label>Enter the Y value:</label>
                    <input
                      type="text"
                      id="y-value"
                      name="y"
                      placeholder="in range -5 to 3"
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
                    <th>Script Execution Time (ms)</th>
                  </tr>
                </thead>
                <tbody>
                <c:forEach items="${applicationScope.resultsHistory.history}" var="result">
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
