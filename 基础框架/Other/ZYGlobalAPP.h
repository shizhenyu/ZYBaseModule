//
//  ZYGlobalAPP.h
//  基础框架
//
//  Created by youyun on 2017/11/29.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

/**
 *切换视图控制器
 **/

#import <Foundation/Foundation.h>

@interface ZYGlobalAPP : NSObject

@property(nonatomic, strong) UIWindow *window;

/**
 * 单例模式创建
 */
+ (instancetype)sharedInstance;

/**
 * 程序启动时的入口
 */
- (void)handleAfterAppBoot:(UIWindow *)swindow;

/**
 * 主视图为登录视图
 */
- (void)gotoSiginViewController;

/**
 * 主视图为tabbar视图
 */
- (void)gotoTabbarViewController;

@end
