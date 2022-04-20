package stu.kms.carnehome.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.*;
import com.amazonaws.util.IOUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import stu.kms.carnehome.domain.AttachFileDTO;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class S3Service {

    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    public AttachFileDTO upload(MultipartFile multipartFile) {

        String fileName = multipartFile.getOriginalFilename();
        UUID uuid = UUID.randomUUID();
        String contentType = multipartFile.getContentType();

        String key = uuid + "_" + fileName;

        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(contentType);


        try (InputStream inputStream = multipartFile.getInputStream()) {
            amazonS3Client.putObject(new PutObjectRequest(bucketName, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
        } catch (IOException e) {
            e.printStackTrace();
        }

        AttachFileDTO attachFile = new AttachFileDTO();
        attachFile.setFileName(fileName);
        attachFile.setFileUrl(amazonS3Client.getUrl(bucketName, key).toString());
        attachFile.setImage(isImage(contentType));

        return attachFile;
    }

    public void delete(String fileUrl) {
        fileUrl = URLDecoder.decode(fileUrl, StandardCharsets.UTF_8);
        String key = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
        amazonS3Client.deleteObject(bucketName, key);
    }

    public byte[] download(String fileUrl) {
        fileUrl = URLDecoder.decode(fileUrl, StandardCharsets.UTF_8);
        String key = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

        log.info(key);
        S3Object s3Object = amazonS3Client.getObject(bucketName, key);
        S3ObjectInputStream inputStream = s3Object.getObjectContent();

        try {
            return IOUtils.toByteArray(inputStream);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private boolean isImage(String contentType) {
        if (contentType == null) {
            return false;
        }
        return contentType.startsWith("image");
    }
}
