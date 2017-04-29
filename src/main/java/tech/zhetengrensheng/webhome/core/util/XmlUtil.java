package tech.zhetengrensheng.webhome.core.util;/**
 * Created by Long on 2017-04-29.
 */

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;

import java.io.File;

/**
 * 解析xml文件的工具类
 *
 * @author Long
 * @create 2017-04-29 14:09
 **/
public class XmlUtil {

    /**
     * 将一个xml文件转换成xml格式的字符串
     * @param xmlFileUrl
     * @return
     */
    public static String xml2String(String xmlFileUrl) throws DocumentException {

        SAXReader reader = new SAXReader();
        Document doc = reader.read(new File(xmlFileUrl));

        return doc.asXML();

    }

}
