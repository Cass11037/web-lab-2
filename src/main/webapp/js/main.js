"use strict";
const canvas = document.getElementById("plot-canvas");
const ctx = canvas.getContext("2d");
const form = document.getElementById("coordinates-form");
const xButtons = document.querySelectorAll(".x-button");
const hiddenXInput = document.getElementById("x-value");
const yInput = document.getElementById("y-value");
const rSelect = document.getElementById("r-value");
const errorContainer = document.getElementById("error-container");

xButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
        hiddenXInput.value = event.target.value;
        xButtons.forEach((btn) => btn.classList.remove("selected"));
        event.target.classList.add("selected");
    });
});


canvas.addEventListener("click", (event) => {
    hideError();
    const rValue = parseFloat(rSelect.value);
    if (isNaN(rValue)) {
        showError("Невозможно определить координаты: радиус R не установлен!");
        return;
    }
    const rect = canvas.getBoundingClientRect();
    const canvasX = event.clientX - rect.left;
    const canvasY = event.clientY - rect.top;

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const r_pixels = canvas.width / 3;

    const mathX = (canvasX - centerX) / r_pixels * rValue;
    const mathY = (centerY - canvasY) / r_pixels * rValue;

    hiddenXInput.value = mathX.toFixed(3);
    yInput.value = mathY.toFixed(3);

    form.submit();
});


form.addEventListener("submit", (event) => {

    const errorMessage = validateAllFields();
    if (errorMessage) {
        event.preventDefault();
        showError(errorMessage);
    } else {
        hideError();
    }
});


rSelect.addEventListener("change", () => {
    const rValue = parseFloat(rSelect.value);
    if (!isNaN(rValue)) {
        drawPlot(rValue);
        redrawPoints(rValue);
    }
});

function validateAllFields() {
    const xValue = hiddenXInput.value;
    if (xValue === "") { return "Пожалуйста, выберите значение X."; }

    const yValueStr = yInput.value.trim().replace(",", ".");
    if (yValueStr === "") { return "Пожалуйста, введите значение Y."; }
    if (isNaN(yValueStr)) { return "Значение Y должно быть числом."; }

    const yNum = parseFloat(yValueStr);
    if (yNum <= -5 || yNum >= 3) {
        return "Значение Y должно быть в интервале (-5 ... 3).";
    }

    const rValue = rSelect.value;
    if (rValue === "") { return "Пожалуйста, выберите значение R."; }

    return null;
}

function drawPlot(r) {
    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const r_pixels = width / 3;

    ctx.clearRect(0, 0, width, height);

    ctx.fillStyle = "#5c99ED";
    ctx.strokeStyle = "#255799";
    ctx.lineWidth = 1;

    ctx.beginPath();
    ctx.rect(centerX, centerY - r_pixels / 2, r_pixels, r_pixels / 2);
    ctx.fill(); ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(centerX + r_pixels / 2, centerY);
    ctx.lineTo(centerX, centerY + r_pixels);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.arc(centerX, centerY, r_pixels , Math.PI / 2, Math.PI);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    ctx.strokeStyle = "black";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, centerY); ctx.lineTo(width, centerY);
    ctx.moveTo(centerX, 0); ctx.lineTo(centerX, height);
    ctx.stroke();

    ctx.fillStyle = "black";
    const labels = [`-${r}`, `-${r/2}`, `${r/2}`, `${r}`];
    const positions = [-r_pixels, -r_pixels / 2, r_pixels / 2, r_pixels];
    positions.forEach((pos, i) => {
        ctx.fillText(labels[i], centerX + pos - 5, centerY - 5);
        ctx.fillText(labels[i], centerX + 5, centerY - pos + 3);
    });
}

function drawPoint(x, y, r, isHit) {
    if (isNaN(r) || r <= 0) return;
    const r_pixels = canvas.width / 3;
    const scale = r_pixels / r;

    const canvasX = canvas.width / 2 + x * scale;
    const canvasY = canvas.height / 2 - y * scale;

    ctx.fillStyle = isHit ? "green" : "red";
    ctx.beginPath();
    ctx.arc(canvasX, canvasY, 4, 0, 2 * Math.PI);
    ctx.fill();
}


function redrawPoints(currentR) {
    if (typeof historyPoints !== 'undefined' && historyPoints) {
        historyPoints.forEach(point => {
            if (point.r == currentR) {
                drawPoint(point.x, point.y, point.r, point.hit);
            }
        });
    }
}

function showError(message) {
    errorContainer.textContent = message;
    errorContainer.style.display = "block";
}

function hideError() {
    errorContainer.style.display = "none";
}


document.addEventListener("DOMContentLoaded", () => {
    const initialR = parseFloat(rSelect.value);
    if (!isNaN(initialR)) {
        drawPlot(initialR);
        redrawPoints(initialR);
    } else {
        drawPlotWithTextLabels();
    }
});

function drawPlotWithTextLabels() {

    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const r_pixels = width / 3;

    ctx.clearRect(0, 0, width, height);

    ctx.fillStyle = "#5c99ED";
    ctx.strokeStyle = "#255799";
    ctx.lineWidth = 1;

    ctx.beginPath();
    ctx.rect(centerX, centerY - r_pixels / 2, r_pixels, r_pixels / 2);
    ctx.fill(); ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(centerX + r_pixels / 2, centerY);
    ctx.lineTo(centerX, centerY + r_pixels);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.arc(centerX, centerY, r_pixels , Math.PI / 2, Math.PI);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    ctx.strokeStyle = "black";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, centerY); ctx.lineTo(width, centerY);
    ctx.moveTo(centerX, 0); ctx.lineTo(centerX, height);
    ctx.stroke();


    ctx.fillStyle = "black";
    const labels = ["-R", "-R/2", "R/2", "R"];
    const positions = [-r_pixels, -r_pixels / 2, r_pixels / 2, r_pixels];
    positions.forEach((pos, i) => {
        ctx.fillText(labels[i], centerX + pos - 5, centerY - 5);
        ctx.fillText(labels[i], centerX + 5, centerY - pos + 3);
    });
}