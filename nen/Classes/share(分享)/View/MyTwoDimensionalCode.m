//
//  MyTwoDimensionalCode.m
//  nen
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTwoDimensionalCode.h"
#import <CoreImage/CoreImage.h>

@interface MyTwoDimensionalCode()
@property (weak, nonatomic) IBOutlet UIImageView *dimensCode;


@end

@implementation MyTwoDimensionalCode

- (void)setMyTheLink:(NSString *)myTheLink
{
    _myTheLink = myTheLink;
    
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [myTheLink dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    self.dimensCode.image = [UIImage imageWithCIImage:image];
}

@end
