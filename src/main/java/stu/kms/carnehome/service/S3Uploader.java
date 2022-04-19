package stu.kms.carnehome.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class S3Uploader {

    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    public String bucket;

    public AttachFileDTO upload(MultipartFile file, String dir) throws IOException {
        File uploadFile = saveTempLocal(file)
                .orElseThrow(() -> new IllegalArgumentException("임시 파일 변환 실패"));

        AttachFileDTO attachFile = new AttachFileDTO();

        String fileName = uploadFile.getName();
        UUID uuid = UUID.randomUUID();
        String key = dir + "/" + uuid + fileName;

        String fileUrl = putS3(uploadFile, key);

        attachFile.setFileName(fileName);
        attachFile.setFileUrl(fileUrl);
        attachFile.setImage(checkFileType(uploadFile));

        removeTempLocal(uploadFile);

        return attachFile;
    }

    private String putS3(File uploadFile, String key) {
        amazonS3Client.putObject(
                new PutObjectRequest(bucket, key, uploadFile).withCannedAcl(CannedAccessControlList.PublicRead));

        return amazonS3Client.getUrl(bucket, key).toString();
    }

    private Optional<File> saveTempLocal(MultipartFile file) throws IOException {

        File convertFile = new File((System.getProperty("user.dir") + "/" + file.getOriginalFilename()));

        if (convertFile.createNewFile()) {
            try (FileOutputStream fos = new FileOutputStream(convertFile)) {
                fos.write(file.getBytes());
            }
            return Optional.of(convertFile);
        }
        return Optional.empty();
    }

    private void removeTempLocal(File file) {
        if (file.delete()) {
            return;
        }
        log.info("임시 파일 삭제 실패");
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
}
