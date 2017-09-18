//
//  CZCountDownView.h
//  countDownDemo


#import <UIKit/UIKit.h>

typedef void(^TimerStopBlock)();

@interface FLCountDownView : UIView
// 时间戳
@property (nonatomic,assign)NSInteger timestamp;
// 背景
@property (nonatomic,copy)NSString *backgroundImageName;
// 时间停止后回调
@property (nonatomic,copy)TimerStopBlock timerStopBlock;
/**
 *  创建单例对象
 */
+ (instancetype)fl_shareCountDown;// 工程中使用的倒计时是唯一的

/**
 *  创建非单例对象
 */
+ (instancetype)fl_countDown; // 工程中倒计时不是唯一的

@end
