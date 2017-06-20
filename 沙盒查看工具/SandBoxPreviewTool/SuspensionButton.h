//
//  Created by wjyx on 2017/6/4.
//  悬浮按钮
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SuspensionViewLeanType) {
    /** Can only stay in the left and right */
    SuspensionViewLeanTypeHorizontal,
    /** Can stay in the upper, lower, left, right */
    SuspensionViewLeanTypeEachSide
};


@interface SuspensionButton : UIButton

@property (nonatomic,assign)SuspensionViewLeanType leanType;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color;

@end
