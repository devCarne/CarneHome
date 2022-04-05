package stu.kms.carnehome.service;

import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.PostAttachVO;
import stu.kms.carnehome.domain.PostVO;

import java.util.List;

public interface PostService {

    List<PostVO> getList(PageVO pageVO);

    Long getPostCount();

    PostVO getPost(Long postNo);

    boolean modify(PostVO post);

    boolean delete(Long postNo);

    List<PostAttachVO> getAttachList(Long postNo);

    void write(PostVO post);
}
