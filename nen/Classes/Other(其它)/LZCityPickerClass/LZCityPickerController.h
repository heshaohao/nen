//
//  LZCityPickerController.h
//  LZCityPicker


#import <UIKit/UIKit.h>

typedef void(^__actionBlock)(NSString *address, NSString *province,NSString *city,NSString *area);

@interface LZCityPickerController : UIViewController

+ (instancetype)showPickerInViewController:(UIViewController *)vc
                               selectBlock:(__actionBlock)block ;
@end
