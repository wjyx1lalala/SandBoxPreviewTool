//
//  LJ_FileInfoController.m
//  LJHotUpdate
//
//  Created by nuomi on 2017/2/9.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJ_FileInfoController.h"
#import "LJ_FileInfo.h"
#import "SandBoxPreviewTool.h"
//屏幕最小值
#define MIN_Screen ([UIScreen mainScreen].bounds.size.width <  [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

@interface LJ_FileInfoController ()

@property (nonatomic,strong) UITextView * tView;
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,copy) NSString * md5;

@end

@implementation LJ_FileInfoController

+ (instancetype)createWithFileName:(NSString *)fileName andFilePath:(NSString *)filePath andFileInfo:(NSDictionary *)fileInfo{
    LJ_FileInfoController * infoVC = [[LJ_FileInfoController alloc] init];
    infoVC.filePath = filePath;
    infoVC.fileName = fileName;
    infoVC.fileInfo = fileInfo;
    return infoVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
#ifdef DEBUG
    if ([SandBoxPreviewTool sharedTool].openLog) {
        NSLog(@"%@",self.filePath);
    }
#endif
}

- (void)setUpUI{
    
    self.title = self.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;//禁止内容从bar底部开始布局
  
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile)];
    self.navigationItem.rightBarButtonItem = right;
    
    NSString * type= [[self.fileName componentsSeparatedByString:@"."] lastObject];
    UIView * top_View = nil;
    if ([type isEqualToString:@"html"] || [type isEqualToString:@"js"] || [type isEqualToString:@"pdf"] || [type isEqualToString:@"docx"] || [type isEqualToString:@"xlsx"] || [type isEqualToString:@"ppt"] || [type isEqualToString:@"xlsx"] || [type isEqualToString:@"css"]) {
          //go webView  when .js .html .ppt .pdf .docx .css file
          NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]];
          [self.webView loadRequest:request];
          top_View = self.webView;
      
      }else if ([type isEqualToString:@"h"] ||[type isEqualToString:@"m"] || [type isEqualToString:@"jsbundle"] || [type isEqualToString:@"log"]|| [type isEqualToString:@"txt"]) {
          //go textView  when .h .m .jsbundle .log .txt file
          NSString * string = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
          self.tView.text = string;
          top_View = self.tView;
      }else if ([self.fileInfo[@"FileType"] hasPrefix:@"image"]){
        
          //go imageView
          UIImage * image = [[UIImage alloc] initWithContentsOfFile:self.filePath];
          UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
          imageView.translatesAutoresizingMaskIntoConstraints = NO;
          imageView.contentMode = UIViewContentModeScaleAspectFit;
          CGFloat width = MIN_Screen - 50;
          CGFloat height = (width/image.size.width) * image.size.height;
        
          if ((image.size.width < width && image.size.height <width) || (image.size.width > width && image.size.height < 60)) {//如果图片的尺寸小于真实的尺寸
            CGFloat img_w = image.size.width;
            CGFloat img_h = image.size.height;
            if (img_w < 50 && img_h < 50) {//图片太小的情况下，略微放大显示
              img_w *= 2;
              img_h *= 2;
            }else if (image.size.width > width){
              img_w = width;
            }
            UIView * bgView = [[UIView alloc] init];
            [bgView addSubview:imageView];
            NSLayoutConstraint * imgV_CenterX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            NSLayoutConstraint * imgV_CenterY = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            NSLayoutConstraint * imgV_W = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:img_w];
            NSLayoutConstraint * imgV_H = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:img_h];
            [bgView addConstraints:@[imgV_CenterX,imgV_CenterY,imgV_W,imgV_H]];
            [self.view addSubview:bgView];
            top_View = bgView;
          }else{
            CGFloat margin_gap = 20;
            [self.view addSubview:imageView];
            NSLayoutConstraint * imgV_Top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin_gap];
            if (image.size.width < width) {
              NSLayoutConstraint * imgV_CenterX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
              NSLayoutConstraint * imgV_Width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:image.size.width];
              NSLayoutConstraint * imgV_Height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:image.size.height];
              [self.view addConstraints:@[imgV_CenterX,imgV_Width,imgV_Top,imgV_Height]];
            }else{
              NSLayoutConstraint * imgV_Left = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin_gap];
              NSLayoutConstraint * imgV_Right = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin_gap];
              NSLayoutConstraint * imgV_Height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(height >= 1?height : 1)];
              [self.view addConstraints:@[imgV_Left,imgV_Right,imgV_Top,imgV_Height]];
            }
            top_View = imageView;
          }
      }else if( [type isEqualToString:@"plist"]){
          //.plist
          NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
          NSString *jsonString = [self changeDicToString:dataDictionary];
          if (jsonString) {
            self.tView.text = jsonString;
            top_View = self.tView;
          }else{
              UILabel * lb = [[UILabel alloc] init];
              lb.text = @"数据为空哦~";
              lb.textColor = [UIColor darkGrayColor];
              lb.textAlignment = NSTextAlignmentCenter;
              [self.view addSubview:lb];
              top_View = lb;
          }
      }else if( [type isEqualToString:@"json"]){
          //.json
          NSData *data=[NSData dataWithContentsOfFile:self.filePath];
          if(data){
              NSError *error;
              NSDictionary * dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
              NSString *jsonString = [self dictionaryToJson:dataDictionary];
              if (jsonString && !error) {
                  self.tView.text = jsonString;
                  top_View = self.tView;
              }else{
                  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]];
                  [self.webView loadRequest:request];
                  top_View = self.webView;
              }
          }else{
              NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]];
              [self.webView loadRequest:request];
              top_View = self.webView;
          }
      }else{
          NSError * error = nil;
          NSString * aString = [type isEqualToString:@"note"] ? nil : [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:&error];
          if (error || !aString) {
              //other file ,not support
              UILabel * lb = [[UILabel alloc] init];
              lb.text = @"暂不支持的文件格式";
              lb.textColor = [UIColor darkGrayColor];
              lb.textAlignment = NSTextAlignmentCenter;
              [self.view addSubview:lb];
              top_View = lb;
          }else if(aString && [aString isKindOfClass:[NSString class]]){
              NSDictionary * dict = [self parseJSONStringToNSDictionary:aString];
              if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                  NSString * formatString = [self dictionaryToJson:dict];
                  if (formatString) {
                      self.tView.text = formatString;
                      top_View = self.tView;
                  }else{
                      self.tView.text = aString;
                      top_View = self.tView;
                  }
              }else{
                  self.tView.text = aString;
                  top_View = self.tView;
              }
          }
      }
      [self addFileInfoViewWithTopView:top_View];
}

 - (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (id)dictionaryToJson:(NSDictionary *)dic
{
    if([dic isKindOfClass:[NSDictionary class]] && dic){
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        if (parseError || !jsonData) {
            return [self changeDicToString:dic];
        }
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}


//字段转换成格式化的字符串
- (NSString *)changeDicToString:(NSDictionary *)dict{
    if(!dict)return @"";
    NSMutableString * s = [NSMutableString string];
    [s appendString:@"{\n"];
    for (NSString * key in dict.allKeys) {
      NSString * value = dict[key];
      [s appendString:[NSString stringWithFormat:@"   %@  =  %@;\n",key,value]];
    }
    [s appendString:@"\n}\n"];
    return s;
}

//分享文件
- (void)shareFile{
    NSURL *urlToShare = [NSURL fileURLWithPath:self.filePath];
    if (!urlToShare) return;
    NSArray *activityItems = @[urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.navigationController presentViewController:activityVC animated:YES completion:nil];
    } else {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


- (void)addFileInfoViewWithTopView:(UIView *)topView{
    //底部视图的高度是155
    UIView * bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * b_Left = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint * b_Right = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint * b_Bottom = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint * b_Height = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:155];
  
  
    //文件信息标签
    UILabel * gapLineView = [[UILabel alloc] init];
    gapLineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    gapLineView.text = @"文件信息";
    gapLineView.font = [UIFont systemFontOfSize:14];
    gapLineView.textColor = [UIColor colorWithRed:0.356 green:0.356 blue:0.356 alpha:1];
    gapLineView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:gapLineView];
    gapLineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * gap_Left = [NSLayoutConstraint constraintWithItem:gapLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint * gap_Right = [NSLayoutConstraint constraintWithItem:gapLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint * gap_Bottom = [NSLayoutConstraint constraintWithItem:gapLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint * gap_Height = [NSLayoutConstraint constraintWithItem:gapLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
    if (![topView isKindOfClass:[UIImageView class]]) {
      [self.view addConstraints:@[b_Left,b_Right,b_Bottom,b_Height]];
      [self.view addConstraints:@[gap_Left,gap_Right,gap_Bottom,gap_Height]];
    }else if ([topView isKindOfClass:[UIImageView class]]){
      NSLayoutConstraint * gap_Top = [NSLayoutConstraint constraintWithItem:gapLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
      NSLayoutConstraint * b_Top = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:gapLineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
      [self.view addConstraints:@[gap_Left,gap_Right,gap_Top,gap_Height]];
      [self.view addConstraints:@[b_Left,b_Right,b_Top,b_Height]];
    }
  
    if (topView && ![topView isKindOfClass:[UIImageView class]]) {
      //顶部视图
      topView.translatesAutoresizingMaskIntoConstraints = NO;
      NSLayoutConstraint * topV_Left = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
      NSLayoutConstraint * topV_Right = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
      NSLayoutConstraint * topV_Top = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
      NSLayoutConstraint * topV_Bottom = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:gapLineView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
      [self.view addConstraints:@[topV_Left,topV_Right,topV_Top,topV_Bottom]];
    }
  
    NSString * fileSize, *fileModDate,*fileCreateDate, *fileMD5 = @"";
    //文件大小
    fileSize = [self.fileInfo objectForKey:NSFileSize];
    CGFloat kb = [fileSize floatValue]/1024;
    if (kb < 1024) {
        fileSize = [NSString stringWithFormat:@"%.2f%@",kb,@"kb"];
    }else{
        fileSize = [NSString stringWithFormat:@"%.2f%@",kb/1024,@"M"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //文件创建日期
    fileCreateDate = [dateFormatter stringFromDate:self.fileInfo[NSFileCreationDate]];
    //文件修改日期
    fileModDate =  [dateFormatter stringFromDate:self.fileInfo[NSFileModificationDate]];
    //md5
    fileMD5 = [self.filePath hasSuffix:@".note"] ? @"管道文件，无法获取MD5值" :  [LJ_FileInfo getFileMD5WithPath:self.filePath];
    self.md5 = fileMD5;
    NSArray * infoArr = @[fileMD5?:@"",fileSize?:@"",fileCreateDate?:@"",fileModDate?:@""];
    NSArray * infoKeyArr = @[@"MD5值：",@"文件大小：",@"创建时间：",@"修改时间："];
    CGFloat height = 0;
    for (int i = 0; i < infoKeyArr.count; i++) {
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, height , [UIScreen mainScreen].bounds.size.width - 20, 35)];
        backView.clipsToBounds = YES;
        [bottomView addSubview:backView];
    
        UILabel * desclb = [self createInfoLabelWithDesc:infoKeyArr[i]];
        desclb.textAlignment = NSTextAlignmentRight;
        desclb.textColor = [UIColor lightGrayColor];
        desclb.frame = CGRectMake(0, 0, 74, 35);
        [backView addSubview:desclb];
        
        UILabel * contentlb = [self createInfoLabelWithDesc:infoArr[i]];
        contentlb.textAlignment = NSTextAlignmentLeft;
        contentlb.textColor = [UIColor blackColor];
        contentlb.frame = CGRectMake(74, 0, [UIScreen mainScreen].bounds.size.width - 94 , 35);
        [backView addSubview:contentlb];
        if (i == 0) {
          contentlb.userInteractionEnabled = YES;
          UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(getMD5)];
          longPress.minimumPressDuration = 0.5;
          [contentlb addGestureRecognizer:longPress];
        }
        height += 40;
    }
  
    if([topView isKindOfClass:[UIImageView class]]){
      [self.view layoutIfNeeded];
      UIView * vi = self.view;
      UIScrollView * sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
      sc.contentSize = CGSizeMake(vi.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
      sc.showsVerticalScrollIndicator = NO;
      [sc addSubview:vi];
      self.view = sc;
    }
  
}


- (void)getMD5{
    [UIPasteboard generalPasteboard].string = self.md5;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"复制该文件MD5成功" message:self.md5 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (UILabel *)createInfoLabelWithDesc:(NSString * )descStr{
    UILabel * label = [[UILabel alloc] init];
    label.text = descStr;
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}


- (UITextView *)tView{
    if (!_tView) {
      _tView = [[UITextView alloc] init];
      _tView.editable = NO;
      _tView.backgroundColor = [UIColor whiteColor];
      [self.view addSubview:_tView];
    }
    return _tView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}



@end
