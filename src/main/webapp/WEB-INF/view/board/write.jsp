<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<title>게시판</title>
<jsp:include page="../includes/header.jsp"/>

<style>
    li {
        margin: 0 20px;
    }
</style>
<div class="container">
    <div class="row">
        <div class="col py-3 mb-4 border-bottom">
            <h2>글쓰기</h2>
        </div>
    </div>

    <form class="write-form">
<%--        작성자--%>
        <div class="row align-items-baseline">
            <label for="username" class="col-sm-1 form-label">작성자</label>
            <div class="col-sm-11">
                <input type="text" readonly class="form-control-plaintext" id="username" value="<sec:authentication property="principal.username"/>"/>
            </div>
        </div>
<%--        제목--%>
        <div class="row align-items-baseline">
            <label for="title" class="col-sm-1 form-label">제목</label>
            <div class="col-sm-6">
                <input type="text" class="form-control" id="title" maxlength="100">
            </div>
        </div>

        <hr>
<%--        내용--%>
        <div class="row align-items-baseline">
            <label for="content" class="col-sm-1 form-label">내용</label>
            <div class="col-sm-11">
                <textarea class="form-control" id="content" rows="6" maxlength="2000" style="resize: none"></textarea>
            </div>
        </div>
<%--        글자 수 체크--%>
        <div class="row justify-content-end">
            <div class="col-1">
                <p class="textCount">0/2000자</p>
            </div>
        </div>
<%--        csrf--%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

        <div class="row align-items-center justify-content-end">
<%--            파일 업로드--%>
            <div class="col-11">
                <input class="form-control" type="file" id="fileUpload" multiple>
            </div>
<%--            등록 버튼--%>
            <div class="col-1">
                <button type="submit" class="btn btn-primary btn-lg">작성</button>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <ul class="nav align-items-center uploadResult">

                </ul>
            </div>
        </div>

    </form>
</div>

<script>
    $(document).ready(function () {

        //textbox 글자 수 체크
        $('#content').keyup(function () {
            let content = $(this).val();

            if (content.length === 0 || content === '') {
                $('.textCount').text('0자/2000자');
            } else {
                $('.textCount').text(content.length + '/2000자');
            }

            if (content.length > 2000) {
                $(this).val($(this).val().substring(0, 2000));
                alert('2000자까지 입력 가능합니다.');
            }
        });

        //파일 업로드
        const MAX_SIZE = 10 * 1024 * 1024;

        let csrfHeader = "${_csrf.headerName}";
        let csrfToken = "${_csrf.token}";

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
            if(!result || result.length === 0) return;

            let ul = $(".uploadResult");
            let fileCallPath;
            let str = "";

            $(result).each(function (i, file) {
                if (file.image) {
                    fileCallPath = encodeURIComponent(file.uploadPath + "/s_" + file.uuid + "_" + file.fileName);

                    str +=
                        "<li class='nav' data-path'" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.image + "'>" +
                        "   <div>" +
                        "       <img src='/showImage?fileName=" + fileCallPath + "'>" +
                        "       <button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>" +
                        "           <i class='fa fa-times'></i>" +
                        "       </button>" +
                        // "       <span>" + file.fileName + "</span>" +
                        "   </div>" +
                        "</li>"
                } else {
                    fileCallPath = encodeURIComponent(file.uploadPath + "/" + file.uuid + "_" + file.fileName);
                    str +=
                        "<li data-path'" + file.uploadPath + "' data-uuid='" + file.uuid + "' data-filename='" + file.fileName + "' data-type='" + file.image + "'>" +
                        "   <div>" +
                        "       <img src='/resources/img/attach.png' style='width: 100px'>" +
                        "       <button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>" +
                        "           <i class='fa fa-times'></i>" +
                        "       </button>" +
                        "       <span>" + file.fileName + "</span>" +
                        "   </div>" +
                        "</li>"
                }
            });
            ul.append(str)
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
    });
</script>