package ru.itmo.sludnaya.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PointCheckResult {
    private double x;
    private double y;
    private  double r;
    private boolean hit;
    private LocalDateTime timestamp;

    public PointCheckResult(double x, double y, double r, boolean hit) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.hit = hit;
        this.timestamp = LocalDateTime.now();
    }

    public boolean isHit() {
        return hit;
    }
    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getR() {
        return r;
    }


    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    public String getFormattedTimestamp() {
        return timestamp.format(DateTimeFormatter.ofPattern("HH:mm:ss dd.MM.yyyy"));
    }
}
