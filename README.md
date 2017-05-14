# SandBoxPreviewTool

### 一两行代码就能查看ios沙盒文件。debug好帮手

json，plist，html，css，log日志，图片等支持应用内查看。

sqlite，realm等文件，支持AirDrop，微信QQ分享后查看。

附带文件MD5信息，适合文件下载后查看本地文件信息，校验文件完整性。

例如：如果你觉得自己应用中的数据库文件写的有问题，可以直接将对应的db或realm文件通过AirDrop分享到电脑后，然后通过相关应用直接输入sql语句进行debug。

```
#import <SandBoxPreviewTool.h>

//点击事件中调用
- (IBAction)click:(id)sender {
    //[[SandBoxPreviewTool sharedTool] setOpenLog:YES];是否开启控制台打印文件路径。不用可自行忽略
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}
```

查看文件MD5值
```
#import <LJ_FileInfo.h>

//xx_filePath 本地沙盒文件路径（不能设置为文件夹路径）
[LJ_FileInfo getFileMD5WithPath: xx_filePath];
```
#### 安装
```
pod  "SandBoxPreviewTool"
```

#### 部分样例

初次打开的样子，测试按钮自行忽略
![image](http://nuomiadai.oss-cn-shanghai.aliyuncs.com/sandbox_dir.jpg)

通过AirDrop或三方分享 共享文件
![image](http://nuomiadai.oss-cn-shanghai.aliyuncs.com/sharedb.jpg)

查看某个文件下所有子文件 可以方便得查看类似于SDWebImage工具的图片缓存
![image](http://nuomiadai.oss-cn-shanghai.aliyuncs.com/fileDir.jpg)

在Mac电脑上查看手机中写入的数据库db
![image](http://nuomiadai.oss-cn-shanghai.aliyuncs.com/localdb.jpg)
