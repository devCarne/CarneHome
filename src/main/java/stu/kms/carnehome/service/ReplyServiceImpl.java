package stu.kms.carnehome.service;

import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;
import stu.kms.carnehome.mapper.PostMapper;
import stu.kms.carnehome.mapper.ReplyMapper;

import java.util.List;

@Service
public class ReplyServiceImpl implements ReplyService{

    @Setter(onMethod_ = @Autowired)
    private ReplyMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private PostMapper postMapper;

    @Override
    public List<ReplyVO> list(Long postNo, PageVO pageVO) {
        return mapper.list(postNo, pageVO);
    }

    @Override
    public ReplyVO getReply(Long replyNo) {
        return mapper.getReply(replyNo);
    }

    @Override
    public Long getReplyCount(Long postNo) {
        return mapper.getReplyCount(postNo);
    }

    @Override
    public boolean write(ReplyVO reply) {
        postMapper.updateReplyCount(reply.getPostNo(), 1);

        return mapper.write(reply) == 1;
    }

    @Override
    public boolean modify(ReplyVO reply) {
        return mapper.modify(reply) == 1;
    }

    @Override
    public boolean delete(ReplyVO reply) {
        postMapper.updateReplyCount(reply.getPostNo(), -1);
        return mapper.delete(reply.getReplyNo()) == 1;
    }
}
