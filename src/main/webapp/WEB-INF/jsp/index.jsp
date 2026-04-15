<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home - ${courseName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/index">Online Course System</a>
            <div class="d-flex text-light align-items-center">
                <sec:authorize access="!isAuthenticated()">
                    <a href="/login" class="btn btn-outline-light me-2">Login</a>
                    <a href="/register" class="btn btn-primary">Register</a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <span class="me-3">Welcome, <sec:authentication property="name"/></span>
                    
                    <a href="/profile" class="btn btn-outline-info btn-sm me-3">My Profile</a>
                    
                    <sec:authorize access="hasRole('TEACHER')">
                        <a href="/teacher/dashboard" class="btn btn-danger me-3">Admin Dashboard</a>
                    </sec:authorize>
                    
                    <form action="/logout" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
                    </form>
                </sec:authorize>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="p-5 mb-4 bg-white rounded-3 shadow-sm border">
            <div class="container-fluid py-2">
                <h1 class="display-5 fw-bold text-dark">${courseName}</h1>
                <p class="col-md-8 fs-4 text-secondary">${courseDescription}</p>
                <a href="/index" class="btn btn-secondary btn-sm mt-2">Refresh Homepage</a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h3 class="mb-3 border-bottom pb-2">Course Lectures</h3>
                <div class="list-group">
                    <c:forEach var="lecture" items="${lectures}">
                        <a href="/lecture/${lecture.id}" class="list-group-item list-group-item-action mb-3 shadow-sm rounded border">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1 text-primary fw-bold">${lecture.title}</h5>
                            </div>
                            <p class="mb-1 text-dark">${lecture.summary}</p>
                            <small class="text-muted">Click to view materials & discussion</small>
                        </a>
                    </c:forEach>
                    <c:if test="${empty lectures}">
                        <div class="alert alert-secondary shadow-sm">No lectures have been uploaded yet.</div>
                    </c:if>
                </div>
            </div>

            <div class="col-md-6">
                <h3 class="mb-3 border-bottom pb-2">Active Polls</h3>
                <div class="list-group">
                    <c:forEach var="poll" items="${polls}">
                        <a href="/poll/${poll.id}" class="list-group-item list-group-item-action mb-3 shadow-sm rounded border-primary border-2">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1 text-primary">Poll #${poll.id}</h5>
                            </div>
                            <p class="mb-1 fw-bold text-dark">${poll.question}</p>
                            <small class="text-success">Click to participate or view results</small>
                        </a>
                    </c:forEach>
                    <c:if test="${empty polls}">
                        <div class="alert alert-secondary shadow-sm">No active polls at the moment.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>