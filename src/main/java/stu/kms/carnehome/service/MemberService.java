package stu.kms.carnehome.service;

import stu.kms.carnehome.domain.AuthVO;
import stu.kms.carnehome.domain.MemberVO;

public interface MemberService {

    int signUp(MemberVO member, AuthVO auth);

    boolean modify(MemberVO member, AuthVO auth);

    String idCheck(String userid);

    String pwCheck(String userid, String originalPw);

}
