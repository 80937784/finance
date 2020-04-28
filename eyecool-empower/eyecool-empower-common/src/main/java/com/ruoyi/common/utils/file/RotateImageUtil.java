package com.ruoyi.common.utils.file;

import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import sun.misc.BASE64Decoder;

/**
 * 旋转图片工具类
 * 
 * @author admin 
 * @date 2019年12月12日
 */
@SuppressWarnings("restriction")
public class RotateImageUtil {

    private static final Logger LOG = LoggerFactory.getLogger(RotateImageUtil.class);

    /**
     * 旋转Base64
     * 
     * @param imageBase64 图像base64
     * @param angel 旋转角度
     * @param baseDir 生成图片的文件夹
     * @param imgSuffix 图片的拓展名
     * @param isDeleteFile 是否删除生成的图片
     * @return 旋转后的图片base64
     */
    public static String rotateImageBase64(String imageBase64, int angel, String baseDir, String imgSuffix, boolean isDeleteFile) {
        // Base64生成图片
        if (StringUtils.isEmpty(imageBase64)) {// 图像数据为空
            LOG.error("imageBase64图像数据为空");
            return null;
        }
        String imgFilePath = baseDir + UUID.randomUUID().toString() + "." + imgSuffix;
        File imgFile = new File(imgFilePath);
        if (!imgFile.getParentFile().exists()) {
            imgFile.getParentFile().mkdirs();
        }
        boolean generateImage = GenerateImage(imageBase64, imgFilePath);
        if (!generateImage) {
            return null;
        }
        FileInputStream fileInputStream = null;
        try {
            fileInputStream = new FileInputStream(imgFilePath);
            BufferedImage bufferedImage = ImageIO.read(fileInputStream);
            // 调用图片旋转工具类，旋转图片
            BufferedImage rotateImage = RotateImageUtil.rotateImage(bufferedImage, angel);
            // 将旋转后的图片保存
            File file = new File(imgFilePath);
            ImageIO.write(rotateImage, imgSuffix, file);
            return getImageBase64(imgFilePath);
        } catch (IOException e) {
            LOG.error("获取图片bufferedImage失败：{}", e.getMessage(), e);
            return null;
        } finally {
            try {
                if (null != fileInputStream) {
                    fileInputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (isDeleteFile) {
                deleteFile(imgFilePath);
            }
        }
    }

    /**
     * 旋转图片
     * 
     * @param bufferedImage 图片
     * @param angel 旋转角度
     * @return
     */
    public static BufferedImage rotateImage(BufferedImage bufferedImage, int angel) {
        if (bufferedImage == null) {
            return null;
        }
        if (angel < 0) {
            // 将负数角度，纠正为正数角度
            angel = angel + 360;
        }
        int imageWidth = bufferedImage.getWidth(null);
        int imageHeight = bufferedImage.getHeight(null);
        // 计算重新绘制图片的尺寸
        Rectangle rectangle = calculatorRotatedSize(new Rectangle(new Dimension(imageWidth, imageHeight)), angel);
        // 获取原始图片的透明度
        int type = bufferedImage.getColorModel().getTransparency();
        BufferedImage newImage = null;
        newImage = new BufferedImage(rectangle.width, rectangle.height, type);
        Graphics2D graphics = newImage.createGraphics();
        // 平移位置
        graphics.translate((rectangle.width - imageWidth) / 2, (rectangle.height - imageHeight) / 2);
        // 旋转角度
        graphics.rotate(Math.toRadians(angel), imageWidth / 2, imageHeight / 2);
        // 绘图
        graphics.drawImage(bufferedImage, null, null);
        return newImage;
    }

    /**
     * 旋转图片
     * 
     * @param image 图片
     * @param angel 旋转角度
     * @return
     */
    public static BufferedImage rotateImage(Image image, int angel) {
        if (image == null) {
            return null;
        }
        if (angel < 0) {
            // 将负数角度，纠正为正数角度
            angel = angel + 360;
        }
        int imageWidth = image.getWidth(null);
        int imageHeight = image.getHeight(null);
        Rectangle rectangle = calculatorRotatedSize(new Rectangle(new Dimension(imageWidth, imageHeight)), angel);
        BufferedImage newImage = null;
        newImage = new BufferedImage(rectangle.width, rectangle.height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = newImage.createGraphics();
        // transform
        graphics.translate((rectangle.width - imageWidth) / 2, (rectangle.height - imageHeight) / 2);
        graphics.rotate(Math.toRadians(angel), imageWidth / 2, imageHeight / 2);
        graphics.drawImage(image, null, null);
        return newImage;
    }

    /**
     * 计算旋转后的尺寸
     * 
     * @param src
     * @param angel
     * @return
     */
    private static Rectangle calculatorRotatedSize(Rectangle src, int angel) {
        if (angel >= 90) {
            if (angel / 90 % 2 == 1) {
                int temp = src.height;
                src.height = src.width;
                src.width = temp;
            }
            angel = angel % 90;
        }
        double r = Math.sqrt(src.height * src.height + src.width * src.width) / 2;
        double len = 2 * Math.sin(Math.toRadians(angel) / 2) * r;
        double angel_alpha = (Math.PI - Math.toRadians(angel)) / 2;
        double angel_dalta_width = Math.atan((double) src.height / src.width);
        double angel_dalta_height = Math.atan((double) src.width / src.height);

        int len_dalta_width = (int) (len * Math.cos(Math.PI - angel_alpha - angel_dalta_width));
        int len_dalta_height = (int) (len * Math.cos(Math.PI - angel_alpha - angel_dalta_height));
        int des_width = src.width + len_dalta_width * 2;
        int des_height = src.height + len_dalta_height * 2;
        return new java.awt.Rectangle(new Dimension(des_width, des_height));
    }

    /**
     * 获取网络图片流（附加）
     * 
     * @param url
     * @return
     */
    public static InputStream getImageStream(String url) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setReadTimeout(5000);
            connection.setConnectTimeout(5000);
            connection.setRequestMethod("GET");
            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                InputStream inputStream = connection.getInputStream();
                return inputStream;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 对字节数组字符串进行Base64解码并生成图片
     * 
     * @param imgBase64
     * @param imgFilePath
     * @return
     */
    public static boolean GenerateImage(String imgBase64, String imgFilePath) {
        if (imgBase64 == null) {// 图像数据为空
            LOG.error("imageBase64图像数据为空");
            return false;
        }
        File imgFile = new File(imgFilePath);
        if (!imgFile.getParentFile().exists()) {
            imgFile.getParentFile().mkdirs();
        }
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            // Base64解码
            byte[] bytes = decoder.decodeBuffer(imgBase64);
            for (int i = 0; i < bytes.length; ++i) {
                if (bytes[i] < 0) {// 调整异常数据
                    bytes[i] += 256;
                }
            }
            // 生成jpeg图片
            OutputStream out = new FileOutputStream(imgFilePath);
            out.write(bytes);
            out.flush();
            out.close();
            return true;
        } catch (Exception e) {
            LOG.error("base64生成图片文件错误:{}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 根据路径获取图片的Base64
     *
     * @param path
     * @return
     */
    public static String getImageBase64(String path) {
        String stringBase64 = null;
        try {
            File file = new File(path);
            if (file != null && file.exists()) {
                FileInputStream fis = new FileInputStream(file);
                try {
                    byte[] fileBytes = new byte[fis.available()];
                    fis.read(fileBytes);
                    stringBase64 = Base64.encodeBase64String(fileBytes);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    fis.close();
                }
            }
        } catch (Exception ex) {
            LOG.error("获取图片的base64失败：" + ex.getMessage());
        }
        return stringBase64;
    }

    /**
     * 删除文件
     * 
     * @param filePath 文件
     * @return
     */
    public static boolean deleteFile(String filePath) {
        boolean flag = false;
        File file = new File(filePath);
        // 路径为文件且不为空则进行删除
        if (file.isFile() && file.exists()) {
            file.delete();
            flag = true;
        }
        return flag;
    }

    public static void main(String[] args) {
        String url = "https://www.baidu.com/img/bd_logo1.png";
        // 将网络图片转为BufferedImage
        try {
            BufferedImage bufferedImage = ImageIO.read(RotateImageUtil.getImageStream(url));
            // 调用图片旋转工具类，旋转图片
            BufferedImage rotateImage = RotateImageUtil.rotateImage(bufferedImage, 45);
            // 截取URL中的图片名称和后缀
            String fileName = url.substring(url.lastIndexOf("/") + 1, url.length());
            // 截取图片后缀名（.png）,以保持图片格式不变
            String imgSuffix = url.substring(url.lastIndexOf(".") + 1, url.length());
            // 将旋转后的图片保存到D盘根目录下
            File file = new File("D:\\", fileName);
            ImageIO.write(rotateImage, imgSuffix, file);
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 测试本地图片
        String imgFilePathold = "D://test.jpg";
        String imageBase64 = getImageBase64(imgFilePathold);
        System.err.println(imageBase64);
        String rotateImageBase64 = rotateImageBase64(imageBase64, 90, "D:\\", "jpg", true);
        System.err.println(imageBase64.equals(rotateImageBase64));
    }

}