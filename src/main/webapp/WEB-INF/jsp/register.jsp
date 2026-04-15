<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - Online Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h3 class="card-title text-center mb-2">User Registration</h3>
                        <p class="text-center text-muted mb-4">Create a student or teacher account.</p>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <form action="/register" method="post">
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="${param.username}" required>
                                </div>
                                <div class="col">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="role" class="form-label">Account Type</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="STUDENT" <c:if test="${empty param.role || param.role == 'STUDENT'}">selected</c:if>>Student</option>
                                    <option value="TEACHER" <c:if test="${param.role == 'TEACHER'}">selected</c:if>>Teacher</option>
                                </select>
                            </div>
                            <div class="mb-3" id="inviteCodeGroup">
                                <label for="inviteCode" class="form-label">Teacher Invite Code</label>
                                <input type="password" class="form-control" id="inviteCode" name="inviteCode" placeholder="Required for teacher accounts">
                                <div class="form-text">Only needed if you select Teacher.</div>
                            </div>
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${param.fullName}" required>
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${param.email}" required>
                                </div>
                                <div class="col">
                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${param.phoneNumber}" required>
                                </div>
                            </div>
                            
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Register Account</button>
                            </div>
                        </form>
                    </div>
                    <div class="card-footer text-center">
                        <a href="/index">Return to Homepage</a> | 
                        <a href="/login">Already have an account? Login here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const roleSelect = document.getElementById('role');
        const inviteCodeInput = document.getElementById('inviteCode');
        const updateInviteState = () => {
            const isTeacher = roleSelect.value === 'TEACHER';
            inviteCodeInput.required = isTeacher;
            inviteCodeInput.parentElement.style.display = isTeacher ? 'block' : 'none';
            if (!isTeacher) {
                inviteCodeInput.value = '';
            }
        };
        roleSelect.addEventListener('change', updateInviteState);
        updateInviteState();
    </script>
</body>
</html>
