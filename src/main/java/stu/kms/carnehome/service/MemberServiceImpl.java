package stu.kms.carnehome.service;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import stu.kms.carnehome.domain.AuthVO;
import stu.kms.carnehome.domain.MemberVO;
import stu.kms.carnehome.mapper.MemberMapper;

@Service
@Slf4j
public class MemberServiceImpl implements MemberService{

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public int signUp(MemberVO member, AuthVO auth) {
        log.info("회원가입 : " + member + auth);

        member.setUserpw(passwordEncoder.encode(member.getUserpw()));

        mapper.signUp(member);

        if (auth.getAuth().equals("SUPER")) {
            log.info("우수회원");
            mapper.signUpAuth(auth);
        }

        auth.setAuth("NORMAL");
        return mapper.signUpAuth(auth);
    }

    @Override
    public String idCheck(String userid) {
        MemberVO member = mapper.loadUser(userid);
        if (member == null) {
            return "ok";
        } else {
            return "dup";
        }
    }
}