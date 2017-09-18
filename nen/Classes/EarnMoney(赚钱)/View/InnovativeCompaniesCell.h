//
//  InnovativeCompaniesCell.h
//  nen
//
//  Created by nenios101 on 2017/6/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumPostModel;
@interface InnovativeCompaniesCell : UITableViewCell

@property(nonatomic,strong)ForumPostModel *model;

- (CGFloat)rowHeight;

@end
