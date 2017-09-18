//
//  WinningMessageViewController.h
//  nen
//
//  Created by nenios101 on 2017/4/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinningMessageViewController : UIViewController

// 支付宝翻回信息
@property(nonatomic,copy) NSString *trade_no;

// 支付方式
@property(nonatomic,copy) NSString *pay_type;

@end
