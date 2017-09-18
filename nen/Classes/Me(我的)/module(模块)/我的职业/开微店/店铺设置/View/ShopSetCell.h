//
//  ShopSetCell.h
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopSetNameModel.h"
@interface ShopSetCell : UITableViewCell

// 开始加载完毕后传值
@property(nonatomic,assign) NSInteger section;
@property(nonatomic,assign) NSInteger line;

@property(nonatomic,strong) ShopSetNameModel *mode;

@property(nonatomic,copy) NSString *titleContent;


// 设置完毕后传值
@property(nonatomic,assign) NSInteger grops;

@property(nonatomic,assign) NSInteger row;

@property(nonatomic,strong) UIImage *rightImage;

@property(nonatomic,strong) NSMutableDictionary *dict;

@end
