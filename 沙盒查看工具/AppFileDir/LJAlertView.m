//
//  LJAlertView.m
//  LJHotUpdate
//
//  Created by nuomi on 2017/2/9.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJAlertView.h"

#define HeightProportion [UIScreen mainScreen].bounds.size.height / 575.0f
#define DefaultGroupGap   6.0f//间隔大小
#define DefaultCellHeight 45 
#define AnimationShowDuration .4f//弹出动画时长
#define AnimationHiddenDuration .2f//隐藏动画时长
#define kFontSize 16.0f //字体大小

static NSString * const TopCellID = @"top";
static NSString * const BottomCellID = @"bottom";

@interface LJAlertView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,copy)  void(^clickBlock)(int row);
@property (nonatomic,assign)BOOL isShow;
@end

@implementation LJAlertView

+ (LJAlertView *)createAlertViewWith:(NSArray * )dataSource  AndCancleTitle:(NSString *)cancleTitle andClick:(void(^)(int row))clickBlock{
    LJAlertView * alertView = [[LJAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    alertView.dataSource = dataSource;
    alertView.cancleTitle = cancleTitle;
    alertView.clickBlock = clickBlock;
    [alertView.tableView reloadData];
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenWithDiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 防止手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:NSStringFromClass([self class])]) {
        return YES;
    }else{
        return NO;
    }
}

//隐藏
- (void)hiddenWithDiss{
    CGRect frame = self.tableView.frame;
    
    CGFloat height = DefaultCellHeight * (self.dataSource.count + 1) + DefaultGroupGap;
    frame.origin.y += height;
    _isShow = NO;
    UIColor * color = [UIColor clearColor];
    [UIView animateWithDuration:AnimationHiddenDuration animations:^{
        self.backgroundColor = color;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//弹出
- (void)show{
    
    if (self.isShow) {
        [self hiddenWithDiss];
        return ;
    }
    
    [self bringSubviewToFront:self.tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect frame = self.tableView.frame;
    CGFloat height = DefaultCellHeight * (self.dataSource.count + 1) + DefaultGroupGap;
    frame.origin.y -= height;
    
    UIColor * viewColor = [UIColor blackColor];
    viewColor = [viewColor colorWithAlphaComponent:.3f];
    _isShow = YES;
    [UIView animateWithDuration:AnimationShowDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.tableView.frame = frame;
        
        self.backgroundColor = viewColor;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        float footerHeight = 20;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, DefaultCellHeight * (self.dataSource.count + 1) + DefaultGroupGap + footerHeight)];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIColor * color = [UIColor colorWithRed:0.84 green:0.84 blue:0.85 alpha:1];
        _tableView.backgroundColor = color;
        _tableView.rowHeight = DefaultCellHeight;
        _tableView.separatorColor = color;
        [self addSubview:_tableView];
        //for spring animation
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, footerHeight)];
        footerView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 1) {
        if (self.clickBlock) {
            self.clickBlock((int)indexPath.row);
        }
    }
    [self hiddenWithDiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section ? 1:self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section ? DefaultGroupGap: 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellid = nil;
    if (indexPath.section == 0) {
        cellid = TopCellID;
    }else{
        cellid = BottomCellID;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = cell.contentView.center;
    label.textColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    label.font = [UIFont systemFontOfSize:kFontSize];
    [cell.contentView addSubview:label];
    //居中
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, DefaultCellHeight);
    if (indexPath.section == 0) {
        label.text = [self.dataSource objectAtIndex:indexPath.row];
    }else{
        if (self.cancleTitle && [self.cancleTitle isKindOfClass:[NSString class]] && self.cancleTitle.length) {
            label.text = self.cancleTitle;
        }else{
            label.text = @"取消";
        }
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setPreservesSuperviewLayoutMargins:NO];
    return cell;
}


@end
