package tech.zhetengrensheng.webhome.core.util;

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

    private static String dataDir;
    private static String targetDir;
    private static Integer userId;

    private static final String CATEGORY = "category";
    private static final String NODE = "node";
    private static final String LINK = "link";

    /**
     * category的id和index的映射表，一般在数据量大的时候用到，数据量小可能会浪费性能
     */
    private static Map<Integer, Integer> categoryIdIndexMap = new HashMap<Integer, Integer>();

    /**
     * node的id和index的映射表，一般在数据量大的时候用到，数据量小可能会浪费性能
     */
    private static Map<Integer, Integer> nodeIdIndexMap = new HashMap<Integer, Integer>();

    /**
     * 在使用该工具类之前必须先调用register(String dataDir, Integer userId)，
     * 注册好用户以及数据文件的路径
     * @param dataDir 数据文件路径
     * @param userId 用户id
     */
    public static void register(String dataDir, Integer userId) {
        ZheTengLinkUtil.dataDir = dataDir;
        ZheTengLinkUtil.userId = userId;
        targetDir = dataDir + userId + File.separator;
    }

    /**
     * 根据type选择获取相应的临时文件
     * @param type 类型，可选category，node，link
     * @return 返回临时文件
     */
    private static File getTargetTmpFile(String type) {
        String fileName = type + "_" + userId + ".tmp";

        File dir = new File(targetDir);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        return new File(targetDir, fileName);
    }

    /**
     * 从category的临时文件获取id为categoryId的项的索引
     * @param categoryId
     * @return
     * @throws Exception
     */
    private static int getCategoryIdIndex(Integer categoryId) throws Exception {

        File categoryFile = getTargetTmpFile(CATEGORY);

        return getTargetIdIndex(categoryId, categoryIdIndexMap, categoryFile);

    }

    /**
     * 从node的临时文件里获取id为nodeId的项的索引
     * @param nodeId
     * @return
     * @throws Exception
     */
    private static int getNodeIdIndex(Integer nodeId) throws Exception {

        File nodeFile = getTargetTmpFile(NODE);

        return getTargetIdIndex(nodeId, nodeIdIndexMap, nodeFile);

    }

    /**
     * 从targetIdIndexMap里找key为targetId的value，即索引，
     * 如果找不到，从targetTmpFile里面读取数据到targetIdIndexMap，
     * 再从targetIdIndexMap里找
     * @param targetId 要查找的id
     * @param targetIdIndexMap category或者node的id和index的映射表
     * @param targetTmpFile category或者node的临时数据文件
     * @return targetId的所在项的索引
     */
    private static int getTargetIdIndex(Integer targetId, Map<Integer, Integer> targetIdIndexMap, File targetTmpFile) {

        Integer i = targetIdIndexMap.get(targetId);
        if (i != null) {
            return i;
        }

        readIndexToMap(targetTmpFile, targetIdIndexMap);

        return targetIdIndexMap.get(targetId);
    }

    /**
     * 从指定的文件里读取所有项的id和index，并放入到映射表targetIdIndexMap中
     * @param file 该文件通常是tmp临时文件
     * @param targetIdIndexMap 某个id和index的映射表
     */
    public static void readIndexToMap(File file, Map<Integer, Integer> targetIdIndexMap) {

        try {
            String line;
            // 读取临时文件内容
            BufferedReader br = new BufferedReader(new FileReader(file));

            int i = 0;
            while ((line = br.readLine()) != null) {
                // "id":30,
                String str = "\"id\":";
                int idIndex = line.indexOf(str);
                int commaIndex = line.indexOf(",");
                String idTxt = line.substring(idIndex + str.length(), commaIndex).trim();
                int id = Integer.parseInt(idTxt);

                targetIdIndexMap.put(id, i++);

            }
            br.close();
        } catch (Exception e) {
            System.err.println("targetIdIndexMap size = " + targetIdIndexMap.size());
        }

    }

    /**
     * 往category的临时文件里写入该list里的category信息
     * @param categories 存放有category信息的list
     * @param clearToWrite 是否清空文件内容再写入
     * @throws Exception
     */
    public static void writeCategories(List<Category> categories, boolean clearToWrite) throws Exception {

        File file = getTargetTmpFile(CATEGORY);

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, !clearToWrite));

        if (categories != null && !categories.isEmpty()) {

            // 文件已经有内容，不清空文件内容
            if (!clearToWrite && file.length() != 0) {
                bw.write(",");
                bw.newLine();
            }

            for (int i = 0; i < categories.size(); i++) {
                Category category = categories.get(i);
                String name = category.getCategoryName();
                String color = category.getCategoryColor();
                Integer categoryId = category.getCategoryId();

                bw.append("{");
                bw.append("\"id\":").append(categoryId + "");
                bw.append(",");
                bw.append("\"name\":").append("\"").append(name).append("\"");
                bw.append(",");
                bw.append("\"itemStyle\":");
                bw.append("{");
                bw.append("\"normal\":");
                bw.append("{");
                bw.append("\"color\":").append("\"").append(color).append("\"");
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

    /**
     * 往node的临时文件写入list里的node数据
     * @param nodes 装有node数据的list
     * @param clearToWrite 是否清空临时文件的内容再写入
     * @throws Exception
     */
    public static void writeNodes(List<Node> nodes, boolean clearToWrite) throws Exception {

        File file = getTargetTmpFile(NODE);

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, !clearToWrite));

        if (nodes != null && !nodes.isEmpty()) {

            // 文件已经有内容，不清空文件内容
            if (!clearToWrite && file.length() != 0) {
                bw.write(",");
                bw.newLine();
            }

            for (int i = 0; i < nodes.size(); i++) {
                Node node = nodes.get(i);
                String name = node.getNodeName();
                String color = node.getNodeColor();
                Integer categoryId = node.getCategoryId();
                Integer nodeId = node.getNodeId();

                int index = getCategoryIdIndex(categoryId);

                bw.append("{");
                bw.append("\"id\":").append(nodeId + "");
                bw.append(",");
                bw.append("\"name\":").append("\"").append(name).append("\"");
                bw.append(",");
                bw.append("\"category\":").append(index + "");
                bw.append(",");
                bw.append("\"itemStyle\":");
                bw.append("{");
                bw.append("\"normal\":");
                bw.append("{");
                bw.append("\"color\":").append("\"").append(color).append("\"");
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

    /**
     * 往link的临时文件写入list里的link数据
     * @param links 装有link数据的list
     * @param clearToWrite 是否清空内容再写入
     * @throws Exception
     */
    public static void writeLinks(List<Link> links, boolean clearToWrite) throws Exception {

        File file = getTargetTmpFile(LINK);

        BufferedWriter bw = new BufferedWriter(new FileWriter(file, !clearToWrite));

        if (links != null && !links.isEmpty()) {

            // 文件已经有内容，不清空文件内容
            if (!clearToWrite && file.length() != 0) {
                bw.write(",");
                bw.newLine();
            }

            for (int i = 0; i < links.size(); i++) {
                Link link = links.get(i);
                Integer sourceNodeId = link.getSourceNodeId();
                Integer targetNodeId = link.getTargetNodeId();

                int sourceNodeIdIndex = getNodeIdIndex(sourceNodeId);
                int targetNodeIdIndex = getNodeIdIndex(targetNodeId);

                bw.append("{");
                bw.append("\"source\":").append(sourceNodeIdIndex + "");
                bw.append(",");
                bw.append("\"target\":").append(targetNodeIdIndex + "");
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

    /**
     * 将targetFile的内容写入到BufferedWriter对应的文件中
     * @param bw 在另一个方法实例化的BufferedWriter，对应一个写入的文件
     * @param targetFile 目标文件，将目标文件的内容写入到bw对应的写入文件中
     * @throws IOException
     */
    private static void writeFileContent(BufferedWriter bw, File targetFile) {
        try {
            String line;
            // 读取临时文件内容
            BufferedReader br = new BufferedReader(new FileReader(targetFile));

            while ((line = br.readLine()) != null) {
                bw.write(line);
                bw.newLine();
            }
            bw.flush();
            br.close();
        } catch (IOException e) {
            System.out.println("The tmp data file " + targetFile.getName() + " maybe not exist, but is OK!");
        }
    }

    /**
     * 将category、node、link临时文件的内容合并写入到一个json文件中
     * @return json文件的名称
     */
    public static String writeJson() {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
        String format = sdf.format(new Date());

        String jsonFileName = Constants.ZHE_TENG_LINK_FILE_PREFIX + format + "_" + userId + ".json";

        File category = getTargetTmpFile("category");
        File node = getTargetTmpFile("node");
        File link = getTargetTmpFile("link");

        File file = new File(targetDir, jsonFileName);

        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(file));

            bw.write("{");
            bw.write("\"type\": \"force\"");
            bw.write(",");
            bw.newLine();
            bw.write("\"categories\": ");
            bw.write("[");
            bw.newLine();

            // 写入category文件内容
            writeFileContent(bw, category);

            bw.write("]");

            bw.write(",");
            bw.newLine();
            bw.write("\"nodes\": ");
            bw.write("[");
            bw.newLine();

            // 写入node文件内容
            writeFileContent(bw, node);

            bw.write("]");

            bw.write(",");
            bw.newLine();
            bw.write("\"links\": ");
            bw.write("[");
            bw.newLine();

            // 写入link文件内容
            writeFileContent(bw, link);

            bw.write("]");

            bw.newLine();
            bw.write("}");
            bw.flush();
            bw.close();

        } catch (Exception e) {
            System.err.println("write json error!");
            jsonFileName = null;
        }

        return jsonFileName;

    }

}
