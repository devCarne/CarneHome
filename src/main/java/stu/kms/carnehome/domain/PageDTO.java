package stu.kms.carnehome.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private int startPage;
    private int endPage;
    private boolean prevPageList;
    private boolean nextPageList;

    private long totalObjAmount;

    private PageVO pageVO;

    public PageDTO(PageVO pageVO, long totalObjAmount) {
        this.pageVO = pageVO;
        this.totalObjAmount = totalObjAmount;

        this.endPage = (int) (Math.ceil(pageVO.getPageNum() / 10.0)) * 10; // 현재 페이지가 26이면 (3) * 10 = 30이 끝 페이지
        this.startPage = endPage - 9;

        int lastPage = (int) (Math.ceil((totalObjAmount * 1.0) / pageVO.getAmountPerPage())); // 글 갯수가 355개, 페이지당 10개면 마지막 페이지는 36

        if (lastPage < this.endPage) {
            this.endPage = lastPage;
        }

        this.prevPageList = this.startPage > 1;
        this.nextPageList = this.endPage < lastPage;
    }
}
