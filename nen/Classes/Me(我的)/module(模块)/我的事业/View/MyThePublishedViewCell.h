//
//  MyThePublishedViewCell.h
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//
@class MyThePostModel;
#import <UIKit/UIKit.h>

@interface MyThePublishedViewCell : UITableViewCell

@property(nonatomic,strong) MyThePostModel *model;


- (CGFloat)rowHeight;

@end
