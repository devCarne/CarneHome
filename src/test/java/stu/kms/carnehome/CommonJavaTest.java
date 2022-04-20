package stu.kms.carnehome;

import org.junit.jupiter.api.Test;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

public class CommonJavaTest {

    @Test
    public void substring() {
        String s = "https://carnehome-bucket.s3.ap-northeast-2.amazonaws.com/4a02135c-d70d-4f2b-8c81-8ab36ab45393_%EA%B0%95%EB%AF%BC%EC%84%9D-%ED%8C%8C%EC%9D%BC.jpg";
        s = URLDecoder.decode(s, StandardCharsets.UTF_8);
        System.out.println(s.substring(s.lastIndexOf("/") + 1));
    }
}
