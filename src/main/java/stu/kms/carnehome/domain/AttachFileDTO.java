package stu.kms.carnehome.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
    private String fileName;
    private String fileUrl;
    private boolean image;
}