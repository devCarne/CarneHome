package stu.kms.carnehome.security.domain;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import stu.kms.carnehome.domain.MemberVO;

import java.util.Collection;
import java.util.stream.Collectors;

@Getter
public class CustomUser extends User {

    private MemberVO member;

    public CustomUser (String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }

    public CustomUser(MemberVO member) {
        super(member.getUserid(), member.getUserpw(),
                member.getAuthList().stream().map(authVO -> new SimpleGrantedAuthority(authVO.getAuth())).collect(Collectors.toList()));
        this.member = member;
    }
}
