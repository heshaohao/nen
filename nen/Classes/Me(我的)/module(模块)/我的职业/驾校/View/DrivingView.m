//
//  DrivingView.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DrivingView.h"

@implementation DrivingView

- (IBAction)icomeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"icome" object:self];
}
- (IBAction)drivingBtn:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dri" object:self];
}
- (IBAction)courseBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"course" object:self];
}
- (IBAction)orderBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"order" object:self];
}
- (IBAction)wordView:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"word" object:self];
}


@end
