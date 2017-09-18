//
//  ThereIsNoDataBackgroundView.m
//  nen
//
//  Created by nenios101 on 2017/6/29.
//  Copyright © 2017年 nen. All rights reserved.
//没有网络 背景图片

#import "ThereIsNoDataBackgroundView.h"

@implementation ThereIsNoDataBackgroundView
- (instancetype)initWithThereIsNoDataBackgroundViewImageIcon:(UIImage *)imageIcon ImageX:(CGFloat)imageX  ImageY:(CGFloat)imageY ImageW:(CGFloat)ImageW  imageH:(CGFloat)imageH ShowBottomText:(NSString *)showBottomtext
{
    ThereIsNoDataBackgroundView *backgroundView = [[ThereIsNoDataBackgroundView alloc] init];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:imageIcon];
    CGFloat X;
    CGFloat Y;
    CGFloat W;
    CGFloat H;
    
    if (imageY > 0)
    {
        Y = imageY;
    }else
    {
        Y = 10;
    }
    
    if (ImageW > 0)
    {
        W = ImageW;
    }else
    {
        W = 60;
    }
    
    if (imageH > 0)
    {
        H = imageH;
        
    }else
    {
        H = 60;
    }
    
    if (imageX > 0)
    {
        X = imageX;
        
    }else
    {
        X = 100;
    }
    
    
    img.sh_y = Y;
    img.sh_x = X;
    img.sh_width = W;
    img.sh_height =H;
    
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.frame = CGRectMake(img.sh_x,img.sh_bottom + 10,img.sh_width,35);
    warnLabel.text = showBottomtext;
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = [UIColor whiteColor];
    [backgroundView addSubview:warnLabel];
    
    return backgroundView;
    
}


@end
