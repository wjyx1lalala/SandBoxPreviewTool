//
//  ViewController.m
//  沙盒查看工具
//
//  Created by wjyx on 2017/5/15.
//  Copyright © 2017年 魏家园潇. All rights reserved.
//

#import "ViewController.h"

#import "SandBoxPreviewTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(id)sender {
    //whether show log about the file path
    [[SandBoxPreviewTool sharedTool] setOpenLog:YES];
    
    //open or close sandbox preview
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
