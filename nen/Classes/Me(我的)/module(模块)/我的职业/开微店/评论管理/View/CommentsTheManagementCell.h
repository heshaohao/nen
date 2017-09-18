//
//  CommentsTheManagementCell.h
//  nen
//
//  Created by nenios101 on 2017/7/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopGoodsCommentsModel;

@interface CommentsTheManagementCell : UITableViewCell

@property(nonatomic,strong) ShopGoodsCommentsModel *model;

- (CGFloat)returnCommentsHeight;

@end
