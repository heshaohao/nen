//
//  MessageViewCell.h
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PushMessageModel;
@interface NewsCell : UITableViewCell

@property(nonatomic,strong)PushMessageModel *model;
@end
