//
//  LJ_FileTool.h
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//  沙盒预览工具 程序磁盘文件调试系统
//  Usage
/*
 step1:
 #import "SandBoxPreviewTool.h"
 
 step2:
 [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
 */

#import <Foundation/Foundation.h>

@interface SandBoxPreviewTool : NSObject


@property (nonatomic,assign)BOOL openLog;//开启log打印文件路径

//单例
+ (instancetype)sharedTool;


//自动打开或关闭应用磁盘目录面板
- (void)autoOpenCloseApplicationDiskDirectoryPanel;


@end
