//
//  Created by wjyx on 2017/6/4.
//
//

#import "SuspensionButton.h"


@interface SuspensionButton ()
@property (nonatomic,strong)UIColor * normalColor;
@end

@implementation SuspensionButton

double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}


- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.normalColor = color;
        self.alpha = .7;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        CGFloat min = frame.size.width <= frame.size.height ? frame.size.width : frame.size.height ;
        self.layer.cornerRadius = min / 2.0;
        self.clipsToBounds = YES;
        
        [self creatWithGap:5  andCallBack:nil];
        [self creatWithGap:11 andCallBack:nil];
        [self creatWithGap:17 andCallBack:^(CAShapeLayer *layer) {
            CALayer *lineLayer1 = [CALayer layer];
            lineLayer1.backgroundColor = [[UIColor whiteColor] CGColor];
            lineLayer1.frame = CGRectMake(3,15.5, min - 23 , 2);
            lineLayer1.cornerRadius = 1;
            [layer addSublayer:lineLayer1];
            
            CALayer *lineLayer2 = [CALayer layer];
            lineLayer2.backgroundColor = [[UIColor whiteColor] CGColor];
            lineLayer2.frame = CGRectMake(15.5, 3,2, min - 23 );
            [layer addSublayer:lineLayer2];
            lineLayer2.cornerRadius = 1;
            
            layer.transform = CATransform3DMakeRotation(radians(45), 0, 0, 1);
        }];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)creatWithGap:(CGFloat)gap andCallBack:(void(^)(CAShapeLayer * layer))callBack{
    CGFloat min = self.frame.size.width <= self.frame.size.height ? self.frame.size.width : self.frame.size.height ;
    CAShapeLayer * ringShapeLayer = [[CAShapeLayer alloc] init];
    ringShapeLayer.bounds = CGRectMake(0, 0, min - gap, min -gap);
    ringShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ringShapeLayer.lineWidth = 1.5;
    ringShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    CGRect frame = ringShapeLayer.bounds;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame];
    ringShapeLayer.path = circlePath.CGPath;
    ringShapeLayer.position = CGPointMake(min/2,min/2);
    [self.layer addSublayer:ringShapeLayer];
    if (callBack) {
        callBack(ringShapeLayer);
    }
}


#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p
{
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    if(p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
        self.backgroundColor = self.normalColor;
    }else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = .7;
        self.backgroundColor = [UIColor blackColor];
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = 0;
        if (self.leanType == SuspensionViewLeanTypeHorizontal) {
            minSpace = MIN(left, right);
        }else{
            minSpace = MIN(MIN(MIN(top, left), bottom), right);
        }
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < 15 + ballHeight / 2.0) {
            targetY = 15 + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - 15)) {
            targetY = screenHeight - ballHeight / 2.0 - 15;
        }else{
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(ballHeight / 3, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - ballHeight / 3, targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, ballWidth / 3);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - ballWidth / 3);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        }];
    }else{
        self.alpha = .7;
    }
}




@end
