<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="includes/header.jsp"/>
<body class="bg-light">

<div class="container">
    <main>
        <div class="py-5 text-center">
            <h2>회원가입</h2>
        </div>
        <div class="row g-5">
            <div class="col-md-5 col-lg-2 order-md-last">
                <br><br>
                <p class="lead"> 환영합니다!</p>
                <p class="lead"> 가입에 필요한 항목을 입력해주세요.</p>
                <p class="lead"> 가짜로 입력하셔도 괜찮습니다.</p>
            </div>

            <div class="col-md-7 col-lg-10">
                <form class="needs-validation" method="post" action="/signUp">
                    <div class="row g-3">
                        <div class="col-7">
                            <label for="userid" class="form-label">아이디</label>
                            <input type="text" class="form-control" id="userid" name="userid" required onkeyup="idCheck()" maxlength="30">
                        </div>

                        <div class="col-sm-4">
                            <label for="idCheck" class="form-label">&nbsp</label><br>
                            <div id="idCheck"></div>
                        </div>

                        <div class="col-7">
                            <label for="userpw" class="form-label">비밀번호</label>
                            <input type="password" class="form-control" id="userpw" name="userpw" required>
                        </div>

                        <div class="col-7">
                            <label for="username" class="form-label">유저명(닉네임)</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>

                        <div class="col-7">
                            <label for="usermail" class="form-label">이메일 <span class="text-muted">(선택)</span></label>
                            <input type="email" class="form-control" id="usermail" name="usermail"
                                   placeholder="you@example.com">
                        </div>

                        <div class="col-md-5">
                            <label for="auth" class="form-label">회원등급<span
                                    class="text-muted">(우수회원은 특별 게시판 이용 가능)</span></label>
                            <select class="form-select" id="auth" name="auth">
                                <option value="NORMAL">일반회원</option>
                                <option value="SUPER">우수회원</option>
                            </select>
                        </div>
                        <hr class="my-4">

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                        <input class="w-50 btn btn-primary btn-lg" type="submit" onclick="return submitCheck()" value="회원가입">
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

        let form = document.querySelectorAll('.needs-validation')

        let csrfHeaderName = "${_csrf.headerName}";
        let csrfTokenValue = "${_csrf.token}";

        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        });
    });

    function idCheck() {
        let userid = $("#userid").val();
        $.ajax({
            url: "/idCheck",
            type: "POST",
            data: {userid: userid},
            dataType: 'text',
            success: function (result) {
                console.log(result)
                if (result === "dup") {
                    $("#idCheck").html("중복된 아이디입니다.");
                } else if (result === "ok") {
                    $("#idCheck").html("사용 가능한 아이디입니다.");
                }
            },
            error: function (error) {
                // console.log(error)
            },
        });
    }

    function submitCheck() {
        let check = $("#idCheck").text();

        console.log(check)
        if (check === "중복된 아이디입니다.") {
            alert("다른 아이디를 입력해주세요.");
            $("#userid").focus();
            return false;
        }
    }
</script>
</body>
