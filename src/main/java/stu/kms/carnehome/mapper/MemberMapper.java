package stu.kms.carnehome.mapper;

import org.apache.ibatis.annotations.Mapper;
import stu.kms.carnehome.domain.AuthVO;
import stu.kms.carnehome.domain.MemberVO;

@Mapper
public interface MemberMapper {

    void signUp(MemberVO member);

    int signUpAuth(AuthVO auth);

    int modify(MemberVO member);

    void deleteAuth(String userid);

    MemberVO loadUser(String username);

    String pwCheck(String userid);
}
