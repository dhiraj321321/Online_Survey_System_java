# Online_Survey_System_java

Project Overview
The Online Survey System is a web-based application developed using Java Servlets, JSP, and JDBC for managing and conducting surveys. It allows authenticated users to create surveys with various question types (Multiple Choice, Short Answer, Rating), collect responses, and view aggregated results.

Features
User Authentication: Secure login and registration for users.

Survey Creation:

Create new surveys with a title and description.

Dynamically add multiple questions per survey.

Support for different question types:

Multiple Choice (MCQ): Allows adding multiple options for selection.

Short Answer: For open-ended text responses.

Rating: For numerical ratings (e.g., 1-5).

Survey Participation: Users can submit responses to available surveys.

View Surveys: Browse a list of all available surveys.

View Results: See collected responses for each question, including an overview for different question types (e.g., individual answers, average ratings).

Survey Management: Delete existing surveys along with all associated questions, options, responses, and answers.

Database Integration: Stores all survey data, questions, options, and responses in a PostgreSQL database.

User Interface: Modern and responsive UI built with Bootstrap 5.

Technologies Used
Backend:

Java (Servlets, JDBC)

Apache Tomcat (Application Server)

Frontend:

JSP (JavaServer Pages)

HTML5

CSS3 (Custom styles)

JavaScript (for dynamic UI elements)

Bootstrap 5 (for responsive design and styling)

Font Awesome (for icons)

Database:

PostgreSQL

Build Tool:

Maven

Setup Instructions
Prerequisites
Java Development Kit (JDK) 8 or higher

Apache Maven

Apache Tomcat 9.x or higher

PostgreSQL Database Server

Your preferred IDE (e.g., Apache NetBeans, IntelliJ IDEA, Eclipse)

Database Setup
Create a PostgreSQL Database:

SQL

CREATE DATABASE surveysystem;
Create Tables: Connect to the surveysystem database and run the following SQL scripts to create the necessary tables:

SQL

-- users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- surveys table
CREATE TABLE surveys (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- questions table
CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    survey_id INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL, -- e.g., 'MCQ', 'Short Answer', 'Rating'
    score INTEGER DEFAULT 0,
    FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
);

-- options table (for MCQ questions)
CREATE TABLE options (
    id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE, -- useful if surveys are also quizzes
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- responses table (a single submission of a survey by a user)
CREATE TABLE responses (
    id SERIAL PRIMARY KEY,
    survey_id INTEGER NOT NULL,
    user_email VARCHAR(100), -- Storing email as user might not be logged in or new user
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
);

-- answers table (individual answers to questions within a response)
CREATE TABLE answers (
    id SERIAL PRIMARY KEY,
    response_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    answer_text TEXT, -- Stores the text of the answer
    FOREIGN KEY (response_id) REFERENCES responses(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);
Database Connection (DBConnection.java):

Update src/main/java/com/login/onlinesurveysystem/util/DBConnection.java with your PostgreSQL database credentials:

Java

// Example snippet from DBConnection.java
private static final String URL = "jdbc:postgresql://localhost:5432/surveysystem"; // Your DB URL
private static final String USER = "your_db_username"; // Your DB username
private static final String PASSWORD = "your_db_password"; // Your DB password
Project Setup
Clone the Repository (if not already):

Bash

git clone https://github.com/YOUR_USERNAME/Online_Survey_System_java.git
cd Online_Survey_System_java
Open in IDE: Import the project into your IDE (NetBeans, IntelliJ, Eclipse) as a Maven project.

Build the Project: Use Maven to clean and build the project.

Bash

mvn clean install
This will generate the onlinesurveysystem-1.0-SNAPSHOT.war file in the target/ directory.

Deployment to Tomcat
Locate Tomcat webapps directory: Find the webapps directory in your Apache Tomcat installation (e.g., C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps).

Deploy WAR file: Copy the generated onlinesurveysystem-1.0-SNAPSHOT.war file from your project's target/ directory into Tomcat's webapps directory.

Rename (Optional): For a cleaner URL, you can rename onlinesurveysystem-1.0-SNAPSHOT.war to OnlineSurveySystem.war (or any other name you prefer). Tomcat will then deploy it under /[your_chosen_name] as the context root. If you rename it to ROOT.war, it will be deployed directly under the base URL (e.g., http://localhost:8080/).

Start Tomcat: Start your Tomcat server.

Usage
Access the Application:
Open your web browser and navigate to:
http://localhost:8080/OnlineSurveySystem/ (assuming Tomcat default port and context root)
or
http://localhost:8080/OnlineSurveySystem/index.jsp

Register a New User: Click on "Register" to create a new account.

Login: Use your registered credentials to log in.

Create Survey: From the dashboard, click "Create New Survey" to design your survey with various questions and options.

View All Surveys: See the list of surveys you and others have created. You can view a survey to participate or view its results.

Submit Response: Complete a survey by providing your email and answers.

View Results: Analyze the submitted responses for your surveys.

Delete Survey: Remove surveys and all related data from the system.

