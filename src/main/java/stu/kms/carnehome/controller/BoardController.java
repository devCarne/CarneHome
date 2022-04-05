package stu.kms.carnehome.controller;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stu.kms.carnehome.domain.PageDTO;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.PostAttachVO;
import stu.kms.carnehome.domain.PostVO;
import stu.kms.carnehome.security.CustomUserDetailService;
import stu.kms.carnehome.security.domain.CustomUser;
import stu.kms.carnehome.service.PostService;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/board/*")
public class BoardController {

    @Setter(onMethod_ = @Autowired)
    private PostService service;

    @GetMapping("/list")
    public void list(PageVO pageVO, Model model) {
        log.info("list() : " + pageVO);
        model.addAttribute("postList", service.getList(pageVO));
        model.addAttribute("pageDTO", new PageDTO(pageVO, service.getPostCount()));
    }

    @GetMapping("/post")
    public void post(Long postNo, PageVO pageVO, Model model) {
        log.info("post() : " + postNo + ", " + pageVO);

        PostVO post = service.getPost(postNo);
        model.addAttribute("post", post);
    }

    @GetMapping("/modify")
    public void modify(Long postNo, PageVO pageVO, Model model) {
        log.info("modify() : " + postNo + ", " + pageVO);

        PostVO post = service.getPost(postNo);
        model.addAttribute("post", post);
    }

    @PostMapping("/modify")
    public String modify(@AuthenticationPrincipal CustomUser user, PostVO post, PageVO pageVO, RedirectAttributes redirectAttributes) {
        log.info("modify() : " + user + ";" + post + ";" + pageVO);

        if (user.getMember().getUsername().equals(post.getUserName())){
            if (service.modify(post)) {
                redirectAttributes.addFlashAttribute("result", "success");
            }
        } else {
            return "redirect:/accessDenied";
        }
        return "redirect:/board/list" + pageVO.getPageUrl();
    }

    @GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<PostAttachVO>> getAttachList(Long postNo) {
        log.info("getAttachList() : " + postNo);
        return new ResponseEntity<>(service.getAttachList(postNo), HttpStatus.OK);
    }


    @GetMapping("/write")
    @PreAuthorize("isAuthenticated()")
    public void write() {

    }

    @PostMapping("/write")
    @PreAuthorize("isAuthenticated()")
    public String register(PostVO post, RedirectAttributes redirectAttributes) {
        log.info("write() : " + post);
        service.write(post);

        redirectAttributes.addFlashAttribute("writeResult", post.getPostNo());
        return "redirect:/board/list";
    }
}