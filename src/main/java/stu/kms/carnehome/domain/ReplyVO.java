package stu.kms.carnehome.domain;

import lombok.Data;

import java.util.Date;

@Data
public class ReplyVO {
    private long replyNo;
    private long postNo;

    private String userName;
    private String replyContent;

    private Date replyDate;
    private Date updateDate;
}
