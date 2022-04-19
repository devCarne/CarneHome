package stu.kms.carnehome.service;

import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;

import java.util.List;

public interface ReplyService {

    List<ReplyVO> list(Long postNo, PageVO pageVO);

    ReplyVO getReply(Long replyNo);

    Long getReplyCount(Long postNo);

    boolean write(ReplyVO reply);

    boolean modify(ReplyVO reply);

    boolean delete(ReplyVO reply);
}
