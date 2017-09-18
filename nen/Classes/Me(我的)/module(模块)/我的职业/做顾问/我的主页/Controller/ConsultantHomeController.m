//
//  ConsultantHomeController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ConsultantHomeController.h"
#import "ConsultantHomeView.h"

@interface ConsultantHomeController ()

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ConsultantHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addScrollView];
    
    [self addConsultantHomeview];
}

- (void)addScrollView
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.bounces = NO;
    scrVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    scrVc.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrVc];
    
    
    
}

- (void)addConsultantHomeview
{
    ConsultantHomeView *homeView = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantHomeView" owner:nil options:nil] lastObject];
    homeView.frame = CGRectMake(0, 0,ScreenWidth,1430);
    
    [self.scrollView addSubview:homeView];
    
    self.scrollView.contentSize = CGSizeMake(0,homeView.sh_bottom);
    
    // NSLog(@"%f",homeView.sh_bottom);
    
}

@end
