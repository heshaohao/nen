//
//  ReleaseGoodsModel.h
//  nen
//
//  Created by apple on 17/7/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseGoodsModel : NSObject

//分类id，查找顶级分类为0
@property(nonatomic,copy)NSString *id;
//分类名称
@property(nonatomic,copy)NSString *category_name;

+ (void)releaseGoodsModelParent_Id:(NSString * )parent_id success:(void(^)(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray))successBlock error:(void(^)()) errorBlock;

@end
