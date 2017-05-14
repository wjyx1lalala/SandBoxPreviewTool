//
//  LJ_HomeDirViewController.m
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJ_HomeDirViewController.h"
#import "LJ_FileInfoController.h" //文件详情页面
#import "LJ_FileInfo.h"  //文件检查类

@interface LJ_HomeDirViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation LJ_HomeDirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)close{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setUpUI{
    
    if (self.isHomeDir) {
        self.title = @"应用沙盒文件目录";
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // CFShow((__bridge CFTypeRef)(infoDictionary));
        NSString *executableFile = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey]; //获取项目包文件
        if(executableFile){
            executableFile = [executableFile stringByAppendingString:@".app (包)"];
        }else{
            executableFile = @"app";
        }
        [_dataSource addObject:@{@"title":executableFile,@"isDir":@NO,@"canDel":@NO}];
        _filePath = NSHomeDirectory();
        UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
        self.navigationItem.leftBarButtonItem = left;
    }else{
        self.title = self.fileName;
        UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(findAllFileInfo)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self findAllFileInfo];
}

- (void)findAllFileInfo{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataSource = [LJ_FileInfo searchAllFileFromRightDirPath:_filePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataSource.count) {
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                self.tableView.hidden = YES;
            }
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"LJ_HomeDirViewController_tableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary  *infoDict = _dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1];
    cell.textLabel.text = [infoDict objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([[infoDict objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory] == NO) {
        //非文件夹
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([infoDict[@"FileType"] hasPrefix:@"image"]) {
            //图片类型
            cell.imageView.image = [UIImage imageNamed:@"lj_Pictures"];
        }else{
            //unknow_icon  未知文件类型
            cell.imageView.image = [UIImage imageNamed:@"lj_unknow_icon"];
        }
    }else{
        //文件夹模式
        cell.imageView.image = [UIImage imageNamed:@"GenericFolderIcon.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    if(infoDict[NSFileModificationDate]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //[dateFormatter setDateFormat:@"最近修改时间:yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:infoDict[NSFileModificationDate]];
        cell.detailTextLabel.text = dateStr;
    }else{
        cell.detailTextLabel.text = @" ";
    }
    
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isHomeDir) {
        return @[];
    }
    
    BOOL canDelete = [[NSFileManager defaultManager] isDeletableFileAtPath:self.filePath];
    NSString * title = canDelete ? @"删除" : @"不可删除";
    UITableViewRowAction * delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([action.title isEqualToString:@"删除"]) {
            [self deleteOneRowWithIndexPath:indexPath];
        }else{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
    
    return @[delete];
}
#pragma mark - 删除文件或者目录
- (void)deleteOneRowWithIndexPath:(NSIndexPath *)indexPath{
    
    //获取文件属性
    NSFileManager * filemager = [NSFileManager defaultManager];
    NSDictionary * info = _dataSource[indexPath.row];
    NSString * path = [self.filePath stringByAppendingPathComponent:info[@"title"]];
    NSError * error = nil;
    [filemager removeItemAtPath:path error:&error];
    if (error) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"删除文件失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return ;
    }
    
    NSMutableArray * ds = [NSMutableArray arrayWithArray:self.dataSource];
    [ds removeObjectAtIndex:indexPath.row];
    self.dataSource = ds;
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * infoDict = _dataSource[indexPath.row];
    if ([[infoDict objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
        LJ_HomeDirViewController * dirVC = [[LJ_HomeDirViewController alloc] init];
        dirVC.filePath = [self.filePath stringByAppendingPathComponent:infoDict[@"title"]];
        dirVC.fileName = infoDict[@"title"];
        [self.navigationController pushViewController:dirVC animated:YES];
    }else{
        NSString * fileName = infoDict[@"title"];
        NSString * filePath = [self.filePath stringByAppendingPathComponent:fileName];
        
        LJ_FileInfoController * infovc =[LJ_FileInfoController createWithFileName:fileName andFilePath:filePath andFileInfo:infoDict];
        [self.navigationController pushViewController:infovc animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
