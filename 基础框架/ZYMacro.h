//
//  ZYMacro.h
//  基础框架
//
//  Created by youyun on 2017/10/30.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#ifndef ZYMacro_h
#define ZYMacro_h

/** 屏幕宽高 **/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(width) width * kScreenWidth / 375.0
#define kHeight(height) height * kScreenHeight / 667.0

// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
// 是否为iPhone X
#define IsIPhone_X  kStatusBarHeight > 20.f ? YES : NO
// tabbar高度
#define kTabBarHeight    (IsIPhone_X ? 83.f : 49.f) // 适配iPhone x 底栏高度
// 导航栏高度
#define kNavigationBarHeight (IsIPhone_X ? 88.f : 64.f)
// 全屏view的高度
#define kContentViewHeight (ScreenHeight - kStatusBarHeight - 44.0f -  kTabBarHeight)

/** 字体设置 **/
#define kFont(size) [UIFont systemFontOfSize:size]
#define kBFont(size) [UIFont boldSystemFontOfSize:size]

#define kImage(imageName) [UIImage imageNamed:imageName]

/** 第一个参数是当下的控制器，第二个参数表示scrollview或子类 **/
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

/** 日志打印 **/
#define LogFunc Log(@"%s", __func__)

#if DEBUG
#define Log(FORMAT, ...) fprintf(stderr,"\nFunction:%s line:%d \n content:%s \n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define Log(FORMAT, ...) nil
#endif

#define kWeakSelf __weak typeof(self)weakSelf = self;

/** 弱引用 **/
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

/** 强引用 **/
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* ZYMacro_h */
