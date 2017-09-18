//
//  NSString+JKAlert.h
//  AlertAssemble
//
\
#import <UIKit/UIKit.h>

@interface NSString (JKAlert)

/**
 *  获取单行字符串宽度
 *
 *  @param font 字体
 *
 *
 */
- (CGFloat)widthWithFont:(UIFont *)font;
/**
 *  获取多行字符串高度
 *
 *  @param width 最大宽度
 *  @param font  字体
 *
 *  
 */
- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font;

@end
