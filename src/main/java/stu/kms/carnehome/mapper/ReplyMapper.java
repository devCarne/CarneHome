package stu.kms.carnehome.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;

import java.util.List;

@Mapper
public interface ReplyMapper {

    List<ReplyVO> list(Long postNo, PageVO pageVO);

    Long getReplyCount(Long postNo);
}
