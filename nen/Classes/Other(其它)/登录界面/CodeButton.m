//
//  CodeButton.m
//  nen
//
//  Created by nenios101 on 2017/3/22.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CodeButton.h"

@interface CodeButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation CodeButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;

   [self setTitleColor:[UIColor colorWithRed:128 green:177 blue:34 alpha:1] forState:UIControlStateNormal];
  self.layer.borderColor = [UIColor colorWithRed:128 green:177 blue:34 alpha:1].CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    self.count = timeCount;
    self.enabled = NO;
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.count != 1) {
        self.count -= 1;
        self.enabled = NO;
        [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", (long)self.count] forState:UIControlStateNormal];
        //      [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.count = 60;
        [self.timer invalidate];
    }
}

@end
