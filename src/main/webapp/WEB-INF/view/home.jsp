<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<title>홈</title>
<jsp:include page="includes/header.jsp"/>

<style>

    .rounded-5 {
        border-radius: 1rem;
    }

    .text-shadow-1 {
        text-shadow: 0 .125rem .1rem rgba(0, 0, 0, .9);
    }

    .card-cover {
        background-repeat: no-repeat;
        background-position: center center;
        background-size: cover;
        border: none;
    }

    a {
        text-decoration: none;
    }

    .icons {
        width: 100px;
        height: 100px;
        margin: 10px;
    }

</style>
<main>
    <div class="container px-4 py-5" id="custom-cards">
        <h2 class="pb-2 border-bottom">프로젝트 정보</h2>

        <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-5">
            <div class="col">
                <a href="https://github.com/devCarne/CarneHome" target="_blank">
                    <div class="card card-cover h-100 overflow-hidden text-white bg-dark rounded-5 shadow-lg"
                         style="background-image: url('/resources/img/GitHub.png');">
                        <div class="d-flex flex-column h-100 p-5 pb-3 text-light text-shadow-1">
                            <h2 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold">소스코드 GitHub</h2>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col">
                <a href="https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-%ED%95%B5%EC%8B%AC-%EC%9B%90%EB%A6%AC-%EA%B8%B0%EB%B3%B8%ED%8E%B8"
                   target="_blank">
                    <div class="card card-cover h-100 overflow-hidden text-white bg-dark rounded-5 shadow-lg"
                         style="background-image: url('/resources/img/Spring.png');">
                        <div class="d-flex flex-column h-100 p-5 pb-3 text-shadow-1">
                            <h2 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold">참고한 강의<br><br><br><br></h2>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col">
                <a href="https://www.yes24.com/Product/Goods/64340061" target="_blank">
                    <div class="card card-cover h-100 overflow-hidden text-white bg-dark rounded-5 shadow-lg"
                         style="background-image: url('/resources/img/Book.jpg');">
                        <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                            <h2 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold">참고한 서적</h2>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <h2 class="pb-2 mt-5 border-bottom">사용된 기술</h2>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 py-5">
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/springBoot.png">
                <div>
                    <h4 class="fw-bold">Spring Boot</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/springSecurity.png">
                <div>
                    <h4 class="fw-bold">Spring Security</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/mybatis.png">
                <div>
                    <h4 class="fw-bold">Mybatis</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/oracleDB.png">
                <div>
                    <h4 class="fw-bold">OracleDB</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/mariaDB.png">
                <div>
                    <h4 class="fw-bold">MariaDB</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/tomcat.png">
                <div>
                    <h4 class="fw-bold">Apache Tomcat</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/jsp.png">
                <div>
                    <h4 class="fw-bold">.JSP</h4>
                </div>
            </div>
            <div class="col d-flex align-items-center">
                <img class="icons" src="/resources/img/icons/bootstrap.png">
                <div>
                    <h4 class="fw-bold">Bootstrap</h4>
                </div>
            </div>
        </div>
    </div>
    <%--modal--%>

    <div class="modal fade" id="myModal"
         tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">환영합니다.</h4>
                </div>
                <div class="modal-body">처리가 완료되었습니다.</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="modalClose">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <script>
        $(document).ready(function () {
            //모달창 표현
            let result = '<c:out value="${result}"/>';
            let modifyResult = '<c:out value="${modifyResult}"/>';

            checkModal(result);
            checkModifyModal(modifyResult);

            history.replaceState({}, null, null);

            //모달창 표현 함수
            function checkModal(result) {
                if (result === '' || history.state) {
                    return;
                }
                if (result !== null) {
                    $(".modal-body").html(result + "님의 회원가입이 완료되었습니다. 로그인 후 이용하세요.");
                }
                $("#myModal").modal("show");
            }

            function checkModifyModal(modifyResult) {
                if (modifyResult === '' || history.state) {
                    return;
                }
                if (modifyResult !== null) {
                    $(".modal-body").html(modifyResult + "님의 정보수정이 완료되었습니다.");
                }
                $("#myModal").modal("show");
            }

            $("#modalClose").on("click", function () {
                $("#myModal").modal("hide");
            });
        });
    </script>
