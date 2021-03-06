package stu.kms.carnehome.service;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.PostAttachVO;
import stu.kms.carnehome.domain.PostVO;
import stu.kms.carnehome.mapper.AttachMapper;
import stu.kms.carnehome.mapper.PostMapper;

import java.util.List;

@Service
@Slf4j
public class PostServiceImpl implements PostService{

    @Setter(onMethod_ = @Autowired)
    private PostMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private AttachMapper attachMapper;

    @Override
    public List<PostVO> getList(PageVO pageVO) {
        return mapper.getList(pageVO);
    }

    @Override
    public List<PostVO> getHighlightList() {
        return mapper.getHighlightList();
    }

    @Override
    public Long getPostCount() {
        return mapper.getPostCount();
    }

    @Override
    public PostVO getPost(Long postNo) {
        PostVO post = mapper.getPost(postNo);
        post.setContent(post.getContent().replace("\n", "<br>"));

        return post;
    }

    @Override
    public PostVO getPost_modify(Long postNo) {
        return mapper.getPost(postNo);
    }

    @Override
    @Transactional
    public boolean modify(PostVO post) {
        attachMapper.deleteAll(post.getPostNo());

        if (post.getAttachList() == null || post.getAttachList().size() <= 0) {
            return mapper.modify(post) == 1;
        }

        for (PostAttachVO attach : post.getAttachList()) {
            attach.setPostNo(post.getPostNo());
            attachMapper.insert(attach);
        }

        return mapper.modify(post) == 1;
    }

    @Override
    @Transactional
    public boolean delete(Long postNo) {
        attachMapper.deleteAll(postNo);
        return mapper.delete(postNo) == 1;
    }

    @Override
    public List<PostAttachVO> getAttachList(Long postNo) {
        return attachMapper.getAttachList(postNo);
    }

    @Override
    @Transactional
    public void write(PostVO post) {
        if (mapper.getHighlightList().size() >= 5) {
            mapper.disableHighlight();
        }
        mapper.write(post);

        //??????????????? ????????? ????????? ??????
        if (post.getAttachList() == null || post.getAttachList().size() <= 0) {
            return;
        }

        //???????????? ????????? DB??? ??????
        for (PostAttachVO attach : post.getAttachList()) {
            attach.setPostNo(post.getPostNo());
            attachMapper.insert(attach);
        }
    }
}
