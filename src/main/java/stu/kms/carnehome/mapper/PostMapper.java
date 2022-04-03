package stu.kms.carnehome.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.PostVO;

import java.util.List;

@Mapper
public interface PostMapper {

    List<PostVO> getList(PageVO pageVO);

    Long getPostCount();

    PostVO getPost(Long postNo);
}
