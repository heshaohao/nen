//
//  DeliciousFoodCell.m
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
// 免费吃推荐

#import "DeliciousFoodCell.h"

@interface DeliciousFoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImage;

@end

@implementation DeliciousFoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setFoodImageName:(NSString *)foodImageName
{
    _foodImageName = foodImageName;
    self.foodImage.image = [UIImage imageNamed:foodImageName];
}



@end
