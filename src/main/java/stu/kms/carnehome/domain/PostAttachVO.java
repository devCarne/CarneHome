package stu.kms.carnehome.domain;

import lombok.Data;

@Data
public class PostAttachVO {
    private String fileName;
    private String fileUrl;
    private boolean image;

    private Long postNo;
}
