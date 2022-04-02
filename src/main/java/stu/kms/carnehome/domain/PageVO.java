package stu.kms.carnehome.domain;

import lombok.Data;
import org.springframework.web.util.UriComponentsBuilder;


@Data
public class PageVO {
    private int pageNum;
    private int amountPerPage;

    private String searchType;
    private String keyword;

    public PageVO(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amountPerPage = amount;
    }

    public PageVO() {
        this(1, 10);
    }

    public String getPageUrl() {
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("pageNum", this.pageNum)
                .queryParam("amountPerPage", this.amountPerPage)
                .queryParam("searchType", this.searchType)
                .queryParam("keyword", this.keyword);

        return builder.toUriString();
    }
}
