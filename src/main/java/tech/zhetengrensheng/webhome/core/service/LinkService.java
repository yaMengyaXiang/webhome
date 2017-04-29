package tech.zhetengrensheng.webhome.core.service;/**
 * Created by Long on 2017-04-29.
 */

import tech.zhetengrensheng.webhome.core.entity.Link;

/**
 * @author Long
 * @create 2017-04-29 22:12
 **/
public interface LinkService {

    int deleteByPrimaryKey(Integer linkId);

    int insert(Link record);

    Link selectByPrimaryKey(Integer linkId);

    int update(Link record);

}
