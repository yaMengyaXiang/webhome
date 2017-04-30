package tech.zhetengrensheng.webhome.core.util;

import com.alibaba.fastjson.JSONReader;
import tech.zhetengrensheng.webhome.core.entity.Category;
import tech.zhetengrensheng.webhome.core.entity.Link;
import tech.zhetengrensheng.webhome.core.entity.Node;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 有关折腾链的工具类
 *
 * @author Long
 * @create 2017-04-30 8:55
 **/
public class ZheTengLinkUtil {

    private static File getTargetFile(String directory, Integer userId, String name) {
        String targetDir = directory + userId + File.separator;

        String fileName = name + "_" + userId + ".tmp";

        File dir = new File(targetDir);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        File file = new File(targetDir, fileName);

        return file;
    }

    public static void writeCategories(String directory, Integer userId, List<Category> categories) throws Exception {

        File file = getTargetFile(directory, userId, "category");

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));

        // 文件已经有内容
        if (file.length() != 0) {
            bw.write(",");
            bw.newLine();
        }

        if (categories != null && !categories.isEmpty()) {

            for (int i = 0; i < categories.size(); i++) {
                Category category = categories.get(i);
                String name = category.getCategoryName();
                String color = category.getCategoryColor();
                Integer categoryId = category.getCategoryId();

                bw.append("{");
                bw.append("\"id\": ").append(categoryId + "");
                bw.append(",");
                bw.append("\"name\": ").append("\"").append(name).append("\"");
                bw.append(",");
                bw.append("\"itemStyle\": ");
                bw.append("{");
                bw.append("\"normal\": ");
                bw.append("{");
                bw.append("\"color\": ").append("\"").append(color).append("\"");
                bw.append("}");
                bw.append("}");
                bw.append("}");

                if (i != categories.size() - 1) {
                    bw.write(",");
                    bw.newLine();
                }

            }

        }

        bw.flush();
        bw.close();

    }

    private static int readJson(File file, Integer targetId) {

        int index = -1;
        try {
            JSONReader reader = new JSONReader(new FileReader(file));

            reader.startArray();

            int i = 0;
            while (reader.hasNext()) {

                reader.startObject();

                while (reader.hasNext()) {
                    String key = reader.readString();
                    String value = reader.readObject().toString();
                    if ("id".equals(key)) {
                        Integer id = Integer.parseInt(value);
                        if (id.intValue() == targetId.intValue()) {
                            index = i;
                        }
                    }
                }

                reader.endObject();

                i++;
            }

            reader.endArray();

        } catch (Exception e) {

        }

        return index;
    }

    private static int getCategoryIdIndex(String directory, Integer userId, Integer categoryId) throws Exception {

        int index;

        String targetDir = directory + userId + File.separator;

        String categoryFile = targetDir + "category_" + userId + ".tmp";
        String tmpFile = targetDir + "tmp_" + userId + ".tmp";

        File file = new File(tmpFile);

        BufferedWriter bw = new BufferedWriter(new FileWriter(file));
        bw.write("[");
        bw.newLine();
        writeFileContent(bw, new File(categoryFile));
        bw.newLine();
        bw.write("]");
        bw.flush();
        bw.close();

        index = readJson(file, categoryId);

        return index;

    }

    private static int getNodeIdIndex(String directory, Integer userId, Integer nodeId) throws Exception {

        int index;

        String targetDir = directory + userId + File.separator;

        String nodeFile = targetDir + "node_" + userId + ".tmp";
        String tmpFile = targetDir + "tmp_" + userId + ".tmp";

        File file = new File(tmpFile);

        BufferedWriter bw = new BufferedWriter(new FileWriter(file));
        bw.write("[");
        bw.newLine();
        writeFileContent(bw, new File(nodeFile));
        bw.newLine();
        bw.write("]");
        bw.flush();
        bw.close();

        index = readJson(file, nodeId);

        return index;

    }

    public static void writeNodes(String directory, Integer userId, List<Node> nodes) throws Exception {

        File file = getTargetFile(directory, userId, "node");

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));

        // 文件已经有内容
        if (file.length() != 0) {
            bw.write(",");
            bw.newLine();
        }

        if (nodes != null && !nodes.isEmpty()) {

            for (int i = 0; i < nodes.size(); i++) {
                Node node = nodes.get(i);
                String name = node.getNodeName();
                String color = node.getNodeColor();
                Integer categoryId = node.getCategoryId();
                Integer nodeId = node.getNodeId();

                int index = getCategoryIdIndex(directory, userId, categoryId);

                bw.append("{");
                bw.append("\"id\": ").append(nodeId + "");
                bw.append(",");
                bw.append("\"name\": ").append("\"").append(name).append("\"");
                bw.append(",");
                bw.append("\"category\": ").append(index + "");
                bw.append(",");
                bw.append("\"itemStyle\": ");
                bw.append("{");
                bw.append("\"normal\": ");
                bw.append("{");
                bw.append("\"color\": ").append("\"").append(color).append("\"");
                bw.append("}");
                bw.append("}");
                bw.append("}");

                if (i != nodes.size() - 1) {
                    bw.write(",");
                    bw.newLine();
                }

            }

        }

        bw.flush();
        bw.close();
    }

    public static void writeLinks(String directory, Integer userId, List<Link> links) throws Exception {

        File file = getTargetFile(directory, userId, "link");

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));

        // 文件已经有内容
        if (file.length() != 0) {
            bw.write(",");
            bw.newLine();
        }


        if (links != null && !links.isEmpty()) {

            for (int i = 0; i < links.size(); i++) {
                Link link = links.get(i);
                Integer sourceNodeId = link.getSourceNodeId();
                Integer targetNodeId = link.getTargetNodeId();

                int sourceNodeIdIndex = getNodeIdIndex(directory, userId, sourceNodeId);
                int targetNodeIdIndex = getNodeIdIndex(directory, userId, targetNodeId);

                bw.append("{");
                bw.append("\"source\": ").append(sourceNodeIdIndex + "");
                bw.append(",");
                bw.append("\"target\": ").append(targetNodeIdIndex + "");
                bw.append("}");

                if (i != links.size() - 1) {
                    bw.write(",");
                    bw.newLine();
                }
            }

        }

        bw.flush();
        bw.close();

    }

    public static void writeFileContent(BufferedWriter bw, File targetFile) throws IOException {
        String line;
        // 读取临时文件内容
        BufferedReader br = new BufferedReader(new FileReader(targetFile));

        while ((line = br.readLine()) != null) {
            bw.write(line);
        }
        bw.flush();
        br.close();
    }

    public static String writeJson(String directory, Integer userId) {
        String targetDir = directory + userId + File.separator;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
        String format = sdf.format(new Date());

        String jsonFileName = Constants.ZHE_TENG_LINK_FILE_PREFIX + format + "_" + userId + ".json";

        File category = getTargetFile(directory, userId, "category");
        File node = getTargetFile(directory, userId, "node");
        File link = getTargetFile(directory, userId, "link");

        File file = new File(targetDir, jsonFileName);

        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(file));

            bw.write("{");
            bw.write("\"type\": \"force\"");
            bw.write(",");
            bw.newLine();
            bw.write("\"categories\": ");
            bw.write("[");

            try {
                // 写入category文件内容
                writeFileContent(bw, category);

            } catch (IOException e) {
            }
            bw.write("]");

            bw.write(",");
            bw.newLine();
            bw.write("\"nodes\": ");
            bw.write("[");
            try {
                // 写入node文件内容
                writeFileContent(bw, node);

            } catch (IOException e) {
            }
            bw.write("]");

            bw.write(",");
            bw.newLine();
            bw.write("\"links\": ");
            bw.write("[");
            try {
                // 写入link文件内容
                writeFileContent(bw, link);

            } catch (IOException e) {
            }
            bw.write("]");

            bw.newLine();
            bw.write("}");
            bw.flush();
            bw.close();
        } catch (Exception e) {

        }

        return jsonFileName;

    }

}
