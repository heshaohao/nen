//
//  DrivingBottomView.m
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DrivingBottomView.h"

@interface  DrivingBottomView()


@end

@implementation DrivingBottomView
- (IBAction)appointmentBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appointment" object:self userInfo:nil];
    
}

@end
