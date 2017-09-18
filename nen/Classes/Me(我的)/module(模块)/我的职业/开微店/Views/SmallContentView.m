//
//  SmallContentView.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SmallContentView.h"

@interface SmallContentView()

@end

@implementation SmallContentView

- (IBAction)GoodsBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shop" object:self];

}
- (IBAction)orderBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"order" object:self];
}
- (IBAction)messageBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:self];
}
- (IBAction)Income:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"income" object:self];
}
- (IBAction)shopBtn:(UIButton *)sender
{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"commentsManagement" object:self];
    
    
}
- (IBAction)decorateBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"decorate" object:self];
}

@end
