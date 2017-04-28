package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.facade.UserBehaviorFacade;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.service.CommentService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Constants;
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

    @Resource
    private UserBehaviorFacade userBehaviorFacade;

    @RequestMapping("/publishComment.action")
    @ResponseBody
    public String publishComment(Comment comment, HttpServletRequest request) {

        JSONObject jo = new JSONObject();

        String targetUrl = request.getParameter("targetUrl");

        try {

            if (!StringUtils.isEmpty(comment) &&
                    !StringUtils.isEmpty(comment.getCommentContent())) {

                if (!StringUtils.isEmpty(targetUrl)) {

                    userBehaviorFacade.publishDirectComment(comment);

                    jo.put("success", targetUrl);
                    return jo.toString();
                }

                jo.put("success", "false");

            }
        } catch (Exception e) {
            jo.put("success", "false");
        }

        return jo.toString();
    }


    @RequestMapping("/publishSubComment.action")
    public String publishSubComment(Comment comment) {

        if (comment != null && comment.getCommentParentId() != null && comment.getArticleId() != null) {

            userBehaviorFacade.publishSubComment(comment);

            // 要经过视图渲染
            return "forward:/comment/showComment.action?articleId=" + comment.getArticleId()
                    + "&commentId=" + comment.getCommentParentId();
        }

        return null;

    }


    @RequestMapping("/showComment.action")
    public String showComment(Long commentId, Long articleId, Integer subPageNo, HttpServletRequest request) {

        if (subPageNo == null || subPageNo < 1) {
            subPageNo = 1;
        }

        Page<Comment> pageSubComments = userBehaviorFacade.querySubComments(commentId, articleId, subPageNo);

        Comment cmt = commentService.selectByPrimaryKey(commentId);

        cmt.setPageSubComments(pageSubComments);
        cmt.setSubCommentCount(pageSubComments.getTotalResults());

        request.setAttribute("cmt", cmt);

        return "/comment/comment.jsp";
    }

    @RequestMapping("/deleteDirectComment.action")
    @ResponseBody
    public String deleteDirectComment(Long commentId) {

        JSONObject jo = new JSONObject();
        jo.put("success", "false");

        if (commentId != null) {
            try {
                // 会把子回复也一并删除
                commentService.deleteDirectComment(commentId);

                jo.put("success", "true");

            } catch (Exception e) {
                jo.put("success", "false");
            }

        }

        return jo.toString();
    }

}
