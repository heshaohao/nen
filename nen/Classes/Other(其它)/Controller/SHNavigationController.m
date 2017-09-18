//
//  SHNavigationController.m
//  百思不得姐demo
//
//  Created by macbook pro on 16/10/11.
//  Copyright © 2016年 itcsas. All rights reserved.
//

#import "SHNavigationController.h"
#import "SearGoodsViewController.h"

@interface SHNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation SHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.interactivePopGestureRecognizer.delegate = self;
   //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];    
}

/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count >= 1)
    { // 左上角
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        // 隐藏底部的工具条
         viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//       if (self.childViewControllers.count == 1) { // 导航控制器中只有1个子控制器
//            return NO;
//        }
//        return YES;
    
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}


@end
