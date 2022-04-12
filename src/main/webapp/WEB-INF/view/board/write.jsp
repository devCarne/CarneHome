<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<title>게시판</title>
<jsp:include page="../includes/header.jsp"/>


<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 border-bottom">
            <h2>글쓰기</h2>
        </div>
    </div>

    <form class="write-form" action="/board/write" method="post">
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
            <div class="col-sm-5">
                <input type="text" class="form-control" id="title" name="title" maxlength="100" required>
            </div>
        </div>

        <hr>
        <%--내용--%>
        <div class="row align-items-baseline">
            <label for="content" class="col-sm-1 form-label">내용</label>
            <div class="col-sm-11">
                <textarea class="form-control" id="content" name="content" rows="6" maxlength="2000"
                          style="resize: none" required></textarea>
            </div>
        </div>

        <%--글자 수 체크--%>
        <div class="row justify-content-end">
            <div class="col-1">
                <p class="textCount">0/2000자</p>
            </div>
        </div>

        <%--csrf--%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">


        <div class="row align-items-center justify-content-end">
            <%--파일 업로드--%>
            <div class="col-10">
                <input class="form-control" type="file" id="fileUpload" multiple>
            </div>

            <%--등록 버튼--%>
            <div class="col-2">
                <button type="submit" class="write-btn btn btn-primary">작성</button>
                <button class="list-btn btn btn-secondary">목록으로</button>

            </div>

        </div>

        <div class="row">
            <div class="col">
                <ul class="list-group uploadResult">

                </ul>
            </div>
        </div>

    </form>
</div>

<script>
    $(document).ready(function () {

        let content = $("#content")
        $(".textCount").text(content.val().length + "/2000자");

        //textbox 글자 수 체크
        content.keyup(function () {
            $(".textCount").text(content.val().length + "/2000자");
        });

        //파일 업로드
        const MAX_SIZE = 10 * 1024 * 1024;

        let csrfHeader = "${_csrf.headerName}";
        let csrfToken = "${_csrf.token}";

        let uploadUL = $(".uploadResult");

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

            let fileCallPath;
            let str = "";

            $(result).each(function (i, file) {
                if (file.image) {
                    fileCallPath = encodeURIComponent(file.uploadPath + "/s_" + file.uuid + "_" + file.fileName);

                    str +=
                        "<li class='nav align-items-center' data-path='" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.image + "'>" +
                        "   <div class='col-1'>" +
                        "       <img src='/showImage?fileName=" + fileCallPath + "'>" +
                        "   </div>" +
                        "   <div class='col-1'>" +
                        "       <button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>" +
                        "           <i class='fa fa-times'></i>" +
                        "       </button>" +
                        "   </div>" +
                        "   <div class='col-10'>" +
                        "       <span>" + file.fileName + "</span>" +
                        "   </div>" +
                        "</li>"
                } else {
                    fileCallPath = encodeURIComponent(file.uploadPath + "/" + file.uuid + "_" + file.fileName);
                    str +=
                        "<li class='nav  align-items-center' data-path='" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.image + "'>" +
                        "   <div class='col-1'>" +
                        "       <img src='/resources/img/attach.png' style='width: 100px'>" +
                        "   </div>" +
                        "   <div class='col-1'>" +
                        "       <button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>" +
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
            console.log(files);

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
                data: {fileName: $(this).data("file"), type: $(this).data("type")},
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

        //'작성' 버튼 동작 처리
        $(".write-btn").on("click", function (e) {
            e.preventDefault();

            let title = $("#title");
            let content = $("#content");

            if (title.val() === null || title.val().length === 0) {
                alert("제목을 입력해주세요.");
                title.focus();
                return;
            } else if (content.val() === null || content.val().length === 0) {
                alert("내용을 입력해주세요.");
                content.focus();
                return;
            }

            let str = "";
            $(".uploadResult li").each(function (i, file) {
                let targetFile = $(file);

                str +=
                    "<input type='hidden' name='attachList[" + i + "].fileName' value='" + targetFile.data("filename") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].uuid' value='" + targetFile.data("uuid") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + targetFile.data("path") + "'>" +
                    "<input type='hidden' name='attachList[" + i + "].fileType' value='" + targetFile.data("type") + "'>";
            });
            $(".write-form").append(str).submit();
        });

        //목록으로 버튼 동작 처리
        $(".list-btn").on("click", function (e) {
            e.preventDefault()
            if (confirm("작성한 내용을 잃게 됩니다. 계속하시겠습니까?") === true) {
                location.href = "/board/list";
            }
        });
    })
</script>