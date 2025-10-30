package ru.itmo.sludnaya.controller;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ru.itmo.sludnaya.model.PointCheckResult;
import ru.itmo.sludnaya.model.ResultsHistory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name="AreaCheckServlet", value = "/check")
public class AreaCheckServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long startTime = System.nanoTime();

        String[] xStrArray = req.getParameterValues("x");
        String yStr = req.getParameter("y");
        String rStr = req.getParameter("r");

        ServletContext context = getServletContext();
        ResultsHistory history = (ResultsHistory) context.getAttribute("resultsHistory");
        if (history == null) {
            history = new ResultsHistory();
        }

        // 1. ИЗМЕНЕНИЕ: Создаем временный список для "новых" результатов
        List<PointCheckResult> newResults = new ArrayList<>();

        try {
            if (xStrArray == null || yStr == null || rStr == null || xStrArray.length == 0) {
                throw new IllegalArgumentException("Отсутствуют необходимые параметры.");
            }

            double y = Double.parseDouble(yStr.replace(',', '.'));
            double r = Double.parseDouble(rStr.replace(',', '.'));

            for (String xStr : xStrArray) {
                double x = Double.parseDouble(xStr.replace(',', '.'));
                boolean hit = checkHit(x, y, r);
                PointCheckResult resultBean = new PointCheckResult(x, y, r, hit);

                long endTime = System.nanoTime();
                double executionTime = (endTime - startTime) / 1_000_000.0;
                resultBean.setExecutionTime(executionTime);

                history.add(resultBean);
                newResults.add(0,resultBean);

                startTime = System.nanoTime();
            }

            context.setAttribute("resultsHistory", history);

            // 3. ИЗМЕНЕНИЕ: Кладем в request именно список НОВЫХ результатов
            req.setAttribute("newResults", newResults);

            // 4. ИЗМЕНЕНИЕ: Возвращаем forward на result.jsp
            getServletContext().getRequestDispatcher("/result.jsp").forward(req, resp);

        }
        catch (NumberFormatException | NullPointerException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: all or any param arent correct");
        }
    }
    private boolean checkHit(double x, double y, double r) {
        if (x >= 0 && y >= 0 && x <= r && y <= r / 2) {
            return true;
        }
        if (x >= 0 && y <= 0 && y >= (x/2 - r/2)) {
            return true;
        }
        if (x <= 0 && y <= 0 && (x * x + y * y <= r * r)) {
            return true;
        }
        return false;
    }
}
