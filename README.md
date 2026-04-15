# COMP3800 Course Management Platform

This project is a course management and teaching platform built with Spring Boot 3, Spring Security, Spring Data JPA, JSP, and H2 Database. It supports user authentication, teacher and student roles, course material management, classroom polls, comment interaction, and profile management in a simple web-based interface.

## Features

- User registration and login with Spring Security
- Teacher and student role-based access control
- Teacher dashboard for managing users, lectures, materials, comments, and polls
- Course lecture pages with downloadable materials
- Classroom polling and voting
- Comment interaction on lectures and polls
- User profile viewing and editing
- H2 file-based database for persistent local storage

## Tech Stack

- Java 17
- Spring Boot 3.2.4
- Spring Security
- Spring Data JPA
- JSP / JSTL
- Gradle
- H2 Database

## Project Structure

```text
3800/
├─ src/
│  └─ main/
│     ├─ java/
│     │  └─ hk/edu/hkmu/comp3800/
│     ├─ resources/
│     │  ├─ application.properties
│     │  └─ static/
│     └─ webapp/
│        └─ WEB-INF/jsp/
├─ data/
├─ build.gradle
└─ README.md
```

## Main Functions

### Public

- View the home page
- Browse lectures and polls
- Register a student or teacher account
- Log in and log out

### Student

- View lectures and course materials
- Vote in classroom polls
- Post comments
- Manage personal profile

### Teacher

- Access the teacher dashboard
- Create, update, and delete lectures
- Upload and remove course materials
- Create, update, and delete polls
- Manage users and comments

## Default Demo Accounts

The application seeds sample accounts on first run:

- Teacher: `teacher1` / `password`
- Student: `student1` / `password`

Teacher registration also uses an invite code defined in `application.properties`:

- Invite code: `HKMU-TEACHER-2026`

## How to Run

### Requirements

- Java 17
- Gradle installed locally

### Start the application

```bash
gradle bootRun
```

After startup, open:

- Application: `http://localhost:8080`
- H2 Console: `http://localhost:8080/h2-console`

## Configuration

The main configuration file is:

```text
src/main/resources/application.properties
```

Important settings include:

- Server port
- H2 database path
- Upload size limits
- JSP view resolver
- Teacher invite code:HKMU-TEACHER-2026

Current database configuration uses a local file:

```text
jdbc:h2:file:./data/course_db
```

Uploaded files are stored in:

```text
data/uploads/
```

## License

This project is intended for educational use.
