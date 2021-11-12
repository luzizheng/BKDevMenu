//
//  LSBFileModel.h
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LSBFileType) {
    LSBFileTypeUnknown = -1, //其他
    LSBFileTypeAll = 0, //所有
    LSBFileTypeImage = 1, //图片
    LSBFileTypeTxt = 2, //文档
    LSBFileTypeVoice = 3, //音乐
    LSBFileTypeAudioVidio = 4, //视频
    LSBFileTypeApplication = 5, //应用
    LSBFileTypeDirectory = 6, //目录
    LSBFileTypePDF = 7, //PDF
    LSBFileTypePPT = 8, //PPT
    LSBFileTypeWord = 9, //Word
    LSBFileTypeXLS = 10, //XLS
};

@interface LSBFileDes : NSObject
@property(nonatomic,copy)NSString * iconName;
@property(nonatomic,strong)NSArray * suffixs;
@property(nonatomic,copy)NSString * fileTypeName;
+(LSBFileDes *)searchDesWithKeyword:(NSString *)keyword;
+(LSBFileDes *)documentDes;
+(LSBFileDes *)binaryDes;
@end



@interface LSBFileModel : NSObject
//文件路径
@property (copy, nonatomic) NSString *filePath; ///< 全路径
//文件URL
@property (copy, nonatomic) NSString *fileUrl;

@property (copy, nonatomic) NSString *name; ///< 文件名称

@property (copy, nonatomic) NSString *fileSize; ///< 大小用字符表述

@property (nonatomic, assign) float fileSizefloat; ///< 大小用float

@property (copy, nonatomic) NSString *modTime; ///< 修改时间

@property (copy, nonatomic) NSString *creatTime; ///< 修改时间

@property (assign, nonatomic) LSBFileType fileType;

@property (copy, nonatomic)NSString *mimeType;

@property (nonatomic, strong) NSDictionary *attributes; ///<文件属性


@property(nonatomic,readonly)NSString *fileTypeName;

/// 如果是文件夹，里面的文件数量
@property (assign, nonatomic)NSInteger fileCount;


@property (nonatomic, strong)LSBFileDes * fileDes;
/**
 初始化方法

 @param filePath 全路径
 @return 自身对象
 */
- (instancetype)initWithFilePath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
