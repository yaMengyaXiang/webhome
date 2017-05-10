package tech.zhetengrensheng.webhome.core.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Created by Long on 2017/4/10.
 */
public class EntityUtil {

    /**
     * 将属性名转换成数据库表中的字段名，重新构造一个Map返回
     * @param conditions key -- 属性名，value -- 属性值
     */
    public static Map<String, Object> proertyChangeToColumn(Map<String, Object> conditions) {

        Map<String, Object> fieldCondition = new HashMap<String, Object>(conditions.size());

        if (conditions != null && !conditions.isEmpty()) {
            for (Map.Entry entry : conditions.entrySet()) {

                String key = camelToLine((String) entry.getKey());
                Object value = entry.getValue();

                fieldCondition.put(key, value);

            }
        }

        return fieldCondition;
    }

    private static void iterate(Map<String, Object> conditions) {
        if (conditions != null && !conditions.isEmpty()) {
            Set<Map.Entry<String, Object>> entries = conditions.entrySet();
            for (Map.Entry entry : entries) {
                System.out.println(entry.getKey() + " -- " + entry.getValue());

            }
        }
    }

    private static String camelToLine(String property) {
        return property.replaceAll("[A-Z]", "_$0").toLowerCase();
    }

    public static void main(String[] args) {
        Map<String, Object> conditions = new HashMap<String, Object>();
        conditions.put("tagId", 1);
        conditions.put("tagName", "long");

        conditions = proertyChangeToColumn(conditions);

//        System.out.println(camelToLine("tagName"));
    }

}
