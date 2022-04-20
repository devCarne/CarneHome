<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<title>게시판</title>
<jsp:include page="../includes/header.jsp"/>
<sec:authentication property="principal" var="principal"/>

<style>
    .thumbnail {
        width: 50px;
    }
</style>

<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 border-bottom">
            <h2>수정하기</h2>
        </div>
    </div>

    <form class="modify-form" action="/board/modify" method="post">

        <%--글번호--%>
        <div class="row align-items-baseline">
            <label for="postNo" class="col-sm-1 form-label">글번호</label>
            <div class="col-sm-11">
                <input type="text" readonly class="form-control-plaintext" id="postNo" name="postNo"
                       value="${post.postNo}"/>
            </div>
        </div>
        <%--작성자--%>
        <div class="row align-items-baseline">
            <label for="userName" class="col-sm-1 form-label">작성자</label>
            <div class="col-sm-11">
                <input type="text" readonly class="form-control-plaintext" id="userName" name="userName"
                       value="<sec:authentication property="principal.member.username"/>"/>
            </div>
        </div>

        <%--제목--%>
        <div class="row align-items-baseline">
            <label for="title" class="col-sm-1 form-label">제목</label>
            <div class="col-sm-6">
                <input type="text" class="form-control" id="title" name="title" value="${post.title}" maxlength="100">
            </div>
        </div>

        <hr>
        <%--내용--%>
        <div class="row align-items-baseline">
            <label for="content" class="col-sm-1 form-label">내용</label>
            <div class="col-sm-11">
                <textarea class="form-control" id="content" name="content" rows="6" maxlength="2000"
                          style="resize: none">${post.content}</textarea>
            </div>
        </div>

        <%--글자 수 체크--%>
        <div class="row justify-content-end">
            <div class="col-1">
                <p class="textCount">0/2000자</p>
            </div>
        </div>

        <%--파일 목록--%>
        <div class="row">
            <div class="col">
                <label for="attachFiles" class="col-sm-1 form-label">첨부파일 목록</label>
                <ul class="list-group attachFiles" id="attachFiles">

                </ul>
            </div>
        </div>
        <%--파일 목록--%>

        <%--파일 업로드 폼--%>
        <div class="row my-5">
            <div class="col">
                <input class="form-control" type="file" id="fileUpload" multiple>
            </div>
        </div>
        <%--파일 업로드 폼--%>

        <%--새로 업로드된 파일--%>
        <div class="row">
            <div class="col">
                <ul class="list-group uploadResult">

                </ul>
            </div>
        </div>
        <%--새로 업로드된 파일--%>

        <%--버튼--%>
        <div class="row">
            <div class="col text-center">
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${principal.member.username eq post.userName}">
                        <button type="submit" class="modify-btn btn btn-primary">수정</button>
                        <button class="delete-btn btn btn-danger">삭제</button>
                    </c:if>
                 </sec:authorize>
                <button type="submit" class="list-btn btn btn-secondary">목록으로</button>
            </div>
        </div>

        <%--버튼--%>

        <%--히든 폼--%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="pageNum" value="<c:out value='${pageVO.pageNum}'/>">
        <input type="hidden" name="amountPerPage" value="<c:out value='${pageVO.amountPerPage}'/>">
        <input type="hidden" name="searchType" value="<c:out value='${pageVO.searchType}'/>">
        <input type="hidden" name="keyword" value="<c:out value='${pageVO.keyword}'/>">
        <%--히든 폼--%>

    </form>
</div>

