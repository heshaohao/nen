//
//  UIButton+CenterTitleAndImage.h
//  nen
//
//  Created by nenios101 on 2017/5/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CenterTitleAndImage)

/**
 *  上下居中，图片在上，文字在下
 */
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
/**
 *  上下居中，图片在上，文字在下  默认6.0
 */
- (void)verticalCenterImageAndTitle;

/**
 *  左右居中，文字在左，图片在右
 */
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
/**
 *  默认6.0
 */
- (void)horizontalCenterTitleAndImage;


/**
 *  左右居中，图片在左，文字在右
 */
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
/**
 *  左右居中，图片在左，文字在右 默认6.0
 */
- (void)horizontalCenterImageAndTitle;


/**
 *  文字居中，图片在左边
 */
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
/**
 *  文字居中，图片在左边 默认6.0
 */
- (void)horizontalCenterTitleAndImageLeft;

/**
 *  文字居中，图片在右边
 */
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
/**
 *  文字居中，图片在右边 默认6.0
 */
- (void)horizontalCenterTitleAndImageRight;
@end
