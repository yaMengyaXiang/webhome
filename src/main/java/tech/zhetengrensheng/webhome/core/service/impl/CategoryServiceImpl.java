package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.CategoryDao;
import tech.zhetengrensheng.webhome.core.entity.Category;
import tech.zhetengrensheng.webhome.core.service.CategoryService;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Long
 * @create 2017-04-29 22:18
 **/
@Service("categoryService")
public class CategoryServiceImpl implements CategoryService {

    @Resource
    private CategoryDao categoryDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Integer categoryId) {
        return categoryDao.deleteByPrimaryKey(categoryId);
    }

    @Override
    @Transactional
    public int insert(Category record) {
        return categoryDao.insert(record);
    }

    @Override
    public Category selectByPrimaryKey(Integer categoryId) {
        return categoryDao.selectByPrimaryKey(categoryId);
    }

    @Override
    public List<Category> selectAll() {
        return categoryDao.selectAll();
    }

    @Override
    @Transactional
    public int update(Category record) {
        return categoryDao.update(record);
    }
}
