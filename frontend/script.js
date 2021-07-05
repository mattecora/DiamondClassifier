const labels = ["Low", "Medium", "High"];

const loadingOverlayDiv = document.getElementById("loading-overlay");
const predictionLoadingDiv = document.getElementById("prediction-loading");
const predictionResultDiv = document.getElementById("prediction-result");
const predictionResultContentDiv = document.getElementById("prediction-result-content");
const predictionErrorDiv = document.getElementById("prediction-error");
const predictionErrorContentDiv = document.getElementById("prediction-error-content");

function updateSliderLabel(sliderId, labelId, suffix) {
    document.getElementById(labelId).innerText = document.getElementById(sliderId).value + " " + suffix;
}

async function predict() {
    // Show the spinner
    loadingOverlayDiv.style.display = "flex";

    // Parse the inputs
    let inputs = {
        "cut": parseInt(document.querySelector("input[name='input-cut']:checked").value),
        "color": parseInt(document.querySelector("input[name='input-color']:checked").value),
        "clarity": parseInt(document.querySelector("input[name='input-clarity']:checked").value),
        "price": parseFloat(document.querySelector("input#input-price").value),
        "x": parseFloat(document.querySelector("input#input-x").value),
        "y": parseFloat(document.querySelector("input#input-y").value),
        "z": parseFloat(document.querySelector("input#input-z").value),
        "depth": parseFloat(document.querySelector("input#input-depth").value),
        "table": parseFloat(document.querySelector("input#input-table").value)
    };

    try {
        // Call the prediction endpoint
        let response = await (await fetch(predictUrl, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify([inputs])
        })).json();
        console.log("OK");

        // Display results
        predictionResultContentDiv.innerHTML = 
            "<strong>Predicted class</strong>: " + 
            labels[response["predictions"][0]["label"]] + 
            "<br /><strong>Request body</strong>:<br />" + 
            JSON.stringify(response["predictions"][0]["body"], null, 1);
        predictionResultDiv.style.display = "block";
    } catch (e) {
        predictionErrorContentDiv.innerText = e;
        predictionErrorDiv.style.display = "block";
    }

    // Hide the spinner
    predictionLoadingDiv.style.display = "none";
}

function closeOverlay() {
    // Reset elements visibility
    loadingOverlayDiv.style.display = "none";
    predictionLoadingDiv.style.display = "block";
    predictionResultDiv.style.display = "none";
    predictionErrorDiv.style.display = "none";
}

updateSliderLabel("input-price", "input-price-val", "$");
updateSliderLabel("input-x", "input-x-val", "mm");
updateSliderLabel("input-y", "input-y-val", "mm");
updateSliderLabel("input-z", "input-z-val", "mm");
updateSliderLabel("input-depth", "input-depth-val", "%");
updateSliderLabel("input-table", "input-table-val", "%");