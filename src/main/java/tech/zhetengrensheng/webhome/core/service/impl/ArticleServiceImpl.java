package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.ArticleDao;
import tech.zhetengrensheng.webhome.core.entity.Article;
import tech.zhetengrensheng.webhome.core.service.ArticleService;
import tech.zhetengrensheng.webhome.core.util.Page;

import javax.annotation.Resource;
import java.util.List;

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
    public int deleteTags(Long[] articleIds) {
        return articleDao.deleteTags(articleIds);
    }

    @Override
    @Transactional
    public int insert(Article record) {
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
    public List<Article> selectAll(Page<Article> page) {
        return articleDao.selectAll(page);
    }

    @Override
    public List<Article> selectArticles(Page<Article> page) {
        return articleDao.selectArticles(page);
    }
}