<script>
    $(document).ready(function () {

        let content = $("#content")
        let modifyForm = $(".modify-form");

        $(".textCount").text(content.val().length + "/2000자");

        //textbox 글자 수 체크
        content.keyup(function () {
            if (content.length === 0 || content === "") {
                $(".textCount").text("0자/2000자");
            } else {
                $(".textCount").text(content.val().length + "/2000자");
            }
        });

        //수정버튼
        $(".modify-btn").on("click", function (e) {
            e.preventDefault();

            let str = "";
            let fileIndex = 0;

            $(".attachFiles li").each(function (i, file){
                let targetFile = $(file);

                str +=
                    "<input type='hidden' name='attachList[" + i + "].fileName' value='" + targetFile.data("filename") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].fileUrl' value='" + targetFile.data("fileurl") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].image' value='" + targetFile.data("image") + "'>";
                fileIndex++;
            })

            $(".uploadResult li").each(function (i, file) {
                let targetFile = $(file);

                str +=
                    "<input type='hidden' name='attachList[" + (i + fileIndex) + "].fileName' value='" + targetFile.data("filename") + "'>" +
                    "<input type='hidden' name='attachList[" + (i + fileIndex) + "].fileUrl' value='" + targetFile.data("fileurl") + "'>" +
                    "<input type='hidden' name='attachList[" + (i + fileIndex) + "].image' value='" + targetFile.data("image") + "'>";
            });
            modifyForm.append(str).submit();
        });

        //삭제버튼
        $(".delete-btn").on("click", function (e) {
            e.preventDefault();
            if(confirm("정말로 삭제하시겠습니까?") === true) {
                modifyForm.attr("action", "/board/delete").submit();
            }
        });

        //목록버튼
        $(".list-btn").on("click", function () {
            let pageNumTag = $("input[name='pageNum']").clone();
            let amountTag = $("input[name='amountPerPage']").clone();
            let typeTag = $("input[name='searchType']").clone();
            let keywordTag = $("input[name='keyword']").clone();

            modifyForm.empty();
            modifyForm.append(pageNumTag);
            modifyForm.append(amountTag);
            modifyForm.append(typeTag);
            modifyForm.append(keywordTag);

            modifyForm.attr("action", "/board/list").attr("method", "get").submit();
        });
    });

    const MAX_SIZE = 10 * 1024 * 1024;

    let csrfHeader = "${_csrf.headerName}";
    let csrfToken = "${_csrf.token}";

    let postNo = ${post.postNo};
    let attachUL = $(".attachFiles");
    let uploadUL = $(".uploadResult");

    //첨부파일 목록 가져오기
    $.getJSON("/board/getAttachList", {postNo: postNo}, function (result) {
        let str = "";

        $(result).each(function (i, file) {
            if (file.image) {

                str +=
                    "<li class='nav align-items-center' data-fileurl='" + file.fileUrl + "' data-filename='" + file.fileName + "' data-image='" + file.image + "'>" +
                    "   <div class='col-1'>" +
                    "       <img class='thumbnail' src='" + file.fileUrl + "'>" +
                    "   </div>" +
                    "   <div class='col-1'>" +
                    "       <button type='button' class='btn btn-warning btn-circle'>" +
                    "           <i class='fa fa-times'></i>" +
                    "       </button>" +
                    "   </div>" +
                    "   <div class='col-11'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            } else {
                str +=
                    "<li class='nav align-items-center' data-fileurl='" + file.fileUrl + "' data-filename='" + file.fileName + "' data-image='" + file.image + "'>" +
                    "   <div class='col-1'>" +
                    "       <img class='thumbnail' src='/resources/img/attach.png'>" +
                    "   </div>" +
                    "   <div class='col-1'>" +
                    "       <button type='button' class='btn btn-warning btn-circle'>" +
                    "           <i class='fa fa-times'></i>" +
                    "       </button>" +
                    "   </div>" +
                    "   <div class='col-11'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            }
        });
        attachUL.append(str)
    });
    //첨부파일 목록 가져오기

    // X 클릭 시 화면에서만 삭제(뒤로가기 문제 등 해결)
    attachUL.on("click", "button", function () {
        if (confirm("파일을 삭제할까요?")) {
            $(this).closest("li").remove();
        }
    });
    // X 클릭 시 화면에서만 삭제(뒤로가기 문제 등 해결)

    //파일 업로드
    //파일 사이즈 체크
    function checkExtension(fileSize) {
        if (fileSize >= MAX_SIZE) {
            alert("10MB까지 업로드 가능합니다.");
            return false;
        }
        return true;
    }

    //업로드된 파일 출력
    function showUploadResult(result) {
        if (!result || result.length === 0) return;

        let str = "";

        $(result).each(function (i, file) {
            if (file.image) {
                str +=
                    "<li class='nav align-items-center' data-fileurl='" + file.fileUrl + "' data-filename='" + file.fileName + "' data-image='" + file.image + "'>" +
                    "   <div class='col-1'>" +
                    "       <img class='thumbnail' src='" + file.fileUrl + "'>" +
                    "   </div>" +
                    "   <div class='col-1'>" +
                    "       <button type='button' class='btn btn-warning btn-circle'>" +
                    "           <i class='fa fa-times'></i>" +
                    "       </button>" +
                    "   </div>" +
                    "   <div class='col-10'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            } else {
                str +=
                    "<li class='nav  align-items-center' data-fileurl='" + file.fileUrl + "' data-filename='" + file.fileName + "' data-image='" + file.image + "'>" +
                    "   <div class='col-1'>" +
                    "       <img class='thumbnail' src='/resources/img/attach.png'>" +
                    "   </div>" +
                    "   <div class='col-1'>" +
                    "       <button type='button' class='btn btn-warning btn-circle'>" +
                    "           <i class='fa fa-times'></i>" +
                    "       </button>" +
                    "   </div>" +
                    "   <div class='col-10'>" +
                    "       <span>" + file.fileName + "</span>" +
                    "   </div>" +
                    "</li>"
            }
        });
        uploadUL.append(str)
    }

    //파일 업로드 Ajax
    $("#fileUpload").change(function () {
        let uploadForm = new FormData;
        let files = $(this)[0].files;

        for (let i = 0; i < files.length; i++) {
            if (!checkExtension(files[i].size)) {
                return false;
            }
            uploadForm.append("files", files[i]);
        }

        $.ajax({
            url: "/uploadAjax",
            type: "POST",
            data: uploadForm,
            dataType: "json",
            processData: false,
            contentType: false,

            beforeSend: function (xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken)
            },

            success: function (result) {
                showUploadResult(result);
            }
        })
    });

    //파일 삭제 Ajax
    uploadUL.on("click", "button", function () {
        let targetLi = $(this).closest("li");

        $.ajax({
            url: "/deleteFileAjax",
            type: "POST",
            data: {fileUrl: targetLi.data("fileurl")},
            dataType: "text",

            beforeSend: function (xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },

            success: function (result) {
                alert(result);
                targetLi.remove();
            },
        })
    });
</script>