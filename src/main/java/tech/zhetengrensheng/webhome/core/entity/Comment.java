package tech.zhetengrensheng.webhome.core.entity;

import tech.zhetengrensheng.webhome.core.util.Page;

import java.io.Serializable;
import java.util.Date;

public class Comment implements Serializable {

    private Long commentId;

    private Date commentDate;

    private Integer userId;

    private Long articleId;

    private Long commentParentId;

    private String commentContent;

    private String commentNum;

    private User user;

    private Page<Comment> pageSubComments;  // 子回复，楼中楼回复，带分页

    public Page<Comment> getPageSubComments() {
        return pageSubComments;
    }

    public void setPageSubComments(Page<Comment> pageSubComments) {
        this.pageSubComments = pageSubComments;
    }

    public String getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(String commentNum) {
        this.commentNum = commentNum;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Long getCommentId() {
        return commentId;
    }

    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }

    public Date getCommentDate() {
        return commentDate;
    }

    public void setCommentDate(Date commentDate) {
        this.commentDate = commentDate;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Long getArticleId() {
        return articleId;
    }

    public void setArticleId(Long articleId) {
        this.articleId = articleId;
    }

    public Long getCommentParentId() {
        return commentParentId;
    }

    public void setCommentParentId(Long commentParentId) {
        this.commentParentId = commentParentId;
    }

    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent == null ? null : commentContent.trim();
    }
}