<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

    .uploadResult li:hover {
        cursor: pointer;
    }
</style>

<sec:authentication property="principal" var="principal"/>

<div class="container">

    <%--본문--%>
    <div class="row" style="min-height: 400px">
        <div class="col py-3 mb-4 bg-light">

            <h2>${post.title}</h2>
            <ul class="post-meta list-inline">
                <li class="list-inline-item">
                    <i class="fa fa-user-circle-o"></i> <a href="#">${post.userName}</a>
                </li>
                <li class="list-inline-item">
                    <i class="fa fa-calendar-o"></i> <a href="#">작성일:<fmt:formatDate value="${post.postDate}"
                                                                                     pattern="yyyy-MM-dd"/></a>
                </li>
                <li class="list-inline-item">
                    <i class="fa fa-calendar"></i> <a href="#">최종 수정:<fmt:formatDate value="${post.updateDate}"
                                                                                     pattern="yyyy-MM-dd-hh:mm:ss"/></a>
                </li>
            </ul>
            <hr class="mb30">
            <p>${post.content}</p>

            <%--버튼 처리 히든 폼--%>
            <form class="multi-form" method="get">
                <input type="hidden" name="postNo" value="${post.postNo}">
                <input type="hidden" name="pageNum" value="<c:out value='${pageVO.pageNum}'/>">
                <input type="hidden" name="amountPerPage" value="<c:out value='${pageVO.amountPerPage}'/>">
                <input type="hidden" name="searchType" value="<c:out value='${pageVO.searchType}'/>">
                <input type="hidden" name="keyword" value="<c:out value='${pageVO.keyword}'/>">
            </form>
        </div>
    </div>
    <%--본문--%>

    <%--수정,삭제 버튼--%>
    <div class="row">
        <div class="col text-center">
            <sec:authorize access="isAuthenticated()">
                <c:if test="${principal.member.username eq post.userName}">
                    <button class="modify-btn btn btn-primary">수정</button>
                </c:if>
            </sec:authorize>
            <button class="list-btn btn btn-secondary">목록으로</button>
        </div>
    </div>
    <%--수정,삭제 버튼--%>

    <%--첨부 파일 목록--%>
    <div class="row">
        <div class="col">
            <ul class="list-group uploadResult">

            </ul>
        </div>
    </div>
    <%--첨부 파일 목록--%>


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

<script>
    //첨부파일 목록 가져오기
    let postNo = ${post.postNo};

    $.getJSON("/board/getAttachList", {postNo: postNo}, function (result) {
        let fileCallPath;
        let str = "";

        $(result).each(function (i, file) {
            if (file.fileType) {
                fileCallPath = encodeURIComponent(file.uploadPath + "/s_" + file.uuid + "_" + file.fileName);

                str +=
                    "<li class='nav align-items-center' data-path='" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.fileType + "'>" +
                    "   <div class='col-1'>" +
                    "       <img src='/showImage?fileName=" + fileCallPath + "'>" +
                    "   </div>" +
                    "   <div class='col-11'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            } else {
                fileCallPath = encodeURIComponent(file.uploadPath + "/" + file.uuid + "_" + file.fileName);
                str +=
                    "<li class='nav align-items-center' data-path='" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.fileType + "'>" +
                    "   <div class='col-1'>" +
                    "       <img src='/resources/img/attach.png' style='width: 100px'>" +
                    "   </div>" +
                    "   <div class='col-11'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            }
        });
        $(".uploadResult").append(str)
    });
    //첨부파일 목록 가져오기

    //첨부파일 다운로드/원본보기

    //다운로드
    $(".uploadResult").on("click", "li", function () {
        let li = $(this);

        let fileCallPath = encodeURIComponent(li.data("path") + "/" + li.data("uuid") + "_" + li.data("filename"));
        if (li.data("type")) {
            window.open("/showImage?fileName=" + fileCallPath.replace(new RegExp(/\\/g), "/"));
        } else {
            self.location = "/download?fileName=" + fileCallPath;
        }
    });
    //다운로드

    //버튼 동작
    $(document).ready(function () {

        let multiForm = $(".multi-form")

        $(".modify-btn").on("click", function () {
            multiForm.attr("action", "/board/modify").submit();
        });

        $(".list-btn").on("click", function () {
            multiForm.find("#postNo").remove();
            multiForm.attr("action", "/board/list").submit();
        });
    });

</script>