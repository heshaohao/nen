//
//  ShopArrayModel.h
//  nen
//
//  Created by nenios101 on 2017/4/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopItemModel.h"

@interface ShopArrayModel : NSObject

@property(nonatomic,copy) NSString *class_name;

@property(nonatomic,copy) NSString * id;

@property(nonatomic,strong) NSMutableArray<ShopItemModel *> *shopArr;

@end
