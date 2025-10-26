"use strict";

// --- НАЧАЛО: ПОЛУЧАЕМ ДОСТУП К ЭЛЕМЕНТАМ (DOM Elements) ---
const canvas = document.getElementById("plot-canvas");
const ctx = canvas.getContext("2d");
const form = document.getElementById("coordinates-form");
const xButtons = document.querySelectorAll(".x-button");
const hiddenXInput = document.getElementById("x-value");
const yInput = document.getElementById("y-value");
const rSelect = document.getElementById("r-value");
const errorContainer = document.getElementById("error-container");

// --- КОНЕЦ: ПОЛУЧАЕМ ДОСТУП К ЭЛЕМЕНТАМ ---


// --- НАЧАЛО: ОБРАБОТЧИКИ СОБЫТИЙ (Event Handlers) ---

// Обработчик для кнопок X (остается без изменений, он работает правильно)
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

// --- КОНЕЦ: ОБРАБОТЧИКИ СОБЫТИЙ ---


// --- НАЧАЛО: ФУНКЦИИ ---

// Функция валидации (остается без изменений, она работает правильно)
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

    return null; // Нет ошибок
}

// Функция отрисовки графика (фигур и осей)
function drawPlot(r) {
    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const r_pixels = width / 3;

    ctx.clearRect(0, 0, width, height);

    // Рисуем цветную область
    ctx.fillStyle = "#5c99ED";
    ctx.strokeStyle = "#255799";
    ctx.lineWidth = 1;

    // 1. Прямоугольник (I четверть: x от 0 до R, y от 0 до R/2)
    ctx.beginPath();
    ctx.rect(centerX, centerY - r_pixels / 2, r_pixels, r_pixels / 2);
    ctx.fill(); ctx.stroke();

    // 2. Треугольник (IV четверть: вершины (0,0), (R/2,0), (0,-R))
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(centerX + r_pixels / 2, centerY);
    ctx.lineTo(centerX, centerY + r_pixels);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    // 3. Сектор круга (III четверть, радиус R/2)
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.arc(centerX, centerY, r_pixels , Math.PI / 2, Math.PI);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    // Рисуем оси
    ctx.strokeStyle = "black";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, centerY); ctx.lineTo(width, centerY); // Ось X
    ctx.moveTo(centerX, 0); ctx.lineTo(centerX, height); // Ось Y
    ctx.stroke();

    // Рисуем подписи на осях (теперь они зависят от переданного r)
    ctx.fillStyle = "black";
    const labels = [`-${r}`, `-${r/2}`, `${r/2}`, `${r}`];
    const positions = [-r_pixels, -r_pixels / 2, r_pixels / 2, r_pixels];
    positions.forEach((pos, i) => {
        ctx.fillText(labels[i], centerX + pos - 5, centerY - 5); // Подписи на оси X
        ctx.fillText(labels[i], centerX + 5, centerY - pos + 3); // Подписи на оси Y
    });
}

// Функция отрисовки одной точки
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

// Функция перерисовки всех точек из истории для текущего R
function redrawPoints(currentR) {
    if (typeof historyPoints !== 'undefined' && historyPoints) {
        historyPoints.forEach(point => {
            // Рисуем точку, только если ее R совпадает с текущим выбранным R
            if (point.r == currentR) {
                drawPoint(point.x, point.y, point.r, point.hit);
            }
        });
    }
}

// Вспомогательные функции для ошибок (без изменений)
function showError(message) {
    errorContainer.textContent = message;
    errorContainer.style.display = "block";
}

function hideError() {
    errorContainer.style.display = "none";
}


// --- НАЧАЛО: КОД, ВЫПОЛНЯЕМЫЙ ПРИ ЗАГРУЗКЕ СТРАНИЦЫ ---
document.addEventListener("DOMContentLoaded", () => {
    // При загрузке страницы, рисуем график и точки для R, который выбран по умолчанию
    const initialR = parseFloat(rSelect.value);
    if (!isNaN(initialR)) {
        drawPlot(initialR);
        redrawPoints(initialR);
    } else {
        // Если R не выбран, рисуем "пустой" график с подписями "R", "R/2" и т.д.
        drawPlotWithTextLabels();
    }
});

// НАЙДИТЕ И ЗАМЕНИТЕ ЭТУ ФУНКЦИЮ:
function drawPlotWithTextLabels() {
    // 1. ПОЛУЧАЕМ ПЕРЕМЕННЫЕ (как в drawPlot)
    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const r_pixels = width / 3;

    // 2. ОЧИЩАЕМ ХОЛСТ (как в drawPlot)
    ctx.clearRect(0, 0, width, height);

    // 3. РИСУЕМ ЦВЕТНУЮ ОБЛАСТЬ (код скопирован из drawPlot)
    ctx.fillStyle = "#5c99ED";
    ctx.strokeStyle = "#255799";
    ctx.lineWidth = 1;
    // Прямоугольник
    ctx.beginPath();
    ctx.rect(centerX, centerY - r_pixels / 2, r_pixels, r_pixels / 2);
    ctx.fill(); ctx.stroke();
    // Треугольник
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(centerX + r_pixels / 2, centerY);
    ctx.lineTo(centerX, centerY + r_pixels);
    ctx.closePath();
    ctx.fill(); ctx.stroke();
    // Сектор круга
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.arc(centerX, centerY, r_pixels , Math.PI / 2, Math.PI);
    ctx.closePath();
    ctx.fill(); ctx.stroke();

    // 4. РИСУЕМ ОСИ (код скопирован из drawPlot)
    ctx.strokeStyle = "black";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, centerY); ctx.lineTo(width, centerY); // Ось X
    ctx.moveTo(centerX, 0); ctx.lineTo(centerX, height); // Ось Y
    ctx.stroke();

    // 5. А ТЕПЕРЬ РИСУЕМ НАШИ УНИКАЛЬНЫЕ ТЕКСТОВЫЕ ПОДПИСИ
    ctx.fillStyle = "black";
    const labels = ["-R", "-R/2", "R/2", "R"];
    const positions = [-r_pixels, -r_pixels / 2, r_pixels / 2, r_pixels];
    positions.forEach((pos, i) => {
        ctx.fillText(labels[i], centerX + pos - 5, centerY - 5); // Подписи на оси X
        ctx.fillText(labels[i], centerX + 5, centerY - pos + 3); // Подписи на оси Y
    });
}