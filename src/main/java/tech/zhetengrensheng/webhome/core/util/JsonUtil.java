package tech.zhetengrensheng.webhome.core.util;/**
 * Created by Long on 2017-04-29.
 */

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Properties;

/**
 * json工具类
 *
 * @author Long
 * @create 2017-04-29 16:26
 **/
public class JsonUtil {

    /**
     * 从一个json文件里读取内容
     * @param file
     * @return
     */
    public static String readJson(File file) {

        StringBuilder jsonTxt = new StringBuilder();

        try {
            BufferedReader br = new BufferedReader(new FileReader(file));

            String line;

            while ((line = br.readLine()) != null) {
                jsonTxt.append(line);
                Properties prop = System.getProperties();
                String newLine = prop.getProperty("line.separator");
                jsonTxt.append(newLine);
            }

            br.close();

        } catch (Exception e) {
        }

        return jsonTxt.toString();
    }

}
