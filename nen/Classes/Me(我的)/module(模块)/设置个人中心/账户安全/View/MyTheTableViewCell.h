//
//  MyTheTableViewCell.h
//  nen
//
//  Created by nenios101 on 2017/4/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SetModel;

@interface MyTheTableViewCell : UITableViewCell

@property(nonatomic,strong) SetModel *model;

@property(nonatomic,copy) NSString *rightTtitleStr;

@property(nonatomic,assign) NSInteger section;

@property(nonatomic,assign) NSInteger line;

@end
