package stu.kms.carnehome.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.carnehome.domain.PostAttachVO;

import java.util.List;

@Mapper
public interface AttachMapper {

    void insert(PostAttachVO vo);

    void deleteAll(Long postNo);

    List<PostAttachVO> getAttachList(Long postNo);
}
