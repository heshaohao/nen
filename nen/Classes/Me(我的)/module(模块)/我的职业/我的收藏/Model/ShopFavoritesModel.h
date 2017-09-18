//
//  ShopFavoritesModel.h
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopFavoritesModel : NSObject

//商家ID
@property(nonatomic,copy) NSString *id;
//商家名
@property(nonatomic,copy) NSString *shop_name;
//商家logo
@property(nonatomic,copy) NSString *img;


+(void)ShopFavoritesModelsuccess:(void(^)(NSMutableArray<ShopFavoritesModel *> *ShopFavoritesArray))successBlock error:(void(^)()) errorBlock;

@end
