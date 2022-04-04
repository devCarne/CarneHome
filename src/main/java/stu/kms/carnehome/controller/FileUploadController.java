package stu.kms.carnehome.controller;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@Slf4j
public class FileUploadController {

    String uploadFolder = "C:\\upload\\carnehome\\";

    private String getFolderWithDate() {
        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy\\MM\\dd");

        String str = dateFormat.format(date);
        return str.replace("-", File.separator);
    }

    private boolean checkFileType(File file) {
        try {
            String fileType = Files.probeContentType(file.toPath());

            if (fileType == null) return false;

            return fileType.startsWith("image");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    @PostMapping(value = "/uploadAjax", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjax(MultipartFile[] files) {
        log.info("uploadAjax() : " + Arrays.toString(files));

        List<AttachFileDTO> attachFileList = new ArrayList<>();

        String subPath = getFolderWithDate();
        File uploadPath = new File(uploadFolder, subPath);
        if(!uploadPath.exists()) uploadPath.mkdirs();

        for (MultipartFile file : files) {
            AttachFileDTO attachFile = new AttachFileDTO();
            attachFile.setUploadPath(subPath);

            //Internet Explorer 구버전에서는 경로가 모두 출력되므로 경로를 잘라준다.
            String tempFileName = file.getOriginalFilename();
            String fileName = Objects.requireNonNull(tempFileName).substring(tempFileName.lastIndexOf("\\") + 1);
            attachFile.setFileName(fileName);

            UUID uuid = UUID.randomUUID();
            fileName = uuid + "_" + fileName;
            attachFile.setUuid(uuid.toString());

            try {
                File finalSaveFile = new File(uploadPath, fileName);
                file.transferTo(finalSaveFile);

                if (checkFileType(finalSaveFile)) {
                    attachFile.setImage(true);

                    //썸네일 생성
                    FileOutputStream fos = new FileOutputStream(new File(uploadPath, "s_" + fileName));
                    // 매개변수 : (InputStream, OutputStream, width, height)
                    Thumbnailator.createThumbnail(file.getInputStream(), fos, 100, 100);
                    fos.close();
                }

                attachFileList.add(attachFile);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return new ResponseEntity<>(attachFileList, HttpStatus.OK);
    }

    @GetMapping("/showImage")
    @ResponseBody
    public ResponseEntity<byte[]> showImage(String fileName) {
        log.info("showImage() : " + fileName);

        File file = new File(uploadFolder, fileName);
        ResponseEntity<byte[]> result = null;

        try {
            HttpHeaders header = new HttpHeaders();

            header.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
}
