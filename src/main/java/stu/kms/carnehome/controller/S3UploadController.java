package stu.kms.carnehome.controller;

import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;
import stu.kms.carnehome.service.S3Uploader;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class S3UploadController {

    private final S3Uploader s3Uploader;

    @PostMapping(value = "/uploadAjax", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjax(MultipartFile[] files) throws IOException {
        log.info("uploadAjax() : " + Arrays.toString(files));

        List<AttachFileDTO> attachFileList = new ArrayList<>();

        for (MultipartFile file : files) {
            AttachFileDTO attachFile = s3Uploader.upload(file, "static");

            attachFileList.add(attachFile);
        }
        return new ResponseEntity<>(attachFileList, HttpStatus.OK);
    }
}
