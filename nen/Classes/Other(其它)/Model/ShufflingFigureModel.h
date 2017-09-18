//
//  ShufflingFigureModel.h
//  nen
//
//  Created by nenios101 on 2017/3/20.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShufflingFigureModel : NSObject

@property(nonatomic,strong) NSNumber* id;

@property(nonatomic,copy) NSString *img_url;

@property(nonatomic,strong) NSNumber *sort;

@property(nonatomic,strong) NSNumber *category_id;


+(void)shufflingFigureLocation:(NSString *)location Success:(void(^)(NSArray<ShufflingFigureModel *>* shufflingFigure))successBlock error:(void(^)())errorBlock;

@end
