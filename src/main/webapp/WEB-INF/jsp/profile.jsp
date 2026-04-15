<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile & History - Online Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/index">Online Course System</a>
            <div class="d-flex text-light align-items-center">
                <span class="me-3">Welcome, <sec:authentication property="name"/></span>
                
                <sec:authorize access="hasRole('TEACHER')">
                    <a href="/teacher/dashboard" class="btn btn-danger btn-sm me-3">Admin Dashboard</a>
                </sec:authorize>
                
                <form action="/logout" method="post" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="mb-3">
            <a href="/index" class="btn btn-secondary btn-sm">&larr; Back to Homepage</a>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success shadow-sm">${successMessage}</div>
        </c:if>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-info mb-4">
                    <div class="card-body bg-info bg-opacity-10">
                        <h4 class="card-title text-info border-bottom pb-2">My Profile</h4>
                        <p class="mb-1"><strong>Username:</strong> ${user.username}</p>
                        <p class="mb-1"><strong>Name:</strong> ${user.fullName}</p>
                        <p class="mb-1"><strong>Email:</strong> ${user.email}</p>
                        <p class="mb-1"><strong>Phone:</strong> ${user.phoneNumber}</p>
                        <p class="mb-0"><strong>Role:</strong> <span class="badge bg-secondary">${user.role}</span></p>
                    </div>
                </div>

                <div class="card shadow-sm border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">Edit Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="/profile/update" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="mb-3">
                                <label class="form-label text-muted small">Username (Cannot be changed)</label>
                                <input type="text" class="form-control bg-light" value="${user.username}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small">Full Name</label>
                                <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small">Email Address</label>
                                <input type="email" class="form-control" name="email" value="${user.email}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small">Phone Number</label>
                                <input type="tel" class="form-control" name="phoneNumber" value="${user.phoneNumber}" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-warning">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">My Voting History</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach var="vote" items="${votingHistory}">
                                <a href="/poll/${vote.poll.id}" class="list-group-item list-group-item-action p-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-1 fw-bold text-dark">Poll #${vote.poll.id}</h6>
                                    </div>
                                    <p class="mb-2 text-secondary small">${vote.poll.question}</p>
                                    <p class="mb-0 bg-light p-2 rounded border border-primary text-primary d-inline-block">
                                        <strong>You selected:</strong> ${vote.selectedOption.optionText}
                                    </p>
                                </a>
                            </c:forEach>
                            <c:if test="${empty votingHistory}">
                                <div class="p-3 text-muted">You haven't participated in any polls yet.</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">My Comment History</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach var="comment" items="${commentHistory}">
                                <c:choose>
                                    <c:when test="${not empty comment.lecture}">
                                        <c:set var="targetLink" value="/lecture/${comment.lecture.id}" />
                                        <c:set var="targetName" value="Lecture: ${comment.lecture.title}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="targetLink" value="/poll/${comment.poll.id}" />
                                        <c:set var="targetName" value="Poll: ${comment.poll.question}" />
                                    </c:otherwise>
                                </c:choose>

                                <a href="${targetLink}" class="list-group-item list-group-item-action p-3">
                                    <div class="d-flex w-100 justify-content-between mb-2">
                                        <span class="badge bg-success bg-opacity-25 text-success border border-success">${targetName}</span>
                                        <small class="text-muted">${comment.createdAt.toLocalDate()}</small>
                                    </div>
                                    <p class="mb-0 text-dark">"${comment.content}"</p>
                                </a>
                            </c:forEach>
                            <c:if test="${empty commentHistory}">
                                <div class="p-3 text-muted">You haven't posted any comments yet.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>