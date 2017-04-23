package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.service.CommentService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Page;
import tech.zhetengrensheng.webhome.core.util.PageNumberGenerator;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Long on 2017-04-22.
 */
@Controller("commentController")
@RequestMapping("/comment")
public class CommentController {

    @Resource
    private CommentService commentService;

    @Resource
    private ArticleService articleService;

    @Resource
    private UserService userService;

    @RequestMapping("/publishComment.action")
    @ResponseBody
    public String publishComment(Comment comment, HttpServletRequest request) {

        JSONObject jo = new JSONObject();
        try {

            if (!StringUtils.isEmpty(comment) &&
                    !StringUtils.isEmpty(comment.getCommentContent())) {

                comment.setCommentDate(new Date());

                Article article = articleService.selectByPrimaryKey(comment.getArticleId());
                Integer replyHit = article.getReplyHit();
                article.setReplyHit(replyHit + 1);
                // 楼数 = 回复数 + 1，1楼显示文章内容
                comment.setCommentNum(replyHit + 1 + 1 + "");

                commentService.insert(comment);
                articleService.update(article);

                String targetUrl = request.getParameter("targetUrl");

                if (!StringUtils.isEmpty(targetUrl)) {
                    jo.put("success", targetUrl);
                    return jo.toString();
                }

                jo.put("success", "false");

//                return "redirect:/article/showArticleDetail.action?articleId=" + comment.getArticleId();
            }
        } catch (Exception e) {
            jo.put("success", "false");
        }

        return jo.toString();
    }


    @RequestMapping("/publishSubComment.action")
    @ResponseBody
    public String publishSubComment(Comment comment, HttpServletRequest request) {

        if (comment != null && comment.getCommentParentId() != null && comment.getArticleId() != null) {

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

            // 要经过视图渲染
            return "redirect:/comment/showComment.action?articleId=" + articleId + "&commentId=" + commentParentId;
        }

        return null;

    }


    @RequestMapping("/showComment.action")
    public String showComment(Comment comment, HttpServletRequest request) {

        Long articleId = comment.getArticleId();
        Long commentId = comment.getCommentId();

        Page<Comment> pageSubComments = new Page<Comment>(1);
        Map<String, Object> subConditions = new HashMap<String, Object>();

        subConditions.put("articleId", articleId);
        subConditions.put("commentParentId", commentId);

        pageSubComments.setConditions(subConditions);

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

        Comment cmt = commentService.selectByPrimaryKey(commentId);

        Integer count = commentService.selectSubCommentsCount(commentId);

        cmt.setSubCommentCount(count);

        cmt.setPageSubComments(pageSubComments);

        request.setAttribute("cmt", cmt);

        return "/comment/comment.jsp";
    }

}