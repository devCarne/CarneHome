package stu.kms.carnehome.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
    private String fileName;
    private String uuid;
    private String uploadPath;
    private boolean image;
}