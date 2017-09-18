//
//  ShoppingCarCell.h
//  GoodsShoppingCar
//
//  Created by nenios101 on 2017/3/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCarModel;
typedef void(^LZNumberChangedBlock)(NSInteger number);
typedef void(^LZCellSelectedBlock)(BOOL select);
@interface ShoppingCarCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger lzNumber;
@property (assign,nonatomic)BOOL lzSelected;

@property(nonatomic,strong) ShoppingCarModel *model;

- (void)numberAddWithBlock:(LZNumberChangedBlock)block;
- (void)numberCutWithBlock:(LZNumberChangedBlock)block;
- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block;
@end
