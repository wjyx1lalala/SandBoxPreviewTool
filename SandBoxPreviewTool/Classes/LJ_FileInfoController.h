//
//  LJ_FileInfoController.h
//  LJHotUpdate
//
//  Created by nuomi on 2017/2/9.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJ_FileInfoController : UIViewController

@property (nonatomic,copy)NSString * filePath;//文件路径
@property (nonatomic,copy)NSString * fileName;//文件名称
@property (nonatomic,strong)NSDictionary * fileInfo;//文件名称
//根据文件类型和路径创建
+ (instancetype)createWithFileName:(NSString *)fileName andFilePath:(NSString *)filePath andFileInfo:(NSDictionary *)fileInfo;

@end
