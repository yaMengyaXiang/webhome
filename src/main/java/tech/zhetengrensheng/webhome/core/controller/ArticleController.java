package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.ArticleService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by Long on 2017-04-21.
 */
@Controller("articleController")
@RequestMapping("/article")
public class ArticleController {

    @Resource
    private ArticleService articleService;

    @RequestMapping("/saveOrUpdateArticle.action")
    @ResponseBody
    public String saveOrUpdateArticle(Article article, HttpServletRequest request) {

        JSONObject jo = new JSONObject();

        HttpSession session = request.getSession(false);
        try {
            User user = (User) session.getAttribute("user");
            article.setUserId(user.getUserId());
        } catch (Exception e) {
            // 未登录？
            jo.put("success", "false");
            return jo.toString();
        }

        if (article != null && !StringUtils.isEmpty(article.getTitle())
                && !StringUtils.isEmpty(article.getArticleContent())
                && article.getTagId() != null) {

            try {
                if (article.getArticleId() != null) {
                    // update
                    articleService.update(article);
                    jo.put("success", "true");
                } else {
                    // save
                    articleService.insert(article);
                    jo.put("success", "true");
                }

            } catch (Exception e){
                jo.put("success", "false");
            }

        } else {
            jo.put("success", "false");
        }

        return jo.toString();
    }

}
