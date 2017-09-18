//
//  myCareerViewController.h
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCareerViewController : UIViewController

@property(nonatomic,copy) NSString *page;
    
// 公司类型
@property(nonatomic,copy) NSString *type;

// 成员 
@property (nonatomic,copy) NSString *membersType;
@end
