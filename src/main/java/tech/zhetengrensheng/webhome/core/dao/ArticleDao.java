package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

public interface ArticleDao {

    int deleteByPrimaryKey(Long articleId);

    int deleteArticles(Long[] articleIds);

    int insert(Article record);

    Article selectByPrimaryKey(Long articleId);

    int update(Article record);

    /**
     * 查询所有的文章，所有的字段
     * @param page
     * @return
     */
    List<Article> selectAll(Page<Article> page);

    /**
     * 查询所有的文章，不是全部的字段
     * @param page
     * @return
     */
    List<Article> selectArticles(Page<Article> page);

    /**
     * 获取其他用户的文章，带概要
     * @param page
     * @return
     */
    List<Article> selectOtherUserArticles(Page<Article> page);

}