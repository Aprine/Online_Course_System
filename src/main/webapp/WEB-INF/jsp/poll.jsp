<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Poll: ${poll.question} - Online Course</title>
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

        <div class="card shadow-sm mb-4 border-primary">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Course Poll</h3>
            </div>
            <div class="card-body">
                <h4 class="card-title mb-4">${poll.question}</h4>

                <sec:authorize access="isAuthenticated()">
                    <form action="/poll/vote" method="post">
                        <input type="hidden" name="pollId" value="${poll.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <div class="list-group mb-4">
                            <c:forEach var="option" items="${options}">
                                <label class="list-group-item d-flex justify-content-between align-items-center list-group-item-action cursor-pointer">
                                    <div>
                                        <input class="form-check-input me-2" type="radio" name="optionId" value="${option.id}" required
                                               <c:if test="${userVoteId == option.id}">checked</c:if>>
                                        ${option.optionText}
                                    </div>
                                    <span class="badge bg-primary rounded-pill">${option.voteCount} votes</span>
                                </label>
                            </c:forEach>
                        </div>
                        
                        <button type="submit" class="btn btn-success">
                            <c:choose>
                                <c:when test="${not empty userVoteId}">Update Vote</c:when>
                                <c:otherwise>Submit Vote</c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </sec:authorize>
                
                <sec:authorize access="!isAuthenticated()">
                    <div class="alert alert-warning">
                        You must be <a href="/login">logged in</a> to participate in this poll.
                    </div>
                    <ul class="list-group mb-4">
                        <c:forEach var="option" items="${options}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                ${option.optionText}
                                <span class="badge bg-secondary rounded-pill">${option.voteCount} votes</span>
                            </li>
                        </c:forEach>
                    </ul>
                </sec:authorize>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white">
                <h5 class="mb-0">Poll Discussion</h5>
            </div>
            <div class="card-body">
                <sec:authorize access="isAuthenticated()">
                    <form action="/comment/add" method="post" class="mb-4">
                        <input type="hidden" name="pollId" value="${poll.id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3">
                            <textarea class="form-control" name="content" rows="2" placeholder="Share your thoughts on this poll..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm">Post Comment</button>
                    </form>
                </sec:authorize>

                <div class="list-group">
                    <c:forEach var="comment" items="${comments}">
                        <div class="list-group-item">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 fw-bold">${comment.author.fullName}</h6>
                            </div>
                            <p class="mb-1">${comment.content}</p>
                        </div>
                    </c:forEach>
                    <c:if test="${empty comments}">
                        <p class="text-muted text-center mt-2">No comments yet.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>