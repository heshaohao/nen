//
//  NotificationMessageCell.h
//  nen
//
//  Created by nenios101 on 2017/6/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PushMessageModel;
@interface NotificationMessageCell : UITableViewCell
@property(nonatomic,strong)PushMessageModel *model;
@end
