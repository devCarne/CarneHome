<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<title>게시판</title>
<jsp:include page="../includes/header.jsp"/>

<style>
    a {
        text-decoration: none;
        color: black;
    }

    a:visited {
        color: gray;
    }

    a:hover {
        font-weight: bold;
    }

    .table {
        table-layout: fixed;
    }

    .table td {
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
    }

    table th {
        text-align: center;
    }

    .table-center {
        text-align: center
    }


</style>

<body>

<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 border-bottom">
            <h2>게시판</h2>
        </div>
    </div>

    <%--게시물 표시--%>
    <div class="row">
        <div class="col table-responsive">
            <table class="table table-sm">
                <thead>
                <tr>
                    <th class="col-1">글번호</th>
                    <th class="col-4">제목</th>
                    <th class="col-1">작성자</th>
                    <th class="col-1">작성일</th>
                    <th class="col-1">수정일</th>
                </tr>
                </thead>
                <c:forEach items="${postList}" var="post">
                    <tr>
                            <%--                글번호--%>
                        <td class="table-center">
                                ${post.postNo}
                        </td>
                            <%--                제목--%>
                        <td>
                            <a class="post-link" href="<c:out value='${post.postNo}'/>">
                                <c:out value="${post.title}"/>
                                <b>
                                    [<c:out value="${post.replyCount}"/>]
                                </b>
                            </a>
                        </td>
                            <%--                작성자    --%>
                        <td>
                                ${post.userName}
                        </td>
                            <%--                작성일--%>
                        <td class="table-center">
                            <fmt:formatDate value="${post.postDate}" pattern="yyyy-MM-dd"/>
                        </td>
                            <%--                수정일--%>
                        <td class="table-center">
                            <fmt:formatDate value="${post.updateDate}" pattern="yyyy-MM-dd"/>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <%--게시물 표시--%>

    <%--검색창--%>
    <form id="searchForm" action="/board/list" method="get">
        <div class="row justify-content-center">
            <div class="col-2">
                <select class="form-select" name="searchType">
                    <option value="T" <c:out
                            value="${pageDTO.pageVO.searchType == 'T'?'selected':''}"/>>제목
                    </option>
                    <option value="C" <c:out
                            value="${pageDTO.pageVO.searchType == 'C'?'selected':''}"/>>내용
                    </option>
                    <option value="TC" <c:out
                            value="${pageDTO.pageVO.searchType == 'TC'?'selected':''}"/>>제목/내용
                    </option>
                    <option value="U" <c:out
                            value="${pageDTO.pageVO.searchType == 'U'?'selected':''}"/>>작성자
                    </option>
                </select>
            </div>

            <div class="col-6">
                <input class="form-control form-control-dark" type="text" name="keyword"
                       value="<c:out value='${pageDTO.pageVO.keyword}'/>" placeholder="Search"
                       aria-label="Search">
            </div>

            <div class="col-1">
                <input class="btn btn-secondary" type="submit" onclick="return submitCheck()"
                       value="검색">
            </div>

            <div class="col-1">
                <button class="write-btn btn btn-primary" type="button">글쓰기</button>
           </div>
        </div>
    </form>
    <%--검색창--%>

    <%--페이징--%>
    <div class="row">
        <div class="col">
            <%--페이징 버튼 표시--%>
            <%--a 하이퍼링크는 실제 동작하지 않고 JS에서 PageVOForm의 페이지를 자신이 가진 값으로 변경 시킨 후 동작하게 만든다.--%>
            <ul class="pagination justify-content-center">
                <c:if test="${pageDTO.prevPageList}">
                    <li class="page-item">
                        <a class="page-link" href="${pageDTO.startPage - 1}">이전</a>
                    </li>
                </c:if>

                <c:forEach var="page" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
                    <li class="page-item ${pageDTO.pageVO.pageNum == page ? 'active' : ''}">
                        <a class="page-link" href="${page}">${page}</a>
                    </li>
                </c:forEach>

                <c:if test="${pageDTO.nextPageList}">
                    <li class="page-item">
                        <a class="page-link" href="${pageDTO.endPage + 1}">다음</a>
                    </li>
                </c:if>
            </ul>
            <%--페이징 버튼 표시--%>
        </div>
    </div>

    <%--모달--%>
    <div class="modal" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="ModalLabel">처리 결과</h5>
                </div>

                <div class="modal-body">

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
                </div>

            </div>
        </div>
    </div>
    <%--모달--%>

    <%--PageVO 정보 전달 히든 폼--%>
    <form id="PageVOForm" action="/board/list" method="get">
        <input type="hidden" id="pageNum" name="pageNum" value="${pageDTO.pageVO.pageNum}">
        <input type="hidden" name="amountPerPage" value="${pageDTO.pageVO.amountPerPage}">
        <input type="hidden" name="searchType" value="${pageDTO.pageVO.searchType}">
        <input type="hidden" name="keyword" value="${pageDTO.pageVO.keyword}">
    </form>
    <%--PageVO 정보 전달 히든 폼--%>
</body>

<script>
    $(document).ready(function () {

        let pageVOForm = $("#PageVOForm");
        //게시물 조회 처리
        $(".post-link").on("click", function (e) {
            e.preventDefault();

            pageVOForm.append("<input type='hidden' name='postNo' value='" + $(this).attr('href') + "'/>");
            pageVOForm.attr("action", "/board/post");
            pageVOForm.submit();
        });

        // 글쓰기 버튼
        $(".write-btn").on("click", function (e) {
            self.location = "/board/write";
        });

        // 페이징 버튼 처리
        $(".page-link").on("click", function (e) {
            e.preventDefault();
            e.stopPropagation(); //부모 DOM 으로의 이벤트 전파를 중단

            $("#pageNum").val($(this).attr('href'));
            $("#PageVOForm").submit();
        });

        //모달
        function showModal(result) {
            if (result === '' || history.state) return;

            $(".modal-body").html(result);

            $("#resultModal").modal("show");
        }

        showModal("${result}");
        history.replaceState({}, null, null); //(stateObj, title, url) 뒤로가기시 반복 출력 막기
    });
</script>