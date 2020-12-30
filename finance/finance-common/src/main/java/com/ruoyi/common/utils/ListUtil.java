package com.ruoyi.common.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * List操作工具类
 * 
 * @author admin 
 * @date 2020年3月17日
 */
public class ListUtil {

    /**
     * List分割
     * 
     * @param unitSize
     * @param list
     * @return
     */
    public static <T> List<List<T>> groupList(int unitSize, List<T> list) {
        List<List<T>> listGroup = new ArrayList<List<T>>();
        int listSize = list.size();
        // 子集合的长度
        int toIndex = unitSize;
        for (int i = 0; i < list.size(); i += unitSize) {
            if (i + unitSize > listSize) {
                toIndex = listSize - i;
            }
            List<T> newList = list.subList(i, i + toIndex);
            listGroup.add(newList);
        }
        return listGroup;
    }

}
