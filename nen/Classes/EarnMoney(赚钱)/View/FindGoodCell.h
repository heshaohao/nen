//
//  FindGoodCell.h
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//

@class ForumPostModel;
#import <UIKit/UIKit.h>

@interface FindGoodCell : UITableViewCell

@property(nonatomic,strong) ForumPostModel *model;

@property(nonatomic,assign) NSInteger  group;

@property(nonatomic,assign) NSInteger  row;

- (CGFloat)rowHeight;

@end
