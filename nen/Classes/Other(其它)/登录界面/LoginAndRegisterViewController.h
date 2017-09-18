//
//  LoginAndRegisterViewController.h
//  nen
//
//  Created by nenios101 on 2017/3/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginAndRegisterViewController : UIViewController

+ (LoginAndRegisterViewController *)sharedManager;

@property (nonatomic,copy) NSString *flag;

@end
