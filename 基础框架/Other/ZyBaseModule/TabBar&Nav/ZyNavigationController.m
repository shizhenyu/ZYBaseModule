//
//  ZyNavigationController.m
//  MiddleLove
//
//  Created by 史振宇 on 2017/6/15.
//  Copyright © 2017年 Youzeshi. All rights reserved.
//

#import "ZyNavigationController.h"

@interface ZyNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZyNavigationController


+ (void)load {
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor zy_colorWithHex:0xf2f7fa]] forBarMetrics:UIBarMetricsDefault];
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zy_colorWithHex:0x333434]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]} forState:UIControlStateNormal];
    
    navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 全屏滑动返回
    self.interactivePopGestureRecognizer.enabled = YES;
    
    // 将返回按钮替换为我们的自定义按钮，并使滑动返回重新生效
    self.interactivePopGestureRecognizer.delegate = (id)self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotate {
    
    if (self.visibleViewController) {
        
        return self.visibleViewController.shouldAutorotate;
    }
    
    return YES;
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([self.visibleViewController isKindOfClass:[UIAlertController class]]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    if (self.visibleViewController) {
        
        return self.visibleViewController.supportedInterfaceOrientations;
        
    }
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.visibleViewController) {
        return self.visibleViewController.preferredStatusBarStyle;
    }
    
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return self.visibleViewController?self.visibleViewController.preferredInterfaceOrientationForPresentation:UIInterfaceOrientationPortrait;
}


//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
