package stu.kms.carnehome.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stu.kms.carnehome.domain.AuthVO;
import stu.kms.carnehome.domain.MemberVO;
import stu.kms.carnehome.service.MemberService;

import java.awt.*;

@Controller
@Slf4j
@RequestMapping("/*")
public class HomeController {

    @Autowired
    private MemberService service;

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @GetMapping("/signUp")
    public void signUp() {
    }

    @PostMapping(value = "/idCheck")
    @ResponseBody
    public ResponseEntity<String> idCheck(String userid){
        log.info("userid : " + userid);
        return new ResponseEntity<>(service.idCheck(userid), HttpStatus.OK);
    }

    @PostMapping("/signUp")
    public String signUp(MemberVO member, AuthVO auth, RedirectAttributes redirectAttributes) {
        if (service.signUp(member, auth) == 1) {
            redirectAttributes.addFlashAttribute("result", member.getUsername());
        }
        return "redirect:/";
    }

    @GetMapping("/signIn")
    public void signIn() {

    }

    @GetMapping("/accessDenied")
    public void AccessDenied() {

    }
}