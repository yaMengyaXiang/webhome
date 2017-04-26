package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.CommentDao;
import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.service.CommentService;
import tech.zhetengrensheng.webhome.core.util.Page;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Long on 2017-04-22.
 */
@Service("commentService")
public class CommentServiceImpl implements CommentService {

    @Resource
    private CommentDao commentDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Long commentId) {
        return commentDao.deleteByPrimaryKey(commentId);
    }

    @Override
    @Transactional
    public int deleteDirectComment(Long commentId) {
        return commentDao.deleteDirectComment(commentId);
    }

    @Override
    @Transactional
    public int insert(Comment record) {
        return commentDao.insert(record);
    }

    @Override
    @Transactional
    public int update(Comment record) {
        return commentDao.update(record);
    }

    @Override
    public Comment selectByPrimaryKey(Long commentId) {
        return commentDao.selectByPrimaryKey(commentId);
    }

    @Override
    public List<Comment> selectDirectComments(Page<Comment> page) {
        return commentDao.selectDirectComments(page);
    }

    @Override
    public List<Comment> selectSubComments(Page<Comment> page) {
        return commentDao.selectSubComments(page);
    }

    @Override
    public Integer selectSubCommentsCount(Long commentParentId) {
        return commentDao.selectSubCommentsCount(commentParentId);
    }

    @Override
    public String selectCommentNum(Long commentId) {
        return commentDao.selectCommentNum(commentId);
    }

    @Override
    public Integer selectDirectCommentsCount(Long articleId) {
        return commentDao.selectDirectCommentsCount(articleId);
    }
}
