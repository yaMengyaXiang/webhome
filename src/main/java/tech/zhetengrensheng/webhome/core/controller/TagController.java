package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.Tag;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.TagService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created by Long on 2017/4/9.
 */
@Controller("tagController")
@RequestMapping("/tag")
public class TagController {

    @Resource
    private TagService tagService;

    @RequestMapping("/getAllTags.action")
    public String getAllTags() {

        return "";
    }


    @RequestMapping("/addOrEditTag.action")
    @ResponseBody
    public String addOrEditTag(Tag tag, HttpServletRequest request) {

        JSONObject jo = new JSONObject();

        HttpSession session = request.getSession(false);
        try {
            User user = (User) session.getAttribute("user");
            tag.setUserId(user.getUserId());
        } catch (Exception e) {
            // 未登录？
            jo.put("success", "false");
            return jo.toString();
        }

        if (tag != null && !StringUtils.isEmpty(tag.getTagName())) {

            try {
                if (tag.getTagId() != null) {
                    // update
                    tagService.update(tag);
                    jo.put("success", "true");
                } else {
                    // save
                    tagService.insert(tag);
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

    @RequestMapping("/deleteTag.action")
    public String deleteTag(Integer tagId, HttpServletResponse response) {

        if (tagId != null) {
            try {
                tagService.deleteByPrimaryKey(tagId);
            } catch (Exception e) {
                try {
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().write("<script type='text/javascript'> alert('删除失败 !'); </script>");
                    return null;
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }

            return "redirect:/user/toMyTags.action";
        }

        return null;

    }


    @RequestMapping("/deleteTags.action")
    @ResponseBody
    public String deleteTags(@RequestParam(value = "ids[]") Integer[] tagIds) {

        JSONObject jo = new JSONObject();

        if (tagIds != null && tagIds.length > 0) {
            try {
                tagService.deleteTags(tagIds);
                jo.put("success", "true");
            } catch (Exception e) {
                jo.put("success", "false");
            }

        } else {
            jo.put("success", "false");
        }

        return jo.toString();
    }

}
