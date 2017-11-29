//
//  ViewController.m
//  基础框架
//
//  Created by youyun on 2017/10/30.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import "ViewController.h"
#import "ZyTabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [[ZYGlobalAPP sharedInstance] handleAfterAppBoot:window];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
