//
//  MyTheCommentCell.h
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

@class PostCommentsModel;
#import <Foundation/Foundation.h>

@interface MyTheCommentCell : UITableViewCell

@property(nonatomic,strong) PostCommentsModel *model;


- (CGFloat)rowHeight;

@end
