<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<title>접근거부</title>
<jsp:include page="../includes/header.jsp"/>

<h1>잘못된 접근입니다.</h1>
<button class="btn btn-primary btn-home" type="button" value="홈으로"></button>

<script>
    $(".btn-home").on("click", function () {
        location.href = "/";
    });
</script>