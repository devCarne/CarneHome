<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<title>게시판</title>
<jsp:include page="../includes/header.jsp"/>

<style>
    .entry-content .entry-title a {
        color: #333;
    }

    .entry-content .entry-title a:hover {
        color: #4782d3;
    }

    .post-meta li a {
        color: #999;
        font-size: 13px;
    }

    .post-meta li a:hover {
        color: #4782d3;
    }

    .post-meta li i {
        margin-right: 5px;
    }

    .post-meta li:last-child:after {
        display: none;
    }

    .share-buttons li {
        vertical-align: middle;
    }

    .mb40 {
        margin: 40px 0;
    }
    .media-body h5 a {
        color: #555;
    }

</style>

<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 bg-light">
            <h2>${post.title}</h2>
            <ul class="post-meta list-inline">
                <li class="list-inline-item">
                    <i class="fa fa-user-circle-o"></i> <a href="#">${post.userName}</a>
                </li>
                <li class="list-inline-item">
                    <i class="fa fa-calendar-o"></i> <a href="#">작성일:<fmt:formatDate value="${post.postDate}" pattern="yyyy-MM-dd"/></a>
                </li>
                <li class="list-inline-item">
                    <i class="fa fa-calendar"></i> <a href="#">최종 수정:<fmt:formatDate value="${post.updateDate}" pattern="yyyy-MM-dd-hh:mm:ss"/></a>
                </li>
            </ul>
            <hr class="mb30">
            <p>${post.content}</p>
        </div>
    </div>

    <div class="row">
        <div class="col">
            <hr class="mb40">
            <h4 class="mb40"><i class="fa fa-comment"></i> 댓글</h4>
            <h5 class="mt-0 font400 clearfix bg-light"><i class="fa fa-user"></i> aaa</h5>
            댓글내용
            <hr class="mb40">
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-10">
            <h4 class="mb40 text-uppercase font500">댓글 쓰기</h4>
            <form role="form">
                <div class="form-group">
                    <label>작성자</label>
                    <input type="text" class="form-control" placeholder="홍길동">
                </div>
                <div class="form-group">
                    <label>내용</label>
                    <textarea class="form-control" rows="5" placeholder="안녕하세요"></textarea>
                </div>
                <div class="clearfix float-right">
                    <button type="button" class="btn btn-primary btn-lg">등록</button>
                </div>
            </form>
        </div>
    </div>



                </div>
            <!-- post article-->
        </div>
    </div>
</div>