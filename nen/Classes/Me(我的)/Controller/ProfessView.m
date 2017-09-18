//
//  ProfessView.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ProfessView.h"

@interface ProfessView()

@end

@implementation ProfessView
// 开店
- (IBAction)shopBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weidian" object:self];
}


// 驾校
- (IBAction)drivingBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driving" object:self];
}
// 当顾问
- (IBAction)consultantBtn:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doConsultant" object:self];
}
// 当老师
- (IBAction)teacherBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doTeacher" object:self];
}
// 当师傅
- (IBAction)masterBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doMaster" object:self];
}

@end
