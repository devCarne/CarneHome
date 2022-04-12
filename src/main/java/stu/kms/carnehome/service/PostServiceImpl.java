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
    public Long getPostCount() {
        return mapper.getPostCount();
    }

    @Override
    public PostVO getPost(Long postNo) {
        return mapper.getPost(postNo);
    }

    @Override
    @Transactional
    public boolean modify(PostVO post) {
        attachMapper.deleteAll(post.getPostNo());

        boolean result = mapper.modify(post) == 1;

        log.info("attach : " + post.getAttachList());
        if (result && post.getAttachList() != null && post.getAttachList().size() > 0) {
            for (PostAttachVO attach : post.getAttachList()) {
                attach.setPostNo(post.getPostNo());
                attachMapper.insert(attach);
            }
        }
        return result;
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
        mapper.write(post);

        //첨부파일이 없으면 여기서 종료
        if (post.getAttachList() == null || post.getAttachList().size() <= 0) {
            return;
        }

        //첨부파일 목록을 DB에 저장
        for (PostAttachVO attach : post.getAttachList()) {
            attach.setPostNo(post.getPostNo());
            attachMapper.insert(attach);
        }
    }
}
