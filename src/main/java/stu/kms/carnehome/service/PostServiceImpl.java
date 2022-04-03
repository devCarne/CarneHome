package stu.kms.carnehome.service;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.PostVO;
import stu.kms.carnehome.mapper.PostMapper;

import java.util.List;

@Service
@Slf4j
public class PostServiceImpl implements PostService{

    @Setter(onMethod_ = @Autowired)
    private PostMapper mapper;

    @Override
    public List<PostVO> getList(PageVO pageVO) {
        return mapper.getList(pageVO);
    }

    @Override
    public Long getPostCount() {
        return mapper.getPostCount();
    }

    @Override
    public PostVO getPost(Long postNo) {
        return mapper.getPost(postNo);
    }
}
