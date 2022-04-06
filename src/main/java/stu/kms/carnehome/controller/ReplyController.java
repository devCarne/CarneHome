package stu.kms.carnehome.controller;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import stu.kms.carnehome.domain.PageDTO;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.security.domain.CustomUser;
import stu.kms.carnehome.service.ReplyService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/reply/*")
@Slf4j
public class ReplyController {

    @Setter(onMethod_ = @Autowired)
    private ReplyService service;

    @GetMapping(value = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map> list(@AuthenticationPrincipal CustomUser user, Long postNo, int replyPage) {
        log.info("reply.list() : " + postNo + ";" + replyPage);

        PageVO pageVO = new PageVO(replyPage, 50);
        PageDTO pageDTO = new PageDTO(pageVO, service.getReplyCount(postNo));

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("replyList", service.list(postNo, pageVO));
        resultMap.put("pageDTO", pageDTO);
        resultMap.put("userName", user.getMember().getUsername());

        log.info(String.valueOf(service.list(postNo, pageVO).size()));
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}
