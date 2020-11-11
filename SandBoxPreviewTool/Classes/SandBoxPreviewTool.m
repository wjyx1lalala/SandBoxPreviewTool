//
//  LJ_FileTool.m
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SandBoxPreviewTool.h"
#import "LJ_DirToolNavigatorController.h"

@interface SandBoxPreviewTool ()

@property (nonatomic,strong)LJ_DirToolNavigatorController * navVC;

@end

@implementation SandBoxPreviewTool

static SandBoxPreviewTool *_singleton;

+ (instancetype)sharedTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];;
    });
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super allocWithZone:zone];
    });
    return _singleton;
}

#pragma mark 打开或关闭应用磁盘目录面板
- (void)autoOpenCloseApplicationDiskDirectoryPanel{
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    BOOL isEqual = root.presentedViewController == _navVC;
    if (root.presentedViewController) {
      if (isEqual) {//相同则直接隐藏  不相同，隐藏后再弹出
        [_navVC dismissViewControllerAnimated:YES completion:nil];
      }else{
        [root.presentedViewController dismissViewControllerAnimated:YES completion:^{
          [self presentNav];
        }];
      }
    }else{//直接弹出
      [self presentNav];
    }
}

- (void)presentNav{
    if (_navVC) {
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_navVC animated:YES completion:nil];
    }else{
      LJ_DirToolNavigatorController * vc = [LJ_DirToolNavigatorController create];
      vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
      _navVC = vc;
    }
}



@end
