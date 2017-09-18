//
//  ShopArrayModel.m
//  nen
//
//  Created by nenios101 on 2017/4/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopArrayModel.h"
#import "ShopItemModel.h"

@implementation ShopArrayModel



- (void)setShopArr:(NSMutableArray<ShopItemModel *> *)shopArr
{
    _shopArr = shopArr;
    
    _shopArr = [ShopItemModel mj_objectArrayWithKeyValuesArray:shopArr];
}


- (instancetype)init{
    
    if (self=[super init]) {
        
        [ShopArrayModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"shopArr" : @"self"
                     
                     };
        }];
        
    }
    return self;
}

@end
