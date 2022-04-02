package stu.kms.carnehome.domain;

import lombok.Data;

@Data
public class PostAttachVO {
    private String uploadPath;
    private String uuid;
    private String fileName;
    private String fileType;

    private Long postNo;
}
