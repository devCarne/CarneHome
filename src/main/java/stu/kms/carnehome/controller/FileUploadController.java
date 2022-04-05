package stu.kms.carnehome.controller;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

    @PostMapping("/deleteFileAjax")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<String> deleteFileAjax(String fileName, String type) {
        log.info("deleteFileAjax() : " + fileName + ";" + type);

        try {
            File file = new File(uploadFolder + URLDecoder.decode(fileName, StandardCharsets.UTF_8));
            file.delete();

            if (type.equals("image")) {
                file = new File(file.getAbsolutePath().replace("s_", ""));
                file.delete();
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>("파일 삭제 완료", HttpStatus.OK);
    }

    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, String fileName) {

        Resource resource = new FileSystemResource(uploadFolder + fileName);

        if (!resource.exists()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        String resourceFileName = resource.getFilename();
        String resourceOriginalFileName = Objects.requireNonNull(resourceFileName).substring(resourceFileName.indexOf("_") + 1);
        String downloadName;

        if (userAgent.contains("Trident") || userAgent.contains("MSIE")) {
            downloadName = URLEncoder.encode(resourceOriginalFileName, StandardCharsets.UTF_8).replaceAll("\\+", " ");
        } else if (userAgent.contains("Edge")) {
            downloadName = URLEncoder.encode(resourceOriginalFileName, StandardCharsets.UTF_8);
        } else {
            downloadName = new String(resourceOriginalFileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=" + downloadName);

        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
}
