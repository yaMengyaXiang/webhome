package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.service.CommentService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;

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

}
