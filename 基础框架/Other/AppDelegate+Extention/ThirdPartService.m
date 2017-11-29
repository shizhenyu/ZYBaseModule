//
//  ThirdPartService.m
//  基础框架
//
//  Created by youyun on 2017/10/31.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import "ThirdPartService.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation ThirdPartService

+ (void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [[self class] setKeyBoard];
        
        [[self class] testReachableStatus];
    });
}

#pragma mark - 键盘回收相关
+ (void)setKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 检测网络相关
+ (void)testReachableStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.设置监听
    //网络状态
    //显然是枚举值
    // -设置网络监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                Log(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                Log(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                Log(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                Log(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    //3.开始监听
    [manager startMonitoring];
}

@end
