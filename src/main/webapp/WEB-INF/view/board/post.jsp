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

    .replyResult {
        padding-left: 0;
    }

    .replyResult li {
        list-style: none;
        margin-bottom: 20px;
        line-height: 100%;
    }

    .replyResult li i {
        margin-right: 10px;
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

    <hr class="mb40">

    <div class="row">
        <div class="col">
            <h4 class="mb40"><i class="fa fa-comment"></i> 댓글</h4>

            <ul class="replyResult">
                <li>
                    <h5 class="bg-light">
                        <i class="fa fa-user"></i>aaa
                        <button class="btn btn-sm btn-outline-secondary" type="button">수정</button>
                        <button class="btn btn-sm btn-outline-danger" type="button">삭제</button>
                        <p class="pull-right text-muted">001133</p>
                    </h5>
                    <p>댓글내용</p>
                </li>
            </ul>
        </div>
    </div>

    <div class="row">
        <div class="col reply-paging">

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
    $(document).ready(function () {
        getReplyList(1);
    });

    // 버튼 처리
    let multiForm = $(".multi-form")
    $(".modify-btn").on("click", function () {
        multiForm.attr("action", "/board/modify").submit();
    });

    $(".list-btn").on("click", function () {
        multiForm.find("#postNo").remove();
        multiForm.attr("action", "/board/list").submit();
    });
    // 버튼 처리





    // 첨부파일 처리
    let postNo = ${post.postNo};

    //첨부파일 목록 가져오기
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
    //첨부파일 처리





    //댓글 처리
    let replyUL = $(".replyResult");
    let replyPagingUL = $(".reply-paging");
    let replyPageNum = 1;

    let csrfHeaderName = "${_csrf.headerName}";
    let csrfTokenValue = "${_csrf.token}";

    $(document).ajaxSend(function (e, xhr) {
        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    });

    //댓글 목록 가져오기
    function getReplyList(replyPage) {
        $.getJSON("/reply/list/", {postNo: postNo, replyPage: replyPage}, function (resultMap) {

            let replyList = resultMap.replyList;
            let str = "";

            console.log(resultMap.userName);
            $(replyList).each(function (i, reply) {
                str +=
                    "<li data-replyNo='" + reply.replyNo + "'>" +
                    "   <h6 class='bg-light'>" +
                    "       <i class='fa fa-user'></i>" + reply.userName + "";

                if (resultMap.userName === reply.userName) {
                    str +=
                        "                   <button class='btn btn-sm btn-outline-secondary' type='button'>수정</button>" +
                        "                   <button class='btn btn-sm btn-outline-danger' type='button'>삭제</button>";
                }
                str +=
                    "       <p class='pull-right text-muted'>" + replyTimeFormat(reply.replyDate) + "</p>" +
                    "   </h6>" +
                    "   <p>" + reply.replyContent + "</p>" +
                    "</li>"
            });

            replyUL.html(str);
            createReplyPaging(resultMap.pageDTO)//페이징 화면도 함께 출력
        });
    }

    //댓글 시간 표시 함수
    function replyTimeFormat(replyDate) {
        let now = new Date();
        let written = new Date(replyDate);

        let gap = now.getTime() - written.getTime();

        let yy = written.getFullYear();
        let mm = written.getMonth() + 1;
        let dd = written.getDate();

        if (gap < (86400000)) {
            let hh = written.getHours();
            let mi = written.getMonth();
            let ss = written.getSeconds();

            return [yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd, ' ', (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ":", (ss > 9 ? '' : '0') + ss].join('');
        } else {
            return [yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
        }
    }

    //댓글 페이징 처리 함수
    function createReplyPaging(pageDTO) {
        let str = "<ul class='pagination justify-content-center'>";

        if (pageDTO.prevPageList) {
            str +=
                "<li class='page-item'>" +
                "   <a class='page-link' href='" + (pageDTO.startPage - 1) + "'>이전</a>" +
                "</li>"
        }

        for (let i = pageDTO.startPage; i <= pageDTO.endPage; i++) {
            let pageActive = replyPageNum === i ? "active" : "";

            str +=
                "<li class='page-item'" + pageActive + "'>" +
                "   <a class='page-link' href='" + i + "'>" + i + "</a>" +
                "</li>"
        }

        if (pageDTO.nextPageList) {
            str +=
                "<li class='page-item'>" +
                "   <a class='page-link' href='" + (pageDTO.endPage + 1) + "'>다음</a>" +
                "</li>"
        }

        str += "</ul></div>";
        replyPagingUL.html(str);
    }

    //댓글 페이징 버튼 처리
    replyPagingUL.on("click", "li a", function (e) {
        e.preventDefault();
        replyPageNum = $(this).attr("href");
        getReplyList(replyPageNum);
    });
    //댓글 처리
</script>