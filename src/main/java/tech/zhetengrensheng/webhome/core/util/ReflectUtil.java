package tech.zhetengrensheng.webhome.core.util;

import java.lang.reflect.Field;

/**
 * Created by Long on 2017/4/9.
 * 反射工具类
 */
public class ReflectUtil {

    /**
     * 获取某个对象或其父类中指定名称的字段
     * @param fieldName
     * @param instance
     * @return
     */
    public static Field getField(String fieldName, Object instance) {

        Field field = null;

        for (Class<?> clazz = instance.getClass(); clazz != Object.class; clazz = clazz.getSuperclass()) {

            try {
                field = clazz.getDeclaredField(fieldName);
                break;
            } catch (NoSuchFieldException e) {
                // 不需要处理，如果出现异常，break无法执行，将从父类中查找，如果父类也没有则返回null
            }

        }

        return field;

    }

    /**
     * 获取指定对象中指定字段的值
     * @param fieldName
     * @param instance
     * @return
     */
    public static Object getFieldValue(String fieldName, Object instance) {

        Object value = null;

        Field field = getField(fieldName, instance);

        if (field != null) {
            try {
                field.setAccessible(true);
                value = field.get(instance);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        return value;

    }


    /**
     * 给字段赋值
     * @param fieldName
     * @param instance
     * @param value
     */
    public static void setFieldValue(String fieldName, Object instance, Object value) {

        Field field = getField(fieldName, instance);

        if (field != null) {
            try {
                field.setAccessible(true);
                field.set(instance, value);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

    }


}
