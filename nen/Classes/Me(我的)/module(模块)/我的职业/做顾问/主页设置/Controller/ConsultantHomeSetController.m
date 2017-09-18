//
//  ConsultantHomeSetController.m
//  nen
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ConsultantHomeSetController.h"
#import "ConsultantHomeSetView.h"
@interface ConsultantHomeSetController ()

@end

@implementation ConsultantHomeSetController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addConsultantHome];
    
}

- (void)addConsultantHome
{
    ConsultantHomeSetView *setView = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantHomeSetView" owner:nil options:nil] lastObject];
    setView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight);
    [self.view addSubview:setView];
}

@end
