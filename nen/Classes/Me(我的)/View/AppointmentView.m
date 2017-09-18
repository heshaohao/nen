//
//  AppointmentView.m
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AppointmentView.h"

@interface AppointmentView()
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *drivingLabel;

@end

@implementation AppointmentView


- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.buyLabel.layer.cornerRadius = 7.5;
    self.buyLabel.clipsToBounds = YES;
    self.buyLabel.layer.borderWidth = 1.0f;
    self.buyLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyLabel.text = [NSString stringWithFormat:@"%@",dict[@"shoporder"]];
    
    
    NSInteger driveer = [dict[@"driverorder"] integerValue];
    
    if (driveer > 0)
    {
        self.drivingLabel.layer.cornerRadius = 7.5;
        self.drivingLabel.clipsToBounds = YES;
        self.drivingLabel.layer.borderWidth = 1.0f;
        self.drivingLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.drivingLabel.text = [NSString stringWithFormat:@"%@",dict[@"driverorder"]];
        
    }
}

- (IBAction)pushAllOrder:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOrder" object:self];
}
- (IBAction)moreBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOrder" object:self];
}

@end
