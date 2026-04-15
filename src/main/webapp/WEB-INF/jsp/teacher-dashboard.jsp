<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Dashboard - Online Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="/index">Admin Portal</a>
            <div class="d-flex text-light align-items-center">
                <span class="me-3">Teacher: <sec:authentication property="name"/></span>
                <form action="/logout" method="post" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="mb-3">
            <a href="/index" class="btn btn-secondary btn-sm">&larr; Back to Main Website</a>
        </div>
        
        <h2 class="mb-4">System Management Dashboard</h2>

        <c:if test="${not empty successMessage}">
            <c:choose>
                <c:when test="${successMessage == 'UserDeleted'}"><div class="alert alert-success shadow-sm">User deleted successfully.</div></c:when>
                <c:when test="${successMessage == 'UserUpdated'}"><div class="alert alert-success shadow-sm">User updated successfully.</div></c:when>
                <c:when test="${successMessage == 'CommentDeleted'}"><div class="alert alert-success shadow-sm">Comment deleted successfully.</div></c:when>
                <c:when test="${successMessage == 'LectureAdded'}"><div class="alert alert-success shadow-sm">Lecture added successfully.</div></c:when>
                <c:when test="${successMessage == 'LectureUpdated'}"><div class="alert alert-success shadow-sm">Lecture updated successfully.</div></c:when>
                <c:when test="${successMessage == 'LectureDeleted'}"><div class="alert alert-success shadow-sm">Lecture deleted successfully.</div></c:when>
                <c:when test="${successMessage == 'MaterialDeleted'}"><div class="alert alert-success shadow-sm">Course material deleted successfully.</div></c:when>
                <c:when test="${successMessage == 'PollAdded'}"><div class="alert alert-success shadow-sm">Poll added successfully.</div></c:when>
                <c:when test="${successMessage == 'PollUpdated'}"><div class="alert alert-success shadow-sm">Poll updated successfully.</div></c:when>
                <c:when test="${successMessage == 'PollDeleted'}"><div class="alert alert-success shadow-sm">Poll deleted successfully.</div></c:when>
                <c:otherwise><div class="alert alert-success shadow-sm">${successMessage}</div></c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <c:choose>
                <c:when test="${errorMessage == 'UserNotFound'}"><div class="alert alert-danger shadow-sm">User not found.</div></c:when>
                <c:when test="${errorMessage == 'LectureNotFound'}"><div class="alert alert-danger shadow-sm">Lecture not found.</div></c:when>
                <c:when test="${errorMessage == 'MaterialNotFound'}"><div class="alert alert-danger shadow-sm">Course material not found.</div></c:when>
                <c:when test="${errorMessage == 'MaterialRequired'}"><div class="alert alert-danger shadow-sm">A course material file is required when the lecture has no existing material.</div></c:when>
                <c:when test="${errorMessage == 'PollNotFound'}"><div class="alert alert-danger shadow-sm">Poll not found.</div></c:when>
                <c:when test="${errorMessage == 'UploadFailed'}"><div class="alert alert-danger shadow-sm">File upload failed. Please try again.</div></c:when>
                <c:otherwise><div class="alert alert-danger shadow-sm">${errorMessage}</div></c:otherwise>
            </c:choose>
        </c:if>

        <div class="row">
            <div class="col-md-12 mb-4">
                <div class="card shadow-sm border-danger">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0">Registered Users</h5>
                    </div>
                    <div class="card-body table-responsive">
                        <table class="table table-striped align-middle">
                            <thead>
                                <tr>
                                    <th style="width: 5%;">ID</th>
                                    <th style="width: 12%;">Username</th>
                                    <th style="width: 18%;">Full Name</th>
                                    <th style="width: 20%;">Email</th>
                                    <th style="width: 14%;">Phone</th>
                                    <th style="width: 12%;">Role</th>
                                    <th style="width: 19%;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>
                                            <input class="form-control form-control-sm" form="userForm-${user.id}" name="fullName" value="${user.fullName}" required>
                                        </td>
                                        <td>
                                            <input class="form-control form-control-sm" form="userForm-${user.id}" type="email" name="email" value="${user.email}" required>
                                        </td>
                                        <td>
                                            <input class="form-control form-control-sm" form="userForm-${user.id}" type="tel" name="phoneNumber" value="${user.phoneNumber}" required>
                                        </td>
                                        <td>
                                            <select class="form-select form-select-sm" form="userForm-${user.id}" name="role">
                                                <option value="ROLE_STUDENT" <c:if test="${user.role == 'ROLE_STUDENT'}">selected</c:if>>Student</option>
                                                <option value="ROLE_TEACHER" <c:if test="${user.role == 'ROLE_TEACHER'}">selected</c:if>>Teacher</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="hidden" form="userForm-${user.id}" name="userId" value="${user.id}">
                                            <input type="hidden" form="userForm-${user.id}" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <button type="submit" form="userForm-${user.id}" class="btn btn-sm btn-primary me-1">Save</button>
                                            <form id="userForm-${user.id}" action="/teacher/user/update" method="post" class="d-inline"></form>
                                            <form action="/teacher/user/delete" method="post" class="d-inline">
                                                <input type="hidden" name="userId" value="${user.id}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Delete this user?');">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Lectures & Materials</h5>
                        <span class="small">Add / delete lecture pages</span>
                    </div>
                    <div class="card-body">
                        <form action="/teacher/lecture/add" method="post" enctype="multipart/form-data" class="mb-4 border rounded p-3 bg-light">
                            <h6 class="mb-3">Add Lecture</h6>
                            <div class="mb-2">
                                <input class="form-control form-control-sm" name="title" placeholder="Lecture title" required>
                            </div>
                            <div class="mb-2">
                                <textarea class="form-control form-control-sm" name="summary" rows="3" placeholder="Lecture summary" required></textarea>
                            </div>
                            <div class="mb-2">
                                <input class="form-control form-control-sm" name="materialFileName" placeholder="Display name for the file" required>
                            </div>
                            <div class="mb-2">
                                <input class="form-control form-control-sm" type="file" name="materialFile" required>
                                <div class="form-text">Upload the lecture note or course material file.</div>
                            </div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-success btn-sm">Create Lecture</button>
                        </form>

                        <div class="list-group">
                            <c:forEach var="lecture" items="${lectures}">
                                <div class="list-group-item mb-3">
                                    <form id="lectureForm-${lecture.id}" action="/teacher/lecture/update" method="post" enctype="multipart/form-data"></form>
                                    <input type="hidden" name="lectureId" value="${lecture.id}" form="lectureForm-${lecture.id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" form="lectureForm-${lecture.id}">
                                    <div class="mb-2">
                                        <label class="form-label small mb-1">Lecture Title</label>
                                        <input class="form-control form-control-sm" name="title" value="${lecture.title}" form="lectureForm-${lecture.id}" required>
                                    </div>
                                    <div class="mb-2">
                                        <label class="form-label small mb-1">Summary</label>
                                        <textarea class="form-control form-control-sm" name="summary" rows="3" form="lectureForm-${lecture.id}" required>${lecture.summary}</textarea>
                                    </div>
                                    <div class="row g-2 mb-2">
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Material Name</label>
                                            <input class="form-control form-control-sm" name="materialFileName" value="${empty lecture.materials ? 'Lecture Notes' : lecture.materials[0].fileName}" form="lectureForm-${lecture.id}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Replace Material File</label>
                                            <input class="form-control form-control-sm" type="file" name="materialFile" form="lectureForm-${lecture.id}">
                                        </div>
                                    </div>
                                    <c:if test="${not empty lecture.materials}">
                                        <div class="small text-muted mb-2 d-flex flex-wrap align-items-center gap-2">
                                            <span>Current file:</span>
                                            <a href="${lecture.materials[0].filePath}" target="_blank">${lecture.materials[0].fileName}</a>
                                            <form action="/teacher/material/delete" method="post" class="d-inline">
                                                <input type="hidden" name="materialId" value="${lecture.materials[0].id}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2" onclick="return confirm('Delete this course material?');">Delete Material</button>
                                            </form>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty lecture.materials}">
                                        <div class="small text-muted mb-2">No course material uploaded yet. Upload one before saving if you want this lecture to have a download file.</div>
                                    </c:if>
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="submit" form="lectureForm-${lecture.id}" class="btn btn-sm btn-primary">Save Lecture</button>
                                        <form action="/teacher/lecture/delete" method="post" class="d-inline">
                                            <input type="hidden" name="lectureId" value="${lecture.id}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button class="btn btn-sm btn-outline-danger" type="submit" onclick="return confirm('Delete this lecture?');">Delete</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">Polls</h5>
                    </div>
                    <div class="card-body">
                        <form action="/teacher/poll/add" method="post" class="mb-4 border rounded p-3 bg-light">
                            <h6 class="mb-3">Add Poll</h6>
                            <div class="mb-2">
                                <textarea class="form-control form-control-sm" name="question" rows="2" placeholder="Poll question" required></textarea>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-md-6"><input class="form-control form-control-sm" name="option1" placeholder="Option 1" required></div>
                                <div class="col-md-6"><input class="form-control form-control-sm" name="option2" placeholder="Option 2" required></div>
                                <div class="col-md-6"><input class="form-control form-control-sm" name="option3" placeholder="Option 3" required></div>
                                <div class="col-md-6"><input class="form-control form-control-sm" name="option4" placeholder="Option 4" required></div>
                                <div class="col-md-6"><input class="form-control form-control-sm" name="option5" placeholder="Option 5" required></div>
                            </div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-success btn-sm">Create Poll</button>
                        </form>

                        <div class="list-group">
                            <c:forEach var="poll" items="${polls}">
                                <div class="list-group-item mb-3">
                                    <form id="pollForm-${poll.id}" action="/teacher/poll/update" method="post"></form>
                                    <input type="hidden" name="pollId" value="${poll.id}" form="pollForm-${poll.id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" form="pollForm-${poll.id}">
                                    <div class="mb-2">
                                        <label class="form-label small mb-1">Poll Question</label>
                                        <textarea class="form-control form-control-sm" name="question" rows="2" form="pollForm-${poll.id}" required>${poll.question}</textarea>
                                    </div>
                                    <div class="row g-2 mb-2">
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Option 1</label>
                                            <input class="form-control form-control-sm" name="option1" value="${poll.options[0].optionText}" form="pollForm-${poll.id}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Option 2</label>
                                            <input class="form-control form-control-sm" name="option2" value="${poll.options[1].optionText}" form="pollForm-${poll.id}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Option 3</label>
                                            <input class="form-control form-control-sm" name="option3" value="${poll.options[2].optionText}" form="pollForm-${poll.id}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Option 4</label>
                                            <input class="form-control form-control-sm" name="option4" value="${poll.options[3].optionText}" form="pollForm-${poll.id}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small mb-1">Option 5</label>
                                            <input class="form-control form-control-sm" name="option5" value="${poll.options[4].optionText}" form="pollForm-${poll.id}" required>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="submit" form="pollForm-${poll.id}" class="btn btn-sm btn-primary">Save Poll</button>
                                        <form action="/teacher/poll/delete" method="post" class="d-inline">
                                            <input type="hidden" name="pollId" value="${poll.id}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this poll?');">Delete</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-12 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">Recent Comments</h5>
                    </div>
                    <div class="card-body" style="max-height: 300px; overflow-y: auto;">
                        <ul class="list-group">
                            <c:forEach var="comment" items="${comments}">
                                <li class="list-group-item flex-column align-items-start">
                                    <div class="d-flex w-100 justify-content-between">
                                        <small class="fw-bold">${comment.author.username}</small>
                                        <form action="/teacher/comment/delete" method="post" class="d-inline">
                                            <input type="hidden" name="commentId" value="${comment.id}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-danger py-0 px-1" onclick="return confirm('Delete this comment?');">X</button>
                                        </form>
                                    </div>
                                    <p class="mb-0 small">${comment.content}</p>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
