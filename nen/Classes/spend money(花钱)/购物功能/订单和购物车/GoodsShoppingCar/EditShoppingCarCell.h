//
//  EditShoppingCarCell.h
//  nen
//
//  Created by apple on 17/4/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class editShoppingCarModel;
typedef void(^LZNumberChangedBlock)(NSInteger number);
typedef void(^LZCellSelectedBlock)(BOOL select);
@interface EditShoppingCarCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger lzNumber;
@property (assign,nonatomic)BOOL lzSelected;

@property(nonatomic,strong) editShoppingCarModel *model;

- (void)numberAddWithBlock:(LZNumberChangedBlock)block;
- (void)numberCutWithBlock:(LZNumberChangedBlock)block;
- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block;
@end
