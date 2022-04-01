<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<jsp:include page="includes/header.jsp"/>
<h1>home</h1>

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
        checkModal(result);
        history.replaceState({},null,null);

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

        $("#modalClose").on("click", function () {
            $("#myModal").modal("hide");
        });
    });
</script>
</body>
</html>
