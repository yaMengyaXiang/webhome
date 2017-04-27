package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.ArticleDao;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.util.Page;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Long on 2017-04-21.
 */
@Service("articleService")
public class ArticleServiceImpl implements ArticleService {

    @Resource(name = "articleDao")
    private ArticleDao articleDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Long articleId) {
        return articleDao.deleteByPrimaryKey(articleId);
    }

    @Override
    @Transactional
    public int deleteArticles(Long[] articleIds) {
        return articleDao.deleteArticles(articleIds);
    }

    @Override
    @Transactional
    public int insert(Article record) {
        record.setPublishDate(new Date());
        record.setClickHit(0);
        record.setReplyHit(0);
        return articleDao.insert(record);
    }

    @Override
    public Article selectByPrimaryKey(Long articleId) {
        return articleDao.selectByPrimaryKey(articleId);
    }

    @Override
    @Transactional
    public int update(Article record) {
        return articleDao.update(record);
    }

    @Override
    @Transactional
    public int userUpdateArticle(Article record) {
        record.setEditDate(new Date());
        return articleDao.update(record);
    }

    @Override
    public List<Article> selectAll(Page<Article> page) {
        return articleDao.selectAll(page);
    }

    @Override
    public Page<Article> selectArticles(Integer userId, Integer pageNo) {

        Page<Article> pageArticles = new Page<Article>(pageNo);

        Map<String, Object> conditions = new HashMap<String, Object>(1);
        conditions.put("userId", userId);

        pageArticles.setConditions(conditions);

        List<Article> articles = articleDao.selectArticles(pageArticles);

        pageArticles.setResults(articles);

        return pageArticles;
    }
}
