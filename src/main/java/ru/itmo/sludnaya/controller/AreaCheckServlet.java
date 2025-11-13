package ru.itmo.sludnaya.controller;

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

        String[] xStrArray = req.getParameterValues("x");
        String yStr = req.getParameter("y");
        String rStr = req.getParameter("r");

        List<PointCheckResult> newResults = new ArrayList<>();

        try {
            long startTime = System.nanoTime();

            if (xStrArray == null || yStr == null || rStr == null || xStrArray.length == 0) {
                throw new IllegalArgumentException("Required parameters are missing.");
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
                newResults.add(0, resultBean);

                startTime = System.nanoTime();
            }
            ServletContext context = getServletContext();
            synchronized (context) {
                ResultsHistory history = (ResultsHistory) context.getAttribute("resultsHistory");
                if (history == null) {
                    history = new ResultsHistory();
                }
                for (PointCheckResult result : newResults) {
                    history.add(result);
                }
                context.setAttribute("resultsHistory", history);
            }
            req.setAttribute("newResults", newResults);
            getServletContext().getRequestDispatcher("/result.jsp").forward(req, resp);

        } catch ( IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: Invalid or missing parameters.");
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