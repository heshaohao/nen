//
//  InfoturnModel.h
//  nen
//
//  Created by nenios101 on 2017/7/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoturnModel : NSObject

@property (nonatomic,strong) NSNumber *id;

//轮播信息内容
@property (nonatomic,copy) NSString *content;
// 从小到大轮播信息排序
@property (nonatomic,strong) NSNumber *sort;

+ (void)InfoturnModelLocation:(NSNumber *)location Success:(void(^)(NSArray<InfoturnModel *>* InfoturnArray))successBlock error:(void(^)())errorBlock;

@end
