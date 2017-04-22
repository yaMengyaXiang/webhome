package tech.zhetengrensheng.webhome.core.interceptor;

import org.apache.ibatis.executor.statement.RoutingStatementHandler;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.*;
import tech.zhetengrensheng.webhome.core.util.Page;
import tech.zhetengrensheng.webhome.core.util.ReflectUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.Properties;

/**
 * Created by Long on 2017/4/9.
 * Mybatis分页拦截器
 */
// 拦截StatementHandler接口的带这些参数的prepare方法，该方法声明如下：
// Statement prepare(Connection connection, Integer transactionTimeout) throws SQLException;
// 比较旧的版本好像只有一个Connection参数，新版本多了一个Integer类型的参数
@Intercepts({
//        @Signature(type = StatementHandler.class, method = "prepare", args = {Connection.class}),
        @Signature(type = StatementHandler.class, method = "prepare", args = {Connection.class, Integer.class})
})
public class PaginationInterceptor implements Interceptor {

    /**
     * 在Mybatis准备用sql语句生成Statement对象之前拦截，在此时修改sql语句来生成带分页的select语句
     * @param invocation
     * @return
     * @throws Throwable
     */
    @Override
    public Object intercept(Invocation invocation) throws Throwable {

        // 拦截的目标类是RoutingStatementHandler
        RoutingStatementHandler handler = (RoutingStatementHandler) invocation.getTarget();

        // 获取RoutingStatementHandler里面的最终成员变量StatementHandler
        StatementHandler statementHandler = (StatementHandler) ReflectUtil.getFieldValue("delegate", handler);

        // 获取mappedStatement
//        MappedStatement mappedStatement = (MappedStatement) ReflectUtil.getFieldValue("mappedStatement", statementHandler);

        // 获取BoundSql，它封装了原始的sql语句（xml文件里写的），传入的参数等
        BoundSql boundSql = statementHandler.getBoundSql();

        // xml文件里传入一条sql里的参数
        Object parameterObject = boundSql.getParameterObject();

        // 第一个参数Connection类型
        Connection connection = (Connection) invocation.getArgs()[0];

        // 在Mybatis生成Statement对象之前修改sql语句

        // 传入一个Page对象的参数，是要分页的select语句，如果不是select语句直接放行
        if (parameterObject instanceof Page<?>) {
            Page<?> page = (Page<?>) parameterObject;

            // 原始的sql语句
            String sql = boundSql.getSql();

            sql = appendConditions(sql, page);

            // 用于统计的sql
            String countSql = getCountSql(sql, page);
//
            System.out.println(countSql);

//            BoundSql newBoundSql = new BoundSql(
//                    mappedStatement.getConfiguration(), countSql, boundSql.getParameterMappings(), page);
//
//            ParameterHandler parameterHandler = new DefaultParameterHandler(mappedStatement, page, newBoundSql);

            // 生成preparedStatement
            PreparedStatement pstmt = connection.prepareStatement(countSql);

//            parameterHandler.setParameters(pstmt);

            // 执行统计的sql语句
            ResultSet resultSet = pstmt.executeQuery();

            if (resultSet.first()) {
                page.countOtherProperties(resultSet.getInt(1));
            }

            resultSet.close();
            pstmt.close();

            // 对原始的sql语句追加分页代码
            sql = appendPagination(sql, page);

            System.out.println(sql);

            ReflectUtil.setFieldValue("sql", boundSql, sql);

        }

        return invocation.proceed();
    }

    @Override
    public Object plugin(Object target) {
        // 拦截器对应的封装原始对象的方法
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {

    }


    /**
     * 获取用于统计的sql语句, page里带有查询条件
     * @param originSql
     * @param page
     * @return
     */
    private String getCountSql(String originSql, Page<?> page) {

        int fromIndex = -1;

        int index1 = originSql.indexOf("from");
        int index2 = originSql.indexOf("FROM");
        int index3 = originSql.indexOf("From");

        if (index1 > 0) {
            fromIndex = index1;
        }

        if (index2 > 0 && index2 < index1) {
            fromIndex = index2;
        }

        if (index3 > 0 && index3 < index1 && index3 < index2) {
            fromIndex = index3;
        }

        String sql = "select count(1) " + originSql.substring(fromIndex);

        return sql;

    }


    /**
     * 往原始sql语句追加分页代码
     * @param originSql
     * @param page
     * @return
     */
    private String appendPagination(String originSql, Page<?> page) {

        StringBuilder sb = new StringBuilder();

        int startIndex = page.getStartIndex();
        int pageSize = page.getPageSize();

        sb.append(originSql).append(" limit ").append(startIndex).append(", ").append(pageSize);

        return sb.toString();
    }

    /**
     * 从page里取出条件，追加到sql中
     * @param originSql
     * @param page
     * @return
     */
    private String appendConditions(String originSql, Page<?> page) {

        StringBuilder sb = new StringBuilder();
        sb.append(originSql);

        Map<String, Object> conditions = page.getConditions();

        if (conditions != null && !conditions.isEmpty()) {

            sb.append(" where 1=1 ");

            for (Map.Entry<String, Object> entry : conditions.entrySet()){

                Object value = entry.getValue();

                if (null == value) {
                    sb.append(" and ").append(entry.getKey()).append(" is ");
                    sb.append("null");
                } else {
                    sb.append(" and ").append(entry.getKey()).append(" = ");
                    if (value instanceof Number) {
                        sb.append(value);
                    } else {
                        sb.append("'").append(value).append("'");
                    }
                }

            }

        }

        return sb.toString();

    }

}
