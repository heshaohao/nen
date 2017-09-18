//
//  UIColor+ColorChange.h
//  nen
//
//  Created by nenios101 on 2017/5/17.
//  Copyright © 2017年 nen. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
