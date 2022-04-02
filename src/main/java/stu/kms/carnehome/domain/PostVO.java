package stu.kms.carnehome.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class PostVO {
    private Long postNo;
    private String title;
    private String content;
    private String userName;
    private Date postDate;
    private Date updateDate;

    private int replyCount;

    private List<PostAttachVO> attachList;
}
