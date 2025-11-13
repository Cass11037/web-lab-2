"use strict";

const canvas = document.getElementById("plot-canvas");
const ctx = canvas.getContext("2d");
const form = document.getElementById("coordinates-form");
const yInput = document.getElementById("y-value");
const rSelect = document.getElementById("r-value");
const errorContainer = document.getElementById("error-container");
const KEY_FOR_R_VALUE = "selected_r_value";

canvas.addEventListener("click", (event) => {
  hideError();
  const rError = validateR();
  if (rError) {
    showError(rError);
    return;
  }
  const rValue = parseFloat(rSelect.value);
  const rect = canvas.getBoundingClientRect();
  const canvasX = event.clientX - rect.left;
  const canvasY = event.clientY - rect.top;
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;
  const r_pixels = canvas.width / 3;
  const mathX = ((canvasX - centerX) / r_pixels) * rValue;
  const mathY = ((centerY - canvasY) / r_pixels) * rValue;
  const dynamicForm = document.createElement("form");
  dynamicForm.method = "POST";
  dynamicForm.action = form.action;

  function createInput(name, value) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;
    return input;
  }
  dynamicForm.appendChild(createInput("x", mathX.toFixed(3)));
  dynamicForm.appendChild(createInput("y", mathY.toFixed(3))); 
  dynamicForm.appendChild(createInput("r", rValue));

  document.body.appendChild(dynamicForm);
  dynamicForm.submit();
});


form.addEventListener("submit", (event) => {
  const xError = validateX();
  const yError = validateY();
  const rError = validateR();

  if (xError || yError || rError) {
    event.preventDefault();
    showError(xError || yError || rError);
  } else {
    hideError();
  }
});

rSelect.addEventListener("change", () => {
  const rValue = parseFloat(rSelect.value);
  if (!isNaN(rValue)) {
    drawPlot(rValue);
    redrawPoints(rValue);
    localStorage.setItem(KEY_FOR_R_VALUE, rValue);
  }
});


function validateX() {
  const checkedX = document.querySelector('input[name="x"]:checked');
  if (!checkedX) {
    return "Please select at least one X value.";
  }
  return null;
}

function validateY() {
  const yValueStr = yInput.value.trim().replace(",", ".");
  if (yValueStr === "") {
    return "Please enter a Y value.";
  }
  if (isNaN(yValueStr)) {
    return "The Y value must be a number.";
  }
  const yNum = parseFloat(yValueStr);
  if (yNum <= -5 || yNum >= 3) {
    return "The Y value must be in the interval (-5 ... 3).";
  }
  return null;
}

function validateR() {
  const rValue = rSelect.value;
  if (rValue === "") {
    return "Please select an R value.";
  }
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
  ctx.fill();
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(centerX, centerY);
  ctx.lineTo(centerX + r_pixels / 2, centerY);
  ctx.lineTo(centerX, centerY + r_pixels);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(centerX, centerY);
  ctx.arc(centerX, centerY, r_pixels, Math.PI / 2, Math.PI);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  drawAxes();

  ctx.fillStyle = "black";
  const labels = [`-${r}`, `-${r / 2}`, `${r / 2}`, `${r}`];
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
  if (typeof historyPoints !== "undefined" && historyPoints) {
    historyPoints.forEach((point) => {
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
  ctx.fill();
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(centerX, centerY);
  ctx.lineTo(centerX + r_pixels / 2, centerY);
  ctx.lineTo(centerX, centerY + r_pixels);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(centerX, centerY);
  ctx.arc(centerX, centerY, r_pixels, Math.PI / 2, Math.PI);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  drawAxes();

  ctx.fillStyle = "black";
  const labels = ["-R", "-R/2", "R/2", "R"];
  const positions = [-r_pixels, -r_pixels / 2, r_pixels / 2, r_pixels];
  positions.forEach((pos, i) => {
    ctx.fillText(labels[i], centerX + pos - 5, centerY - 5);
    ctx.fillText(labels[i], centerX + 5, centerY - pos + 3);
  });
}

function drawAxes() {
  const width = canvas.width;
  const height = canvas.height;
  const centerX = width / 2;
  const centerY = height / 2;
  const arrowSize = 10;
  ctx.strokeStyle = "black";
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(0, centerY);
  ctx.lineTo(width, centerY);
  ctx.moveTo(width, centerY);
  ctx.lineTo(width - arrowSize, centerY - arrowSize / 2);
  ctx.moveTo(width, centerY);
  ctx.lineTo(width - arrowSize, centerY + arrowSize / 2);
  ctx.moveTo(centerX, height);
  ctx.lineTo(centerX, 0);
  ctx.moveTo(centerX, 0);
  ctx.lineTo(centerX - arrowSize / 2, arrowSize);
  ctx.moveTo(centerX, 0);
  ctx.lineTo(centerX + arrowSize / 2, arrowSize);
  ctx.stroke();
}

document.addEventListener("DOMContentLoaded", () => {
  const savedR = localStorage.getItem(KEY_FOR_R_VALUE);
  let initialR;
  if (savedR) {
    rSelect.value = savedR;
    initialR = parseFloat(savedR);
  } else {
    initialR = parseFloat(rSelect.value);
  }
  if (!isNaN(initialR)) {
    drawPlot(initialR);
    redrawPoints(initialR);
  } else {
    drawPlotWithTextLabels();
  }
});
