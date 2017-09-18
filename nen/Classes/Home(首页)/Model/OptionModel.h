//
//  OptionMode.h
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
