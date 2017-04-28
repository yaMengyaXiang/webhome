package tech.zhetengrensheng.webhome.core.facade;/**
 * Created by Long on 2017-04-27.
 */

import org.springframework.stereotype.Component;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.service.CommentService;
import tech.zhetengrensheng.webhome.core.service.TagService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Constants;
import tech.zhetengrensheng.webhome.core.util.Page;
import tech.zhetengrensheng.webhome.core.util.PageNumberGenerator;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文章行为的门面类，让service层稍微解耦
 *
 * @author Long
 * @create 2017-04-27 21:34
 **/
@Component(value = "userBehaviorFacade")
public class UserBehaviorFacade {

    @Resource
    private ArticleService articleService;

    @Resource
    private TagService tagService;

    @Resource
    private UserService userService;

    @Resource
    private CommentService commentService;

    /**
     * 用户点击文章，文章点击量+1
     * @param articleId
     * @return
     */
    public Article userClickArticle(Long articleId) {

        Article article = articleService.selectByPrimaryKey(articleId);
        article.setClickHit(article.getClickHit() + 1);
        articleService.update(article);

        return article;
    }

    /**
     * 查询谋篇文章的所有评论，包括楼中楼评论，并且把评论者的信息也查询出来，返回的Page对象还带有分页按钮
     * @param pageNo
     * @param articleId
     * @return
     */
    public Page<Comment> queryAllComments(Integer pageNo, Long articleId) {
        // 查询这篇文章的所有评论
        Page<Comment> pageComments = new Page<Comment>(pageNo);
        Map<String, Object> conditions = new HashMap<String, Object>(2);

        conditions.put("articleId", articleId);
        conditions.put("commentParentId", null);
        pageComments.setConditions(conditions);

        // 查找是对文章直接评论的回复，不是楼中楼回复
        List<Comment> comments = commentService.selectDirectComments(pageComments);

        // 查出来的评论只有userId，而没有user的其他信息
        if (comments != null && !comments.isEmpty()) {
            for (Comment cmt : comments) {
                User cmtUser = userService.selectByPrimaryKey(cmt.getUserId());
                cmt.setUser(cmtUser);

                // 楼中楼的回复，默认显示第一页
                Page<Comment> pageSubComments = querySubComments(cmt.getCommentId(), articleId, 1);

                cmt.setPageSubComments(pageSubComments);
                // 楼中楼回复的数量
                cmt.setSubCommentCount(pageSubComments.getTotalResults());

            }
        }

        pageComments.setResults(comments);

        List<Integer> pageNums = PageNumberGenerator.generator(pageComments.getCurrentPage(), pageComments.getTotalPageNum());

        pageComments.setPageNums(pageNums);

        return pageComments;
    }


    /**
     * 查看谋篇文章的某个回复的所有子回复，根据subPageNo来显示指定页数的子回复
     * @param commentId 楼层回复
     * @param articleId 文章id
     * @param subPageNo 第几页的子回复
     * @return
     */
    public Page<Comment> querySubComments(Long commentId, Long articleId, Integer subPageNo) {
        // 楼中楼的回复
        Page<Comment> pageSubComments = new Page<Comment>(subPageNo);
        Map<String, Object> subConditions = new HashMap<String, Object>(2);

        subConditions.put("articleId", articleId);
        subConditions.put("commentParentId", commentId);

        pageSubComments.setConditions(subConditions);
        pageSubComments.setPageSize(Constants.SUB_PAGE_SIZE);

        // 也是只有userId，没有user的其他信息，这是楼中楼的回复
        List<Comment> subComments = commentService.selectSubComments(pageSubComments);
        if (subComments != null && !subComments.isEmpty()) {
            for (Comment subCmt : subComments) {
                User subCmtUser = userService.selectByPrimaryKey(subCmt.getUserId());
                subCmt.setUser(subCmtUser);
            }
        }

        pageSubComments.setResults(subComments);

        List<Integer> subPageNums = PageNumberGenerator.generator(pageSubComments.getCurrentPage(), pageSubComments.getTotalPageNum());

        pageSubComments.setPageNums(subPageNums);


        return pageSubComments;
    }

    /**
     * 发表子回复（楼中楼回复），comment里面带有userId
     * @param comment
     */
    public void publishSubComment(Comment comment) {
        Long commentParentId = comment.getCommentParentId();

        // 这是几楼
        String commentNum = commentService.selectCommentNum(commentParentId);

        // 查询该楼层的回复数
        Integer count = commentService.selectSubCommentsCount(commentParentId);
        String newCmtNum = commentNum + "-" + (count + 1);

        comment.setCommentNum(newCmtNum);
        Date commentDate = new Date();
        comment.setCommentDate(commentDate);

        Long articleId = comment.getArticleId();

        Article article = articleService.selectByPrimaryKey(articleId);
        article.setReplyHit(article.getReplyHit() + 1);

        articleService.update(article);
        commentService.insert(comment);
    }

    /**
     * 发表直接回复，不是楼中楼回复
     * @param comment
     */
    public void publishDirectComment(Comment comment) {
        comment.setCommentDate(new Date());

        Long articleId = comment.getArticleId();

        Article article = articleService.selectByPrimaryKey(articleId);

        Integer replyHit = article.getReplyHit();
        // 总回复量+1
        article.setReplyHit(replyHit + 1);
        // 最大楼层数
        Integer maxFloorNum = article.getMaxFloorNum();
        // +1
        article.setMaxFloorNum(maxFloorNum + 1);
        // 楼数 = 最大回复楼层数 + 1
        comment.setCommentNum(maxFloorNum + 1 + "");

        commentService.insert(comment);
        articleService.update(article);
    }

}
