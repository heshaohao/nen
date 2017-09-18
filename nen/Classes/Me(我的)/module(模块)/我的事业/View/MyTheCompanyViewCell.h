//
//  MyTheCompanyViewCell.h
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyemployeecountModel;

@interface MyTheCompanyViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary  *dataDict;

@property(nonatomic,strong) MyemployeecountModel *model;

@property(nonatomic,copy) NSString *index;
  

@end
