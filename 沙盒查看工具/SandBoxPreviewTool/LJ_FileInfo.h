//
//  LJ_FileInfo.h
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//  获取文件MD5 用于验证文件完整性

#import <Foundation/Foundation.h>

@interface LJ_FileInfo : NSObject

//获取制定路径文件的md5值，不能为文件夹，文件路径不能为空
+ (NSString*)getFileMD5WithPath:(NSString*)path;

//查找指定路径下文件信息
+ (NSMutableArray*)searchAllFileFromRightDirPath:(NSString *)rightDirPath;

//获取文件类型
+ (NSString *)judgeFileTypeWithPath:(NSString *)filePath;

@end
