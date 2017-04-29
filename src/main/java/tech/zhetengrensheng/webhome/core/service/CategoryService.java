package tech.zhetengrensheng.webhome.core.service;/**
 * Created by Long on 2017-04-29.
 */

import tech.zhetengrensheng.webhome.core.entity.Category;

import java.util.List;

/**
 * @author Long
 * @create 2017-04-29 22:11
 **/
public interface CategoryService {

    int deleteByPrimaryKey(Integer categoryId);

    int insert(Category record);

    Category selectByPrimaryKey(Integer categoryId);

    List<Category> selectAll();

    int update(Category record);

}
