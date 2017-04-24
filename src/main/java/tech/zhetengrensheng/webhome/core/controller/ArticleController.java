package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.entity.Tag;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.service.CommentService;
import tech.zhetengrensheng.webhome.core.service.TagService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Constants;
import tech.zhetengrensheng.webhome.core.util.Page;
import tech.zhetengrensheng.webhome.core.util.PageNumberGenerator;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Long on 2017-04-21.
 */
@Controller("articleController")
@RequestMapping("/article")
public class ArticleController {

    @Resource
    private ArticleService articleService;

    @Resource
    private TagService tagService;

    @Resource
    private UserService userService;

    @Resource
    private CommentService commentService;

    @RequestMapping("/getArticleById.action")
    public String getArticleById(Long articleId, HttpServletRequest request) {

        try {
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("currentLoginUser");

            Article article = articleService.selectByPrimaryKey(articleId);

            List<Tag> tags = tagService.queryAll(user.getUserId());

            request.setAttribute("article", article);
            request.setAttribute("tags", tags);

            return "user/backend/edit-article.jsp";

        } catch (Exception e) {
            // 未登录？
            return "forward:/login.jsp";
        }

    }

    @RequestMapping("/saveOrUpdateArticle.action")
    @ResponseBody
    public String saveOrUpdateArticle(Article article, HttpServletRequest request) {

        JSONObject jo = new JSONObject();

        HttpSession session = request.getSession(false);
        try {
            User user = (User) session.getAttribute("currentLoginUser");
            article.setUserId(user.getUserId());

            if (article != null && !StringUtils.isEmpty(article.getTitle())
                    && !StringUtils.isEmpty(article.getArticleContent())
                    && article.getTagId() != null) {

                try {
                    if (article.getArticleId() != null) {
                        // update
                        article.setEditDate(new Date());
                        articleService.update(article);
                    } else {
                        // save
                        article.setPublishDate(new Date());
                        article.setClickHit(0);
                        article.setReplyHit(0);
                        articleService.insert(article);
                    }

                    jo.put("success", "true");

                } catch (Exception e){
                    jo.put("success", "false");
                }

            } else {
                jo.put("success", "false");
            }
        } catch (Exception e) {
            // 未登录？
            jo.put("success", "false");
        }

        return jo.toString();
    }


    @RequestMapping("/deleteArticles.action")
    @ResponseBody
    public String deleteArticles(@RequestParam("ids[]") Long[] articleIds) {

        JSONObject jo = new JSONObject();

        if (articleIds != null && articleIds.length > 0) {
            try {
                articleService.deleteTags(articleIds);
                jo.put("success", "true");

            } catch (Exception e) {
                jo.put("success", "false");
            }

        } else {
            jo.put("success", "false");
        }

        return jo.toString();
    }


    @RequestMapping("/showArticleDetail.action")
    public String showArticleDetail(Long articleId, Integer pageNo, HttpServletRequest request) {

        if (pageNo == null || pageNo < 1) {
            pageNo = 1;
        }

        Article article = articleService.selectByPrimaryKey(articleId);
        article.setClickHit(article.getClickHit() + 1);
        articleService.update(article);

        Tag tag = tagService.selectByPrimaryKey(article.getTagId());

        String keyword = article.getKeyword();
        String keywords[] = null;
        if (!StringUtils.isEmpty(keyword)) {
            // 可能有多个空格
            keywords = keyword.split(" +");
        }

        User user = userService.selectByPrimaryKey(article.getUserId());

        // 查询这篇文章的所有评论
        Page<Comment> pageComments = new Page<Comment>(pageNo);
        Map<String, Object> conditions = new HashMap<String, Object>();

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

                Integer count = commentService.selectSubCommentsCount(cmt.getCommentId());
                cmt.setSubCommentCount(count);

                Page<Comment> pageSubComments = new Page<Comment>(1);
                Map<String, Object> subConditions = new HashMap<String, Object>();

                subConditions.put("articleId", articleId);
                subConditions.put("commentParentId", cmt.getCommentId());

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

                cmt.setPageSubComments(pageSubComments);

            }
        }

        pageComments.setResults(comments);

        List<Integer> pageNums = PageNumberGenerator.generator(pageComments.getCurrentPage(), pageComments.getTotalPageNum());


        request.setAttribute("keywords", keywords);
        request.setAttribute("article", article);
        request.setAttribute("tag", tag);
        request.setAttribute("articleUser", user);
        request.setAttribute("pageComments", pageComments);
        request.setAttribute("pageNums", pageNums);

        // TODO 页面需要静态化

        return "article/detail.jsp";

    }

}
