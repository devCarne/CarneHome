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
            <h1 class="h2">게시판</h1>
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
                            <a class="move" href="<c:out value='${post.postNo}'/>">
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
                            value="${pageData.pageVO.searchType == 'T'?'selected':''}"/>>제목
                    </option>
                    <option value="C" <c:out
                            value="${pageData.pageVO.searchType == 'C'?'selected':''}"/>>내용
                    </option>
                    <option value="TC" <c:out
                            value="${pageData.pageVO.searchType == 'TC'?'selected':''}"/>>제목/내용
                    </option>
                    <option value="U" <c:out
                            value="${pageData.pageVO.searchType == 'U'?'selected':''}"/>>작성자
                    </option>
                </select>
            </div>

            <div class="col-6">
                <input class="form-control form-control-dark" type="text" name="keyword"
                       value="<c:out value='${pageData.pageVO.keyword}'/>" placeholder="Search"
                       aria-label="Search">
            </div>

            <div class="col-1">
                <input class="btn btn-secondary" type="submit" onclick="return submitCheck()"
                       value="검색">
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
                <c:if test="${pageData.prevPageList}">
                    <li class="page-item">
                        <a class="page-link" href="${pageData.startPage - 1}">이전</a>
                    </li>
                </c:if>

                <c:forEach var="page" begin="${pageData.startPage}" end="${pageData.endPage}">
                    <li class="page-item ${pageData.pageVO.pageNum == page ? 'active' : ''}">
                        <a class="page-link" href="${page}">${page}</a>
                    </li>
                </c:forEach>

                <c:if test="${pageData.nextPageList}">
                    <li class="page-item">
                        <a class="page-link" href="${pageData.endPage + 1}">다음</a>
                    </li>
                </c:if>
            </ul>
            <%--                    페이징 버튼 표시--%>
        </div>
    </div>

    <%--                PageVO 정보 전달 히든 폼--%>
    <form id="PageVOForm" action="/board/list" method="get">
        <input type="hidden" id="pageNum" name="pageNum" value="${pageData.pageVO.pageNum}">
        <input type="hidden" name="amountPerPage" value="${pageData.pageVO.amountPerPage}">
        <input type="hidden" name="searchType" value="${pageData.pageVO.searchType}">
        <input type="hidden" name="keyword" value="${pageData.pageVO.keyword}">
    </form>
    <%--검색창--%>
</body>

<script>
    $(document).ready(function () {

        $(".page-link").on("click", function (e) {
            e.preventDefault();
            e.stopPropagation(); //부모 DOM 으로의 이벤트 전파를 중단

            $("#pageNum").val($(this).attr('href'));
            $("#PageVOForm").submit();
        });
    });
</script>