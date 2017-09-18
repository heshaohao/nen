//
//  GoodsClassPickerModel.h
//  nen
//
//  Created by apple on 17/6/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsClassPickerModel : NSObject
@property (nonatomic, copy) NSString* name;

@end


@interface SHProvince : GoodsClassPickerModel

@property (nonatomic, strong) NSArray *cities;
- (void)configWithDic:(NSDictionary *)dic;
@end

@interface SHCity : GoodsClassPickerModel

@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSArray *areas;
- (void)configWithArr:(NSArray *)arr;
@end

@interface SHArea : GoodsClassPickerModel

//@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@end
