package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

public interface ArticleDao {

    int deleteByPrimaryKey(Long articleId);

    int insert(Article record);

    Article selectByPrimaryKey(Long articleId);

    int update(Article record);

    /**
     * 查询所有的文章，带分页
     * @param page
     * @return
     */
    List<Article> selectAll(Page<Article> page);

}