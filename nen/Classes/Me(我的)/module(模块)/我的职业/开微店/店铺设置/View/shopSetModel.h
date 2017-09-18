//
//  shopSetModel.h
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface shopSetModel : NSObject

@property(nonatomic,strong) NSArray *nameArray;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)shopSetGroupWithDict:(NSDictionary *)dict;

@end
