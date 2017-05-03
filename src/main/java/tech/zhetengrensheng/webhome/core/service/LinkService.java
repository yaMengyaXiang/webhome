package tech.zhetengrensheng.webhome.core.service;/**
 * Created by Long on 2017-04-29.
 */

import tech.zhetengrensheng.webhome.core.entity.Link;

import java.util.List;
import java.util.Map;

/**
 * @author Long
 * @create 2017-04-29 22:12
 **/
public interface LinkService {

    int deleteByPrimaryKey(Integer linkId);

    int deleteByNodeId(Integer nodeId);

    int insert(Link record);

    Link selectByPrimaryKey(Integer linkId);

    List<Link> selectByUserId(Integer userId);

    List<Link> selectCheckForInsert(Map<String, Integer> map);

    int update(Link record);

}
