//
//  EducationOptionModel.h
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EducationOptionModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
