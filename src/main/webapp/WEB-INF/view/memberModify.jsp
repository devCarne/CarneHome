<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:include page="includes/header.jsp"/>

<sec:authentication property="principal" var="principal"/>

<body class="bg-light">

<div class="container">
    <main>
        <div class="py-5 text-center">
            <h2>정보수정</h2>
        </div>
        <div class="row g-5">

            <div class="col-md-7 col-lg-10">
                <form class="needs-validation" method="post" action="/memberModify">
                    <div class="row g-3">
                        <div class="col-7">
                            <label for="userid" class="form-label">아이디</label>
                            <input type="text" class="form-control" id="userid" name="userid" required maxlength="30" value="${principal.username}" readonly>
                        </div>

                        <div class="col-sm-4">
                            <label for="pwCheck" class="form-label">&nbsp</label><br>
                            <div id="pwCheck"></div>
                        </div>

                        <div class="col-7">
                            <label for="originalPw" class="form-label">기존 비밀번호</label>
                            <input type="password" class="form-control" id="originalPw" name="originalPw" required maxlength="30" onkeyup="pwCheck()">
                        </div>

                        <div class="col-7">
                            <label for="userpw" class="form-label">변경할 비밀번호</label>
                            <input type="password" class="form-control" id="userpw" name="userpw" required maxlength="30">
                        </div>

                        <div class="col-7">
                            <label for="username" class="form-label">닉네임</label>
                            <input type="text" class="form-control" id="username" name="username" required maxlength="100" value="${principal.member.username}" readonly>
                        </div>

                        <div class="col-7">
                            <label for="usermail" class="form-label">이메일 <span class="text-muted">(선택)</span></label>
                            <input type="email" class="form-control" id="usermail" name="usermail"
                                   placeholder="you@example.com" maxlength="100">
                        </div>

                        <div class="col-md-5">
                            <label for="auth" class="form-label">회원등급<span
                                    class="text-muted">(우수회원은 게시판에 강조글 작성 가능)</span></label>
                            <select class="form-select" id="auth" name="auth">
                                <option value="NORMAL">일반회원</option>
                                <option value="SUPER">우수회원</option>
                            </select>
                        </div>

                        <hr class="my-4">

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                        <input class="w-50 btn btn-primary btn-lg" type="submit" onclick="return submitCheck()" value="정보변경">
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>

    (function () {
        'use strict'

        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        let forms = document.querySelectorAll('.needs-validation')

        // Loop over them and prevent submission
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                        form.classList.add('was-validated')
                    }
                }, false)
            })
    }())



    $(document).ready(function () {

        let csrfHeaderName = "${_csrf.headerName}";
        let csrfTokenValue = "${_csrf.token}";

        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        });
    });

    function pwCheck() {

        $.ajax({
            url: "/pwCheckAjax",
            type: "POST",
            data: {userid: $("#userid").val(), originalPw: $("#originalPw").val()},
            dataType: "text",
            success: function (result) {
                if (result === "no") {
                    $("#pwCheck").html("잘못된 비밀번호입니다.");
                } else if (result === "ok") {
                    $("#pwCheck").html("올바른 비밀번호입니다.");
                }
            }
        });
    }

    function submitCheck() {
        let check = $("#pwCheck").text();

        if (check === "잘못된 비밀번호입니다.") {
            alert("정확한 비밀번호를 입력해주세요.");
            $("#originalPw").focus();
            return false;
        }
    }
</script>
</body>
