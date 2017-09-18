//
//  ShareCollectionViewCell.m
//  nen
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@interface ShareCollectionViewCell ()

@property(nonatomic,strong) UIImageView *iconImage;

@end

@implementation ShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addChildControll];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.iconImage.image = image;
    
}



- (void)addChildControll
{

    UIImageView *image = [[UIImageView alloc] init];
    self.iconImage = image;
    image.frame = CGRectMake(0, 0,self.contentView.sh_width, self.contentView.sh_height);
    image.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:image];
    
}






@end
