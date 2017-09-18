//
//  OptionMode.m
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
//        self.icon = dict[@"icon"];
//        self.name = dict[@"name"];
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


@end
