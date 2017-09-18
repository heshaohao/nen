//
//  CourseViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//课程订单


#import "CourseViewController.h"
#import "CoursesOrderView.h"
@interface CourseViewController ()

@property(nonatomic,strong) CoursesOrderView *courseView;

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    
    [self addCourseView];
}


- (void)addCourseView
{
    _courseView = [[[NSBundle mainBundle] loadNibNamed:@"CoursesOrderView" owner:nil options:nil] lastObject];
    _courseView.frame = self.view.frame;
    
    [self.view addSubview:_courseView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
