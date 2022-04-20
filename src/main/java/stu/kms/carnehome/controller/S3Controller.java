package stu.kms.carnehome.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;
import stu.kms.carnehome.service.S3Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class S3Controller {

    private final S3Service s3Service;

    @PostMapping(value = "/uploadAjax", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjax(MultipartFile[] files) {
        log.info("uploadAjax() : " + Arrays.toString(files));

        List<AttachFileDTO> attachFileList = new ArrayList<>();

        for (MultipartFile file : files) {
            AttachFileDTO attachFile = s3Service.upload(file);

            attachFileList.add(attachFile);
        }
        return new ResponseEntity<>(attachFileList, HttpStatus.OK);
    }

    @PostMapping("/deleteFileAjax")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<String> deleteFileAjax(String fileUrl) {
        log.info("deleteFileAjax() : " + fileUrl);

        s3Service.delete(fileUrl);

        return new ResponseEntity<>("파일 삭제 완료", HttpStatus.OK);
    }

    @GetMapping("/download")
    public ResponseEntity<ByteArrayResource> download(String fileUrl, String fileName) {
        byte[] fileData = s3Service.download(fileUrl);
        ByteArrayResource resource = new ByteArrayResource(fileData);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentLength(fileData.length);
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);

        ContentDisposition contentDisposition = ContentDisposition.builder("inline").filename(fileName).build();
        headers.setContentDisposition(contentDisposition);

        return ResponseEntity
                .ok()
                .headers(headers)
                .body(resource);
    }

}
