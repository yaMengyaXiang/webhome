package tech.zhetengrensheng.webhome.core.util;

import org.apache.commons.io.FilenameUtils;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.CropImageFilter;
import java.awt.image.FilteredImageSource;
import java.awt.image.ImageFilter;
import java.io.File;
import java.io.InputStream;

/**
 * 图片工具类
 *
 * @author Long
 * @create 2017-05-10 14:08
 **/
public class ImageUtil {

    /**
     * 图片裁剪
     * @param srcImage 源图片
     * @param x 到最左边的距离
     * @param y 到最上边的距离
     * @param w 宽
     * @param h 高
     * @param dest 裁剪后的图片存放的位置
     * @throws Exception
     */
    public static void cutImage(InputStream srcImage, int x, int y, int w, int h, File dest) throws Exception {

        BufferedImage bufferedImage = ImageIO.read(srcImage);

        Image scaledInstance = bufferedImage.getScaledInstance(
                bufferedImage.getWidth(), bufferedImage.getHeight(), Image.SCALE_DEFAULT);

        ImageFilter cropFilter = new CropImageFilter(x, y, w, h);
        Image img = Toolkit.getDefaultToolkit().createImage(
                new FilteredImageSource(scaledInstance.getSource(), cropFilter));

        // 目标图片
        BufferedImage target = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);

        Graphics graphics = target.getGraphics();
        // 画到目标图片中
        graphics.drawImage(img, 0, 0, null);
        graphics.dispose();

        String extension = FilenameUtils.getExtension(dest.getName());

        // 输出为文件
        ImageIO.write(target, extension, dest);

    }

}
