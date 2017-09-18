//
//  CurriculumController.m
//  nen
//
//  Created by apple on 17/3/13.
//  Copyright © 2017年 nen. All rights reserved.
//课程发布

#import "CurriculumController.h"
#import "PublishView.h"
@interface CurriculumController ()

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) PublishView *publsiView;

@end

@implementation CurriculumController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addScrollView];
   
    [self addPublishView];
    
    [self addBottomView];
    
}

- (void)addScrollView
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 50);
    scrVc.backgroundColor = [UIColor greenColor];
   // scrVc.backgroundColor = [UIColor orangeColor];
    scrVc.bounces = NO;
    [self.view addSubview:scrVc];
    
}

- (void)addPublishView
{
    _publsiView = [[[NSBundle mainBundle] loadNibNamed:@"PublishView" owner:nil options:nil] firstObject];
    _publsiView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    self.scrollView.contentSize = CGSizeMake(0, _publsiView.sh_bottom);
    
    [self.scrollView addSubview:_publsiView];
    
}

- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    bottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
    [self.view addSubview:bottomView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth *0.05,10,ScreenWidth *0.9,30);
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"课程发布" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [bottomView addSubview:btn];
    
}


@end
