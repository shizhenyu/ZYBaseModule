//
//  HomeViewController.m
//  基础框架
//
//  Created by youyun on 2017/10/30.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UINavigationControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"这只是个测试");
    
    [self setupNav];
}

/**
 设置导航条
 */
- (void)setupNav
{
    self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

//#pragma mark - 更改statusBar颜色
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
