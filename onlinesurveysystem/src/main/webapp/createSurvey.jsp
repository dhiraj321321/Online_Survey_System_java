<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Survey</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .options-container {
            border: 1px dashed #ccc;
            padding: 15px;
            margin-top: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .option-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .option-item .form-control {
            flex-grow: 1;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary">Create a New Survey</h2>
    <form action="CreateSurveyServlet" method="post" class="mt-4">
        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-primary text-white">
                Survey Details
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="title" class="form-label">Survey Title</label>
                    <input type="text" id="title" name="title" class="form-control" placeholder="Enter survey title" required />
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea id="description" name="description" class="form-control" rows="4" placeholder="Provide a brief description of your survey" required></textarea>
                </div>
            </div>
        </div>

        <div id="questions-container">
            </div>
        
        <div class="d-grid gap-2">
            <button type="button" id="add-question-btn" class="btn btn-info btn-lg mt-3"><i class="fas fa-plus-circle"></i> Add Another Question</button>
            <button type="submit" class="btn btn-success btn-lg mt-3"><i class="fas fa-paper-plane"></i> Create Survey</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let questionCount = 0;

    function addQuestion() {
        questionCount++;
        console.log("addQuestion called. Current questionCount:", questionCount); // DEBUG
        const container = document.getElementById('questions-container');
        const newQuestionHtml = `
            <div class="card my-3 question-card shadow-sm" id="question-${questionCount}">
                <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                    <span>Question ${questionCount}</span>
                    <button type="button" class="btn btn-sm btn-outline-light remove-question-btn" data-question-id="${questionCount}"><i class="fas fa-times-circle"></i> Remove</button>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label for="questionText-${questionCount}" class="form-label">Question Text</label>
                        <input type="text" id="questionText-${questionCount}" name="questionTexts" class="form-control" placeholder="Enter question text" required />
                    </div>
                    <div class="mb-3">
                        <label for="questionType-${questionCount}" class="form-label">Question Type</label>
                        <select id="questionType-${questionCount}" name="questionTypes" class="form-select" required onchange="toggleOptionsVisibility(this)">
                            <option value="MCQ">MCQ (Multiple Choice)</option>
                            <option value="Short Answer">Short Answer</option>
                            <option value="Rating">Rating (1-5)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="score-${questionCount}" class="form-label">Score (Optional)</label>
                        <input type="number" id="score-${questionCount}" name="scores" class="form-control" value="0" min="0" />
                    </div>

                    <div class="options-container" id="options-container-${questionCount}" style="display: none;">
                        <h6 class="mb-3">Multiple Choice Options:</h6>
                        <div id="mcq-options-${questionCount}">
                            </div>
                        <button type="button" class="btn btn-sm btn-primary mt-2 add-option-btn" data-question-id="${questionCount}"><i class="fas fa-plus-square"></i> Add Option</button>
                    </div>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', newQuestionHtml);
        console.log("Added new question card. ID:", `question-${questionCount}`); // DEBUG

        // Add event listeners for remove question and add option buttons
        document.querySelector(`#question-${questionCount} .remove-question-btn`).addEventListener('click', function() {
            this.closest('.question-card').remove();
            updateQuestionNumbers();
        });

        document.querySelector(`#question-${questionCount} .add-option-btn`).addEventListener('click', function() {
            const currentQuestionId = this.dataset.questionId;
            addMcqOption(currentQuestionId);
        });

        // Initialize visibility for the newly added question
        toggleOptionsVisibility(document.getElementById(`questionType-${questionCount}`));
    }

    function addMcqOption(questionId) {
        console.log("addMcqOption called for questionId:", questionId); // DEBUG: Check if questionId is correct here
        const optionsDiv = document.getElementById(`mcq-options-${questionId}`);
        if (!optionsDiv) {
            console.error("Target options div mcq-options-" + questionId + " not found!"); // DEBUG
            return;
        }
        const optionIndex = optionsDiv.children.length;

        const optionHtml = `
            <div class="option-item" id="option-${questionId}-${optionIndex}">
                <input type="text" name="options[${questionId}][]" class="form-control" placeholder="Option Text" required>
                <button type="button" class="btn btn-danger btn-sm remove-option-btn"><i class="fas fa-minus-circle"></i></button>
            </div>
        `;
        console.log("Generated optionHtml:", optionHtml); // DEBUG: Inspect the full HTML string for correctness

        optionsDiv.insertAdjacentHTML('beforeend', optionHtml);

        // Add event listener for the remove option button
        document.querySelector(`#option-${questionId}-${optionIndex} .remove-option-btn`).addEventListener('click', function() {
            this.closest('.option-item').remove();
        });
    }


    function toggleOptionsVisibility(selectElement) {
        const questionId = selectElement.id.split('-')[1];
        const optionsContainer = document.getElementById(`options-container-${questionId}`);
        console.log("toggleOptionsVisibility for Q_ID:", questionId, "Type:", selectElement.value); // DEBUG
        if (selectElement.value === "MCQ") {
            optionsContainer.style.display = 'block';
            const mcqOptionsDiv = document.getElementById(`mcq-options-${questionId}`);
            if (mcqOptionsDiv.children.length === 0) {
                addMcqOption(questionId); // Add first option if none exist
            }
        } else {
            optionsContainer.style.display = 'none';
            document.getElementById(`mcq-options-${questionId}`).innerHTML = ''; // Clear options
        }
    }

    function updateQuestionNumbers() {
        const questionCards = document.querySelectorAll('.question-card');
        console.log("updateQuestionNumbers called. Number of cards:", questionCards.length); // DEBUG
        questionCards.forEach((card, index) => {
            const oldId = card.id.split('-')[1];
            const newId = index + 1;
            
            card.id = `question-${newId}`;
            card.querySelector('.card-header span').textContent = `Question ${newId}`;
            card.querySelector('.remove-question-btn').dataset.questionId = newId;

            // Update input names and IDs for question text, type, score
            card.querySelector(`[name="questionTexts"]`).id = `questionText-${newId}`;
            card.querySelector(`[name="questionTypes"]`).id = `questionType-${newId}`;
            // Re-attach onchange handler to ensure it works after re-ID
            card.querySelector(`[name="questionTypes"]`).setAttribute('onchange', `toggleOptionsVisibility(this)`); 
            card.querySelector(`[name="scores"]`).id = `score-${newId}`;

            // Update options container and button data-question-id
            const optionsContainer = card.querySelector('.options-container');
            if (optionsContainer) {
                optionsContainer.id = `options-container-${newId}`;
                const mcqOptionsDiv = card.querySelector(`#mcq-options-${oldId}`); // Use oldId to find it first
                if (mcqOptionsDiv) {
                    mcqOptionsDiv.id = `mcq-options-${newId}`; // Then update its ID
                }
                const addOptionBtn = card.querySelector('.add-option-btn');
                if (addOptionBtn) {
                    addOptionBtn.dataset.questionId = newId;
                }

                // Update names of existing options
                const optionInputs = optionsContainer.querySelectorAll(`input[name="options[${oldId}][]"]`);
                optionInputs.forEach(input => {
                    input.name = `options[${newId}][]`;
                    console.log(`Updated option input name from options[${oldId}][] to options[${newId}][]`); // DEBUG
                });
            }
        });
        questionCount = questionCards.length;
    }

    document.getElementById('add-question-btn').addEventListener('click', addQuestion);

    // Add an initial question when the page loads
    window.onload = addQuestion;
</script>
</body>
</html>