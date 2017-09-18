//
//  CommentsTableViewCell.h
//  nen
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary  *replyDataDict;

- (CGFloat)returnHight;

@end
