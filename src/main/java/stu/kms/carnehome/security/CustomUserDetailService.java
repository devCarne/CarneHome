package stu.kms.carnehome.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import stu.kms.carnehome.domain.MemberVO;
import stu.kms.carnehome.mapper.MemberMapper;
import stu.kms.carnehome.security.domain.CustomUser;

@Service
@Slf4j
public class CustomUserDetailService implements UserDetailsService {

    @Autowired
    private MemberMapper mapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("username으로 유저 불러오기 : " + username);

        MemberVO member = mapper.loadUser(username);
        return member == null ? null : new CustomUser(member);
    }
}
