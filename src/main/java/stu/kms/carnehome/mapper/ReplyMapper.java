package stu.kms.carnehome.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;

import java.util.List;

@Mapper
public interface ReplyMapper {

    List<ReplyVO> list(Long postNo, PageVO pageVO);

    ReplyVO getReply(Long replyNo);

    Long getReplyCount(Long postNo);

    int write(ReplyVO reply);

    int modify(ReplyVO replyVO);

    int delete(Long replyNo);
}
