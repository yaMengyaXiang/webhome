package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Link;

import java.util.List;
import java.util.Map;

public interface LinkDao {

    int deleteByPrimaryKey(Integer linkId);

    /**
     * 删除node，级联删除link
     * @param nodeId
     * @return
     */
    int deleteByNodeId(Integer nodeId);

    int insert(Link record);

    Link selectByPrimaryKey(Integer linkId);

    List<Link> selectByUserId(Integer userId);

    List<Link> selectCheckForInsert(Map<String, Integer> map);

    int update(Link record);

}