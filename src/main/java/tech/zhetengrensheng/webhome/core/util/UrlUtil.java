package tech.zhetengrensheng.webhome.core.util;

import com.alibaba.fastjson.JSON;
import org.springframework.util.StringUtils;
import tech.zhetengrensheng.webhome.core.entity.User;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Long on 2017/3/26.
 */
public class UrlUtil {

    public static String getFromUri(HttpServletRequest request) {
        String referer = request.getHeader("referer");

        StringBuffer requestURL = request.getRequestURL();
        System.out.println(requestURL.toString());

        String fromUrl =
                referer == null ? request.getHeader("Referer") : referer;

        String fromUri = "";

        if (StringUtils.isEmpty(fromUrl)) {
            fromUri = "/";
        } else {

            String rootName = "webhome";

            int index = fromUrl.indexOf(rootName);


            String uri = fromUrl.substring(index + rootName.length());

            System.out.println(uri);

//            if ("".equals(uri) || "/".equals(uri)) {
//                uri = "index.jsp";
//            }
            if ("".equals(uri)) {
                uri = "/";
            }

            fromUri = uri;

        }

        return fromUri;
    }

    public static void main(String[] args) {
        String url = "http://localhost:8080/webhome/user/login.action";

        System.out.println(url.indexOf("webhome"));

        System.out.println(url.substring(url.indexOf("webhome")));

//        User user = new User();
//        user.setUsername("java");
//        user.setPassword("1234");
////        String jsonString = JSON.toJSONString(user);
//        String s = JSON.toJSONString(user);
//        System.out.println(s);
////        System.out.println(jsonString);
    }

}
