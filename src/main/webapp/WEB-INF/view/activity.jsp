<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<title>대외활동</title>
<jsp:include page="includes/header.jsp"/>

<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 border-bottom">
            <h2>대외활동</h2>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-10">
            <h3>카카오게임즈 토크쇼 유배자들의 수다</h3>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-6">
            <iframe width="100%" height="350px" src="https://www.youtube.com/embed/R2CeXvNcqg8" title="YouTube video player"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen></iframe>
        </div>

        <div class="col-6">
            <iframe width="100%" height="350px" src="https://www.youtube.com/embed/BioQ2qyW1qU" title="YouTube video player"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen></iframe>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-6">
            <div class="col-6 mb-3">
                <h3>생방송 채널</h3>
            </div>
        </div>

        <div class="col-6">
            <div class="col-6 mb-3">
                <h3>유튜브 채널</h3>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-center">
            <a href="https://www.twitch.tv/carnetv" target="_blank">
                <img src="<c:url value="/resources/img/twitch.png"/>" width="80%" >
            </a>
        </div>

        <div class="col-6 d-flex align-items-center justify-content-center">
            <a href="https://www.youtube.com/c/%EC%B9%B4%EB%A5%B4%EB%84%A4TV" target="_blank">
                <img src="<c:url value="/resources/img/youtube.png"/>" width="80%">
            </a>
        </div>
    </div>
</div>
