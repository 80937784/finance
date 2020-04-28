package com.ruoyi.common.utils.file;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.web.multipart.MultipartFile;

import com.ruoyi.common.exception.BusinessException;
import com.ruoyi.common.utils.PlatformCryptUtils;
import com.ruoyi.common.utils.StringUtils;

/**
 * 平台文件工具类(平台自定义的文件操作使用这个)
 * 
 * @author admin 
 * @date 2019年12月24日
 */
public class PlatformFileUtils extends FileUtils {

    private static final Logger LOG = LoggerFactory.getLogger(FileUtils.class);

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
     * 根据MultipartFile获取图片的base64
     * 
     * @param multipartFile
     * @return
     */
    public static String getImageBase64(MultipartFile multipartFile) {
        String photoName = multipartFile.getOriginalFilename().split("\\.")[0];
        LOG.info("上传的图片名称是[{}]", photoName);
        byte[] imageContent = null;
        try {
            imageContent = multipartFile.getBytes();
        } catch (Exception e) {
            LOG.error("图片名称[{}] 的图片出错[{}]", photoName, e.getMessage());
        }
        return Base64.encodeBase64String(imageContent);
    }

    /**
     * 根据InputStream获取图片base64
     * 
     * @param inputStream
     * @return
     */
    public static String getImageBase64(InputStream in) {
        byte[] bytes = null;
        try {
            bytes = new byte[in.available()];
            in.read(bytes);
        } catch (IOException e) {
            LOG.error("inputStream转换Base64出错", e);
        }
        return Base64.encodeBase64String(bytes);
    }

