package stu.kms.carnehome.service;

import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;
import stu.kms.carnehome.mapper.ReplyMapper;

import java.util.List;

@Service
public class ReplyServiceImpl implements ReplyService{

    @Setter(onMethod_ = @Autowired)
    private ReplyMapper mapper;

    @Override
    public List<ReplyVO> list(Long postNo, PageVO pageVO) {
        return mapper.list(postNo, pageVO);
    }

    @Override
    public Long getReplyCount(Long postNo) {
        return mapper.getReplyCount(postNo);
    }
}
