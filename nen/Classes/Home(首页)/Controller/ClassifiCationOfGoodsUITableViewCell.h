//
//  ClassifiCationOfGoodsUITableViewCell.h
//  nen
//
//  Created by nenios101 on 2017/5/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopItemModel,ShopArrayModel;

@interface ClassifiCationOfGoodsUITableViewCell : UITableViewCell

@property(nonatomic,strong) NSMutableArray<ShopArrayModel *> *shopArray;

@property(nonatomic,strong) NSMutableArray <ShopItemModel *>*shopItmeArray;

@property(nonatomic,copy) NSString *name;

@property(nonatomic,assign) NSInteger Id;

@end
