//
//  UIView+SHextension.m

//  Created by macbook pro on 16/10/11.
//  Copyright © 2016年 itcsas. All rights reserved.
//

#import "UIView+SHextension.h"

@implementation UIView (SHextension)

- (CGSize)sh_size
{
    return self.frame.size;
}

- (void)setSh_size:(CGSize)sh_size
{
    CGRect frame = self.frame;
    frame.size = sh_size;
    self.frame = frame;
}

- (CGFloat)sh_width
{
    return self.frame.size.width;
}

- (CGFloat)sh_height
{
    return self.frame.size.height;
}

- (void)setSh_width:(CGFloat)sh_width
{
    CGRect frame = self.frame;
    frame.size.width = sh_width;
    self.frame = frame;
}

- (void)setSh_height:(CGFloat)sh_height
{
    CGRect frame = self.frame;
    frame.size.height = sh_height;
    self.frame = frame;
}

- (CGFloat)sh_x
{
    return self.frame.origin.x;
}

- (void)setSh_x:(CGFloat)sh_x
{
    CGRect frame = self.frame;
    frame.origin.x = sh_x;
    self.frame = frame;
}

- (CGFloat)sh_y
{
    return self.frame.origin.y;
}

- (void)setSh_y:(CGFloat)sh_y
{
    CGRect frame = self.frame;
    frame.origin.y = sh_y;
    self.frame = frame;
}

- (CGFloat)sh_centerX
{
    return self.center.x;
}

- (void)setSh_centerX:(CGFloat)sh_centerX
{
    CGPoint center = self.center;
    center.x = sh_centerX;
    self.center = center;
}

- (CGFloat)sh_centerY
{
    return self.center.y;
}

- (void)setSh_centerY:(CGFloat)sh_centerY
{
    CGPoint center = self.center;
    center.y = sh_centerY;
    self.center = center;
}

- (CGFloat)sh_right
{
    //    return self.sh_x + self.sh_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)sh_bottom
{
    //    return self.sh_y + self.sh_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setSh_right:(CGFloat)sh_right
{
    self.sh_x = sh_right - self.sh_width;
}

- (void)setSh_bottom:(CGFloat)sh_bottom
{
    self.sh_y = sh_bottom - self.sh_height;
}

@end
