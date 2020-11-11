//
//  SPViewController.m
//  SandBoxPreviewTool
//

#import "SPViewController.h"
#import <SandBoxPreviewTool/SandBoxPreviewTool.h>
#import <SandBoxPreviewTool/SuspensionButton.h>//悬浮球按钮

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.darkGrayColor;
    [self createDebugSuspensionButton];
}

// 创建悬浮球按钮
- (void)createDebugSuspensionButton{
   //自行添加哦~ 记得上线前要去除哦。 QA或者调试开发阶段可以这么使用
  SuspensionButton * button = [[SuspensionButton alloc] initWithFrame:CGRectMake(-5, [UIScreen mainScreen].bounds.size.height/2 - 100 , 50, 50) color:[UIColor colorWithRed:135/255.0 green:216/255.0 blue:80/255.0 alpha:1]];
    button.leanType = SuspensionViewLeanTypeEachSide;
    [button addTarget:self action:@selector(pushToDebugPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//open or close sandbox preview
- (void)pushToDebugPage{
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}

@end
