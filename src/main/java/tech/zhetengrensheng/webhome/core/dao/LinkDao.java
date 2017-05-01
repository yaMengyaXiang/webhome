package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Link;

import java.util.List;

public interface LinkDao {

    int deleteByPrimaryKey(Integer linkId);

    int deleteByNodeId(Integer nodeId);

    int insert(Link record);

    Link selectByPrimaryKey(Integer linkId);

    List<Link> selectByUserId(Integer userId);

    int update(Link record);

}