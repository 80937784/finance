-- ----------------------------
-- 1、人员基础信息表添加唯一索引(最大767byte)
-- ----------------------------
ALTER TABLE base_person_info ADD UNIQUE INDEX uniqueIdIndex (unique_id);
-- ----------------------------
-- 2、人脸信息表表添加正常索引(最大767byte)
-- ----------------------------
ALTER TABLE base_person_face ADD INDEX personIdIndex (person_id);
-- ----------------------------
-- 3、指纹信息表表添加正常索引(最大767byte)
-- ----------------------------
ALTER TABLE base_person_finger ADD INDEX personIdIndex (person_id);
-- ----------------------------
-- 4、人脸信息表表添加正常索引(最大767byte)
-- ----------------------------
ALTER TABLE base_person_iris ADD INDEX personIdIndex (person_id);