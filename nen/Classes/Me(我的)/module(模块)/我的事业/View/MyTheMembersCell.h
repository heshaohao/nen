//
//  MyTheMembersCell.h
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MembersModel;

@interface MyTheMembersCell : UITableViewCell

@property(nonatomic,strong) MembersModel *model;

@property(nonatomic,copy) NSString *index;

@end
