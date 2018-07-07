//
//  SLUnilityObject.h
//  沙盒查看工具
//
//  Created by zhengxin  on 2018/4/23.
//  Copyright © 2018 魏家园潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLUnilityObject : NSObject

+ (nullable NSBundle *)resourcesBundle;
+ (nullable UIImage *)imageWithName:(nullable NSString *)name;

+ (nullable NSBundle *)resourcesBundleWithName:(nullable NSString *)bundleName;
+ (nullable UIImage *)imageInBundle:(nullable NSBundle *)bundle withName:(nullable NSString *)name;

@end
