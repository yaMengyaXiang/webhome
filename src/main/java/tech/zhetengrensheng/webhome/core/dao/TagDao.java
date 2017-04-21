package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Tag;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

public interface TagDao {

    /**
     * 通过主键删除
     * @param tagId
     * @return
     */
    int deleteByPrimaryKey(Integer tagId);

    /**
     * 通过主键删除一组记录
     * @param tagIds
     * @return
     */
    int deleteTags(Integer[] tagIds);

    /**
     * 插入一条记录
     * @param record
     * @return
     */
    int insert(Tag record);

    /**
     * 通过主键查找
     * @param tagId
     * @return
     */
    Tag selectByPrimaryKey(Integer tagId);

    /**
     * 更新
     * @param record
     * @return
     */
    int update(Tag record);

    /**
     * 查询所有的标签，带分页
     * @param page
     * @return
     */
    List<Tag> selectAll(Page<Tag> page);

    /**
     * 查询所有的标签，不带分页
     * @return
     */
    List<Tag> queryAll(Integer userId);

}