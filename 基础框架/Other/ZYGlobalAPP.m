//
//  ZYGlobalAPP.m
//  基础框架
//
//  Created by youyun on 2017/11/29.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import "ZYGlobalAPP.h"
#import "ZyTabBarController.h"

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application" //上次程序运行的版本

@implementation ZYGlobalAPP
@synthesize window;

/**
 * 单例模式创建
 */
+ (instancetype)sharedInstance
{
    static ZYGlobalAPP *shareapp = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareapp = [[ZYGlobalAPP alloc]init];
    });
    
    return shareapp;
}

/**
 * 程序启动时的入口
 */
- (void)handleAfterAppBoot:(UIWindow *)swindow
{
    window = swindow;
 
    // 这里可以写一些监听全局消息的操作 (比如监听极光推送的自定义消息，账号下线通知)
    
    // 切换window的根视图界面
    [self buildRootView];
}

/**
 * 切换window的根视图界面
 */
-(void)buildRootView
{
    // 在这里写切换界面的逻辑

    BOOL userIsLogin = YES;
    
    if ([self isFirstLoad]) {
        
        [self gotoNewFeatureViewController];
        
    }else {
        if (userIsLogin) {
            
            [self gotoTabbarViewController];
            
        }else {
            
            [self gotoSiginViewController];
            
        }
    }
}

/**
 * 登录视图
 */
- (void)gotoSiginViewController
{
    
}

/**
 * tabbar视图
 */
- (void)gotoTabbarViewController
{
    UIViewController * vc = window.rootViewController;
    
    [vc removeFromParentViewController];
    
    ZyTabBarController *tabBarVC = [ZyTabBarController new];
    
    [tabBarVC configTabBarWithPlist:@"TabBarConfig"];
    
    window.rootViewController = tabBarVC;
}

/**
 * 新面孔视图
 */
- (void)gotoNewFeatureViewController
{
    UIViewController * vc = window.rootViewController;
    
    [vc removeFromParentViewController];
    
    ZyTabBarController *tabBarVC = [ZyTabBarController new];
    
    [tabBarVC configTabBarWithPlist:@"TabBarConfig"];
    
    window.rootViewController = tabBarVC;
}


/**
 * 判断应用是否是第一次启动
 */
- (BOOL)isFirstLoad
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

@end
