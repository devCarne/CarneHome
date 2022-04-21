<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%--JQuery--%>
    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
    <!-- Bootstrap core CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    <%--font awsome icons--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- Custom styles for this template -->
<body>
<main>
    <header class="p-3 bg-dark text-white">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-5">
                    <ul class="nav">
                        <li><a href="/" class="nav-link px-2 text-white">홈으로</a></li>
                        <li><a href="/board/list" class="nav-link px-2 text-white">게시판</a></li>
                        <li><a href="/activity" class="nav-link px-2 text-white">대외활동</a></li>
                        <li><a href="#" class="nav-link px-2 text-white">채팅(구현 중)</a></li>
                        <li class="dropdown">
                            <a href="#" class="nav-link px-2 text-white dropdown-toggle"  role="button" data-toggle="dropdown" aria-haspopup="true">연락처</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item dropdown-phone" style="color: black" href="#">전화번호: 010-2078-1158</a>
                                <a class="dropdown-item dropdown-email" style="color: black" href="#">이메일: kms74568@naver.com</a>
                            </div>
                        </li>
                    </ul>
                </div>


                <sec:authorize access="isAnonymous()">
                    <div class="col btn-group">
                        <button type="button" class="btn btn-outline-light me-2" id="signInBtn">로그인</button>
                        <button type="button" class="btn btn-warning" id="singUpBtn">회원가입</button>
                    </div>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                <div class="col">
                    <sec:authorize access="hasAuthority('SUPER')">
                        <span>우수회원</span>
                    </sec:authorize>
                    <span><sec:authentication property="principal.member.username"/>님 안녕하세요.</span>
                </div>


                    <div class="col-3 btn-group">
                    <form class="logout-form visually-hidden" role="form" method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                    <button type="button" class="btn btn-outline-light me-2" id="logoutBtn">로그아웃</button>
                        <button type="button" class="btn btn-outline-light me-2 btn-memberModify">정보수정</button>
<%--                    <button type="button" class="btn btn-warning" id="singUpBtn">회원정보 수정</button>--%>
                </div>
                </sec:authorize>

            </div>
        <p style="display: none" class="phone">01020781158</p>
        <p style="display: none" class="email">kms74568@naver.com</p>

        </div>
    </header>

    <div class="b-example-divider"></div>
</main>

<script>
    $(document).ready(function () {

        $("#singUpBtn").on("click", function () {
            location.href = "/signUp";
        });

        $("#signInBtn").on("click", function () {
            location.href = "/signIn";
        })

        $("#logoutBtn").on("click", function () {
            $(".logout-form").submit();
            alert("로그아웃 하였습니다.");
        });

        $(".btn-memberModify").on("click", function () {
            location.href = "/memberModify";
        });

        $('.dropdown-toggle').on("click", function () {
            $(this).dropdown('toggle');
        });

        $(".dropdown-phone").on("click", function () {
            navigator.clipboard.writeText($(".phone").text());
            alert("전화번호가 복사되었습니다.")
        });

        $(".dropdown-email").on("click", function () {
            navigator.clipboard.writeText($(".email").text());
            alert("이메일이 복사되었습니다.")
        })
    });
</script>
</body>
