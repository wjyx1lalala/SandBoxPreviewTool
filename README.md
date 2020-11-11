# SandBoxPreviewTool

### 一两行代码就能轻松查看ios应用沙盒文件。debug好帮手

很多项目中，都或多或少有文件下载，db存储或其他类型文件缓存/音视频图片缓存等等。

可是，真机或者调试阶段要查看这些文件就需要各位开发同学进入对应沙盒路径文件夹自行查看，非常不方便。对于真机，更是麻烦。

建议各位同发同学都可以在项目提测阶段，添加悬浮球，一键跳转沙盒，方便试试查看缓存文件信息或者分享文件到PC。

json，plist，html，css，log日志，图片等支持应用内查看。

sqlite，realm等文件（会自动忽略部分管道文件），支持AirDrop分享查看。

附带文件MD5信息，适合文件下载后查看本地文件信息，校验文件完整性。

例如：如果你觉得自己应用中的数据库文件写的有问题，可以直接将对应的db或realm文件通过AirDrop分享到电脑后，然后通过相关应用直接输入sql语句进行debug。

```
#import <SandBoxPreviewTool/SuspensionButton.h>//悬浮球按钮

//按钮点击事件中调用
- (IBAction)click:(id)sender {
    //[[SandBoxPreviewTool sharedTool] setOpenLog:YES];是否开启控制台打印文件路径。不用可自行忽略
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}
```

赠送附加功能1：查看文件MD5值，建议有重要文件下载、上传都严格校验文件MD5摘要，防止文件网络请求过程出错或被篡改等等意外。
```
#import <SandBoxPreviewTool/LJ_FileInfo.h>

//xx_filePath 文件沙盒路径（不能设置为文件夹路径）
[LJ_FileInfo getFileMD5WithPath: xx_filePath];

```
赠送附加功能2：悬浮球
```在AppDelegate.m中导入
#import <SandBoxPreviewTool/SuspensionButton.h>//悬浮球按钮

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    ...创建window以后向window添加悬浮球
    [self createDebugSuspensionButton];

}

// 创建悬浮球按钮
- (void)createDebugSuspensionButton{
   //自行添加哦~ 记得上线前要去除哦。 QA或者调试开发阶段可以这么使用
  SuspensionButton * button = [[SuspensionButton alloc] initWithFrame:CGRectMake(-5, [UIScreen mainScreen].bounds.size.height/2 - 100 , 50, 50) color:[UIColor colorWithRed:135/255.0 green:216/255.0 blue:80/255.0 alpha:1]];
    button.leanType = SuspensionViewLeanTypeEachSide;
    [button addTarget:self action:@selector(pushToDebugPage) forControlEvents:UIControlEventTouchUpInside];
    [self.window.rootViewController.view addSubview:button];
}

//open or close sandbox preview
- (void)pushToDebugPage{
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}

```
#### 安装
```
pod  "SandBoxPreviewTool"
```

#### 部分样例

初次打开的样子，测试按钮自行忽略
<br/>
<img src="http://nuomi-yx.oss-cn-hangzhou.aliyuncs.com/git/SandBoxPreviewTool/dirtable.png" width = "300" height = "649.6"/>

通过AirDrop或三方分享 共享文件
<br/>
<img src="http://nuomi-yx.oss-cn-hangzhou.aliyuncs.com/git/SandBoxPreviewTool/share.png" width = "300" height = "649.6"/>

查看某个文件下所有子文件 可以方便得查看类似于SDWebImage工具的图片缓存
<br/>
<img src="http://nuomi-yx.oss-cn-hangzhou.aliyuncs.com/git/SandBoxPreviewTool/img.png" width = "300" height = "649.6"/>

查看沙盒中下载的文件，MD5值可以用于校验文件是否下载出错。
<br/>
<img src="http://nuomi-yx.oss-cn-hangzhou.aliyuncs.com/git/SandBoxPreviewTool/cv.png" width = "300" height = "649.6"/>


#### 其他建议
其实开发中大家一样可以使用在info.plist中添加UIFileSharingEnabled为true。
这样可以很容易的itunes中查看Documents文件目录下文件内容。
但是如果没有特殊需要，上线前一定要关闭该功能哦~
