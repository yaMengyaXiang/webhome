package tech.zhetengrensheng.webhome.core.service;

import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

/**
 * Created by Long on 2017-04-21.
 */
public interface ArticleService {

    int deleteByPrimaryKey(Long articleId);

    int deleteArticles(Long[] articleIds);

    int insert(Article record);

    Article selectByPrimaryKey(Long articleId);

    int update(Article record);

    /**
     * 用户编辑，更新文章
     * @param record
     * @return
     */
    int userUpdateArticle(Article record);


    /**
     * 查询所有的文章，带分页
     * @param page
     * @return
     */
    List<Article> selectAll(Page<Article> page);

    /**
     * 查询用户所有的文章，不是全部的字段，带分页
     * @param userId
     * @param pageNo
     * @return
     */
    Page<Article> selectArticles(Integer userId, Integer pageNo);


}
