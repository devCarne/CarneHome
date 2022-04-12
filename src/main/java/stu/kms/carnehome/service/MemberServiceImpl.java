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
        member.setUserpw(passwordEncoder.encode(member.getUserpw()));

        mapper.signUp(member);

        if (auth.getAuth().equals("SUPER")) {
            mapper.signUpAuth(auth);
        }

        auth.setAuth("NORMAL");
        return mapper.signUpAuth(auth);
    }

    @Override
    public boolean modify(MemberVO member, AuthVO auth) {
        member.setUserpw(passwordEncoder.encode(member.getUserpw()));

        mapper.modify(member);

        mapper.deleteAuth(member.getUserid());

        if (auth.getAuth().equals("SUPER")) {
            mapper.signUpAuth(auth);
        }

        auth.setAuth("NORMAL");
        return mapper.signUpAuth(auth) == 1;
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

    @Override
    public String pwCheck(String userid, String originalPw) {
        if (passwordEncoder.matches(originalPw, mapper.pwCheck(userid))) {
            return "ok";
        } else {
            return "no";
        }
    }


}