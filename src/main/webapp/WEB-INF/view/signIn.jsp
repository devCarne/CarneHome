<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<title>로그인</title>
<jsp:include page="includes/header.jsp"/>

<style>
  .panel-heading {
    padding: 30px;
  }

  .form-group, .checkbox {
    margin: 10px 0;
  }
</style>
<body>

<div class="container">
  <div class="row">
    <div class="col-md-4 col-md-offset-4">
      <div class="login-panel panel panel-default">

        <div class="panel-heading">
          <h3 class="panel-title">회원 로그인</h3>
        </div>

        <div class="panel-body">
          <form role="form" method="post" action="/login">
            <fieldset>
              <div class="form-group">
                <input class="form-control" placeholder="아이디" name="username" type="text" autofocus>
              </div>
              <div class="form-group">
                <input class="form-control" placeholder="비밀번호" name="password" type="password">
              </div>
              <div class="checkbox">
                <label>
                  <input name="remember-me" type="checkbox"> 로그인 유지
                </label>
              </div>
              <c:if test="${exception != null}">
                <p id="valid" class="alert alert-danger">${exception}</p>
              </c:if>
              <!-- Change this to a button or input when using this as a form -->
              <button class="btn btnSignIn w-100 btn-lg btn-success btn-block">Login</button>
            </fieldset>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
          </form>
          <button class="btn btnSignUp w-100 btn-lg btn-primary btn-block">회원가입</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- jQuery -->

<script>
  $(".btnSignIn").on("click", function (e) {
    e.preventDefault();
    $("form").submit();
  });

  $(".btnSignUp").on("click", function (e) {
    location.href = "/signUp";
  });
</script>
</body>
