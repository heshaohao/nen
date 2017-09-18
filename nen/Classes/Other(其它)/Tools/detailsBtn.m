//
//  detailsBtn.m
//  nen
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "detailsBtn.h"

@implementation detailsBtn
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.sh_y = 0;
    self.imageView.sh_x = self.sh_width *0.25;
    self.imageView.sh_width = self.sh_width *0.5;
    self.imageView.sh_height = self.sh_height *0.5;
    
    self.titleLabel.sh_x = 0;
    self.titleLabel.sh_y = self.imageView.sh_bottom;
    self.titleLabel.sh_height = self.sh_height *0.5;
    self.titleLabel.sh_width = self.sh_width;
    
}
@end
