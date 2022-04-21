package stu.kms.carnehome.controller;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import stu.kms.carnehome.domain.PageDTO;
import stu.kms.carnehome.domain.PageVO;
import stu.kms.carnehome.domain.ReplyVO;
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

        PageVO pageVO = new PageVO(replyPage, 20);
        pageVO.setOffset();
        PageDTO pageDTO = new PageDTO(pageVO, service.getReplyCount(postNo));

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("replyList", service.list(postNo, pageVO));
        resultMap.put("pageDTO", pageDTO);
        resultMap.put("userName", user.getMember().getUsername());

        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @PostMapping(value = "/writeAjax", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> writeAjax(@RequestBody ReplyVO reply) {
        log.info("reply.replyAjax() : " + reply);

        return service.write(reply)
                ? new ResponseEntity<>("댓글 등록에 성공했습니다.", HttpStatus.OK)
                : new ResponseEntity<>("댓글 등록에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PostMapping(value = "/modifyAjax", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> modifyAjax(@AuthenticationPrincipal CustomUser user, @RequestBody ReplyVO reply) {
        log.info("reply.modifyAjax() : " + user + ";" + reply);

        if (user.getMember().getUsername().equals(reply.getUserName())) {
            return service.modify(reply)
                    ? new ResponseEntity<>("댓글 수정에 성공했습니다.", HttpStatus.OK)
                    : new ResponseEntity<>("댓글 수정에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        } else {
            return new ResponseEntity<>("잘못된 접근입니다.", HttpStatus.FORBIDDEN);
        }
    }

    @PostMapping(value = "/deleteAjax", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> deleteAjax(@AuthenticationPrincipal CustomUser user, @RequestBody Long replyNo) {
        log.info("reply:deleteAjax() : " + replyNo);

        ReplyVO reply = service.getReply(replyNo);

        if (user.getMember().getUsername().equals(reply.getUserName())) {
            return service.delete(reply)
                    ? new ResponseEntity<>("댓글 삭제에 성공했습니다.", HttpStatus.OK)
                    : new ResponseEntity<>("댓글 삭제에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        } else {
            return new ResponseEntity<>("잘못된 접근입니다.", HttpStatus.FORBIDDEN);
        }
    }
}
