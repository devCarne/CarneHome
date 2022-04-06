package stu.kms.carnehome.service;

import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;

import java.util.List;

public interface ReplyService {

    List<ReplyVO> list(Long postNo, PageVO pageVO);

    Long getReplyCount(Long postNo);
}
