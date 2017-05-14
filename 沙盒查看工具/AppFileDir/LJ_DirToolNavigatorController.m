//
//  LJ_DirToolNavigatorController.m
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJ_DirToolNavigatorController.h"
#import "LJ_HomeDirViewController.h"

@interface LJ_DirToolNavigatorController ()<UIGestureRecognizerDelegate>

@end


@implementation LJ_DirToolNavigatorController


+ (instancetype)create{
    LJ_HomeDirViewController * homeDir = [[LJ_HomeDirViewController alloc] init];
    homeDir.isHomeDir = YES;
    return [[LJ_DirToolNavigatorController alloc] initWithRootViewController:homeDir];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = self.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.356 green:0.356 blue:0.356 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    navBar.tintColor = [UIColor colorWithRed:0.356 green:0.356 blue:0.356 alpha:1];
    navBar.barTintColor = [UIColor whiteColor];
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count == 1 ? NO : YES;
}

- (void)back{
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
