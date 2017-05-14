//
//  LJAlertView.h
//  LJHotUpdate
//
//  Created by nuomi on 2017/2/9.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJAlertView : UIView

@property (nonatomic,strong)NSArray <NSString *> * dataSource;

@property (nonatomic,copy)NSString * cancleTitle;

/**
 *  Alert提示框
 *
 *  @param dataSource  提示框显示的内容
 *  @param cancleTitle 取消键名称,nil则默认为@"取消"
 *  @param clickBlock  点击后的回调
 *
 */
+ (LJAlertView *)createAlertViewWith:(NSArray * )dataSource  AndCancleTitle:(NSString *)cancleTitle andClick:(void(^)(int row))clickBlock;

/**
 *  弹出提示框
 */
- (void)show;


@end
