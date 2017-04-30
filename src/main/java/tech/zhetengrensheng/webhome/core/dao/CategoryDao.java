package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Category;

import java.util.List;

public interface CategoryDao {

    int deleteByPrimaryKey(Integer categoryId);

    int insert(Category record);

    Category selectByPrimaryKey(Integer categoryId);

    List<Category> selectAll();

    List<Category> selectByUserId(Integer userId);

    int update(Category record);

}