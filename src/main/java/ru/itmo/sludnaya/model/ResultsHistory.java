package ru.itmo.sludnaya.model;

import java.util.LinkedList;
import java.util.List;

public class ResultsHistory {
    private final List<PointCheckResult> history = new LinkedList<>();
    public void add(PointCheckResult res) {
        history.add(0, res);
    }

    public List<PointCheckResult> getHistory() {
        return history;
    }
}
