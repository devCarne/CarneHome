package stu.kms.carnehome.controller;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import stu.kms.carnehome.domain.PageDTO;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.service.PostService;

@Controller
@Slf4j
@RequestMapping("/board/*")
public class BoardController {

    @Setter(onMethod_ = @Autowired)
    private PostService service;

    @GetMapping("/list")
    public void list(PageVO pageVO, Model model) {
        model.addAttribute("postList", service.getList(pageVO));
        PageDTO dto = new PageDTO(pageVO, service.getPostCount());
        log.info(dto.toString());
        model.addAttribute("pageData", new PageDTO(pageVO, service.getPostCount()));
    }
}
