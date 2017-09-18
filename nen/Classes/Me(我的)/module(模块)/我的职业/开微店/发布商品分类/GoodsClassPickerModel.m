//
//  GoodsClassPickerModel.m
//  nen
//
//  Created by apple on 17/6/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsClassPickerModel.h"

@implementation GoodsClassPickerModel
- (void)configWithDic:(NSDictionary *)dic {
    
}
@end

@implementation SHProvince

- (void)configWithDic:(NSDictionary *)dic {
    
    NSArray *citys = [dic allKeys];
    
    NSMutableArray *tmpCitys = [NSMutableArray arrayWithCapacity:citys.count];
    for (NSString *tmp in citys) {
        
        SHCity *city = [[SHCity alloc]init];
        city.name = tmp;
        city.province = self.name;
        NSArray *area = [dic objectForKey:tmp];
        
        [city configWithArr:area];
        [tmpCitys addObject:city];
        
    }
    
    self.cities = [tmpCitys copy];
}
@end

@implementation SHCity

- (void)configWithArr:(NSArray *)arr {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSString *tmp in arr) {
        
        SHArea *area = [[SHArea alloc]init];
        area.name = tmp;
        area.province = self.province;
        area.city = self.name;
        [array addObject:area];
    }
    
    self.areas = [array copy];
}
@end

@implementation SHArea


@end

