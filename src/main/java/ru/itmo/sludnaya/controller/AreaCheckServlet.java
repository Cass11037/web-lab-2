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

@WebServlet(name="AreaCheckServlet", value = "/check")
public class AreaCheckServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String xStr = req.getParameter("x");
        String yStr = req.getParameter("y");
        String rStr = req.getParameter("r");

        try {
            double x = Double.parseDouble(xStr.replace(',', '.'));
            double y = Double.parseDouble(yStr.replace(',', '.'));
            double r = Double.parseDouble(rStr.replace(',', '.'));
            boolean hit = checkHit(x,y,r);
            PointCheckResult resultBean = new PointCheckResult(x,y,r,hit);
            req.setAttribute("currentResult", resultBean);


            ServletContext context = getServletContext();
            ResultsHistory history =(ResultsHistory)  context.getAttribute("resultsHistory");
            if(history == null) {
                history = new ResultsHistory();
            }
            history.add(resultBean);
            context.setAttribute("resultsHistory", history);

            getServletContext().getRequestDispatcher("/result.jsp").forward(req, resp);

        }
        catch (NumberFormatException | NullPointerException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ошибка: один или несколько параметров некорректны.");
        }
    }
    private boolean checkHit(double x, double y, double r) {
        if (x >= 0 && y >= 0 && x <= r && y <= r / 2) {
            return true;
        }
        // Треугольник (правый нижний)
        if (x >= 0 && y <= 0 && y >= (x/2 - r/2)) { // Уточнил формулу для треугольника
            return true;
        }
        // Четверть круга (левый нижний)
        if (x <= 0 && y <= 0 && (x * x + y * y <= r * r)) {
            return true;
        }
        return false;
    }
}