    /**
     * 压缩zip文件
     * 
     * @param entryList
     * @param zipFile
     */
    public static void zipFiles(List<ZipEntryFileModel> entryList, File zipFile) {
        // 判断压缩后的文件存在不，不存在则创建
        if (!zipFile.exists()) {
            try {
                zipFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        // 创建 FileOutputStream 对象
        FileOutputStream fileOutputStream = null;
        // 创建 ZipOutputStream
        ZipOutputStream zipOutputStream = null;
        // 创建 FileInputStream 对象
        FileInputStream fileInputStream = null;
        try {
            // 实例化 FileOutputStream 对象
            fileOutputStream = new FileOutputStream(zipFile);
            // 实例化 ZipOutputStream 对象
            zipOutputStream = new ZipOutputStream(fileOutputStream);
            // 创建 ZipEntry 对象
            ZipEntry zipEntry = null;
            // 遍历源文件集合
            for (int i = 0; i < entryList.size(); i++) {
                // 将源文件数组中的当前文件读入 FileInputStream 流中
                ZipEntryFileModel zipEntryFileModel = entryList.get(i);
                if (null == zipEntryFileModel.getFile() || !zipEntryFileModel.getFile().exists()) {
                    continue;
                }
                fileInputStream = new FileInputStream(zipEntryFileModel.getFile());
                // 实例化 ZipEntry 对象，源文件数组中的当前文件
                String fileName = zipEntryFileModel.getFile().getName();
                if (StringUtils.isNotBlank(zipEntryFileModel.getFileName())) {
                    fileName = zipEntryFileModel.getFileName();
                }
                zipEntry = new ZipEntry(fileName);
                zipOutputStream.putNextEntry(zipEntry);
                // 获取字节数组
                if (null != zipEntryFileModel.getEncrypted() && zipEntryFileModel.getEncrypted()) {
                    byte[] bytes = PlatformCryptUtils.decryptStreamToBytes(fileInputStream);
                    zipOutputStream.write(bytes);
                } else {
                    // 该变量记录每次真正读的字节个数
                    int len;
                    // 定义每次读取的字节数组
                    byte[] buffer = new byte[1024];
                    while ((len = fileInputStream.read(buffer)) > 0) {
                        zipOutputStream.write(buffer, 0, len);
                    }
                }
            }
            zipOutputStream.closeEntry();
            zipOutputStream.close();
            if (null != fileInputStream) {
                fileInputStream.close();
            }
            fileOutputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 对zip类型的文件进行解压
     * 
     * @param multipartFile
     * @param zipFile
     * @return
     */
    public static List<FileModel> unzip(MultipartFile multipartFile) {
        // 判断文件是否为zip文件
        String filename = multipartFile.getOriginalFilename();
        if (!filename.endsWith("zip")) {
            LOG.info("传入文件格式不是zip文件" + filename);
            throw new BusinessException("传入文件格式错误" + filename);
        }
        List<FileModel> fileModelList = new ArrayList<>();
        String zipFileName = null;
        // 对文件进行解析
        try {
            ZipInputStream zipInputStream = new ZipInputStream(multipartFile.getInputStream(), Charset.forName("GBK"));
            BufferedInputStream bs = new BufferedInputStream(zipInputStream);
            ZipEntry zipEntry = null;
            byte[] bytes = null;
            // 获取zip包中的每一个zipFileEntry
            while ((zipEntry = zipInputStream.getNextEntry()) != null) {
                if (zipEntry.isDirectory()) {
                    throw new BusinessException("传入文件格式错误,压缩包内不能包含文件夹!");
                }
                zipFileName = zipEntry.getName();
                Assert.notNull(zipFileName, "压缩文件中子文件的名字格式不正确");
                bytes = new byte[(int) zipEntry.getSize()];
                bs.read(bytes, 0, (int) zipEntry.getSize());
                InputStream byteArrayInputStream = new ByteArrayInputStream(bytes);
                FileModel fileModel = new FileModel();
                fileModel.setFileName(zipFileName);
                fileModel.setFileInputstream(byteArrayInputStream);
                fileModel.setFileSize(zipEntry.getSize());
                fileModelList.add(fileModel);
            }
            bs.close();
            zipInputStream.close();
        } catch (Exception e) {
            LOG.error("读取压缩包文件内容失败,请确认压缩包格式正确:" + zipFileName, e);
            throw new BusinessException("读取压缩包文件内容失败,请确认压缩包格式正确:" + zipFileName);
        }
        return fileModelList;
    }

    /**
     * 根据得到图片字节，获得图片后缀
     *
     * @param photoByte 图片字节
     * @return 图片后缀
     */
    public static String getImageFileExtendName(byte[] photoByte) {
        String strFileExtendName = ".jpg";
        if ((photoByte[0] == 71) && (photoByte[1] == 73) && (photoByte[2] == 70) && (photoByte[3] == 56) && ((photoByte[4] == 55) || (photoByte[4] == 57))
                && (photoByte[5] == 97)) {
            strFileExtendName = ".gif";
        } else if ((photoByte[6] == 74) && (photoByte[7] == 70) && (photoByte[8] == 73) && (photoByte[9] == 70)) {
            strFileExtendName = ".jpg";
        } else if ((photoByte[0] == 66) && (photoByte[1] == 77)) {
            strFileExtendName = ".bmp";
        } else if ((photoByte[1] == 80) && (photoByte[2] == 78) && (photoByte[3] == 71)) {
            strFileExtendName = ".png";
        }
        return strFileExtendName;
    }

    /**
     * 根据图片Base64，获得图片后缀
     *
     * @param base64String 图片base64
     * @return 图片后缀
     */
    public static String getImageFileExtendName(String base64String) {
        byte[] bytes = Base64.decodeBase64(base64String);
        return getImageFileExtendName(bytes);
    }

    /**
     * 删除文件夹
     * 
     * @param dirPath
     */
    public static void deleteDir(String dirPath) {
        File file = new File(dirPath);
        if (file.isFile()) {
            file.delete();
        } else {
            File[] files = file.listFiles();
            if (files == null) {
                file.delete();
            } else {
                for (int i = 0; i < files.length; i++) {
                    deleteDir(files[i].getAbsolutePath());
                }
                file.delete();
            }
        }
    }

}
