//
//  MarketingModel.h
//  nen
//
//  Created by nenios101 on 2017/3/24.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketingModel : NSObject
// 文章
@property(nonatomic,copy) NSString *details1;
// 图片
@property(nonatomic,copy) NSString *goods_img;
// 视频
@property(nonatomic,copy) NSString *video;

+(void)marketingListGoodsId:(NSString *)goodsId success:(void(^)(MarketingModel* markeModel))successBlock error:(void(^)())errorBlock;
@end
