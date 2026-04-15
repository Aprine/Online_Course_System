<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${lecture.title} - Online Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/index">Online Course System</a>
            <div class="d-flex text-light align-items-center">
                <sec:authorize access="isAuthenticated()">
                    <span class="me-3">Welcome, <sec:authentication property="name"/></span>
                    <form action="/logout" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
                    </form>
                </sec:authorize>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="mb-3">
            <a href="/index" class="btn btn-secondary btn-sm">&larr; Back to Homepage</a>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h2 class="card-title">${lecture.title}</h2>
                <hr>
                <p class="card-text fs-5">${lecture.summary}</p>
                
                <h5 class="mt-4">Course Materials</h5>
                <ul class="list-group list-group-flush mb-3">
                    <c:forEach var="material" items="${materials}">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            ${material.fileName}
                            <a href="${material.filePath}" class="btn btn-primary btn-sm" download>Download</a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty materials}">
                        <li class="list-group-item text-muted">No materials uploaded for this lecture yet.</li>
                    </c:if>
                </ul>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white">
                <h4 class="mb-0">Discussion</h4>
            </div>
            <div class="card-body">
                <sec:authorize access="isAuthenticated()">
                    <form action="/comment/add" method="post" class="mb-4">
                        <input type="hidden" name="lectureId" value="${lecture.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3">
                            <label for="content" class="form-label">Write a comment...</label>
                            <textarea class="form-control" id="content" name="content" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-success">Post Comment</button>
                    </form>
                </sec:authorize>
                <sec:authorize access="!isAuthenticated()">
                    <div class="alert alert-warning">
                        You must be <a href="/login">logged in</a> to post a comment.
                    </div>
                </sec:authorize>

                <div class="list-group">
                    <c:forEach var="comment" items="${comments}">
                        <div class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 fw-bold">${comment.author.fullName} (@${comment.author.username})</h6>
                                <small class="text-muted">${comment.createdAt}</small>
                            </div>
                            <p class="mb-1">${comment.content}</p>
                        </div>
                    </c:forEach>
                    <c:if test="${empty comments}">
                        <p class="text-muted text-center mt-3">Be the first to comment!</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>