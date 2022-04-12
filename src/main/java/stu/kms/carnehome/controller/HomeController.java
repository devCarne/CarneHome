package stu.kms.carnehome.controller;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stu.kms.carnehome.domain.AuthVO;
import stu.kms.carnehome.domain.MemberVO;
import stu.kms.carnehome.service.MemberService;

@Controller
@Slf4j
@RequestMapping("/*")
public class HomeController {

    @Setter(onMethod_ = @Autowired)
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
        log.info("idCheck() : " + userid);
        return new ResponseEntity<>(service.idCheck(userid), HttpStatus.OK);
    }

    @PostMapping("/signUp")
    public String signUp(MemberVO member, AuthVO auth, RedirectAttributes redirectAttributes) {
        log.info("signUp() : " + member + ";" + auth);
        if (service.signUp(member, auth) == 1) {
            redirectAttributes.addFlashAttribute("result", member.getUsername());
        }
        return "redirect:/";
    }

    @GetMapping("/signIn")
    public void signIn(
            @RequestParam(value = "error", required = false)String error,
            @RequestParam(value = "exception", required = false)String exception,
            Model model) {
        log.info("signIn() : " + error, exception);

        model.addAttribute("error", error);
        model.addAttribute("exception", exception);
    }

    @GetMapping("/accessDenied")
    public void AccessDenied() {

    }
}