//
//  UIViewController+Storyboard.h
//  MiddleLove
//
//  Created by 史振宇 on 2017/6/15.
//  Copyright © 2017年 Youzeshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Storyboard)

/**
 从Storyboard 里加载ViewController
 
 @return UIViewController 实例对象
 */
+ (__kindof UIViewController *)loadViewControllerFromStory;

@end
